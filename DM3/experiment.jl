# --------------------------------------------------------------------------- #
# Perform a numerical experiment (with a fake version of GRASP-SPP)
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
        zbetter = max(zbetter, zamelioration)
        push!(zbest ,zbetter)
        if fitness(S, P) > fitness(S_best, P) # update best solution
                S_best = S      
        end
        nbIter += 1
    end # until stopping rule
    return zconstruction, zamelioration, zbest, nbIter # return best solution
end

function graspSPP(fname, alpha, nbIterationGrasp)

    zconstruction = zeros(Int64,nbIterationGrasp)
    zamelioration = zeros(Int64,nbIterationGrasp)
    zbest = zeros(Int64,nbIterationGrasp)
    zbetter=0

    for i=1:nbIterationGrasp
        zconstruction[i] = rand(15:40) # # livrable du DM2
        zamelioration[i] = rand(0:10) + zconstruction[i] # livrable du DM2
        zbetter = max(zbetter, zamelioration[i])
        zbest[i] = zbetter
    end
    return zconstruction, zamelioration, zbest
end

function plotRunGrasp(iname,zinit, zls, zbest)
    figure("Examen d'un run",figsize=(6,6)) # Create a new figure
    title("GRASP-SPP | \$z_{Init}\$  \$z_{LS}\$  \$z_{Best}\$ | " * iname)
    xlabel("Itérations")
    ylabel("valeurs de z(x)")
    ylim(0, maximum(zbest)+2)

    nPoint = length(zinit)
    x=collect(1:nPoint)
    xticks([1,convert(Int64,ceil(nPoint/4)),convert(Int64,ceil(nPoint/2)), convert(Int64,ceil(nPoint/4*3)),nPoint])
    plot(x,zbest, linewidth=2.0, color="green", label="meilleures solutions")
    plot(x,zls,ls="",marker="^",ms=2,color="green",label="toutes solutions améliorées")
    plot(x,zinit,ls="",marker=".",ms=2,color="red",label="toutes solutions construites")
    vlines(x, zinit, zls, linewidth=0.5)
    legend(loc=4, fontsize ="small")
end

function plotAnalyseGrasp(iname, x, zmoy, zmin, zmax)
    figure("bilan tous runs",figsize=(6,6)) # Create a new figure
    title("GRASP-SPP | \$z_{min}\$  \$z_{moy}\$  \$z_{max}\$ | " * iname)
    xlabel("Itérations (pour nbRunGrasp)")
    ylabel("valeurs de z(x)")
    ylim(0, zmax[end]+2)

    nPoint = length(x)
    intervalle = [reshape(zmoy,(1,nPoint)) - reshape(zmin,(1,nPoint)) ; reshape(zmax,(1, nPoint))-reshape(zmoy,(1,nPoint))]
    xticks(x)
    errorbar(x,zmoy,intervalle,lw=1, color="black", label="zMin zMax")
    plot(x,zmoy,linestyle="-", marker="o", ms=4, color="green", label="zMoy")
    legend(loc=4, fontsize ="small")
end

function plotCPUt(allfinstance, tmoy)
    figure("bilan CPUt tous runs",figsize=(6,6)) # Create a new figure
    title("GRASP-SPP | tMoy")
    ylabel("CPUt moyen (s)")

    xticks(collect(1:length(allfinstance)), allfinstance, rotation=60, ha="right")
    margins(0.15)
    subplots_adjust(bottom=0.15,left=0.21)
    plot(collect(1:length(allfinstance)),tmoy,linestyle="--", lw=0.5, marker="o", ms=4, color="blue", label="tMoy")
    legend(loc=4, fontsize ="small")
end


# Simulation d'une experimentation numérique  --------------------------

#Pkg.add("PyPlot") # Mandatory before the first use of this package
using PyPlot

function simulation()
    allfinstance      =  ["didactic.txt", "fn2.txt", "fn3.txt", "fnA.txt", "fnX.txt"]
    nbInstances       =  length(allfinstance)
    nbRunGrasp        =  30   # nombre de fois que la resolution GRASP est repetee
    nbIterationGrasp  =  200  # nombre d'iteration que compte une resolution GRASP
    nbDivisionRun     =  10   # nombre de division que compte une resolution GRASP

    zinit = zeros(Int64, nbIterationGrasp) # zero
    zls   = zeros(Int64, nbIterationGrasp) # zero
    zbest = zeros(Int64, nbIterationGrasp) # zero

    x     = zeros(Int64, nbDivisionRun)
    zmax  = Matrix{Int64}(undef,nbInstances , nbDivisionRun); zmax[:] .= typemin(Int64)  # -Inf entier
    zmoy  = zeros(Float64, nbInstances, nbDivisionRun) # zero
    zmin  = Matrix{Int64}(undef,nbInstances , nbDivisionRun) ; zmin[:] .= typemax(Int64)  # +Inf entier
    tmoy  = zeros(Float64, nbInstances)  # zero

    # calcule la valeur du pas pour les divisions
    for division=1:nbDivisionRun
        x[division] = convert(Int64, ceil(nbIterationGrasp / nbDivisionRun * division))
    end

    println("Experimentation GRASP-SPP avec :")
    println("  nbInstances       = ", nbInstances)
    println("  nbRunGrasp        = ", nbRunGrasp)
    println("  nbIterationGrasp  = ", nbIterationGrasp)
    println("  nbDivisionRun     = ", nbDivisionRun)
    println(" ")
    cpt = 0

    # run non comptabilise (afin de produire le code compile)
    zinit, zls, zbest = graspSPP(allfinstance[1], 0.5, 1) #TODO

    for instance = 1:nbInstances
        # les instances sont traitees separement

        print("  ",allfinstance[instance]," : ")
        for runGrasp = 1:nbRunGrasp
            # une instance sera resolue nbrungrasp fois

            start = time() # demarre le compteur de temps
            alpha = 0.75
            zinit, zls, zbest = graspSPP(allfinstance[instance], alpha, nbIterationGrasp) #TODO
            tutilise = time()-start # arrete et releve le compteur de temps
            cpt+=1; print(cpt%10)

            # mise a jour des resultats collectes
            for division=1:nbDivisionRun
                zmax[instance,division] = max(zbest[x[division]], zmax[instance,division])
                zmin[instance,division] = min(zbest[x[division]], zmin[instance,division])
                zmoy[instance,division] =  zbest[x[division]] + zmoy[instance,division]
            end #division
            tmoy[instance] = tmoy[instance] + tutilise

        end #run
        for division=1:nbDivisionRun
             zmoy[instance,division] =  zmoy[instance,division] /  nbRunGrasp
        end #division
        tmoy[instance] = tmoy[instance] / nbRunGrasp
        println(" ")

    end #instance

    #Pkg.add("PyPlot") # Mandatory before the first use of this package
    println(" ");println("  Graphiques de synthese")
#    using PyPlot
    instancenb = 1
    plotRunGrasp(allfinstance[instancenb], zinit, zls, zbest)
    plotAnalyseGrasp(allfinstance[instancenb], x, zmoy[instancenb,:], zmin[instancenb,:], zmax[instancenb,:] )
    plotCPUt(allfinstance, tmoy)
end

simulation()