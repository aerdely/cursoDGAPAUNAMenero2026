### Generar dígitos de la raíz cuadrada de 2
### Autor: Arturo Erdely
### Fecha: 2026-01-11


## Algunos tipos de números y su representación binaria

versioninfo() # versión de Julia y otra info

Sys.WORD_SIZE # procesador de la compu a 64 bits

typemax(Int) # el entero mayor a 64 bits

typemax(Int) / (10^18) # > 9.2 trillones

maxInt64 = typemax(Int64) # el entero mayor a 64 bits
minInt64 = typemin(Int64) # el entero menor a 64 bits

println(bitstring(13)) # representación binaria del entero 13 a 64 bits
length(bitstring(5)) # comprobando cantidad de bits
1*2^0 + 0*2^1 + 1*2^2 + 1*2^3 # comprobando
sum([1, 0, 1, 1] .* (2 .^ [0, 1, 2, 3])) # comprobando

maxInt64 # el entero mayor a 64 bits
println(bitstring(maxInt64)) # rep binaria del entero mayor a 64 bits
maxInt64 - 1
println(bitstring(maxInt64 - 1)) # rep binaria del entero mayor a 64 bits - 1

minInt64 # el entero menor a 64 bits
println(bitstring(minInt64)) # rep binaria del entero menor a 64 bits
minInt64 + 1
println(bitstring(minInt64 + 1)) # rep binaria del entero mayor a 64 bits + 1

println(collect(0:62)) # vector de 63 enteros: [0,1,…,62]
println(2 .^ collect(0:62)) # vector de valores 2^k con k ∈ {0,1,…,62}
sum(2 .^ collect(0:62)) # calcula suma ∑2^k con k ∈ {0,1,…,62}
maxInt64 # coincide con el entero mayor a 64 bits
println(bitstring(maxInt64)) # rep binaria del entero mayor a 64 bits
maxInt64 + 1 # entero más grande a 64 bits + 1 → entero menor a 64 bits!
minInt64 # entero menor a 64 bits!
println(bitstring(minInt64)) # rep binaria del entero menor a 64 bits
println(bitstring(-1)) # rep binaria de -1

a = 2^62 # potencia entera de 2 más grande, calculable correctamente a 64 bits
b = 2^63 # se pasa del máximo tamaño posible, resultado erróneo ¡cuidado!
minInt64 # 2^63 ⟶ entero menor a 64 bits! 
typeof(b) # tipo entero a 64 bits
c = 2.0^63 # potencia entera de un número de punto flotante a 64 bits
typeof(c) # tipo flotante a 64 bits

println(bitstring(22)) # rep binaria de 22 como entero a 64 bits
0*2^0 + 1*2^1 + 1*2^2 + 0*2^3 + 1*2^4 # comprobando
sum([0, 1, 1, 0, 1] .* (2 .^ [0, 1, 2, 3, 4])) # otra forma de comprobar
println(bitstring(22.0)) # rep binaria de 22.0 como flotante a 64 bits


#=
    Así como en el sistema decimal hay números racionales que no es posible
    representar mediante un número finito de decimales, por ejemplo:

    1/3 = 0.333333333333…

    Lo mismo sucede con la representación binaria de números racionales que
    bajo la aritmética de punto flotante no es posible representarlos mediante
    un número finito de bits:
=#
println(bitstring(0.1))
# y esto provoca redondeos que arrojan resultados inexactos:
0.1 + 0.2

