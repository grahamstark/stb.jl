using Test
using STBParameters
using JSON
using Utils

@testset "IT Parameter Tests" begin
    itsysdir :: IncomeTaxSys = get_default_it_system( year=2019, scotland=true)

    it = IncomeTaxSys()
    itweekly = deepcopy(it)
    @test itweekly.savings_rates == it.savings_rates
    weeklyise!( itweekly )
    annualise!( itweekly )
    @test isapprox( itweekly.non_savings_bands, it.non_savings_bands, rtol=0.00001 )
    @test itweekly.mca_minimum ≈ it.mca_minimum
    it_s = JSON.json( it )
    itj_dic = JSON.parse( it_s )
    itj = fromJSON( itj_dic )
    @test itj.non_savings_bands ≈ it.non_savings_bands
    @test itj.mca_minimum ≈ it.mca_minimum

end # example 1
