#
#
using DataFrames
using CSV

using Definitions

global FRS_DIR = "/mnt/data/frs/"
global HBAI_DIR = "/mnt/data/hbai/"
global OUTPUT_DIR = "/home/graham_s/tmp/"

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
        data_year = Vector{Union{Int64,Missing}}(missing, n),
        hid = Vector{Union{BigInt,Missing}}(missing, n),
        pid = Vector{Union{BigInt,Missing}}(missing, n),
        pno = Vector{Union{Integer,Missing}}(missing, n),
        from_child_record = Vector{Union{Integer,Missing}}(missing, n),
        default_benefit_unit = Vector{Union{Integer,Missing}}(missing, n),
        age = Vector{Union{Integer,Missing}}(missing, n),
        sex = Vector{Union{Integer,Missing}}(missing, n),
        ethnic_group = Vector{Union{Integer,Missing}}(missing, n),
        marital_status = Vector{Union{Integer,Missing}}(missing, n),
        highest_qualification = Vector{Union{Integer,Missing}}(missing, n),
        sic = Vector{Union{Integer,Missing}}(missing, n),
        occupational_classification = Vector{Union{Integer,Missing}}(missing, n),
        public_or_private = Vector{Union{Integer,Missing}}(missing, n),
        principal_employment_type = Vector{Union{Integer,Missing}}(missing, n),
        socio_economic_grouping = Vector{Union{Integer,Missing}}(missing, n),
        age_completed_full_time_education = Vector{Union{Integer,Missing}}(missing, n),
        years_in_full_time_work = Vector{Union{Integer,Missing}}(missing, n),
        employment_status = Vector{Union{Integer,Missing}}(missing, n),
        usual_hours_worked = Vector{Union{Real,Missing}}(missing, n),
        actual_hours_worked = Vector{Union{Real,Missing}}(missing, n),
        income_wages = Vector{Union{Real,Missing}}(missing, n),
        income_self_employment_income = Vector{Union{Real,Missing}}(missing, n),
        income_self_employment_expenses = Vector{Union{Real,Missing}}(missing, n),
        income_self_employment_losses = Vector{Union{Real,Missing}}(missing, n),
        income_odd_jobs = Vector{Union{Real,Missing}}(missing, n),
        income_private_pensions = Vector{Union{Real,Missing}}(missing, n),
        income_national_savings = Vector{Union{Real,Missing}}(missing, n),
        income_bank_interest = Vector{Union{Real,Missing}}(missing, n),
        income_stocks_shares = Vector{Union{Real,Missing}}(missing, n),
        income_isa = Vector{Union{Real,Missing}}(missing, n),
        income_dividends = Vector{Union{Real,Missing}}(missing, n),
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
        income_avcs = Vector{Union{Real,Missing}}(missing, n),
        income_other_deductions = Vector{Union{Real,Missing}}(missing, n),
        income_loan_repayments = Vector{Union{Real,Missing}}(missing, n),
        income_student_loan_repayments = Vector{Union{Real,Missing}}(missing, n),
        income_pension_contributions = Vector{Union{Real,Missing}}(missing, n),
        income_education_allowances = Vector{Union{Real,Missing}}(missing, n),
        income_foster_care_payments = Vector{Union{Real,Missing}}(missing, n),
        income_student_grants = Vector{Union{Real,Missing}}(missing, n),
        income_student_loans = Vector{Union{Real,Missing}}(missing, n),
        income_income_tax = Vector{Union{Real,Missing}}(missing, n),
        income_national_insurance = Vector{Union{Real,Missing}}(missing, n),
        income_local_taxes = Vector{Union{Real,Missing}}(missing, n),
        income_free_school_meals = Vector{Union{Real,Missing}}(missing, n),
        income_dlaself_care = Vector{Union{Real,Missing}}(missing, n),
        income_dlamobility = Vector{Union{Real,Missing}}(missing, n),
        income_child_benefit = Vector{Union{Real,Missing}}(missing, n),
        income_pension_credit = Vector{Union{Real,Missing}}(missing, n),
        income_state_pension = Vector{Union{Real,Missing}}(missing, n),
        income_bereavement_allowance_or_widowed_parents_allowance_or_bereavement = Vector{Union{
            Real,
            Missing
        }}(
            missing,
            n
        ),
        income_armed_forces_compensation_scheme = Vector{Union{Real,Missing}}(missing, n),
        income_war_widows_or_widowers_pension = Vector{Union{Real,Missing}}(missing, n),
        income_severe_disability_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_attendence_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_carers_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_jobseekers_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_industrial_injury_disablement_benefit = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        income_employment_and_support_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_incapacity_benefit = Vector{Union{Real,Missing}}(missing, n),
        income_income_support = Vector{Union{Real,Missing}}(missing, n),
        income_maternity_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_maternity_grant_from_social_fund = Vector{Union{Real,Missing}}(missing, n),
        income_funeral_grant_from_social_fund = Vector{Union{Real,Missing}}(missing, n),
        income_any_other_ni_or_state_benefit = Vector{Union{Real,Missing}}(missing, n),
        income_trade_union_sick_or_strike_pay = Vector{Union{Real,Missing}}(missing, n),
        income_friendly_society_benefits = Vector{Union{Real,Missing}}(missing, n),
        income_private_sickness_scheme_benefits = Vector{Union{Real,Missing}}(missing, n),
        income_accident_insurance_scheme_benefits = Vector{Union{Real,Missing}}(missing, n),
        income_hospital_savings_scheme_benefits = Vector{Union{Real,Missing}}(missing, n),
        income_government_training_allowances = Vector{Union{Real,Missing}}(missing, n),
        income_guardians_allowance = Vector{Union{Real,Missing}}(missing, n),
        income_widows_payment = Vector{Union{Real,Missing}}(missing, n),
        income_unemployment_or_redundancy_insurance = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        income_winter_fuel_payments = Vector{Union{Real,Missing}}(missing, n),
        income_dwp_third_party_payments_is_or_pc = Vector{Union{Real,Missing}}(missing, n),
        income_dwp_third_party_payments_jsa_or_esa = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        income_social_fund_loan_repayment_from_is_or_pc = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        income_social_fund_loan_repayment_from_jsa_or_esa = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        income_extended_hb = Vector{Union{Real,Missing}}(missing, n),
        income_permanent_health_insurance = Vector{Union{Real,Missing}}(missing, n),
        income_any_other_sickness_insurance = Vector{Union{Real,Missing}}(missing, n),
        income_critical_illness_cover = Vector{Union{Real,Missing}}(missing, n),
        income_working_tax_credit = Vector{Union{Real,Missing}}(missing, n),
        income_child_tax_credit = Vector{Union{Real,Missing}}(missing, n),
        income_working_tax_credit_lump_sum = Vector{Union{Real,Missing}}(missing, n),
        income_child_tax_credit_lump_sum = Vector{Union{Real,Missing}}(missing, n),
        income_housing_benefit = Vector{Union{Real,Missing}}(missing, n),
        income_universal_credit = Vector{Union{Real,Missing}}(missing, n),
        income_personal_independence_payment_daily_living = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        income_personal_independence_payment_mobility = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        income_a_loan_from_the_dwp_and_dfc = Vector{Union{Real,Missing}}(missing, n),
        income_a_loan_or_grant_from_local_authority = Vector{Union{Real,Missing}}(
            missing,
            n
        ),
        income_social_fund_loan_uc = Vector{Union{Real,Missing}}(missing, n),
        income_other_benefits = Vector{Union{Real,Missing}}(missing, n),
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
        asset_isa = Vector{Union{Real,Missing}}(missing, n),
        asset_fixd_rate_svngs_bonds_or_grntd_incm_bonds_or_grntd_growth_bonds = Vector{Union{
            Real,
            Missing
        }}(
            missing,
            n
        ),
        asset_geb = Vector{Union{Real,Missing}}(missing, n),
        asset_basic_account = Vector{Union{Real,Missing}}(missing, n),
        asset_credit_unions = Vector{Union{Real,Missing}}(missing, n),
        asset_endowment_policy_not_linked = Vector{Union{Real,Missing}}(missing, n),
        contracted_out_of_serps = Vector{Union{Integer,Missing}}(missing, n),
        registered_blind = Vector{Union{Integer,Missing}}(missing, n),
        registered_partially_sighted = Vector{Union{Integer,Missing}}(missing, n),
        registered_deaf = Vector{Union{Integer,Missing}}(missing, n),
        disability_vision = Vector{Union{Integer,Missing}}(missing, n),
        disability_hearing = Vector{Union{Integer,Missing}}(missing, n),
        disability_mobility = Vector{Union{Integer,Missing}}(missing, n),
        disability_dexterity = Vector{Union{Integer,Missing}}(missing, n),
        disability_learning = Vector{Union{Integer,Missing}}(missing, n),
        disability_memory = Vector{Union{Integer,Missing}}(missing, n),
        disability_mental_disability = Vector{Union{Integer,Missing}}(missing, n),
        disability_stamina = Vector{Union{Integer,Missing}}(missing, n),
        disability_socially = Vector{Union{Integer,Missing}}(missing, n),
        disability_other_difficulty = Vector{Union{Integer,Missing}}(missing, n),
        health_status = Vector{Union{Integer,Missing}}(missing, n),
        is_informal_carer = Vector{Union{Integer,Missing}}(missing, n),
        receives_informal_care_from_non_householder = Vector{Union{Integer,Missing}}(
            missing,
            n
        ),
        hours_of_care_received = Vector{Union{Real,Missing}}(missing, n),
        hours_of_care_given = Vector{Union{Real,Missing}}(missing, n),
        hours_of_childcare = Vector{Union{Real,Missing}}(missing, n),
        cost_of_childcare = Vector{Union{Real,Missing}}(missing, n),
        childcare_type = Vector{Union{Integer,Missing}}(missing, n),
        employer_provides_child_care = Vector{Union{Integer,Missing}}(missing, n),


        relationship_to_hoh = Vector{Union{Integer,Missing}}(missing, n),
        relationship_1 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_2 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_3 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_4 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_5 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_6 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_7 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_8 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_9 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_10 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_11 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_12 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_13 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_14 = Vector{Union{Integer,Missing}}(missing, n),
        relationship_15 = Vector{Union{Integer,Missing}}(missing, n)

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
        rent_includes_water_and_sewerage = Vector{Union{Integer,Missing}}(missing, n),
        other_housing_charges = Vector{Union{Real,Missing}}(missing, n),
        gross_housing_costs = Vector{Union{Real,Missing}}(missing, n),
        total_income = Vector{Union{Real,Missing}}(missing, n),
        total_wealth = Vector{Union{Real,Missing}}(missing, n),
        house_value = Vector{Union{Real,Missing}}(missing, n),
        weight = Vector{Union{Real,Missing}}(missing, n),
    )
    hh
