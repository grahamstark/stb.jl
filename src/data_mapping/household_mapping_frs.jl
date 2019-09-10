#
#
using DataFrames
using StatFiles
using IterableTables
using IteratorInterfaceExtensions
using TableTraits
using CSV

using Definitions

global FRS_DIR = "/mnt/data/frs/"
global HBAI_DIR = "/mnt/data/hbai/"

global MONTHS = Dict(
    "JAN" => 1,
    "FEB" => 2,
    "MAR" => 3,
    "APR" => 4,
    "MAY" => 5,
    "JUN" => 6,
    "JUL" => 7,
    "AUG" => 8,
    "SEP" => 9,
    "OCT" => 10,
    "NOV" => 11,
    "DEC" => 12
)


function loadGDPDeflator(name::AbstractString)::DataFrame
    prices = CSV.File(name, delim = ',') |> DataFrame
    np = size(prices)[1]
    prices[!, :year] = zeros(Int64, np) #Union{Int64,Missing},np)
    prices[!, :q] = zeros(Int8, np) #zeros(Union{Int64,Missing},np)
    dp = r"([0-9]{4}) Q([1-4])"
    for i in 1:np
        rc = match(dp, prices[i, :CDID])
        if (rc != nothing)
            prices[i, :year] = parse(Int64, rc[1])
            prices[i, :q] = parse(Int8, rc[2])
                #else
        #                prices[i,:year] = 0 # missing
        #                prices[i,:month] = 0 # missing
        end
    end
    prices
end

function loadPrices(name::AbstractString)::DataFrame
    prices = CSV.File(name, delim = ',') |> DataFrame
    np = size(prices)[1]
    prices[!, :year] = zeros(Int64, np) #Union{Int64,Missing},np)
    prices[!, :month] = zeros(Int8, np) #zeros(Union{Int64,Missing},np)
    dp = r"([0-9]{4}) ([A-Z]{3})"
    for i in 1:np
        rc = match(dp, prices[i, :CDID])
        if (rc != nothing)
            prices[i, :year] = parse(Int64, rc[1])
            prices[i, :month] = MONTHS[rc[2]]
                #else
        #                prices[i,:year] = 0 # missing
        #                prices[i,:month] = 0 # missing
        end
    end
    prices
end

