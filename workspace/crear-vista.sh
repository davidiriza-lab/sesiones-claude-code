#!/usr/bin/env bash
# crear-vista.sh — vistas por organización sobre ~/proyectos/, hechas solo de symlinks.
#
# La carpeta real de cada proyecto no se mueve nunca. Una "vista" es una carpeta en
# ~/Workspace/<organización>/ donde cada proyecto es un enlace simbólico con un nombre
# corto (y emoji, si quieres). git no ve los enlaces; los repos siguen en ~/proyectos/.
#
# Uso:
#   crear-vista.sh "<vista>" <carpeta-real> ["Nombre en la vista"]
#   crear-vista.sh --limpiar                 # borra enlaces rotos en todas las vistas
#
# Ejemplos:
#   crear-vista.sh "🟠 Empresa" landing-cliente-x "Landing Cliente X"
#   crear-vista.sh "🔵 Personal" sitio-web "🎩 Sitio Web"
#   crear-vista.sh "🔵 Personal" sitio-web            # usa el nombre de la carpeta
#
# Se puede correr las veces que quieras: si el enlace ya existe y apunta al mismo
# sitio, no hace nada; si apunta a otro sitio, lo reemplaza y avisa.

set -euo pipefail

PROYECTOS="${PROYECTOS:-$HOME/proyectos}"
WORKSPACE="${WORKSPACE:-$HOME/Workspace}"

limpiar() {
  local rotos=0
  [ -d "$WORKSPACE" ] || { echo "No existe $WORKSPACE"; exit 0; }
  while IFS= read -r -d '' enlace; do
    if [ ! -e "$enlace" ]; then
      echo "roto: $enlace -> $(readlink "$enlace")"
      rm "$enlace"
      rotos=$((rotos + 1))
    fi
  done < <(find "$WORKSPACE" -mindepth 2 -maxdepth 2 -type l -print0)
  echo "Enlaces rotos eliminados: $rotos"
}

if [ "${1:-}" = "--limpiar" ]; then
  limpiar
  exit 0
fi

if [ $# -lt 2 ]; then
  sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'
  exit 1
fi

vista="$1"
carpeta="$2"
nombre="${3:-$carpeta}"

# Acepta ruta absoluta o nombre dentro de $PROYECTOS.
if [ -d "$carpeta" ]; then
  real="$(cd "$carpeta" && pwd)"
elif [ -d "$PROYECTOS/$carpeta" ]; then
  real="$PROYECTOS/$carpeta"
else
  echo "No encuentro la carpeta real: $carpeta (ni en $PROYECTOS)"
  exit 1
fi

destino_dir="$WORKSPACE/$vista"
destino="$destino_dir/$nombre"
mkdir -p "$destino_dir"

if [ -L "$destino" ]; then
  actual="$(readlink "$destino")"
  if [ "$actual" = "$real" ]; then
    echo "ya existe: $destino -> $real"
    exit 0
  fi
  echo "reemplazo: $destino apuntaba a $actual"
  rm "$destino"
elif [ -e "$destino" ]; then
  echo "En la vista ya hay algo que NO es un enlace: $destino. No lo toco."
  exit 1
fi

ln -s "$real" "$destino"
echo "creado: $destino -> $real"
