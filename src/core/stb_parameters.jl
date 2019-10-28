#
using TBComponents
using Definitions

mutable struct IncomeTax

   earnings_rates :: RateBands
   earnings_bands :: RateBands
   savings_rates  :: RateBands
   savings_bands  :: RateBands
   dividend_rates :: RateBands
   dividend_bands :: RateBands
   pa    :: Real

end

mutable struct NationalInsurance

end

mutable struct TaxBenefitSystem
   name :: AbstractString
   it :: IncomeTax
   ni :: NationalInsurance
end
