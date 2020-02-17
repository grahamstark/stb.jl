using MiniTB
using Test
using TBComponents
using CSV
using DataFrames
using StatsBase
using Utils
using BenchmarkTools

include("../src/web/web_model_libs.jl" )


print_test = false

BenchmarkTools.DEFAULT_PARAMETERS.seconds = 120
BenchmarkTools.DEFAULT_PARAMETERS.samples = 2

function basic_run( params, num_households, num_people, base_results)

    global print_test

    num_repeats = 100
    json_out=missing
    results=missing
    params.it_rate[1] = 0.66
    results = doonerun( params, num_households, num_people, num_repeats )
    summary_output = summarise_results!( results=results, base_results=base_results )

    if print_test
        print( "   deciles = $( summary_output.deciles)\n\n" )

        print( "   poverty_line = $(summary_output.poverty_line)\n\n" )

        print( "   inequality = $(summary_output.inequality)\n\n" )

        print( "   poverty = $(summary_output.poverty)\n\n" )

        print( "   gainlose_by_sex = $(summary_output.gainlose_by_sex)\n\n" )
        print( "   gainlose_by_thing = $(summary_output.gainlose_by_thing)\n\n" )

        print( "   metr_histogram= $(summary_output.metr_histogram)\n\n")
        println( "SUMMARY OUTPUT")
        println( summary_output )
        println( "as JSON")
        println( JSON.json( summary_output ))
    end

end # summary_output.timing summary_output.blockt = JSON.json( summary_output )

example_names, num_households, num_people = load_data( load_examples = true, load_main = true, start_year = 2015 )

params = deepcopy(DEFAULT_PARAMS)

base_results = create_base_results( num_households, num_people )

t = @benchmark basic_run( params, num_households, num_people, base_results ) seconds=120 samples=10 evals=1

print(t)
