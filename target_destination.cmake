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
        set_target_properties(${TARGET_NAME} PROPERTIES C_STANDARD ${STANDARD_VERSION})
    else()
        set_target_properties(${TARGET_NAME} PROPERTIES CXX_STANDARD ${STANDARD_VERSION})
    endif()

endmacro()