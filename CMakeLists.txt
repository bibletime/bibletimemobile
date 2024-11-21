cmake_minimum_required(VERSION 3.24)
project(mobile VERSION 0.1 LANGUAGES CXX)
SET(CMAKE_CXX_STANDARD_REQUIRED ON)

set(VERSION_NAME 3.40)

if(CMAKE_ANDROID_ARCH_ABI STREQUAL "arm64-v8a")
    set(VERSION_CODE 3401)
elseif(CMAKE_ANDROID_ARCH_ABI STREQUAL "x86_64")
    set(VERSION_CODE 3402)
else()
    set(VERSION_CODE 3400)
endif()

message(status " CMAKE_ANDROID_ARCH_ABI: ${CMAKE_ANDROID_ARCH_ABI}")
message(status " VERSION_CODE: ${VERSION_CODE}")

set(QT_ANDROID_TARGET_SDK_VERSION  34)
set(QT_ANDROID_MIN_SDK_VERSION     28)

SET(BTM_LIBS_BASE "/home/gary/btm-libs2")

MESSAGE(STATUS "CMAKE_MODULE_PATH:  ${CMAKE_MODULE_PATH}")
LIST(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
MESSAGE(STATUS "CMAKE_MODULE_PATH:  ${CMAKE_MODULE_PATH}")
FIND_PACKAGE(QT NAMES Qt6 VERSION 6.8 COMPONENTS Core)
MESSAGE(STATUS "Found Qt ${QT_VERSION}")
FIND_PACKAGE(Qt${QT_VERSION_MAJOR} REQUIRED COMPONENTS
    Core
    Svg
    Qml
    Quick
    Xml
    Gui
    QuickControls2
    Widgets
    LinguistTools
)
SET(CMAKE_AUTOMOC ON)
SET(CMAKE_AUTOUIC ON)
SET(CMAKE_AUTORCC ON)

if(ANDROID)
    SET(BTM_LIBS_INSTALL_DIR "${BTM_LIBS_BASE}/install/${ANDROID_ABI}-Release")
#    SET(BTM_LIBS_INSTALL_DIR "${BTM_LIBS_BASE}/install/${ANDROID_ABI}-Debug")
    MESSAGE(STATUS "External libraries:  ${BTM_LIBS_INSTALL_DIR}")

    SET(BTM_INC_DIR ${BTM_LIBS_INSTALL_DIR}/include)
    SET(BTM_LIB_DIR ${BTM_LIBS_INSTALL_DIR}/lib)
    include_directories(${BTM_INC_DIR})
    link_directories(${BTM_LIB_DIR})

    set(CMAKE_PREFIX_PATH ${BTM_LIBS_INSTALL_DIR})

    # CLucene_INCLUDE_DIR  = where CLucene/StdHeader.h can be found
    # CLucene_LIBRARY_DIR  = where CLucene/clucene-config.h can be found
    # CLucene_LIBRARY      = the library to link against CLucene
    # CLucene_VERSION      = The CLucene version string
    # CLucene_FOUND        = set to 1 if clucene is found
    set(CLucene_INCLUDE_DIR    "${BTM_LIBS_INSTALL_DIR}/include")
    set(CLucene_LIBRARY_DIR    "${BTM_LIBS_INSTALL_DIR}/include")
    set(CLucene_LIBRARY        "${BTM_LIBS_INSTALL_DIR}/lib/libclucene-core.so")
    set(CLucene_SHARED_LIBRARY "${BTM_LIBS_INSTALL_DIR}/lib/libclucene-shared.so")
    MESSAGE(STATUS "CLucene_LIBRARY:         ${CLucene_LIBRARY}")
    MESSAGE(STATUS "CLucene_SHARED_LIBRARY:  ${CLucene_SHARED_LIBRARY}")

    find_package(Sword 1.9 REQUIRED)
    MESSAGE(STATUS "Sword_LIBRARIES:           ${Sword_LIBRARIES}")

else()
    find_package(CLucene REQUIRED)
    MESSAGE(STATUS "CLucene_LIBRARY:         ${CLucene_LIBRARY}")
    MESSAGE(STATUS "CLucene_SHARED_LIB:      ${CLucene_SHARED_LIB}")

    find_package(Sword 1.9 REQUIRED)
endif()

include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/BtmSources.cmake")

QT_ADD_EXECUTABLE(${PROJECT_NAME}
    ${bibletime_BACKEND_SOURCES}
    ${bibletime_UTILS}
    ${bibletime_FRONTEND_SOURCES}
)

message(status " xxx BTM_LIB_DIR ${BTM_LIB_DIR}")

set_target_properties(${PROJECT_NAME} PROPERTIES
    QT_ANDROID_EXTRA_LIBS ${BTM_LIB_DIR}/libclucene-core.so,${BTM_LIB_DIR}/libclucene-shared.so,${BTM_LIB_DIR}/libsword.so
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    QT_ANDROID_VERSION_CODE "${VERSION_CODE}"
    QT_ANDROID_VERSION_NAME "${VERSION_NAME}"
)

execute_process(
    COMMAND git rev-parse HEAD
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE BTM_GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(status " git hash btm ${BTM_GIT_COMMIT_HASH}")

execute_process(
    COMMAND git rev-parse HEAD
    WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/../bibletime"
    OUTPUT_VARIABLE BT_GIT_COMMIT_HASH
    OUTPUT_STRIP_TRAILING_WHITESPACE
)
message(status " git hash bt  ${BT_GIT_COMMIT_HASH}")

TARGET_COMPILE_DEFINITIONS(${PROJECT_NAME} PRIVATE
    cxx_std_17
    -DBTM_VERSION="${VERSION_CODE}"
    -DBTM_GIT_VERSION="${BTM_GIT_COMMIT_HASH}"
    -DBT_GIT_VERSION="${BT_GIT_COMMIT_HASH}"
)

TARGET_LINK_LIBRARIES(${PROJECT_NAME}
    PUBLIC
    Qt::Widgets
    Qt::Xml
    Qt::Qml
    Qt::Quick
    Qt::QuickControls2
    ${CLucene_LIBRARY}
    ${CLucene_SHARED_LIBRARY}
    sword
)

TARGET_INCLUDE_DIRECTORIES(${PROJECT_NAME}
    PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}/../bibletime/src
    ${CMAKE_CURRENT_SOURCE_DIR}/src
    ${BTM_INC_DIR}
    ${BTM_INC_DIR}/sword
    ${CLucene_INCLUDE_DIR}            #CLucene headers
    ${CLucene_LIBRARY_DIR}            #CLucene/clucene-config.h
    ${CLucene_SHARED_LIB}
    ${Sword_INCLUDE_DIRS}
)

