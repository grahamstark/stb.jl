module IncomeTaxCalculations

import Dates
import Dates: Date, now, TimeType, Year

import Model_Household: Person
import STBParameters: IncomeTaxSys

using Definitions

export calc_income_tax, old_enough_for_mca

const MCA_DATE = Date(1935,4,6) # fixme make this a parameter

"""
Very rough approximation to MCA age - ignores all months since we don't have that in a typical dataset
TODO maybe overload this with age as a Date?
"""
function old_enough_for_mca(
    age            :: Integer,
    model_run_date :: TimeType = now() ) :: Bool
    (model_run_date - Year(age)) < MCA_DATE
end

function calc_income_tax(
    pers   :: Person,
    sys    :: IncomeTaxSys,
    spouse :: Union{Person,Nothing} = nothing ) :: Real

    0.0
end


end # module
