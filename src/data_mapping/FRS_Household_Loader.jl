module FRS_Household_Getter

include( "hhld_from_frame.jl" )

export  initialise, get_num_households, get_household

MODEL_HOUSEHOLDS=missing

function initialise( )
    global HOUSEHOLDS
    MODEL_HOUSEHOLDS = load_dataset()
end

function get_num_households()
    size(MODEL_HOUSEHOLDS)[1]
end

function get_household( hno :: Integer ) :: Household
    MODEL_HOUSEHOLDS[hno]
end

end
