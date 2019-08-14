#
using Definitions

using Dates

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

end
