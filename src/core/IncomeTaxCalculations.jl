module IncomeTaxCalculations

import Dates
import Dates: Date, now, TimeType, Year

import Model_Household: Person
import STBParameters: IncomeTaxSys
import TBComponents: TaxResult, calctaxdue, RateBands, *

using Definitions

export calc_income_tax, old_enough_for_mca, apply_allowance

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
If rates are
    0.1,0.2,0.4
and bands:
    100,200
then
    delete_bands_up_to( rates=rates, bands=bands, 101 )
gives
    rates = 0.2,0.4 bands = 99,200
"""
function delete_bands_up_to( ; rates :: RateBands, bands :: RateBands, upto :: Real )
  total = 0.0
  last_total = 0.0
  firstband = 0.0
  num_bands = size( bands )[1]
  deleteband = -1
  n = size( bands )[1]
  for i in 1:n
    total += bands[i]
    if total > upto
      deleteband = i
      firstband = upto - last_total
      break
    elseif i == n
      deleteband = -1
    end
    last_total = total
  end # 1:n
  if deleteband > 0
    rates = rates[deleteband:end]
    bands = bands[deleteband:end]
    bands[1] -= firstband
  elseif deleteband == -1
    rates = rates[end:end]
    bands :: RateBands = [ Inf ]
  end
  rates, bands
end

function calc_income_tax(
    pers   :: Person,
    sys    :: IncomeTaxSys,
    intermediate :: Dict,
    spouse :: Union{Person,Nothing} = nothing ) :: Real

    total_income = ALL_TAXABLE*pers.income;
    non_savings = NON_SAVINGS_INCOME*pers.income;
    savings = SAVINGS_INCOME*pers.income;
    dividend = DIVIDEND_INCOME*pers.income;
    allowance = sys.personal_allowance
    # allowance reductions goes here

    taxable_income = max(0.0, total_income-allowance)
    non_savings_tax = 0.0
    savings_tax = 0.0
    dividend_tax = 0.0
    if taxable_income > sys.personal_allowance_income_limit
        allowance =
            max(0.0,
                allowance -
                    sys.personal_allowance_withdrawal_rate*(
                        taxable_income - sys.personal_allowance_income_limit ))
        println( "made allowance as $allowance")
    end
    savings_bands = deepcopy( sys.savings_bands )
    savings_rates = deepcopy( sys.savings_rates )
    # FIXME model all this with parameters
    toprate = size( savings_bands )[1]
    if taxable_income > 0
        # horrific savings calculation see Melville Ch2 "Savings Income" & examples 2-3
        allowance,non_savings_taxable = apply_allowance( allowance, non_savings )
        non_savings_tax = calctaxdue(
            taxable=non_savings_taxable,
            rates=sys.non_savings_rates,
            bands=sys.non_savings_bands ).due

            # FIXME Move to separate function
            # delete the starting bands up to non_savings taxabke icome
            savings_rates, savings_bands = delete_bands_up_to(
                rates=savings_rates, bands=savings_bands, upto=non_savings_taxable );
            if sys.personal_savings_allowance > 0
                psa = sys.personal_savings_allowance
                println( "taxable income $taxable_income sys.savings_bands[2] $(sys.savings_bands[2])")
                if taxable_income > sys.savings_bands[toprate]
                    psa = 0.0
                elseif taxable_income > sys.savings_bands[2] # above the basic rate
                    psa *= 0.5 # FIXME parameterise this
                end
                if psa > 0 ## if we haven't deleted the zero band already, just widen it
                    if savings_rates[1] == 0.0
                        savings_bands[1] += psa;
                    else ## otherwise, insert a  new one.
                        savings_bands = vcat([psa], savings_bands )
                        savings_rates = vcat([0.0], savings_rates )
                    end
                end # add personal_savings_allowance as a band
                intermediate["personal_savings_allowance"] = psa
                intermediate["savings_rates"] = savings_rates
                intermediate["savings_bands"] = savings_bands
            end # we have a personal_savings_allowance
        allowance,savings_taxable = apply_allowance( allowance, savings )
        savings_tax = calctaxdue(
            taxable=savings_taxable,
            rates=savings_rates,
            bands=savings_bands ).due
        allowance,dividend_taxable = apply_allowance( allowance, dividend )
        dividend_tax = calctaxdue(
            taxable=dividend_taxable,
            rates=sys.dividend_rates,
            bands=sys.dividend_bands ).due
    end
    intermediate["non_savings_tax"]=non_savings_tax
    intermediate["savings_tax"]=savings_tax
    intermediate["dividend_tax"]=dividend_tax

    non_savings_tax+savings_tax+dividend_tax
end


end # module
