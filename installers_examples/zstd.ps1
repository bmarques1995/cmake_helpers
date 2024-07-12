param (
    [string]$buildMode = "Debug",
    [string]$installPrefix,
    [string]$moduleDestination
)

if (($buildMode -eq "Debug" -or $buildMode -eq "Release") -and ($installPrefix -ne ""))
{
    git clone --recursive https://github.com/facebook/zstd.git "$moduleDestination/modules/zstd"
    cmake -S "$moduleDestination/modules/zstd/build/cmake" -B "$moduleDestination/dependencies/windows/zstd" -DCMAKE_INSTALL_PREFIX="$installPrefix"
    cmake --build "$moduleDestination/dependencies/windows/zstd" --config "$buildMode" --target install
}