module Definitions
#
#
using Utils
export Employment_Status  # mapped from empstat
export Employee, Self_employed
export Missing_Employment_Status

@enum Employment_Status begin  # mapped from empstat
   Missing_Employment_Status = -1
   Employee = 1
   Self_employed = 2
end


export ILO_Employment  # mapped from empstati
export Full_time_Employee,
       Part_time_Employee,
       Full_time_Self_Employed,
       Part_time_Self_Employed,
       Unemployed,
       Retired,
       Student,
       Looking_after_family_or_home,
       Permanently_sick_or_disabled,
       Temporarily_sick_or_injured,
       Other_Inactive
export Missing_ILO_Employment

@enum ILO_Employment begin  # mapped from empstati
   Missing_ILO_Employment = -1
   Full_time_Employee = 1
   Part_time_Employee = 2
   Full_time_Self_Employed = 3
   Part_time_Self_Employed = 4
   Unemployed = 5
   Retired = 6
   Student = 7
   Looking_after_family_or_home = 8
   Permanently_sick_or_disabled = 9
   Temporarily_sick_or_injured = 10
   Other_Inactive = 11
end


export Ethnic_Group  # mapped from ethgr3
export White,
       Mixed_or_Multiple_ethnic_groups,
       Asian_or_Asian_British,
       Black_or_African_or_Caribbean_or_Black_British,
       Other_ethnic_group
export Missing_Ethnic_Group

@enum Ethnic_Group begin  # mapped from ethgr3
   Missing_Ethnic_Group = -1
   White = 1
   Mixed_or_Multiple_ethnic_groups = 2
   Asian_or_Asian_British = 3
   Black_or_African_or_Caribbean_or_Black_British = 4
   Other_ethnic_group = 5
end


export Ethnic_Scotland  # mapped from ethgrps
export Scottish,
       Other_British,
       Irish,
       Gypsy_or_Traveller,
       Polish,
       Any_other_white_ethnic_group,
       Any_mixed_or_multiple_ethnic_group,
       Pakistani_Pakistani_Scottish_or_Pakistani_British,
       Indian_Indian_Scottish_or_Indian_British,
       Bangladeshi_Bangladeshi_Scottish_or_Bangladeshi_British,
       Chinese_Chinese_Scottish_or_Chinese_British,
       Any_other_Asian,
       African_African_Scottish_or_African_British,
       Any_other_African,
       Caribbean_Caribbean_Scottish_or_Caribbean_British,
       Black_Black_Scottish_or_Black_British,
       Any_other_Caribbean_or_Black,
       Arab_Arab_Scottish_or_Arab_British,
       Any_other_ethnic_group
export Missing_Ethnic_Scotland

@enum Ethnic_Scotland begin  # mapped from ethgrps
   Missing_Ethnic_Scotland = -1
   Scottish = 1
   Other_British = 2
   Irish = 3
   Gypsy_or_Traveller = 4
   Polish = 5
   Any_other_white_ethnic_group = 6
   Any_mixed_or_multiple_ethnic_group = 7
   Pakistani_Pakistani_Scottish_or_Pakistani_British = 8
   Indian_Indian_Scottish_or_Indian_British = 9
   Bangladeshi_Bangladeshi_Scottish_or_Bangladeshi_British = 10
   Chinese_Chinese_Scottish_or_Chinese_British = 11
   Any_other_Asian = 12
   African_African_Scottish_or_African_British = 13
   Any_other_African = 14
   Caribbean_Caribbean_Scottish_or_Caribbean_British = 15
   Black_Black_Scottish_or_Black_British = 16
   Any_other_Caribbean_or_Black = 17
   Arab_Arab_Scottish_or_Arab_British = 18
   Any_other_ethnic_group = 19
end


export Sex  # mapped from sex
export Male, Female
export Missing_Sex

@enum Sex begin  # mapped from sex
   Missing_Sex = -1
   Male = 1
   Female = 2
end


export Health_Status  # mapped from heathad
export Very_Good, Good, Fair, Bad, Very_Bad
export Missing_Health_Status

@enum Health_Status begin  # mapped from heathad
   Missing_Health_Status = -1
   Very_Good = 1
   Good = 2
   Fair = 3
   Bad = 4
   Very_Bad = 5
