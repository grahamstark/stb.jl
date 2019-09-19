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
