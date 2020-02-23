using HTTP
using JSON
using MySQL
using Dates
using DataFrames
using Base.Filesystem

function getdata( rate1:: Real, rate2 :: Real ) :: Array{Any,1}
    url =
        "https://oustb.virtual-worlds.scot/oustb/stb/?it_allow=12500&it_rate_1=$rate1&it_rate_$rate2&it_band=50000"
    println( "fetching from URL $url" )
    resp = HTTP.request( "GET", url )

    json = JSON.parse(join((map(Char,resp.body))))
    return json;
end

function doRunBatch( max :: Integer )
    n = 0
    for r1 in 1:30
        for r2 in 40:50
            println( "getting data r1=$r1 r2=$r2 " )
            json = getdata( r1, r2 )
            if n % 1 == 0
                print( json )
            end
            n += 1
            if n > max
                break
            end
        end # rand2
    end # rand1
end # func doRunBatch

function doall( threadno :: Integer )
    println(" at start" )
    doRunBatch(1)
end

doall(1)
