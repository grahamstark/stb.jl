using Test
using Model_Household
using FRS_Household_Getter


@testset begin

    @time nhhs = initialise()
    @time for hno in 1:nhhs
        hh = get_household( hno )
        if hno % 10_000 == 0
            println( hh )
        end
    end
end
