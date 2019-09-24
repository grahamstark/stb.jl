using MiniTB
using Test
using TBComponents
using CSV
using DataFrames
using StatsBase
using Utils

include("../src/web/web_model_libs.jl" )

example_names, num_households, num_people = load_data( load_examples = true, load_main = true, start_year = 2017 )

hhlds_to_do = num_households # 15_000 # actually, just people
people_to_do = num_people

params = DEFAULT_PARAMS

num_repeats = 50

json_out=missing

mr_edges = [0.001, 0.1, 0.25, 0.5, 0.75, 1.0, 9999.0]

for i in 1:1

    @time begin

        results = doonerun( params, num_households, num_people, num_repeats )
        println( "computing $num_households hhlds and $num_people people ")
        CSV.write( "/home/graham_s/tmp/stb_test_results.tab", results, delim='\t')

        deciles_1 = TBComponents.binify( results, 10, :weight, :net_income_1 )
        deciles_2 = TBComponents.binify( results, 10, :weight, :net_income_2 )

        poverty_line = deciles_1[5,3]*(2.0/3.0)
        growth = 0.02

        inequality_1 = TBComponents.makeinequality( results, :weight, :net_income_1 )
        inequality_2 = TBComponents.makeinequality( results, :weight, :net_income_2 )

        # println( "weight " )
        # println( results[!,:weight ])

        poverty_1 = TBComponents.makepoverty( results, poverty_line, growth, :weight, :net_income_1  )
        poverty_2 = TBComponents.makepoverty( results, poverty_line, growth, :weight, :net_income_2  )

        disallowmissing!( results )

        results.gainers = (((results.net_income_2 - results.net_income_1)./results.net_income_1).>=0.01).*results.weight
        results.losers = (((results.net_income_2 - results.net_income_1)./results.net_income_1).<= -0.01).*results.weight
        results.nc = ((abs.(results.net_income_2 - results.net_income_1)./results.net_income_1).< 0.01).*results.weight

        gainlose_by_thing = DataFrame(
            thing=levels( results.thing ),
            losers = counts(results.thing,fweights( results.losers )),
            nc= counts(results.thing,fweights( results.nc )),
            gainers = counts(results.thing,fweights( results.gainers )))
        gainlose_by_sex = DataFrame(
            sex=pretty.(levels( results.sex )),
            losers = counts(Int.(results.sex),fweights( results.losers )),
            nc= counts(Int.(results.sex),fweights( results.nc )),
            gainers = counts(Int.(results.sex),fweights( results.gainers )))

        metr_hist_1 = fit(Histogram,results.metr_1,Weights(results.weight),mr_edges)
        metr_hist_2 = fit(Histogram,results.metr_2,Weights(results.weight),mr_edges)

        res_tup = (
            gainlose_by_sex=gainlose_by_sex,
            gainlose_by_thing=gainlose_by_thing,
            poverty_1=poverty_1,
            poverty_2=poverty_2,
            inequality_1=inequality_1,
            inequality_2=inequality_2,
            metr_hist_1=metr_hist_1,
            metr_hist_2=metr_hist_2
        )

        if i == 1
            println( "   deciles_1 = $( deciles_1)" )
            println( "   deciles_2 = $( deciles_2)" )

            println( "   poverty_line = $(poverty_line)" )
            println( "   growth = $(growth)" )

            println( "   inequality_1 = $(inequality_1)" )
            println( "   inequality_2 = $(inequality_2)" )

            println( "   poverty_1 = $(poverty_1)" )
            println( "   poverty_2 = $(poverty_2)" )

            println( "   gainlose_by_sex = $(gainlose_by_sex)" )
            println( "   gainlose_by_thing = $(gainlose_by_thing)" )

            println( "   metr_hist_1= $metr_hist_1 ")
            println( "   metr_hist_2= $metr_hist_1 ")


        end # print 1st
        json_out = JSON.json( res_tup )
    end # timing block
end # iteration
