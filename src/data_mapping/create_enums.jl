#
using DDIMeta

function make_from_frs()

    conn = init( "/home/graham_s/VirtualWorlds/projects/ou/stb.jl/etc/msc.ini")

    hhv :: VariableList = loadvariablelist( conn, "frs", "househol", 2017 )
    @assert length( hhv )[1] > 0
    adv :: VariableList = loadvariablelist( conn, "frs", "adult", 2017 )
    @assert length( adv )[1] > 0

    allv = merge( hhv, adv )
    println( make_enumerated_type( "Employment_Status", allv[:empstat], true, true ))

    # todo
    # Activities_Of_Daily_Living_Bool_Array
    # Council_Tax_Band_Type CTBAND Houshol

#    Employment_Status_ILO_Definition :: EMPSTATI
#    Ethnic_Group_Type :: ETHGRP [ETHGRPS - 2016/2017 only]
#    Gender_Type :: SEX
#    Health_Status_Self_Reported :: HEATHAD / HEATHCH adu
#    Marital_Status_Type :: MARITAL
#    Msc_Data_Enums.Qualification_Type :: DVHIQUAL
#    Region_Type :: GVTREGN
#    Socio_Economic_Grouping_Type :: NSSEC
#    Standard_Industrial_Classification_2007 :: SIC
#    Standard_Occupational_Classification :: SC2010HD
#    Tenure_Type :: tentyp2

    println( make_enumerated_type( "ILO_Employment", allv[:empstati], true, true )) # employment_status_ilo_definition
    println( make_enumerated_type( "Ethnic_Group", allv[:ethgr3], true, true )) # ethnic_group_type[ethgrps - 2016/2017 only]
    println( make_enumerated_type( "Ethnic_Scotland", allv[:ethgrps], true, true )) # ethnic_group_type[ethgrps - 2016/2017 only]
    println( make_enumerated_type( "Sex", allv[:sex], true, true )) # gender_type
    println( make_enumerated_type( "Health_Status", allv[:heathad], true, true )) # health_status_self_reported/ heathch adu
    println( make_enumerated_type( "Marital_Status", allv[:marital], true, true )) # marital_status_type
    println( make_enumerated_type( "Highest_Qualification", allv[:dvhiqual], true, true )) # msc_data_enums.qualification_type
    println( make_enumerated_type( "Standard_Region", allv[:gvtregn], true, true )) # region_type
    println( make_enumerated_type( "Socio_Economic_Group", allv[:nssec], true, true )) # socio_economic_grouping_type
    println( make_enumerated_type( "SIC_2007", allv[:sic], true, true )) # standard_industrial_classification_2007
    println( make_enumerated_type( "Standard_Occupational_Classification", allv[:soc2010], true, true )) # standard_occupational_classification2010hd
    println( make_enumerated_type( "Tenure_Type", allv[:tentyp2], true, true )) # tenure_type2
    println( make_enumerated_type( "CT_Band", allv[:ctband], true, true )) # Council_Tax_Band_Type

end

make_from_frs()
