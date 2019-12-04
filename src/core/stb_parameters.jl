#
using TBComponents
using Definitions
using Parameters
using Unitful



@with_kw mutable struct IncomeTaxSys
   earnings_rates :: RateBands = [19.0,20.0,21.0,41.0,46.0]./100.0
   earnings_bands :: RateBands = [2_049.0, 12_444.0, 30_930.0, 150_000.0]
   savings_rates  :: RateBands = [0.0, 20.0, 40.0, 45.0]./100.0
   savings_bands  :: RateBands = [5_000.0, 37_500.0, 150_000.0]
   dividend_rates :: RateBands = [0.0, 7.5,32.5,38.1]./100.0
   dividend_bands :: RateBands = [2_000.0, 37_500.0, 150_000.0]
   personal_allowance          = 12_500.00
   blind_persons_allowance     = 2_450.00
   married_couples_allowance   = 8_915.00
   mca_minimum                 = 3_450.00
   marriage_allowance          = 1_250.00
   personal_savings_allowance  = 1_000.00
end

function weekly( )

end

@with_kw mutable struct NationalInsuranceSys
   rates :: RateBands = [1.0]
end

@with_kw mutable struct TaxBenefitSystem
   name :: AbstractString = "Scotland 2919/20"
   it   :: IncomeTaxSys = IncomeTaxSys()
   ni   :: NationalInsuranceSys = NationalInsuranceSys()
end


include( "../default_params/default2019_20.jl")
