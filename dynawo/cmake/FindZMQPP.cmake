# Find the ZMQPP library and include directories
# Look for the header files
find_path(ZMQPP_INCLUDE_DIR
    NAMES zmqpp/zmqpp.hpp
)

# Look for the library file
find_library(ZMQPP_LIBRARY
    NAMES zmqpp
)

# Ensure both were found
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ZMQPP
    REQUIRED_VARS ZMQPP_LIBRARY ZMQPP_INCLUDE_DIR
)

# Expose the found paths to the parent scope
if (ZMQPP_FOUND)
    message(STATUS "Found ZMQPP: ${PACKAGE_VERSION}")
    mark_as_advanced(ZMQPP_INCLUDE_DIR ZMQPP_LIBRARY)
    if (NOT TARGET ZMQPP::ZMQPP)
        add_library(ZMQPP::ZMQPP UNKNOWN IMPORTED)
        set_target_properties(ZMQPP::ZMQPP PROPERTIES
            IMPORTED_LOCATION "${ZMQPP_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${ZMQPP_INCLUDE_DIR}"
        )
    endif()
endif()
