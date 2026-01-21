### Cotas de Fréchet-Hoeffding
### Autor: Arturo Erdely
### Fecha: 2026-01-21


using Plots, LaTeXStrings # paquetes instalados previamente


## Definición de funciones
begin
    W(u,v) = max(u + v - 1, 0) # cota inferior de FH
    Π(u,v) = u * v # independencia 
    M(u,v) = min(u, v) # cota superior de FH
end;


## Calcular valores de funciones sobre una malla de valores
begin
    n = 100
    u = collect(range(0, 1, length = n))
    v = u 
    w = zeros(n, n)
    p = zeros(n, n)
    m = zeros(n, n)
    for i ∈ 1:n, j ∈ 1:n 
        w[j, i] = W(u[i], v[j])
        p[j, i] = Π(u[i], v[j])
        m[j, i] = M(u[i], v[j])
    end
end


## Conjuntos de nivel
begin
    cW = contour(u, v, w, xlabel = L"u", ylabel = L"v", size = (420, 400), fill = true, title = L"W(u,v)=\max\{u+v-1,0\}")
    cΠ = contour(u, v, p, xlabel = L"u", ylabel = L"v", size = (420, 400), fill = true, title = L"\Pi(u,v)=uv")
    cM = contour(u, v, m, xlabel = L"u", ylabel = L"v", size = (420, 400), fill = true, title = L"M(u,v)=\min\{u,v\}")
end;

cW # cota inferior de FH 
cΠ # independencia 
cM # cota superior de FH


## Superficies

# cota inferior de FH
cW 
sW = surface(u, v, w, xlabel = L"u", ylabel = L"v", zlabel = L"W(u,v)", legend = false)
begin # agregar curvas de nivel
    for t ∈ collect(0.0:0.1:0.9)
        plot!([t, 1], [1, t], [t, t], color = :white, lw = 0.5)
    end
    sW = current()
end

# independencia
cΠ 
sΠ = surface(u, v, p, xlabel = L"u", ylabel = L"v", zlabel = L"Π(u,v)", legend = false)
begin # agregar curvas de nivel
    for t ∈ collect(0.0:0.1:0.9)
        uu = collect(range(t, 1, length = 100))
        vv = t ./ uu
        pp = fill(t, length(uu))
        plot!(uu, vv, pp, color = :white, lw = 0.5)
    end
    sΠ = current()
end

# cota superior de FH
cM 
sM = surface(u, v, m, xlabel = L"u", ylabel = L"v", zlabel = L"M(u,v)", legend = false)
begin
    for t ∈ collect(0.0:0.1:0.9)
        plot!([t, t], [t, 1], [t, t], color = :white, lw = 0.5)
        plot!([t, 1], [t, t], [t, t], color = :white, lw = 0.5)
    end
    sM = current()
end


## δ(A,B) = P(A∩B) - uv,   con P(A)=u y P(B)=v
## δmin ≤ δ(A,B) ≤ δmax
begin
    δmin(u,v) = -min((1-u)*(1-v), u*v) # cota inferior
    δmax(u,v) = min(u*(1-v), (1-u)*v) # cota superior
    δamp(u,v) = δmax(u,v) - δmin(u,v) # amplitud
end;

# calcular valores sobre una malla
begin
    δδmin = [δmin(uu, vv) for uu ∈ u, vv ∈ v]
    δδmax = [δmax(uu, vv) for uu ∈ u, vv ∈ v]
    δδamp = [δamp(uu, vv) for uu ∈ u, vv ∈ v]
end;

# valores extremos alcanzados
extrema(δδmin) # teóricamente: [-1/4, 0]
extrema(δδmax) # teóricamente: [0, 1/4]
extrema(δδamp) # teóricamente: [0, 1/2]

# conjuntos de nivel 
contour(u, v, δδmin, fill = true, xlabel = L"u", ylabel = L"v", title = L"δ_{min}", size = (420, 400))
contour(u, v, δδmax, fill = true, xlabel = L"u", ylabel = L"v", title = L"δ_{max}", size = (420, 400))
contour(u, v, δδamp, fill = true, xlabel = L"u", ylabel = L"v", title = L"δ_{amp}", size = (420, 400))


## Ejemplo 

pA = 0.7 # P(A)
pB = 0.2 # P(B)
pA*pB # P(A)P(B)

δmin(pA, pB)
δmax(pA, pB)
δamp(pA, pB)
