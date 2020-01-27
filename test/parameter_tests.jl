using Test
using STBParameters
using JSON
using Utils

@testset "IT Parameter Tests" begin

    it = IncomeTaxSys()
    itweekly = deepcopy(it)
    @test itweekly == it
    weeklyise!( itweekly )
    annualise!( itweekly )
    @test itweekly.earnings_bands ≈ it.earnings_bands
    @test itweekly.mca_minimum ≈ it.mca_minimum
    it_s = JSON.json( it )
    itj_dic = JSON.parse( it_s )
    itj = fromJSON( itj_dic )
    @test itj.earnings_bands ≈ it.earnings_bands
    @test itj.mca_minimum ≈ it.mca_minimum

end # example 1
