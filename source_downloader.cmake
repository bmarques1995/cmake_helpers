macro(download_sources_from_git_repo)

    set(oneValueArgs "SOURCE_BASE_URL" "COMMIT_VALUE" "SOURCE_BASE_OUTPUT_DIR")
    set(multiValueArgs "SOURCE_INPUTS")
    set(options)

    cmake_parse_arguments(PACKAGE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    if((NOT DEFINED PACKAGE_SOURCE_INPUTS) OR
       (NOT DEFINED PACKAGE_SOURCE_BASE_OUTPUT_DIR) OR
       (NOT DEFINED PACKAGE_SOURCE_BASE_URL))
        message(FATAL_ERROR "SOURCE_INPUTS, SOURCE_BASE_URL and SOURCE_BASE_OUTPUT_DIR are required arguments")
    endif()

    if((NOT DEFINED PACKAGE_COMMIT_VALUE))
		set(PACKAGE_COMMIT_VALUE "refs/heads/main")
    endif()

    foreach(SOURCE_INPUT ${PACKAGE_SOURCE_INPUTS})
        
        set(OUTPUT_FILENAME "${PACKAGE_SOURCE_BASE_OUTPUT_DIR}/${SOURCE_INPUT}")
        find_file(SOURCE_FILE_FOUND PATHS ${PACKAGE_SOURCE_BASE_OUTPUT_DIR} ${SOURCE_INPUT})

        if((NOT SOURCE_FILE_FOUND))
            set(INPUT_FILENAME "${PACKAGE_SOURCE_BASE_URL}/${PACKAGE_COMMIT_VALUE}/${SOURCE_INPUT}")
		    file(DOWNLOAD ${INPUT_FILENAME} ${OUTPUT_FILENAME} SHOW_PROGRESS)
		    message(STATUS "Downloaded ${SOURCE_INPUT} to ${OUTPUT_FILE}")
        endif()
	
    endforeach()

endmacro()