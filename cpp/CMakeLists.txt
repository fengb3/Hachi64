cmake_minimum_required(VERSION 3.14)
project(hachi64 VERSION 1.0.0 LANGUAGES CXX)

# 设置 C++ 标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# 定义头文件库
add_library(hachi64 INTERFACE)
target_include_directories(hachi64 INTERFACE
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
)

# 测试选项
option(BUILD_TESTS "Build the tests" ON)

if(BUILD_TESTS)
    enable_testing()
    
    # 下载并配置 GoogleTest
    include(FetchContent)
    FetchContent_Declare(
        googletest
        GIT_REPOSITORY https://github.com/google/googletest.git
        GIT_TAG v1.14.0
    )
    
    # For Windows: Prevent overriding the parent project's compiler/linker settings
    set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
    FetchContent_MakeAvailable(googletest)
    
    # 添加测试可执行文件
    add_executable(hachi64_test tests/test_hachi64.cpp)
    target_link_libraries(hachi64_test PRIVATE hachi64 GTest::gtest_main)
    
    # 发现并注册测试
    include(GoogleTest)
    gtest_discover_tests(hachi64_test)
endif()

# 安装支持
install(TARGETS hachi64
    EXPORT hachi64Targets
    INCLUDES DESTINATION include
)

install(DIRECTORY include/
    DESTINATION include
)

install(EXPORT hachi64Targets
    FILE hachi64Targets.cmake
    NAMESPACE hachi64::
    DESTINATION lib/cmake/hachi64
)

# 生成配置文件
include(CMakePackageConfigHelpers)
write_basic_package_version_file(
    "${CMAKE_CURRENT_BINARY_DIR}/hachi64ConfigVersion.cmake"
    VERSION ${PROJECT_VERSION}
    COMPATIBILITY AnyNewerVersion
)

configure_package_config_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/hachi64Config.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/hachi64Config.cmake"
    INSTALL_DESTINATION lib/cmake/hachi64
)

install(FILES
    "${CMAKE_CURRENT_BINARY_DIR}/hachi64Config.cmake"
    "${CMAKE_CURRENT_BINARY_DIR}/hachi64ConfigVersion.cmake"
    DESTINATION lib/cmake/hachi64
)
