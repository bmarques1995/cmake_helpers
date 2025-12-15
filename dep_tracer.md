# dep_tracer

`trace_dependency(<NAME> <INSTALL_SCRIPT> [VERSION] [COMPONENTS...] [USE_VSTOOLS] [LIMIT_SEARCH_PATHS] [<COMPONENT_INFIX>] [<EXTRA_SUFFIXES>] [<PYTHON_SUFFIX_NAME>] [<WORKING_DIR>])`:
this function is used to search for a package, if it is found the macro is aborted, but if it was not found, the macro will call an install script to clone the dependency and install it.

Args:
- NAME: is the name of the dependency
- INSTALL_SCRIPT: script used to download, compile and install the dependency, for Linux distros it calls bash for a `.sh` script, on Windows the supported files are `.cmd` and `.bat` for command prompt and `.ps1` for powershell. Two sample scripts are avaliable at `./installers_examples/`.
- VERSION: Optional, referred to the package version
- COMPONENTS: Optional, referred to the package components, like Qt6 Widgets
- USE_VSTOOLS: Optional, referred to use the vs compiler path
- LIMIT_SEARCH_PATHS: Optional, referred to search only in the INSTALL_PREFIX
- COMPONENT_INFIX: Optional, referred to the package component infix pattern, where the default value is empty, when you call `find_package(<NAME> COMPONENTS <COMPONENTS>)`, a set of variable is stored, and each package follow one pattern, the most usual is empty, for example `find_package(Qt6 COMPONENTS Core)` will produce the variable `Qt6Core_FOUND`, but in some cases, it need an infix to separate the package name to the component name, for example `find_package(Boost COMPONENTS System)` will produce the variable `Boost_System_FOUND`.
- EXTRA_SUFFIXES: Optional, add extra search suffixes, ignored if LIMIT_SEARCH_PATH is false.
- PYTHON_NAME_SUFFIX: Optional, allow the addition of a suffix for the python executable. Ex: python3
- WORKING_DIR: Optional, set the directory where the dependency fetcher is located

`trace_library(<NAME> <INSTALL_SCRIPT> [USE_VSTOOLS] [LIMIT_SEARCH_PATHS] [<PYTHON_SUFFIX_NAME>] [<WORKING_DIR>])`:
this function is used to search for a library, if it is found the macro is aborted, but if it was not found, the macro will call an install script to clone the dependency and install it.
Uses the same principle of the `trace_dependency`.

Args:
- NAME: is the name of the dependency
- INSTALL_SCRIPT: script used to download, compile and install the dependency, for Linux distros it calls bash for a `.sh` script, on Windows the supported files are `.cmd` and `.bat` for command prompt and `.ps1` for powershell.
- USE_VSTOOLS: Optional, referred to use the vs compiler path
- LIMIT_SEARCH_PATHS: Optional, referred to search only in the INSTALL_PREFIX
- PYTHON_NAME_SUFFIX: See trace_dependency PYTHON_NAME_SUFFIX.
- WORKING_DIR: Optional, set the directory where the dependency fetcher is located

Disclaimer: These macros use `CMAKE_BUILD_TYPE` to define the build type, Debug/Release, and `CMAKE_INSTALL_PREFIX` to define the binaries installation dir. These values will be sent to the builder as command line arguments.

`trace_file(<NAME> <INSTALL_SCRIPT> <LOCATION> <EXTENSION> [LIMIT_SEARCH_PATHS]  [<PYTHON_SUFFIX_NAME>] [<WORKING_DIR>])`:
this function is used to search for a file, if it is found the macro is aborted, but if it was not found, the macro will call an install script to clone the file and install it.

Args:
- NAME: is the name of the file
- INSTALL_SCRIPT: script used to download, compile and install the dependency, for Linux distros it calls bash for a `.sh` script, on Windows the supported files are `.cmd` and `.bat` for command prompt and `.ps1` for powershell.
- LOCATION: parent directory to search the file
- EXTENSION: extension of desired file
- LIMIT_SEARCH_PATHS: Optional, referred to search only in the INSTALL_PREFIX
- PYTHON_NAME_SUFFIX: See trace_dependency PYTHON_NAME_SUFFIX.
- WORKING_DIR: Optional, set the directory where the dependency fetcher is located

`trace_installable_file(<NAME> <INSTALL_SCRIPT> <LOCATION> <EXTENSION> [LIMIT_SEARCH_PATHS] [<PYTHON_SUFFIX_NAME>] [<WORKING_DIR>])`:
Same for `trace_file`, but will compile a code instead of download it

All other functions are auxiliars and are not supposed to be used as separated functions/macros.
