### Cópulas arquimedianas
### Autor: Arturo Erdely
### Fecha: 2026-01-27


## Paquetes instalados previamente

using Plots, LaTeXStrings


## Parametrizando el generador de W 

ϕ(t,θ) = (1.0 - t) ^ θ # 0 ≤ t ≤ 1, θ ≥ 1

function ϕi(z, θ) # 0 ≤ z ≤ ∞
    if 0.0 ≤ z ≤ 1.0 
        return 1.0 - z^(1/θ)
    else
        return 0.0
    end
end

# cópula arquimediana
C(u,v,θ) = ϕi(ϕ(u,θ) + ϕ(v,θ),θ)

# curva de región cero 
g(u,θ) = 1 - (1 - (1-u)^θ)^(1/θ) 


# ejemplo de matriz con comprensión de arreglos
[u + 100v for u ∈ [1,2,3], v ∈ [1,2,3]]
transpose([u + 100v for u ∈ [1,2,3], v ∈ [1,2,3]]) 

# malla en [0,1]x[0,1]
begin
    n = 100
    uu = collect(range(0, 1, length = n))
    vv = collect(range(0, 1, length = n))
end;

# gráfica de la cópula y la curva de región cero

function curvas_nivel(θ, n = 100)
    uu = collect(range(0, 1, length = n))
    vv = collect(range(0, 1, length = n))
    ww = transpose([C(u,v,θ) for u ∈ uu, v ∈ vv])
    contour(uu, vv, ww, fill = true, xlabel = L"u", ylabel = L"v",
            title = L"C_{θ}(u,v)" * "       θ = $θ", size = (500,450))
    plot!(uu, g.(uu,θ), lw = 3, color = :green, label = L"g(u)", legend = :bottomleft)
end

curvas_nivel(1.0)
curvas_nivel(2.0)   
curvas_nivel(10.0)
