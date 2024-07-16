param (
    [string]$buildMode = "Debug",
    [string]$installPrefix,
    [string]$moduleDestination,
    [string]$vsCompilerLocation
)

function AppendVSHost {
    param (
        [string]$compilerLocation,
        [bool]$IsArch64= 1
    )
    $baseArch = "x64"
    if(!$IsArch64)
    {
        $baseArch = "x86"
    }

    $compilerRegex = "MSVC[\\/](\d+\.\d+\.\d+)[\\/]bin"
    $vsVersionRegex = "(.*Community|Enterprise|Professional)"

    $compilerVersion = ""
    $vsBasePath = ""

    if ($compilerLocation -match $compilerRegex) {
        $compilerVersion = $matches[1]
    } else {
        Write-Output "Version not found"
    }

    if ($compilerLocation -match $vsVersionRegex) {
        $vsBasePath = $matches[1]
    } else {
        Write-Output "Version not found"
    }

    $env:PATH = "$vsBasePath/VC/Tools/MSVC/$compilerVersion/bin/Host$baseArch/$baseArch;$env:PATH"
}

if (($buildMode -eq "Debug" -or $buildMode -eq "Release") -and ($installPrefix -ne "") -and ($moduleDestination -ne "") -and ($vsCompilerLocation -ne ""))
{
    AppendVSHost($vsCompilerLocation)
    $buildMode = $buildMode.ToLower()
    Set-Location $moduleDestination
    where.exe nmake.exe
    git clone --recursive https://github.com/openssl/openssl.git ./modules/openssl
    Set-Location ./modules/openssl
    perl ./Configure VC-WIN64A "--$buildMode" --prefix="$installPrefix" --openssldir="$install_prefix/openssl" -shared zlib-dynamic --with-zlib-lib="$installPrefix/lib" --with-zlib-include="$installPrefix/include" --with-brotli-include="$installPrefix/include" --with-brotli-lib="$installPrefix/lib" enable-zstd-dynamic --with-zstd-lib="$installPrefix/lib" --with-zstd-include="$installPrefix/include"
    nmake
    nmake install
    Set-Location ../..
}
else
{
    Write-Output "Invalid build type or install path. Please provide either 'Debug' or 'Release' and a valid prefix path"
}