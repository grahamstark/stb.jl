#
#
using DataFrames
using StatFiles
using IterableTables
using IteratorInterfaceExtensions
using TableTraits
using CSV

using Definitions

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

                hid                                            :: BigInt
            	pid                                            :: BigInt

            	age                                            :: Integer
            	sex                                            :: Sex

            	ethnic_group                                   :: Ethnic_Group
            	marital_status                                 :: Marital_Status
            	highest_qualification                          :: Qualification_Type
            	industrial_classification                      :: SIC_2007
            	occupational_classification                    :: Standard_Occupational_Classification
            	# FIXME needs work on the mapping - leeve out for now
            	socio_economic_grouping                        :: Socio_Economic_Group
            	age_completed_full_time_education              :: Integer
            	years_in_full_time_work                        :: Integer
            	employment_status                              :: ILO_Employment
            	hours_worked                                   :: Integer

            	income                                         :: Incomes_Dict
            	assets                                         :: Asset_Dict
            	pension_contributions                          :: Real
            	contracted_out_of_serps                        :: Bool

            	registered_blind                               :: Bool
            	registered_partially_sighted                   :: Bool
            	registered_deaf                                :: Bool
            	has_learning_difficulty                        :: Bool
            	has_dementia                                   :: Bool

            	disabilities                                   :: Disability_Dict
            	health_status                                  :: Health_Status
            	wealth                                         :: Asset_Dict
            	is_informal_carer                              :: Bool
            	receives_informal_care_from_non_householder    :: Bool
            	hours_of_care_received                         :: Real
            	hours_of_care_given                            :: Real

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

function loadtoframe( filename :: AbstractString ) :: DataFrame
        df = CSV.File( filename, delim = '\t') |> DataFrame
        lcnames = Symbol.(lowercase.(string.(names(df))))
        names!(df, lcnames)
        df
end

function loadfrs( which :: AbstractString, year :: Integer ) :: DataFrame
    filename = "$(FRS_DIR)/$(year)/tab/$(which).tab"
    loadtoframe( filename )
end

hbai_indiv = loadtoframe( "$(HBAI_DIR)/tab/i1718_all.tab" )
hbai_household = loadtoframe( "$(HBAI_DIR)/tab/h1718_all.tab" )

prices = loadPrices( "/mnt/data/prices/mm23/mm23_edited.csv" );
gdpdef = loadGDPDeflator( "/mnt/data/prices/gdpdef.csv" )

households = initialise_household(0)
people = initialise_personal(0)

for year in 2015:2017

        print( "on year $year " )

        accounts = loadfrs( "accounts", year )
        benunit = loadfrs( "benunit", year )
        extchild = loadfrs( "extchild", year )
        maint = loadfrs( "maint", year )
        penprov = loadfrs( "penprov", year )

        admin = loadfrs( "admin", year )
        care = loadfrs( "care", year )
        frs1718 = loadfrs( "frs1718", year )
        mortcont = loadfrs( "mortcont", year )
        pension = loadfrs( "pension", year )

        adult = loadfrs( "adult", year )
        child = loadfrs( "child", year )
        govpay = loadfrs( "govpay", year )
        mortgage = loadfrs( "mortgage", year )
        pianon1718 = loadfrs( "pianon1718", year )

        assets = loadfrs( "assets", year )
        chldcare = loadfrs( "chldcare", year )
        househol = loadfrs( "househol", year )
        oddjob = loadfrs( "oddjob", year )
        rentcont = loadfrs( "rentcont", year )

        benefits = loadfrs( "benefits", year )
        endowmnt = loadfrs( "endowmnt", year )
        job = loadfrs( "job", year )
        owner = loadfrs( "owner", year )
        renter = loadfrs( "renter", year )


end
