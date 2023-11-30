using LinearAlgebra
using InvertedIndices

include("Utils.jl")

# Implémentation de la fonction localSearchImprovement qui effectue l'amélioration par recherche locale k-exchange 2-1

function localSearchImprovement(S, A, P) # S is the solution, A is the constraint matrix, P is the profit vector
    improved = false 
    compteur = 0 
    while improved != true # repeat until no improvement is possible
        k= 2
        p= 1
        compteur = compteur + 1 # we count the number of iterations

         # We create two lists, one with the indices of the zeros and the other with the indices of the ones
         zeros_indices = findall(S .== 0)
         ones_indices = findall(S .== 1)

         # we replace k 0 values with 1 : we choose k random indices in the list of zeros and we replace the 0 with a 1
         S_new = copy(S)
         for  i in 1:k # we repeat the operation k times
             random_index = rand(zeros_indices) # we choose a random index in the list of zeros
             S_new[random_index] = 1 # we replace the 0 with a 1 in a new solution set
             deleteat!(zeros_indices, findfirst(isequal(random_index), zeros_indices)) # we delete the index from the list of zeros
             zeros_indices = findall(S_new .== 0) # we update the list of zeros
             ones_indices = findall(S_new .== 1) # we update the list of ones
         end

         # we replace p 1 values with 0 : we choose p random indices in the list of ones and we replace the 1 with a 0
         for  i in 1:p # we repeat the operation p times
             random_index = rand(ones_indices) # we choose a random index in the list of ones
             S_new[random_index] = 0 # we replace the 1 with a 0 in a new solution set
             deleteat!(ones_indices, findfirst(isequal(random_index), ones_indices)) # we delete the index from the list of ones
             zeros_indices = findall(S_new .== 0) # we update the list of zeros
             ones_indices = findall(S_new .== 1) # we update the list of ones
         end

        # We check if the new solution is better and admissible
         if all(A * S_new .<= 1) && fitness(S_new, P) > fitness(S, P) # if the new solution is better and admissible
            S = S_new # update solution
            improved = true # we update the boolean to true 
         end

        # We stop the loop if we have done more than 400 iterations
         if compteur > 400 
            break
         end

        end

    return S # return solution
end