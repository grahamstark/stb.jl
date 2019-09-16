module Uprating

include( "prices.jl" )

export uprate!

export
    Uprate_Item_Type,
    upr_earnings,
    upr_housing,
    upr_unearned,
    upr_costs,
    upr_cpi,
    upr_gdp_deflator,
    upr_nominal_gdp,
    upr_shares

end
