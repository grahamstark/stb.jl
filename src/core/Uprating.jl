module Uprating

"""
Semi-complete indexing routine using OBR quarterly data.
"""

include( "prices.jl" )

export uprate

export
    Uprate_Item_Type,
    upr_no_uprate,
    upr_earnings,
    upr_housing_rents,
    upr_housing_oo,
    upr_unearned,
    upr_costs,
    upr_cpi,
    upr_gdp_deflator,
    upr_nominal_gdp,
    upr_shares

end