end

function process_penprovs(a_pens::DataFrame)::Real
    npens = size(a_pens)[1]
    penconts = 0.0
    for p in 1:npens
        pc = safe_inc(0.0, a_pens[p, :penamt])
        if a_pens[p, :penamtpd] == 95
            pc /= 52.0
        end
        penconts += pc
    end
    # FIXME something about SERPS
    penconts
end

function process_pensions(a_pens::DataFrame)::NamedTuple
    npens = size(a_pens)[1]
    private_pension = 0.0
    tax = 0.0
    for p in 1:npens
        private_pension = safe_inc(private_pension, a_pens[p, :penpay])
        private_pension = safe_inc(private_pension, a_pens[p, :ptamt]) # tax
        private_pension = safe_inc(private_pension, a_pens[p, :penpd2]) # other deduction
        tax = safe_inc(tax, a_pens[p, :ptamt])
    end
    return (pension = private_pension, tax = tax)
end

function map_investment_income!(model_adult::DataFrameRow, accounts::DataFrame)
    naccts = size(accounts)[1]

    model_adult.income_national_savings = 0.0
    model_adult.income_bank_interest = 0.0
    model_adult.income_stocks_shares = 0.0
    model_adult.income_isa = 0.0
    model_adult.income_property = 0.0
    model_adult.income_royalties = 0.0
    model_adult.income_bonds_and_gilts = 0.0
    model_adult.income_other_investment_income = 0.0


    for i in 1:naccts
        v = max(0.0, accounts[i, :accint]) # FIXME national savings stuff appears to be coded -1 for missing
        if accounts[i, :invtax] == 1
            # FIXME is this right for dividends anymore?
            v /= 0.8
        end
        # FIXME building society - check with other models
        atype = Account_Type(accounts[i, :account])
        if atype in [
            Current_account,
            Basic_Account,
            NSB_Investment_account,
            NSB_Direct_Saver
        ]
            model_adult.income_bank_interest += v
        elseif atype in [
            National_Savings_capital_bonds,
            Index_Linked_National_Savings_Certificates,
            Fixed_Interest_National_Savings_Certificates,
            Fixed_Rate_Savings_or_Guaranteed_Income_or_Guaranteed_Growth_Bonds,
            First_Option_bonds,
            National_Savings_income_bonds,
            National_Savings_deposit_bonds,
            Pensioners_Guaranteed_Bonds
        ]
            model_adult.income_national_savings += v# FIXME appears to be all zero!
        elseif atype in [Stocks_Shares_Bonds_etc, Member_of_Share_Club]
            model_adult.income_stocks_shares += v
        elseif atype in [ISA]
            model_adult.income_isa += v
        elseif atype in [
            SAYE,
            Savings_investments_etc,
            Unit_or_Investment_Trusts,
            Endowment_Policy_Not_Linked,
            Profit_sharing,
            Credit_Unions,
            Yearly_Plan,
            Premium_bonds,
            Company_Share_Option_Plans,
            Post_Office_Card_Account
        ]
            model_adult.income_other_investment_income += v
        elseif atype in [Guaranteed_Equity_Bond, Government_Gilt_Edged_Stock]
            model_adult.income_bonds_and_gilts += v
        else
            @assert false "failed to map $atype"
        end
    end # accounts loop
