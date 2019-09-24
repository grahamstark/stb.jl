using JSON
using FRS_Household_Getter
using Example_Household_Getter
using Model_Household
using Utils
using MiniTB
using DataFrames
using TBComponents
using Definitions



function load_data(; load_examples::Bool, load_main :: Bool, start_year = 2017 )
   example_names = Vector{AbstractString}()
   num_households = 0
   if load_examples
      example_names = Example_Household_Getter.initialise()
   end
   if load_main
      rc = @timed begin
         num_households,num_people,nhh2 = FRS_Household_Getter.initialise( start_year = start_year )
      end
      mb = trunc(Integer, rc[3] / 1024^2)
      println("loaded data; load time $(rc[2]); memory used $(mb)mb; loaded $num_households households\nready...")
   end
   (example_names, num_households, num_people )
end

mr_edges = [-99999.99, 0.0, 0.1, 0.25, 0.5, 0.75, 1.0, 9999.0]
growth = 0.02

function poverty_targetting_adder( dfr :: DataFrameRow, data :: Dict ) :: Real
   which = data[:which_element]
   if dfr.net_income_1 <= data[:poverty_line]
      return dfr[which]*dfr.weight_1
   end
   return 0.0
end

function characteristic_targetting_adder( dfr :: DataFrameRow, data :: Dict ) :: Real
   which = data[:which_element]
   characteristic = data[:characteristic]
   if dfr[characteristic] in data[:targets]
      return dfr[which]*dfr.weight_1
   end
   return 0.0
end

function operate_on_frame( results :: DataFrame, adder, data::Dict )
   n = size( results )[1]
   total = 0
   for i in 1:n
      total += adder( results[i,:], data )
   end
   total
end

function summarise_results( base_results::DataFrame, results :: DataFrame )::Tuple
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
    deciles_3 =  deciles_2 - deciles_1

    poverty_line = deciles_1[5,3]*(2.0/3.0)

    inequality_1 = TBComponents.makeinequality( results, :weight_1, :net_income_1 )
    inequality_2 = TBComponents.makeinequality( results, :weight_1, :net_income_2 )
    inequality_3 =  diff_between( inequality_1, inequality_2 )

    poverty_1 = TBComponents.makepoverty( results, poverty_line, growth, :weight_1, :net_income_1  )
    poverty_2 = TBComponents.makepoverty( results, poverty_line, growth, :weight_1, :net_income_2  )
    poverty_3 =  diff_between( poverty_1, poverty_2 )

    totals_1 = zeros(4)
    totals_1[1]=sum(results[!,:total_taxes_1].*results[!,:weight_1])
    totals_1[2]=sum(results[!,:total_benefits_1].*results[!,:weight_1])
    totals_1[3]=sum(results[!,:benefit1_1].*results[!,:weight_1])
    totals_1[4]=sum(results[!,:benefit2_1].*results[!,:weight_1])
    totals_2 = zeros(4)
    totals_2[1]=sum(results[!,:total_taxes_2].*results[!,:weight_1])
    totals_2[2]=sum(results[!,:total_benefits_2].*results[!,:weight_1])
    totals_2[3]=sum(results[!,:benefit1_2].*results[!,:weight_1])
    totals_2[4]=sum(results[!,:benefit2_2].*results[!,:weight_1])
    totals_3 = totals_2-totals_1
    totals_names=["Total Taxes","Total Benefits","Benefit1", "Benefit2"]

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

    metr_hist_1 = fit(Histogram,results.metr_1,Weights(results.weight_1),mr_edges,closed=:right).weights
    metr_hist_2 = fit(Histogram,results.metr_2,Weights(results.weight_1),mr_edges,closed=:right).weights
    metr_hist_3 = metr_hist_2-metr_hist_1

    targetting_benefit1_1 = operate_on_frame( results, poverty_targetting_adder,
        Dict(
         :which_element=>:benefit1_1,
         :poverty_line=>poverty_line
        )
    )
    targetting_benefit1_1 /= totals_1[3]

    targetting_benefit1_2 = operate_on_frame( results, poverty_targetting_adder,
        Dict(
         :which_element=>:benefit1_2,
         :poverty_line=>poverty_line
        )
    )
    targetting_benefit1_2 /= totals_2[3]

    targetting_benefit2_1 = operate_on_frame( results, poverty_targetting_adder,
        Dict(
         :which_element=>:benefit2_1,
         :poverty_line=>poverty_line
        )
    )
    targetting_benefit2_1 /= totals_1[4]

    targetting_benefit2_2 = operate_on_frame( results, poverty_targetting_adder,
        Dict(
         :which_element=>:benefit2_2,
         :poverty_line=>poverty_line
        )
    )
    targetting_benefit2_2 /= totals_2[4]

    targetting_benefit1_3 = targetting_benefit1_2 - targetting_benefit1_1
    targetting_benefit2_3 = targetting_benefit2_2 - targetting_benefit2_1


    summary_output = (
        gainlose_by_sex=gainlose_by_sex,
        gainlose_by_thing=gainlose_by_thing,

        poverty_1=poverty_1,
        poverty_2=poverty_2,
        poverty_3=poverty_3,

        inequality_1=inequality_1,
        inequality_2=inequality_2,
        inequality_3=inequality_3,

        metr_hist_1=metr_hist_1,
        metr_hist_2=metr_hist_2,
        metr_hist_3=metr_hist_3,
        metr_axis=mr_edges,

        deciles_1=deciles_1,
        deciles_2=deciles_2,
        deciles_3=deciles_3,

        targetting_benefit1_1=targetting_benefit1_1,
        targetting_benefit1_2=targetting_benefit1_2,
        targetting_benefit1_3=targetting_benefit1_3,

        targetting_benefit2_1=targetting_benefit2_1,
        targetting_benefit2_2=targetting_benefit2_2,
        targetting_benefit2_3=targetting_benefit2_3,

        totals_1=totals_1,
        totals_2=totals_2,
        totals_3=totals_3,
        totals_names=totals_names,
        poverty_line=poverty_line,
        growth_assumption=growth
    )
    (summary_output, results )
