module IncomeTaxCalculations

import Dates
import Dates: Date, now, TimeType, Year

import Model_Household: Person
import STBParameters: IncomeTaxSys
import TBComponents: TaxResult, calctaxdue, RateBands, delete_thresholds_up_to, *
import Parameters: @with_kw

using Definitions

export calc_income_tax, old_enough_for_mca, apply_allowance, ITResult

@with_kw mutable struct ITResult
    total :: Real = 0.0
    non_savings :: Real = 0.0
    non_savings_band :: Integer = 0
    savings :: Real = 0.0
    savings_band :: Integer = 0
    dividends :: Real = 0.0
    dividends_band :: Integer = 0
    unused_allowance :: Real = 0.0
end

## FIXME all these constants should ultimately be parameters
const MCA_DATE = Date(1935,4,6) # fixme make this a parameter

const SAVINGS_INCOME = Incomes_Dict(
    bank_interest => 1.0,
    bonds_and_gilts => 1.0,
    other_investment_income => 1.0
)

const DIVIDEND_INCOME = Incomes_Dict(
    stocks_shares => 1.0
)
const Exempt_Income = Incomes_Dict(
    individual_savings_account=>1.0,
    local_taxes=>1.0,
    free_school_meals => 1.0,
    dlaself_care => 1.0,
    dlamobility => 1.0,
    child_benefit => 1.0,
    pension_credit => 1.0,
    bereavement_allowance_or_widowed_parents_allowance_or_bereavement=> 1.0,
    armed_forces_compensation_scheme => 1.0, # FIXME not in my list check this
    war_widows_or_widowers_pension => 1.0,
    severe_disability_allowance => 1.0,
    attendence_allowance => 1.0,
    industrial_injury_disablement_benefit => 1.0,
    employment_and_support_allowance => 1.0,
    incapacity_benefit => 1.0,## taxable after 29 weeks,
    income_support => 1.0,
    maternity_allowance => 1.0,
    maternity_grant_from_social_fund => 1.0,
    funeral_grant_from_social_fund => 1.0,
    guardians_allowance => 1.0,
    winter_fuel_payments => 1.0,
    dwp_third_party_payments_is_or_pc => 1.0,
    dwp_third_party_payments_jsa_or_esa => 1.0,
    extended_hb => 1.0,
    working_tax_credit => 1.0,
    child_tax_credit => 1.0,
    working_tax_credit_lump_sum => 1.0,
    child_tax_credit_lump_sum => 1.0,
    housing_benefit => 1.0,
    universal_credit => 1.0,
    personal_independence_payment_daily_living => 1.0,
    personal_independence_payment_mobility => 1.0 )

function make_all_taxable()::Incomes_Dict
    eis = union(Set( keys( Exempt_Income )), Definitions.Expenses )
    all_t = Incomes_Dict()
    for i in instances(Incomes_Type)
        if ! (i ∈ eis )
            all_t[i]=1.0
        end
    end
    all_t
end

function make_non_savings()::Incomes_Dict
    excl = union(Set(keys(DIVIDEND_INCOME)), Set( keys(SAVINGS_INCOME)))
    nsi = make_all_taxable()
    for i in excl
        delete!( nsi, i )
    end
    nsi
end

const NON_SAVINGS_INCOME = make_non_savings()
const ALL_TAXABLE = make_all_taxable()

IT_Result = TaxResult{Real}

"""
Very rough approximation to MCA age - ignores all months since we don't have that in a typical dataset
TODO maybe overload this with age as a Date?
"""
function old_enough_for_mca(
    age            :: Integer,
    model_run_date :: TimeType = now() ) :: Bool
    (model_run_date - Year(age)) < MCA_DATE
end

function apply_allowance( allowance::Real, income::Real )::Tuple
    r = max( 0.0, income - allowance )
    allowance = max(0.0, allowance-income)
    allowance,r
end

