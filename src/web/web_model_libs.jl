using JSON
using FRS_Household_Getter
using Example_Household_Getter
using Model_Household
using Utils
using MiniTB
using DataFrames
using TBComponents
using Definitions
using CSV
using StatsBase

function load_data(; load_examples::Bool, load_main :: Bool, start_year = 2015 )
   example_names = Vector{AbstractString}()
   num_households = 0
   if load_examples
      example_names = Example_Household_Getter.initialise()
   end
   if load_main
      rc = @timed begin
         num_households,num_people,nhh2 =
            FRS_Household_Getter.initialise(
            household_name = "model_households_scotland",
            people_name    = "model_people_scotland",
            start_year = start_year )
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

function add_targetting( results :: DataFrame, total_spend:: AbstractArray, item_name :: AbstractString, poverty_line :: Real ) :: AbstractArray
    targetting = zeros(3)
    for sys in 1:2
        key = Symbol( "$(item_name)_$sys" )
        on_target = operate_on_frame( results, poverty_targetting_adder,
            Dict(
             :which_element=>key,
             :poverty_line=>poverty_line
            )
        )
        targetting[sys] = on_target
    end
    targetting[3] = targetting[2]-targetting[1]
    for sys in 1:3
        if total_spend[sys] > 0
            targetting[sys] /= total_spend[sys]
            targetting[sys] *= 100.0
        end
    end # loop to props
    targetting
end


function summarise_results!(; results::DataFrame, base_results :: DataFrame )::NamedTuple
    global mr_edges, growth
    basenames = names( base_results )
    basenames_2 = addsysnotoname( basenames, 1 )
    names!( base_results, basenames_2 )

    n_names = names( results )
    n_names = addsysnotoname( n_names, 2 )
    names!( results, n_names )
    results = hcat( base_results, results )
    names!( base_results, basenames ) # restore names in base run FIXME this needs synchronized
    @assert results.pid_1 == results.pid_2
    println( "computing $num_households hhlds and $num_people people ")
    CSV.write( "/home/graham_s/tmp/stb_test_results.tab", results, delim='\t')

    deciles = []
    push!( deciles, TBComponents.binify( results, 10, :weight_1, :net_income_1 ))
    push!( deciles, TBComponents.binify( results, 10, :weight_1, :net_income_2 ))
    push!( deciles, deciles[2] - deciles[1] )

    poverty_line = deciles[1][5,3]*(2.0/3.0)

    inequality = []
    push!( inequality, TBComponents.makeinequality( results, :weight_1, :net_income_1 ))
    push!( inequality, TBComponents.makeinequality( results, :weight_1, :net_income_2 ))
    push!( inequality, diff_between( inequality[2], inequality[1] ))

    poverty = []
    push!(poverty, TBComponents.makepoverty( results, poverty_line, growth, :weight_1, :net_income_1  ))
    push!( poverty, TBComponents.makepoverty( results, poverty_line, growth, :weight_1, :net_income_2  ))
    push!( poverty, diff_between( poverty[2], poverty[1] ))

    totals = []
    totals_1 = zeros(6)
    totals_1[1]=sum(results[!,:total_taxes_1].*results[!,:weight_1])
    totals_1[2]=sum(results[!,:total_benefits_1].*results[!,:weight_1])
    totals_1[3]=sum(results[!,:benefit1_1].*results[!,:weight_1])
    totals_1[4]=sum(results[!,:benefit2_1].*results[!,:weight_1])
    totals_1[5]=sum(results[!,:basic_income_1].*results[!,:weight_1])
    totals_1[6]=sum(results[!,:net_income_1].*results[!,:weight_1]) # FIXME not true if we have min wage or (maybe) indirect taxes

    totals_2 = zeros(6)
    totals_2[1]=sum(results[!,:total_taxes_2].*results[!,:weight_1])
    totals_2[2]=sum(results[!,:total_benefits_2].*results[!,:weight_1])
    totals_2[3]=sum(results[!,:benefit1_2].*results[!,:weight_1])
    totals_2[4]=sum(results[!,:benefit2_2].*results[!,:weight_1])
    totals_2[5]=sum(results[!,:basic_income_2].*results[!,:weight_1])
    totals_2[6]=sum(results[!,:net_income_2].*results[!,:weight_1])

    totals_3 = totals_2-totals_1

    push!( totals, totals_1 )
    push!( totals, totals_2 )
    push!( totals, totals_3 )
    totals_names=["Total Taxes","Total Benefits","Benefit1", "Benefit2", "Basic Income","Net Incomes"]

    disallowmissing!( results )

    # these are for the gain lose weights below
    results.gainers = (((results.net_income_2 - results.net_income_1)./results.net_income_1).>=0.01).*results.weight_1
    results.losers = (((results.net_income_2 - results.net_income_1)./results.net_income_1).<= -0.01).*results.weight_1
    results.nc = ((abs.(results.net_income_2 - results.net_income_1)./results.net_income_1).< 0.01).*results.weight_1

    gainlose_totals = (
        losers = sum( results.losers ),
        nc = sum( results.nc ),
        gainers = sum( results.losers ))

    gainlose_by_thing = (
        thing=levels( results.thing_1 ),
        losers = counts(results.thing_1,fweights( results.losers )),
        nc= counts(results.thing_1,fweights( results.nc )),
        gainers = counts(results.thing_1,fweights( results.gainers )))
    gainlose_by_sex = (
        sex=pretty.(levels( results.sex_1 )),
        losers = counts(Int.(results.sex_1),fweights( results.losers )),
        nc= counts(Int.(results.sex_1),fweights( results.nc )),
        gainers = counts(Int.(results.sex_1),fweights( results.gainers )))

    metr_histogram = []
    push!( metr_histogram, fit(Histogram,results.metr_1,Weights(results.weight_1),mr_edges,closed=:right).weights )
    push!( metr_histogram, fit(Histogram,results.metr_2,Weights(results.weight_1),mr_edges,closed=:right).weights )
    push!( metr_histogram, metr_histogram[2]-metr_histogram[1] )

    targetting_benefit1 = add_targetting( results, [totals[1][3],totals[2][3],totals[3][3]], "benefit1", poverty_line )
    targetting_benefit2 = add_targetting( results, [totals[1][4],totals[2][4],totals[3][4]], "benefit2", poverty_line )
    targetting_basic_income = add_targetting( results, [totals[1][5],totals[2][5],totals[3][5]], "basic_income", poverty_line )

    totals .*= WEEKS_PER_YEAR # annualise

    summary_output = (
        gainlose_totals=gainlose_totals,
        gainlose_by_sex=gainlose_by_sex,
        gainlose_by_thing=gainlose_by_thing,

        poverty=poverty,

        inequality=inequality,

        metr_histogram=metr_histogram,
        metr_axis=mr_edges,

        deciles=deciles,

        targetting_benefit1=targetting_benefit1,
        targetting_benefit2=targetting_benefit2,
        targetting_basic_income=targetting_basic_income,

        totals=totals,
        totals_names=totals_names,
        poverty_line=poverty_line,
        growth_assumption=growth
    )
    summary_output
