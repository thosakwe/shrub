find_package(FLEX REQUIRED)
flex_target(ShrubScanner scanner.l ${CMAKE_CURRENT_BINARY_DIR}/lexer.cpp
  DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/lexer.hpp)
flex_target(ShrubProtoScanner scanner_proto.l ${CMAKE_CURRENT_BINARY_DIR}/lexer_proto.cpp
  DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/lexer_proto.hpp)
add_library(shrub
  main.cpp
  scanner.cpp scanner.hpp
  ${FLEX_ShrubScanner_OUTPUTS}
  ${FLEX_ShrubProtoScanner_OUTPUTS}
)
target_include_directories(shrub PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${CMAKE_CURRENT_BINARY_DIR})
target_compile_options(shrub PUBLIC -Wno-deprecated-register)
