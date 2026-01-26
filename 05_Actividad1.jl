### Actividad #1
### Autor: Arturo Erdely
### Fecha: 2026-01-24


# paquetes instalados previamente

using Plots, LaTeXStrings, Distributions


#= 
    (X,Y) ~ Uniforme en el triángulo con vértices (0,0), (2,0) y (0,1)
=#


# función auxiliar: evaluar función sobre malla 
function mallaXY(fXY, xmin, xmax, ymin, ymax, nx, ny = nx)
    x = collect(range(xmin, xmax, length = nx))
    y = collect(range(ymin, ymax, length = ny))
    matriz = zeros(ny, nx)
    for i ∈ 1:nx, j ∈ 1:ny
        matriz[j, i] = fXY(x[i], y[j])
    end
    return (X = x, Y = y, Z = matriz)
end


## 1. Función de distribución conjunta

function FXY(x, y)
    if x ≤ 0 || y ≤ 0 
        return 0.0
    elseif x ≥ 2 && y ≥ 1
        return 1.0
    elseif 0 < x < 2 && 0 < y < 1
        if y ≤ 1 - x/2
            return x * y
        else
            return x + 2y - (x^2)/4 - y^2 - 1
        end
    elseif 0 < x < 2 && y ≥ 1
        return x - (x^2)/4
    elseif x ≥ 2 && 0 < y < 1
        return 2y - y^2
    end
end


# valor de FXY por regiones 
begin
    scatter([0,0,3,3], [0,1.5,0,1.5], mc = :white, ms = 0, 
            xlabel = L"x", ylabel = L"y", xlims = (0, 3), ylims = (0, 1.5),
            legend = false, title = L"F_{X,Y}(x,y)"
    )
    hline!([1], color = :black, lw = 1)
    vline!([2], color = :black, lw = 1)
    plot!([0, 2], [1, 0], color = :black, lw = 1) # frontera del triángulo
    annotate!(0.6, 0.3, text(L"xy", :black, :left, 12)) # triángulo inferior
    annotate!(0.8, 0.75, text(L"x+2y-\frac{x^2}{4}-y^2-1", :black, :left, 12)) # triángulo
    annotate!(2.35, 0.5, text(L"2y - y^{2}", :black, :left, 12)) # marginal de Y
    annotate!(1, 1.2, text(L"x - \frac{x^{2}}{4}", :black, :left, 12)) # marginal de X
    annotate!(2.5, 1.2, text(L"1", :black, :left, 12)) # probabilidad total 
end

# calcular valores de FXY sobre una malla
R = mallaXY(FXY, 0, 3, 0, 1.5, 1_000);

# curvas de nivel de FXY
begin
    cFXY = contour(R.X, R.Y, R.Z, xlabel = L"x", ylabel = L"y", size = (650, 400),
                   fill = true, title = L"F_{X,Y}(x,y)", legend = false)
    hline!([1], color = :white, lw = 1)
    vline!([2], color = :white, lw = 1)
    plot!([0, 2], [1, 0], color = :white, lw = 1) # frontera del triángulo
end

# superficie de FXY
begin
    sFXY = surface(R.X, R.Y, R.Z, xlabel = L"x", ylabel = L"y", 
                   zlabel = L"F_{X,Y}(x,y)", legend = false)
    x = collect(range(0, 2, length = 1_000))
    y = 1 .- (x ./ 2)
    z = [FXY(xi, yi) for xi ∈ x, yi ∈ y] # frontera del triángulo
    z0 = zeros(length(x))
    plot!(x, y, FXY.(x, y), color = :white, lw = 2) # frontera del triángulo en la superficie
    plot!(x, y, z0, color = :gray, lw = 1) # frontera del triángulo en el dominio
end


## 2. Marginales 

