module Model_Household

  export Household, Person, People_Dict
  export uprate!, equivalence_scale, oldest_person, default_bu_allocation
  export get_benefit_units, num_people, get_head,get_spouse, printpids

  include( "household.jl" )


end
