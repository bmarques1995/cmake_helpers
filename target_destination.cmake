macro(set_cxx_project_standards TARGET_NAME STANDARD_VERSION USES_C)
    set(C_VALID_VERSIONS "90" "99" "11" "17" "23")
    set(CXX_VALID_VERSIONS "98" "11" "14" "17" "20" "23" "26")
    
    if(USES_C)
        if (NOT "${STANDARD_VERSION}" IN_LIST C_VALID_VERSIONS)
            message(FATAL_ERROR "The valid C Versions are 90, 99, 11, 17 and 23")
        endif()
    else()
        if (NOT "${STANDARD_VERSION}" IN_LIST CXX_VALID_VERSIONS)
            message(FATAL_ERROR "The valid CXX Versions are 98, 11, 14, 17, 20, 23 and 26")
        endif()
    endif()

    set_target_properties(${TARGET_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_PREFIX_PATH}/bin")
    set_target_properties(${TARGET_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG "${CMAKE_PREFIX_PATH}/bin")
    set_target_properties(${TARGET_NAME} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_PREFIX_PATH}/bin")
    set_target_properties(${TARGET_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY "${CMAKE_PREFIX_PATH}/lib")
    set_target_properties(${TARGET_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_DEBUG "${CMAKE_PREFIX_PATH}/lib")
    set_target_properties(${TARGET_NAME} PROPERTIES LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_PREFIX_PATH}/lib")
    set_target_properties(${TARGET_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_PREFIX_PATH}/lib")
    set_target_properties(${TARGET_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_DEBUG "${CMAKE_PREFIX_PATH}/lib")
    set_target_properties(${TARGET_NAME} PROPERTIES ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_PREFIX_PATH}/lib")
    
    if(USES_C)
        set_target_properties(${TARGET_NAME} PROPERTIES LINKER_LANGUAGE C)
        set_target_properties(${TARGET_NAME} PROPERTIES C_STANDARD ${STANDARD_VERSION})
    else()
        set_target_properties(${TARGET_NAME} PROPERTIES LINKER_LANGUAGE CXX)
        set_target_properties(${TARGET_NAME} PROPERTIES CXX_STANDARD ${STANDARD_VERSION})
    endif()

endmacro()

macro(target_installation_behaviour)

    set(oneValueArgs "CONFIG_FILE" "TARGET_NAME" "VERSION" "PROJECT_NAME" "NAMESPACE")
    set(options "USE_SHARE")
    set(multiValueArgs "HEADER_INPUT" "HEADER_OUTPUT" "EXTRA_HEADER_EXTENSION_PATTERN")
    cmake_parse_arguments(PACKAGE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    message(STATUS "The target include directories must be set with \"\$\<BUILD_INTERFACE: \$\{include_dir\}\>\" and \"\$\<INSTALL_INTERFACE: \$\{include_dir\}\>\".\nOtherwise, the behaviour can be incorrect")
    
    if((NOT DEFINED PACKAGE_TARGET_NAME) 
        OR (NOT DEFINED PACKAGE_CONFIG_FILE)
        OR (NOT DEFINED PACKAGE_VERSION)
        OR (NOT DEFINED PACKAGE_PROJECT_NAME)
        OR (NOT DEFINED PACKAGE_NAMESPACE))
        message(FATAL_ERROR "CONFIG_FILE, TARGET_NAME, VERSION, PROJECT_NAME and NAMESPACE are required arguments")
    endif()

    set(CONFIG_BASE_DIR "lib/cmake/")
    if(PACKAGE_USE_SHARE)
        set(CONFIG_BASE_DIR "share/cmake/")
    endif()

    set(TARGET_GENERATED_DIR "${CMAKE_CURRENT_BINARY_DIR}/generated")
    set(TARGET_VERSION_CONFIG "${TARGET_GENERATED_DIR}/${PACKAGE_PROJECT_NAME}ConfigVersion.cmake")
    set(TARGET_PROJECT_CONFIG "${TARGET_GENERATED_DIR}/${PACKAGE_PROJECT_NAME}Config.cmake")
    set(TARGET_TARGETS_EXPORT_NAME "${PACKAGE_PROJECT_NAME}Targets")
    set(TARGET_CONFIG_INSTALL_DIR "${CONFIG_BASE_DIR}${PACKAGE_PROJECT_NAME}")
    set(TARGET_NAMESPACE "${PACKAGE_NAMESPACE}::")
    set(TARGET_VERSION ${PACKAGE_VERSION})

    include(CMakePackageConfigHelpers)
    write_basic_package_version_file(
        "${TARGET_VERSION_CONFIG}" VERSION ${TARGET_VERSION} COMPATIBILITY SameMajorVersion
    )
    configure_file("${PACKAGE_CONFIG_FILE}" "${TARGET_PROJECT_CONFIG}" @ONLY)

    # Install cmake config files
    install(
        FILES "${TARGET_PROJECT_CONFIG}" "${TARGET_VERSION_CONFIG}"
        DESTINATION "${TARGET_CONFIG_INSTALL_DIR}")

    install(
        EXPORT "${TARGET_TARGETS_EXPORT_NAME}"
        NAMESPACE "${TARGET_NAMESPACE}"
        DESTINATION "${TARGET_CONFIG_INSTALL_DIR}")

    install(TARGETS ${PACKAGE_TARGET_NAME}
            EXPORT ${TARGET_TARGETS_EXPORT_NAME} 
            RUNTIME DESTINATION "bin"
            ARCHIVE DESTINATION "lib"
            LIBRARY DESTINATION "lib")

    list(LENGTH PACKAGE_HEADER_INPUT IN_LENGTH)
    list(LENGTH PACKAGE_HEADER_OUTPUT OUT_LENGTH)
    if(NOT (${IN_LENGTH} EQUAL ${OUT_LENGTH}))
        message(FATAL_ERROR "Each input header folder must be associated to an output header folder")
    endif()


    foreach(INPUT_FOLDER OUTPUT_FOLDER IN ZIP_LISTS PACKAGE_HEADER_INPUT PACKAGE_HEADER_OUTPUT)
        install(DIRECTORY ${INPUT_FOLDER}
                DESTINATION ${OUTPUT_FOLDER}
                FILES_MATCHING PATTERN "*.h" PATTERN "*.hpp" PATTERN "*.hh" PATTERN "*.hxx" PATTERN "*.h++" 
                PATTERN "*.i" PATTERN "*.ipp" PATTERN "*.ii" PATTERN "*.ixx" PATTERN "*.i++" PATTERN "*.inl" PATTERN "*.inc")

        foreach(PATTERN IN LISTS PACKAGE_EXTRA_HEADER_EXTENSION)
            install(DIRECTORY ${INPUT_FOLDER}
                    DESTINATION ${OUTPUT_FOLDER}
                    FILES_MATCHING PATTERN "${PATTERN}")
        endforeach()
    endforeach()

endmacro()
