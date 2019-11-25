# steps to upgrade server

## Install a new version of Julia

1. location `/opt/julia-xxx`; symlink this to /opt/julia/
2. `/etc/profile.d/grahams.sh` check settings e.g.
    export PATH=/opt/julia/bin:$PATH
    export JULIA_NUM_THREADS=4
3. packages TODO proper package thing with dependencies..
4. but meantime..
    - `Pkg.installed()`
    - turn into install list e.g. `~/install/all_packages_nov_2019.jl`
    - and run the install on the new julia

## Server install

1. `/lib/systemd/system/stb.service`
2. server environment in `/etc/systemd/user/gks_environment` (e.g.) JULIA_NUM_THREADS
3. server script: `/home/graham_s/VirtualWorlds/projects/ou/stb.jl/scripts/run_server.sh`
