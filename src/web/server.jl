using Mux
using JSON
using FRS_Household_Getter
using Example_Household_Getter
using Model_Household


@time example_names = Example_Household_Getter.initialise()
# @time num_households = FRS_Household_Getter.initialise()

function get_hh( hdstr :: AbstractString )
  hid = parse( Int64, hdstr )
  JSON.json( Example_Household_Getter.get_household(hid))
end

@app test = (
  Mux.defaults,
  page(respond("<h1>Hello World!</h1>")),
  page("/hhld/:hid", req -> get_hh((req[:params][:hid]))),
  Mux.notfound())

serve(test)