begin
    FX(x) = FXY(x, Inf) # FX(x) = FXY(x, ∞) 
    FY(y) = FXY(Inf, y) # FY(y) = FXY(∞, y)
    FXinv(u) = (2 - 2*√(1 - u)) * (0 ≤ u ≤ 1)
    FYinv(v) = 1 - √(1 - v) * (0 ≤ v ≤ 1)
    fX(x) = (1 - x/2) * (0 ≤ x ≤ 2) # derivada de FX: densidad marginal de X
    fY(y) = (2 - 2y) * (0 ≤ y ≤ 1) # derivada de FY: densidad marginal de Y
end;


## 3. Condicionales 

function condY(x)
    if 0 < x < 2
        return Uniform(0, 1 - x/2)
    else
        error("valor 'x' fuera de soporte")
        return nothing
    end
end
function condX(y)
    if 0 < y < 1
        return Uniform(0, 2 - 2y)
    else
        error("valor 'y' fuera de soporte")
        return nothing
    end
end


## 4. Simulación de (X,Y) 

function simXY(n)
    u = rand(Uniform(0, 1), n)
    x = FXinv.(u)
    y = zeros(n)
    for i ∈ 1:n
        y[i] = rand(condY(x[i]), 1)[1]
    end
    return (X = x, Y = y)
end

s = simXY(10_000)
[s.X s.Y]
scatter(s.X, s.Y, ms = 1, mc = :black, xlabel = L"X", ylabel = L"Y",
        xlims = (0, 2), ylims = (0, 1), 
        title = "Simulación de (X,Y)", legend = false
)


## 5. Histogramas marginales 
histogram(s.X, bins = 30, xlabel = L"X", ylabel = "densidad", 
          label = "empírica", normalize = true, color = :yellow)
plot!(0:0.01:2, fX.(0:0.01:2), label = "teórica", lw = 2, color = :red)
histogram(s.Y, bins = 30, xlabel = L"Y", ylabel = "densidad", 
          label = "empírica", normalize = true, color = :cyan)
plot!(0:0.01:1, fY.(0:0.01:1), label = "teórica", lw = 2, color = :blue)


## 6. Cópula subyacente 

C(u,v) = FXY(FXinv(u), FYinv(v)) 
# evaluar sobre malla
begin
    mC = mallaXY(C, 0, 1, 0, 1, 1_000)
    u = mC.X
    v = mC.Y    
    z = mC.Z
end;


# curvas de nivel
nivC = contour(u, v, z, xlabel = L"u", ylabel = L"v", size = (420, 400), 
               fill = true, title = L"C(u,v)", legend = false)


# superficie
sC = surface(u, v, z, xlabel = L"u", ylabel = L"v", zlabel = L"C(u,v)", legend = false)

# agregar frontera deformada del triángulo
ψ(u) = u + 2*√(1-u) - 1 
# frontera del triángulo en el dominio
w0 = zeros(length(u));
plot!(u, ψ.(u), w0, color = :gray, lw = 1)
# frontera del triángulo en la superficie
plot!(u, ψ.(u), C.(u, ψ.(u)), color = :cyan, lw = 2) # frontera del triángulo en la superficie


## Extra: comparar versus W, Π y M 

begin
    n = length(u)
    W(u,v) = max(u + v - 1, 0) # cópula cota inferior FH
    Π(u,v) = u * v             # cópula independencia
    M(u,v) = min(u, v)         # cópula cota superior FH
    mW = mallaXY(W, 0, 1, 0, 1, n)
    mΠ = mallaXY(Π, 0, 1, 0, 1, n)
    mM = mallaXY(M, 0, 1, 0, 1, n)
    nivW = contour(mW.X, mW.Y, mW.Z, xlabel = L"u", ylabel = L"v", size = (420, 400), 
                   fill = true, title = L"W(u,v)", legend = false)
    nivΠ = contour(mΠ.X, mΠ.Y, mΠ.Z, xlabel = L"u", ylabel = L"v", size = (420, 400), 
                   fill = true, title = L"\Pi(u,v)", legend = false)
    nivM = contour(mM.X, mM.Y, mM.Z, xlabel = L"u", ylabel = L"v", size = (420, 400), 
                   fill = true, title = L"M(u,v)", legend = false)
end;

nivC
nivW
nivΠ
nivM

