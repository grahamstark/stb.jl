using Test
using CSV
using DataFrames
using Definitions
using Uprating
using Model_Household
using FRS_Household_Getter
include( "../src/data_mapping/hhld_from_frame.jl")
#
# Low-ish level tests of loading households from frames
#
@testset begin

    hhdata = CSV.File("$(MODEL_DATA_DIR)/model_households.tab", delim='\t') |> DataFrame
    nhhlds = size( hhdata )[1]
    hhpeople = CSV.File("$(MODEL_DATA_DIR)/model_people.tab", delim='\t') |> DataFrame
    some_pids = ((hhdata.hid.==1) .& (hhdata.data_year.==2017))
    npeople = size( hhpeople)[1]
    hhlds_a = Vector{Union{Missing,Household}}(missing,nhhlds)

    @time for h in 1:nhhlds
        hh1 = hhdata[h,:]
        mhh = map_hhld( hh1 )
        ## hhlds_a[h] = mhh
        if h % 10_000 == 0
            println( "$mhh")
        end
    end

    @time for p in 1:npeople
        p1 = hhpeople[p,:]
        mp = map_person( p1 )
        if p % 1_000 == 0
            println( "$mp")
        end
    end

    @time for h in 1:nhhlds
        hh1 = hhdata[h,:]
        mhh = load_hhld_from_frame( hh1, hhpeople )
        hhlds_a[h] = mhh
        if h % 10_000 == 0
            println( "$mhh")
        end
    end

    @time for h in 1:nhhlds
        uprate!( hhlds_a[h])
        if h % 10_000 == 0
            println( hhlds_a[h] )
        end
    end

    println(sizeof( hhlds_a ))

end
