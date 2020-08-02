# Búsqueda Automatizada de Parches para Corregir Errores de Programas usando Programación Genética

* Resumen

En este primer acercamiento, se realizan experimentos sobre programas escritos en Pharo. Se buscan parches simples (agregar una línea de código nueva). 

* Ejemplo

Considerar el siguiente programa que pasa exitosamente 4 tests.

`setUp
    |x y c d|
    x := -3.14 to: 3.14 by: 0.1.
    y := x cos.
    c := RSChart new.
    d := RSLinePlot new. 
	d color: Color red.
	d x: x y: y.
    "c addPlot: d." "<== lost line"
	c build`