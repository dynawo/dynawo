# LibIIDM
Models IIDM networks and allows importing and exporting them to files.

## I. Installation instructions using cmake.
In the following explanations,
* `<src-path>` is the path where the sources of LibIIDM are (usually, the directory containing this document)
* `<build-path>` is the path where LibIIDM will be built
* `<install-path>` is the actual install path the library will be installed to.

Just follow these steps:
```
$> cd <build-path>
$> cmake <src-path> [<OPTIONS>...]
$> make
$> make install
```

Where options are given in the form `-D<option>=<value>`, like `-DBUILD_XML=ON`

You will probably want to use the following command as second step:
```
cmake <src-path> -DCMAKE_PREFIX_PATH=<cmake find path> -DBOOST_ROOT=<boost-path> -DCMAKE_INSTALL_PREFIX=<install-target-path> -DBUILD_XML=ON
```

An alternative to cmake is `ccmake`, which provides a visual interactive interface. BOOST_ROOT still needs to be specified on the command line.
```
ccmake <src-path>  -DBOOST_ROOT=<boost-path>
```

## II. Options available to CMake
### Variables controlling components build (ON: build, OFF: do not build)
* BUILD_XML             enable the xml support (default: OFF)
* BUILD_SAMPLES         enable the samples (only those depending on built components, not installed) (default: OFF)

### Variables controlling external libraries location:
* BOOST_ROOT            Boost library install directory
* CMAKE_PREFIX_PATH     extra paths where package searches are done. (list separated by ';'). should permit to find libXML

### Other variables:
* CMAKE_INSTALL_PREFIX  Install path prefix.
* CMAKE_BUILD_TYPE      Choose the type of build, options are: None (neither debug nor release), Debug, Release, RelWithDebInfo(both) and MinSizeRel.

## III. Partial build and installation
Once CMake was run, you may use specific make targets to build (and install) specific parts.
see `make help` for the exact list

  all                     builds everything: core, xml, extensions (with there xml support), and samples
  install                 build "all" and install everything

  iidm                    only builds core
  iidm-xml                builds core and xml

  install-core            only installs core
  install-xml             installs core and xml

  extensions              builds all extensions (and core)
  extensions-xml              builds all extensions and their xml support (as well as core and xml)

  install-extensions      installs core and every extensions
  install-extensions-xml  installs core, xml and every extensions with there xml support

For each extension <E>, there are 4 targets:

  iidm-ext-<E>
  iidm-ext-<E>-xml
  install-<E>
  install-<E>-xml

Each sample program has its own build target, but no install target.

## IV. packaging the library
`make package` creates the packages.
You may prefer `cpack -G <type>` to select which package kind. see `cpack --help`.
