module FRS_Household_Getter

include( "hhld_from_frame.jl" )

export  initialise, get_num_households, get_household

"""
return number of households available
"""
function initialise() :: Integer
    load_dataset()
    size(MODEL_HOUSEHOLDS)[1]
end

function get_household( pos :: Integer ) :: Household
    global MODEL_HOUSEHOLDS
    MODEL_HOUSEHOLDS[pos]
end

end
