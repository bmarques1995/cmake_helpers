macro(download_sources_from_git_repo)

    set(oneValueArgs "SOURCE_BASE_URL" "COMMIT_VALUE" "SOURCE_BASE_OUTPUT_DIR")
    set(multiValueArgs "SOURCE_INPUTS")
    set(options "FORCE_DOWNLOAD")

    cmake_parse_arguments(PACKAGE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if((NOT DEFINED PACKAGE_SOURCE_INPUTS) OR
       (NOT DEFINED PACKAGE_SOURCE_BASE_OUTPUT_DIR) OR
       (NOT DEFINED PACKAGE_SOURCE_BASE_URL))
        message(FATAL_ERROR "SOURCE_INPUTS, SOURCE_BASE_URL and SOURCE_BASE_OUTPUT_DIR are required arguments")
    endif()

    if((NOT DEFINED PACKAGE_COMMIT_VALUE))
		set(PACKAGE_COMMIT_VALUE "refs/heads/main")
    endif()

    if((NOT DEFINED PACKAGE_FORCE_DOWNLOAD))
		set(PACKAGE_FORCE_DOWNLOAD OFF)
    endif()

    foreach(SOURCE_INPUT ${PACKAGE_SOURCE_INPUTS})
        
		set(OUTPUT_FILENAME "${PACKAGE_SOURCE_BASE_OUTPUT_DIR}/${SOURCE_INPUT}")
        
        get_filename_component(FILE_NAME "${SOURCE_INPUT}" NAME)   # "my_header.h"
        get_filename_component(FILE_DIR  "${SOURCE_INPUT}" DIRECTORY)  # "include"
        if(${FILE_DIR})
            find_file(SOURCE_FILE_FOUND ${FILE_NAME} PATHS ${PACKAGE_SOURCE_BASE_OUTPUT_DIR}/${FILE_DIR} NO_DEFAULT_PATH)
        else()
            find_file(SOURCE_FILE_FOUND ${FILE_NAME} PATHS ${PACKAGE_SOURCE_BASE_OUTPUT_DIR} NO_DEFAULT_PATH)
        endif()

        if((NOT SOURCE_FILE_FOUND) OR PACKAGE_FORCE_DOWNLOAD)
            set(INPUT_FILENAME "${PACKAGE_SOURCE_BASE_URL}/${PACKAGE_COMMIT_VALUE}/${SOURCE_INPUT}")
		    file(DOWNLOAD ${INPUT_FILENAME} ${OUTPUT_FILENAME} SHOW_PROGRESS)
            message(STATUS "Downloaded ${SOURCE_INPUT} to ${OUTPUT_FILE}")
        endif()
	
        unset(SOURCE_FILE_FOUND CACHE)
    endforeach()

endmacro()

macro(download_remote_files)
    set(oneValueArgs "SOURCE_BASE_OUTPUT_DIR")
    set(multiValueArgs "SOURCE_INPUTS")
    set(options "FORCE_DOWNLOAD")

    cmake_parse_arguments(PACKAGE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if((NOT DEFINED PACKAGE_SOURCE_INPUTS) OR
       (NOT DEFINED PACKAGE_SOURCE_BASE_OUTPUT_DIR))
        message(FATAL_ERROR "SOURCE_INPUTS, SOURCE_BASE_OUTPUT_DIR are required arguments")
    endif()

    if((NOT DEFINED PACKAGE_FORCE_DOWNLOAD))
		set(PACKAGE_FORCE_DOWNLOAD OFF)
    endif()

    foreach(SOURCE_INPUT ${PACKAGE_SOURCE_INPUTS})
        
        get_filename_component(FILE_NAME "${SOURCE_INPUT}" NAME)
        get_filename_component(FILE_DIR  "${SOURCE_INPUT}" DIRECTORY)
        set(OUTPUT_FILENAME "${PACKAGE_SOURCE_BASE_OUTPUT_DIR}/${FILE_NAME}")
        find_file(BINARY_FILE_FOUND ${FILE_NAME} PATHS ${PACKAGE_SOURCE_BASE_OUTPUT_DIR} NO_DEFAULT_PATH)

        if((NOT BINARY_FILE_FOUND) OR PACKAGE_FORCE_DOWNLOAD)
		    file(DOWNLOAD ${SOURCE_INPUT} ${OUTPUT_FILENAME} SHOW_PROGRESS)
		    message(STATUS "Downloaded ${SOURCE_INPUT} to ${OUTPUT_FILENAME}")
        endif()
	
    endforeach()

endmacro()