#
using Definitions

using Dates

mutable struct Person
    age                                            :: Integer
    sex                                            :: Sex
	hid                                            :: BigInt
	pid                                            :: BigInt

	ethnic_group                                   :: Ethnic_Group
	marital_status                                 :: Marital_Status
	highest_qualification                          :: Qualification_Type
	industrial_classification                      :: SIC_2007
	occupational_classification                    :: Standard_Occupational_Classification
	# FIXME needs work on the mapping - leeve out for now
	socio_economic_grouping                        :: Socio_Economic_Group
	age_completed_full_time_education              :: Integer
	years_in_full_time_work                        :: Integer
	employment_status                              :: ILO_Employment
	hours_worked                                   :: Integer

	income                                         :: Incomes_Dict
	assets                                         :: Asset_Dict
	pension_contributions                          :: Real
	contracted_out_of_serps                        :: Bool

	registered_blind                               :: Bool
	registered_partially_sighted                   :: Bool
	registered_deaf                                :: Bool
	has_learning_difficulty                        :: Bool
	has_dementia                                   :: Bool

	disabilities                                   :: Disability_Dict
	health_status                                  :: Health_Status
	wealth                                         :: Asset_Dict
	is_informal_carer                              :: Bool
	receives_informal_care_from_non_householder    :: Bool
	hours_of_care_received                         :: Real
	hours_of_care_given                            :: Real
end

People_Dict = Dict{BigInt,Person}

mutable struct Household
   hid                           :: BigInt
   year                          :: Unsigned
   current_simulated_date        :: Date
   tenure                        :: Tenure_Type
   region                        :: Standard_Region

   ct_band                       :: CT_Band
   council_tax                   :: Real

   sewerage                      :: Real
   water                         :: Real
   mortgage_payment              :: Real
   mortgage_interest             :: Real
   years_outstanding_on_mortgage :: Integer
   mortgage_outstanding          :: Real
   year_house_bought             :: Integer
   gross_rent                    :: Real # rentg Gross rent including Housing Benefit  or rent Net amount of last rent payment
   rent_includes_water_and_sewerage :: Bool
   other_housing_charges         :: Real # rent Net amount of last rent payment
   gross_housing_costs           :: Real
   total_income                  :: Real
   total_wealth                  :: Real
   # wealth                        :: Incomes_Dict
   house_value                   :: Real

   people :: People_Dict;

end
