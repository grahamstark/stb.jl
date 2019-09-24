using MiniTB
using Test
using TBComponents
using CSV
using DataFrames
using StatsBase
using Utils

include("../src/web/web_model_libs.jl" )


print_test = false

example_names, num_households, num_people = load_data( load_examples = true, load_main = true, start_year = 2017 )

hhlds_to_do = num_households
people_to_do = num_people

params = deepcopy(DEFAULT_PARAMS)

num_repeats = 50

json_out=missing
results=missing

base_results = doonerun( DEFAULT_PARAMS, num_households, num_people, num_repeats )

@time begin

    results = doonerun( params, num_households, num_people, num_repeats )
    summary_output, results = summarise_results( results, base_results )

    if print_test
        print( "   deciles_1 = $( summary_output.deciles_1)\n\n" )
        print( "   deciles_2 = $( summary_output.deciles_2)\n\n" )
        print( "   deciles_3 = $( summary_output.deciles_3)\n\n" )

        print( "   poverty_line = $(summary_output.poverty_line)\n\n" )

        print( "   inequality_1 = $(summary_output.inequality_1)\n\n" )
        print( "   inequality_2 = $(summary_output.inequality_2)\n\n" )
        print( "   inequality_3 = $(summary_output.inequality_3)\n\n" )

        print( "   poverty_1 = $(summary_output.poverty_1)\n\n" )
        print( "   poverty_2 = $(summary_output.poverty_2)\n\n" )
        print( "   poverty_3 = $(summary_output.poverty_3)\n\n" )

        print( "   gainlose_by_sex = $(summary_output.gainlose_by_sex)\n\n" )
        print( "   gainlose_by_thing = $(summary_output.gainlose_by_thing)\n\n" )

        print( "   metr_hist_1= $(summary_output.metr_hist_1)\n\n")
        print( "   metr_hist_2= $(summary_output.metr_hist_1)\n\n")
    end
end # summary_output.timing summary_output.blockt = JSON.json( summary_output )

print( JSON.json( summary_output ))