function initialise_person(n::Integer)::DataFrame
    pers = DataFrame(
        frs_year = Vector{Union{Int64,Missing}}(missing, n),
        hid = Vector{Union{BigInt,Missing}}(missing, n),
        pid = Vector{Union{BigInt,Missing}}(missing, n),
        pno = Vector{Union{Integer,Missing}}(missing, n),
        default_benefit_unit = Vector{Union{Integer,Missing}}(missing, n),
        age = Vector{Union{Integer,Missing}}(missing, n),
        sex = Vector{Union{Integer,Missing}}(missing, n),
        ethnic_group = Vector{Union{Integer,Missing}}(missing, n),
        marital_status = Vector{Union{Integer,Missing}}(missing, n),
        highest_qualification = Vector{Union{Integer,Missing}}(missing, n),
        sic = Vector{Union{Integer,Missing}}(missing, n),
        occupational_classification = Vector{Union{
            Standard_Occupational_Classification,
            Missing
        }}(
            missing,
            n
        ),
        public_or_private = Vector{Union{Integer,Missing}}(missing, n),
        principal_employment_type = Vector{Union{Integer,Missing}}(missing, n),

        socio_economic_grouping = Vector{Union{Integer,Missing}}(missing, n),
        age_completed_full_time_education = Vector{Union{Integer,Missing}}(missing, n),
        years_in_full_time_work = Vector{Union{Integer,Missing}}(missing, n),
        employment_status = Vector{Union{Integer,Missing}}(missing, n),
        usual_hours_worked = Vector{Union{Integer,Missing}}(missing, n),
        actual_hours_worked = Vector{Union{Integer,Missing}}(missing, n),
        income_wages = Vector{Union{Real,Missing}}(missing, n),
        income_self_employment_income = Vector{Union{Real,Missing}}(missing, n),
        income_self_employment_expenses = Vector{Union{Real,Missing}}(missing, n),
        income_self_employment_losses = Vector{Union{Real,Missing}}(missing, n),
        income_private_pensions = Vector{Union{Real,Missing}}(missing, n),
        income_national_savings = Vector{Union{Real,Missing}}(missing, n),
        income_bank_interest = Vector{Union{Real,Missing}}(missing, n),
        income_building_society = Vector{Union{Real,Missing}}(missing, n),
        income_stocks_shares = Vector{Union{Real,Missing}}(missing, n),
        income_peps = Vector{Union{Real,Missing}}(missing, n),
        income_isa = Vector{Union{Real,Missing}}(missing, n),
        income_property = Vector{Union{Real,Missing}}(missing, n),
        income_royalties = Vector{Union{Real,Missing}}(missing, n),
        income_bonds_and_gilts = Vector{Union{Real,Missing}}(missing, n),
        income_other_investment_income = Vector{Union{Real,Missing}}(missing, n),
        income_other_income = Vector{Union{Real,Missing}}(missing, n),
        income_alimony_and_child_support_received = Vector{Union{Real,Missing}}(missing, n),
        income_health_insurance = Vector{Union{Real,Missing}}(missing, n),

        income_alimony_and_child_support_paid = Vector{Union{Real,Missing}}(missing, n),
        income_care_insurance = Vector{Union{Real,Missing}}(missing, n),
        income_trade_unions_etc = Vector{Union{Real,Missing}}(missing, n),
        income_friendly_societies = Vector{Union{Real,Missing}}(missing, n),
        income_work_expenses = Vector{Union{Real,Missing}}(missing, n),
        income_repayments = Vector{Union{Real,Missing}}(missing, n),
        income_pension_contributions = Vector{Union{Real,Missing}}(missing, n),
        income_avcs = Vector{Union{Real,Missing}}(missing, n),
        income_loan_repayments = Vector{Union{Real,Missing}}(missing, n),
        income_student_loan_repayments = Vector{Union{Real,Missing}}(missing, n),
        income_other_deductions = Vector{Union{Real,Missing}}(missing, n),

        income_education_allowances = Vector{Union{Real,Missing}}(missing, n),
        income_foster_care_payments = Vector{Union{Real,Missing}}(missing, n),
        income_student_grants = Vector{Union{Real,Missing}}(missing, n),
        income_student_loans = Vector{Union{Real,Missing}}(missing, n),
        income_income_tax = Vector{Union{Real,Missing}}(missing, n),
        income_national_insurance = Vector{Union{Real,Missing}}(missing, n),
        income_local_taxes = Vector{Union{Real,Missing}}(missing, n),
        income_child_benefit = Vector{Union{Real,Missing}}(missing, n),
        income_pension_credit = Vector{Union{Real,Missing}}(missing, n),
        income_retirement_pension = Vector{Union{Real,Missing}}(missing, n),
        income_other_pensions = Vector{Union{Real,Missing}}(missing, n),
        income_disabled_living_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_pip = Vector{Union{Real,Missing}}(missing, n),
        income_severe_disablement_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_attendance_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_invalid_care_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_incapacity_benefit = Vector{Union{Real,Missing}}(missing, n),
        income_jobseekers_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_income_support_jsa = Vector{Union{Real,Missing}}(missing, n),
        income_maternity_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_other_benefits = Vector{Union{Real,Missing}}(missing, n),
        income_winter_fuel_payments = Vector{Union{Real,Missing}}(missing, n),
        income_housing_benefit = Vector{Union{Real,Missing}}(missing, n),
        income_council_tax_benefit = Vector{Union{Real,Missing}}(missing, n),
        income_tax_credits = Vector{Union{Real,Missing}}(missing, n),
        income_sickness_benefits = Vector{Union{Real,Missing}}(missing, n),
        assets = Vector{Union{Asset_Dict,Missing}}(missing, n),
        asset_current_account = Vector{Union{Real,Missing}}(missing, n),
        asset_nsb_ordinary_account = Vector{Union{Real,Missing}}(missing, n),
        asset_nsb_investment_account = Vector{Union{Real,Missing}}(missing, n),
        asset_not_used = Vector{Union{Real,Missing}}(missing, n),
        asset_savings_investments_etc = Vector{Union{Real,Missing}}(missing, n),
        asset_government_gilt_edged_stock = Vector{Union{Real,Missing}}(missing, n),
        asset_unit_or_investment_trusts = Vector{Union{Real,Missing}}(missing, n),
        asset_stocks_shares_bonds_etc = Vector{Union{Real,Missing}}(missing, n),
        asset_pep = Vector{Union{Real,Missing}}(missing, n),
        asset_national_savings_capital_bonds = Vector{Union{Real,Missing}}(missing, n),
        asset_index_linked_national_savings_certificates = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        asset_fixed_interest_national_savings_certificates = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        asset_pensioners_guaranteed_bonds = Vector{Union{Real,Missing}}(missing, n),
        asset_saye = Vector{Union{Real,Missing}}(missing, n),
        asset_premium_bonds = Vector{Union{Real,Missing}}(missing, n),
        asset_national_savings_income_bonds = Vector{Union{Real,Missing}}(missing, n),
        asset_national_savings_deposit_bonds = Vector{Union{Real,Missing}}(missing, n),
        asset_first_option_bonds = Vector{Union{Real,Missing}}(missing, n),
        asset_yearly_plan = Vector{Union{Real,Missing}}(missing, n),
        asset_isas = Vector{Union{Real,Missing}}(missing, n),
        asset_fixd_rate_svngs_bonds = Vector{Union{Real,Missing}}(missing, n),
        asset_geb = Vector{Union{Real,Missing}}(missing, n),
        asset_basic_account = Vector{Union{Real,Missing}}(missing, n),
        asset_credit_unions = Vector{Union{Real,Missing}}(missing, n),
        asset_endowment_policy_not_linked = Vector{Union{Real,Missing}}(missing, n),
        pension_contributions = Vector{Union{Real,Missing}}(missing, n),
        contracted_out_of_serps = Vector{Union{Bool,Missing}}(missing, n),
        registered_blind = Vector{Union{Bool,Missing}}(missing, n),
        registered_partially_sighted = Vector{Union{Bool,Missing}}(missing, n),
        registered_deaf = Vector{Union{Bool,Missing}}(missing, n),
        has_learning_difficulty = Vector{Union{Bool,Missing}}(missing, n),
        has_dementia = Vector{Union{Bool,Missing}}(missing, n),
        disability_vision = Vector{Union{Real,Missing}}(missing, n),
        disability_hearing = Vector{Union{Real,Missing}}(missing, n),
        disability_mobility = Vector{Union{Real,Missing}}(missing, n),
        disability_dexterity = Vector{Union{Real,Missing}}(missing, n),
        disability_learning = Vector{Union{Real,Missing}}(missing, n),
        disability_memory = Vector{Union{Real,Missing}}(missing, n),
        disability_mental_disability = Vector{Union{Real,Missing}}(missing, n),
        disability_stamina = Vector{Union{Real,Missing}}(missing, n),
        disability_socially = Vector{Union{Real,Missing}}(missing, n),
        disability_other_difficulty = Vector{Union{Real,Missing}}(missing, n),
        health_status = Vector{Union{Health_Status,Missing}}(missing, n),
        is_informal_carer = Vector{Union{Bool,Missing}}(missing, n),
        receives_informal_care_from_non_householder = Vector{Union{Bool,Missing}}(
            missing,
            n
        ),
        hours_of_care_received = Vector{Union{Real,Missing}}(missing, n),
        hours_of_care_given = Vector{Union{Real,Missing}}(missing, n)
    )

