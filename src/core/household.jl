#
using Definitions
using Uprating
using Dates

mutable struct Person
    hid::BigInt # == sernum
    pid::BigInt # == unique id (year * 100000)+
    pno::Integer# person number in household
    default_benefit_unit::Integer
    age::Integer

    sex::Sex
    ethnic_group::Ethnic_Group
    marital_status::Marital_Status
    highest_qualification::Qualification_Type

    sic::SIC_2007
    occupational_classification::Standard_Occupational_Classification
    public_or_private :: Employment_Sector
    principal_employment_type :: Employment_Type

    socio_economic_grouping::Socio_Economic_Group
    age_completed_full_time_education::Integer
    years_in_full_time_work::Integer
    employment_status::ILO_Employment
    actual_hours_worked::Real
    usual_hours_worked::Real

    income::Incomes_Dict
    assets::Asset_Dict
    # contracted_out_of_serps::Bool

    registered_blind::Bool
    registered_partially_sighted::Bool
    registered_deaf::Bool

    disabilities::Disability_Dict
    health_status::Health_Status
    relationships::Relationship_Dict
    relationship_to_hoh :: Relationship;
    is_informal_carer::Bool
    receives_informal_care_from_non_householder::Bool
    hours_of_care_received::Real
    hours_of_care_given::Real
    #
    # Childcare fields; assigned to children
    #
    hours_of_childcare :: Real
    cost_of_childcare :: Real
    childcare_type :: Child_Care_Type
    employer_provides_child_care :: Bool
end

People_Dict = Dict{BigInt,Person}

mutable struct Household
    sequence::Integer # position in current generated dataset
    hid::BigInt
    interview_year::Integer
    interview_month::Integer
    quarter::Integer
    tenure::Tenure_Type
    region::Standard_Region
    ct_band::CT_Band
    council_tax::Real
    water_and_sewerage ::Real
    mortgage_payment::Real
    mortgage_interest::Real
    years_outstanding_on_mortgage::Integer
    mortgage_outstanding::Real
    year_house_bought::Integer
    gross_rent::Real # rentg Gross rent including Housing Benefit  or rent Net amount of last rent payment
    rent_includes_water_and_sewerage::Bool
    other_housing_charges::Real # rent Net amount of last rent payment
    gross_housing_costs::Real
    total_income::Real
    total_wealth::Real
    house_value::Real
    weight::Real
    people::People_Dict

end

function uprate!( pid :: BigInt, year::Integer, quarter::Integer, person :: Person )
    for (t,inc) in person.income
            person.income[t] = uprate( inc, year, quarter, UPRATE_MAPPINGS[t])
    end
    for (a,ass) in person.assets
            person.assets[a] = uprate( ass, year, quarter, UPRATE_MAPPINGS[a])
    end
    person.cost_of_childcare = uprate( person.cost_of_childcare, year, quarter, upr_earnings )
end

function uprate!( hh :: Household )

    hh.water_and_sewerage  = uprate( hh.water_and_sewerage , hh.interview_year, hh.quarter, upr_housing_rents )
    hh.mortgage_payment = uprate( hh.mortgage_payment, hh.interview_year, hh.quarter, upr_housing_oo )
    hh.mortgage_interest = uprate( hh.mortgage_interest, hh.interview_year, hh.quarter, upr_housing_oo )
    hh.mortgage_outstanding = uprate( hh.mortgage_outstanding, hh.interview_year, hh.quarter, upr_housing_oo )
    hh.gross_rent = uprate( hh.gross_rent, hh.interview_year, hh.quarter, upr_housing_rents )
    hh.other_housing_charges = uprate( hh.other_housing_charges, hh.interview_year, hh.quarter, upr_nominal_gdp )
    hh.gross_housing_costs = uprate( hh.gross_housing_costs, hh.interview_year, hh.quarter, upr_nominal_gdp )
    hh.total_income = uprate( hh.total_income, hh.interview_year, hh.quarter, upr_nominal_gdp )
    hh.total_wealth = uprate( hh.total_wealth, hh.interview_year, hh.quarter, upr_nominal_gdp )
    hh.house_value = uprate( hh.house_value, hh.interview_year, hh.quarter, upr_housing_oo )
    for (pid,person) in hh.people
        uprate!( pid, hh.interview_year, hh.quarter, person )
    end

end
