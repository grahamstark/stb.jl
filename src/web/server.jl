#
# see: https://github.com/JuliaWeb/Mux.jl
# and:
#
using Mux
using JSON
using FRS_Household_Getter
using Example_Household_Getter
using Model_Household
using Utils
using MiniTB
using TBComponents


println("starting server")
rc = @timed begin
   example_names = Example_Household_Getter.initialise()
   num_households = FRS_Household_Getter.initialise()
end
mb = trunc(Integer, rc[3] / 1024^2)
println("loaded data; load time $(rc[2]); memory used $(mb)mb; loaded $num_households households\nready...")



# Headers -- set Access-Control-Allow-Origin for either dev or prod
# this is from https://github.com/JuliaDiffEq/DiffEqOnlineServer
# not used yet
function withHeaders(res, req)
    println("Origin: ", get(req[:headers], "Origin", ""))
    headers  = HttpCommon.headers()
    headers["Content-Type"] = "application/json; charset=utf-8"
    if get(req[:headers], "Origin", "") == "http://localhost:4200"
        headers["Access-Control-Allow-Origin"] = "http://localhost:4200"
    else
        headers["Access-Control-Allow-Origin"] = "http://app.juliadiffeq.org"
    end
    println(headers["Access-Control-Allow-Origin"])
    Dict(
       :headers => headers,
       :body=> res
    )
end

function maptoexample( modelpers :: Model_Household.Person ) :: MiniTB.Person
   minipers :: MiniTB.person
   minipers.pid = modelpers.pid
   minipers.age = modelpers.age
   minipers.sex = ( minipers.age % 2) == 0 ? male : female;
   minipers.wage = 0.0
   for k,v in modelpers.income
      minipers.wage += v
   end
   minipers
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

const DEFAULT_BC = local_makebc(MiniTB.DEFAULT_PERSON, MiniTB.DEFAULT_PARAMS)
const DEFAULT_PORT=8000
const DEFAULT_SERVER="http://localhost:$DEFAULT_PORT/"
const DEFAULT_TEST_URL="$(DEFAULT_SERVER)/bc?it_allow=300.0&it_rate_1=0.25&it_rate_2=0.5&it_band=10000&benefit1=150.0&benefit2=60.0&ben2_l_limit = 150.0&ben2_taper=0.5&ben2_u_limit = 250.0"
const ZERO_TEST_URL="$(DEFAULT_SERVER)/bc?it_allow=0&it_rate_1=0&it_rate_2=0&it_band=0&benefit1=0&benefit2=0.0&ben2_taper=0&ben2_l_limit=0&ben2_u_limit=0"

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


makeresults = DataFrame( n :: Integer ) :: DataFrame
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

function doonerun( req )
   num_people = 10_000
   tbparams = map_params( req )
   results = makeresults( num_people )
   pni = 0
   for hhno in 1:num_people
      frshh = FRS_Household_Getter.get_household( hhno )
      for pid,frsperson in frshh.people
         pnum += 1
         experson = maptoexample( frsperson )
         rc1 = MiniTB.calculate( experson, DEFAULT_PARAMS )
         rc2 = MiniTB.calculate( experson, tbparams )
         res = results[pnum,:]
         res.pid = experson.pid
         res.tax_1 = rc1.tax
         res.benefit1_1 = rc1.benefit1
         res.benefit2_1 = rc1.benefit2
         res.tax_2 = rc2.tax
         res.benefit1_2 = rc2.benefit1
         res.benefit2_2 = rc2.benefit2
         if pnum >= num_people
            break
         end
      end
end

function local_makebc( req )
   tbparams = map_params( req )
   bc = local_makebc( DEFAULT_PERSON, tbparams )
   JSON.json((base = DEFAULT_BC, changed = bc))
end

function get_hh(hdstr::AbstractString)
   hid = parse(Int64, hdstr)
   JSON.json(FRS_Household_Getter.get_household(hid))
end

function addqstrdict(app, req)
   req[:parsed_querystring] = qstrtodict(req[:query])
   return app(req)
end

function paramtest(req)
   JSON.json(req[:query])
   JSON.json(req)
end

# Better error handling
function errorCatch(app, req)
   try
      app(req)
   catch e
      println("Error occured!")

      io = IOBuffer()
      showerror(io, e)
      err_text = takebuf_string(io)
      println(err_text)
      resp = withHeaders(JSON.json(Dict("message" => err_text, "error" => true)), req)
      resp[:status] = 500
      return resp
   end
end

# ourstack = stack(Mux.todict, errorCatch, Mux.splitquery, Mux.toresponse) # from DiffEq

@app dd226 = (
   Mux.defaults,
   addqstrdict,
# Mux.splitquery,
   page(respond("<h1>OU DD226 TB Model</h1>")),
   page("/hhld/:hid", req -> get_hh((req[:params][:hid]))),
   page("/paramtest", req -> paramtest(req)),
   page("/bc", req -> local_makebc(req)),
   Mux.notfound(),
)


port = 8000
if length(ARGS) > 0
   port = parse(Int64, ARGS[1])
end
@sync serve(dd226, port)
