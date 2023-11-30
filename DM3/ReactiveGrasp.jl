using LinearAlgebra
using InvertedIndices
using Random

include("localSearchImprovement.jl")
include("greedyRandomizedConstruction.jl")
include("Grasp.jl")
include("Utils.jl")

# Tentative d'implémentation de la fonction ReactiveGRASP qui effectue l'heuristique GRASP réactive 

function ReactiveGRASP(A, cost, m, Nα) # A is the constraint matrix, cost is the profit vector, m is the number of α values, Nα is the number of iterations for each α value
    α_values = rand(m) # list of α values (randomly generated)
    S_best = zeros(Int, length(cost)) # initialize best solution
    zBest = -Inf # best solution value 
    zWorst = Inf # worst solution value
    zAvgk =  Vector{Float64}(undef, m) # average solution value for each α value

    P = fill(1/m, m) # initialize list of probabilities (uniform distribution) 
    
    # First phase : we run GRASP for each α value and we update the probabilities after each iteration 
    for k in 1:m # for each α value
        α = α_values[k] # current α value
        zAvg = 0 # average solution value for current α value
        for i in 1:Nα # for each iteration of current α value
            S = Grasp(A, cost, α) # run GRASP
            z = fitness(S, cost) # solution value
            zAvg += z/Nα # update average solution value
            if z > zBest && all(A * S .<= 1)  # update best solution if solution is feasible 
                S_best = S
                zBest = z
            end
            if z < zWorst && all(A * S .<= 1) # update worst solution if solution is feasible
                zWorst = z
            end
        end   
        
        zAvgk[k] = zAvg # store average solution value for current α value in a list 
        updateParameters(zBest, zWorst, zAvgk, P) # update probabilities (see updateParameters function below)
    end 
    
    #Second phase : we run GRASP for each α value taking into account the new probabilities 
    compteur = 0 
    while compteur < 100
        zAvg = 0.0 # average solution value for current α value
        for i in 1:Nα # for each iteration of current α value

            α = rand(DiscreteNonParametric(P, α_values)) # TO DO : FIND A WAY TO CHOOSE THE α VALUE ACCORDING TO THE PROBABILITIES

            S = GRASP(A, cost, α) # run GRASP
            z = fitness(S, cost) # solution value
            zAvg += z/Nα # update average solution value
            if z > zBest && all(A * S .<= 1)# update best solution if solution is feasible
                S_best = S
                zBest = z
            end
            if z < zWorst && all(A * S .<= 1) # update worst solution if solution is feasible
                zWorst = z
            end
        end
        zAvgk[k] = zAvg # store average solution value for current α value in a list
        updateParameters(zBest, zWorst, zAvg, P) # update probabilities (see updateParameters function below)

        compteur = compteur + 1 
    end 
    return S_best # return best solution
end

# Implémentation de la fonction updateParameters qui met à jour les probabilités
function updateParameters(zBest, zWorst, zAvg, P) # zBest is the best solution value, zWorst is the worst solution value, zAvg is the average solution value, P is the list of probabilities
    for k in 1:length(P)
        qk = (zAvg[k] - zWorst) / (zBest - zWorst) 
        P[k] = qk # update probability of each α value 
    end
    # P = P ./ sum(P) 
    return P
end

#= RETIREZ CE COMMENTAIRE POUR TESTER L'HEURISTIQUE REACTIVE GRASP
#heuristique ReactiveGRASP
m = 10 # nombre de valeurs de alpha à tester - vous pouvez jouer avec cette valeur
Nα = 3 # nombre d'itérations pour chaque valeur de alpha - vous pouvez jouer avec cette valeur
Rgrasp_soluce = ReactiveGRASP(A, P, m, Nα)
z_Rgrasp = fitness(Rgrasp_soluce, P)
println("\nHeuristique ReactiveGRASP : ", Rgrasp_soluce)
println("Valeur de la solution : ", z_Rgrasp)
println("----------------------------------------------------") =#


