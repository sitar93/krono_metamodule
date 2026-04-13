cmake_minimum_required(VERSION 3.22)

if(NOT "${METAMODULE_SDK_DIR}" STREQUAL "")
	message(STATUS "METAMODULE_SDK_DIR (CMake variable): ${METAMODULE_SDK_DIR}")
elseif(DEFINED ENV{METAMODULE_SDK_DIR})
	set(METAMODULE_SDK_DIR "$ENV{METAMODULE_SDK_DIR}")
	message(STATUS "METAMODULE_SDK_DIR (environment): ${METAMODULE_SDK_DIR}")
else()
	set(METAMODULE_SDK_DIR "${CMAKE_CURRENT_LIST_DIR}/metamodule-plugin-sdk")
	message(STATUS "METAMODULE_SDK_DIR (default): ${METAMODULE_SDK_DIR}")
endif()

include(${METAMODULE_SDK_DIR}/plugin.cmake)

project(
	Krono
	VERSION 2.1.0
	DESCRIPTION "Krono multi-modal rhythm generator for MetaModule"
	LANGUAGES C CXX ASM)

add_library(Krono STATIC)

# krono_vcv/metamodule: plugin.json in ..  |  krono_metamodule accanto a krono_vcv: usa ../krono_vcv
if(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../plugin.json")
	set(KRONO_ROOT "${CMAKE_CURRENT_LIST_DIR}/..")
elseif(EXISTS "${CMAKE_CURRENT_LIST_DIR}/../krono_vcv/plugin.json")
	set(KRONO_ROOT "${CMAKE_CURRENT_LIST_DIR}/../krono_vcv")
else()
	message(FATAL_ERROR "plugin.json non trovato. Attesi:\n  ${CMAKE_CURRENT_LIST_DIR}/../plugin.json oppure\n  ${CMAKE_CURRENT_LIST_DIR}/../krono_vcv/plugin.json")
endif()

target_sources(
	Krono
	PRIVATE ${KRONO_ROOT}/src/plugin.cpp ${KRONO_ROOT}/src/Krono.cpp
		${KRONO_ROOT}/src/krono_hw_engine.cpp)

target_include_directories(Krono PRIVATE ${KRONO_ROOT}/src)

create_plugin(
	SOURCE_LIB Krono
	PLUGIN_NAME Krono
	PLUGIN_JSON ${KRONO_ROOT}/plugin.json
	SOURCE_ASSETS ${CMAKE_CURRENT_LIST_DIR}/assets
	DESTINATION ${CMAKE_CURRENT_LIST_DIR}/metamodule-plugins)
