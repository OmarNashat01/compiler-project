add_library(symbol_table STATIC symbolTable.c symbolTable.h)


target_include_directories(symbol_table PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
