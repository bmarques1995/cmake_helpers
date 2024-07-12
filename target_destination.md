# target_destination

`set_cxx_project_standards(TARGET_NAME STANDARD_VERSION USES_C)`:
this function is used to set some args for a Target Component listed above:

- RUNTIME/LIBRARY/ARCHIVE Destination: this is the destination of the build result
- Standard: Set the C/CXX standard of the project 

Args:
- TARGET_NAME: is the name of the target
- STANDARD_VERSION: is the C/CXX standard version.
- USES_C: Tell the cmake if the project uses C or CXX
