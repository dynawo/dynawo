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
    set(ZMQPP_LIBRARIES ${ZMQPP_LIBRARY})
    set(ZMQPP_INCLUDE_DIRS ${ZMQPP_INCLUDE_DIR})

    mark_as_advanced(ZMQPP_INCLUDE_DIR ZMQPP_LIBRARY)
endif()
