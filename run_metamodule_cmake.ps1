param(
	[string]$MsysRoot = "C:\msys64"
)

$ErrorActionPreference = "Stop"

function Convert-ToMsysPath {
	param([string]$WindowsPath)
	$full = [System.IO.Path]::GetFullPath($WindowsPath)
	if ($full -match '^([A-Za-z]):\\(.*)$') {
		$drive = $Matches[1].ToLower()
		$rest = $Matches[2] -replace '\\', '/'
		return "/$drive/$rest"
	}
	throw "Percorso Windows non convertibile in MSYS: $WindowsPath"
}

function Test-ArmGccInDir {
	param([string]$BinDir)
	if ([string]::IsNullOrWhiteSpace($BinDir)) { return $false }
	$gcc = Join-Path $BinDir "arm-none-eabi-gcc.exe"
	return (Test-Path -LiteralPath $gcc)
}

function Find-ArmToolchainBinDir {
	$explicit = $env:TOOLCHAIN_BASE_DIR
	if (Test-ArmGccInDir $explicit) {
		return [System.IO.Path]::GetFullPath($explicit.TrimEnd('\', '/'))
	}

	try {
		$cmd = Get-Command "arm-none-eabi-gcc.exe" -ErrorAction Stop
		$d = Split-Path -Parent $cmd.Source
		if (Test-ArmGccInDir $d) { return [System.IO.Path]::GetFullPath($d) }
	} catch {}

	$searchRoots = @(
		(Join-Path $env:ProgramFiles "Arm GNU Toolchain"),
		(Join-Path ${env:ProgramFiles(x86)} "Arm GNU Toolchain"),
		(Join-Path $env:ProgramFiles "GNU Arm Embedded Toolchain"),
		(Join-Path ${env:ProgramFiles(x86)} "GNU Arm Embedded Toolchain")
	)
	foreach ($root in $searchRoots) {
		if (!(Test-Path -LiteralPath $root)) { continue }
		$hit = Get-ChildItem -LiteralPath $root -Recurse -Filter "arm-none-eabi-gcc.exe" -ErrorAction SilentlyContinue |
			Sort-Object FullName -Descending |
			Select-Object -First 1
		if ($hit) {
			return $hit.Directory.FullName
		}
	}

	return $null
}

$metaDir = $PSScriptRoot
$bashExe = Join-Path $MsysRoot "usr\bin\bash.exe"
if (!(Test-Path -LiteralPath $bashExe)) {
	throw "MSYS2 bash non trovato: $bashExe (imposta -MsysRoot o installa MSYS2)"
}

$tcWin = Find-ArmToolchainBinDir
if (-not $tcWin) {
	Write-Host @"
[krono-mm] arm-none-eabi-gcc non trovato.
[krono-mm] Installa ARM GNU Toolchain 12.2 o 12.3 (arm-none-eabi) da:
         https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
[krono-mm] Poi o aggiungi la cartella ...\bin al PATH di Windows, oppure in BUILD_METAMODULE.cmd:
         set TOOLCHAIN_BASE_DIR=C:\percorso\alla\toolchain\bin
"@ -ForegroundColor Yellow
	exit 1
}

$msysTc = Convert-ToMsysPath $tcWin
Write-Host "[krono-mm] Toolchain bin: $tcWin"

$inner = Convert-ToMsysPath (Join-Path $metaDir "build_metamodule_msys.sh")
$innerEsc = $inner -replace "'", "'\''"

Write-Host "[krono-mm] CMake MetaModule (MSYS2 MINGW64)..."
$msysTcEsc = $msysTc -replace "'", "'\''"
$mmArgs = $env:KRONO_MM_BUILD_ARGS
if ([string]::IsNullOrWhiteSpace($mmArgs)) {
	$invokeInner = "bash '$innerEsc'"
} else {
	$invokeInner = "bash '$innerEsc' $mmArgs"
}
$bashLc = "set -euo pipefail; export MSYSTEM=MINGW64; export CHERE_INVOKING=1; export TOOLCHAIN_BASE_DIR='$msysTcEsc'; export PATH='$msysTcEsc':/mingw64/bin:/usr/bin:`$PATH; $invokeInner"
& $bashExe -lc $bashLc
if ($LASTEXITCODE -ne 0) {
	exit $LASTEXITCODE
}
