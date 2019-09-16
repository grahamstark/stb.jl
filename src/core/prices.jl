#
# fixme combines
#
using DataFrames
using CSV
using Utils

export uprate!

const TO_Q = 4
const TO_Y = 2019

@enum Uprate_Item_Type
    upr_earnings
    upr_housing
    upr_unearned
    upr_costs
    upr_cpi
    upr_gdp_deflator
    upr_nominal_gdp
    upr_shares
end

const PRICES_DIR="/mnt/data/prices/obr/"

OBR_DATA = load()

function uprate!( item <: Number, from_y :: Integer, from_q :: Integer, itype :: Uprate_Item_Type )

end

function load()

    obr = CSV.File( "$(PRICES_DIR)/merged_quarterly.tab"; delim='\t', comment="#" ) |> DataFrame
    np = size(prices)[1]
    lcnames = Symbol.(basiccensor.(string.(names(obr))))
    names!(obr, lcnames)

    obr[!, :year] = zeros(Int64, np) #Union{Int64,Missing},np)
    obr[!, :month] = zeros(Int8, np) #zeros(Union{Int64,Missing},np)
    dp = r"([0-9]{4}) ([A-Z]{3})"
    for i in 1:np
        rc = match(dp, obr[i, :date])
        if (rc != nothing)
            obr[i, :year] = parse(Int64, rc[1])
            obr[i, :month] = MONTHS[rc[2]]
                #else
        #                obr[i,:year] = 0 # missing
        #                obr[i,:month] = 0 # missing
        end
    end
    obr
end
