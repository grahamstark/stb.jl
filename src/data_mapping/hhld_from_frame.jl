using Definitions
using DataFrames
using CSV
using Model_Household


function map_person( model_person :: DataFrameRow )

    income = Incomes_Dict()
    for i in instances(Incomes_Type)
        ikey = make_sym_for_frame("income", i)
        if ! ismissing(model_person[ikey])
            if model_person[ikey] != 0.0
                income[i] = model_person[ikey]
            end
        end
    end

    assets = Asset_Dict()
    for i in instances(Asset_Type)
        if i != Missing_Asset_Type
            ikey = make_sym_for_asset( i )
            if ! ismissing(model_person[ikey])
                if model_person[ikey] != 0.0
                    assets[i] = model_person[ikey]
                end
            end
        end
    end

    disabilities = Disability_Dict()
    for i in instances(Disability_Type)
        ikey = make_sym_for_frame("disability", i)
        if ! ismissing(model_person[ikey])
            if model_person[ikey] == 1
                disabilities[i] = Bool(model_person[ikey])
            end
        end
    end

    relationships = Relationship_Dict()
    for i in 1:14
        relmod = Symbol( "relationship_$(i)") # :relationship_10 or :relationship_2
        irel = model_person[relmod]
        if (! ismissing( irel )) & ( irel >= 0 )
            pid = get_pid(
                FRS,
                model_person.data_year,
                model_person.hid,
                i )
            relationships[pid] = Relationship( irel )
        end
    end

    Person(

        BigInt(model_person.hid),  # BigInt# == sernum
        BigInt(model_person.pid),  # BigInt# == unique id (year * 100000)+
        model_person.pno,  # Integer# person number in household
        model_person.default_benefit_unit,  # Integer
        model_person.age,  # Integer

        Sex(model_person.sex),  # Sex
        Ethnic_Group(safe_assign(model_person.ethnic_group)),  # Ethnic_Group
        Marital_Status(safe_assign(model_person.marital_status)),  # Marital_Status
        Qualification_Type(safe_assign(model_person.highest_qualification)),  # Qualification_Type

        SIC_2007(safe_assign(model_person.sic)),  # SIC_2007
        Standard_Occupational_Classification(safe_assign(model_person.occupational_classification)),  # Standard_Occupational_Classification
        Employment_Sector(safe_assign(model_person.public_or_private)),  #  Employment_Sector
        Employment_Type(safe_assign(model_person.principal_employment_type)),  #  Employment_Type

        Socio_Economic_Group(safe_assign(model_person.socio_economic_grouping)),  # Socio_Economic_Group
        m2z(model_person.age_completed_full_time_education),  # Integer
        m2z(model_person.years_in_full_time_work),  # Integer
        ILO_Employment(safe_assign(model_person.employment_status)),  # ILO_Employment
        m2z(model_person.actual_hours_worked),  # Real
        m2z(model_person.usual_hours_worked),  # Real

        income,
        assets,

        safe_to_bool(model_person.registered_blind),
        safe_to_bool(model_person.registered_partially_sighted),
        safe_to_bool(model_person.registered_deaf),

        disabilities,
        Health_Status(safe_assign(model_person.health_status)),
        relationships,
        Relationship(model_person.relationship_to_hoh),
        safe_to_bool(model_person.is_informal_carer),
        safe_to_bool(model_person.receives_informal_care_from_non_householder),
        m2z(model_person.hours_of_care_received),
        m2z(model_person.hours_of_care_given),
        m2z(model_person.hours_of_childcare),
        m2z(model_person.cost_of_childcare),
        Child_Care_Type(safe_assign(model_person.childcare_type )),
        safe_to_bool( model_person.employer_provides_child_care )
    )

end

function map_hhld( hno::Integer, frs_hh :: DataFrameRow )

    people = People_Dict()

    Household(
        hno,
        frs_hh.hid,
        frs_hh.interview_year,
        frs_hh.interview_month,
        frs_hh.quarter,
        Tenure_Type(frs_hh.tenure),
        Standard_Region(frs_hh.region),
        CT_Band(frs_hh.ct_band),
        m2z(frs_hh.council_tax),
        m2z(frs_hh.water_and_sewerage ),
        m2z(frs_hh.mortgage_payment),
        m2z(frs_hh.mortgage_interest),
        m2z(frs_hh.years_outstanding_on_mortgage),
        m2z(frs_hh.mortgage_outstanding),
        m2z(frs_hh.year_house_bought),
        m2z(frs_hh.gross_rent),
        safe_to_bool(frs_hh.rent_includes_water_and_sewerage),
        m2z(frs_hh.other_housing_charges),
        m2z(frs_hh.gross_housing_costs),
        m2z(frs_hh.total_income),
        m2z(frs_hh.total_wealth),
        m2z(frs_hh.house_value),
        m2z(frs_hh.weight),
        people )
end

function load_hhld_from_frs( year :: Integer, hid :: Integer; hhld_fr :: DataFrame, pers_fr :: DataFrame ) :: Household
     frs_hh = hhld_fr[((hhld_fr.data_year .== year).& (hhld_fr.hid .== hid)),:]
     nhh = size( frs_hh )[1]
     @assert nhh in [0,1]
     if nhh == 1
         return load_hhld_from_frs( 1, frs_hh[1,:], pers_fr )
     else
        return missing
     end
end

function load_hhld_from_frs( hseq::Integer, hhld_fr :: DataFrameRow, pers_fr :: DataFrame ) :: Household
     hh = map_hhld( hseq, hhld_fr )
     pers_fr_in_this_hh = pers_fr[((pers_fr.data_year .== hhld_fr.data_year).&(pers_fr.hid .== hh.hid)),:]
     npers = size( pers_fr_in_this_hh )[1]
     @assert npers in 1:19
     for p in 1:npers
         pers = map_person( pers_fr_in_this_hh[p,:])
         hh.people[pers.pid] = pers
     end
     hh
 end


MODEL_HOUSEHOLDS=missing

function load_dataset()
    global MODEL_HOUSEHOLDS
    hh_dataset = CSV.File("$(MODEL_DATA_DIR)/model_households.tab", delim='\t') |> DataFrame
    people_dataset = CSV.File("$(MODEL_DATA_DIR)/model_people.tab", delim='\t') |> DataFrame
    npeople = size( people_dataset)[1]
    nhhlds = size( hh_dataset )[1]
    MODEL_HOUSEHOLDS = Vector{Union{Missing,Household}}(missing,nhhlds)
    for hseq in 1:nhhlds
        MODEL_HOUSEHOLDS[hseq] = load_hhld_from_frs( hseq, hh_dataset[hseq,:], people_dataset )
        uprate!( MODEL_HOUSEHOLDS[hseq] )
    end
end
