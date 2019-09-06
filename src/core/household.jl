#
using Definitions

using Dates

mutable struct Person
    age                                            :: Integer
    sex                                            :: Sex
	hid                                            :: Int128
	pid                                            :: Int128
	age                                            :: Integer

	ethnic_group                                   :: Ethnic_Group_Type
	marital_status                                 :: Marital_Status_Type
	highest_qualification                          :: Qualification_Type
	industrial_classification                      :: Standard_Industrial_Classification_2007
	occupational_classification                    :: Standard_Occupational_Classification
	# FIXME needs work on the mapping - leeve out for now
	socio_economic_grouping                        :: Socio_Economic_Grouping_Type
	age_completed_full_time_education              :: Integer
	years_in_full_time_work                        :: Integer
	employment_status                              :: Employment_Status_ILO_Definition
	hours_worked                                   :: Natural ["dvuhr[1..sp"

	income                                         :: Incomes_Dict
	assets                                         :: Asset_Dict
	pension_contributions                          :: Real
	contracted_out_of_serps                        :: Bool

	registered_blind                               :: Bool
	registered_partially_sighted                   :: Bool
	registered_deaf                                :: Bool
	has_learning_difficulty                        :: Bool
	has_dementia                                   :: Bool

	disabilities                                   :: Dict{Disability_Type,Bool}
	health_status                                  :: Health_Status
	wealth                                         :: Wealth_List
	is_informal_carer                              :: Bool
	receives_informal_care_from_non_householder    :: Bool
	hours_of_care_received                         :: Real
	hours_of_care_given                            :: Real
end

mutable struct Household
   hid                           :: BigInt
   year                          :: Unsigned
   current_simulated_date        :: Date
   tenure                        :: Tenure_Type
   region                        :: Region_Type

   ct_band                       :: Council_Tax_Band_Type
   council_tax                   :: Real

   sewerage                      :: Real
   water                         :: Real
   mortgage_payment              :: Real
   mortgage_interest             :: Real
   years_outstanding_on_mortgage :: Integer
   mortgage_outstanding          :: Real
   year_house_bought             :: Unsigned
   gross_rent                    :: Real # rentg Gross rent including Housing Benefit  or rent Net amount of last rent payment
   rent_includes_water_and_sewerage :: Bool
   other_housing_charges         :: Real # rent Net amount of last rent payment
   gross_housing_costs           :: Real
   total_income                  :: Real
   total_wealth                  :: Real
   # wealth                        :: Incomes_Dict
   house_value                   :: Real

   people :: PeopleArray;

end