end


export Marital_Status  # mapped from marital
export Married_or_Civil_Partnership,
       Cohabiting,
       Single,
       Widowed,
       Separated,
       Divorced_or_Civil_Partnership_dissolved
export Missing_Marital_Status

@enum Marital_Status begin  # mapped from marital
   Missing_Marital_Status = -1
   Married_or_Civil_Partnership = 1
   Cohabiting = 2
   Single = 3
   Widowed = 4
   Separated = 5
   Divorced_or_Civil_Partnership_dissolved = 6
end


export Qualification_Type  # mapped from dvhiqual
export Doctorate_or_MPhil,
       Masters_PGCE_or_some_other_post_graduate_degree,
       Degree_inc_foundation_degree_or_professional_institute_member,
       Teaching_qualification_excluding_PGCE,
       Any_other_foreign_qualification_at_degree_level,
       Any_other_work_related_or_vocational_qualification_at_degr,
       Any_other_professional_qualification_at_degree_level,
       Other_Higher_Education_qualification_below_degree_level,
       Nursing_or_other_medical_qualification_not_yet_mentioned,
       Diploma_in_higher_education,
       HNC_or_HND,
       BTEC_BEC_TEC_EdExcel_or_LQL_at_higher_level_Higher_Lev,
       SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_higher_level_level,
       NVQ_or_SVQ_Level_4,
       NVQ_or_SVQ_Level_5,
       RSA_or_OCR_a_higher_diploma_or_OCR_Level_4,
       A_Level_or_GCE_in_Applied_Subjects_or_equivalent,
       Welsh_Baccalaureate_at_Advanced_level,
       Scottish_Baccalaureate,
       International_Baccalaureate,
       AS_level_or_equivalent,
       Certificate_of_6th_Year_Studies_CSYS_Scotland,
       Access_to_Higher_Education,
       Advanced_Higher_or_Higher_or_Intermediate_or_Access_Qualification_Sc,
       Skills_for_work_Higher,
       ONC_or_OND,
       BTEC_BEC_TEC_EdExcel_or_LQL_at_Nat_Cert_or_Nat_Dipl_leve,
       SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_full_Nat_Cert_Level,
       New_Diploma_an_Advanced_diploma_level3,
       New_Diploma_a_Progression_diploma_level_3,
       NVQ_or_SVQ_Level_3,
       GNVQ_or_GSVQ_Advanced,
       RSA_or_OCR_an_advanced_diploma_or_advanced_certificate_or_OCR_L,
       City_and_Guilds_advanced_craft_or_part_3,
       Welsh_Baccalaureate_at_the_Intermediate_level,
       O_Level_or_equivalent_five_or_more,
       Standard_Grade_or_Ordinary_Grade_or_Lower_Scotland_five_or,
       GCSE_or_equivalent_five_or_more,
       CSE_five_or_more,
       Scottish_National_level_5,
       Skills_for_work_National_level_5,
       BTEC_BEC_TEC_EdExcel_or_LQL_first_diploma_or_general_diplo,
       SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_first_diploma_or_genera,
       New_Diploma_a_Higher_diploma_level_2,
       NVQ_or_SVQ_Level_2,
       GNVQ_or_GSVQ_Full_Intermediate,
       RSA_or_OCR_a_diploma_or_OCR_Level_2,
       City_and_Guilds_craft_or_part_2,
       Any_other_qualification_high_school_leavers_qualification,
       BTEC_BEC_TEC_EdExcel_or_LQL,
       BTEC_BEC_TEC_EdExcel_or_LQL_first_cert_or_general_cert_Le,
       SCOTVEC_SCOTEC_or_SCOTBEC_Scotland,
       SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_first_cert_or_general_c,
       SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_modules_towards_Nat,
       New_Diploma,
       New_Diploma_Foundation_Diploma_level_1,
       Welsh_Baccalaureate,
       Welsh_Baccalaureate_at_the_foundation_level,
       NVQ_or_SVQ,
       NVQ_or_SVQ_Level_1,
       GNVQ_or_GSVQ,
       GNVQ_or_GSVQ_Part_One_Intermediate,
       GNVQ_or_GSVQ_Full_Foundation,
       GNVQ_or_GSVQ_Part_One_Foundation,
       O_Level_or_equivalent,
       O_Level_or_equivalent_fewer_than_5,
       Standard_Grade_or_Ordinary_Grade_or_Lower_Scotland,
       Standard_Grade_or_Ordinary_Grade_or_Lower_Scotland_fewer_t,
       GCSE_or_equivalent,
       GCSE_or_equivalent_fewer_than_5,
       Scottish_National_level_1_to_4,
       Scottish_National_level,
       Skills_for_work_National_level_3_and_4,
       Skills_for_work,
       CSE,
       CSE_fewer_than_5,
       RSA_or_OCR,
       RSA_or_OCR_some_other_RSA_including_Stage_I_II_and_III_or_OC,
       City_and_Guilds,
       City_and_Guilds_foundation_or_part_1,
       YT_Certificate_or_YTP,
       Key_Skills_or_Core_Skills_Scotland_or_Essential_Skills_Wales,
       Basic_Skills_skills_for_life_or_literacy_or_numeracy_or_language,
       Entry_Level_Qualifications,
       Award_Certificate_or_Diploma_at_entry_level_levels_1_to_8,
       Any_other_professional_or_vocational_or_foreign_qualifications
