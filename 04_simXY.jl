### Simular un vector aleatorio
### Autor: Arturo Erdely
### Fecha: 2026-01-18


# paquetes instalados previamente
using Plots, LaTeXStrings, SpecialFunctions, QuadGK, Distributions


#= Ejemplo

    X ~ Exponencial(1)
    
    Y|X=x ~ Uniforme(0, x)
=#


@doc expinti # función integral exponencial (SpecialFunctions)


# función de densidad marginal de Y 
fY(y) = -expinti(-y) 


# comprobando que integra a 1
quadgk(fY, 0, Inf) # del paquete: QuadGK


# fY(0) = + ∞
fY(0.0001)
fY(0.0000001)
fY(0.0)


# graficar fdp de Y
begin
    y = collect(range(0.001, 3, length = 1_000))
    plot(y, fY.(y), lw = 3, legend = false)
    xaxis!(L"y"); yaxis!(L"f_Y(y)")
end


# simular (X,Y)
begin
    n = 10_000
    sX = rand(Exponential(1), n)
    sU = rand(Uniform(0, 1), n)
    sY = sX .* sU
end;


# densidad marginal de Y (empírica y teórica)
begin
    histogram(sY, normalize = true, label = "empírica")
    plot!(y, fY.(y), label = "teórica", lw = 2)
    xaxis!(L"y"); yaxis!("densidad de Y")
end


# media muestral
mean(sY) # teórica: E(Y) = 1/2


# diagrama de dispersión (scatterplot)
begin
    scatter(sX[1:3000], sY[1:3000], mc = :black, ms = 1, legend = false)
    xaxis!(L"X"); yaxis!(L"Y")
end
