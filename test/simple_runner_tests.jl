using MiniTB
using Test
using TBComponents

include("../src/web/web_model_libs.jl" )

example_names, num_households = load_data( load_examples = true, load_main = true, start_year = 2017 )

hhlds_to_do = 15_000

params = DEFAULT_PARAMS

results_frame = doonerun( params, hhlds_to_do )