# Si no queremos perder precisión al trabajar con números racionales
# podemos tabajar con números tipo Rational que son pares de números enteros!
f = 1 / 10 # resulta en un número de punto flotante
typeof(f)
r = 1 // 10 # número tipo Rational ⟶ almacena el para de enteros (1, 10)
typeof(r)
1//10 + 2//10 # suma de racionales
float(3//10) # conversión final a número de punto flotante
2//7 + 3//5 # otro ejemplo


# Enteros a 128 bits 
maxInt128 = typemax(Int128) # entero mayor a 128 bits
maxInt128 / (10.0^36) # > 170 sixtillones
minInt128 = typemin(Int128) # entero menor a 128 bits
println(bitstring(maxInt128)) # rep binaria del entero mayor a 128 bits
length(bitstring(maxInt128)) # comprobando longitud de 128 bits
println(bitstring(minInt128)) # rep binaria del entero menor a 128 bits

# Enteros sin signo a 128 bits 
maxUInt128 = typemax(UInt128) # entero mayor sin signo a 128 bits (hexadecimal)
minUInt128 = typemin(UInt128) # entero menor sin signo a 128 bits (hexadecimal)
println(minUInt128, "\t", maxUInt128) # enteros a 128 bits sin signo, mínimo y máximo
maxUInt128 / maxInt128 # el doble que enteros con signo
println(bitstring(minUInt128)) # rep binaria del entero menor a 128 bits
println(bitstring(maxUInt128)) # rep binaria del entero mayor a 128 bits


#=
    Generar m dígitos exactos de la expansión decimal de la raíz cuadrada de 2:

    √2  =  1.4142…  =  d₀.d₁d₂d₃…dₘ …

    Algoritmo
    ---------
    d[0] = 1 = t[0]
    para n ∈ {1,2,…,m}
        d[n] = máx{d ∈ {0,1,…,9}: (10*t[n-1] + d)² < 2×10^{2n}}
        t[n] = 10*t[n-1] + d[n]
    siguiente n

    Sea U el entero mayor que admite una computadora. Entonces:

    2×10^{2m} ≤ U ⟺ m ≤ (log U - log 2) / 2 log 10
=#

# número máximo m de dígitos posible con enteros sin signo a 128 bits
(log(maxUInt128) - log(2)) / (2 * log(10))

# resultado matemáticamente incorrecto, por exceder el entero mayor a 64 bits:
3 ^ 500

# El tipo de número BigInt: aritmética de precisión arbitraria
b = big(3) ^ 500
typeof(b)
b+1
bitstring(b) # ERROR: no aprovecha el cálculo óptimo del procesador a 64 bits


## Velocidad de operaciones con Int, Float y BigInt

function sumaFórmula(n::Integer)
    # fórmula para calcular 1 + 2 + ⋯ + n
    return n * (n + 1) ÷ 2
end

sumaFórmula(100)

a = 4 / 2 # división de punto flotante
typeof(a)
b = 4 ÷ 2 # división entera
typeof(b)
5 ÷ 3 # división entera
5 % 3 # residuo de la división entera 
divrem(5, 3) # ambos como una tupla


function sumaEntera(n::Int)
    # calcular 1 + 2 + ⋯ + n
    s = 0
    for i ∈ 1:n 
        s += i # es lo mismo que: s = s + i
    end
    return s
end

sumaEntera(100)

n = 1_000_000
typemax(Int) / (10^18) # > 9 trillones = 9 × 10^18
n^2 # 10^12 < 9×10^18
@timev sumaFórmula(n) # ejecutar varias veces
@timev sumaEntera(n) # ejecutar varias veces

function sumaFlotante(n::Int)
    # calcula 1.0 + 2.0 + ⋯ + n.0
    s = 0.0
    for i ∈ 1:n 
        s += i # es lo mismo que: s = s + i
    end
    return s
end

sumaFlotante(100)

n = 1_000_000
@timev sumaFlotante(n) # ejecutar varias veces
@timev sumaEntera(n) # ejecutar varias veces

# moraleja: operaciones aritméticas con enteros son más rápidas

function sumaBigInt(n::Int)
    # calcula big(0) + big(1) + ⋯ + big(n)
    s = BigInt(0)
    for i ∈ 1:n 
        s += i # es lo mismo que s = s + i
    end
    return s
end

sb = sumaBigInt(100)
typeof(sb)

n = 10_000
@timev sumaBigInt(n) # ejecutar varias veces
@timev sumaFlotante(n) # ejecutar varias veces
@timev sumaEntera(n) # ejecutar varias veces

# moraleja: operaciones con enteros de precisión arbitraria son mucho más lentas

# conversión automática de tipos
typeof(1 + 2)
typeof(big(1) + 2)


#=
    Ahora sí: generar m dígitos decimales de la raíz cuadrada de 2:

    √2  =  1.4142…  =  d₀.d₁d₂d₃…dₘ …

    Algoritmo
    ---------
    d[0] = 1 = t[0]
    para n ∈ {1,2,…,m}
        d[n] = máx{d ∈ {0,1,…,9}: (10*t[n-1] + d)² < 2×10^{2n}}
        t[n] = 10*t[n-1] + d[n]
    siguiente n
=#

function raíz2(m::Int)
    # calcular m dígitos de √2 = 1.d₁d₂…dₘ
    t = big(1)
    d = zeros(Int, m)
    for n ∈ 1:m
        dígito = 0
        while (10*t + dígito)^2 < 2*(big(10)^(2*n))
            dígito += 1 # es lo mismo que: dígito = dígito + 1
        end
        d[n] = dígito - 1
        t = 10*t + d[n]
    end
    return (d, t)
end

zeros(Int, 5)
println(zeros(Int, 5))
tupla = (2, 3) # tupla, distinto de [2, 3]
typeof(tupla)
tupla[2]
typeof([2, 3])

r = raíz2(16) # 16 dígitos de la parte decimal de √2
println(r[1])
println(r[2])
join(r[1])
"1." * join(r[1])

a = √2 # es lo mismo que sqrt(2), el símbolo se genera: \sqrt + tab 
typeof(a) # número de únto flotante a 64 bits


begin # m decimales de √2
    m = 1_000
    r = raíz2(m)
    rd = "1." * join(r[1])
    println(rd)
end

r[1]
r[2]
typeof(r[2])
r[2]^2


# Cálculo de 1 millón de dígitos de √2
# https://apod.nasa.gov/htmltest/gifcity/sqrt2.1mil

f = open("prueba.txt") # abrir archivo
c = readlines(f) # leer cada línea del archivo
close(f) # cerrar el archivo ¡muy importante!
typeof(c) # tipo de objeto donde se guardó el contenido
c
join(c) # unir como texto los elementos del vector c

archivo = "nasa.txt" # fuente: https://apod.nasa.gov/htmltest/gifcity/sqrt2.1mil
ta = filesize(archivo) # tamaño de archivo en bytes
ta / (1024^2) # tamaño de archivo en megabytes (Mb)
countlines(archivo) # número de líneas del archivo
f = open(archivo) # abrir archivo
c = readlines(f) # leer cada línea del archivo 
close(f) # cerrar el archivo ¡muy importante!
nasa = join(c) # unir en una sola cadena de texto el contenido
length(nasa) # número de caracteres

m = 10_000 # número de dígitos decimales a generar
subnasa = nasa[1:m+2] # primeros m dígitos según nasa.txt
println(subnasa)
@time r = raíz2(m); # aplicando nuestro algoritmo
rd = "1." * join(r[1]) # unir en una sola cadena de texto
println(rd) 

# comparemos:
subnasa == rd

@time r = raíz2(10_000);
@time r = raíz2(20_000);
subnasa = nasa[1:20_002];
rd = "1." * join(r[1]);
subnasa == rd

# Advertencia: La implementación del algoritmo NO está
# optimizada, preferí claridad sobre velocidad, pero es posible
# modificarlo para que sea más rápido y eficiente
# con el uso de memoria. Por ejemplo:

function raíz2A(m::Int)
    # calcular m dígitos de √2 = 1.d₁d₂…dₘ
    t = big(1)
    d = zeros(Int, m)
    #
    cota = 2 * big(10)^0 
    #
    for n ∈ 1:m
        #= 
        dígito = 0
        while (10*t + dígito)^2 < 2*(big(10)^(2*n))
            dígito += 1 # es lo mismo que: dígito = dígito + 1
        end
        d[n] = dígito - 1
        t = 10*t + d[n]
        =#
        cota *= 100 # es lo mismo que: cota = cota * 100
        t *= 10 # es lo mismo que: t = t * 10
        for dígito ∈ 0:9
            if (t + dígito)^2 < cota
                d[n] = dígito
            else
                break
            end
        end
        t += d[n]
    end
    return (d, t)
end

# comprobando nueva versión 
raíz2(1000)[1] == raíz2A(1000)[1]
@time r1 = raíz2(10_000);
@time r2 = raíz2A(10_000);

@time r2 = raíz2A(20_000);
subnasa = nasa[1:20_002];
rd = "1." * join(r2[1]);
subnasa == rd
