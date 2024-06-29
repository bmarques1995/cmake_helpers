param (
    [string]$buildMode = "Debug",
    [string]$installPrefix
)

if (($buildMode -eq "Debug" -or $buildMode -eq "Release") -and ($installPrefix -ne ""))
{
    git clone --recursive https://github.com/facebook/zstd.git ./modules/zstd
    cmake -S ./modules/zstd/build/cmake -B ./dependencies/windows/zstd -DCMAKE_INSTALL_PREFIX="$installPrefix"
    cmake --build ./dependencies/windows/zstd --config "$buildMode" --target install
}