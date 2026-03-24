

# Taller: Introducción a Big Data con sparklyr

Taller práctico de introducción al procesamiento de datos masivos con
**sparklyr** en R. Aprenderás a conectar con Apache Spark desde R,
manipular grandes volúmenes de datos con sintaxis dplyr, y construir
modelos de machine learning distribuidos.

## Requisitos previos

Antes de la sesión, asegúrate de tener instalado lo siguiente:

- **R** (≥ 4.3): https://cran.r-project.org/
- **RStudio** (≥ 2023.06): https://posit.co/download/rstudio-desktop/
- **Java 11**: necesario para ejecutar Spark. Puedes comprobar tu
  versión con `java -version` en la terminal.
  - Windows/Mac: https://adoptium.net/temurin/releases/?version=11
  - Ubuntu/Debian: `sudo apt install openjdk-11-jdk`
- **Git**: https://git-scm.com/downloads
- **Cuenta de GitHub**: https://github.com/signup

### Paquetes de R

Abre RStudio y ejecuta lo siguiente para instalar los paquetes
necesarios:

``` r
install.packages(c("sparklyr", "dplyr", "ggplot2", "tidyr", "knitr"))
```

Después, instala Apache Spark en local (esto tarda unos minutos la
primera vez):

``` r
sparklyr::spark_install(version = "3.5.0")
```

Para comprobar que todo funciona:

``` r
library(sparklyr)
sc <- spark_connect(master = "local")
spark_disconnect(sc)
```

Si no obtienes errores, estás listo.

## Estructura del repositorio

    taller-sparklyr/
    ├── README.md                    ← Este archivo
    ├── .gitignore
    ├── taller_sparklyr.qmd          ← Notebook del taller (tu archivo de trabajo)
    ├── cheatsheet_sparklyr.html     ← Cheatsheet de referencia (abrir en navegador)
    └── data/
        └── generar_datos.R          ← Script para generar el dataset de vuelos

## Instrucciones paso a paso

### Paso 1 — Clonar el repositorio

Abre una terminal (o la terminal integrada de RStudio en
`Tools → Terminal`) y ejecuta:

``` bash
git clone https://github.com/calote/sparklyr-intro.git
cd sparklyr-intro
```

También puedes clonar desde RStudio:
`File → New Project → Version Control → Git`, pega la URL del
repositorio y elige una carpeta de destino.

### Paso 2 — Crear tu rama personal

Cada alumno trabaja en su propia rama. Usa el formato
`alumno/nombre-apellido` (sin tildes ni espacios):

``` bash
git checkout -b alumno/nombre-apellido
```

**Desde RStudio:** haz clic en el botón morado **New Branch** del panel
Git (pestaña arriba a la derecha), escribe el nombre de tu rama y pulsa
**Create**.

> ⚠️ **Importante:** nunca trabajes directamente en la rama `main`. Está
> protegida y no podrás hacer push a ella.

### Paso 3 — Generar los datos

El dataset no está incluido en el repositorio porque es demasiado
pesado. En su lugar, lo generamos con un script de simulación. En la
consola de R ejecuta:

``` r
source("data/generar_datos.R")
```

Esto creará el archivo `data/vuelos_2024.csv` con ~500.000 filas de
vuelos simulados. Tardará unos segundos. No te preocupes si no aparece
en el panel Git: está excluido por el `.gitignore`.

### Paso 4 — Trabajar en el notebook

Abre `taller_sparklyr.qmd` en RStudio. El notebook contiene
explicaciones, ejemplos resueltos y retos con huecos que debes
completar. Los huecos están marcados con `TU_CODIGO_AQUI`:

``` r
# Reto: Filtra los vuelos con retraso mayor a 60 minutos
vuelos_retrasados <- vuelos_spark %>%
  TU_CODIGO_AQUI
```

Tu trabajo consiste en reemplazar cada `TU_CODIGO_AQUI` por el código
correcto.

Tienes disponible `cheatsheet_sparklyr.html` como referencia rápida.
Ábrela en el navegador para consultarla mientras trabajas.

