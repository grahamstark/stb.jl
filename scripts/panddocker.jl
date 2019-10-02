MD_DIR = "/home/graham_s/OU/DD226/docs/sections/"
OUT_DIR = "/var/www/ou/stb/"
INCLUDE_DIR = "/home/graham_s/VirtualWorlds/projects/ou/stb.jl/web/includes/"
PANDOC_DIR = "/home/graham_s/pandoc_data/"
NullableString = Union{Missing,AbstractString}

const DEFAULT_OPTS = Dict(
    "data-dir"          => PANDOC_DIR,
    "css"               =>
            [
                "https://learn2.open.ac.uk/theme/styles.php/osep/1569489122_1567580537/all",
                "/css/oustb.css"
            ],
    "include-in-header" => [ "$INCLUDE_DIR/ou-js-headers.html"],
    "from"              => "markdown+smart",
    "section-divs"      => true,
    "standalone"        => true,
    "number-sections"   => true,
    "bibliography"      => "DD226.bib",
    "default-image-extension"=>"svg",
    "csl"               => "$PANDOC_DIR/chicago-note-bibliography.csl",
    "to"                => "html5",
    "filter"            => "pandoc-citeproc",
    "template"          => "$INCLUDE_DIR/ou-template.html"

);

function makeoptstring( opts :: Dict, format=missing ) :: AbstractString
    oldformat = opts["to"]
    if ! ismissing(format)
         opts["to"] = format
    end
    s = ""
    for (k,v) in opts
        if v === true
            v = ""
        end
        if length(k) == 1
            k = "-$k"
        else
            k = "--$k"
        end
        if ! (typeof( v ) <: Array)
            v = [v]
        end
        for ve in v
            if ve !== ""
                s *= " $k $ve"
            else
                s *= " $k "
            end
        end
    end
    opts["to"] = oldformat
    s
end

function addone(
    pos,
    count,
    title::String,
    output :: NullableString,
    form::NullableString,
    content::AbstractString,
    prev_content::NullableString,
    next_content::NullableString )

    opts = deepcopy( DEFAULT_OPTS )
    includes = []
    if ! ismissing(output)
        push!( includes, "$(INCLUDE_DIR)/$(output).html" )
    end
    if ! ismissing(form)
        push!( includes, "$(INCLUDE_DIR)/$(form).html" )
    end
    if pos > 1
        opts["number-offset"]=(pos-1)
    end
    opts["include-before-body"] = includes
    forward = ""
    backward = ""
    if ! ismissing(prev_content )
        backward="<a href='$(next_content).html'>prev</a>"
    end
    if ! ismissing(prev_content )
        forward="<a href='$next_content).html'>prev</a>"
    end
    nav = "<footer><nav>$backward $forward</nav></footer>"
    opts["include-after-body"] = nav
    opts["o"] = "$(OUT_DIR)$(content).html"
    optstr = makeoptstring( opts )
    optstr *= " $(MD_DIR)$(content).md"

    cmd=`/usr/bin/pandoc $optstr`
    println( cmd )
    run( cmd )
end

addone( 1, 2, "Introduction",missing,missing,"intro",missing,missing)
