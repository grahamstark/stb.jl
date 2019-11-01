# example 2
using Statistics
using Distributions
using DelimitedFiles
using VegaLite
using DataFrames

const INC_SIZE = 1_000
const EXERCISE_DIR="/home/graham_s/OU/DD226/docs/exercises/"
incomes = zeros( INC_SIZE )
for i in 1:INC_SIZE
    incomes[i] = 1_000*exp(randn()) # kinda log-normal
end
sort!( incomes )
println("mean  ", mean(incomes))
println( "median ", median(incomes))
println( "kurtosis ", kurtosis(incomes))

writedlm( "$EXERCISE_DIR/exercise_1.csv", incomes )

incframe = DataFrame( incomes=incomes )

plot_1 = incframe |>
 @vlplot(:bar,
    x={:incomes, bin={maxbins=40}},
    y="count()")

save( "$EXERCISE_DIR/exercise_1.svg", plot_1 )
