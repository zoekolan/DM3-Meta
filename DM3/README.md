# Set Packing Problem Solver

Ce projet contient une implémentation en Julia de différentes heuristiques pour résoudre le "Set Packing Problem" (Problème de couverture par ensembles). Le problème consiste à sélectionner un ensemble d'ensembles de manière à maximiser le nombre d'ensembles sélectionnés tout en respectant certaines contraintes.

## Fichiers inclus

- `utils.jl` : Ce fichier contient les fonctions utilitaires utilisées dans les différents algorithmes, telles que le calcul de l'utilité, de la valeur de la solution, la recherche d'indices d'éléments dans une liste, et le critère d'arrêt.

- `tabou.jl` : Ce fichier implémente la méthode de recherche tabou pour résoudre le Set packing Problem.

- `greedyConstruction.jl` : Ce fichier implémente l'heuristique de construction gloutonne pour résoudre le Set Packing Problem.

- `greedyRandomizedConstruction.jl` : Ce fichier implémente l'heuristique de construction gloutonne randomisée pour résoudre le problème.

- `localSearchImprovement.jl` : Ce fichier implémente l'amélioration par recherche locale (k-exchange 2-1) pour optimiser les solutions.

- `grasp.jl` : Ce fichier implémente l'algorithme GRASP (Greedy Randomized Adaptive Search Procedure) pour résoudre le problème en utilisant une combinaison d'heuristiques gloutonnes et de recherche locale.

- `main.jl` : Ce fichier est un script principal qui charge une instance du Set Packing Problem, exécute plusieurs heuristiques pour trouver une solution, et affiche les résultats. 

- `ReactiveGrasp.jl` : Ce fichier contient une tentative d'implémentation de l'heuristique GRASP réactif. L'algorithme tente de résoudre le problème du "Set Packing" en deux phases : la première phase consiste à exécuter GRASP pour chaque valeur d'alpha (α) et à mettre à jour les probabilités, tandis que la deuxième phase utilise ces probabilités mises à jour pour exécuter GRASP en choisissant aléatoirement la valeur d'alpha en fonction des probabilités.

- `influenceAlpha.jl` : Ce fichier nous permets de répondre à la question 2 du Devoir. Nous y étudions l'influence du paramètre α intervenant dans notre solution Grasp.

- `GraspExperiment.jl` : Ce fichier nous permets d'effectuer une expérimentation numérique de notre algorithme Grasp;

- `loadSPP.jl` : lecture d'une instance de SPP au format OR-library
- `setSPP.jl` : construction d'un modèle JuMP de SPP
- `getfname.jl`: collecte les noms de fichiers non cachés présents dans un répertoire donné
- `experiment.jl`: protocole pour mener une expérimentation numérique avec sorties graphiques

------

Le répertoire `Data` contient une sélection d'instances numériques de SPP au format OR-library :
- didactic.dat
- pb_100rnd0100.dat 
- pb_200rnd0100.dat 
- pb_500rnd0100.dat
- pb_1000rnd0100.dat
- pb_2000rnd0100.dat


## Utilisation

Pour utiliser ce projet, suivez ces étapes :

1. Assurez-vous d'avoir Julia installé sur votre système.

2. Exécutez le fichier `main.jl` pour charger une instance du problème et exécuter les différentes heuristiques. Vous pouvez vous amuser à modifier les diffférents paramètres comme α pour l'instance Grasp, m et Nα pour l'instance Réactive Grasp.
A NOTER : Notre implémentation Reactive Grasp étant en construction, vous devrez retirer les commentaires afin de pouvoir tenter l'exécution du Reactive Grasp.

3. Vous pouvez également personnaliser les instances du problème en modifiant le fichier de données ou en ajustant les paramètres dans `main.jl`.

## Exécution

Vous pouvez exécuter le projet en utilisant Julia. Par exemple, pour exécuter le fichier principal :

```
julia main.jl
```

## Résultats

Le script principal affiche les résultats des différentes heuristiques, y compris les valeurs des solutions trouvées par chaque algorithme.

## Configuration

Le projet nécessite les packages suivants, qui doivent être installés dans votre environnement Julia :

- InvertedIndices
- Random
- JuMP
- GLPK
- LinearAlgebra

Assurez-vous de les installer avant d'exécuter le projet.

## Auteurs

Ce projet a été développé par Zoé Kolan et Eléa Mouly en s'appuyant sur le projet de Xavier Gandibleux.

## Licence
La base sur laquelle s'appuie ce projet est sous licence : Copyright (c) 2017 Xavier Gandibleux.
