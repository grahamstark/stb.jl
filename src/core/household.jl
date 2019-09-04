#
using Definitions

using Dates

mutable struct Person
    age                                            :: Integer
    sex                                            :: Sex
	hid                                            :: Int128
	pid                                            :: Int128    
	age                                            :: Integer        
	sex                                            :: Gender_Type      
	
	ethnic_group                                   :: Ethnic_Group_Type 
	marital_status                                 :: Marital_Status_Type 
	highest_qualification                          :: Msc_Data_Enums.Qualification_Type 
	industrial_classification                      :: Standard_Industrial_Classification_2007 
	occupational_classification                    :: Standard_Occupational_Classification 
	# FIXME needs work on the mapping - leeve out for now
	socio_economic_grouping                        :: Socio_Economic_Grouping_Type 
	age_completed_full_time_education              :: Age_Range        
	years_in_full_time_work                        :: Integer          
	employment_status                              :: Employment_Status_ILO_Definition 
	usual_hours_worked_per_week                    :: Natural 
	
	income                                         :: Incomes_Type_Real_Array 
	assets                                         :: Asset_Type_Real_Array 
	pension_contributions                          :: Real 
	contracted_out_of_serps                        :: Bool 
	
	registered_blind                               :: Bool 
	registered_partially_sighted                   :: Bool 
	registered_deaf                                :: Bool 
	has_learning_difficulty                        :: Bool 
	has_dementia                                   :: Bool 
	
	disabilities                                   :: Disabilities_Type_Bool_Array 
	events_next_period                             :: Events_Type_Bool_Array 
	adls                                           :: Activities_Of_Daily_Living_Bool_Array 
	health_status                                  :: Health_Status_Self_Reported 
	wealth                                         :: Wealth_List 
	has_any_adls                                   :: Bool 
	receives_informal_care_from_household_member   :: Bool 
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
   average_council_tax           :: Real

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
   wealth                        :: IncomesDict
   house_value                   :: Real
   is_care_home                  :: Bool

   people :: PeopleArray;

end


