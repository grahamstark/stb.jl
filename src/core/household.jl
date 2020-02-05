#
using Definitions
using Uprating
using Dates

mutable struct Person
    hid::BigInt # == sernum
    pid::BigInt # == unique id (year * 100000)+
    pno::Integer # person number in household
    default_benefit_unit::Integer
    age::Integer

    sex::Sex
    ethnic_group::Ethnic_Group
    marital_status::Marital_Status
    highest_qualification::Qualification_Type

    sic::SIC_2007
    occupational_classification::Standard_Occupational_Classification
    public_or_private :: Employment_Sector
    principal_employment_type :: Employment_Type

    socio_economic_grouping::Socio_Economic_Group
    age_completed_full_time_education::Integer
    years_in_full_time_work::Integer
    employment_status::ILO_Employment
    actual_hours_worked::Real
    usual_hours_worked::Real

    income::Incomes_Dict
    assets::Asset_Dict
    # contracted_out_of_serps::Bool

    registered_blind::Bool
    registered_partially_sighted::Bool
    registered_deaf::Bool

    disabilities::Disability_Dict
    health_status::Health_Status
    relationships::Relationship_Dict
    relationship_to_hoh :: Relationship;
    is_informal_carer::Bool
    receives_informal_care_from_non_householder::Bool
    hours_of_care_received::Real
    hours_of_care_given::Real
    #
    # Childcare fields; assigned to children
    #
    hours_of_childcare :: Real
    cost_of_childcare :: Real
    childcare_type :: Child_Care_Type
    employer_provides_child_care :: Bool
end

People_Dict = Dict{BigInt,Person}
Pid_Array = Vector{BigInt}

mutable struct Household
    sequence::Integer # position in current generated dataset
    hid::BigInt
    interview_year::Integer
    interview_month::Integer
    quarter::Integer
    tenure::Tenure_Type
    region::Standard_Region
    ct_band::CT_Band
    council_tax::Real
    water_and_sewerage ::Real
    mortgage_payment::Real
    mortgage_interest::Real
    years_outstanding_on_mortgage::Integer
    mortgage_outstanding::Real
    year_house_bought::Integer
    gross_rent::Real # rentg Gross rent including Housing Benefit  or rent Net amount of last rent payment
    rent_includes_water_and_sewerage::Bool
    other_housing_charges::Real # rent Net amount of last rent payment
    gross_housing_costs::Real
    total_income::Real
    total_wealth::Real
    house_value::Real
    weight::Real
    people::People_Dict

end

function uprate!( pid :: BigInt, year::Integer, quarter::Integer, person :: Person )
    for (t,inc) in person.income
            person.income[t] = uprate( inc, year, quarter, UPRATE_MAPPINGS[t])
    end
    for (a,ass) in person.assets
            person.assets[a] = uprate( ass, year, quarter, UPRATE_MAPPINGS[a])
    end
    person.cost_of_childcare = uprate( person.cost_of_childcare, year, quarter, upr_earnings )
end

function uprate!( hh :: Household )

    hh.water_and_sewerage  = uprate( hh.water_and_sewerage , hh.interview_year, hh.quarter, upr_housing_rents )
    hh.mortgage_payment = uprate( hh.mortgage_payment, hh.interview_year, hh.quarter, upr_housing_oo )
    hh.mortgage_interest = uprate( hh.mortgage_interest, hh.interview_year, hh.quarter, upr_housing_oo )
    hh.mortgage_outstanding = uprate( hh.mortgage_outstanding, hh.interview_year, hh.quarter, upr_housing_oo )
    hh.gross_rent = uprate( hh.gross_rent, hh.interview_year, hh.quarter, upr_housing_rents )
    hh.other_housing_charges = uprate( hh.other_housing_charges, hh.interview_year, hh.quarter, upr_nominal_gdp )
    hh.gross_housing_costs = uprate( hh.gross_housing_costs, hh.interview_year, hh.quarter, upr_nominal_gdp )
    hh.total_income = uprate( hh.total_income, hh.interview_year, hh.quarter, upr_nominal_gdp )
    hh.total_wealth = uprate( hh.total_wealth, hh.interview_year, hh.quarter, upr_nominal_gdp )
    hh.house_value = uprate( hh.house_value, hh.interview_year, hh.quarter, upr_housing_oo )
    for (pid,person) in hh.people
        uprate!( pid, hh.interview_year, hh.quarter, person )
    end

end

function oldest_person( people :: People_Dict ) :: NamedTuple
    oldest = ( age=-999, pid=BigInt(0))
    for person in people
        if person.age > oldest.age
            oldest.age = person.age
            oldest.pid = person.pid
        end
    end
    oldest
end

