# Build 4coder from the latest 4coder-community/4cc develop (core: 4ed.exe +
# 4ed_app.dll) plus the byp custom layer from ~/4coder (nasrlol/4coder), and
# install both into %LOCALAPPDATA%\Programs\4coder with the config, themes, fonts.
#
#   powershell -ExecutionPolicy Bypass -File windows\build-4coder.ps1
param(
    [string]$Repo = "$HOME\4coder",
    [string]$Core = "$HOME\src\4cc",
    [string]$App  = "$env:LOCALAPPDATA\Programs\4coder"
)
$ErrorActionPreference = 'Stop'
$vs = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -property installationPath
$vcvars = "$vs\VC\Auxiliary\Build\vcvarsall.bat"

# 1. core from upstream develop
if (Test-Path $Core) { git -C $Core pull -q --ff-only } else { git clone -q https://github.com/4coder-community/4cc.git $Core }
# build.exe runs the metadata generator from the cwd, so keep cwd exe lookup on
cmd /c "set NoDefaultCurrentDirectoryInExePath=&& call `"$vcvars`" amd64 >nul && `"$Core\build.bat`" --mode=release"
if ($LASTEXITCODE) { throw 'core build failed' }

# 2. byp layer, staged so the repo stays untouched. byp vendors its own custom
# layer, but its API tables must match the core's, so take the core's.
$stage = "$env:TEMP\4coder-byp-stage"
$work  = "$env:TEMP\4coder-build"
Remove-Item -Recurse -Force $stage, $work -ErrorAction SilentlyContinue
Copy-Item "$Repo\build\4coder_byp" $stage -Recurse
foreach ($f in 'custom_api.h', 'custom_api.cpp', 'custom_api_master_list.h', 'custom_api_constructor.cpp') {
    Copy-Item "$Core\code\custom\generated\$f" "$stage\custom\generated\$f" -Force
}
New-Item -ItemType Directory $work | Out-Null
cmd /c "set NoDefaultCurrentDirectoryInExePath=&& call `"$vcvars`" amd64 >nul && cd /d `"$work`" && call `"$stage\custom\bin\buildsuper_x64-win.bat`" `"$stage\4coder_byp.cpp`" release"
if (-not (Test-Path "$work\custom_4coder.dll")) { throw 'layer build failed' }

# 3. install
New-Item -ItemType Directory -Force "$App\themes", "$App\fonts" | Out-Null
if (-not (Test-Path "$App\4ed.exe")) { Copy-Item "$Core\build\*" $App -Recurse -Force }
Copy-Item "$Core\build\4ed.exe", "$Core\build\4ed_app.dll" $App -Force
Copy-Item "$work\custom_4coder.dll", "$work\custom_4coder.pdb" $App -Force
Copy-Item "$Repo\build\config.4coder" $App -Force
Copy-Item "$Repo\build\themes\*" "$App\themes" -Force
Copy-Item "$Repo\build\fonts\*" "$App\fonts" -Force
"installed 4cc $(git -C $Core log -1 --format='%h %cs') + byp layer into $App"
