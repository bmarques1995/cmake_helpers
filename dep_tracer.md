# dep_tracer

`trace_dependency(<NAME> <INSTALL_SCRIPT> [<VERSION>] [COMPONENTS ...])`:
this function is used to search for a package, if it is found the macro is aborted, but if it was not found, the macro will call an install script to clone the dependency and install it.

Args:
- NAME: is the name of the dependency
- INSTALL_SCRIPT: script used to download, compile and install the dependency, for Linux distros it calls bash for a `.sh` script, on Windows the supported files are `.cmd` and `.bat` for command prompt and `.ps1` for powershell. Two sample scripts are avaliable at `./installers_examples/`.
- VERSION: Optional, referred to the package version
- COMPONENTS: Optional, referred to the package components, like Qt6 Widgets

Disclaimer: The macro uses `CMAKE_BUILD_TYPE` to define the build type, Debug/Release, and `CMAKE_INSTALL_PREFIX` to define the binaries installation dir. These values will be sent to the builder as command line arguments.

All other functions are auxiliars.