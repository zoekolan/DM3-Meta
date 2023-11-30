using LinearAlgebra
using InvertedIndices

include("Utils.jl")

# Implémentation de la fonction  greedyRandomizedConstruction qui effectue la construction gloutonne randomisée

function greedyRandomizedConstruction(A, P, α) # A is the constraint matrix, P is the profit vector, α is the parameter
    S = zeros(Int, length(P)) # initialize solution
    C = collect(1:length(P)) # candidate set - list of indices of elements not yet in the solution (in didactic : [1,2,3,4,5,6,7,8,9])
    A_new = copy(A)
    C_new = copy(P)
    while !isFinished(S, A) # repeat until stopping rule is satisfied (see Utils.jl file fo details about stopping rule)
        u = utility(C, C_new, A_new) # compute utility of each element in the candidate set
        limit = minimum(u) + α * (maximum(u) - minimum(u)) # compute limit
        RCL = [v for v in C if u[find_e(v, C)] >= limit]  # compute RCL (Restricted Candidate List) - list of elements with utility greater than limit
        e = rand(RCL) # select a random element from RCL
        index = findfirst(x -> x == e, C) # find index of element e in candidate set C
        S[e] = 1 # add element to the solution

        #= !!! New Matrix construction !!! - we chose to remove the columns of the elements that are in the solution 
        as well as the columns of the elements that are in the same row as the element that we just added to the solution=#
        rows_to_check = findall(A_new[:, index] .== 1)  # We retrieve the rows that have a 1 in column e
        liste = []  # we create a list of lists that will contain the columns to remove
        for row in rows_to_check # for each row that has a= 1 in column e
            col = findall(A_new[row, :] .== 1)  # we retrieve the columns that have a 1 in this row
            push!(liste, col)# we add the columns to the list
        end 

        col_to_remove = reduce(union, liste) # we remove the duplicates
        A_new = A_new[:, setdiff(1:end, col_to_remove)] # we remove the columns from the matrix
        C = C[setdiff(1:end, col_to_remove)] # we remove the corresponding candidates from the candidate set
    end
    return S # return solution
end 