if [ "$1" == "Debug" ] || [ "$1" == "Release" ] && [ ! -z "$2" ] && [ ! -z "$3" ]; then
    git clone --recursive http://code.qt.io/qt/qtbase.git "$3/modules/qtbase"
    cmake -S "$3/modules/qtbase" -B "$3/dependencies/linux/qtbase" -G "Ninja"  -DCMAKE_INSTALL_PREFIX="$2" -DCMAKE_BUILD_TYPE="$1"
    cmake --build "$3/dependencies/linux/qtbase" --target install
else
    echo "Invalid build type or install path. Please provide either 'Debug' or 'Release', a valid prefix path and a valid Module Destination"
fi
