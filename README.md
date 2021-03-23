# Búsqueda Automatizada para Generar Código Usando Programación Genética en un Lenguaje de Programación OOP

El presente repositorio contiene una técnica desarrollada en el lenguaje de programación Pharo (versión 9), que permite construir código fuente utilizando programación genética.
A partir de una aplicación  y un conjunto de tests, actualmente la técnica puede construir el código referente al cuerpo de métodos de una sola línea con presición del 51%. 


## Instalación en Pharo 

Para realizar exitosamente experimentos se debe contar con las herramientas Roassal3 y Spy instaladas en la imagen de Pharo donde se trabaja.  

## Ejemplo de uso 
 
Considere el siguiente método, que pertenece a Roassal3. El algoritmo debe ser capaz de encontrar el cuerpo de este método de una sola línea `^ self definedValuesX max`.

<pre><code>maxValueX
	"Return the maximum X value of the plot, excluding NaN and infinite"
	
	^ self definedValuesX max  "<= lost line" 
</code></pre>
	    
GP necesita como conjunto de entrada el contexto en donde vive este método. Particulamente, se asume la ubicación del lugar donde se debe insertar el parche pues es un método de una sola sentencia (usando `codeBefore:` y `codeAfter:`. Además de señalar el paquete de la aplicación con su respectivo paquete de pruebas unitarias.

<pre><code> g:= GPCodeGenerator new codeBefore: '' codeAfter: '' onPackageNamed: 'Roassal3-Chart' onPackageTesting: 'Rossal3-Chart-Tests'.</code></pre>

Para evitar problemas en el futuro, se guarda el código original del método, para recompilar luego de usar el algoritmo. 

<pre><code>originalSource := (RSAbstractPlot>>#maxValueX) getSourceFromFile. </code></pre>

Se deben señalar el nombre del método, el nombre de la clase y el conjunto de variables participantes (las variables de instancia se obtienen de la clase). 

<pre><code> g nameMethod: 'minValueY'; nameClass: RSAbstractPlot; setOfVariables: ''. </code></pre>

El algoritmo utiliza un sistema de pesos que considera el contexto clásico de un lenguaje con orientación programada a objetos y tipado dinámico.  Actualmente existen cuatro sistema de pesos posibles: "uniform", "similarity", "hierarchy" y "balanced".

<pre><code>
g addWeights: 'similarity'.
</code></pre>

Después para ejecutar el algoritmo y seleccionar el mejor individuo, se debe agregar el siguiente código. Puede demorar bastante tiempo:

<pre><code>
e := GPEngine new.
e configuration: g.
e execute.
i:= e pickBestIndividual.
</code></pre>

Finalmente para recompilar el método con su código original, evitando que existan problemas en la aplicación de Roassal: 

<pre><code> RSAbstractPlot compile: originalSource. </code></pre>

Finalmente para ejecutar, basta con seleccionar todo el código y teclear `ctrl + G`.

* Resultados

	- Código generado: `^ self definedValuesX max `. 
	
	![alt text](https://github.com/vicho08/GeneticProgramming/blob/master/images/fitnessTime02.png "Evolución fitness durante el avance del programa genético")



