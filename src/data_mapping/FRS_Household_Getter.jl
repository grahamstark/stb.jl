module FRS_Household_Getter

include( "hhld_from_frame.jl" )

export  initialise, get_household

MODEL_HOUSEHOLDS=missing

"""
return number of households available
"""
function initialise() :: Integer

    global MODEL_HOUSEHOLDS
    hh_dataset = CSV.File("$(MODEL_DATA_DIR)/model_households.tab", delim='\t') |> DataFrame
    people_dataset = CSV.File("$(MODEL_DATA_DIR)/model_people.tab", delim='\t') |> DataFrame
    npeople = size( people_dataset)[1]
    nhhlds = size( hh_dataset )[1]
    MODEL_HOUSEHOLDS = Vector{Union{Missing,Household}}(missing,nhhlds)
    for hseq in 1:nhhlds
        MODEL_HOUSEHOLDS[hseq] = load_hhld_from_frame( hseq, hh_dataset[hseq,:], people_dataset )
        uprate!( MODEL_HOUSEHOLDS[hseq] )
    end
    size(MODEL_HOUSEHOLDS)[1]
end

function get_household( pos :: Integer ) :: Household
    global MODEL_HOUSEHOLDS
    MODEL_HOUSEHOLDS[pos]
end

end
