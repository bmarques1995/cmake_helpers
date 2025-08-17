# target_destination

`set_cxx_project_standards(TARGET_NAME STANDARD_VERSION USES_C)`:
this function is used to set some args for a Target Component listed above:

- RUNTIME/LIBRARY/ARCHIVE Destination: this is the destination of the build result
- Standard: Set the C/CXX standard of the project 

Args:
- TARGET_NAME: is the name of the target
- STANDARD_VERSION: is the C/CXX standard version. A predefined list
	- `[90, 99, 11, 17, 23]` for C
	- `[98, 11, 14, 17, 20, 23, 26]` for C++
- USES_C: Tell the cmake if the project uses C or CXX

`target_installation_behaviour(<CONFIG_FILE> <TARGET_NAME> <VERSION> <PROJECT_NAME> <NAMESPACE> [USE_SHARE] [HEADER_INPUT...] [HEADER_OUTPUT...] [EXTRA_HEADER_EXTENSION...])`:
this function is used to set installation resources of a Target Component:

Args:
- CONFIG_FILE: file that will be use in the function `configure_file` of cmake, that will generate the targets
- TARGET_NAME: is the name of the target
- VERSION: version of the package.
- PROJECT_NAME: Name of the project.
- NAMESPACE: Namespace of the target installation, the most common set is the project name.
- USE_SHARE: Defines if the config files will be saved on `${CMAKE_INSTALL_PREFIX}/lib/cmake` or `${CMAKE_INSTALL_PREFIX}/share/cmake`, the default value is false, meaning the that the config files will be saved in `${CMAKE_INSTALL_PREFIX}/lib/cmake`
- HEADER_INPUT: Defines the header files source folder, if is set must have the same size of the HEADER_OUTPUT, these directories should be wrapped by a `$<BUILD_INTERFACE:dir>`, and must end with a `/` character, for example `${CMAKE_CURRENT_SOURCE_DIR}/include/content/`
- HEADER_OUTPUT: Defines the header files installation folder, if is set must have the same size of the HEADER_INPUT, these directories should be wrapped by a `$<INSTALL_INTERFACE:dir>`
- EXTRA_HEADER_EXTENSION_PATTERN: Defines extensions patterns of header files to be installed, `.h`, `.hpp`, `.hh`, `.hxx`, `.h++`, `.i`, `.ipp`, `.ii`, `.ixx`, `.i++`, `.inl` and `.inc` extensions are covered by default and will install the headers automaticly if are the only extensions, the most usual extension pattern expected is `*.<extension>`, if the files don't have extensions, just pass `*` if usual, but keep in mind to organize the unextended file in a special folder to not copy source files, you can use more ellaborated regexes, but this I keep with you.

`target_add_test(<TARGET_NAME> <SOURCE_DIR> <GTEST_INSTALL_SCRIPT> [<HEADER_EXTENSION>] [<SOURCE_EXTENSION>] [EXTRA_LINKED_LIBS...] [EXTRA_INCLUDE_DIRS...])`:
this function is used to set installation resources of a Target Component:

Args:

- TARGET_NAME: is the name of the target
- SOURCE_DIR: is the root directory where the project is located
- SUB_DIR: is the sub directory where the headers and source files are located, based on source dir
- GTEST_INSTALL_SCRIPT: is the location of the gtest script to install the lib
- HEADER_EXTENSION: is the header extension, by default is `.hpp`
- SOURCE_EXTENSION: is the source extension, by default is `.cpp`
- EXTRA_LINKED_LIBS: represents all libs that will be linked in addition of gtest suit.
- EXTRA_INCLUDE_DIRS: represents all include directories that will be added to the default path.

`appen_shared_lib_prefix_path(TARGET_NAME)`:

this function is user to set the installation dir to unix(linux|freebsd|netbsd) shared libs:

Args:

- TARGET_NAME: is the name of the target
