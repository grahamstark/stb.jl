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

     total_taxes_1 = Vector{Union{Real,Missing}}(missing, n),
     total_benefits_1 = Vector{Union{Real,Missing}}(missing, n),
     tax_1 = Vector{Union{Real,Missing}}(missing, n),
     benefit1_1 = Vector{Union{Real,Missing}}(missing, n),
     benefit2_1 = Vector{Union{Real,Missing}}(missing, n),
     net_income_1 = Vector{Union{Real,Missing}}(missing, n),
     metr_1 = Vector{Union{Real,Missing}}(missing, n),

     total_taxes_2 = Vector{Union{Real,Missing}}(missing, n),
     total_benefits_2 = Vector{Union{Real,Missing}}(missing, n),
     tax_2 = Vector{Union{Real,Missing}}(missing, n),
     benefit1_2 = Vector{Union{Real,Missing}}(missing, n),
     benefit2_2 = Vector{Union{Real,Missing}}(missing, n),
     net_income_2 = Vector{Union{Real,Missing}}(missing, n),
     metr_2 = Vector{Union{Real,Missing}}(missing, n))
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
         res.tax_1 = rc1[:tax]
         res.benefit1_1 = rc1[:benefit1]
         res.benefit2_1 = rc1[:benefit2]
         res.total_taxes_1= rc1[:tax]
         res.total_benefits_1 = rc1[:benefit2]+rc1[:benefit1]
         res.net_income_1 = rc1[:netincome]
         res.metr_1 = rc1[:metr]

         res.tax_2 = rc2[:tax]
         res.benefit1_2 = rc2[:benefit1]
         res.benefit2_2 = rc2[:benefit2]
         res.total_taxes_2 = rc1[:tax]
         res.total_benefits_2 = rc2[:benefit2]+rc2[:benefit1]
         res.net_income_2 = rc2[:netincome]
         res.metr_2 = rc2[:metr]

      end # people
   end # hhlds
   @label end_of_calcs
   ran = rand()
   print("Done; people $pnum rand=$ran\n")
   results[1:pnum-1,:];
end