export Missing_Highest_Qualification

@enum Qualification_Type begin  # mapped from dvhiqual
   Missing_Highest_Qualification = -1
   Doctorate_or_MPhil = 1
   Masters_PGCE_or_some_other_post_graduate_degree = 2
   Degree_inc_foundation_degree_or_professional_institute_member = 3
   Teaching_qualification_excluding_PGCE = 4
   Any_other_foreign_qualification_at_degree_level = 5
   Any_other_work_related_or_vocational_qualification_at_degr = 6
   Any_other_professional_qualification_at_degree_level = 7
   Other_Higher_Education_qualification_below_degree_level = 8
   Nursing_or_other_medical_qualification_not_yet_mentioned = 9
   Diploma_in_higher_education = 10
   HNC_or_HND = 11
   BTEC_BEC_TEC_EdExcel_or_LQL_at_higher_level_Higher_Lev = 12
   SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_higher_level_level = 13
   NVQ_or_SVQ_Level_4 = 14
   NVQ_or_SVQ_Level_5 = 15
   RSA_or_OCR_a_higher_diploma_or_OCR_Level_4 = 16
   A_Level_or_GCE_in_Applied_Subjects_or_equivalent = 17
   Welsh_Baccalaureate_at_Advanced_level = 18
   Scottish_Baccalaureate = 19
   International_Baccalaureate = 20
   AS_level_or_equivalent = 21
   Certificate_of_6th_Year_Studies_CSYS_Scotland = 22
   Access_to_Higher_Education = 23
   Advanced_Higher_or_Higher_or_Intermediate_or_Access_Qualification_Sc = 24
   Skills_for_work_Higher = 25
   ONC_or_OND = 26
   BTEC_BEC_TEC_EdExcel_or_LQL_at_Nat_Cert_or_Nat_Dipl_leve = 27
   SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_full_Nat_Cert_Level = 28
   New_Diploma_an_Advanced_diploma_level3 = 29
   New_Diploma_a_Progression_diploma_level_3 = 30
   NVQ_or_SVQ_Level_3 = 31
   GNVQ_or_GSVQ_Advanced = 32
   RSA_or_OCR_an_advanced_diploma_or_advanced_certificate_or_OCR_L = 33
   City_and_Guilds_advanced_craft_or_part_3 = 34
   Welsh_Baccalaureate_at_the_Intermediate_level = 35
   O_Level_or_equivalent_five_or_more = 36
   Standard_Grade_or_Ordinary_Grade_or_Lower_Scotland_five_or = 37
   GCSE_or_equivalent_five_or_more = 38
   CSE_five_or_more = 39
   Scottish_National_level_5 = 40
   Skills_for_work_National_level_5 = 41
   BTEC_BEC_TEC_EdExcel_or_LQL_first_diploma_or_general_diplo = 42
   SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_first_diploma_or_genera = 43
   New_Diploma_a_Higher_diploma_level_2 = 44
   NVQ_or_SVQ_Level_2 = 45
   GNVQ_or_GSVQ_Full_Intermediate = 46
   RSA_or_OCR_a_diploma_or_OCR_Level_2 = 47
   City_and_Guilds_craft_or_part_2 = 48
   Any_other_qualification_high_school_leavers_qualification = 49
   BTEC_BEC_TEC_EdExcel_or_LQL = 50
   BTEC_BEC_TEC_EdExcel_or_LQL_first_cert_or_general_cert_Le = 51
   SCOTVEC_SCOTEC_or_SCOTBEC_Scotland = 52
   SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_first_cert_or_general_c = 53
   SCOTVEC_SCOTEC_or_SCOTBEC_Scotland_modules_towards_Nat = 54
   New_Diploma = 55
   New_Diploma_Foundation_Diploma_level_1 = 56
   Welsh_Baccalaureate = 57
   Welsh_Baccalaureate_at_the_foundation_level = 58
   NVQ_or_SVQ = 59
   NVQ_or_SVQ_Level_1 = 60
   GNVQ_or_GSVQ = 61
   GNVQ_or_GSVQ_Part_One_Intermediate = 62
   GNVQ_or_GSVQ_Full_Foundation = 63
   GNVQ_or_GSVQ_Part_One_Foundation = 64
   O_Level_or_equivalent = 65
   O_Level_or_equivalent_fewer_than_5 = 66
   Standard_Grade_or_Ordinary_Grade_or_Lower_Scotland = 67
   Standard_Grade_or_Ordinary_Grade_or_Lower_Scotland_fewer_t = 68
   GCSE_or_equivalent = 69
   GCSE_or_equivalent_fewer_than_5 = 70
   Scottish_National_level_1_to_4 = 71
   Scottish_National_level = 72
   Skills_for_work_National_level_3_and_4 = 73
   Skills_for_work = 74
   CSE = 75
   CSE_fewer_than_5 = 76
   RSA_or_OCR = 77
   RSA_or_OCR_some_other_RSA_including_Stage_I_II_and_III_or_OC = 78
   City_and_Guilds = 79
   City_and_Guilds_foundation_or_part_1 = 80
   YT_Certificate_or_YTP = 81
   Key_Skills_or_Core_Skills_Scotland_or_Essential_Skills_Wales = 82
   Basic_Skills_skills_for_life_or_literacy_or_numeracy_or_language = 83
   Entry_Level_Qualifications = 84
   Award_Certificate_or_Diploma_at_entry_level_levels_1_to_8 = 85
   Any_other_professional_or_vocational_or_foreign_qualifications = 86
