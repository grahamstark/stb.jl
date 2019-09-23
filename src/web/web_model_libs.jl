using JSON
using FRS_Household_Getter
using Example_Household_Getter
using Model_Household
using Utils
using MiniTB
using DataFrames
using TBComponents


function load_data(; load_examples::Bool, load_main :: Bool, start_year = 2017 )
   example_names = Vector{AbstractString}()
   num_households = 0
   if load_examples
      example_names = Example_Household_Getter.initialise()
   end
   if load_main
      rc = @timed begin
         num_households = FRS_Household_Getter.initialise( start_year = start_year )
      end
      mb = trunc(Integer, rc[3] / 1024^2)
      println("loaded data; load time $(rc[2]); memory used $(mb)mb; loaded $num_households households\nready...")
   end
   (example_names, num_households )
end


function maptoexample( modelpers :: Model_Household.Person ) :: MiniTB.Person
   inc = 0.0
   for (k,v) in modelpers.income
      inc += v
   end
   MiniTB.Person( modelpers.pid, inc, modelpers.age, Female )
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
     total_taxes_1 = Vector{Union{Real,Missing}}(missing, n),
     total_benefits_1 = Vector{Union{Real,Missing}}(missing, n),
     tax_1 = Vector{Union{Real,Missing}}(missing, n),
     benefit1_1 = Vector{Union{Real,Missing}}(missing, n),
     benefit2_1 = Vector{Union{Real,Missing}}(missing, n),
     net_income_1 = Vector{Union{Real,Missing}}(missing, n),
     total_taxes_2 = Vector{Union{Real,Missing}}(missing, n),
     total_benefits_2 = Vector{Union{Real,Missing}}(missing, n),
     tax_2 = Vector{Union{Real,Missing}}(missing, n),
     benefit1_2 = Vector{Union{Real,Missing}}(missing, n),
     benefit2_2 = Vector{Union{Real,Missing}}(missing, n),
     net_income_2 = Vector{Union{Real,Missing}}(missing, n))
end

function doonerun( tbparams::MiniTB.Parameters, num_people :: Integer )
   results = make_results_frame( num_people )
   pnum = 0
   for hhno in 1:num_people
      frshh = FRS_Household_Getter.get_household( hhno )
      for (pid,frsperson) in frshh.people
         pnum += 1
         if pnum >= num_people
            # break
            @goto end_of_calcs
         end
         experson = maptoexample( frsperson )
         rc1 = MiniTB.calculate( experson, DEFAULT_PARAMS )
         rc2 = MiniTB.calculate( experson, tbparams )
         res = results[pnum,:]
         res.pid = experson.pid
         res.tax_1 = rc1[:tax]
         res.benefit1_1 = rc1[:benefit1]
         res.benefit2_1 = rc1[:benefit2]
         res.total_taxes_1= rc1[:tax]
         res.total_benefits_1 = rc1[:benefit2]+rc1[:benefit1]
         res.tax_2 = rc2[:tax]
         res.benefit1_2 = rc2[:benefit1]
         res.benefit2_2 = rc2[:benefit2]
         res.total_taxes_2 = rc1[:tax]
         res.total_benefits_2 = rc2[:benefit2]+rc2[:benefit1]

      end # people
   end # hhlds
   @label end_of_calcs
   ran = rand()
   "Done; people $pnum rand=$ran"
end
