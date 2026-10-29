#!/usr/bin/env bash
# Instala Godot (Linux, sin interfaz) y SOLO las plantillas de exportación web.
# Verifica cada descarga contra el SHA512-SUMS.txt oficial de la versión.
#
# Uso: tools/ci/install_godot.sh 4.4.1
# Resultado: $HOME/godot/godot y plantillas en
#            $HOME/.local/share/godot/export_templates/<versión>.stable/
set -euo pipefail

VERSION="${1:?Indica la versión de Godot, p. ej. 4.4.1}"
TAG="${VERSION}-stable"
BASE_URL="https://github.com/godotengine/godot/releases/download/${TAG}"
GODOT_DIR="${HOME}/godot"
TEMPLATES_DIR="${HOME}/.local/share/godot/export_templates/${VERSION}.stable"
BIN_ZIP="Godot_v${TAG}_linux.x86_64.zip"
TPL_FILE="Godot_v${TAG}_export_templates.tpz"

mkdir -p "${GODOT_DIR}" "${TEMPLATES_DIR}"
cd "${GODOT_DIR}"

if [[ -x "${GODOT_DIR}/godot" && -f "${TEMPLATES_DIR}/web_nothreads_release.zip" ]]; then
  echo "Godot ${VERSION} ya instalado (caché)."
else
  curl -fsSL -o SHA512-SUMS.txt "${BASE_URL}/SHA512-SUMS.txt"

  echo "Descargando ${BIN_ZIP}..."
  curl -fsSL -o "${BIN_ZIP}" "${BASE_URL}/${BIN_ZIP}"
  grep " ${BIN_ZIP}\$" SHA512-SUMS.txt | sha512sum -c -
  unzip -o -q "${BIN_ZIP}"
  mv -f "Godot_v${TAG}_linux.x86_64" godot
  chmod +x godot
  rm -f "${BIN_ZIP}"

  echo "Descargando ${TPL_FILE} (~1,2 GB)..."
  curl -fsSL -o "${TPL_FILE}" "${BASE_URL}/${TPL_FILE}"
  grep " ${TPL_FILE}\$" SHA512-SUMS.txt | sha512sum -c -
  unzip -o -q -j "${TPL_FILE}" 'templates/web_*' 'templates/version.txt' -d "${TEMPLATES_DIR}"
  rm -f "${TPL_FILE}"
fi

if [[ -n "${GITHUB_PATH:-}" ]]; then
  echo "${GODOT_DIR}" >> "${GITHUB_PATH}"
fi

"${GODOT_DIR}/godot" --headless --version
