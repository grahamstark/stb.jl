using Test
using Model_Household
using FRS_Household_Getter
using Example_Household_Getter



@testset "Example Households" begin
    @time names = Example_Household_Getter.initialise()

    @time for name in names
        hh = Example_Household_Getter.get_household( name )
        println(name)
        println( hh )
        println()
    end
end

@testset  "Main FRS Households"  begin

    @time nhhs = FRS_Household_Getter.initialise()
    @time for hno in 1:nhhs
        hh = FRS_Household_Getter.get_household( hno )
        if hno % 10_000 == 0
            println( hh )
            println()
        end
    end
end
