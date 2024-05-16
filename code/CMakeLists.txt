cmake_minimum_required(VERSION 3.0)
project(c_compiler)

message(STATUS "CMAKE_SOURCE_DIR: ${CMAKE_SOURCE_DIR}")

add_subdirectory(${PROJECT_SOURCE_DIR}/symbol-table)
add_subdirectory(${PROJECT_SOURCE_DIR}/operation-table)


# Define lex command (adjust as needed)
set(LEX_COMMAND flex -o${PROJECT_SOURCE_DIR}/lexer.yy.c lexer.l)

# Define yacc command (adjust as needed)
set(YACC_COMMAND bison --yacc -d -o ${PROJECT_SOURCE_DIR}/parser.c parser.y)


# # Generate lexer.yy.c from lexer.l
add_custom_command(
    OUTPUT ${PROJECT_SOURCE_DIR}/lexer.yy.c
    COMMAND ${LEX_COMMAND}
    DEPENDS lexer.l
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}  # Adjust as needed
)

# Generate parser.c from parser.y
add_custom_command(
    OUTPUT ${PROJECT_SOURCE_DIR}/parser.c
    COMMAND ${YACC_COMMAND}
    DEPENDS parser.y
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}  # Adjust as needed
)

add_custom_target(lexer DEPENDS ${PROJECT_SOURCE_DIR}/lexer.yy.c)
add_custom_target(parser DEPENDS ${PROJECT_SOURCE_DIR}/parser.c)

find_library(symbol_table_path NAMES symbol_table PATHS ${CMAKE_LIBRARY_PATH} ${PROJECT_SOURCE_DIR}/build/symbol-table)  # Adjust paths as needed
find_library(operation_table_path NAMES operation_table PATHS ${CMAKE_LIBRARY_PATH} ${PROJECT_SOURCE_DIR}/build/operation-table)  # Adjust paths as needed

set_source_files_properties(${PROJECT_SOURCE_DIR}/lexer.yy.c ${PROJECT_SOURCE_DIR}/parser.c PROPERTIES LANGUAGE CXX)
# Create the executable
add_executable(c_compiler ${PROJECT_SOURCE_DIR}/lexer.yy.c ${PROJECT_SOURCE_DIR}/parser.c )

# Link libraries (if applicable, list them here)
target_link_libraries(c_compiler ${symbol_table_path} ${operation_table_path})

# delete libraries and exe before building
add_custom_command(TARGET c_compiler PRE_BUILD
    COMMAND ${CMAKE_COMMAND} -E remove ${PROJECT_BINARY_DIR}/liboperation_table.dll ${PROJECT_BINARY_DIR}/libsymbol_table.dll ${PROJECT_BINARY_DIR}/c_compiler.exe
)

# Copy the generated libraries to the build directory
add_custom_command(TARGET c_compiler POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_BINARY_DIR}/operation-table/liboperation_table.dll ${PROJECT_BINARY_DIR}/liboperation_table.dll
    COMMAND ${CMAKE_COMMAND} -E copy ${PROJECT_BINARY_DIR}/symbol-table/libsymbol_table.dll ${PROJECT_BINARY_DIR}/libsymbol_table.dll
    DEPENDS ${symbol_table_path} ${operation_table_path}
)


# Delete generated files
add_custom_command(TARGET c_compiler POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E remove ${PROJECT_SOURCE_DIR}/lexer.yy.c ${PROJECT_SOURCE_DIR}/parser.c ${PROJECT_SOURCE_DIR}/parser.h
)