end


export Standard_Region  # mapped from gvtregn
export North_East,
       North_West,
       Yorks_and_the_Humber,
       East_Midlands,
       West_Midlands,
       East_of_England,
       London,
       South_East,
       South_West,
       Scotland,
       Wales,
       Northern_Ireland
export Missing_Standard_Region

@enum Standard_Region begin  # mapped from gvtregn
   Missing_Standard_Region = -1
   North_East = 112000001
   North_West = 112000002
   Yorks_and_the_Humber = 112000003
   East_Midlands = 112000004
   West_Midlands = 112000005
   East_of_England = 112000006
   London = 112000007
   South_East = 112000008
   South_West = 112000009
   Scotland = 299999999
   Wales = 399999999
   Northern_Ireland = 499999999
end


export Socio_Economic_Group  # mapped from nssec
export Employers_in_large_organisations,
       Higher_managerial_occupations,
       Higher_professional_occupations_New_self_employed,
       Lower_prof_and_higher_technical_Traditional_employee,
       Lower_managerial_occupations,
       Higher_supervisory_occupations,
       Intermediate_clerical_and_administrative,
       Employers_in_small_organisations_non_professional,
       Own_account_workers_non_professional,
       Lower_supervisory_occupations,
       Lower_technical_craft,
       Semi_routine_sales,
       Routine_sales_and_service,
       Never_worked,
       Full_time_student,
       Not_classified_or_inadequately_stated,
       Not_classifiable_for_other_reasons
export Missing_Socio_Economic_Group