"""

Complete(??) income tax calculation, based on the Scottish/UK 2019 system.
Mostly taken from Melville (2019) chs 2-4.

FIXME this is too long and needs broken up.

problems:

1. we do this in strict non-savings, savings, dividends order; see 2(11) for examples where it's now advantageous to use a different order
2.

returns a single total tax liabilty, plus multiple intermediate numbers
in the `intermediate` dict

"""
function calc_income_tax(
    pers   :: Person,
    sys    :: IncomeTaxSys,
    intermediate :: Dict,
    spouse_transfer :: Real = 0.0 ) :: ITResult
    itres :: ITResult = ITResult()
    total_income = ALL_TAXABLE*pers.income;
    non_savings = NON_SAVINGS_INCOME*pers.income;
    savings = SAVINGS_INCOME*pers.income;
    dividends = DIVIDEND_INCOME*pers.income;
    allowance = sys.personal_allowance+spouse_transfer
    # allowance reductions goes here

    non_dividends = non_savings + savings

    adjusted_net_income = total_income
    # ...

    non_savings_tax = TaxResult(0.0, 0)
    savings_tax = TaxResult(0.0, 0)
    dividend_tax = TaxResult(0.0, 0)

    if adjusted_net_income > sys.personal_allowance_income_limit
        allowance =
            max(0.0,
                allowance -
                    sys.personal_allowance_withdrawal_rate*(
                        adjusted_net_income - sys.personal_allowance_income_limit ))
    end
    taxable_income = max(0.0, adjusted_net_income-allowance)
    intermediate["allowance"]=allowance
    intermediate["total_income"]=total_income
    intermediate["adjusted_net_income"]=adjusted_net_income
    intermediate["taxable_income"]=taxable_income
    intermediate["savings"]=savings
    intermediate["non_savings"]=non_savings
    intermediate["dividends"]=dividends

    savings_thresholds = deepcopy( sys.savings_thresholds )
    savings_rates = deepcopy( sys.savings_rates )
    # FIXME model all this with parameters
    toprate = size( savings_thresholds )[1]
    if taxable_income > 0
        allowance,non_savings_taxable = apply_allowance( allowance, non_savings )
        non_savings_tax = calctaxdue(
            taxable=non_savings_taxable,
            rates=sys.non_savings_rates,
            thresholds=sys.non_savings_thresholds )

        # horrific savings calculation see Melville Ch2 "Savings Income" & examples 2-3
        # FIXME Move to separate function
        # delete the starting bands up to non_savings taxabke icome
        savings_rates, savings_thresholds = delete_thresholds_up_to(
            rates=savings_rates,
            thresholds=savings_thresholds,
            upto=non_savings_taxable );
        if sys.personal_savings_allowance > 0
            psa = sys.personal_savings_allowance
            # println( "taxable income $taxable_income sys.savings_thresholds[2] $(sys.savings_thresholds[2])")
            if taxable_income > sys.savings_thresholds[toprate]
                psa = 0.0
            elseif taxable_income > sys.savings_thresholds[2] # above the basic rate
                psa *= 0.5 # FIXME parameterise this
            end
            if psa > 0.0 ## if we haven't deleted the zero band already, just widen it
                savings_thresholds .+= psa;
                if savings_rates[1] > 0.0
                    # .. insert a  new zero band if there isn't one
                    savings_thresholds = vcat([psa], savings_thresholds )
                    savings_rates = vcat([0.0], savings_rates )
                end
            end # add personal_savings_allowance as a band
            intermediate["personal_savings_allowance"] = psa
        end # we have a personal_savings_allowance
        intermediate["savings_rates"] = savings_rates
        intermediate["savings_thresholds"] = savings_thresholds
        allowance,savings_taxable = apply_allowance( allowance, savings )
        savings_tax = calctaxdue(
            taxable=savings_taxable,
            rates=savings_rates,
            thresholds=savings_thresholds )

        # Dividends
        # see around example 8-9 ch2
        allowance,dividends_taxable =
            apply_allowance( allowance, dividends )
        dividend_rates=deepcopy(sys.dividend_rates)
        dividend_thresholds=deepcopy(sys.dividend_thresholds )
        # always preserve any bottom zero rate
        add_back_zero_band = false
        zero_band = 0.0
        used_thresholds = non_savings_taxable+savings_taxable
        copy_start = 1
        # handle the zero rate
        if dividend_rates[1] == 0.0
            add_back_zero_band = true
            zero_band = dividend_thresholds[1]
            used_thresholds += min( zero_band, dividends_taxable )
            copy_start = 2
        end
        dividend_rates, dividend_thresholds =
            delete_thresholds_up_to(
                rates=dividend_rates[copy_start:end],
                thresholds=dividend_thresholds[copy_start:end],
                upto=used_thresholds );
        if add_back_zero_band
            dividend_rates = vcat( [0.0], dividend_rates )
            dividend_thresholds .+= zero_band # push all up
            dividend_thresholds = vcat( zero_band, dividend_thresholds )
        end
        intermediate["dividend_rates"]=dividend_rates
        intermediate["dividend_thresholds"]=dividend_thresholds
        intermediate["add_back_zero_band"]=add_back_zero_band
        intermediate["dividends_taxable"]=dividends_taxable

        dividend_tax = calctaxdue(
            taxable=dividends_taxable,
            rates=dividend_rates,
            thresholds=dividend_thresholds )
    end
    intermediate["non_savings_tax"]=non_savings_tax.due
    intermediate["savings_tax"]=savings_tax.due
    intermediate["dividend_tax"]=dividend_tax.due


    itres.total = non_savings_tax.due+savings_tax.due+dividend_tax.due
    itres.non_savings = non_savings_tax.due
    itres.non_savings_band = non_savings_tax.end_band
    itres.savings = savings_tax.due
    itres.savings_band = savings_tax.end_band
    itres.dividends = dividend_tax.due
    itres.dividends_band = dividend_tax.end_band
    itres.unused_allowance = allowance
    itres

end


end # module
