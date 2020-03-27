#
# Stuff to read FRS and HBAI files into frames and merge them
# a lot of this is just to overcome the weird way I have these stored
# and would need adaption by anyone with a sensible layout who had all the
# files in the one format
# SINGLE (LATEST) year only
#
using DataFrames
using StatFiles
using TableTraits
using CSV
using Utils
using Definitions

function loadfrs(which::AbstractString, year::Integer)::DataFrame
    filename = "$(FRS_DIR)/$(year)/tab/$(which).tab"
    loadtoframe(filename)
end

function remapRegion( r :: Integer )
        if r == 112000001 # North East
                r = 1
        elseif r == 112000002 # North West
                r = 2
        # no region 3
        elseif r == 112000003 # Yorks and the Humber
                r = 4
        elseif r == 112000004 # East Midlands
                r = 5
        elseif r == 112000005 # West Midlands
                r = 6
        elseif r == 112000006
                r = 7  # East of England
        elseif r == 112000007 # | London
                r = 8
        elseif r == 112000008 # South East
                r = 9
        elseif r == 112000009 # South West
                r = 10
        elseif r == 399999999 #  wales
                r = 11
        elseif r == 299999999
                r = 12        # Scotland
        elseif r == 499999999 # Northern Ireland
                r = 13
        end
        return r
end

function initialise_person( n::Integer )::DataFrame
    DataFrame(
        frs_year    = Vector{Union{Int64,Missing}}(missing,n),
        household_number  = Vector{Union{Int64,Missing}}(missing,n),
        benefit_unit = Vector{Union{Int8,Missing}}(missing,n),
        person  = Vector{Union{Int8,Missing}}(missing,n),
        government_region  = Vector{Union{Int8,Missing}}(missing,n),
        tenure_type  = Vector{Union{Int8,Missing}}(missing,n), # f enums OK
        household_income = Vector{Union{Real,Missing}}(missing,n),
        benefit_unit_income = Vector{Union{Real,Missing}}(missing,n),
        household_composition = Vector{Union{Int8,Missing}}(missing,n), # full - check for differences (OK)
        num_children = Vector{Union{Int8,Missing}}(missing,n),
        num_adults = Vector{Union{Int8,Missing}}(missing,n),
        age = Vector{Union{Int8,Missing}}(missing,n), # age80 - 2005-2012 ; iagegr2 full
        empstati = Vector{Union{Int8,Missing}}(missing,n),
        sex = Vector{Union{Int8,Missing}}(missing,n),     # full
        marital_status = Vector{Union{Int8,Missing}}(missing,n), # full
        ethnic_group  = Vector{Union{Int8,Missing}}(missing,n), # ethgr3
        years_in_full_time_work =  Vector{Union{Int64,Missing}}(missing,n), # ftwk
        age_completed_full_time_education = Vector{Union{Int64,Missing}}(missing,n), # tea
        socio_economic_grouping = Vector{Union{Real,Missing}}(missing,n), # FIXME Really a Decimal nssc
        highest_qualification = Vector{Union{Int8,Missing}}(missing,n), # 2008-11
        occupational_classification = Vector{Union{Int64,Missing}}(missing,n),
        registered_blind_or_deaf = Vector{Union{Int8,Missing}}(missing,n), # full years
        any_disability = Vector{Union{Int8,Missing}}(missing,n), # disd01..09
        health_status = Vector{Union{Int8,Missing}}(missing,n), # heathad
        hours_of_care_received = Vector{Union{Real,Missing}}(missing,n), # full
        hours_of_care_given = Vector{Union{Real,Missing}}(missing,n), # f
        is_informal_carer = Vector{Union{Int8,Missing}}(missing,n), # carefl
        employment_earnings = Vector{Union{Real,Missing}}(missing,n), # 07-08 missing
        self_employment_income = Vector{Union{Real,Missing}}(missing,n),
        in_poverty = Vector{Union{Int8,Missing}}(missing,n), # low60ahc hbai adult
        happiness = Vector{Union{Int8,Missing}}(missing,n), # happywb adult
        in_debt_now = Vector{Union{Int8,Missing}}(missing,n),
        in_debt_in_last_year = Vector{Union{Int8,Missing}}(missing,n)
    )
end