end

const HH_TYPE_HINTS = [
    :region => Standard_Region,
    :ct_band => CT_Band,
    :tenure => Tenure_Type
]



function initialise_household(n::Integer)::DataFrame
        # .. example check
        # select value,count(value),label from dictionaries.enums where dataset='frs' and tables='househol' and variable_name='hhcomps' group by value,label;
    hh = DataFrame(
        data_year = Vector{Union{Integer,Missing}}(missing, n),
        interview_year = Vector{Union{Integer,Missing}}(missing, n),
        interview_month = Vector{Union{Integer,Missing}}(missing, n),
        quarter = Vector{Union{Integer,Missing}}(missing, n),
        hid = Vector{Union{BigInt,Missing}}(missing, n),
        tenure = Vector{Union{Integer,Missing}}(missing, n),
        region = Vector{Union{Integer,Missing}}(missing, n),
        ct_band = Vector{Union{Integer,Missing}}(missing, n),
        council_tax = Vector{Union{Real,Missing}}(missing, n),
        water_and_sewerage = Vector{Union{Real,Missing}}(missing, n),
        mortgage_payment = Vector{Union{Real,Missing}}(missing, n),
        mortgage_interest = Vector{Union{Real,Missing}}(missing, n),
        years_outstanding_on_mortgage = Vector{Union{Integer,Missing}}(missing, n),
        mortgage_outstanding = Vector{Union{Real,Missing}}(missing, n),
        year_house_bought = Vector{Union{Integer,Missing}}(missing, n),
        gross_rent = Vector{Union{Real,Missing}}(missing, n),
        rent_includes_water_and_sewerage = Vector{Union{Bool,Missing}}(missing, n),
        other_housing_charges = Vector{Union{Real,Missing}}(missing, n),
        gross_housing_costs = Vector{Union{Real,Missing}}(missing, n),
        total_income = Vector{Union{Real,Missing}}(missing, n),
        total_wealth = Vector{Union{Real,Missing}}(missing, n),
        house_value = Vector{Union{Real,Missing}}(missing, n),
        weight = Vector{Union{Real,Missing}}(missing, n),
    )
    hh