@enum Socio_Economic_Group begin  # mapped from nssec
   Missing_Socio_Economic_Group = -1
   Employers_in_large_organisations = 1
   Higher_managerial_occupations = 2
   Higher_professional_occupations_New_self_employed = 3
   Lower_prof_and_higher_technical_Traditional_employee = 4
   Lower_managerial_occupations = 5
   Higher_supervisory_occupations = 6
   Intermediate_clerical_and_administrative = 7
   Employers_in_small_organisations_non_professional = 8
   Own_account_workers_non_professional = 9
   Lower_supervisory_occupations = 10
   Lower_technical_craft = 11
   Semi_routine_sales = 12
   Routine_sales_and_service = 13
   Never_worked = 14
   Full_time_student = 15
   Not_classified_or_inadequately_stated = 16
   Not_classifiable_for_other_reasons = 17
end


export SIC_2007  # mapped from sic
export Undefined_SIC,
       Crop_and_animal_production_hunting_and_related_serviceX,
       Forestry_and_logging,
       Fishing_and_aquaculture,
       Mining_of_coal_and_lignite,
       Extraction_of_crude_petroleum_and_natural_gas,
       Mining_of_metal_ores,
       Other_mining_and_quarrying,
       Mining_support_service_activities,
       Manufacture_of_food_products,
       Manufacture_of_beverages,
       Manufacture_of_tobacco_products,
       Manufacture_of_textiles,
       Manufacture_of_wearing_apparel,
       Manufacture_of_leather_and_related_products,
       Manufacture_of_wood_and_of_products_of_wood_and_corkX,
       Manufacture_of_paper_and_paper_products,
       Printing_and_reproduction_of_recorded_media,
       Manufacture_of_coke_and_refined_petroleum_products,
       Manufacture_of_chemicals_and_chemical_products,
       Manufacture_of_basic_pharmaceutical_products_andX,
       Manufacture_of_rubber_and_plastic_products,
       Manufacture_of_other_non_metallic_mineral_products,
       Manufacture_of_basic_metals,
       Manufacture_of_fabricated_metal_products_except_machineryX,
       Manufacture_of_computer_electronic_and_optical_products,
       Manufacture_of_electrical_equipment,
       Manufacture_of_machinery_and_equipment_nec,
       Manufacture_of_motor_vehicles_trailers_and_semi_trailers,
       Manufacture_of_other_transport_equipment,
       Manufacture_of_furniture,
       Other_manufacturing,
       Repair_and_installation_of_machinery_and_equipment,
       Electricity_gas_steam_and_air_conditioning_supply,
       Water_collection_treatment_and_supply,
       Sewerage,
       Waste_collection_treatment_and_disposal_activitiesX,
       Remediation_activities_and_other_waste_management_services,
       Construction_of_buildings,
       Civil_engineering,
       Specialised_construction_activities,
       Wholesale_and_retail_trade_and_repair_of_motor_vehiclesX,
       Wholesale_trade_except_of_motor_vehicles_and_motorcycles,
       Retail_trade_except_of_motor_vehicles_and_motorcycles,
       Land_transport_and_transport_via_pipelines,
       Water_transport,
       Air_transport,
       Warehousing_and_support_activities_for_transportation,
       Postal_and_courier_activities,
       Accommodation,
       Food_and_beverage_service_activities,
       Publishing_activities,
       Motion_picture_video_and_television_programme_productionX,
       Programming_and_broadcasting_activities,
       Telecommunications,
       Computer_programming_consultancy_and_related_activities,
       Information_service_activities,
       Financial_service_activities_except_insurance_and_pensionX,
       Insurance_reinsurance_and_pension_funding_exceptX,
       Activities_auxiliary_to_financial_services_and_insuranceX,
       Real_estate_activities,
       Legal_and_accounting_activities,
       Activities_of_head_offices_management_consultancyX,
       Architectural_and_engineering_activities_technical_testingX,
       Scientific_research_and_development,
       Advertising_and_market_research,
       Other_professional_scientific_and_technical_activities,
       Veterinary_activities,
       Rental_and_leasing_activities,
       Employment_activities,
       Travel_agency_tour_operator_and_other_reservation_serviceX,
       Security_and_investigation_activities,
       Services_to_buildings_and_landscape_activities,
       Office_administrative_office_support_and_other_businessX,
       Public_administration_and_defence_compulsory_socialX,
       Education,
       Human_health_activities,
       Residential_care_activities,
       Social_work_activities_without_accommodation,
       Creative_arts_and_entertainment_activities,
       Libraries_archives_museums_and_other_cultural_activities,
       Gambling_and_betting_activities,
       Sports_activities_and_amusement_and_recreation_activities,
       Activities_of_membership_organisations,
       Repair_of_computers_and_personal_and_household_goods,
       Other_personal_service_activities,
       Activities_of_households_as_employers_of_domestic_personnel,
       Undifferentiated_goods_and_services_producing_activitiesX,
       Activities_of_extraterritorial_organisations_and_bodies