end # map_investment_income

function map_alimony(frs_person::DataFrameRow, a_maint::DataFrame)::Real
    nmaints = size(a_maint)[1]
    alimony = 0.0 # note: not including children
    if frs_person.alimny == 1 # receives alimony
        if frs_person.alius == 2 # not usual
            alimony = safe_inc(0.0, frs_person.aluamt)
        else
            alimony = safe_inc(0.0, frs_person.aliamt)
        end
    end
    for c in 1:nmaints
        alimony = safe_inc(alimony, a_maint[c, :mramt])
    end
    alimony
end

function process_relationships!( model_person :: DataFrameRow, frs_person :: DataFrameRow )
    model_person.relationship_to_hoh = safe_assign( frs_person.relhrp )
    for i in 1:14
        rel = i < 10 ? "r0" : "r"
        relfrs = Symbol( "$(rel)$i" ) # :r10 or :r02 and so on
        relmod = Symbol( "relationship_$(i)") # :relationship_10 or :relationship_2
        model_person[relmod] = safe_assign(frs_person[relfrs])
    end
end

function process_job_rec!(model_adult::DataFrameRow, a_job::DataFrame)
    njobs = size(a_job)[1]

    earnings = 0.0
    actual_hours = 0.0
    usual_hours = 0.0
    health_insurance = 0.0
    alimony_and_child_support_paid = 0.0
    # care_insurance  = 0.0
    trade_unions_etc = 0.0
    friendly_societies = 0.0
    work_expenses = 0.0
    pension_contributions = 0.0
    avcs = 0.0
    other_deductions = 0.0
    student_loan_repayments = 0.0
    loan_repayments = 0.0
    self_employment_income = 0.0
    self_employment_expenses = 0.0
    self_employment_losses = 0.0
    tax = 0.0
    principal_employment_type = -1
    public_or_private = -1
    for j in 1:njobs
        if j == 1 # take 1st record job for all of these
            principal_employment_type = safe_assign(a_job[j, :etype])
            public_or_private = safe_assign(a_job[j, :jobsect])
        end
        usual_hours = safe_inc(usual_hours, a_job[j, :dvushr])
        actual_hours = safe_inc(actual_hours, a_job[j, :jobhours])

        # alimony_and_child_support_paid  = safe_inc( alimony_and_child_support_paid , a_job[j,udeduc0X])
        # care_insurance  = safe_inc( care_insurance , a_job[j,:othded0X]

        pension_contributions = safe_inc(pension_contributions, a_job[j, :udeduc1])
        avcs = safe_inc(avcs, a_job[j, :udeduc2])
        trade_unions_etc = safe_inc(trade_unions_etc, a_job[j, :udeduc3])
        friendly_societies = safe_inc(friendly_societies, a_job[j, :udeduc4])
        other_deductions = safe_inc(other_deductions, a_job[j, :udeduc5])
        loan_repayments = safe_inc(loan_repayments, a_job[j, :udeduc6])
        health_insurance = safe_inc(health_insurance, a_job[j, :udeduc7])
        other_deductions = safe_inc(other_deductions, a_job[j, :udeduc8])
        student_loan_repayments = safe_inc(student_loan_repayments, a_job[j, :udeduc9])
        work_expenses = safe_inc(work_expenses, a_job[j, :umotamt])# CARS FIXME add to this

        # self employment
        if a_job[j, :prbefore] > 0.0
            self_employment_income += a_job[j, :prbefore]
        elseif a_job[j, :profit1] > 0.0
            @assert a_job[j, :profit2] in [1, 2]
            if a_job[j, :profit2] == 1
                self_employment_income += a_job[j, :profit1]
            else
                self_employment_losses += a_job[j, :profit1]
            end
        elseif a_job[j, :seincamt] > 0.0
            self_employment_income += a_job[j, :seincamt]
        end
        # setax = safe_inc(0.0, a_job[j, :setaxamt])
        # tax += setax / 52.0

        # earnings
        addBonus = false
        if a_job[j, :ugross] > 0.0 # take usual when last not usual
            earnings += a_job[j, :ugross]
            addBonus = true
        elseif a_job[j, :grwage] > 0.0 # then take last
            earnings += a_job[j, :grwage]
            addBonus = true
        elseif a_job[j, :ugrspay] > 0.0 # then take total pay, but don't add bonuses
            earnings += a_job[j, :ugrspay]
        end
        if addBonus
            for i in 1:6
                bon = Symbol(string("bonamt", i))
                tax = Symbol(string("bontax", i))
                if a_job[j, bon] > 0.0
                    bon = a_job[j, bon]
                    if a_job[j, tax] == 2
                        bon /= (1 - 0.22) # fixme hack basic rate
                    end
                    earnings += bon / 52.0 # fixwme weeks per year
                end
            end # bonuses loop
        end # add bonuses
    end # jobs loop

    model_adult.usual_hours_worked = usual_hours
    model_adult.actual_hours_worked = actual_hours
    model_adult.income_wages = earnings
    model_adult.principal_employment_type = principal_employment_type
    model_adult.public_or_private = public_or_private
    ## FIXME look at this mapping again: pcodes
    model_adult.income_health_insurance = health_insurance
    # model_adult.income_# care_insurance  = # care_insurance
    model_adult.income_trade_unions_etc = trade_unions_etc
    model_adult.income_friendly_societies = friendly_societies
    model_adult.income_work_expenses = work_expenses
    model_adult.income_pension_contributions = pension_contributions
    model_adult.income_avcs = avcs
    model_adult.income_other_deductions = other_deductions
    model_adult.income_student_loan_repayments = student_loan_repayments # fixme maybe "slrepamt" or "slreppd"
    model_adult.income_loan_repayments = loan_repayments # fixme maybe "slrepamt" or "slreppd"

    model_adult.income_self_employment_income = self_employment_income
    model_adult.income_self_employment_expenses = self_employment_expenses
    model_adult.income_self_employment_losses = self_employment_losses

