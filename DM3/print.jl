# =========================================================================== #
# Compliant julia 1.x

# Using the following packages
using JuMP, GLPK
using LinearAlgebra
using InvertedIndices
using UnicodePlots

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
#heuristique Tabou
# Loading a SPP instance
println("\nLoading...")
#Changez le nom du fichier pour tester d'autres instances (voir le dossier Data)
fname = "Data/pb_100rnd0100.dat"
P, A = loadSPP(fname)

nb_experiment = 10

Tabu_soluce = tabu_search(A, P)
z_Tabu = fitness(Tabu_soluce, P)

