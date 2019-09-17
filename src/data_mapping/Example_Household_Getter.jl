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
    household_name :: AbstractString = "example_households",
    people_name :: AbstractString = "example_people" ) :: Vector{String}

    global KEYMAP
    global EXAMPLE_HOUSEHOLDS

    hh_dataset = CSV.File("$(MODEL_DATA_DIR)/$(household_name).tab", delim='\t') |> DataFrame
    people_dataset = CSV.File("$(MODEL_DATA_DIR)/$(people_name).tab", delim='\t') |> DataFrame
    npeople = size( people_dataset)[1]
    nhhlds = size( hh_dataset )[1]
    for hseq in 1:nhhlds
        hhf = hh_dataset[hseq,:]
        println( "name $(hhf.name)")
        println( typeof( hhf.name ))
        println( typeof( EXAMPLE_HOUSEHOLDS ))
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