function create_adults(
        year         :: Integer,
        hhld         :: DataFrame,
        benunit      :: DataFrame,
        frs_adults   :: DataFrame,
        hbai_adults  :: DataFrame )

        num_adults = size(frs_adults)[1]
        adult_model = initialise_person(num_adults)
        adno = 0
        hbai_year = year - 1993
        println("hbai_year $hbai_year")
        for pn in 1:num_adults
            if pn % 1000 == 0
                println("adults: on year $year, pno $pn")
            end

            frs_person = frs_adults[pn, :]
            sernum = frs_person.sernum
            ad_hbai = hbai_adults[((hbai_adults.year.==hbai_year).&(hbai_adults.sernum.==sernum).&(hbai_adults.person.==frs_person.person).&(hbai_adults.benunit.==frs_person.benunit)), :]
            ad_hhld = hhld[ frs_person.sernum .==  hhld.sernum,:]
            ad_benunit = benunit[ (frs_person.sernum .==  benunit.sernum).&(frs_person.benunit.==benunit.benunit),:]
            frs_person.tenure_type = safe_assign( hhld.tentyp2 )
            frs_person.government_region = remapRegion( hhld.gvtregn )

            @assert size( ad_benunit)[1] == 1
            @assert size( ad_hhld )[1] == 1
            nhbai = size(ad_hbai)[1]
            @assert nhbai in [0, 1]

            if nhbai == 1 # only non-missing in HBAI
                adno += 1
                    ## also for children
                model_adult.frs_year = year
                model_adult = adult_model[adno, :]
                model_hbai = ad_hbai[1,:]
                model_adult.household_income = model_hbai.esninchh
                model_adult.benefit_unit_income = model_hbai.esnincbu
                model_adult.person = frs_person.person
                model_adult.household_number = frs_person.sernum
                model_adult.household_number = frs_person.sernum

                model_adult.age = frs_person.age80
                model_adult.sex = safe_assign(frs_person.sex)
                model_adult.ethnic_group = safe_assign(frs_person.ethgr3)
                # plan 'B' wages and SE from HBAI; first work out hd/spouse so we can extract right ones
                ## adult only

                model_adult.marital_status = safe_assign(frs_person.marital)
                model_adult.highest_qualification = safe_assign(frs_person.dvhiqual)

                model_adult.socio_economic_grouping = safe_assign(Integer(trunc(frs_person.nssec)))
                model_adult.age_completed_full_time_education = safe_assign(frs_person.tea)
                model_adult.years_in_full_time_work = safe_inc(0, frs_person.ftwk)
                model_adult.employment_status = safe_assign(frs_person.empstati)
                model_adult.occupational_classification = safe_assign(frs_person.soc2010)
                hbai_wages = coalesce( is_hbai_head ? model_hbai.esgjobhd : model_hbai.esgjobsp, 0.0 )
                hbai_se = coalesce( is_hbai_head ? model_hbai.esgrsehd : model_hbai.esgrsesp, 0.0 )
                model_adult.employment_earnings = hbai_wages
                model_adult.self_employment_income = hbai_se
                ## also for child
                model_adult.registered_blind_or_deaf =
                    ((frs_person.spcreg1 == 1 ) ||
                     (frs_person.spcreg2 == 1 ) ||
                     (frs_person.spcreg3 == 1)) ? 1 : 0

                model_adult.any_disability = (
                    (frs_person.disd01 == 1) || # cdisd kids ..
                    (frs_person.disd02 == 1) ||
                    (frs_person.disd03 == 1) ||
                    (frs_person.disd04 == 1) ||
                    (frs_person.disd05 == 1) ||
                    (frs_person.disd06 == 1) ||
                    (frs_person.disd07 == 1) ||
                    (frs_person.disd08 == 1) ||
                    (frs_person.disd09 == 1)) ? 1 : 0


                # dindividual_savings_accountbility_other_difficulty = Vector{Union{Real,Missing}}(missing, n),
                model_adult.health_status = safe_assign(frs_person.heathad)
                model_adult.hours_of_care_received = safe_inc(0.0, frs_person.hourcare)
                model_adult.hours_of_care_given = infer_hours_of_care(frs_person.hourtot) # also kid

                model_adult.is_informal_carer = (frs_person.carefl == 1 ? 1 : 0) # also kid
                model_adult.in_poverty = hbai_person.low60ahc == 1

                model_adult.in_debt_now = (
                    (ad_benunit.debt01 == 1 ) ||
                    (ad_benunit.debt02 == 1 ) ||
                    (ad_benunit.debt03 == 1 ) ||
                    (ad_benunit.debt04 == 1 ) ||
                    (ad_benunit.debt05 == 1 ) ||
                    (ad_benunit.debt06 == 1 ) ||
                    (ad_benunit.debt07 == 1 ) ||
                    (ad_benunit.debt08 == 1 ) ||
                    (ad_benunit.debt09 == 1 ) ||
                    (ad_benunit.debt10 == 1 ) ||
                    (ad_benunit.debt11 == 1 ) ||
                    (ad_benunit.debt12 == 1 ) ||
                    (ad_benunit.debt13 == 1 )) ? 1 : 0
                model_adult.in_debt_in_last_year = (
                    (ad_benunit.debtar01 == 1 ) ||
                    (ad_benunit.debtar02 == 1 ) ||
                    (ad_benunit.debtar03 == 1 ) ||
                    (ad_benunit.debtar04 == 1 ) ||
                    (ad_benunit.debtar05 == 1 ) ||
                    (ad_benunit.debtar06 == 1 ) ||
                    (ad_benunit.debtar07 == 1 ) ||
                    (ad_benunit.debtar08 == 1 ) ||
                    (ad_benunit.debtar09 == 1 ) ||
                    (ad_benunit.debtar10 == 1 ) ||
                    (ad_benunit.debtar11 == 1 ) ||
                    (ad_benunit.debtar12 == 1 ) ||
                    (ad_benunit.debtar13 == 1 )) ? 1 : 0
                model_adult.happiness =  frs_person.happywb
            end # if in HBAI
        end # adult loop
        println("final adno $adno")
        adult_model[1:adno, :]

end


hbai_adults = loadtoframe("$(HBAI_DIR)/tab/i1718_all.tab")
model_adults = initialise_person(0)

for year in 2017:2017

    print("on year $year ")

    ## hbf = HBAIS[year]
    ## hbai_adults = loadtoframe("$(HBAI_DIR)/tab/$hbf")
    househol =loadfrs("househol", year)
    benunit = loadfrs("benunit", year)
    adult = loadfrs("adult", year)

    model_adults_yr = create_adults(
        year,
        househol,
        benunit,
        adult,
        hbai_adults
    )
    append!(model_people, model_adults_yr)
end

CSVFiles.save( File( format"CSV", "dd309_frs_households.tab" ),
    model_adults, delim = "\t",  nastring="")
