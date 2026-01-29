### Estimación no paramétrica de una cópula
### ⟶ Continuación de 08_Simular.jl
### Autor: Arturo Erdely
### Fecha: 2026-01-29


using Plots, LaTeXStrings, Distributions

## Cópula arquimediana de 07_CopArquim.jl

# generador
ϕ(t,θ) = (1.0 - t) ^ θ # 0 ≤ t ≤ 1, θ ≥ 1

# pseudo-inversa del generador
function ϕi(z, θ) # 0 ≤ z ≤ ∞
    if 0.0 ≤ z ≤ 1.0 
        return 1.0 - z^(1/θ)
    else
        return 0.0
    end
end

# cópula arquimediana
C(u,v,θ) = ϕi(ϕ(u,θ) + ϕ(v,θ),θ)

# curva frontera de la región cero 
g(u,θ) = 1 - (1 - (1-u)^θ)^(1/θ) 


## Simular cópula arquimediana de 08_Simular.jl

# ψ⁻¹(t|u) como función de t, para u y θ fijos
function ψi(t, u, θ)
    if t > (1-u)^(θ-1) 
        return 1 - (1-u)*(1/(t^(θ/(θ-1))) - 1)^(1/θ)
    else
        return g(u, θ)
    end
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

# Simulación de n observaciones de la cópula arquimediana con parámetro θ
begin
    θ = 2.3
    n = 4_000
    U, V = simular_copula(n, θ)
    scatter(U, V, xlabel = L"U", ylabel = L"V", legend = false, size = (500, 500), markersize = 0.5)
end


## Estimaciones no paramétricas de la cópula 

# Cópula empírica
Cn(u,v) = (1/n) * sum( (U .≤ u) .* (V .≤ v) )

# Cópula Bernstein
function CopBer(u, v, m)
    valor = 0.0
    uu = range(0, 1, m+1)
    vv = range(0, 1, m+1)
    copemp = [Cn(u,v) for u in uu, v in vv]
    for i ∈ 1:m+1
        for j ∈ 1:m+1
            valor += copemp[i,j] * pdf(Binomial(m, u), i-1) * pdf(Binomial(m, v), j-1)
        end
    end
    return valor
end

# Ejemplo de evaluación de las cópulas
u, v = 0.4, 0.6
C(u, v, θ) # valor teórico
Cn(u, v) # valor empírico
CopBer(u, v, 100) # valor Bernstein


## Comparar curvas de nivel de las tres cópulas

# malla para curvas de nivel
begin
    m = 50
    uu = range(0, 1, m+1)
    vv = range(0, 1, m+1)
end;

#  Cópula teórica 
begin
    Copula = [C(u,v,θ) for u in uu, v in vv] 
    nivCopula = contour(uu, vv, Copula, xlabel = L"u", ylabel = L"v",
                        xticks = [0, 0.5, 1], yticks = [0, 0.5, 1], 
                        fill = true, size = (550, 500), title = "Cópula teórica"
    )
end

# Cópula empírica
begin
    Copula = [Cn(u,v) for u in uu, v in vv] 
    nivCopula = contour(uu, vv, Copula, xlabel = L"u", ylabel = L"v",
                        xticks = [0, 0.5, 1], yticks = [0, 0.5, 1], 
                        fill = true, size = (550, 500), title = "Cópula empírica"
    )
end

# Cópula Bernstein (tarda aprox 12 segundos)
@time begin
    Copula = [CopBer(u,v,50) for u in uu, v in vv] 
    nivCopula = contour(uu, vv, Copula, xlabel = L"u", ylabel = L"v",
                        xticks = [0, 0.5, 1], yticks = [0, 0.5, 1], 
                        fill = true, size = (550, 500), title = "Cópula Bernstein"
    )
end