export Missing_SIC_2007

@enum SIC_2007 begin  # mapped from sic
   Missing_SIC_2007 = -1
   Undefined_SIC = 0
   Crop_and_animal_production_hunting_and_related_serviceX = 1
   Forestry_and_logging = 2
   Fishing_and_aquaculture = 3
   Mining_of_coal_and_lignite = 5
   Extraction_of_crude_petroleum_and_natural_gas = 6
   Mining_of_metal_ores = 7
   Other_mining_and_quarrying = 8
   Mining_support_service_activities = 9
   Manufacture_of_food_products = 10
   Manufacture_of_beverages = 11
   Manufacture_of_tobacco_products = 12
   Manufacture_of_textiles = 13
   Manufacture_of_wearing_apparel = 14
   Manufacture_of_leather_and_related_products = 15
   Manufacture_of_wood_and_of_products_of_wood_and_corkX = 16
   Manufacture_of_paper_and_paper_products = 17
   Printing_and_reproduction_of_recorded_media = 18
   Manufacture_of_coke_and_refined_petroleum_products = 19
   Manufacture_of_chemicals_and_chemical_products = 20
   Manufacture_of_basic_pharmaceutical_products_andX = 21
   Manufacture_of_rubber_and_plastic_products = 22
   Manufacture_of_other_non_metallic_mineral_products = 23
   Manufacture_of_basic_metals = 24
   Manufacture_of_fabricated_metal_products_except_machineryX = 25
   Manufacture_of_computer_electronic_and_optical_products = 26
   Manufacture_of_electrical_equipment = 27
   Manufacture_of_machinery_and_equipment_nec = 28
   Manufacture_of_motor_vehicles_trailers_and_semi_trailers = 29
   Manufacture_of_other_transport_equipment = 30
   Manufacture_of_furniture = 31
   Other_manufacturing = 32
   Repair_and_installation_of_machinery_and_equipment = 33
   Electricity_gas_steam_and_air_conditioning_supply = 35
   Water_collection_treatment_and_supply = 36
   Sewerage = 37
   Waste_collection_treatment_and_disposal_activitiesX = 38
   Remediation_activities_and_other_waste_management_services = 39
   Construction_of_buildings = 41
   Civil_engineering = 42
   Specialised_construction_activities = 43
   Wholesale_and_retail_trade_and_repair_of_motor_vehiclesX = 45
   Wholesale_trade_except_of_motor_vehicles_and_motorcycles = 46
   Retail_trade_except_of_motor_vehicles_and_motorcycles = 47
   Land_transport_and_transport_via_pipelines = 49
   Water_transport = 50
   Air_transport = 51
   Warehousing_and_support_activities_for_transportation = 52
   Postal_and_courier_activities = 53
   Accommodation = 55
   Food_and_beverage_service_activities = 56
   Publishing_activities = 58
   Motion_picture_video_and_television_programme_productionX = 59
   Programming_and_broadcasting_activities = 60
   Telecommunications = 61
   Computer_programming_consultancy_and_related_activities = 62
   Information_service_activities = 63
   Financial_service_activities_except_insurance_and_pensionX = 64
   Insurance_reinsurance_and_pension_funding_exceptX = 65
   Activities_auxiliary_to_financial_services_and_insuranceX = 66
   Real_estate_activities = 68
   Legal_and_accounting_activities = 69
   Activities_of_head_offices_management_consultancyX = 70
   Architectural_and_engineering_activities_technical_testingX = 71
   Scientific_research_and_development = 72
   Advertising_and_market_research = 73
   Other_professional_scientific_and_technical_activities = 74
   Veterinary_activities = 75
   Rental_and_leasing_activities = 77
   Employment_activities = 78
   Travel_agency_tour_operator_and_other_reservation_serviceX = 79
   Security_and_investigation_activities = 80
   Services_to_buildings_and_landscape_activities = 81
   Office_administrative_office_support_and_other_businessX = 82
   Public_administration_and_defence_compulsory_socialX = 84
   Education = 85
   Human_health_activities = 86
   Residential_care_activities = 87
   Social_work_activities_without_accommodation = 88
   Creative_arts_and_entertainment_activities = 90
   Libraries_archives_museums_and_other_cultural_activities = 91
   Gambling_and_betting_activities = 92
   Sports_activities_and_amusement_and_recreation_activities = 93
   Activities_of_membership_organisations = 94
   Repair_of_computers_and_personal_and_household_goods = 95
   Other_personal_service_activities = 96
   Activities_of_households_as_employers_of_domestic_personnel = 97
   Undifferentiated_goods_and_services_producing_activitiesX = 98
   Activities_of_extraterritorial_organisations_and_bodies = 99
