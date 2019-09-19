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



function local_makebc(pers::MiniTB.Person, params::Parameters)::Array{Float64,2}

   function getnet(gross::Float64)::Float64
      pers.wage = gross
      rc = calculate(pers, params)
      return rc[:netincome]
   end
   bc = TBComponents.makebc(getnet)
   return pointstoarray(bc)
end

const DEFAULT_BC = local_makebc(MiniTB.DEFAULT_PERSON, MiniTB.DEFAULT_PARAMS)

# it_allow=500.0&it_rate_1=0.25&it_rate_2=0.5&it_band=10000&benefit1=150.0&benefit2=60.0&ben2_l_limit = 200.03&ben2_taper&ben2_u_limit = 300.20
# it_allow=0&it_rate_1=0&it_rate_2=0&it_band=0&benefit1=0&benefit2=0.0&ben2_taper=0&ben2_l_limit=0&ben2_u_limit=0
function local_makebc(req)
   querydict = req[:parsed_querystring]
   tbparams = MiniTB.DEFAULT_PARAMS
   tbparams.it_allow = get_if_set("it_allow", querydict, tbparams.it_allow)
   tbparams.it_rate[1] = get_if_set("it_rate_1", querydict, tbparams.it_rate[1])
   tbparams.it_rate[2] = get_if_set("it_rate_2", querydict, tbparams.it_rate[2])
   tbparams.it_band[1] = get_if_set("it_band", querydict, tbparams.it_band[1])

   tbparams.benefit1 = get_if_set("benefit1", querydict, tbparams.benefit1)
   tbparams.benefit2 = get_if_set("benefit2", querydict, tbparams.benefit2)
   tbparams.ben2_l_limit = get_if_set("ben2_l_limit", querydict, tbparams.ben2_l_limit)
   tbparams.ben2_taper = get_if_set("ben2_taper", querydict, tbparams.ben2_taper)
   tbparams.ben2_u_limit = get_if_set("ben2_u_limit", querydict, tbparams.ben2_u_limit)

   bc = local_makebc(MiniTB.DEFAULT_PERSON, tbparams)
   res = (base = DEFAULT_BC, changed = bc)
   JSON.json(res)
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

println("starting server")
rc = @timed begin
   example_names = Example_Household_Getter.initialise()
  # num_households = FRS_Household_Getter.initialise()
end
mb = trunc(Integer, rc[3] / 1024^2)
println("loaded data; load time $(rc[2]); memory used $(mb)mb;\nready...")



port = 8000
if length(ARGS) > 0
   port = parse(Int64, ARGS[1])
end
@sync serve(dd226, port)