end

function add_in_earnings( a_job :: DataFrame ) :: NamedTuple
    njobs = size( a_job )[1]
    earnings = 0.0
    actual_hours = 0.0
    usual_hours = 0.0
    health_insurance  = 0.0
    alimony_and_child_support_paid  = 0.0
    # care_insurance  = 0.0
    trade_unions_etc = 0.0
    friendly_societies = 0.0
    work_expenses = 0.0
    pension_contributions = 0.0
    avcs = 0.0
    other_deductions = 0.0
    student_loan_repayments = 0.0

    self_employment_income = 0.0
    self_employment_expenses = 0.0
    self_employment_losses = 0.0

    for j in 1:njobs
        if j == 1 # take 1st record job for all of these
            adult_model[adno,:principal_employment_type] =  safe_assign(a_job[j,:etype])
            adult_model[adno,:public_or_private ] =  safe_assign(a_job[j,:jobsect])
        end
        usual_hours = safe_inc( usual_hours, a_job[j,:dvushr])
        actual_hours = safe_inc( actual_hours, a_job[j,:jobhours])

        # alimony_and_child_support_paid  = safe_add( alimony_and_child_support_paid , a_job[j,udeduc0X])
        # care_insurance  = safe_add( care_insurance , a_job[j,:othded0X]

        pension_contributions = safe_add( pension_contributions, a_job[j,:udeduc1])
        avcs = safe_add( avcs, a_job[j,:udeduc2])
        trade_unions_etc = safe_add( trade_unions_etc, a_job[j,:udeduc3])
        friendly_societies = safe_add( friendly_societies, a_job[j,:udeduc4])
        other_deductions= safe_add( other_deductions, a_job[j,:udeduc5])
        loan_repayments = safe_add( loan_repayments, a_job[j,:udeduc6])
        health_insurance  = safe_add( health_insurance , a_job[j,:udeduc7])
        other_deductions= safe_add( other_deductions, a_job[j,:udeduc8])
        student_loan_repayments = safe_add( student_loan_repayments, a_job[j,:udeduc9])
        work_expenses = safe_add( work_expenses, a_job[j,:umotamt]) ## CARS FIXME add to this

        # self employment
        if a_job[j,:prbefore] > 0.0

            self_employment_income += a_job[j,:prbefore]
        elseif a_job[j,:profit1] > 0.0
            @assert a_job[j,:profit2] in [1,2]
            if a_job[j,:profit2] == 1
                self_employment_income += a_job[j,:profit1]
            else
                self_employment_losses += a_job[j,:profit1]
            end
        elseif a_job[j, :seincamt] > 0.0
            self_employment_income += a_job[j,:seincamt]
        end
        # earnings
        addBonus = false
        if a_job[j,:ugross] > 0.0 # take usual when last not usual
                earnings += a_job[j,:ugross]
                addBonus = true
        elseif a_job[j,:grwage] > 0.0 # then take last
                earnings += a_job[j,:grwage]
                addBonus = true
        elseif a_job[j,:ugrspay] > 0.0 # then take total pay, but don't add bonuses
                earnings += a_job[j,:ugrspay]
        end
        if addBonus
                for i in 1:6
                        bon = Symbol( string("bonamt",i))
                        tax = Symbol( string("bontax",i))
                        if a_job[j,bon] > 0.0
                                bon = a_job[j,bon]
                                if  a_job[j,tax] == 2
                                        bon /= (1-0.22) # fixme hack basic rate
                                end
                                earnings += bon/52.0 # fixwme weeks per year
                        end
                end # bonuses loop
        end # add bonuses
    end # jobs loop
    return (
        earnings=earnings,
        usual_hours=usual_hours,
        actual_hours=actual_hours,
        health_insurance =   health_insurance ,
        alimony_and_child_support_paid =   alimony_and_child_support_paid ,
        # care_insurance =   # care_insurance ,
        trade_unions_etc =   trade_unions_etc,
        friendly_societies=   friendly_societies,
        work_expenses=   work_expenses,
        pension_contributions=   pension_contributions,
        avcs=   avcs,
        other_deductions = other_deductions,
        student_loan_repayments=   student_loan_repayments,
        self_employment_income = self_employment_income
        self_employment_expenses = self_employment_expenses
        self_employment_losses = self_employment_losses
     )
