using Test
using Model_Household
using FRS_Household_Getter
using Example_Household_Getter
using Definitions

const RUK_PERSON = 100000001001
const SCOT_HEAD = 100000001002
const SCOT_SPOUSE = 100000001003

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

@testset "ch2 example 7; savings calc" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.income[self_employment_income] = 10_000.00
    pers.income[bank_interest] = 3_380.00
    pers.income[other_investment_income] = 36_680.00/0.8 # gross up at basic
    tax_due_ruk = 10_092.00 # inc already deducted at source
    tax_due_scotland = 10_092.00
end # example 7

#
# dividends
#

@testset "ch2 example 8; simple dividends" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.income[property] = 28_590.00
    pers.income[bank_interest] = 1_050.00
    pers.income[dividends] = 204_100.0 # gross up at basic
    tax_due_ruk = 74_834.94 # inc already deducted at source
    tax_due_scotland = 74_834.94+140.97
end # example 8

@testset "ch2 example 9; simple dividends" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.income[private_pensions] = 17_750.00
    pers.income[bank_interest] = 195.00
    pers.income[dividends] = 1_600.0 # gross up at basic
    tax_due_ruk = 1_050.00 # inc already deducted at source
    tax_due_scotland = 1_050.00-20.49
end # example 9


@testset "ch3 personal allowances ex 1 - hr allowance withdrawal" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.income[self_employment_income] = 110_520.00
    tax_due = 33_812.00
    pers.income[self_employment_income] += 100.0
    tax_due_ruk = 33_812.00+60.0
    tax_due_scotland = 33_812.00+61.5 ## FIXME actually, check this by hand
end # example1 ch3

@testset "ch3 personal allowances ex 2 - marriage allowance" begin
    names = Example_Household_Getter.initialise()
    scot = Example_Household_Getter.get_household( "mel_c2_scot" ) # scots are a married couple
    head = scot.people[SCOT_HEAD]
    spouse = scot.people[SCOT_SPOUSE]
    head.income[self_employment_income] = 110_520.00
    tax_due = 33_812.00
    head.income[self_employment_income] += 100.0
    tax_due_ruk = 33_812.00+60.0
    tax_due_scotland = 33_812.00+61.5 ## FIXME actually, check this by hand
end # example 2 ch3

@testset "ch3 blind person" begin
    names = Example_Household_Getter.initialise()
    ruk = Example_Household_Getter.get_household( "mel_c2" )
    pers = ruk.people[RUK_PERSON]
    pers.registered_blind = true
    # test that tax is 2450xmr
end

@testset "ch3 tax reducers"
    # check that mca is always 10% of amount
    # check marriage transfer is always basic rate tax credit
    # checl MCA only available if 1 spouse born befor 6th April  1935
    names = Example_Household_Getter.initialise()
    scot = Example_Household_Getter.get_household( "mel_c2_scot" ) # scots are a married couple
    head = scot.people[SCOT_HEAD]
    spouse = scot.people[SCOT_SPOUSE]
    head_ages = [75,90,90,70] # after 1935
    spouse_ages = [90,70,70,90]
    spouse_ages  = 90 # before aprol 35
    head_incomes = [19_100.0, 29_710.0,41_080.0,0.0]
    spouse_incomes = [12_450.0,0,13_950.0,49_300.0]
    for i in 1:4
        head.income[private_pension] = head_incomes[i]
        spouse.income[private_pension] = spouse_incomes[i]
        head.income[private = head_incomes[i]
        head.age = head_ages[i]
        spouse.age = spouse_ages[i]
    end
end