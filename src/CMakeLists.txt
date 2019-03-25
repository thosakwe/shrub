find_package(FLEX REQUIRED)
flex_target(ShrubScanner scanner.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp
  DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/lexer.hpp)
add_library(shrub
  main.cpp
  scanner.cpp scanner.hpp
  ${FLEX_ShrubScanner_OUTPUTS}
)
target_include_directories(shrub PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR})
target_compile_options(shrub PUBLIC -Wno-deprecated-register)
