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

const DEFAULT_PORT=8000
const DEFAULT_SERVER="http://localhost:$DEFAULT_PORT/"

const DEFAULT_TEST_URL="$(DEFAULT_SERVER)/bc?it_allow=300.0&it_rate_1=0.25&it_rate_2=0.5&it_band=10000&benefit1=150.0&benefit2=60.0&ben2_l_limit = 150.0&ben2_taper=0.5&ben2_u_limit = 250.0"
const ZERO_TEST_URL="$(DEFAULT_SERVER)/bc?it_allow=0&it_rate_1=0&it_rate_2=0&it_band=0&benefit1=0&benefit2=0.0&ben2_taper=0&ben2_l_limit=0&ben2_u_limit=0"

println("starting server")

include( "web_model_libs.jl")

# Headers -- set Access-Control-Allow-Origin for either dev or prod
# this is from https://github.com/JuliaDiffEq/DiffEqOnlineServer
# not used yet
function with_headers(res, req)
    println("Origin: ", get(req[:headers], "Origin", ""))
    headers  = HttpCommon.headers()
    headers["Content-Type"] = "application/json; charset=utf-8"
    if get(req[:headers], "Origin", "") == "http://localhost:$DEFAULT_PORT"
        headers["Access-Control-Allow-Origin"] = "http://localhost:$DEFAULT_PORT"
    else
        headers["Access-Control-Allow-Origin"] = "http://app.juliadiffeq.org"
    end
    println(headers["Access-Control-Allow-Origin"])
    Dict(
       :headers => headers,
       :body=> res
    )
end

function web_get_hh(hdstr::AbstractString)
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


function web_map_params( req )
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


function web_doonerun( req )
   num_people = 10_000
   tbparams = map_params( req )
   rc = doonerun( tbparams, num_people )
   JSON.json( rc )
end # doonerun

function web_makebc( req )
   tbparams = map_params( req )
   bc = web_makebc( DEFAULT_PERSON, tbparams )
   JSON.json((base = DEFAULT_BC, changed = bc))
end

# ourstack = stack(Mux.todict, errorCatch, Mux.splitquery, Mux.toresponse) # from DiffEq

@app dd226 = (
   Mux.defaults,
   addqstrdict,
# Mux.splitquery,
   page(respond("<h1>OU DD226 TB Model</h1>")),
   page("/hhld/:hid", req -> web_get_hh((req[:params][:hid]))),
   page("/paramtest", req -> web_paramtest(req)),
   page("/bc", req -> web_makebc(req)),
   page("/run", req -> web_doonerun(req)),
   Mux.notfound(),
)


port = 8000
if length(ARGS) > 0
   port = parse(Int64, ARGS[1])
end
load_data( load_examples = true, load_main = true )
@sync serve(dd226, port)
