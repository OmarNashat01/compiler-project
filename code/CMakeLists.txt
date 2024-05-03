cmake_minimum_required(VERSION 3.0)
project(c_compiler)

# # Set include directory (adjust as needed)
# set(CMAKE_INCLUDE_DIRS 
#         ${CMAKE_CURRENT_SOURCE_DIR}/symbol-table
# )

add_subdirectory(symbol-table)
add_subdirectory(operation-table)

# # Find any subdirectories with CMakeLists.txt files and add them
# file(GLOB subdirs src/*/)
# foreach(subdir ${subdirs})
#   if(EXISTS ${subdir}/CMakeLists.txt)
#     add_subdirectory(${subdir})
#   endif()
# endforeach()


# Define lex command (adjust as needed)
set(LEX_COMMAND flex -obuild/lexer.yy.c lexer.l)

# Define yacc command (adjust as needed)
set(YACC_COMMAND bison --yacc -d -o build/parser.c parser.y )


# Generate lexer.yy.c from lexer.l
add_custom_command(
    OUTPUT lexer.yy.c
    COMMAND ${LEX_COMMAND}
    DEPENDS lexer.l
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}  # Adjust as needed
)

# Generate parser.c from parser.y
add_custom_command(
    OUTPUT parser.c
    COMMAND ${YACC_COMMAND}
    DEPENDS parser.y
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}  # Adjust as needed
)

message("\n\n\n\n")
message("Bison command: ${YACC_COMMAND} ${CMAKE_CURRENT_SOURCE_DIR}/parser.y")


# Create the executable
add_executable(c_compiler lexer.yy.c parser.c)


# Link libraries (if applicable, list them here)
# target_link_libraries(my_executable some_library)
