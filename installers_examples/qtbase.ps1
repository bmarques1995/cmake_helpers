param (
    [string]$buildMode = "Debug",
    [string]$installPrefix
)

if (($buildMode -eq "Debug" -or $buildMode -eq "Release") -and ($installPrefix -ne ""))
{
    git clone --recursive https://code.qt.io/qt/qtbase.git ./modules/qtbase
    cmake -S ./modules/qtbase -B ./dependencies/windows/qtbase -G "Ninja" -DCMAKE_INSTALL_PREFIX="$installPrefix" -DCMAKE_C_COMPILER=cl.exe -DCMAKE_CXX_COMPILER=cl.exe -DCMAKE_BUILD_TYPE="$buildMode" -DCMAKE_ASM_COMPILER=ml64.exe
    cmake --build ./dependencies/windows/qtbase --parallel --fresh
    Set-Location ./dependencies/windows/qtbase
    ninja install
    Set-Location ../../..
}
else
{
    Write-Output "Invalid build type or install path. Please provide either 'Debug' or 'Release' and a valid prefix path"
}