#!/usr/bin/env bash
# Falla si un registro de Godot contiene errores.
# Necesario porque Godot sin interfaz suele terminar con código 0 aunque
# haya errores de script o de carga de recursos.
#
# Uso: tools/ci/check_log.sh <archivo.log>
set -euo pipefail

LOG="${1:?Indica el archivo de registro}"
PATTERN='SCRIPT ERROR|^ERROR:|Parse Error|Failed to load|Cannot load|Invalid call|Attempt to call'

if grep -nE "${PATTERN}" "${LOG}"; then
  echo "::error::Se encontraron errores en ${LOG}"
  exit 1
fi
echo "Sin errores en ${LOG}."
