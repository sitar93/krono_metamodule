#!/usr/bin/env bash
# Build Krono.mmplugin (MetaModule). Richiede MSYS2 MINGW64, CMake, arm-none-eabi-gcc 12.2/12.3 sul PATH
# o TOOLCHAIN_BASE_DIR punta alla cartella bin della toolchain ARM.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT"

SDK="${METAMODULE_SDK_DIR:-$ROOT/metamodule-plugin-sdk}"
if [[ ! -f "$SDK/plugin.cmake" ]]; then
	echo "[krono-mm] SDK non trovato: $SDK"
	echo "[krono-mm] Esegui dalla root del repo: git submodule update --init --recursive"
	exit 1
fi

EXTRA=()
if [[ -n "${TOOLCHAIN_BASE_DIR:-}" ]]; then
	EXTRA+=("-DTOOLCHAIN_BASE_DIR=${TOOLCHAIN_BASE_DIR}")
	echo "[krono-mm] TOOLCHAIN_BASE_DIR=$TOOLCHAIN_BASE_DIR"
fi

echo "[krono-mm] METAMODULE_SDK_DIR=$SDK"

# Se build/ è stata copiata da un altro percorso, CMakeCache punta ancora al vecchio sorgente: elimina build/.
if [[ -f build/CMakeCache.txt ]] && command -v cygpath >/dev/null 2>&1; then
	_cached_home="$(grep -m1 '^CMAKE_HOME_DIRECTORY:INTERNAL=' build/CMakeCache.txt 2>/dev/null | cut -d= -f2- || true)"
	if [[ -n "$_cached_home" ]]; then
		_cur="$(cygpath -w "$ROOT" | tr '\\' '/' | tr '[:upper:]' '[:lower:]')"
		_ch="$(echo "$_cached_home" | tr '\\' '/' | tr '[:upper:]' '[:lower:]')"
		if [[ "$_ch" != "$_cur" ]]; then
			echo "[krono-mm] CMakeCache riferisce un altro albero sorgente ($_cached_home); rimuovo build/."
			rm -rf build
		fi
	fi
	unset _cached_home _cur _ch
fi

# Senza --fresh: build incrementale (molto più veloce). Pulizia completa: ./build_metamodule_msys.sh fresh
if [[ "${1:-}" == "fresh" ]]; then
	echo "[krono-mm] cmake --fresh (riconfigurazione e rebuild da zero)"
	cmake --fresh -B build -G "MSYS Makefiles" -DMETAMODULE_SDK_DIR="$SDK" "${EXTRA[@]}"
else
	cmake -B build -G "MSYS Makefiles" -DMETAMODULE_SDK_DIR="$SDK" "${EXTRA[@]}"
fi
cmake --build build

echo "[krono-mm] Output: $ROOT/metamodule-plugins/Krono.mmplugin (se il build è andato a buon fine)"
