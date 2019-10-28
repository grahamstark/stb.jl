using Test
using Model_Household
using FRS_Household_Getter
using Example_Household_Getter



@testset "Example Households" begin
    @time names = Example_Household_Getter.initialise()

    @time for name in names
        hh = Example_Household_Getter.get_household( name )
        bus = default_bu_allocation( hh )
        println(name)
        println( hh )
        println()
    end
end

@testset  "Main FRS Households"  begin

    @time nhhs,npeople,nhh2 = FRS_Household_Getter.initialise(
        household_name = "model_households_scotland",
        people_name    = "model_people_scotland",
        start_year = 2015
    )
    maxbus = -1
    npers_from_bus = 0
    num_wrong_age = 0
    num_bus = 0
    @time for hno in 1:nhhs
        hh = FRS_Household_Getter.get_household( hno )
        bus = default_bu_allocation( hh )
        nbus = size(bus)[1]
        @test nbus in 1:12
        for buno in 1:nbus
            num_bus += 1
            np = size( bus[buno])[1]
            for i in 1:np
                pers = bus[buno][i]
                # sorted right way
                if i > 1
                    @test pers.pid < bus[buno][i-1].pid
                    @test pers.pno < bus[buno][i-1].pno
                    if pers.age > bus[buno][i-1].age
                        num_wrong_age += 1
                    end
                end
                npers_from_bus += 1
            end
        end
        maxbus = max(maxbus, nbus )
        if hno % 10_000 == 0
            println( hh )
            println()
        end
    end
    println( "num HHss = $nhhs")
    println( "num BUs = $num_bus")
    println( "num people = $npeople")
    println( "largest number of BUs = $maxbus")
    println( "num out-of-sync ages $num_wrong_age")
    # bu allocation doesn't result in anyone being lost
    @test npers_from_bus == npeople
end
