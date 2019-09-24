module Utils

using Base.Unicode

export @exported_enum, qstrtodict, pretty, basiccensor, get_if_set
export addsysnotoname

function addsysnotoname( names, sysno ) :: Array{Symbol,1}
    a = Array{Symbol,1}(undef, 0)
    for n in names
        push!( a, Symbol(String( n )*"_$sysno"))
    end
    a
    # Symbol.(String.( names ).*"_sys_$sysno")
end

function get_if_set(key, dict::Dict, default)
  if haskey(dict, key)
    return dict[key]
  end
  default
end

"""
parse an html query string like "sex=male&joe=22&bill=21342&z=12.20"
into a dict. If the value looks like a number, it's parsed into either an Int64 or Float64
"""
function qstrtodict(query_string::AbstractString)::Dict{AbstractString,Any}
  d = Dict{AbstractString,Any}()
  strip(query_string)
  if (query_string == "")
    return d
  end
  as = split(query_string, "&")
  for a in as
    try
      aa = split(a, "=")
      k = aa[1]
      v = aa[2]
      try
        v = parse(Int64, v)
      catch
        try
          v = parse(Float64, v)
        catch
        end
      end
      d[k] = v
    catch

    end
  end
  d
end


"""
returns the string converted to a form suitable to be used as (e.g.) a Symbol,
with leading/trailing blanks removed, forced to lowercase, and with various
characters replaced with '_' (at most '_' in a run).
"""
function basiccensor(s::AbstractString)::AbstractString
  s = strip(lowercase(s))
  s = replace(s, r"[ \-,\t–]" => "_")
  s = replace(s, r"[=\:\)\('’‘]" => "")
  s = replace(s, r"[\";:\.\?\*”“]" => "")
  s = replace(s, r"_$" => "")
  s = replace(s, r"^_" => "")
  s = replace(s, r"^_" => "")
  s = replace(s, r"\/" => "_or_")
  s = replace(s, r"\&" => "_and_")
  s = replace(s, r"\+" => "_plus_")
  s = replace(s, r"_\$+$" => "")
  if occursin(r"^[\d].*", s)
    s = string("v_", s) # leading digit
  end
  s = replace(s, r"__" => "_")
  s = replace(s, r"^_" => "")
  s = replace(s, r"_$" => "")
  return s
end


"""
a_string_or_symbol_like_this => "A String Or Symbol Like This"
"""
function pretty(a)
  s = string(a)
  s = strip(lowercase(s))
  s = replace(s, r"[_]" => " ")
  Unicode.titlecase(s)
end


"""
 macro to define an enum and automatically
 add export statements for its elements
 see: https://discourse.julialang.org/t/export-enum/5396
"""
macro exported_enum(name, args...)
  esc(quote
    @enum($name, $(args...))
    export $name
    for a in $args
      local av = string(a)
      :(export $av)
    end
              # $([:(export $arg) for arg in args]...)
  end)
end

end # module
