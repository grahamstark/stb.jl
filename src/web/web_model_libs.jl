using JSON
using FRS_Household_Getter
using Example_Household_Getter
using Model_Household
using Utils
using MiniTB
using DataFrames
using TBComponents

println("starting server")
rc = @timed begin
   example_names = Example_Household_Getter.initialise()
   num_households = FRS_Household_Getter.initialise()
end
mb = trunc(Integer, rc[3] / 1024^2)
println("loaded data; load time $(rc[2]); memory used $(mb)mb; loaded $num_households households\nready...")


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


function map_params( req )
   querydict = req[:parsed_querystring]
   tbparams = deepcopy(MiniTB.DEFAULT_PARAMS)
   tbparams.it_allow = get_if_set("it_allow", querydict, tbparams.it_allow)
   tbparams.it_rate[1] = get_if_set("it_rate_1", querydict, tbparams.it_rate[1])
   tbparams.it_rate[2] = get_if_set("it_rate_2", querydict, tbparams.it_rate[2])
   tbparams.it_band[1] = get_if_set("it_band", querydict, tbparams.it_band[1])
   tbparams.benefit1 = get_if_set("benefit1", querydict, tbparams.benefit1)
   tbparams.benefit2 = get_if_set("benefit2", querydict, tbparams.benefit2)
   tbparams.ben2_l_limit = get_if_set("ben2_l_limit", querydict, tbparams.ben2_l_limit)
   tbparams.ben2_taper = get_if_set("ben2_taper", querydict, tbparams.ben2_taper)
   tbparams.ben2_u_limit = get_if_set("ben2_u_limit", querydict, tbparams.ben2_u_limit)
   tbparams
end


function make_results_frame( n :: Integer ) :: DataFrame
   DataFrame(
     pid = Vector{Union{BigInt,Missing}}(missing, n),
     tax_1 = Vector{Union{Real,Missing}}(missing, n),
     benefit1_1 = Vector{Union{Real,Missing}}(missing, n),
     benefit2_1 = Vector{Union{Real,Missing}}(missing, n),
     net_income_1 = Vector{Union{Real,Missing}}(missing, n),
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
         res.tax_2 = rc2[:tax]
         res.benefit1_2 = rc2[:benefit1]
         res.benefit2_2 = rc2[:benefit2]
      end # people
   end # hhlds
   @label end_of_calcs
   ran = rand()
   "Done; people $pnum rand=$ran"
end


function doonerun( req )
   num_people = 10_000
   tbparams = map_params( req )
   rc = doonerun( tbparams, num_people )
   JSON.json( rc )
end # doonerun

function local_makebc( req )
   tbparams = map_params( req )
   bc = local_makebc( DEFAULT_PERSON, tbparams )
   JSON.json((base = DEFAULT_BC, changed = bc))
end

const DEFAULT_BC = local_makebc(MiniTB.DEFAULT_PERSON, MiniTB.DEFAULT_PARAMS)
