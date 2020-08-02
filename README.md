# Búsqueda Automatizada de Parches para Corregir Errores de Programas usando Programación Genética

* Resumen

En este primer acercamiento, se realizan experimentos sobre programas escritos en Pharo. Se buscan parches simples (agregar una línea de código nueva). 

* Ejemplo

Considerar el siguiente programa que pasa exitosamente 4 tests. Al eliminar la linea que contiene `c addPlot: d`, el programa sólo aprueba 1 test.

<pre><code>setUp
    |x y c d|
    x := -3.14 to: 3.14 by: 0.1.
    y := x cos.
    c := RSChart new.
    d := RSLinePlot new. 
    d color: Color red.
    d x: x y: y.
    c addPlot: d. "<= lost line"
    c build
</code></pre>
	    
Luego GP, se encarga de buscar la línea faltante tomando el siguiente conjunto de entrada. Asumimos la ubicación del lugar donde se debe insertar el parche (usando `codeBefore:` y `codeAfter:`. Luego se entregan los tipos de las variables, y la relevancia de los métodos a insertar a través de un sistema de pesos, pues una inserción al azar no es óptima.

<pre><code>
g := GPCodeGenerator new codeBefore: 
'x := -3.14 to: 3.14 by: 0.1.
 y := x cos.
 c := RSChart new.
 d := RSLinePlot new. 
 d color: Color red.
 d x: x y: y.' 
codeAfter: 'c build'.

g types: (Dictionary newFrom: { #x -> Array new . #y -> Array new . #d -> RSLinePlot new . #c -> RSChart new}).

g addWeights: (WeightGenerator new initialWeights: { #addPlot: -> 90. #color: -> 50 . #_default_ -> 1 }).
</code></pre>

Después para correr el algoritmo agregamos el siguiente código:

<pre><code>
e := GPEngine new.
e configuration: g.
e execute.
i:= e pickBestIndividual.
</code></pre>

Finalmente para ejecutar, basta con seleccionar todo el código y teclear `ctrl + G`

* Resultados

- Código generado: `c addPlot: d`



