### Simular cópula arquimediana
### ⟶ Continuación de 07_CopArquim.jl
### Autor: Arturo Erdely
### Fecha: 2026-01-28


## Paquetes instalados previamente

using Plots, LaTeXStrings, Distributions


# frontera de región cero 
g(u,θ) = 1 - (1 - (1-u)^θ)^(1/θ) 

# ψ(v|u) = ∂C(u,v)/∂u como función de v, para u y θ fijos
function ∂C∂u(u, v, θ) 
    if g(u,θ) < v ≤ 1.0
        return ((1-u)^(θ-1)) * ((1-u)^θ + (1-v)^θ)^(1/θ-1)
    elseif 0.0 ≤ v < g(u,θ)
        return 0.0
    else
        return NaN
    end
end

# ψ⁻¹(t|u) como función de t, para u y θ fijos
function ψi(t, u, θ)
    if t > (1-u)^(θ-1) 
        return 1 - (1-u)*(1/(t^(θ/(θ-1))) - 1)^(1/θ)
    else
        return g(u, θ)
    end
end

# Gráfica de ψ(v|u) para u y θ fijos
begin
    θ = 2.3
    u = 0.4
    vv = collect(range(0, 1, length = 1_000))
    ψ = [∂C∂u(u, v, θ) for v ∈ vv]
    scatter(vv, ψ, xlabel = L"v", ylabel = L"\partial C_{\theta}(u,v) / \partial u",
         title = "u = $u, θ = $θ", size = (500,400), label = L"v\mapsto \partial C(u,v) / \partial u",
         ms = 2.0, mcolor = :black)
    gu = g(u,θ)
    vg = (1-u)^(θ-1)
    vline!([gu], ls = :dash, color = :red, label = "g(u) = $(round(gu, digits=4))")
    hline!([vg], ls = :dash, color = :gray, label = "(1-u)^(θ-1) = $(round(vg, digits=4))")
end

# Agregar gráfica de ψ⁻¹(t|u) para u y θ fijos
begin
    tt = collect(range(0, 1, length = 1_000))
    plot!([ψi(t, u, θ) for t ∈ tt], tt, color = :cyan,
               label = L"\psi^{(-1)}_{θ}(t|u)")
end


# Función para simular n observaciones de la cópula arquimediana con parámetro θ
function simular_copula(n, θ)
    U = rand(n)
    V = similar(U)
    for i ∈ 1:n
        u = U[i]
        w = rand()
        V[i] = ψi(w, u, θ)
    end
    return U, V
end

begin
    θ = 2
    U, V = simular_copula(1000, θ)
    scatter(U, V, xlabel = L"U", ylabel = L"V", size = (500,470), 
            ms = 2.0, mcolor = :blue, label = "")
end
# agregar frontera
plot!(sort(U), g.(sort(U), θ), color = :red, lw = 2.0, label = L"g_{θ}(u)")


## Simular (X,Y) con cópula arquimediana y márginales dadas 

function simular_XY(n, θ, distX, distY)
    U, V = simular_copula(n, θ)
    X = quantile(distX, U)
    Y = quantile(distY, V)
    return X, Y
end

begin
    θ = 10
    distX = Beta(0.8,0.5)
    distY = Gamma(2,3)
    X, Y = simular_XY(1000, θ, distX, distY)
    scatter(X, Y, xlabel = L"X", ylabel = L"Y", size = (500,470), 
            ms = 2.0, mcolor = :green, label = "")
end
