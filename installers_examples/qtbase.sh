if [ "$1" == "Debug" ] || [ "$1" == "Release" ] && [ ! -z "$2" ]; then
    git clone --recursive http://code.qt.io/qt/qtbase.git ./modules/qtbase
    cmake -S ./modules/qtbase -B ./dependencies/linux/qtbase -G "Ninja"  -DCMAKE_INSTALL_PREFIX="$2" -DCMAKE_BUILD_TYPE="$1"
    cmake --build ./dependencies/linux/qtbase --target install
else
    echo "Invalid build type or install path. Please provide either 'Debug' or 'Release' and a valid prefix path"
fi
