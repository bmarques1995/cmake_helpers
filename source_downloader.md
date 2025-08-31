# source_downloader

`download_sources_from_git_repo(<SOURCE_BASE_URL> <SOURCE_BASE_OUTPUT_DIR> SOURCE_INPUTS... [<COMMIT_VALUE>] [FORCE_DOWNLOAD])`:
this function is used to search for a package, if it is found the macro is aborted, but if it was not found, the macro will call an install script to clone the dependency and install it.

Args:
- SOURCE_BASE_URL:  Referred to the base url, that will compose the file location.
- SOURCE_BASE_OUTPUT_DIR: Referred to the output directory location.
- SOURCE_INPUTS: Referred to the list of files to be downloaded, they will be saved in the SOURCE_BASE_OUTPUT_DIR, being possible to add subdirectories. Ex: `imgui/imgui.h` is valid.
- COMMIT_VALUE: Optional, referred to the Commit to point, if not set, points to the head/main of the of GITHUB, is HIGHLY ADVISABLE to set this variable. If you want to point to the head of a branch, set it as `refs/heads/<branch_name>` 
- FORCE_DOWNLOAD: Optional, used to force the download, even if the file is found

`download_remote_files(<SOURCE_BASE_OUTPUT_DIR> SOURCE_INPUTS... [FORCE_DOWNLOAD])`:
this function is used to search for a package, if it is found the macro is aborted, but if it was not found, the macro will call an install script to clone the dependency and install it.

Args:
- SOURCE_BASE_OUTPUT_DIR: Referred to the output directory location.
- SOURCE_INPUTS: Referred to the list of files to be downloaded, now with FULL URL, they will be saved in the SOURCE_BASE_OUTPUT_DIR.
- FORCE_DOWNLOAD: Optional, used to force the download, even if the file is found

## Tips for source base url:

Here are some patterns to set the value SOURCE_BASE_URL:

- Github: `https://raw.githubusercontent.com/<owner>/<repo>`
- Gitlab: `https://gitlab.com/<owner>/<repo>/-/raw`

## Tips for commits:

Here are some patterns to set the value COMMIT_VALUE:

- Github head branch: `refs/heads/<branch_name>`
- Github in a commit: `<full_commit_value>`
- Gitlab head branch: `<branch_name>`
- Gitlab in a commit: `<full_commit_value>`
