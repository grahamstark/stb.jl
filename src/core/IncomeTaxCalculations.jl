module IncomeTaxCalculations

import Dates
import Dates: Date, now, TimeType, Year

import Model_Household: Person
import STBParameters: IncomeTaxSys

using Definitions

export calc_income_tax, old_enough_for_mca

## FIXME all these constants should ultimately be parameters
const MCA_DATE = Date(1935,4,6) # fixme make this a parameter

const SAVINGS_INCOME = Incomes_Dict(
    bank_interest => 1.0,
    bonds_and_gilts => 1.0,
    other_investment_income => 1.0
)

const DIVIDENDS = Incomes_Dict(
    dividends => 1.0, # FIXME not used needs deleted
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
    excl = union(Set(keys(DIVIDENDS)), Set( keys(SAVINGS_INCOME)))
    nsi = make_all_taxable()
    for i in excl
        delete!( nsi, i )
    end
    nsi
end

const NON_SAVINGS = make_non_savings()
const ALL_TAXABLE = make_all_taxable()

"""
Very rough approximation to MCA age - ignores all months since we don't have that in a typical dataset
TODO maybe overload this with age as a Date?
"""
function old_enough_for_mca(
    age            :: Integer,
    model_run_date :: TimeType = now() ) :: Bool
    (model_run_date - Year(age)) < MCA_DATE
end

function calc_income_tax(
    pers   :: Person,
    sys    :: IncomeTaxSys,
    spouse :: Union{Person,Nothing} = nothing ) :: Real

    0.0
end


end # module