end


"""
Convoluted - take the benefit enum, make ...
FIXME: some represent one-off payments (winter fuel..) so maybe weeklyise, but all that
really matters is whether they are present
"""
function process_benefits!(model_adult::DataFrameRow, a_benefits::DataFrame)
    nbens = size(a_benefits)[1]
    for i in instances(Incomes_Type)
        if i >= dlaself_care && i <= personal_independence_payment_mobility
            ikey = make_sym_for_frame("income", i)
            model_adult[ikey] = 0.0
        end
    end
    for b in 1:nbens
        bno = a_benefits[b, :benefit]
        if !(bno in [46, 47]) # 2015 receipt in last 6 months of tax credits
            btype = Benefit_Type(bno)
            if btype <= Personal_Independence_Payment_Mobility
                ikey = make_sym_for_frame("income", btype)
                model_adult[ikey] = safe_inc(model_adult[ikey], a_benefits[b, :benamt])
            end
        end
    end
end

"""
Convoluted - take the benefit enum, make ...
"""
function process_assets!(model_adult::DataFrameRow, an_asset::DataFrame)
    nassets = size(an_asset)[1]
    for i in instances(Asset_Type)
        if (i > Missing_Asset_Type)
            ikey = make_sym_for_asset(i)
            model_adult[ikey] = 0.0
        end
    end
    for a in 1:nassets
        ano = an_asset[a, :assetype]
        atype = Asset_Type(ano)
        ikey = make_sym_for_asset(atype)
        v = an_asset[a, :howmuch]
        if an_asset[a, :howmuche] > 0
            v = an_asset[a, :howmuche]
        end
        model_adult[ikey] = safe_inc(model_adult[ikey], v)
    end
