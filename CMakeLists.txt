cmake_minimum_required(VERSION 3.10)
project(minimal_ci_cd)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_BUILD_TYPE Release)

add_executable(myapp src/main.cpp)
add_executable(mytest test/test.cpp)
enable_testing()
add_test(NAME basic_test COMMAND mytest)
