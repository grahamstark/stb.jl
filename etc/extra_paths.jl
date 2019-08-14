
## fixme ** should work
# or add_dirs in project
VW_DIR="/home/graham_s/VirtualWorlds/projects/"
STB_DIR=joinpath(VW_DIR,"stb.jl")
for dr in ["core","web","data_mapping","persist", "general"]
    # print(dr)
    push!(LOAD_PATH, joinpath(STB_DIR,"src",dr))
end
push!(LOAD_PATH,joinpath(STB_DIR,"test"))
# if exists in startup dir "add_path.jl"
