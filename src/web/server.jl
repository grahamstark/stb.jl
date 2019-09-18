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

println("starting server")
rc = @timed begin
  example_names = Example_Household_Getter.initialise()
  num_households = FRS_Household_Getter.initialise()
end
mb = trunc(Integer, rc[3] / 1024^2)
println("loaded data; load time $(rc[2]); memory used $(mb)mb;\nready...")

function get_hh(hdstr::AbstractString)
  hid = parse(Int64, hdstr)
  JSON.json(Example_Household_Getter.get_household(hid))
end

function addqstrdict( app, req )
  req[:parsed_querystring] = qstrtodict( req[:query])
  return app( req )
end

function paramtest( req )
  JSON.json( req[:query] )
  JSON.json( req )
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

@app test = (
  Mux.defaults,
  addqstrdict,
# Mux.splitquery,
  page(respond("<h1>OU DD226 TB Model</h1>")),
  page("/hhld/:hid", req -> get_hh((req[:params][:hid]))),
  page("/paramtest", req -> paramtest( req ) ),
  Mux.notfound(),
)

port = 8000
if length(ARGS) > 0
  port = parse(Int64, ARGS[1])
end
@sync serve(test,port)
