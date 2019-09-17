module Example_Household_Getter

include( "hhld_from_frame.jl" )

export  initialise, get_household

EXAMPLE_HOUSEHOLDS = Dict{AbstractString,Household}()

KEYMAP = Vector{AbstractString}()

"""
return number of households available
"""
function initialise() :: Integer
    load_dataset()
    size(EXAMPLE_HOUSEHOLDS)[1]
end

function get_household( pos :: Integer ) :: Household
    global EXAMPLE_HOUSEHOLDS
    global KEYMAP
    key = KEYMAP[pos]
    EXAMPLE_HOUSEHOLDS[key]
end

function get_household( name :: AbstractString ) :: Household
    global EXAMPLE_HOUSEHOLDS
    EXAMPLE_HOUSEHOLDS[name]
end


end
