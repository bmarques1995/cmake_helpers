# CMake Helpers

This is a package that helps you with some common cmake settings.

To use the helpers just add this project as a submodule with:

`git submodule add https://github.com/bmarques1995/cmake_helpers.git <dir>`

Each helper will contain one `<script>.md` explaining the usage

## Subtitle for function signatures

- `<NAME>`: expresses an one value argument
- `[NAME]`: expresses an optional argument, that is only called with the name arg, example: `function(NAME)`
- `[<NAME>]`: expresses an optional one value argument
- `NAME...`: expresses that the argument is a list
- `[NAME...]`: expresses that the argument is an optional list
- Blank argument: expresses an one value argument that is called with the pattern: `value`, without the name, if the argument signature uses one of the previous patterns, it must be called after its name.

Example:
- Blank arg call: `value`
- Signed arg call: `arg_name value`
