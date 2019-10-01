opts = Dict(
    "css" => ["https://learn2.open.ac.uk/theme/styles.php/osep/1569489122_1567580537/all", "/css/oustb.css"],
    "include-in-header" => [
        "/js/jquery.js",
        "/js/jquery-ui/jquery-ui.min.js",
        "/js/numeral.js",
        "/js/mustache.min.js",
        "/js/stb-support.js",
        "/js/vega-lite.min.js",
        "/js/vega.js",
        "/js/vega-embed.min.js"
    ],
    "from" => "markdown+smart",
    "section-divs" => true,
    "standalone" => true,
    "number-sections" => true,
    "bibliography" => "includes/dd226.bib",
    "data-dir" => "/home/graham_s/pandoc_data/",
    "default-image-extension"=>"svg",
    "csl" => "/home/graham_s/pandoc_data/chicago-note-bibliography.csl",
    "to" => "html5"

);

function makeoptstring( opts :: Dict, format=nothing ) :: AbstractString
    oldformat = opts["to"]
    if format !== nothing
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
                s *= " $k=$ve"
            else
                s *= " $k "
            end
        end
    end
    opts["to"] = oldformat
    s
end

opts["include-after-body"]=["includes/main_form.html"]
opts["include-before-body"]=["includes/main_output.html"]

`/usr/bin/pandoc `

MD_DIR = "/home/graham_s/OU/DD226/docs/sections/"
OUT_DIR = "/var/www/ou/stb/"
INCLUDE_DIR = "/home/graham_s/VirtualWorlds/projects/ou/stb.jl/web/"

cmd=`/usr/bin/pandoc`
