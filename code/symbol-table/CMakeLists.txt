add_library(symbol_table SHARED symbolTable.c symbolTable.h)


# target_include_directories(symbol_table PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
# install(TARGETS symbol_table DESTINATION ${CMAKE_SOURCE_DIR}/build)