end

function infer_hours_of_care(hourtot::Integer)::Real
    hrs = Dict(
        0 => 0.0,
        1 => 2.0,
        2 => 7.0,
        3 => 14.0,
        4 => 27.5,
        5 => 42.5,
        6 => 75.0,
        7 => 100.0,
        8 => 10.0,
        9 => 27.5,
        10 => 50.0
    )
    h = 0.0
    if hourtot in keys(hrs)
        h = hrs[hourtot]
    end
    h
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
    hbai_adults::DataFrame
)::DataFrame

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
        nhbai = size(ad_hbai)[1]
        @assert nhbai in [0, 1]

        if nhbai == 1 # only non-missing in HBAI
            adno += 1
                ## also for children
            model_adult = adult_model[adno, :]
            model_adult.pno = frs_person.person
            model_adult.hid = frs_person.sernum
            model_adult.pid = get_pid(FRS, year, frs_person.sernum, frs_person.person)
            model_adult.from_child_record = 0
            model_adult.data_year = year
            model_adult.default_benefit_unit = frs_person.benunit
            model_adult.age = frs_person.age80
            model_adult.sex = safe_assign(frs_person.sex)
            model_adult.ethnic_group = safe_assign(frs_person.ethgr3)

            ## adult only
            a_job = job[((job.sernum.==frs_person.sernum).&(job.benunit.==frs_person.benunit).&(job.person.==frs_person.person)), :]

            a_pension = pension[((pension.sernum.==frs_person.sernum).&(pension.benunit.==frs_person.benunit).&(pension.person.==frs_person.person)), :]
            a_penprov = penprov[((penprov.sernum.==frs_person.sernum).&(penprov.benunit.==frs_person.benunit).&(penprov.person.==frs_person.person)), :]
            an_asset = assets[((assets.sernum.==frs_person.sernum).&(assets.benunit.==frs_person.benunit).&(assets.person.==frs_person.person)), :]
            an_account = accounts[((accounts.sernum.==frs_person.sernum).&(accounts.benunit.==frs_person.benunit).&(accounts.person.==frs_person.person)), :]
            a_maint = maint[((maint.sernum.==frs_person.sernum).&(maint.benunit.==frs_person.benunit).&(maint.person.==frs_person.person)), :]
            a_oddjob = oddjob[((oddjob.sernum.==frs_person.sernum).&(oddjob.benunit.==frs_person.benunit).&(oddjob.person.==frs_person.person)), :]
            a_benefits = benefits[((benefits.sernum.==frs_person.sernum).&(benefits.benunit.==frs_person.benunit).&(benefits.person.==frs_person.person)), :]
            npens = size(a_pension)[1]
            nassets = size(an_asset)[1]
            naaccounts = size(an_account)[1]
            nojs = size(a_oddjob)[1]

            model_adult.marital_status = safe_assign(frs_person.marital)
            model_adult.highest_qualification = safe_assign(frs_person.dvhiqual)
            model_adult.sic = safe_assign(frs_person.sic)

            model_adult.socio_economic_grouping = safe_assign(Integer(trunc(frs_person.nssec)))
            model_adult.age_completed_full_time_education = safe_assign(frs_person.tea)
            model_adult.years_in_full_time_work = safe_assign(frs_person.ftwk)
            model_adult.employment_status = safe_assign(frs_person.empstati)
            model_adult.occupational_classification = safe_assign(frs_person.soc2010)

            process_job_rec!(model_adult, a_job)

            penstuff = process_pensions(a_pension)
            model_adult.income_private_pensions = penstuff.pension
            model_adult.income_income_tax += penstuff.tax

            model_adult.income_pension_contributions = process_penprovs(a_penprov)

            map_investment_income!(model_adult, an_account)
            model_adult.income_property = safe_inc(0.0, frs_person.royyr1)
            if frs_person.rentprof == 2 # it's a loss
                model_adult.income_property *= -1 # a loss
            end
            model_adult.income_royalties = safe_inc(0.0, frs_person.royyr2)
            model_adult.income_other_income = safe_inc(0.0, frs_person.royyr3) # sleeping partners
            model_adult.income_other_income = safe_inc(
                model_adult.income_other_income,
                frs_person.royyr4
            ) # overseas pensions
            # payments from charities, bbysitting ..
            # model_adult.income_other_income = safe_inc( model_adult.income_other_income, frs_person.[x]
            model_adult.income_alimony_and_child_support_received = map_alimony(
                frs_person,
                a_maint
            )

            model_adult.income_odd_jobs = 0.0
            for o in 1:nojs
                model_adult.income_odd_jobs = safe_inc(
                    model_adult.income_odd_jobs,
                    a_oddjob[o, :ojamt]
                )
            end
            model_adult.income_odd_jobs /= 4.0 # since it's monthly

            ## TODO babysitting,chartities (secure version only??)
            ## TODO alimony and childcare PAID ??
            ## TODO allowances from absent spouses

            ## TODO income_education_allowances
            ## TODO income_foster_care_payments
            ## TODO income_student_grants
            ## TODO income_student_loans
            ## TODO income_income_tax
            ## TODO income_national_insurance
            ## TODO income_local_taxes

            process_benefits!(model_adult, a_benefits)
            process_assets!(model_adult, an_asset)

            ## also for child
            model_adult.registered_blind = (frs_person.spcreg1 == 1 ? 1 : 0)
            model_adult.registered_partially_sighted = (frs_person.spcreg2 == 1 ? 1 : 0)
            model_adult.registered_deaf = (frs_person.spcreg3 == 1 ? 1 : 0)

            model_adult.disability_vision = (frs_person.disd01 == 1 ? 1 : 0) # cdisd kids ..
            model_adult.disability_hearing = (frs_person.disd02 == 1 ? 1 : 0)
            model_adult.disability_mobility = (frs_person.disd03 == 1 ? 1 : 0)
            model_adult.disability_dexterity = (frs_person.disd04 == 1 ? 1 : 0)
            model_adult.disability_learning = (frs_person.disd05 == 1 ? 1 : 0)
            model_adult.disability_memory = (frs_person.disd06 == 1 ? 1 : 0)
            model_adult.disability_mental_disability = (frs_person.disd07 == 1 ? 1 : 0)
            model_adult.disability_stamina = (frs_person.disd08 == 1 ? 1 : 0)
            model_adult.disability_socially = (frs_person.disd09 == 1 ? 1 : 0)
            # disability_other_difficulty = Vector{Union{Real,Missing}}(missing, n),
            model_adult.health_status = safe_assign(frs_person.heathad)
            model_adult.hours_of_care_received = safe_inc(0.0, frs_person.hourcare)
            model_adult.hours_of_care_given = infer_hours_of_care(frs_person.hourtot) # also kid

            model_adult.is_informal_carer = (frs_person.carefl == 1 ? 1 : 0) # also kid
            process_relationships!( model_adult, frs_person )
        end # if in HBAI
    end # adult loop
    println("final adno $adno")
    adult_model[1:adno, :]
