# =========================================================================== #
# Compliant julia 1.x

# Using the following packages
using JuMP, GLPK
using LinearAlgebra
using InvertedIndices

include("loadSPP.jl")
include("setSPP.jl")
include("getfname.jl")
include("Grasp.jl")
include("Utils.jl")
include("localSearchImprovement.jl")
include("greedyRandomizedConstruction.jl")
include("greedyConstruction.jl")
include("tabou.jl")

# =========================================================================== #

# Loading a SPP instance
println("\nLoading...")
#Changez le nom du fichier pour tester d'autres instances (voir le dossier Data)
fname = "Data/pb_100rnd0100.dat"
P, A = loadSPP(fname)
#@show P
#@show A

#heuristique de construction gloutonne
@time begin
greedy_soluce = greedyConstruction(A, P)
z_greedy = fitness(greedy_soluce, P)
end
println("\nHeuristique de construction gloutonne: ", greedy_soluce )
println("Valeur de la solution : ", z_greedy )
println("----------------------------------------------------")

#heuristique de localSearchImprovement k-p exchange 2-1
@time begin
local_soluce = localSearchImprovement(greedy_soluce, A, P)
z_local = fitness(local_soluce, P)
end
println("\nHeuristique localSearchImprovement k-p exchange 2-1: ", local_soluce)
println("Valeur de la solution : ", z_local)
println("----------------------------------------------------")

#heuristique de construction Random
@time begin
greedy_random_soluce = greedyRandomizedConstruction(A, P, 0.7)
z_greedy_random = fitness(greedy_random_soluce, P)
end
println("\nHeuristique de construction Random : ", greedy_random_soluce)
println("Valeur de la solution : ", z_greedy_random)
println("----------------------------------------------------")

#heuristique GRASP
α = 0.7 # valeur de alpha - vous pouvez jouer avec cette valeur
@time begin
grasp_soluce = Grasp(A, P, α)
z_grasp = fitness(grasp_soluce, P)
end
println("\nHeuristique GRASP : ", grasp_soluce)
println("Valeur de la solution : ", z_grasp)
println("----------------------------------------------------")

#heuristique Tabou
@time begin
Tabu_soluce = tabu_search(A, P)
z_Tabu = fitness(Tabu_soluce, P)
end
println("\nHeuristique Tabou: ", Tabu_soluce )
println("Valeur de la solution : ", z_Tabu )
println("----------------------------------------------------")

#=Solving a SPP instance with GLPK
@time begin
println("\nSolving a SPP instance with GLPK...")
solverSelected = GLPK.Optimizer
spp = setSPP(P, A)

set_optimizer(spp, solverSelected)
optimize!(spp)

end

# Displaying the results
println("z = ", objective_value(spp))
print("x = "); println(value.(spp[:x]))=#



# =========================================================================== #



