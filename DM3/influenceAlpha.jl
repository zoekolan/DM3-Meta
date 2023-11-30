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

# =========================================================================== #

# Loading a SPP instance
println("\nLoading...")
#Changez le nom du fichier pour tester d'autres instances (voir le dossier Data)
fname = "Data/pb_100rnd0100.dat"
P, A = loadSPP(fname)

# ETUDE DE L'INFLUENCE DE ALPHA SUR LA QUALITE DE LA SOLUTION
# On fait varier alpha et on compare les résultats obtenus en moyenne pour chaque alpha
# POUR PLUS DE PRECISION NOUS DEVRIONS FAIRE PLUS D'ITERATIONS POUR CHAQUE ALPHA

alphaSet= [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9] # list of α values
N = 10 # number of iterations for each α value
S_best = zeros(Int, length(P)) # initialize best solution
zBest = -Inf# best solution value
zWorst = Inf # worst solution value
m = length(alphaSet) # number of α values
zAvgk = Vector{Float64}(undef, m) # average solution value for each α value

for k in 1:m # for each α value
    z_avg = 0.0 # average solution value for current α value
    for i in 1:N # for each iteration of current α value
        alpha = alphaSet[k] 
        S = Grasp(A, P, alpha) # run GRASP
        z = fitness(S, P) # solution value
        z_avg += z/N # update average solution value 
        #= Nous ne comprenons pas pourquoi le fait d'ajouter les lignes en commentaire ci-dessous nous donne l'erreur suivante :
        LoadError: UndefVarError: `zBest` not defined - alors que notre zBest est bien défini au début du code =#
        #=if z > zBest && all(A * S .<= 1)  # update best solution if solution is feasible 
            S_best = S
            zBest = z
        end
        if z < zWorst && all(A * S .<= 1) # update worst solution if solution is feasible
            zWorst = z
        end =#
    end
    println("\nHeuristique GRASP avec alpha = ", alphaSet[k])
    println("moyenne de la solution : ", z_avg)
    println("----------------------------------------------------")
    zAvgk[k] = z_avg # store average solution value for current α value in a list
end

#println("\nRésumé des moyennes Obtenues pour chaque Alpha = ", zAvgk)
println("la valeur de alpha obtenant les meilleurs résultats en moyenne est : ", alphaSet[argmax(zAvgk)])
