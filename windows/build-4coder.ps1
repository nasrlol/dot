# Build the byp custom layer from ~/4coder (nasrlol/4coder) and install it next
# to the stock 4coder 4.1.8 binaries in %LOCALAPPDATA%\Programs\4coder.
#
#   powershell -ExecutionPolicy Bypass -File windows\build-4coder.ps1
param(
    [string]$Repo = "$HOME\4coder",
    [string]$App  = "$env:LOCALAPPDATA\Programs\4coder"
)
$ErrorActionPreference = 'Stop'
$byp  = "$Repo\build\4coder_byp"
$work = "$env:TEMP\4coder-build"
$vc   = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath
New-Item -ItemType Directory -Force $work | Out-Null

# buildsuper runs metadata_generator from the cwd, so keep cwd exe lookup on
cmd /c "set NoDefaultCurrentDirectoryInExePath=&& call `"$vc\VC\Auxiliary\Build\vcvarsall.bat`" amd64 >nul && cd /d `"$work`" && call `"$byp\custom\bin\buildsuper_x64-win.bat`" `"$byp\4coder_byp.cpp`" release"
if (-not (Test-Path "$work\custom_4coder.dll")) { throw 'build failed' }
# metadata_generator rewrites this header with local paths; keep the repo clean
git -C $Repo restore build/4coder_byp/custom/generated/command_metadata.h

if (-not (Test-Path "$App\custom_4coder.stock.dll")) { Copy-Item "$App\custom_4coder.dll" "$App\custom_4coder.stock.dll" }
Copy-Item "$work\custom_4coder.dll", "$work\custom_4coder.pdb" $App -Force
Copy-Item "$Repo\build\config.4coder" $App -Force
Copy-Item "$Repo\build\themes\*" "$App\themes" -Force
Copy-Item "$Repo\build\fonts\*" "$App\fonts" -Force
"installed byp layer + config into $App"
