add_library(operation_table SHARED operationTable.c operationTable.h)


target_include_directories(operation_table PUBLIC "${CMAKE_CURRENT_SOURCE_DIR}")
