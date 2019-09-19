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