end


export Standard_Occupational_Classification  # mapped from soc2010
export Undefined_SOC,
       Managers_Directors_and_Senior_Officials,
       Professional_Occupations,
       Associate_Prof_and_Technical_Occupations,
       Admin_and_Secretarial_Occupations,
       Skilled_Trades_Occupations,
       Caring_leisure_and_other_service_occupations,
       Sales_and_Customer_Service,
       Process_Plant_and_Machine_Operatives,
       Elementary_Occupations
export Missing_Standard_Occupational_Classification

@enum Standard_Occupational_Classification begin  # mapped from soc2010
   Missing_Standard_Occupational_Classification = -1
   Undefined_SOC = 0
   Managers_Directors_and_Senior_Officials = 1000
   Professional_Occupations = 2000
   Associate_Prof_and_Technical_Occupations = 3000
   Admin_and_Secretarial_Occupations = 4000
   Skilled_Trades_Occupations = 5000
   Caring_leisure_and_other_service_occupations = 6000
   Sales_and_Customer_Service = 7000
   Process_Plant_and_Machine_Operatives = 8000
   Elementary_Occupations = 9000
end


export Tenure_Type  # mapped from tentyp2
export LA_or_New_Town_or_NIHE_or_Council_rented,
       Housing_Association_or_Co_Op_or_Trust_rented,
       Other_private_rented_unfurnished,
       Other_private_rented_furnished,
       Owned_with_a_mortgage_includes_part_rent_or_part_own,
       Owned_outright,
       Rent_free,
       Squats
export Missing_Tenure_Type

@enum Tenure_Type begin  # mapped from tentyp2
   Missing_Tenure_Type = -1
   LA_or_New_Town_or_NIHE_or_Council_rented = 1
   Housing_Association_or_Co_Op_or_Trust_rented = 2
   Other_private_rented_unfurnished = 3
   Other_private_rented_furnished = 4
   Owned_with_a_mortgage_includes_part_rent_or_part_own = 5
   Owned_outright = 6
   Rent_free = 7
   Squats = 8
end

function renting(tt::Tenure_Type)::Bool
   tt < Owned_with_a_mortgage_includes_part_rent_or_part_own
end

function owner_occupier(tt::Tenure_Type)::Bool
   tt in [Owned_with_a_mortgage_includes_part_rent_or_part_own, Owned_Outright]
end



export CT_Band  # mapped from ctband
export Band_A,
       Band_B,
       Band_C,
       Band_D,
       Band_E,
       Band_F,
       Band_G,
       Band_H,
       Band_I,
       Household_not_valued_separately
export Missing_CT_Band

@enum CT_Band begin  # mapped from ctband
   Missing_CT_Band = -1
   Band_A = 1
   Band_B = 2
   Band_C = 3
   Band_D = 4
   Band_E = 5
   Band_F = 6
   Band_G = 7
   Band_H = 8
   Band_I = 9
   Household_not_valued_separately = 10
end

export
   Disability_Type,
   Disability_Dict,
   vision,
   hearing,
   mobility,
   dexterity,
   learning,
   memory,
   mental_health,
   stamina,
   socially,
   other_difficulty