end

function create_adults(
    year::Integer,
    frs_adults::DataFrame,
    accounts::DataFrame,
    benunit::DataFrame,
    extchild::DataFrame,
    maint::DataFrame,
    penprov::DataFrame,
    admin::DataFrame,
    care::DataFrame,
    mortcont::DataFrame,
    pension::DataFrame,
    govpay::DataFrame,
    mortgage::DataFrame,
    assets::DataFrame,
    chldcare::DataFrame,
    househol::DataFrame,
    oddjob::DataFrame,
    benefits::DataFrame,
    endowmnt::DataFrame,
    job::DataFrame,
    hbai_adults :: DataFrame

) :: DataFrame

    num_adults = size(frs_adults)[1]
    adult_model = initialise_person(num_adults)
    adno = 0
    hbai_year = year - 1993

    for pn in 1:num_adults
        if pn % 1000 == 0
            println("on year $year, hid $hn")
        end

        frs_person = frs_adult[pn, :]
        adno = 0
        sernum = pers.sernum
        ad_hbai = hbai_adults[(
            (hbai_adults.year .== hbai_year) .&
            (hbai_adults.sernum .== sernum) .&
            (hbai_adults.person .== frs_person.person) .&
            (hbai_adults.benunit .== frs_person.benunit)),  :]
        nhbai = size(ad_hbai)[1]
        @assert nhbai in [0,1]

        if nhbai == 1 # only non-missing in HBAI
            adno += 1
            ## also for children
            adult_model[adno,:pno] = frs_person.person
            adult_model[adno,:hid] = frs_person.sernum
            adult_model[adno,:pid] = getPid( FRS, year, frs_person.sernum, frs_person.person )
            adult_model[adno,:frs_year] = year
            adult_model[adno,:default_benefit_unit] = frs_person.benunit
            adult_model[adno,:age] = frs_person.age80
            adult_model[adno,:sex] = safe_assign(  frs_person.sex )
            adult_model[adno,:ethnic_group] = safe_assign(  frs_person.ethgr3 )

            ## adult only
            a_job = job[(( job.sernum .== frs_person.sernum ) .&
                        ( job.benunit .== frs_person.benunit ) .&
                        ( job.person .== frs_person.person )),:]

            a_pen = penprov[(( penprov.sernum .== frs_person.sernum ) .&
                            ( penprov.benunit .== frs_person.benunit ) .&
                            ( penprov.person .== frs_person.person )),:]
            an_asset = penprov[(( assets.sernum .== frs_person.sernum ) .&
                            ( assets.benunit .== frs_person.benunit ) .&
                            ( assets.person .== frs_person.person )),:]
            an_account = penprov[(( accounts.sernum .== frs_person.sernum ) .&
                            ( accounts.benunit .== frs_person.benunit ) .&
                            ( accounts.person .== frs_person.person )),:]
            npens = size( a_pen )[1]
            nassets = size( an_asset )[1]
            naaccounts = size( an_account )[1]

            adult_model[adno,:marital_status] = safe_assign( frs_person.marital )
            adult_model[adno,:highest_qualification] = safe_assign( frs_person.dvhiqual )
            adult_model[adno,:sic] = safe_assign( frs_person.sic )

            adult_model[adno,:socio_economic_grouping]= safe_assign( frs_person.soc2010 )
            adult_model[adno,:age_completed_full_time_education] = safe_assign( frs_person.tea )
            adult_model[adno,:years_in_full_time_work] = safe_assign( frs_person.ftwk )
            adult_model[adno,:employment_status] = safe_assign( frs_person.empstati )
            wkstuff = create_earnings( a_job )
            adult_model[adno,:usual_hours_worked] = wkstuff.usual_hours
            adult_model[adno,:actual_hours_worked] = wkstuff.actual_hours
            adult_model[adno,:income_wages] = wkstuff.earnings

            ## FIXME look at this mapping again: pcodes
            adult_model[adno,:income_health_insurance ] = wkstuff.health_insurance
            # adult_model[adno,:income_# care_insurance ] = wkstuff.# care_insurance
            adult_model[adno,:income_trade_unions_etc ] = wkstuff.trade_unions_etc
            adult_model[adno,:income_friendly_societies] = wkstuff.friendly_societies
            adult_model[adno,:income_work_expenses] = wkstuff.work_expenses
            adult_model[adno,:income_pension_contributions] = wkstuff.pension_contributions
            adult_model[adno,:income_avcs] = wkstuff.avcs
            adult_model[adno,:income_other_deductions ] = wkstuff.other_deductions
            adult_model[adno,:income_student_loan_repayments] = wkstuff.student_loan_repayments # fixme maybe "slrepamt" or "slreppd"

            adult_model[adno,:income_self_employment_income] = wkstuff.self_employment_income
            adult_model[adno,:income_self_employment_expenses] = wkstuff.self_employment_expenses
            adult_model[adno,:income_self_employment_losses] = wkstuff.self_employment_losses

            # adult_model[adno,:income_alimony_and_child_support_paid ] = wkstuff.alimony_and_child_support_paid

