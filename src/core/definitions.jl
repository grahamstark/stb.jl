#
#
#
@enum Sex male female

@enum Tenure_Type la_or_new_town_or_nihe_or_council_rented,
      housing_association_or_co_op_or_trust_rented,
      other_private_rented_unfurnished,
      other_private_rented_furnished,
      owned_with_a_mortgage_includes_part_rent_or_part_own,
      owned_outright,
      rent_free,
      squats );
   subtype Renting is Tenure_Type range la_or_new_town_or_nihe_or_council_rented .. other_private_rented_furnished;
