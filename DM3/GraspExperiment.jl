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
#include("experiment.jl")

# =========================================================================== #
#EXPERIMENTATION NUMERIQUE SUR LE GRAP#
# Nous n'avons pas réussi à utiliser les plots de experiment.jl d'où la mise en commentaire de cette partie du code.

# Loading a SPP instance
println("\nLoading...")
allfinstance      =  ["Data/didactic.dat", "Data/pb_100rnd0100.dat","Data/pb_100rnd0100.dat"]
nbInstances       =  length(allfinstance)
nbRunGrasp        =  10   # nombre de fois que la resolution GRASP est repetee

alpha = 0.7
function GraspExperiment(allfinstance, nbInstances, nbRunGrasp, alpha)
    liste_global = [Vector{Any}() for _ in 1:nbInstances] 
    for q in 1:length(allfinstance)
        fname = allfinstance[q]
        P, A = loadSPP(fname)
        liste_z = Vector{Float64}(undef, nbRunGrasp)
        α = 0.7 # valeur de alpha - vous pouvez jouer avec cette valeur
        for i in 1:nbRunGrasp
            grasp_soluce = Grasp(A, P, alpha)
            z_grasp = fitness(grasp_soluce, P)
            liste_z[i] = z_grasp
        end
        #println("\nHeuristique GRASP - liste de z: ", liste_z)
        liste_global[q] = liste_z 
    end
    return liste_global
end

#GraspExperiment(allfinstance, nbInstances, nbRunGrasp, alpha)
function GraspExpe(A, P, α) # A is the constraint matrix, P is the profit vector, α is the parameter
    zconstruction = []
    zamelioration = []
    zbest = []
    zbetter=0

    nbIter = 0
    S = zeros(Int, length(P)) # initialize solution
    S_best = zeros(Int, length(P)) # initialize best solution
    while !isFinished(S_best, A) # repeat until stopping rule is satisfied (see Utils.jl file fo details about stopping rule)
        S = greedyRandomizedConstruction(A, P, α) # greedy randomized construction
        push!(zconstruction,fitness(S,P))
        S = localSearchImprovement(S, A, P) # local search improvement
        push!(zamelioration ,fitness(S,P))
        zbetter = max(zbetter, last(zamelioration))
        push!(zbest ,zbetter)
        if fitness(S, P) > fitness(S_best, P) # update best solution
                S_best = S      
        end
        nbIter += 1
    end # until stopping rule
    return zconstruction, zamelioration, zbest, nbIter # return best solution
end

fname = "Data/pb_100rnd0100.dat"
P, A = loadSPP(fname)
GraspExpe(A, P, alpha)
