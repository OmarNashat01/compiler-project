add_library(operation_table STATIC operationTable.c operationTable.h)


target_include_directories(operation_table PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
