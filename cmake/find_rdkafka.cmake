option (ENABLE_RDKAFKA "Enable kafka" ON)

if (ENABLE_RDKAFKA)

option (USE_INTERNAL_RDKAFKA_LIBRARY "Set to FALSE to use system librdkafka instead of the bundled" ${NOT_UNBUNDLED})

if (USE_INTERNAL_RDKAFKA_LIBRARY AND NOT EXISTS "${ClickHouse_SOURCE_DIR}/contrib/librdkafka/CMakeLists.txt")
   message (WARNING "submodule contrib/librdkafka is missing. to fix try run: \n git submodule update --init --recursive")
   set (USE_INTERNAL_RDKAFKA_LIBRARY 0)
   set (MISSING_INTERNAL_RDKAFKA_LIBRARY 1)
endif ()

if (NOT USE_INTERNAL_RDKAFKA_LIBRARY)
    find_library (RDKAFKA_LIBRARY rdkafka)
    find_path (RDKAFKA_INCLUDE_DIR NAMES librdkafka/rdkafka.h PATHS ${RDKAFKA_INCLUDE_PATHS})
endif ()

if (RDKAFKA_LIBRARY AND RDKAFKA_INCLUDE_DIR)
    set (USE_RDKAFKA 1)
elseif (NOT MISSING_INTERNAL_RDKAFKA_LIBRARY)
    set (USE_INTERNAL_RDKAFKA_LIBRARY 1)
    set (RDKAFKA_INCLUDE_DIR "${ClickHouse_SOURCE_DIR}/contrib/librdkafka/src")
    set (RDKAFKA_LIBRARY rdkafka)
    set (USE_RDKAFKA 1)
endif ()

endif ()

message (STATUS "Using librdkafka=${USE_RDKAFKA}: ${RDKAFKA_INCLUDE_DIR} : ${RDKAFKA_LIBRARY}")
