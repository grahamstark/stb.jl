#
#
using DataFrames
using StatFiles
using IterableTables
using IteratorInterfaceExtensions
using TableTraits
using CSV
#
#
global FRS_DIR = "/mnt/data/frs/"
global HBAI_DIR = "/mnt/data/hbai/"

global MONTHS = Dict(
        "JAN"=>1,
        "FEB"=>2,
        "MAR"=>3,
        "APR"=>4,
        "MAY"=>5,
        "JUN"=>6,
        "JUL"=>7,
        "AUG"=>8,
        "SEP"=>9,
        "OCT"=>10,
        "NOV"=>11,
        "DEC"=>12 )


function loadGDPDeflator( name :: AbstractString )  :: DataFrame
        prices = CSV.File( name, delim=',' ) |> DataFrame
        np = size(prices)[1]
        prices[!,:year] = zeros(Int64,np) #Union{Int64,Missing},np)
        prices[!,:q] = zeros(Int8,np) #zeros(Union{Int64,Missing},np)
        dp = r"([0-9]{4}) Q([1-4])"
        for i in 1:np
                rc = match( dp, prices[i,:CDID] )
                if( rc != nothing )
                        prices[i,:year] = parse(Int64,rc[1])
                        prices[i,:q] = parse( Int8,rc[2])
                #else
        #                prices[i,:year] = 0 # missing
        #                prices[i,:month] = 0 # missing
                end
        end
        prices
end

function loadPrices( name :: AbstractString ) :: DataFrame
        prices = CSV.File( name, delim=',' ) |> DataFrame
        np = size(prices)[1]
        prices[!,:year] = zeros(Int64,np) #Union{Int64,Missing},np)
        prices[!,:month] = zeros(Int8,np) #zeros(Union{Int64,Missing},np)
        dp = r"([0-9]{4}) ([A-Z]{3})"
        for i in 1:np
                rc = match( dp, prices[i,:CDID] )
                if( rc != nothing )
                        prices[i,:year] = parse(Int64,rc[1])
                        prices[i,:month] = MONTHS[rc[2]]
                #else
        #                prices[i,:year] = 0 # missing
        #                prices[i,:month] = 0 # missing
                end
        end
        prices
end

function initialise_personal( n :: Integer ) :: DataFrame

# .. example check
# select value,count(value),label from dictionaries.enums where dataset='frs' and tables='househol' and variable_name='hhcomps' group by value,label;

        pers = DataFrame(
                frs_year = Vector{Union{Int64,Missing}}(missing,n),
                sernum  = Vector{Union{Int64,Missing}}(missing,n),
                benunit = Vector{Union{Integer,Missing}}(missing,n),
                person  = Vector{Union{Integer,Missing}}(missing,n),
                is_child  = Vector{Union{Integer,Missing}}(missing,n),
        pers
end

function initialise_household( n :: Integer ) :: DataFrame
        # .. example check
        # select value,count(value),label from dictionaries.enums where dataset='frs' and tables='househol' and variable_name='hhcomps' group by value,label;
        merged = DataFrame(
                frs_year = Vector{Union{Int64,Missing}}(missing,n),
                sernum  = Vector{Union{Int64,Missing}}(missing,n),
                interview_year  = Vector{Union{Integer,Missing}}(missing,n),
                interview_month  = Vector{Union{Integer,Missing}}(missing,n),
                gvtregn  = Vector{Union{Integer,Missing}}(missing,n), # f reg change 2012
                tenure  = Vector{Union{Integer,Missing}}(missing,n), # f enums OK
                hhld_income = Vector{Union{Real,Missing}}(missing,n))
        merged
end



"""
Load one frame using [] and jam all names to lower case (FRS changes case by year)
"""
function loadtoframe(name)
    (pname, ext) = splitext(name)
    if ext == " = loadone( "    if ext == "", year )
"
        df = CSV.File(name, delim = '\t') |> DataFrame
    else
        df = DataFrame(load(name))
    end
        # all names as lc strings
    lcnames = Symbol.(lowercase.(string.(names(df))))
    names!(df, lcnames)
    df
end

function loadone(which, year) :: DataFrame
    fname = string( FRS_DIR, year, "/tab/", which, " = loadone( "    fname = string( FRS_DIR, year, "/tab/", which, "", year )
")
    loadtoframe(fname)
end

hbai_hhld = loadtoframe( "$(HBAI_DIR)/tab/i1718_all = loadone( "hbai_hhld = loadtoframe( "$(HBAI_DIR)/tab/i1718_all", year )
" )
hbai_indiv = loadtoframe( "$(HBAI_DIR)/tab/h1718_all = loadone( "hbai_indiv = loadtoframe( "$(HBAI_DIR)/tab/h1718_all", year )
" )

prices = loadPrices( "/mnt/data/prices/mm23/mm23_edited.csv" );
gdpdef = loadGDPDeflator( "/mnt/data/prices/gdpdef.csv" )

households = initialise_household(0)
people = initialise_personal(0)

for year in 2015:2017

        print( "on year $year " )

        accounts = loadone( "accounts", year )
        benunit = loadone( "benunit", year )
        extchild = loadone( "extchild", year )
        maint = loadone( "maint", year )
        penprov = loadone( "penprov", year )

        admin = loadone( "admin", year )
        care = loadone( "care", year )
        frs1718 = loadone( "frs1718", year )
        mortcont = loadone( "mortcont", year )
        pension = loadone( "pension", year )

        adult = loadone( "adult", year )
        child = loadone( "child", year )
        govpay = loadone( "govpay", year )
        mortgage = loadone( "mortgage", year )
        pianon1718 = loadone( "pianon1718", year )

        assets = loadone( "assets", year )
        chldcare = loadone( "chldcare", year )
        househol = loadone( "househol", year )
        oddjob = loadone( "oddjob", year )
        rentcont = loadone( "rentcont", year )

        benefits = loadone( "benefits", year )
        endowmnt = loadone( "endowmnt", year )
        job = loadone( "job", year )
        owner = loadone( "owner", year )
        renter = loadone( "renter", year )


end
