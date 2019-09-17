using Test
using Model_Household
using FRS_Household_Getter
using Example_Household_Getter



@testset "Example Households" begin
    @time nhhs = Example_Household_Getter.initialise()
    names = Example_Household_Getter.example_names()
    @time for hno in 1:nhhs
        hh = FRS_Household_Getter.get_household( names[hno] )
        println(names[hno])
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