function equivalence_scale( people :: People_Dict ) :: Dict{Equivalence_Scale_Type,Real}
    np = length(people)
    eqp = Vector{EQ_Person}()
    oldest_pid = oldest_person( people )
    for (pid,person) in people
        eqtype = eq_other_adult
        if pid == oldest_pid.pid
            eqtype = eq_head
        else
            if (person.age < 16) || (( person.age < 18 ) & ( person.employment_status in [Student,Other_Inactive]))
                eqtype = eq_dependent_child # needn't actually be dependent, of course
            elseif person.relationships[ oldest_pid.pid ] in [Spouse,Cohabitee,Civil_Partner]
                eqtype = eq_spouse_of_head
            else
                eqtype = eq_other_adult
            end
        end
        push!( eqp, EQ_Person( person.age, eqtype ))
    end
    get_equivalence_scales( eqp )
end

PeopleArray = Vector{Person}

struct BenefitUnit
    people :: People_Dict
    head :: BigInt
    spouse :: BigInt
    children :: Pid_Array
end

function num_people( bu :: BenefitUnit )::Integer
    1 + ((bu.spouse > 0) ? 1 : 0 ) + size( bu.children )[1]
end

function get_head( bu :: BenefitUnit )::Person
    bu.people[bu.head]
end

function get_spouse( bu :: BenefitUnit )::Union{Nothing,Person}
    if bu.spouse <= 0
        return nothing
    end
    bu.people[bu.spouse]
end


BenefitUnits = Vector{BenefitUnit}
BUAllocation = Vector{PeopleArray}


#
# This creates a array of references to each person in the houshold, broken into
# benefit units using the default FRS/EFS benefit unit number.
#
function default_bu_allocation( hh :: Household ) :: BUAllocation
    bua = BUAllocation()
    nbus = 0
    # how many bus
    for (pid,person) in hh.people
        nbus = max( nbus, person.default_benefit_unit )
    end
    ## create benefit units
    for buno in 1:nbus
        push!( bua, PeopleArray())
    end
    sz = size( bua )[1]
    ## allocate people to them
    for (pid,person) in hh.people
        pp = bua[person.default_benefit_unit]
        push!( pp, person )
    end
    ## sort people in each by pid
    for buno in 1:nbus
        sort!( bua[buno], lt=(left,right)->isless(right.age,left.age))
    end
    bua
end

#
# This creates a array of references to each person in the houshold, broken into
# benefit units using the default FRS/EFS benefit unit number.
#
function allocate_to_bus( bua :: BUAllocation ) :: BenefitUnits
    nbus = size(bua)[1]
    bus = BenefitUnits(undef, nbus)
    for i in 1:nbus
        people = People_Dict()
        head_pid :: BigInt = -1
        spouse_pid :: BigInt = -1
        children = Pid_Array()
        npeople = size( bua[i])[1]
        for p in 1:npeople
            person = bua[i][p]
            people[person.pid] = person
            if p == 1
                head_pid = person.pid
            else
                reltohead = person.relationships[head_pid]
                if reltohead in [Spouse,Cohabitee,Civil_Partner]
                    spouse_pid = person.pid
                    # FIXME we need to remove these checks if
                    # we're using a non-default allocation to bus
                    # @assert person.age >= 16
                else
                    # @assert person.age <= 19
                    push!( children, person.pid )
                end
            end
        end
        new_bu = BenefitUnit( people, head_pid, spouse_pid, children )
        bus[i] = new_bu
    end
    bus
end

function get_benefit_units(
    hh :: Household,
    allocator :: Function=default_bu_allocation ) :: BenefitUnits
    allocate_to_bus( allocator(hh))
end

# simple diagnostic prints for testing allocation

function printpids( pers :: Person )
    println( "pid: $(pers.pid) age $(pers.age) sex $(pers.sex) default_benefit_unit $(pers.default_benefit_unit) ")
end

function printpids( bu::BenefitUnit)
      head = get_head( bu )
      print( "HEAD: ")
      printpids( head )
      spouse = get_spouse( bu )
      if spouse != nothing
            print( "SPOUSE: ")
            printpids( spouse )

      end
      for chno in bu.children
            print( "CHILD_$(chno):")
            child = bu.people[chno]
            printpids( child )
      end
end

function printpids( people :: People_Dict )
    ks = sort(collect(keys(people)))
    for k in ks
        print( "PERSON_$k")
        printpids( people[k] )
    end
end

function printpids( buas::BUAllocation )
    nbus = size( buas )[1]
    for i in 1:nbus
        npeople = size( buas[i] )[1]
        println( "bu[$i]; num_people = $npeople:")
        for p in 1:npeople
            print( "PERS_$(p): ")
            printpids( buas[i][p])
        end
    end
end
