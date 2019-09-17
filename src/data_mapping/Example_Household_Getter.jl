module Example_Household_Getter

include( "hhld_from_frame.jl" )

export  initialise, get_household

EXAMPLE_HOUSEHOLDS = Dict{AbstractString,Household}()

KEYMAP = Vector{AbstractString}()

"""
return number of households available
"""
function initialise(
    household_name :: AbstractString = "example_households",
    people_name :: AbstractString = "example_people" ) :: Integer

    global KEYMAP
    global EXAMPLE_HOUSEHOLDS

    hh_dataset = CSV.File("$(MODEL_DATA_DIR)/$(household_name).tab", delim='\t') |> DataFrame
    people_dataset = CSV.File("$(MODEL_DATA_DIR)/$(people_name).tab", delim='\t') |> DataFrame
    npeople = size( people_dataset)[1]
    nhhlds = size( hh_dataset )[1]
    EXAMPLE_HOUSEHOLDS = Vector{Union{Missing,Household}}(missing,nhhlds)
    for hseq in 1:nhhlds
        hhf = hh_dataset[hseq,:]
        push!( KEYMAP, hhf.name )
        EXAMPLE_HOUSEHOLDS[hhf.name] = load_hhld_from_frame( hseq, hhf, people_dataset )
    end
    size(EXAMPLE_HOUSEHOLDS)[1]
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
