if [ "$1" == "Debug" ] || [ "$1" == "Release" ] && [ ! -z "$2" ]; then
    git clone --recursive https://github.com/facebook/zstd.git ./modules/zstd
    cmake -S ./modules/zstd/build/cmake -B ./dependencies/linux/zstd -DCMAKE_INSTALL_PREFIX="$2" -DCMAKE_BUILD_TYPE="$1"
    cmake --build ./dependencies/linux/zstd --target install
else
    echo "Invalid build type or install path. Please provide either 'Debug' or 'Release' and a valid prefix path"
fi