@enum Disability_Type begin  # mapped from ctband
   vision = 1
   hearing  = 2
   mobility  = 3
   dexterity = 4
   learning = 5
   memory = 6
   mental_health = 7
   stamina = 8
   socially = 9
   other_difficulty = 10
end

Disability_Dict = Dict{Disability_Type,Bool}


export Incomes_Type, Incomes_Dict

export
      wages,
      self_employment_income,
      self_employment_expenses,
      self_employment_losses,
      private_pensions,

      national_savings,
      bank_interest,
      building_society,
      stocks_shares,
      peps,
      isa,
      dividends,
      property,
      royalties,
      bonds_and_gilts,
      other_investment_income,

      other_income,
      alimony_and_child_support_received,

      health_insurance,
      alimony_and_child_support_paid,
      care_insurance,
      trade_unions_etc,
      friendly_societies,
      work_expenses,
      repayments,
      pension_contributions,

      education_allowances,
      foster_care_payments,
      student_grants,
      student_loans,

      income_tax,
      national_insurance,
      local_taxes,

      child_benefit,
      pension_credit,
      retirement_pension,
      other_pensions,
      disabled_living_allowance,
      severe_disablement_allowance,
      pip,
      attendance_allowance,
      invalid_care_allowance,
      incapacity_benefit,
      jobseekers_allowance,
      income_support_jsa,
      maternity_allowance,
      other_benefits,
      winter_fuel_payments,
      housing_benefit,
      council_tax_benefit,
      tax_credits,
      sickness_benefits

@enum Incomes_Type begin
   wages
   self_employment_income
   self_employment_expenses
   self_employment_losses
   private_pensions

   national_savings
   bank_interest
   building_society
   stocks_shares
   peps
   isa
   dividends
   property
   royalties
   bonds_and_gilts
   other_investment_income

   other_income
   alimony_and_child_support_received

   health_insurance
   alimony_and_child_support_paid
   care_insurance
   trade_unions_etc
   friendly_societies
   work_expenses
   repayments
   pension_contributions

   education_allowances
   foster_care_payments
   student_grants
   student_loans

   income_tax
   national_insurance
   local_taxes

   child_benefit
   pension_credit
   retirement_pension
   other_pensions
   disabled_living_allowance
   pip
   severe_disablement_allowance
   attendance_allowance
   invalid_care_allowance
   incapacity_benefit
   jobseekers_allowance
   income_support_jsa
   maternity_allowance
   other_benefits
   winter_fuel_payments
   housing_benefit
   council_tax_benefit
   tax_credits
   sickness_benefits
end

Incomes_Dict = Dict{Incomes_Type,Real}

export Asset_Type, Asset_Dict
export
   current_account,
   nsb_ordinary_account,
   nsb_investment_account,
   not_used,
   savings_investments_etc,
   government_gilt_edged_stock,
   unit_or_investment_trusts,
   stocks_shares_bonds_etc,
   pep,
   national_savings_capital_bonds,
   index_linked_national_savings_certificates,
   fixed_interest_national_savings_certificates,
   pensioners_guaranteed_bonds,
   saye,
   premium_bonds,
   national_savings_income_bonds,
   national_savings_deposit_bonds,
   first_option_bonds,
   yearly_plan,
   isas,
   fixd_rate_svngs_bonds_or_grntd_incm_bonds_or_grntd_growth_bonds,
   geb,
   basic_account,
   credit_unions,
   endowment_policy_not_linked

   @enum Asset_Type begin
      current_account
      nsb_ordinary_account
      nsb_investment_account
      not_used
      savings_investments_etc
      government_gilt_edged_stock
      unit_or_investment_trusts
      stocks_shares_bonds_etc
      pep
      national_savings_capital_bonds
      index_linked_national_savings_certificates
      fixed_interest_national_savings_certificates
      pensioners_guaranteed_bonds
      saye
      premium_bonds
      national_savings_income_bonds
      national_savings_deposit_bonds
      first_option_bonds
      yearly_plan
      isas
      fixd_rate_svngs_bonds_or_grntd_incm_bonds_or_grntd_growth_bonds
      geb
      basic_account
      credit_unions
      endowment_policy_not_linked
   end

   Asset_Dict = Dict{ Asset_Type, Real }

end # module
