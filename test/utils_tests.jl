using Test
using Utils

@testset "Dates and Times" begin
    nw = Date( 2020, 01, 27)
    d = Date(1958,01,28)
    @test Utils.age_in_years( d, nw ) == 61
    d = Date(1958,01,27)
    @test Utils.age_in_years( d, nw ) == 62
    d = Date(1958,01,26)
    @test Utils.age_in_years( d, nw ) == 62

end # dates and times
