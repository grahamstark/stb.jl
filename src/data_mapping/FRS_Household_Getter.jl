module FRS_Household_Getter

include( "hhld_from_frame.jl" )

export  initialise, get_household

MODEL_HOUSEHOLDS=missing

"""
return number of households available
"""
function initialise(
        ;
        household_name :: AbstractString = "model_households",
        people_name :: AbstractString = "model_people",
        start_year = -1 ) :: Integer

    global MODEL_HOUSEHOLDS
    # FIXME this is a hack
    Year_Starts = Dict(2015=>(2,2), 2016=>(19243,43560),2017=>(38551,87612))
    start_hh_row = 2
    start_pers_row = 2
    if start_year > 2015
        start_hh_row = Year_Starts[start_year][1]
        start_pers_row = Year_Starts[start_year][2]
    end
    hh_dataset = CSV.File("$(MODEL_DATA_DIR)/$(household_name).tab", delim='\t', datarow=start_hh_row) |> DataFrame
    people_dataset = CSV.File("$(MODEL_DATA_DIR)/$(people_name).tab", delim='\t', datarow=start_pers_row) |> DataFrame
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