end

function maptoexample( modelpers :: Model_Household.Person ) :: MiniTB.Person
   inc = 0.0
   for (k,v) in modelpers.income
      inc += v
   end
   sex = MiniTB.Female
   if modelpers.sex == Definitions.Male ## easier way?
      sex = MiniTB.Male
   end
   MiniTB.Person( modelpers.pid, inc, modelpers.usual_hours_worked, modelpers.age, sex )
end

function local_getnet(data :: Dict, gross::Real)::Real
   person = data[:person]
   person.wage = gross
   person.hours = gross/MiniTB.DEFAULT_WAGE
   rc = MiniTB.calculate_internal( person, data[:params ] )
   return rc[:netincome]
end

function local_makebc( person :: MiniTB.Person, tbparams :: MiniTB.Parameters ) :: NamedTuple
   data = Dict( :person=>person, :params=>tbparams )
   bc = TBComponents.makebc( data, local_getnet )
   annotations = annotate_bc( bc )
   ( points = pointstoarray( bc ), annotations = annotations )
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
     basic_income = Vector{Union{Real,Missing}}(missing, n),
     net_income = Vector{Union{Real,Missing}}(missing, n),
     metr = Vector{Union{Real,Missing}}(missing, n),
     tax_credit = Vector{Union{Real,Missing}}(missing, n))
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
         rc = nothing
         for i in 1:num_repeats
            rc = MiniTB.calculate( experson, tbparams )
         end
         res = results[pnum,:]
         res.pid = experson.pid
         res.sex = experson.sex
         res.gross_income = experson.wage
         res.weight = frshh.weight
         res.thing = rand(1:10)
         res.tax = rc[:tax]
         res.benefit1 = rc[:benefit1]
         res.benefit2 = rc[:benefit2]
         res.basic_income = rc[:basic_income]

         res.total_taxes= rc[:tax]
         res.total_benefits = rc[:benefit2]+rc[:benefit1]+rc[:basic_income]
         res.net_income = rc[:netincome]
         res.metr = rc[:metr]
         res.tax_credit = rc[:tax_credit]
      end # people
   end # hhlds
   @label end_of_calcs
   ran = rand()
   print("Done; people $pnum rand=$ran\n")
   results[1:pnum-1,:];
end
