# How-to build libZIP

## Pre-requisites
The LibZIP library depends on:
- [zlib](http://www.zlib.net/)
- [boost](http://www.boost.org) (1.39 or higher)
- [LibArchive](http://libarchive.org) (2.8 or higher)
- [Google Tests](https://github.com/google/googletest) (optional)

### ZLib
For Windows, download the pre-compiled package from [internet](http://www.zlib.net/).

For linux, install the zlib-devel package:
```
$> sudo yum install zlib-devel
```

### Boost

For Windows:
```
TODO
```

For Linux:
```
$> cd <boost-dir>
$> ./bootstrap.sh --prefix=<boost-install-prefix>
$> ./b2 install
```

### LibArchive
Download the sources from [internet](http://libarchive.org/downloads/) and compile with cmake.

For Windows:
```
$> cd <libarchive-dir>
$> mkdir build
$> cd build
$> cmake -DCMAKE_INSTALL_PREFIX:PATH=<libarchive-install-prefix> -DZLIB_ROOT=<zlib-install-prefix> -G "NMake Makefiles" ..
$> nmake
$> nmake install
```

For Linux:
```
$> cd <libarchive-dir>
$> mkdir build
$> cd build
$> cmake -DCMAKE_INSTALL_PREFIX:PATH=<libarchive-install-prefix> -DZLIB_ROOT=<zlib-install-prefix> ..
$> make
$> make install
```

### Google Tests

For Windows:
```
$> cd <gtest-dir>
$> mkdir build
$> cd build
$> cmake -DCMAKE_INSTALL_PREFIX=<gtest-install-prefix> -G "NMake Makefiles" ..
$> nmake install
```

For Linux:
```
$> cd <gtest-dir>
$> mkdir build
$> cmake -DCMAKE_INSTALL_PREFIX=<gtest-install-prefix> ..
$> make install
```

## Build LibZIP

### Build configuration

| Options | Default | Description |
| ------- | ------- | ----------- |
| LIBZIP_BUILD_TESTS | ON | Build LibZIP tests |
| LIBZIP_BUILD_SAMPLES | ON | Build LibZIP samples |

You can also override the CMAKE common variables:
- CMAKE_BUILD_TYPE
- BIN_INSTALL_DIR, INCLUDE_INSTALL_DIR, LIB_INSTALL_DIR

### Compilation
For Windows:
```
$> cd <libzip-dir>
$> mkdir build
$> cd build
$> cmake -DCMAKE_INSTALL_PREFIX:PATH=<libzip-install-prefix> -DLIBARCHIVE_HOME:PATH=<libarchive-install-prefix> -DBOOST_ROOT:PATH=<boost-install-prefix> -DGTEST_ROOT:PATH=<gtest-install-prefix> -G "NMake Makefiles" ..
$> nmake
$> nmake install
```

For Linux
```
$> cd <libzip-dir>
$> mkdir build
$> cd build
$> cmake -DCMAKE_INSTALL_PREFIX:PATH=<libzip-install-prefix> -DLIBARCHIVE_HOME:PATH=<libarchive-install-prefix> -DBOOST_ROOT:PATH=<boost-install-prefix> -DGTEST_ROOT:PATH=<gtest-install-prefix> ..
$> make
$> make install
```
