#!/bin/sh
cd $OU_HOME
$JULIA/bin/julia --procs=auto --optimize=3 --track-allocation=none --check-bounds=no --code-coverage=none src/web/server.jl 
