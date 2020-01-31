import DataFrames: DataFrame
import Statistics: mean, median, std, quantile

module DataUtils

export summarise_over_positive

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