# wages,   X
# self_employment_income, X
# self_employment_expenses, X
# self_employment_losses,X

# private_pensions,
# national_savings,
# bank_interest,
# building_society,
# stocks_shares,
# peps,
# isa,
# dividends,
# property,
# royalties,
# bonds_and_gilts,
# other_investment_income,
# other_income,

# alimony_and_child_support_received, X
# health_insurance, X
# alimony_and_child_support_paid,
# care_insurance, X
# trade_unions_etc, X
# friendly_societies, X
# work_expenses, X
# loan_repayments, X
# student_loan_repayments, X
# pension_contributions,
# avcs, X

# education_allowances,
# foster_care_payments,
# student_grants,
# student_loans,
# other_deductions,
# income_tax,
# national_insurance,
# local_taxes,
# child_benefit,
# pension_credit,
# retirement_pension,
# other_pensions,
# disabled_living_allowance,
# severe_disablement_allowance,
# pip,
# attendance_allowance,
# invalid_care_allowance,
# incapacity_benefit,
# jobseekers_allowance,
# income_support_jsa,
# maternity_allowance,
# other_benefits,
# winter_fuel_payments,
# housing_benefit,
# council_tax_benefit,
# tax_credits,
# sickness_benefits

        end # if in HBAI
    end # adult loop
    adult_model[1:adno]
