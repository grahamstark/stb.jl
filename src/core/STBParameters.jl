module STBParameters

   using TBComponents
   using Definitions
   using Parameters
   using Unitful
   using Utils
   using JSON


   # include( "stb_parameters.jl" )

   export IncomeTaxSys, NationalInsuranceSys, TaxBenefitSystem
   export weeklyise!, annualise!, fromJSON


   ## TODO Use Unitful to have currency weekly monthly annual counts as annotations

   @with_kw mutable struct IncomeTaxSys
      earnings_rates :: RateBands = [19.0,20.0,21.0,41.0,46.0]
      earnings_bands :: RateBands = [2_049.0, 12_444.0, 30_930.0, 150_000.0]
      savings_rates  :: RateBands = [0.0, 20.0, 40.0, 45.0]
      savings_bands  :: RateBands = [5_000.0, 37_500.0, 150_000.0]
      dividend_rates :: RateBands = [0.0, 7.5,32.5,38.1]
      dividend_bands :: RateBands = [2_000.0, 37_500.0, 150_000.0]
      personal_allowance          = 12_500.00
      blind_persons_allowance     = 2_450.00
      married_couples_allowance   = 8_915.00
      mca_minimum                 = 3_450.00
      marriage_allowance          = 1_250.00
      personal_savings_allowance  = 1_000.00
   end

   function annualise!( it :: IncomeTaxSys )
      it.earnings_rates .*= 100.0
      it.earnings_bands .*= 100.0
      it.savings_rates .*= 100.0
      it.savings_bands .*= 100.0
      it.dividend_rates .*= 100.0
      it.earnings_bands .*= WEEKS_PER_YEAR
      it.savings_bands .*= WEEKS_PER_YEAR
      it.dividend_bands .*= WEEKS_PER_YEAR
      it.personal_allowance *= WEEKS_PER_YEAR
      it.blind_persons_allowance *= WEEKS_PER_YEAR
      it.married_couples_allowance *= WEEKS_PER_YEAR
      it.mca_minimum *= WEEKS_PER_YEAR
      it.marriage_allowance *= WEEKS_PER_YEAR
      it.personal_savings_allowance *= WEEKS_PER_YEAR
   end

   function weeklyise!( it :: IncomeTaxSys )

      it.earnings_rates ./= 100.0
      it.earnings_bands ./= 100.0
      it.savings_rates ./= 100.0
      it.savings_bands ./= 100.0
      it.dividend_rates ./= 100.0
      it.earnings_bands ./= WEEKS_PER_YEAR
      it.savings_bands ./= WEEKS_PER_YEAR
      it.dividend_bands ./= WEEKS_PER_YEAR
      it.personal_allowance /= WEEKS_PER_YEAR
      it.blind_persons_allowance /= WEEKS_PER_YEAR
      it.married_couples_allowance /= WEEKS_PER_YEAR
      it.mca_minimum /= WEEKS_PER_YEAR
      it.marriage_allowance /= WEEKS_PER_YEAR
      it.personal_savings_allowance /= WEEKS_PER_YEAR
   end

   """
   Map from
   """
   function fromJSON( json :: Dict ) :: IncomeTaxSys
      it.earnings_rates = convert( RateBands, json["earnings_rates"] )
      it.earnings_bands  = convert( RateBands, json["earnings_bands"] )
      it.savings_rates = convert( RateBands, json["savings_rates"] )
      it.savings_bands = convert( RateBands, json["savings_bands"] )
      it.dividend_rates = convert( RateBands ,json["dividend_rates"] )
      it.earnings_bands = convert( RateBands ,json["earnings_bands"] )
      it.savings_bands = convert( RateBands ,json["savings_bands"] )
      it.dividend_bands = convert( RateBands ,json["dividend_bands"] )
      it.personal_allowance = json["personal_allowance"]
      it.blind_persons_allowance = json["blind_persons_allowance"]
      it.married_couples_allowance = json["married_couples_allowance"]
      it.mca_minimum = json["mca_minimum"]
      it.marriage_allowance = json["marriage_allowance"]
      it.personal_savings_allowance = json["personal_savings_allowance"]
      it
   end

   @with_kw mutable struct NationalInsuranceSys
      rates :: RateBands = [1.0]
   end

   @with_kw mutable struct TaxBenefitSystem
      name :: AbstractString = "Scotland 2919/20"
      it   :: IncomeTaxSys = IncomeTaxSys()
      ni   :: NationalInsuranceSys = NationalInsuranceSys()
   end

   function save( filename :: AbstractString, sys :: TaxBenefitSystem )
       JSON.print( filename, sys )
   end


   # include( "../default_params/default2019_20.jl")
   # defsys = load()



end
