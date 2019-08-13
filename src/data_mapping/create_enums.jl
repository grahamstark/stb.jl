#
using DDIMeta

function make_from_frs()

    conn = init( "../../etc/msc.ini")

    hhv :: VariableList = loadvariablelist( conn, "frs", "househol", 2015 )
    @assert length( hhv )[1] > 0
    adv :: VariableList = loadvariablelist( conn, "frs", "adult", 2015 )
    @assert length( adv )[1] > 0

    allv = merge( hhv, adv )
    println( make_enumerated_type( allv[:tentyp2], true, true ))
    println( make_enumerated_type( allv[:empstat], true, true ))
end

make_from_frs()
