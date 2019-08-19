module Definitions
#
#
      using Utils

      export renting, owner_occupier
#
      export Tenure_Type,council_rented,housing_association,private_rented_unfurnished
      export private_rented_furnished,mortgaged,owned_outright,rent_free,squats
      export renting, owner_occupier
      export Sex, male, female

      @enum Sex male female

      @enum Tenure_Type begin ## from 2015 FRS tentyp2
            council_rented = 1 #la__or__new_town__or__nihe__or__council_rented = 1
            housing_association = 2 #housing_association__or__co_op__or__trust_rented = 2
            private_rented_unfurnished = 3 #other_private_rented_unfurnished = 3
            private_rented_furnished = 4 # other_private_rented_furnished = 4
            mortgaged = 5 #owned_with_a_mdortgage_includes_part_rent__or__part_own = 5
            owned_outright = 6
            rent_free = 7
            squats = 8
      end

     function renting( tt :: Tenure_Type ) :: Bool
           tt < mortgaged
     end

     function owner_occupier( tt :: Tenure_Type ) :: Bool
           tt in [mortgaged,owned_outright]
     end

end