end # proc create_adult

function create_child(
    year :: Integer,
    child :: DataFrame ) :: DataFrame


end

function create_household(
    year::Integer,
    frs_household::DataFrame,
    renter::DataFrame,
    mortgage::DataFrame,
    mortcont::DataFrame,
    owner::DataFrame,
    hbai_adults::DataFrame ) :: DataFrame

    num_households = size(frs_household)[1]
    hh_model = initialise_household(num_households)
    hhno = 0
    hbai_year = year - 1993

    for hn in 1:num_households
        if hn % 1000 == 0
            println("on year $year, hid $hn")
        end
        hh = frs_household[hn, :]


        sernum = hh.sernum
        ad_hbai = hbai_adults[((hbai_adults.year.==hbai_year).&(hbai_adults.sernum.==sernum)), :]
        if (size(ad_hbai)[1] > 0) # only non-missing in HBAI
            ad1_hbai = ad_hbai[1, :]
            hhno += 1
            dd = split(hh.intdate, "/")
            hh_model[hhno, :interview_year] = parse(Int64, dd[3])
            interview_month = parse(Int8, dd[1])
            hh_model[hhno, :interview_month] = interview_month
            hh_model[hhno, :quarter] = div(interview_month - 1, 3) + 1

            hh_model[hhno, :hid] = sernum
            hh_model[hhno, :data_year] = year
            hh_model[hhno, :tenure] = hh.tentyp2 > 0 ? hh.tentyp2 : -1
            hh_model[hhno, :region] = hh.gvtregn > 0 ? hh.gvtregn : -1
            hh_model[hhno, :ct_band] = hh.ctband > 0 ? hh.ctband : -1
            hh_model[hhno, :weight] = hh.gross4
            # hh_model[hhno, :tenure] = hh.tentyp2 > 0 ? Tenure_Type(hh.tentyp2) :
            #                          Missing_Tenure_Type
            # hh_model[hhno, :region] = hh.gvtregn > 0 ? Standard_Region(hh.gvtregn) :
            #                           Missing_Standard_Region
            # hh_model[hhno, :ct_band] = hh.ctband > 0 ? CT_Band(hh.ctband) : Missing_CT_Band
            #
            # council_tax::Real
            # FIXME this is rounded to £
            if hh_model[hhno, :region] == 299999999 # Scotland
                hh_model[hhno, :water_and_sewerage] = ad1_hbai.cwathh
            elseif hh_model[hhno, :region] == 399999999 # Nireland
                hh_model[hhno, :water_and_sewerage] = 0.0 # FIXME
            else #
                hh_model[hhno, :water_and_sewerage] = ad1_hbai.watsewhh
            end



            # hh_model[hhno, :mortgage_payment]
            hh_model[hhno, :mortgage_interest] = ad1_hbai.hbxmort

            # TODO
            # years_outstanding_on_mortgage::Integer
            # mortgage_outstanding::Real
            # year_house_bought::Integer
            # FIXME rounded to £1
            hh_model[hhno, :gross_rent] = max(0.0, hh.hhrent) #  rentg Gross rent including Housing Benefit  or rent Net amount of last rent payment

            rents = renter[(renter.sernum.==sernum), :]
            nrents = size(rents)[1]
            hh_model[hhno, :rent_includes_water_and_sewerage] = false
            for r in 1:nrents
                if (rents[r, :wsinc] in [1, 2, 3])
                    hh_model[hhno, :rent_includes_water_and_sewerage] = true
                end
            end
            ohc = 0.0
            ohc = safe_inc(ohc, hh.chrgamt1)
            ohc = safe_inc(ohc, hh.chrgamt2)
            ohc = safe_inc(ohc, hh.chrgamt3)
            ohc = safe_inc(ohc, hh.chrgamt4)
            ohc = safe_inc(ohc, hh.chrgamt5)
            ohc = safe_inc(ohc, hh.chrgamt6)
            ohc = safe_inc(ohc, hh.chrgamt7)
            ohc = safe_inc(ohc, hh.chrgamt8)
            ohc = safe_inc(ohc, hh.chrgamt9)
            hh_model[hhno, :other_housing_charges] = ohc


        # TODO
            # gross_housing_costs::Real
            # total_income::Real
            # total_wealth::Real
            # house_value::Real
            # people::People_Dict
        end
    end
    hh_model[1:hhno,:]
