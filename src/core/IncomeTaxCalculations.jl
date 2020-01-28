module IncomeTaxCalculations

import Dates
import Dates: Date

const MCA_DATE = Date(1935,4,6) # fixme make this a parameter

"""

"""
function old_enough_for_mca(
    age            :: Integer,
    model_run_date :: Dates.TimeType = Dates.now() ) :: Bool
    (model_run_date - Dates.Year(trunc(round(age)))) < MCA_DATE # FIXME maybe parse out any decimal thing into weeks or months
end

function calcincometax( )

end

end # module
