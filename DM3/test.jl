using PyPlot

# Création de données pour le tracé
x = collect(0:0.1:2*pi)
y = sin.(x)

# Tracé de la fonction sin(x)
plot(x, y, marker="o", linestyle="-", color="b")
xlabel("x")
ylabel("sin(x)")
title("Fonction sin(x)")
grid(true)
show()
