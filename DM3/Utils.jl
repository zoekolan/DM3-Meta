using LinearAlgebra
using InvertedIndices

# Nous avons rassemblé dans ce fichier les fonctions qui sont utilisées dans les différents algorithmes

#Implémentation de la fonction utility qui calcule l'utilité de chaque candidat
function utility(C, P, A) # C is the candidate set, P is the profit vector, A is the constraint matrix
    u = zeros(length(C)) # initialize utility vector
    S = vec(sum(A, dims=1)) # compute sum of each column of A
    for e in 1:length(C) # for each element in the candidate set C
        value_C = C[e] # value_C is the value of the element in the candidate set C
        u[e] = P[value_C] / S[e] # compute utility of element e and store it in utility vector u 
    end               
    return u # return utility
end

# Implémentation de la fonction fitness qui calcule la valeur d'une solution
function fitness(S, P) # S is the solution, P is the profit vector
    return sum(S .* P)  # return solution value
end

# Implémentation de la fonction find_e qui trouve l'indice d'un élément dans une liste
function find_e(e, C) # e is the element, C is the list
    for i in 1:length(C) # for each element in the list
        if C[i] == e # if element is equal to e
            return i # return index
        end
    end
end

# Implémentation de la fonction isFinished qui sera notre critère d'arrêt pour Grasp, greedyRandomizedConstruction, greedyConstruction 
function isFinished(S, A) # S is the solution, A is the constraint matrix
    # we stop if solution is feasible and there is no element that can be added to the solution
    for i in 1:length(S) # for each element in the solution
        if S[i] == 0 # if element is equal to 0 (not in the solution) 
            S_new = copy(S)
            S_new[i] = 1 # add element to solution
            if all(A * S_new .<= 1) # if solution is feasible 
                return false # return false (we can continue to search for a better solution)
            end
        end
    end
    return true # return true (we stop the search)
end