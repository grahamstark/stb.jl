using Definitions
using DataFrames
using CSV
using Household


function map_person( model_person :: DataFrameRow )

    income = Incomes_Dict()
    for i in instances(Incomes_Type)
        ikey = make_sym_for_frame("income", i)
        if model_person[ikey] != 0.0
            income[ikey] = model_person[ikey]
        end
    end

    assets = Asset_Dict()
    for i in instances(Asset_Type)
        ikey = make_sym_for_asset( i )
        if model_person[ikey] != 0.0
            assets[ikey] = model_person[ikey]
        end
    end

    disabilities = Disability_Dict()
    for i in instances(disabilities)
        ikey = make_sym_for_frame("disability", i)
        if model_person[ikey] == 1
            disabilities[ikey] = Bool(model_person[ikey])
        end
    end

    relationships = Relationship_Dict()
    for i in 1:14
        relmod = Symbol( "relationship_$(i)") # :relationship_10 or :relationship_2
        if ! missing( model_person[relmod] )
            pid = get_pid(
                frs,
                model_person.year,
                model_person.hid,
                model_person.pno )
            relationships( pid, Relationship(model_person[relmod]))
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
        model_person.age_completed_full_time_education,  # Integer
        model_person.years_in_full_time_work,  # Integer
        ILO_Employment(safe_assign(model_person.employment_status)),  # ILO_Employment
        safe_assign(model_person.actual_hours_worked),  # Real
        safe_assign(model_person.usual_hours_worked),  # Real
        income,
        assets,
        safe_to_bool(model_person.registered_blind),
        safe_to_bool(model_person.registered_partially_sighted),
        safe_to_bool(model_person.registered_deaf),
        Health_Status(safe_assign(model_person.health_status)),
        relationships,
        Relationsip(model_person.relationship_to_hoh),
        safe_to_bool(model_person.is_informal_care),
        safe_to_bool(model_person.receives_informal_care_from_non_householder),
        model_person.hours_of_care_received,
        model_person.hours_of_care_given,
        safe_assign(model_person.hours_of_childcare),
        safe_assign(model_person.cost_of_childcare),
        Child_Care_Type(safe_assign(model_person.childcare_type )),
        safe_to_bool( model_person.employer_provides_child_care )
    )

end

function map_hhld( frs_hh :: DataFrameRow )

    people = People_Dict()

    Household(
        frs_hh.hid,
        frs_hh.interview_year,
        frs_hh.interview_month,
        frs_hh.quarter,
        Tenure_Type(frs_hh.tenure),
        Standard_Region(frs_hh.region),
        CT_Band(frs_hh.ct_band),
        frs_hh.council_tax,
        frs_hh.water_and_sewerage ,
        frs_hh.mortgage_payment,
        frs_hh.mortgage_interest,
        frs_hh.years_outstanding_on_mortgage,
        frs_hh.mortgage_outstanding,
        frs_hh.year_house_bought,
        frs_hh.gross_rent,
        frs_hh.rent_includes_water_and_sewerage,
        frs_hh.other_housing_charges,
        frs_hh.gross_housing_costs,
        frs_hh.total_income,
        frs_hh.total_wealth,
        frs_hh.house_value,
        frs_hh.weight,
        people )
end

function load_hhld_from_frs( year :: Integer, hid :: Integer; hhld_fr :: DataFrame, pers_fr :: DataFrame ) :: Household
    frs_hh = hhld_fr[((hhld_fr.year .== year).&(hhld_fr.hid .== hid)),:]
    hh :: Household = map_hhld( frs_hh )
end
