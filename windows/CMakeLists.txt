cmake_minimum_required(VERSION 3.21)

set(PROJECT_NAME "simpleble_flutter")
project(${PROJECT_NAME} LANGUAGES CXX)

set(PLUGIN_NAME "simpleble_flutter_plugin")

set(simpleble_DIR "${CMAKE_CURRENT_SOURCE_DIR}/lib/cmake/simpleble")
find_package(simpleble REQUIRED CONFIG)
if(NOT simpleble_FOUND)
  message(FATAL_ERROR "simpleble not found")
endif()

list(APPEND PLUGIN_SOURCES
  "simpleble_flutter_plugin.cpp"
  "simpleble_flutter_plugin.h"
  "simpleble_flutter.g.cpp"
  "simpleble_flutter.g.h"
  "simpleble_enums.h"
)

add_library(${PLUGIN_NAME} SHARED
  "include/simpleble_flutter/simpleble_flutter_plugin_c_api.h"
  "simpleble_flutter_plugin_c_api.cpp"
  ${PLUGIN_SOURCES}
)

apply_standard_settings(${PLUGIN_NAME})

set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin simpleble::simpleble)


set(simpleble_flutter_bundled_libraries
  ""
  PARENT_SCOPE
)
