#!/bin/sh
cd $OU_HOME
# --procs=auto
$JULIA/bin/julia --startup-file=yes --optimize=3 --track-allocation=none --check-bounds=no --code-coverage=none src/web/server.jl 
