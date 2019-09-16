#
# fixme combines
#
using DataFrames
using CSV
using Utils
using Definitions

const TO_Q = 4
const TO_Y = 2019

@enum Uprate_Item_Type begin
    upr_earnings
    upr_housing_rents
    upr_housing_oo
    upr_unearned
    upr_costs
    upr_cpi
    upr_gdp_deflator
    upr_nominal_gdp
    upr_shares
end

Uprate_Map = Dict(
    upr_earnings => :average_earnings,
    upr_housing_rents => :actual_rents_for_housing,
    upr_housing_oo => :mortgage_interest_payments,
    upr_unearned => :gdp_at_market_prices,
    upr_costs => :cpi,
    upr_cpi => :cpi,
    upr_gdp_deflator => :gdp_deflator,
    upr_nominal_gdp => :gdp_at_market_prices,
    upr_shares => :equity_prices
)

function load_prices()
    obr = CSV.File("$(PRICES_DIR)/merged_quarterly.tab"; delim = '\t', comment = "#") |>
          DataFrame
    nrows = size(obr)[1]
    ncols = size(obr)[2]
    lcnames = Symbol.(basiccensor.(string.(names(obr))))
    names!(obr, lcnames)
    np = size(obr)[1]



    obr[!,:year] = zeros(Int64, nrows)
    obr[!,:q] = zeros(Int8, np) #zeros(Union{Int64,Missing},np)
    dp = r"([0-9]{4})Q([1-4])"
    for i in 1:nrows
        rc = match(dp, obr[i, :date])
        if (rc != nothing)
            obr[i, :year] = parse(Int64, rc[1])
            obr[i, :q] = parse(Int8, rc[2])
        end
    end

    pnew = findfirst((obr.year.==TO_Y) .& (obr.q.==TO_Q))
    for c in 1:ncols
        # println( "on col $c $(lcnames[c])")
        if ! (lcnames[c] in [:q, :year, :date ]) # got to be a better way
            obr[!,c] ./= obr[pnew,c]
        end
    end

    obr
end

OBR_DATA = load_prices()

function uprate( item :: Number, from_y::Integer, from_q::Integer, itype::Uprate_Item_Type)::Number
    # FIXME this is likely much too slow..
    global Uprate_Map
    global OBR_DATA
    global FROM_Y, FROM_Q
    colsym = Uprate_Map[itype]
    p = OBR_DATA[((OBR_DATA.year.==from_y).&(OBR_DATA.q.==from_q)), colsym][1]

    return item * p
end
