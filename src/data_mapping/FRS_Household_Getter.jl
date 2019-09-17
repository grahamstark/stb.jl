module FRS_Household_Getter

include( "hhld_from_frame.jl" )

export  initialise, get_num_households, get_household

function initialise( )
    load_dataset()
end

function get_num_households()
    size(MODEL_HOUSEHOLDS)[1]
end

function get_household( pos :: Integer ) :: Household
    MODEL_HOUSEHOLDS[pos]
end

end
