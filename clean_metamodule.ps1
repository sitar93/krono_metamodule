# Remove CMake build tree and IDE cache under krono_metamodule.
# Does not delete metamodule-plugins/ (Krono.mmplugin, readme.txt).

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot

$toRemove = @(
	@{ Path = Join-Path $root "build"; Label = "CMake build (objects, libs, generated files)" }
	@{ Path = Join-Path $root ".cache"; Label = "Editor cache (e.g. clangd index)" }
)

foreach ($item in $toRemove) {
	$p = $item.Path
	if (Test-Path -LiteralPath $p) {
		Write-Host "[krono-mm-clean] Removing $($item.Label): $p"
		Remove-Item -LiteralPath $p -Recurse -Force
	} else {
		Write-Host "[krono-mm-clean] Skip (not found): $p"
	}
}

Write-Host "[krono-mm-clean] Done. Output plugin in metamodule-plugins/ was not removed."
Write-Host "[krono-mm-clean] Rebuild with build_metamodule.cmd when needed."
