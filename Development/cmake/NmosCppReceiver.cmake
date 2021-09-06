# nmos-cpp-receiver executable

set(NMOS_CPP_NODE_SOURCES
    nmos-cpp-receiver/main.cpp
    nmos-cpp-receiver/node_implementation.cpp
    )
set(NMOS_CPP_NODE_HEADERS
    nmos-cpp-receiver/node_implementation.h
    )

add_executable(
    nmos-cpp-receiver
    ${NMOS_CPP_NODE_SOURCES}
    ${NMOS_CPP_NODE_HEADERS}
    nmos-cpp-receiver/receiver.json
    )

source_group("Source Files" FILES ${NMOS_CPP_NODE_SOURCES})
source_group("Header Files" FILES ${NMOS_CPP_NODE_HEADERS})

target_link_libraries(
    nmos-cpp-receiver
    nmos-cpp::compile-settings
    nmos-cpp::nmos-cpp
    ${PahoMqttCpp_LIBRARIES}
    )
# root directory to find e.g. nmos-cpp-node/node_implementation.h
target_include_directories(nmos-cpp-receiver PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    )

list(APPEND NMOS_CPP_TARGETS nmos-cpp-receiver)
