#
using Definitions

using Dates

mutable struct Person
    hid::BigInt# == sernum
    pid::BigInt# == unique id (year * 100000)+
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
    contracted_out_of_serps::Bool

    registered_blind::Bool
    registered_partially_sighted::Bool
    registered_deaf::Bool
    has_learning_difficulty::Bool
    has_dementia::Bool

    disabilities::Disability_Dict
    health_status::Health_Status
    relationships::Relationship_Dict
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
    hid::BigInt
    interview_year::Unsigned
    interview_month::Unsigned
    quarter::Unsigned
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
