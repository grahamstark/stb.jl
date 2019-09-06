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
age_completed_full_time_education              :: Integer tea
years_in_full_time_work                        :: Integer  ftwk
employment_status                              :: Employment_Status_ILO_Definition
hours_worked                                   :: Natural "tothours" from frs-yr or "injwk" from adult

income                                         :: Incomes_Dict
assets                                         :: Asset_Dict
pension_contributions                          :: Real  job.udeduc1  job.udeduc2
contracted_out_of_serps                        :: Bool ???

registered_blind                               :: Bool spcreg1 adult|child
registered_partially_sighted                   :: Bool spcreg2 adult|child
registered_deaf                                :: Bool spcreg3 adult|child
has_learning_difficulty                        :: Bool disd05 | cdisd05
disabilities                                   :: Dict{Disability_Type,Bool} dis01 .. dis10
health_status                                  :: Health_Status
wealth                                         :: Wealth_List
is_informal_carer                              :: Bool carefl adult|child
receives_informal_care_from_non_householder    :: Bool ??
hours_of_care_received                         :: Real  hourcare
hours_of_care_given                            :: Real  hourtot
hid                           :: BigInt
year                          :: Unsigned
current_simulated_date        :: Date
tenure                        :: Tenure_Type
region                        :: Region_Type

ct_band                       :: Council_Tax_Band_Type
council_tax                   :: "ctamt"

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
is_care_home                  :: Bool
