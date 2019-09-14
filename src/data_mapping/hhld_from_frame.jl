function map_hhld( frs_hh :: DataFrameRow )
    Household(

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
    People_Dict()
end

function load_hhld_from_frs( year :: Integer, hid :: Integer; hhld_fr :: DataFrame, pers_fr :: DataFrame ) :: Household
    frs_hh = hhld_fr[((hhld_fr.year .== year).&(hhld_fr.hid .== hid)),:]
    hh :: Household = map_hhld( frs_hh )
end
