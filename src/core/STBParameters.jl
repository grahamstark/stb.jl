module STBParameters

   using TBComponents
   using Definitions
   using Parameters
   using Unitful
   using Utils
   using JSON


   include( "stb_parameters.jl" )

   export IncomeTaxSys, NationalInsuranceSys, TaxBenefitSystem
   export weeklyise!, annualise!, fromJSON

end
