# Búsqueda Automatizada de Parches para Corregir Errores de Programas usando Programación Genética


## Instalación 


```Smalltalk
	Metacello new
 		baseline:'GeneticProgramming';
		repository: 'github://vicho08/GeneticProgramming';
 		load.
 ```

* Requerimientos

Para realizar exitosamente el experimento se debe contar con Roassal3 y Spy instalados en la imagen de Pharo donde se trabaja. 

* Ejemplo

Considerar el siguiente método. El algoritmo debe ser capaz de encontrar el cuerpo de este método de una sola línea `^ self definedValuesY`.

<pre><code>minValueY
	"Return the minimum Y value of the plot, excluding NaN and infinite"
	
	^ self definedValuesY min  "<= lost line" 
</code></pre>
	    
GP necesita un conjunto de entrada que defina este problema en particular. Se asume la ubicación del lugar donde se debe insertar el parche (usando `codeBefore:` y `codeAfter:`. Además de señalar el paquete donde vive el método.

<pre><code>g:= GPCodeGenerator new codeBefore: '' codeAfter: '' onPackageNamed: 'Roassal3-Chart'.</code></pre>

Para evitar problemas en el futuro, se guarda el código original del método, para recompilar luego de usar el algoritmo. 

<pre><code>originalSource := (RSAbstractPlot>>#minValueY) getSourceFromFile. </code></pre>

Se deben señalar el nombre del método, el nombre de la clase y el conjunto de variables participantes (las variables de instancia se obtienen de la clase). 

<pre><code> g nameMethod: 'minValueY'; nameClass: RSAbstractPlot; setOfVariables: ''. </code></pre>

También, es necesario definir el conjunto de tests que evaluarán los requerimientos necesarios que debe cumplir el método.

<pre><code>  g packageTesting: 'Roassal3-Chart-Tests'. </code></pre>

El algoritmo utiliza un sistema de pesos para dar mayor importancia a ciertos métodos del universo de búsqueda. Se pueden probar distintas variantes de este sistema, que por ahora, se mantiene constante una vez iniciado el algoritmo y que se señala manualmente por el usuario.
<pre><code>
g addWeights: (WeightGenerator new initialWeights: {#min -> 200. #definedValuesY -> 250 .#_default_ -> 1}).
</code></pre>

Después para correr el algoritmo y seleccionar el mejor individuo, agregamos el siguiente código:

<pre><code>
e := GPEngine new.
e configuration: g.
e execute.
i:= e pickBestIndividual.
</code></pre>

Finalmente para recompilar el método con su código original: 

<pre><code> RSAbstractPlot compile: originalSource. </code></pre>

Finalmente para ejecutar, basta con seleccionar todo el código y teclear `ctrl + G`

* Resultados

	- Código generado: `^ self definedValuesY min `. 
	
	![alt text](https://github.com/vicho08/GeneticProgramming/blob/master/images/fitnessTime02.png "Evolución fitness durante el avance del programa genético")