end

function loadtoframe(filename::AbstractString)::DataFrame
    df = CSV.File(filename, delim = '\t') |> DataFrame
    lcnames = Symbol.(lowercase.(string.(names(df))))
    names!(df, lcnames)
    df
end

function loadfrs(which::AbstractString, year::Integer)::DataFrame
    filename = "$(FRS_DIR)/$(year)/tab/$(which).tab"
    loadtoframe(filename)
end

hbai_adults = loadtoframe("$(HBAI_DIR)/tab/i1718_all.tab")
hbai_household = loadtoframe("$(HBAI_DIR)/tab/h1718_all.tab")

prices = loadPrices("/mnt/data/prices/mm23/mm23_edited.csv")
gdpdef = loadGDPDeflator("/mnt/data/prices/gdpdef.csv")

model_households = initialise_household(0)
model_people = initialise_person(0)

for year in 2014:2017

    print("on year $year ")

    accounts = loadfrs("accounts", year)
    benunit = loadfrs("benunit", year)
    extchild = loadfrs("extchild", year)
    maint = loadfrs("maint", year)
    penprov = loadfrs("penprov", year)

    admin = loadfrs("admin", year)
    care = loadfrs("care", year)
    # frs1718 = loadfrs("frs1718", year)
    mortcont = loadfrs("mortcont", year)
    pension = loadfrs("pension", year)

    adult = loadfrs("adult", year)
    child = loadfrs("child", year)
    govpay = loadfrs("govpay", year)
    mortgage = loadfrs("mortgage", year)
    # pianon1718 = loadfrs("pianon1718", year)

    assets = loadfrs("assets", year)
    chldcare = loadfrs("chldcare", year)
    househol = loadfrs("househol", year)
    oddjob = loadfrs("oddjob", year)
    rentcont = loadfrs("rentcont", year)

    benefits = loadfrs("benefits", year)
    endowmnt = loadfrs("endowmnt", year)
    job = loadfrs("job", year)
    owner = loadfrs("owner", year)
    renter = loadfrs("renter", year)

    model_households_yr = create_household(
        year,
        househol,
        renter,
        mortgage,
        mortcont,
        owner,
        hbai_adults
    )
    append!(model_households, model_households_yr)
    model_adults_yr = create_adults(
        year,
        frs_adults,
        accounts,
        benunit,
        extchild,
        maint,
        penprov,
        admin,
        care,
        mortcont,
        pension,
        govpay,
        mortgage,
        assets,
        chldcare,
        househol,
        oddjob,
        benefits,
        endowmnt,
        job,
        hbai_adults
    )
    append!(model_adults, model_adults_yr)
end

CSV.write("model_households.tab", model_households, delim = "\t")
