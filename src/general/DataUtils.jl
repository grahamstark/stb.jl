module DataUtils

import DataFrames: DataFrame
import Statistics: mean, median, std, quantile
import Parameters: @with_kw
using Definitions

export summarise_over_positive, add_to!
export initialise, MinMaxes, show

function initialise( n :: Real = 0.0 )::Incomes_Dict
    dict = Incomes_Dict()
    for i in instances( Incomes_Type )
        dict[i] = n
    end
    dict
end

@with_kw mutable struct MinMaxes
    max ::Incomes_Dict=initialise( -99999999999999999.9)
    min ::Incomes_Dict=initialise( 99999999999999.999 )
    sum ::Incomes_Dict=initialise( 0.0 )
    n :: Integer = 0
    poscounts ::Incomes_Dict = Incomes_Dict=initialise( 0.0 )
end

function add_to!( mms :: MinMaxes, addn :: Incomes_Dict )
    kys = keys( addn )
    mms.n += 1
    for k in kys
        mms.max[k] = max( mms.max[k], addn[k] )
        mms.min[k] = min( mms.min[k], addn[k] )
        mms.sum[k] += addn[k]
        if addn[k]>0
            mms.poscounts[k]+= 1.0
        end
    end
end

import Base.show

function show( io::IO, mms :: MinMaxes )
    s = ""
    for k in instances( Incomes_Type )
        maxx = mms.max[k]
        minx = mms.min[k]
        pc = mms.poscounts[k]
        if pc>0
            mean = mms.sum[k] / pc
        else
            mean = 0.0
        end
        show( io, "$k = (max=$(maxx), min=$(minx), mean=$mean poscounts=$pc) \n");
    end
end

function show( mms :: MinMaxes )
    show( stdout, mms )
end

"""
Means, etc. over just the positive and non-missing elements of a df column
"""
function summarise_over_positive( df::DataFrame, col::Symbol )::NamedTuple
   m = (df[!,col].!== missing) .&
       (df[!,col] .> 0.0)
   sz = size(df[m,col])[1]
   if sz > 0
       (
       num_positive = sz,
       frame_size = size(df[!,col])[1],
       max=maximum(df[m,col]),
       min=minimum(df[m,col]),
       mean=mean(df[m,col]),
       stdev=std(df[m,col]),
       deciles = quantile( df[m,col], [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9] )
      )
   else
      ( num_positive = 0,
        frame_size = size(df[!,col])[1],
        max=0,
        min=0,
        mean=0,
        stdev=0,
        deciles=[] )
   end
end

end