### Paso 5 — Guardar tu progreso

Cada vez que completes un reto o quieras guardar un punto intermedio:

**Desde la terminal:**

``` bash
git add taller_sparklyr.qmd
git commit -m "Completado reto 1"
git push origin alumno/nombre-apellido
```

**Desde RStudio:**

1.  En el panel **Git**, marca la casilla de `taller_sparklyr.qmd` (esto
    hace stage del archivo).
2.  Haz clic en **Commit**, escribe un mensaje descriptivo (por ejemplo,
    “Completado reto 3”) y pulsa **Commit**.
3.  Haz clic en la flecha verde **Push** para subir los cambios a
    GitHub.

> 💡 **Consejo:** haz commit con frecuencia. No esperes a tener todo
> terminado. Mensajes como “Completado reto 2” o “Avance en reto 5,
> falta el gráfico” son perfectos.

### Paso 6 — Entregar tu trabajo

Cuando hayas completado todos los retos (o al finalizar la sesión):

1.  Asegúrate de que has hecho **Commit** y **Push** de todos tus
    cambios.
2.  Ve a https://github.com/calote/sparklyr-intro en el navegador.
3.  Verás un banner amarillo con el nombre de tu rama → haz clic en
    **“Compare & pull request”**.
4.  En el título escribe: `Entrega - Tu Nombre Apellido`.
5.  Haz clic en el botón verde **“Create pull request”**.

**Alternativa rápida desde RStudio** (si tienes el paquete `usethis`):

``` r
usethis::pr_push()
```

Esto abre automáticamente el navegador en la página de creación del Pull
Request.

> ⚠️ **No es necesario que el PR se haga merge.** El Pull Request es tu
> entrega. El profesor revisará tu código directamente ahí y podrá
> dejarte comentarios línea a línea.

## Verificación automática

Cuando abras tu Pull Request, se ejecutará una verificación automática
que comprueba tres cosas:

- **Que no quedan huecos sin rellenar:** busca marcadores como
  `TU_CODIGO_AQUI` en tu notebook.
- **Que el código R no tiene errores de sintaxis:** analiza todos los
  bloques de código del notebook.
- **Que el notebook tiene cambios sustanciales:** comprueba que
  realmente has trabajado sobre el archivo.

Verás el resultado directamente en tu Pull Request como un check verde
(todo correcto) o rojo (algo falla). Si falla, lee el mensaje de error,
corrige tu código, haz commit y push de nuevo: la verificación se vuelve
a ejecutar automáticamente.

## Resolución de problemas

**“No tengo permiso para hacer push”** Asegúrate de que estás haciendo
push a tu rama (`alumno/nombre-apellido`), no a `main`. Comprueba tu
rama activa con `git branch` o en la esquina superior derecha del panel
Git de RStudio.

**“Spark no arranca”** Comprueba que Java 11 está instalado
correctamente: `java -version`. Si tienes varias versiones de Java,
configura la variable de entorno `JAVA_HOME` para que apunte a Java 11.
En R puedes verificarlo con `system("java -version")`.

**“No encuentro el archivo de datos”** Ejecuta
`source("data/generar_datos.R")` desde la consola de R. Asegúrate de que
tu directorio de trabajo es la raíz del proyecto (compruébalo con
`getwd()`).

**“Error al instalar sparklyr”** Prueba a actualizar R a la última
versión. Si el problema persiste, ejecuta
`install.packages("sparklyr", dependencies = TRUE)`.

**“No puedo crear el Pull Request”** Verifica que has hecho push al
menos una vez con `git push origin alumno/nombre-apellido`. El banner de
creación del PR solo aparece en GitHub después del primer push.

## Material de referencia

- [Documentación oficial de sparklyr](https://spark.rstudio.com/)
- [Cheatsheet incluida en el repositorio](cheatsheet_sparklyr.html)
  (descargar y abrir en navegador)
- [Mastering Spark with R](https://therinspark.com/) (libro gratuito
  online)
- [Referencia de dplyr](https://dplyr.tidyverse.org/reference/)
