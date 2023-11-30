using InvertedIndices
using LinearAlgebra
using Random
#using UnicodePlots
using PyPlot

include("Utils.jl")
include("localSearchImprovement.jl")
include("greedyRandomizedConstruction.jl")

# Fonction qui génère les voisins d'une solution donnée 
function generate_neighbors(current_solution, A, P) # current_solution  solution courante, A est matrice de contraintes, P vecteur de profits

    # Initialisation de la liste des voisins (liste vide)
    neighboring_solutions = []

    # Pour chaque élément de la solution courante, on génère un voisin en effectuant un changement sur la solution courante
    for i in 1:(length(current_solution)-1)#TODO ce truc là bizarre
        neighbor = copy(current_solution)  # On copie la solution courante pour créer un voisin

        #neighbor = localSearchImprovement(neighbor, A, P) # Option 1 - On effectue un changement sur le voisin avec un k-exchange 2-1
        neighbor = greedyRandomizedConstruction(A, P, 0.7) # Option 2 - On génère un voisin avec une construction gloutonne randomisée
        push!(neighboring_solutions, neighbor)  # On ajoute le voisin à la liste des voisins
    end
    return neighboring_solutions # On retourne la liste des voisins
end

# Fonction qui trouve le meilleur voisin non tabou parmi les voisins générés sauf si critère d'aspiration
function find_best_non_taboo(neighboring_solutions, tabu_list, A, P, best_solution) # neighboring_solutions  liste de solutions voisines, tabu_list liste tabou,A est matrice de contraintes,  P vecteur de profits, best_solution est meilleure solution trouvée
    best_neighbor = neighboring_solutions[1]  # Initialisation du meilleur voisin
    visited = []
    fitnesses = []
    indices = collect(1:length(neighboring_solutions))
    for neighbor in neighboring_solutions # Pour chaque voisin dans la liste des voisins
        if !(neighbor in tabu_list)  # Vérification si le voisin n'est pas dans la liste tabou
            push!(visited, copy(neighbor))
            push!(fitnesses, fitness(neighbor,P))
            # Si le voisin n'est pas tabou, on le compare avec le meilleur voisin actuel et on vérifie qu'il est admissible
            if fitness(neighbor,P) > fitness(best_neighbor,P) && all(A * neighbor .<= 1)
                best_neighbor = neighbor # On met à jour le meilleur voisin
            end
        end
    end
    # Critère d'aspiration : si le meilleur voisin est tabou mais meilleur que la meilleure solution, on le prend
    if fitness(best_neighbor, P) > fitness(best_solution, P)
        best_solution = best_neighbor # On met à jour la meilleure solution
    end
    #lineplot(indices, fitnesses, title="Example", canvas=DotCanvas, border=:ascii)

    return best_neighbor # On retourne le meilleur voisin
end

# Implémentation de la fonction tabu_search qui effectue la recherche tabou pour le problème SPP 
function tabu_search(A, P) #A est matrice de contraintes,  P vecteur de profits
    # Initialisation de la solution courante et de la meilleure solution trouvée
    #current_solution = greedyConstruction(A, P)  # solution initiale gloutonne
    current_solution = greedyRandomizedConstruction(A, P, 0.7) # solution initiale gloutonne randomisée
    best_solution = copy(current_solution)
    max_tabu_size = 3  # Taille maximale de la liste tabou

    fitness_values = []

    tabu_list = [] # Initialisation de la liste tabou en utilisant une liste vide

    # Définition du critère d'arrêt :nombre d'itérations maximal
    max_iterations = 10
    iterations = 0

    while iterations < max_iterations # Tant que le nombre d'itérations est inférieur au nombre d'itérations maximal
        neighboring_solutions = generate_neighbors(current_solution, A, P) # Générer les mouvements possibles depuis la solution actuelle (voisins)

        # Trouver le meilleur voisin non tabou parmi les voisins générés sauf si critère d'aspiration
        best_neighbor = find_best_non_taboo(neighboring_solutions, tabu_list, A, P, best_solution) 

        current_solution = best_neighbor  # Mettre à jour la solution courante avec le meilleur voisin trouvé

        # Mettre à jour la meilleure solution si nécessaire et si elle est admissible 
        if fitness(current_solution, P) > fitness(best_solution, P) && all(A * current_solution .<= 1)
            best_solution = copy(current_solution) 
        end

        # Mettre à jour la liste tabou en ajoutant le mouvement courant
        push!(tabu_list, copy(current_solution)) 

        # Vérifie si la taille de la liste tabou dépasse la limite 
        if length(tabu_list) > max_tabu_size
            # Supprime les éléments les plus anciens pour maintenir la taille limite
            deleteat!(tabu_list, 1:(length(tabu_list) - max_tabu_size))
        end
        iterations +=1
        push!(fitness_values, fitness(current_solution, P))
    end

    # Plot des valeurs de fitness après toutes les itérations
    plot(1:max_iterations, fitness_values, marker="o", linestyle="-", color="b")
    xlabel("Iterations")
    ylabel("Fitness")
    title("Fitness des solutions voisines")
    grid(true)
    show()

    return best_solution
end

