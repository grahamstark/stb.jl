module Utils

using Base.Unicode

export exported_enum, pretty

     function pretty( a )
           s = string( a )
           s = strip( lowercase( s ))
           s = replace( s, r"[_]" => " " )
           Unicode.titlecase( s )
     end
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
