# bash-object - 2.1.0
Using [bash-unique](https://github.com/MACAYCZ/bash-unique). ***Before use*** make sure that you have all libraries in same folder (also you can change source).

# object.sh
Allows you to create multiple level array and access its elements.
## Functions
```
# Create variable on path (multiple levels of path will generate if doesnt exist already)
# Arguments: root (pre-declared), path (String), output (Variable name), type (-A, -a, -i, --, ...)
object_set

# Echo variable on path
# Arguments: root (Object (pre-declared with unique_new)), path (String)
object_get

# Deletes object recursively
# Arguments: root (Object)
object_del
```

## Global variables
```
# Delimiter for path (Object)
OBJECT_PATH_DELIMITER_STRING=":"

# Delimiter for path (Array)
OBJECT_PATH_DELIMITER_NUMBER=";"
```

# object_io.sh
Allows you to parse & print JSON (Object, Array, String, Int).
## Functions
```
# Parse String to JSON as object
# Arguments: output (Variable name), text (String)
object_parse_json

# Print Object as JSON
# Arguments: root (Object), _tabs (0)
object_print_json
```
