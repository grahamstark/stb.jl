# 
include( "definitions.jl" )

mutable struct IncomeTax

end

mutable struct NationalInsurance

end

mutable struct TaxBenefitSystem
   name :: AbstractString
   it :: IncomeTax
   ni :: NationalInsurance
end
