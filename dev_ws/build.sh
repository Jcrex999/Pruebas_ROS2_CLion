#!/bin/bash
colcon build --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -G Ninja --symlink-install

# Copiar el archivo compile_commands.json al directorio raíz del proyecto
cp build/compile_commands.json .