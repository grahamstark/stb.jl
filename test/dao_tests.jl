using Test
using Model_Household
using FRS_Household_Getter


@testset begin

    @time initialise()
    nhhs = get_num_households()
    @time for hno in 1:nhhs
        hh = get_household( hno )
        if hno % 1000
            println( hh )
        end
    end

end
