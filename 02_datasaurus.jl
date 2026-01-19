### Datasaurus Dozen 
### Data source: https://www.openintro.org/data/index.php?data=datasaurus  
### Article source: https://www.research.autodesk.com/app/uploads/2023/03/same-stats-different-graphs.pdf_rec2hRjLLGgM7Cn2T.pdf
### Autor: Arturo Erdely
### Fecha: 2026-01-11


## Paquetes que no requieren instalación previa 

begin
  using Statistics # calcular algunos estadísticos descriptivos
  using Random # herramientas para generar observaciones pseudo-aleatorias
end


#= Paquetes que requieren haber sido instalados previamente
   de la siguiente forma, en la terminal de Julia:

   julia> ]
   pkg> status
   pkg> add CSV
   pkg> add DataFrames 
   pkg> add Distributions
   pkg> add Plots 
   pkg> status
   pkg> [⟵]
   julia>

=#
begin
  using CSV # Para leer y escribir archivos CSV (Comma Separated Values)
  using DataFrames # Para manipular datos por campos y registros
  using Distributions # Algunos modelos de probabilidad
  using Plots # Para graficar
end


# Cargar datos en un DataFrame
datasaurus = CSV.read("datasaurus.csv", DataFrame)
typeof(datasaurus)


# Estructura del DataFrame
describe(datasaurus)
dataset_names = sort(unique(datasaurus.dataset))
nombres = [collect(1:length(dataset_names)) dataset_names]


# Filtrar por un nombre de dataset
dnom = dataset_names[1] # especificar nombre del dataset
datos = datasaurus[datasaurus.dataset .== dnom, [:x, :y]]
typeof(datos)


# Gráfico de dispersión (scatterplot)
scatter(datos.x, datos.y, title = dnom, legend = false, 
        xlim = (-15, 105), ylim = (-15, 105), aspect_ratio = 1
)


# Estadísticos descriptivos
m1 = mean(datos.x); m2 = mean(datos.y);
m1, m2
scatter!([m1], [m2], ms = 6, color = :red)
std(datos.x), std(datos.y)    
cor(datos.x, datos.y) # correlación de Galton-Pearson


## Análisis de todos los datasets

nombres

# crear tabla para estadísticos descriptivos
tabla = DataFrame(nombre = fill("", 13),
                  media_x = zeros(13), desv_x = zeros(13),
                  media_y = zeros(13), desv_y = zeros(13),
                  corr = zeros(13)
)

for d ∈ 1:13
    tabla.nombre[d] = nombres[d, 2]
    datos = datasaurus[datasaurus.dataset .== nombres[d, 2], [:x, :y]]
    tabla.media_x[d] = mean(datos.x)
    tabla.desv_x[d] = std(datos.x)
    tabla.media_y[d] = mean(datos.y)
    tabla.desv_y[d] = std(datos.y)
    tabla.corr[d] = cor(datos.x, datos.y)
end
tabla 

# función que grafica con base en el nombre (o su número)
function graficar(nombre)
    if typeof(nombre) == String 
        if nombre ∈ nombres[:, 2]
            dnom = nombre
        else
            error("No existe conjunto de datos con ese nombre")
            return nothing 
        end
    elseif typeof(nombre) == Int
        if nombre ∈ collect(1:13)
            dnom = nombres[nombre, 2]
        else 
            error("No existe conjunto de datos con ese número")
            return nothing
        end
  else
      error("Nombre no válido")
      return nothing
  end
  datos = datasaurus[datasaurus.dataset .== dnom, [:x, :y]]
  g = scatter(datos.x, datos.y, title = dnom, legend = false, 
      xlim = (-15, 105), ylim = (-15, 105), aspect_ratio = 1,
      showaxis = false, grid = false, mc = :black, ms = 2
  )
  return g
end

graficar(3)
Dinosaurio = graficar("dino")
graficar("circle")
Dinosaurio

graficar(21)
graficar("perro")
graficar(0.3)


# matriz de gráficas 3×4
docena = setdiff(nombres[:, 1], 4); # quitando a "dino"
println(docena)
g = []
for d ∈ docena
    push!(g, graficar(d))
end
g
g[3]

DataaurusDozen = plot(g..., layout = (3,4))
Dinosaurio


## Simular Normal bivariada con los mismos parámetros 

@doc Distributions

@doc MvNormal 

# fijar parámetros y definir modelo
μ = [mean(tabla.media_x), mean(tabla.media_y)]
σ = [mean(tabla.desv_x), mean(tabla.desv_y)]
r = mean(tabla.corr)
cov = r*σ[1]*σ[2]
Σ = [σ[1]^2 cov; cov σ[2]^2]
Nbiv = MvNormal(μ, Σ)

# simular y comprobar parámetros
simXY = rand(Nbiv, 100_000)
mean(simXY, dims=2)
μ
std(simXY, dims=2)
σ
cor(simXY[1,:], simXY[2, :]), r

# simular muestras del mismo tamaño que Datasaurus Dozen
datos
nrow(datos)
scatter(transpose(rand(Nbiv, 142)), title = "Normal bivariada", legend = false, 
      xlim = (-15, 105), ylim = (-15, 105), aspect_ratio = 1,
      showaxis = false, grid = false, mc = :black, ms = 2
) # ejecutar varias veces 

DataaurusDozen
Dinosaurio

#=

    Moraleja

    Conjuntos de datos con las mismas medias, mismas varianzas,
    y misma correlación, pueden ser muy distintos. ¡Cuidado!

=#