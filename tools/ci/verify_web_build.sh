#!/usr/bin/env bash
# Comprueba que la exportación web está completa y preparada para iPhone.
#
# Uso: tools/ci/verify_web_build.sh build/web
set -euo pipefail

DIR="${1:?Indica la carpeta de la compilación web}"
FAIL=0

fail() { echo "::error::$1"; FAIL=1; }
ok()   { echo "OK    $1"; }

# 1. Archivos imprescindibles.
for f in index.html index.js index.wasm index.pck _headers; do
  if [[ -s "${DIR}/${f}" ]]; then ok "existe ${f}"; else fail "falta ${f}"; fi
done

HTML="${DIR}/index.html"

# 2. Plantilla propia para iPhone.
grep -q 'viewport-fit=cover' "${HTML}"      && ok "viewport-fit=cover"          || fail "falta viewport-fit=cover"
grep -q 'id="sp-rotate"' "${HTML}"          && ok "aviso de giro presente"      || fail "falta el aviso de giro"
grep -q 'id="sp-safe-probe"' "${HTML}"      && ok "sonda de zonas seguras"      || fail "falta la sonda de zonas seguras"
grep -q 'window.spSafeArea' "${HTML}"       && ok "puente spSafeArea"           || fail "falta window.spSafeArea"

# 3. Exportación sin hilos (compatible con Safari/iOS sin cabeceras COOP/COEP).
grep -q 'GODOT_THREADS_ENABLED = false' "${HTML}" && ok "exportación sin hilos" || fail "la exportación usa hilos"

# 4. Ningún marcador de la plantilla sin sustituir.
if grep -q '\$GODOT_' "${HTML}"; then fail "quedan marcadores \$GODOT_ sin sustituir"; else ok "marcadores sustituidos"; fi

# 5. Las pruebas no viajan dentro del paquete del juego.
#    (Godot sí guarda sus RUTAS en el índice uid_cache.bin, pero no su código:
#    se buscan los archivos compilados/convertidos, que son los que importan.)
if grep -aqE 'res://tests/[^[:space:]]*\.(gdc|scn|remap)' "${DIR}/index.pck"; then
  fail "index.pck contiene archivos de prueba"
else
  ok "index.pck sin archivos de prueba"
fi

# 6. Informe de tamaño (sin y con compresión).
echo
echo "Tamaños:"
for f in index.wasm index.pck index.js index.html; do
  raw=$(stat -c %s "${DIR}/${f}")
  gz=$(gzip -9 -c "${DIR}/${f}" | wc -c)
  printf '  %-12s %10s bytes  (gzip: %s bytes)\n' "${f}" "${raw}" "${gz}"
done
echo "  total      $(du -sb "${DIR}" | cut -f1) bytes"

exit "${FAIL}"
