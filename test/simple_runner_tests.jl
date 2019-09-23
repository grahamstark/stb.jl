using MiniTB
using Test
using TBComponents
using CSV
using DataFrames

include("../src/web/web_model_libs.jl" )

example_names, num_households = load_data( load_examples = true, load_main = true, start_year = 2017 )

hhlds_to_do = 15_000 # actually, just people

params = DEFAULT_PARAMS

@time results_frame = doonerun( params, hhlds_to_do )

CSV.write( "/home/graham_s/tmp/stb_test_results.tab", results_frame, delim='\t')
