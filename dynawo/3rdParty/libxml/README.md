# Build libXML in a Linux environment

Recommanded commands:
```
$> mkdir <build-prefix>
$> cd <build-prefix>
$> ccmake <libXML-src-path> -DBOOST_ROOT:PATH=<boost-root> -DXERCESC_HOME:PATH=<xerces-root> -DGTEST_ROOT:PATH=<gtest-root>
```
Configure the various option, especially *CMAKE_BUILD_TYPE* and *CMAKE_INSTALL_PREFIX*
```
$> make
$> make install
```

# Build XML Formatter only

By default, only XML Formatter is installed. Its only dependency is Boost, v1.59 minimum

```
$> mkdir <build-prefix>
$> cd <build-prefix>
$> cmake <libXML-src-path> -DBOOST_ROOT:PATH=<boost-root> -DCMAKE_INSTALL_PREFIX=<install path>
$> make
$> make install
```

# Build XML Formatter and XML Parser

XML parser uses Xerces-C++ library.

```
$> cd <build-prefix>
$> cmake -DBUILD_PARSER=ON <libXML-src-path> -DCMAKE_INSTALL_PREFIX=<install path> -DBOOST_ROOT:PATH=<boost-root> -DXERCESC_HOME:PATH=<xerces-root>
$> make
$> make install
```


# CMake variables associated

- At least one of the following property must be TRUE:
    - **LibXML_SAX_BUILD_SHARED**     (*TRUE*: build / *FALSE*: do not build) XML shared library
    - **LibXML_SAX_BUILD_STATIC**     (*TRUE*: build / *FALSE*: do not build) XML static library

- Variables controlling components build
    - **LibXML_SAX_BUILD_FORMATTER**  (*ON*: build / *OFF*: do not build) XML SAX formatter
    - **LibXML_SAX_BUILD_PARSER**     (*ON*: build / *OFF*: do not build) XML SAX parser
    - **LibXML_SAX_BUILD_SAMPLES**    (*ON*: build / *OFF*: do not build) XML SAX examples
    - **LibXML_BUILD_TESTS**          (*ON*: build / *OFF*: do not build) XML tests

- Variables controlling external libraries location:
    - **BOOST_ROOT**                  Boost library install directory, gives its value to *<boost-install-prefix>*
    - **XERCESC_HOME**                Xerces-C++ library install directory, gives its value to *<xercesc-install-prefix>*
    - **GTEST_ROOT**                  path to a Google Test installation directory

- Other variables:
    - **CXX11_ENABLED**               Enable to use CXX11 compilation
    - **CMAKE_BUILD_TYPE**            CMake build type : *Release* or *Debug* or *RelWithDebInfo*
    - **CMAKE_INSTALL_PREFIX**        Install directory for libXML
    - **CPACK_GENERATOR**             Defines how the library are packed.