end # proc create_adult

function create_children(
    year::Integer,
    frs_children::DataFrame,
    childcare::DataFrame
)::DataFrame
    # I don;t care if the child is in HBAI or not - we'll sort that out when we match with the
    # live benefit units
    num_children = size(frs_children)[1]
    child_model = initialise_person(num_children)
    adno = 0
    for chno in 1:num_children
        if chno % 1000 == 0
            println("on year $year, chno $chno")
        end

        frs_person = frs_children[chno, :]

        a_childcare = childcare[((childcare.sernum.==frs_person.sernum).&(childcare.benunit.==frs_person.benunit).&(childcare.person.==frs_person.person)), :]
        nchildcares = size(a_childcare)[1]

        sernum = frs_person.sernum
        adno += 1
            ## also for children
        model_child = child_model[chno, :]
        model_child.pno = frs_person.person
        model_child.hid = frs_person.sernum
        model_child.pid = get_pid(FRS, year, frs_person.sernum, frs_person.person)
        model_child.from_child_record = 1

        model_child.data_year = year
        model_child.default_benefit_unit = frs_person.benunit
        model_child.age = frs_person.age
        model_child.sex = safe_assign(frs_person.sex)
        # model_child.ethnic_group = safe_assign(frs_person.ethgr3)
        ## also for child
        model_child.registered_blind = (frs_person.spcreg1 == 1 ? 1 : 0)
        model_child.registered_partially_sighted = (frs_person.spcreg2 == 1 ? 1 : 0)
        model_child.registered_deaf = (frs_person.spcreg3 == 1 ? 1 : 0)

        model_child.disability_vision = (frs_person.cdisd01 == 1 ? 1 : 0) # cdisd kids ..
        model_child.disability_hearing = (frs_person.cdisd02 == 1 ? 1 : 0)
        model_child.disability_mobility = (frs_person.cdisd03 == 1 ? 1 : 0)
        model_child.disability_dexterity = (frs_person.cdisd04 == 1 ? 1 : 0)
        model_child.disability_learning = (frs_person.cdisd05 == 1 ? 1 : 0)
        model_child.disability_memory = (frs_person.cdisd06 == 1 ? 1 : 0)
        model_child.disability_mental_disability = (frs_person.cdisd07 == 1 ? 1 : 0)
        model_child.disability_stamina = (frs_person.cdisd08 == 1 ? 1 : 0)
        model_child.disability_socially = (frs_person.cdisd09 == 1 ? 1 : 0)
        # disability_other_difficulty = Vector{Union{Real,Missing}}(missing, n),
        model_child.health_status = safe_assign(frs_person.heathch)
        model_child.income_wages = safe_inc( 0.0, frs_person.chearns )
        model_child.income_other_investment_income = safe_inc( 0.0, frs_person.chsave )
        model_child.income_other_income = safe_inc( 0.0, frs_person.chrinc )
        model_child.income_free_school_meals = 0.0
        for t in [:fsbval,:fsfvval,:fsmlkval,:fsmval]
            model_child.income_free_school_meals = safe_inc( model_child.income_free_school_meals, frs_person[t] )
        end
        model_child.is_informal_carer = (frs_person.carefl == 1 ? 1 : 0) # also kid
        process_relationships!( model_child, frs_person )
        # TODO education grants, all the other good child stuff EMA

        model_child.cost_of_childcare = 0.0
        model_child.hours_of_childcare = 0.0
        for c in 1:nchildcares
            if c == 1 # type of care from 1st instance
                model_child.childcare_type = safe_assign(a_childcare[c, :chlook])
                model_child.employer_provides_child_care = (a_childcare[c, :emplprov] == 2 ?
                                                            1 : 0)
            end
            model_child.cost_of_childcare = safe_inc(
                model_child.cost_of_childcare,
                a_childcare[c, :chamt]
            )
            model_child.hours_of_childcare = safe_inc(
                model_child.hours_of_childcare,
                a_childcare[c, :chhr]
            )
        end # child care loop
    end # chno loop
    child_model # send them all back ...
