using Test
using Model_Household
using FRS_Household_Getter
using Example_Household_Getter
using Definitions

const RUK_PERSON = 100000001001
const SCOT_PERSON = 100000001002

@testset "Melville 2019 ch2 examples 1; basic calc Scotland vs RUK" begin
    # BASIC IT Calcaulation on
    @time names = Example_Household_Getter.initialise()
    income = [11_730,14_493,30_000,33_150.0,58_600,231_400]
    taxes_ruk = [2_346.0,2898.60,6_000,6_630.0,15_940.00,89_130.0]
    taxes_scotland = [2_325.51,2_898.60,6_155.07, 7260.57,17_695.07,92_613.07]
    @test size( income ) == size( taxes_ruk) == size( taxes_scotland )
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    scottish = Example_Household_Getter.get_household( "mel_c2_scot" )

    bus = default_bu_allocation( ruk )
    nbus = size(bus)[1]
    println( bus )
    @test nbus == 1 == size( bus[1])[1]
    pers = bus[1][1]
    for i in size(income)[1]
        pers.income[wages] = income[i]
        println( ruk.people[RUK_PERSON].income )
    end
end # example 1

@testset "Melville 2019 ch2 example 2; personal savings allowance" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    scottish = Example_Household_Getter.get_household( "mel_c2_scot" )
    income = [20_000,37_501,64_000,375_000.0]
    psa = [1_000.0,500.0,500.0,500.0]
    @test size( income ) == size( psa ) # same Scotland and RUK
    pers = ruk.people[RUK_PERSON] # doesn't matter S/RUK
    for i in size(income)[1]
        pers.income[wages] = income[i]

    end
end # example 2

@testset "ch2 example 3; savings calc" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.income[self_employment_income] = 40_000.00
    pers.income[bank_interest] = 1_500.00

    tax_due_ruk = 5_500.00
    tax_due_scotland = 5680.07

end # example 3

@testset "ch2 example 4; savings calc" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.income[property] = 16_700.00
    pers.income[bank_interest] = 1_100.00
    tax_due_ruk = 840.00
    tax_due_scotland = 819.51
end # example 4

@testset "ch2 example 5; savings calc" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.income[self_employment_income] = 58_850.00
    pers.income[bank_interest] = 980.00
    tax_due_ruk = 11_232.00
    tax_due_scotland = 12_864.57
end # example 5

@testset "ch2 example 6; savings calc" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.income[self_employment_income] = 240_325.00
    pers.income[bank_interest] = 1_600.00
    tax_due_ruk = 93_825.75
    tax_due_scotland = 97_397.17
end # example 6
