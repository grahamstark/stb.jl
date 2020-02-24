using HTTP
using JSON
## !!! needs Julia 1.3:w
import Base.Threads.@spawn

function getdata( rate1:: Real, rate2 :: Real ) :: Dict
    url =
    # https://oustb.virtual-worlds.scot/oustb/
        "http://localhost:8000/stb/?it_allow=12500&it_rate_1=$rate1&it_rate_$rate2&it_band=50000"
    println( "fetching from URL $url" )
    resp = HTTP.request( "GET", url )
    json = JSON.parse(join((map(Char,resp.body))))
    return json;
end

function doRunBatch( max :: Integer )
    n = 0
    println("doRunBatch; running on thread $(Threads.threadid())")
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
    n
end # func doRunBatch

function doall( threadno :: Integer )
    println(" at start" )
    for i in 1:threadno
        response = @async doRunBatch(1)
        n = fetch( response )
    end
end

doall(1)
