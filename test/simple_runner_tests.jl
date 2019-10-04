using MiniTB
using Test
using TBComponents
using CSV
using DataFrames
using StatsBase
using Utils

include("../src/web/web_model_libs.jl" )


print_test = false

example_names, num_households, num_people = load_data( load_examples = true, load_main = true, start_year = 2015 )

hhlds_to_do = num_households
people_to_do = num_people

params = deepcopy(DEFAULT_PARAMS)

num_repeats = 50

json_out=missing
results=missing

base_results = create_base_results( num_households, num_people )

@time begin

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
    end
end # summary_output.timing summary_output.blockt = JSON.json( summary_output )

print( JSON.json( summary_output ))