end

function maptoexample( modelpers :: Model_Household.Person ) :: MiniTB.Person
   inc = 0.0
   for (k,v) in modelpers.income
      inc += v
   end
   sex = modelpers.pid % 2 == 0 ? MiniTB.Male : MiniTB.Female
   MiniTB.Person( modelpers.pid, inc, modelpers.age, sex )
end

function local_getnet(data :: Dict, gross::Real)::Real
   person = data[:person]
   person.wage = gross
   rc = MiniTB.calculate( person, data[:params ] )
   return rc[:netincome]
end

function local_makebc( person :: MiniTB.Person, tbparams :: MiniTB.Parameters )
   data = Dict( :person=>person, :params=>tbparams )
   pointstoarray( TBComponents.makebc( data, local_getnet ))
end


function make_results_frame( n :: Integer ) :: DataFrame
   DataFrame(
     pid = Vector{Union{BigInt,Missing}}(missing, n),
     weight = Vector{Union{Real,Missing}}(missing, n),
     sex = Vector{Union{Gender,Missing}}(missing, n),
     thing = Vector{Union{Integer,Missing}}(missing, n),
     gross_income = Vector{Union{Real,Missing}}(missing, n),

     total_taxes = Vector{Union{Real,Missing}}(missing, n),
     total_benefits = Vector{Union{Real,Missing}}(missing, n),
     tax = Vector{Union{Real,Missing}}(missing, n),
     benefit1 = Vector{Union{Real,Missing}}(missing, n),
     benefit2 = Vector{Union{Real,Missing}}(missing, n),
     net_income = Vector{Union{Real,Missing}}(missing, n),
     metr = Vector{Union{Real,Missing}}(missing, n))
end

function doonerun( tbparams::MiniTB.Parameters, num_households :: Integer, num_people :: Integer, num_repeats :: Integer ) :: DataFrame
   results = make_results_frame( num_people )
   pnum = 0
   for hhno in 1:num_households
      frshh = FRS_Household_Getter.get_household( hhno )
      for (pid,frsperson) in frshh.people
         pnum += 1
         if pnum > num_people
            # break
            @goto end_of_calcs
         end
         experson = maptoexample( frsperson )
         rc1 = missing
         rc2 = missing
         for i in 1:num_repeats
            rc1 = MiniTB.calculate( experson, DEFAULT_PARAMS )
            rc2 = MiniTB.calculate( experson, tbparams )
         end
         res = results[pnum,:]
         res.pid = experson.pid
         res.sex = experson.sex
         res.gross_income = experson.wage
         res.weight = frshh.weight
         res.thing = rand(1:10)
         res.tax = rc1[:tax]
         res.benefit1 = rc1[:benefit1]
         res.benefit2 = rc1[:benefit2]
         res.total_taxes= rc1[:tax]
         res.total_benefits = rc1[:benefit2]+rc1[:benefit1]
         res.net_income = rc1[:netincome]
         res.metr = rc1[:metr]
      end # people
   end # hhlds
   @label end_of_calcs
   ran = rand()
   print("Done; people $pnum rand=$ran\n")
   results[1:pnum-1,:];
end
