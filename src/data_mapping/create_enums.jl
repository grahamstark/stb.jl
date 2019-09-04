#
using DDIMeta

function make_from_frs()

    conn = init( "/home/graham_s/VirtualWorlds/projects/ou/stb.jl/etc/msc.ini")

    hhv :: VariableList = loadvariablelist( conn, "frs", "househol", 2017 )
    @assert length( hhv )[1] > 0
    adv :: VariableList = loadvariablelist( conn, "frs", "adult", 2017 )
    @assert length( adv )[1] > 0

    allv = merge( hhv, adv )
    println( make_enumerated_type( allv[:tentyp2], true, true ))
    println( make_enumerated_type( allv[:empstat], true, true ))

    # todo
    Activities_Of_Daily_Living_Bool_Array
    Council_Tax_Band_Type CTBAND Houshol

    Employment_Status_ILO_Definition :: EMPSTATI
    Ethnic_Group_Type :: ETHGRP [ETHGRPS - 2016/2017 only]
    Gender_Type :: SEX
    Health_Status_Self_Reported :: HEATHAD / HEATHCH adu
    Marital_Status_Type :: MARITAL
    Msc_Data_Enums.Qualification_Type :: DVHIQUAL
    Region_Type :: GVTREGN
    Socio_Economic_Grouping_Type :: 
    Standard_Industrial_Classification_2007
    Standard_Occupational_Classification
    Tenure_Type



end

make_from_frs()
