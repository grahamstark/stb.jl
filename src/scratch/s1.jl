

function all_taxable()::Incomes_Dict
    eis = union(Set( keys( Exempt_Income )), Expenses )
    all_t = Incomes_Dict()
    for i in instances(Incomes_Type)
        if ! (i ∈ eis )
         all_t[i]=1.0
        end
    end
    all_t
end

const SAVINGS_INCOME :: Incomes_Dict = Incomes_Dict(



)

const DIVIDENDS = Incomes_Dict(
    dividends => 1.0
)

function make_non_savings()::Incomes_Dict
    excl = UnionAll(Set(Keys(DIVIDENDS)), SET( keys(SAVINGS_INCOME)))
    nsi = all_taxable()
    for i in excl
        delete!( nsi, i )
    end
    nsi
end

const NON_SAVINGS :: Incomes_Dict = make_non_savings()
