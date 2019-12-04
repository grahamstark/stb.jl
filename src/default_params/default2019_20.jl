# DEFAULT 2019/20 system
function load()
    sys = TaxBenefitSystem( "Scotland Default 2019/20")
    sys.it.earnings_rates = [19.0,20.0,21.0,41.0,46.0]./100.0
    sys.it.earnings_bands = [2_049.0, 12_444.0, 30_930.0, 150_000.0]
    sys.it.savings_rates  = [0.0, 20.0, 40.0, 45.0]./100.0
    sys.it.savings_bands  = [5_000.0, 37_500.0, 150_000.0]
    sys.it.dividend_rates = [0.0, 7.5,32.5,38.1]./100.0
    sys.it.dividend_bands = [2_000.0, 37_500.0, 150_000.0]
    sys.it.personal_allowance          = 12_500.00
    sys.it.blind_persons_allowance     = 2_450.00
    sys.it.married_couples_allowance   = 8_915.00
    sys.it.mca_minimum                 = 3_450.00
    sys.it.marriage_allowance          = 1_250.00
    sys.it.personal_savings_allowance  = 1_000.00
    sys
end
