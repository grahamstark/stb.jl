using CSV
using DataFrames
using Definitions

include( "../src/data_mapping/household_mapping_frs.jl")

household_name using CSV
using DataFrames
using Definitions= "model_households"
people_name = "model_people"

hh_dataset = CSV.File("$(MODEL_DATA_DIR)/$(household_name).tab", delim='\t' ) |> DataFrame
people_dataset = CSV.File("$(MODEL_DATA_DIR)/$(people_name).tab", delim='\t') |> DataFrame

scottish_hhlds = hh_dataset[(hh_dataset.region .== 299999999),:]
# fixme there's some nice one-line join for this
npeople = 0
nhhlds = size( scottish_hhlds)[1]
people = initialise_person(50_000)
for hh in 1:nhhlds
    npeople += 1
end