end

function create_household(
    year::Integer,
    frs_household::DataFrame,
    renter::DataFrame,
    mortgage::DataFrame,
    mortcont::DataFrame,
    owner::DataFrame,
    hbai_adults::DataFrame
)::DataFrame

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
    hh_model[1:hhno, :]
end


global HBAIS = Dict(
    2017 => "i1718.tab",
    2016 => "hbai1617_g4.tab",
    2015 => "hbai1516_g4.tab",
    2014 => "hbai1415_g4.tab",
    2013 => "hbai1314_g4.tab",
    2012 => "hbai1213_g4.tab",
    2011 => "hbai1112_g4.tab",
    2010 => "hbai1011_g4.tab",
    2009 => "hbai0910_g4.tab",
    2008 => "hbai0809_g4.tab",
    2007 => "hbai0708_g4.tab",
    2006 => "hbai0607_g4.tab",
    2005 => "hbai0506_g4.tab",
    2004 => "hbai0405_g4.tab",
    2003 => "hbai0304_g4.tab"
)


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
# hbai_household = loadtoframe("$(HBAI_DIR)/tab/h1718_all.tab")

prices = loadPrices("/mnt/data/prices/mm23/mm23_edited.csv")
gdpdef = loadGDPDeflator("/mnt/data/prices/gdpdef.csv")

model_households = initialise_household(0)
model_people = initialise_person(0)

for year in 2015:2017

    print("on year $year ")

    ## hbf = HBAIS[year]
    ## hbai_adults = loadtoframe("$(HBAI_DIR)/tab/$hbf")

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

    model_children_yr = create_children(year, child, chldcare)
    append!(model_people, model_children_yr)

    model_adults_yr = create_adults(
        year,
        adult,
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
    append!(model_people, model_adults_yr)


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

end

CSV.write("$(OUTPUT_DIR)model_households.tab", model_households, delim = "\t")
CSV.write("$(OUTPUT_DIR)model_people.tab", model_people, delim = "\t")
