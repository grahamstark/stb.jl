using MiniTB
using Test
using TBComponents
using CSV
using DataFrames

include("../src/web/web_model_libs.jl" )

example_names, num_households = load_data( load_examples = true, load_main = true, start_year = 2017 )

hhlds_to_do = 15_000 # actually, just people

params = DEFAULT_PARAMS

@time results = doonerun( params, hhlds_to_do )

CSV.write( "/home/graham_s/tmp/stb_test_results.tab", results, delim='\t')

@time begin

    deciles_1 = TBComponents.binify( results, 10, :weight, :net_income_1 )
    deciles_2 = TBComponents.binify( results, 10, :weight, :net_income_2 )

    poverty_line = deciles_1[5,3]*(2.0/3.0)
    growth = 0.02

    inequality_1 = TBComponents.makeinequality( results, :weight, :net_income_1 )
    inequality_2 = TBComponents.makeinequality( results, :weight, :net_income_2 )

    println( "weight " )
    println( results[!,:weight ])

    poverty_1 = TBComponents.makepoverty( results, poverty_line, growth, :weight, :net_income_1  )
    poverty_2 = TBComponents.makepoverty( results, poverty_line, growth, :weight, :net_income_2  )

    println( "   deciles_1 = $( deciles_1)" )
    println( "   deciles_2 = $( deciles_2)" )

    println( "   poverty_line = $(poverty_line)" )
    println( "   growth = $(growth)" )

    println( "   inequality_1 = $(inequality_1)" )
    println( "   inequality_2 = $(inequality_2)" )

    println( "   poverty_1 = $(poverty_1)" )
    println( "   poverty_2 = $(poverty_2)" )


end
