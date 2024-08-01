function(validate_shell_script_extension FILE)
    set(ALLOWED_EXTENSIONS "sh")
    if(WIN32)
        set(ALLOWED_EXTENSIONS "cmd|bat|ps1")  # Add other extensions as needed
    endif()
    string(REGEX MATCH "\\.(${ALLOWED_EXTENSIONS})$" EXT_VALIDATION_RESULT ${FILE})
    if(NOT EXT_VALIDATION_RESULT)
        
        if(WIN32)
            message(FATAL_ERROR "The allowed extensions are: \".cmd\", \".bat\" and \".ps1\"")
        else()
            message(FATAL_ERROR "The only allowed extensions is: \".sh\"")
        endif()
    endif()
endfunction()

function(set_shell_program SCRIPT_FILENAME)
    set(SCRIPT_RUNNER "bash" PARENT_SCOPE)
    set(SCRIPT_ARG PARENT_SCOPE)
    if(WIN32)
        set(CMD_EXTENSIONS "cmd|bat")
        string(REGEX MATCH "\\.(${CMD_EXTENSIONS})$" IS_CMD ${SCRIPT_FILENAME})
        if(IS_CMD)
            set(SCRIPT_RUNNER "cmd" PARENT_SCOPE)
            set(SCRIPT_ARG "/c" PARENT_SCOPE)
        else()
            set(SCRIPT_RUNNER "powershell" PARENT_SCOPE)
            set(SCRIPT_ARG "-File" PARENT_SCOPE)
        endif()
    endif()
endfunction()

