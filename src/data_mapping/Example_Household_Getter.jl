module Example_Household_Getter

using Model_Household
using DataFrames
using CSV

include( "hhld_from_frame.jl" )

export  initialise, get_household

EXAMPLE_HOUSEHOLDS = Dict{String,Household}()

KEYMAP = Vector{String}()


"""
return number of households available
"""
function initialise(
    ;
    household_name :: AbstractString = "example_households",
    people_name :: AbstractString = "example_people";
    start_year = -1 ) :: Vector{String}
    # FIXME this is a hack
    Year_Starts = [2015=(2,2), 2016=(19243,43560),2017=(38551,87612)]
    start_hh_row = 2
    start_pers_row = 2
    if start_year > 2015
        start_hh_row = Year_Starts[start_year][1]
        start_pers_row = Year_Starts[start_year][2]
    end
    global KEYMAP
    global EXAMPLE_HOUSEHOLDS

    hh_dataset = CSV.File("$(MODEL_DATA_DIR)/$(household_name).tab", delim='\t', datarow=start_hh_row ) |> DataFrame
    people_dataset = CSV.File("$(MODEL_DATA_DIR)/$(people_name).tab", delim='\t', datarow=start_pers_row ) |> DataFrame
    npeople = size( people_dataset)[1]
    nhhlds = size( hh_dataset )[1]
    for hseq in 1:nhhlds
        hhf = hh_dataset[hseq,:]
        push!( KEYMAP, hhf.name )
        EXAMPLE_HOUSEHOLDS[hhf.name] = load_hhld_from_frame( hseq, hhf, people_dataset )
    end
    KEYMAP
end

function example_names()
    global KEYMAP
    KEYMAP
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
