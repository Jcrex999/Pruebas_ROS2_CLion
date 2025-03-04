# Tutorial de como configurar Clion para ROS2

## Paso 1: Crear un Espacio de Trabajo de ROS 2

Primero se debe crear un workspace de ROS2, para ello se debe ejecutar el siguiente comando:

```bash
mkdir -p dev_ws/src
cd dev_ws/src
ros2 pkg create --build-type ament_cmake <package_name>
```
## Paso 2: Compilar el Espacio de Trabajo y Generar la Base de Datos de Compilación

1. Navega al directorio raíz de tu espacio de trabajo:
    ```bash
    cd ~/dev_ws
    ```
2. Compila el espacio de trabajo utilizando `colcon` y genera el archivo `compile_commands.json`:
    ```bash
    colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G Ninja
    ```
Este comando compilará todos los paquetes en tu espacio de trabajo y generará una base de datos de compilación en formato JSON que CLion utilizará para indexar el código.
### Nota
En caso de que no aparesca el archivo `compile_commands.json` en la carpeta `build`, se debe a que no tienes configurado el CMakeLists.txt ni package.xml, por lo que no se compilara correctamente. La configuración es la misma que harias para un proyecto de ROS2 normal.

## Paso 3: Crear el script de construcción del workspace
Requerimos hacer un script que nos permita compilar el workspace de ROS2, para ello se debe crear un archivo llamado `build.sh` en el directorio raíz del workspace con el siguiente contenido:

```bash
#!/bin/bash
colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G Ninja --symlink-install

# Copiar el archivo compile_commands.json al directorio raíz del proyecto
# Por lo cual, se debe de ejecutar este script en el directorio raíz del workspace
cp build/compile_commands.json .
```


## Paso 4: Configurar CLion para Usar la Base de Datos de Compilación

1. Abrir CLion desde la Terminal con el Entorno de ROS 2 Sourced:

    Es importante que CLion herede las variables de entorno de ROS 2. Para ello, abre una terminal, sourcea el entorno de ROS 2 y luego inicia CLion desde esa terminal:
    ```bash
    source /opt/ros/humble/setup.bash
    clion &
    ```
2. Abrir el Proyecto en CLion:
    * En CLion, selecciona `File | Open` y navega hasta el archivo `compile_commands.json` ubicado en el directorio build de tu espacio de trabajo `(~/dev_ws/build/compile_commands.json)`.
    * Selecciona `compile_commands.json` y haz clic en `Open` para abrirlo como proyecto.
3. Establecer el Directorio Raíz del Proyecto:
    * Una vez abierto el proyecto, ve a `Tools | Compilation Database | Change Project Root` en el menú principal de CLion.
    * Selecciona el directorio raíz de tu espacio de trabajo `(~/dev_ws)` como el nuevo directorio raíz del proyecto.

## Paso 5: Crear un Objetivo de Compilación Personalizado en CLion
1. Ve a `File | Settings | Build, Execution, Deployment | Custom Build Targets` en el menú de CLion.

2. Haz clic en el botón + para añadir un nuevo objetivo de compilación.
3. Preciona los 3 puntos al lado del desplegable de `build:` y selecciona el `+` para añadir un nuevo `External Tools`.
4. Selecciona el nuevo `External Tools` y configura de la siguiente manera:

   * Name: `CMake commands script`
   * Program: `PATH_al_script/build.sh`
   * Arguments: deja en blanco
   * Working directory: `~/dev_ws/buid/<package_name>`

Ahora con el script creado, se debe de configurar el objetivo de compilación personalizado:
1. Ve a `Settings | Tools | External Tools` en el menú de CLion.
2. Haz clic en el botón + para añadir un nuevo objetivo de compilación.
3. Configura el objetivo de la siguiente manera:

   * Target Name: `colcon build`
   * Build Tool: `colcon`
   * Build Tool Arguments: `build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G Ninja`
   * Working Directory: `~/dev_ws`

4. Guarda los cambios.

## Paso 6: Crear una Configuración de Ejecución/Depuración para el Objetivo de Compilación Personalizado

1. Ve a `Run | Edit Configurations` en el menú principal de CLion.

2. Haz clic en el botón `+` y selecciona `Custom Build Application`.
3. Configura la nueva configuración de la siguiente manera:

   * Name: `Ejecutar Nodo mi_paquete`
   * Target: Selecciona el objetivo de compilación personalizado `colcon build` que creaste anteriormente.
   * Executable: Especifica la ruta al ejecutable del nodo que deseas ejecutar. Por ejemplo, `~/dev_ws/install/mi_paquete/lib/mi_paquete/mi_nodo`.
   * Program Arguments: Si tu nodo requiere argumentos específicos, indícalos aquí.
   * Environment: Asegúrate de que las variables de entorno necesarias para ROS 2 estén configuradas correctamente.

4. Guarda la configuración.

## Paso 7: Construir y Ejecutar/Depurar el Paquete
* Para construir el paquete:

  * Selecciona el objetivo de compilación personalizado colcon build y ejecútalo.

* Para ejecutar o depurar el nodo:

  * Selecciona la configuración de ejecución/depuración Ejecutar Nodo mi_paquete y ejecútala o iníciala en modo depuración según sea necesario.

## Recursos Adicionales

* [Tutorial de configuración de ROS 2 en CLion](https://www.jetbrains.com/help/clion/ros2-tutorial.html?keymap=Sublime%20Text)

Siguiendo estos pasos, podrás configurar CLion para desarrollar aplicaciones con ROS 2 en Ubuntu 22.04 de manera eficiente.