macro(trace_dependency)
    set(oneValueArgs "INSTALL_SCRIPT" "NAME" "VERSION")
    set(options "USE_VSTOOLS")
    set(multiValueArgs "COMPONENTS")
    cmake_parse_arguments(PACKAGE_CONTROLLER "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if((NOT DEFINED PACKAGE_CONTROLLER_NAME) OR (NOT DEFINED PACKAGE_CONTROLLER_INSTALL_SCRIPT))
        message(FATAL_ERROR "NAME and INSTALL_SCRIPT are required arguments")
    endif()

    set(TREATED_USE_VSTOOLS FALSE)
    if((DEFINED PACKAGE_CONTROLLER_USE_VSTOOLS) AND MSVC)
        set(TREATED_USE_VSTOOLS TRUE)
    endif()

    set(VERSION_ARG)
    if(DEFINED ${PACKAGE_CONTROLLER_VERSION})
        set(VERSION_ARG VERSION)
    endif()
    
    find_package(${PACKAGE_CONTROLLER_NAME} ${VERSION_ARG} ${PACKAGE_CONTROLLER_VERSION} COMPONENTS ${PACKAGE_CONTROLLER_COMPONENTS})
    list(LENGTH PACKAGE_CONTROLLER_COMPONENTS NUMBER_OF_COMPONENTS)

    if(NUMBER_OF_COMPONENTS EQUAL 0)
        if(${PACKAGE_CONTROLLER_NAME}_FOUND)
            message(STATUS "${PACKAGE_CONTROLLER_NAME} was found")
        else()
            download_package(${PACKAGE_CONTROLLER_INSTALL_SCRIPT} ${TREATED_USE_VSTOOLS})
        endif()
    else()
        foreach(COMPONENT IN LISTS PACKAGE_CONTROLLER_COMPONENTS)
            if(NOT ${PACKAGE_CONTROLLER_NAME}${COMPONENT}_FOUND)
                download_package(${PACKAGE_CONTROLLER_INSTALL_SCRIPT} ${TREATED_USE_VSTOOLS})
            else()
                message(STATUS "${PACKAGE_CONTROLLER_NAME}${COMPONENT} was found")
            endif()
        endforeach()
    endif()
    
    find_package(${PACKAGE_CONTROLLER_NAME} ${VERSION_ARG} ${PACKAGE_CONTROLLER_VERSION} COMPONENTS ${PACKAGE_CONTROLLER_COMPONENTS} REQUIRED)

endmacro()

macro(trace_library)
    set(oneValueArgs "INSTALL_SCRIPT" "NAME")
    set(multiValueArgs "COMPONENTS")
    cmake_parse_arguments(LIBRARY_CONTROLLER "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if((NOT DEFINED LIBRARY_CONTROLLER_NAME) OR (NOT DEFINED LIBRARY_CONTROLLER_INSTALL_SCRIPT))
        message(FATAL_ERROR "NAME and INSTALL_SCRIPT are required arguments")
    endif()
    
    find_library(${LIBRARY_CONTROLLER_NAME}_FOUND NAMES ${LIBRARY_CONTROLLER_NAME})
    
    if(NOT ${LIBRARY_CONTROLLER_NAME}_FOUND)
        download_package(${LIBRARY_CONTROLLER_INSTALL_SCRIPT} FALSE)
    else()
        message(STATUS "${LIBRARY_CONTROLLER_NAME} was found")
    endif()
    
    find_library(${LIBRARY_CONTROLLER_NAME}_FOUND NAMES ${LIBRARY_CONTROLLER_NAME} REQUIRED)

endmacro()

macro(trace_file)
    set(oneValueArgs "INSTALL_SCRIPT" "LOCATION" "NAME" "EXTENSION")
    set(multiValueArgs "COMPONENTS")
    cmake_parse_arguments(FILE_CONTROLLER "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if((NOT DEFINED FILE_CONTROLLER_NAME) OR (NOT DEFINED FILE_CONTROLLER_INSTALL_SCRIPT) OR (NOT DEFINED FILE_CONTROLLER_LOCATION) OR (NOT DEFINED FILE_CONTROLLER_EXTENSION))
        message(FATAL_ERROR "NAME, INSTALL_SCRIPT, LOCATION and EXTENSION are required arguments")
    endif()

    set(CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH FALSE)
    find_file(${FILE_CONTROLLER_NAME}_FOUND NAMES "${FILE_CONTROLLER_NAME}.${FILE_CONTROLLER_EXTENSION}" PATHS ${FILE_CONTROLLER_LOCATION})
    
    if(NOT ${FILE_CONTROLLER_NAME}_FOUND)
        download_file(${FILE_CONTROLLER_INSTALL_SCRIPT})
    else()
        message(STATUS "${FILE_CONTROLLER_NAME} was found")
    endif()
    
    find_file(${FILE_CONTROLLER_NAME}_FOUND NAMES "${FILE_CONTROLLER_NAME}.${FILE_CONTROLLER_EXTENSION}" PATHS ${FILE_CONTROLLER_LOCATION} REQUIRED)
    set(CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH TRUE)

endmacro()

macro(trace_installable_file)
    set(oneValueArgs "INSTALL_SCRIPT" "LOCATION" "NAME" "EXTENSION")
    set(multiValueArgs "COMPONENTS")
    cmake_parse_arguments(FILE_CONTROLLER "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if((NOT DEFINED FILE_CONTROLLER_NAME) OR (NOT DEFINED FILE_CONTROLLER_INSTALL_SCRIPT) OR (NOT DEFINED FILE_CONTROLLER_LOCATION) OR (NOT DEFINED FILE_CONTROLLER_EXTENSION))
        message(FATAL_ERROR "NAME, INSTALL_SCRIPT, LOCATION and EXTENSION are required arguments")
    endif()

    set(CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH FALSE)
    find_file(${FILE_CONTROLLER_NAME}_FOUND NAMES "${FILE_CONTROLLER_NAME}.${FILE_CONTROLLER_EXTENSION}" PATHS ${FILE_CONTROLLER_LOCATION})
    
    if(NOT ${FILE_CONTROLLER_NAME}_FOUND)
        download_package(${FILE_CONTROLLER_INSTALL_SCRIPT} FALSE)
    else()
        message(STATUS "${FILE_CONTROLLER_NAME} was found")
    endif()
    
    find_file(${FILE_CONTROLLER_NAME}_FOUND NAMES "${FILE_CONTROLLER_NAME}.${FILE_CONTROLLER_EXTENSION}" PATHS ${FILE_CONTROLLER_LOCATION} REQUIRED)
    set(CMAKE_FIND_USE_CMAKE_ENVIRONMENT_PATH TRUE)

endmacro()

macro(download_package INSTALL_SCRIPT USE_VSTOOLS)
    validate_shell_script_extension(${INSTALL_SCRIPT})
    set_shell_program(${INSTALL_SCRIPT})
    execute_process(COMMAND bash ${PROJECT_SOURCE_DIR}/installers/sample.sh)
    if(${USE_VSTOOLS})
        execute_process(COMMAND ${SCRIPT_RUNNER} ${SCRIPT_ARG} ${INSTALL_SCRIPT} ${CMAKE_BUILD_TYPE} ${CMAKE_INSTALL_PREFIX} ${PROJECT_SOURCE_DIR} ${CMAKE_C_COMPILER})
    else()
        execute_process(COMMAND ${SCRIPT_RUNNER} ${SCRIPT_ARG} ${INSTALL_SCRIPT} ${CMAKE_BUILD_TYPE} ${CMAKE_INSTALL_PREFIX} ${PROJECT_SOURCE_DIR})
    endif()
endmacro(download_package)

macro(download_file INSTALL_SCRIPT)
    validate_shell_script_extension(${INSTALL_SCRIPT})
    set_shell_program(${INSTALL_SCRIPT})
    execute_process(COMMAND ${SCRIPT_RUNNER} ${SCRIPT_ARG} ${INSTALL_SCRIPT} ${PROJECT_SOURCE_DIR})
endmacro(download_file)
