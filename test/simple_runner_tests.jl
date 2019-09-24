using MiniTB
using Test
using TBComponents
using CSV
using DataFrames
using StatsBase
using Utils

include("../src/web/web_model_libs.jl" )

mr_edges = [-99999.99, 0.0, 0.1, 0.25, 0.5, 0.75, 1.0, 9999.0]
growth = 0.02


function summarise_results( base_results::DataFrame, results :: DataFrame )::NamedTuple
    global mr_edges, growth
    basenames = names( base_results )
    basenames = addsysnotoname( basenames, 1 )
    names!( base_results, basenames )

    n_names = names( results )
    n_names = addsysnotoname( n_names, 2 )
    names!( results, n_names )
    results = hcat( base_results, results )
    @assert results.pid_1 == results.pid_2
    println( "computing $num_households hhlds and $num_people people ")
    CSV.write( "/home/graham_s/tmp/stb_test_results.tab", results, delim='\t')


    deciles_1 = TBComponents.binify( results, 10, :weight_1, :net_income_1 )
    deciles_2 = TBComponents.binify( results, 10, :weight_1, :net_income_2 )

    poverty_line = deciles_1[5,3]*(2.0/3.0)

    inequality_1 = TBComponents.makeinequality( results, :weight_1, :net_income_1 )
    inequality_2 = TBComponents.makeinequality( results, :weight_1, :net_income_2 )

    poverty_1 = TBComponents.makepoverty( results, poverty_line, growth, :weight_1, :net_income_1  )
    poverty_2 = TBComponents.makepoverty( results, poverty_line, growth, :weight_1, :net_income_2  )

    disallowmissing!( results )

    results.gainers = (((results.net_income_2 - results.net_income_1)./results.net_income_1).>=0.01).*results.weight_1
    results.losers = (((results.net_income_2 - results.net_income_1)./results.net_income_1).<= -0.01).*results.weight_1
    results.nc = ((abs.(results.net_income_2 - results.net_income_1)./results.net_income_1).< 0.01).*results.weight_1

    gainlose_by_thing = DataFrame(
        thing=levels( results.thing_1 ),
        losers = counts(results.thing_1,fweights( results.losers )),
        nc= counts(results.thing_1,fweights( results.nc )),
        gainers = counts(results.thing_1,fweights( results.gainers )))
    gainlose_by_sex = DataFrame(
        sex=pretty.(levels( results.sex_1 )),
        losers = counts(Int.(results.sex_1),fweights( results.losers )),
        nc= counts(Int.(results.sex_1),fweights( results.nc )),
        gainers = counts(Int.(results.sex_1),fweights( results.gainers )))

    metr_hist_1 = fit(Histogram,results.metr_1,Weights(results.weight_1),mr_edges,closed=:right)
    metr_hist_2 = fit(Histogram,results.metr_2,Weights(results.weight_1),mr_edges,closed=:right)
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
    res_tup
end

example_names, num_households, num_people = load_data( load_examples = true, load_main = true, start_year = 2017 )

hhlds_to_do = num_households # 15_000 # actually, just people
people_to_do = num_people

params = deepcopy(DEFAULT_PARAMS)

num_repeats = 50

json_out=missing
results=missing

base_results = doonerun( DEFAULT_PARAMS, num_households, num_people, num_repeats )

@time begin

    results = doonerun( params, num_households, num_people, num_repeats )

    res_tup = summarise_results( results )

    if false
        println( "   deciles_1 = $( res_tup.deciles_1)" )
        println( "   deciles_2 = $( res_tup.deciles_2)" )

        println( "   poverty_line = $(res_tup.poverty_line)" )
        # println# ( "   growth = res_tup.$(growth)" )

        println( "   inequality_1 = $(res_tup.inequality_1)" )
        println( "   inequality_2 = $(res_tup.inequality_2)" )

        println( "   poverty_1 = $(res_tup.poverty_1)" )
        println( "   poverty_2 = $(res_tup.poverty_2)" )

        println( "   gainlose_by_sex = $(res_tup.gainlose_by_sex)" )
        println( "   gainlose_by_thing = $(res_tup.gainlose_by_thing)" )

        println( "   metr_hist_1= $res_tup.metr_hist_1")
        println( "   metr_hist_2= $res_tup.metr_hist_1")
    end
end # res_tup.timing res_tup.blockt = JSON.json( res_tup )
println( json_out )
