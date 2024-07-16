# target_destination

`set_cxx_project_standards(TARGET_NAME STANDARD_VERSION USES_C)`:
this function is used to set some args for a Target Component listed above:

- RUNTIME/LIBRARY/ARCHIVE Destination: this is the destination of the build result
- Standard: Set the C/CXX standard of the project 

Args:
- TARGET_NAME: is the name of the target
- STANDARD_VERSION: is the C/CXX standard version.
- USES_C: Tell the cmake if the project uses C or CXX

`target_installation_behaviour(CONFIG_FILE TARGET_NAME VERSION PROJECT_NAME NAMESPACE USE_SHARE HEADER_INPUT HEADER_OUTPUT)`:
this function is used to set installation resources of a Target Component:

Args:
- CONFIG_FILE: file that will be use in the function `configure_file` of cmake, that will generate the targets
- TARGET_NAME: is the name of the target
- VERSION: version of the package.
- PROJECT_NAME: Name of the project.
- NAMESPACE: Namespace of the target installation, the most common set is the project name.
- USE_SHARE: Optional, defines if the config files will be saved on `${CMAKE_INSTALL_PREFIX}/lib/cmake` or `${CMAKE_INSTALL_PREFIX}/share/cmake`, the default value is false
- HEADER_INPUT: Optional, defines the header files source folder, if is set must have the same size of the HEADER_OUTPUT, is recommended that these directories being wrapped by a `$<BUILD_INTERFACE:dir>`
- HEADER_INPUT: Optional, defines the header files installation folder, if is set must have the same size of the HEADER_INPUT, is recommended that these directories being wrapped by a `$<INSTALL_INTERFACE:dir>`
