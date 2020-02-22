using HTTP
using JSON
using MySQL
using Dates
using DataFrames
using Base.Filesystem

function getdata( rate1:: Real, rate2 :: Real ) :: Array{Any,1}
    url =
        "https://oustb.virtual-worlds.scot/oustb/stb/?it_allow=12500&it_rate_1=$rate1&it_rate_$rate2&it_band=50000"
    resp = HTTP.request( "GET", url )
    json = JSON.parse(join((map(Char,resp.body))))
    return json;
end

function doRunBatch( )
    n = 0
    for r1 in 1:30
        for r2 in 30:50
            json = getdata( r1, r2 )
            if n % 100 == 0
                print( json )
            end
            n += 1
    end
end

function doall( start )
    doRunBatch()
end
