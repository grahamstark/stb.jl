using Test
using CSV
using DataFrames
using Definitions

include( "../src/core/household.jl" )
include( "../src/data_mapping/hhld_from_frame.jl" )

@testset begin

    hhdata = CSV.File("/home/graham_s/tmp/model_households.tab", delim='\t') |> DataFrame
    hhpeople = CSV.File("/home/graham_s/tmp/model_people.tab", delim='\t') |> DataFrame

    some_pids = ((hhdata.hid.==1) .& (hhdata.data_year.==2017))
    hh1 = hhdata[1,:]

    map_hhld( hh1 )
end
