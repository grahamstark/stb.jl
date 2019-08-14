module Utils

using Base.Unicode

      export exported_enum, pretty, basiccensor

      """
      returns the string converted to a form suitable to be used as (e.g.) a Symbol,
      with leading/trailing blanks removed, forced to lowercase, and with various
      characters replaced with '_' (at most '_' in a run).
      """
      function basiccensor( s :: AbstractString ) :: AbstractString
             s = strip( lowercase( s ))
             s = replace( s, r"[ \-,\t–]" => "_" )
             s = replace( s, r"[=\:\)\('’‘]" => "" )
             s = replace( s,  r"[\";:\.\?\*”“]" => "" )
             s = replace( s,  r"_$"=> "" )
             s = replace( s,  r"^_"=> "" )
             s = replace( s,  r"^_"=> "" )
             s = replace( s,  r"\/"=> "_or_" )
             s = replace( s,  r"\&"=> "_and_" )
             s = replace( s,  r"\+"=> "_plus_" )
             s = replace( s,  r"_\$+$"=> "" )
             if occursin( r"^[\d].*", s )
                      s = string("v_", s ) # leading digit
             end
             s = replace( s,  r"__+"=> "_" )
             s = replace( s, r"^_" => "" )
             s = replace( s, r"_$" => "" )
             return s
      end


      """
      a_string_or_symbol_like_this => "A String Or Symbol Like This"
      """
     function pretty( a )
           s = string( a )
           s = strip( lowercase( s ))
           s = replace( s, r"[_]" => " " )
           Unicode.titlecase( s )
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
