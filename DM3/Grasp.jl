using LinearAlgebra
using InvertedIndices

include("localSearchImprovement.jl")
include("greedyRandomizedConstruction.jl")
include("Utils.jl")

# Implémentation de la fonction Grasp

function Grasp(A, P, α) # A is the constraint matrix, P is the profit vector, α is the parameter
    S = zeros(Int, length(P)) # initialize solution
    S_best = zeros(Int, length(P)) # initialize best solution
    nb = 0
    while !isFinished(S_best, A) # repeat until stopping rule is satisfied (see Utils.jl file fo details about stopping rule)
        S = greedyRandomizedConstruction(A, P, α) # greedy randomized construction
        S = localSearchImprovement(S, A, P) # local search improvement
        if fitness(S, P) > fitness(S_best, P) # update best solution
                S_best = S 
        end
        nb +=1
    end # until stopping rule
    print("++++++++++++++++++++++++++++++++++++")
    print(nb)
    return S_best # return best solution
end




