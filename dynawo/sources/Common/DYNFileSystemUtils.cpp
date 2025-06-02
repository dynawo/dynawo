//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNFileSystemUtils.cpp
 *
 * @brief  File system utility : BOOST FileSystem wrapper
 *
 */

#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNFileSystemUtils.h"

using std::string;
using std::list;
using std::vector;

namespace fs = boost::filesystem;

string searchFile(const string& pathFromDirectory, const string& rootPath, const bool searchInSubDirs) {
  fs::path root = rootPath;
  string filePathName = "";

  try {
    if (exists(root)) {
      if (exists(absolute(pathFromDirectory, root))) {
        filePathName = canonical(pathFromDirectory, root).string();
      } else {
        if (searchInSubDirs) {
          for (fs::directory_iterator it(root); it != fs::directory_iterator(); ++it) {
            if (fs::is_directory(*it)) {
              string returnString = searchFile(pathFromDirectory, it->path().string(), true);
              if (!returnString.empty()) {
                filePathName = returnString;
                break;
              }
            }
          }
        }
      }
    } else {
      throw DYNError(DYN::Error::GENERAL, FileSystemItemDoesNotExist, root);
    }
  } catch (const fs::filesystem_error& ex) {
    DYN::Trace::error() << ex.what() << DYN::Trace::endline;
    throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "filesystem", ex.what());
  }
  return filePathName;
}

static bool scanThisDirectory(const fs::path& name) {
  return (name != ".git" && name != ".svn" && name.extension() != ".dSYM");
}

void searchFilesAccordingToExtensions(const string& directoryToScan, const vector<string>& fileExtensionsAllowed,
                                      const vector<string>& fileExtensionsForbidden, const bool searchInSubDirs, vector<string>& filesFound) {
  fs::path root = directoryToScan;
  try {
    if (exists(root)) {
      for (fs::directory_iterator it(root); it != fs::directory_iterator(); ++it) {
        if (fs::is_directory(*it)) {
          const bool shouldScanThisDirectory = searchInSubDirs && scanThisDirectory(it->path().filename());
          if (shouldScanThisDirectory) {
            searchFilesAccordingToExtensions(it->path().string(), fileExtensionsAllowed, fileExtensionsForbidden, searchInSubDirs, filesFound);
          }
        } else {
          // a path is added if the extension is not within forbidden extensions and the extension is within allowed extensions
          const bool fileToKeep = (!extensionFound(it->path().string(), fileExtensionsForbidden)) && extensionFound(it->path().string(), fileExtensionsAllowed);
          if (fileToKeep) {
            filesFound.push_back(absolute(it->path().string()));
          }
        }
      }
    } else {
      throw DYNError(DYN::Error::GENERAL, FileSystemItemDoesNotExist, root);
    }
  } catch (const fs::filesystem_error& ex) {
    DYN::Trace::error() << ex.what() << DYN::Trace::endline;
    throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "filesystem", ex.what());
  }
}

void searchFilesAccordingToExtension(const string& directoryToScan, const string& fileExtensionAllowed,
                                     const vector<string>& fileExtensionsForbidden, const bool searchInSubDirs, vector<string>& filesFound) {
  vector<string> fileExtensionsAllowed;
  fileExtensionsAllowed.push_back(fileExtensionAllowed);

  searchFilesAccordingToExtensions(directoryToScan, fileExtensionsAllowed, fileExtensionsForbidden, searchInSubDirs, filesFound);
}

void searchModelsFiles(const std::string& directoryToScan, const std::string& fileExtension, const vector<string>& fileExtensionsForbidden,
                       const std::unordered_set<fs::path, PathHash>& pathsToIgnore, const bool searchInSubDirs,
                       const bool packageForcesSubDirsSearch, const bool stopWhenSeePackage,
                       std::map<std::string, std::string>& filesFound) {
  // initialise recursion variables
  constexpr bool isPackage = false;
  std::vector<std::string> namespaces;

  // then run recursive function
  searchModelsFilesRec(directoryToScan, fileExtension, fileExtensionsForbidden, pathsToIgnore, searchInSubDirs, isPackage,
                       packageForcesSubDirsSearch, stopWhenSeePackage, namespaces, filesFound);
}

static std::string getFullModelName(const std::string& fileName, const std::vector <std::string>& namespacesLocal,
    const std::string& fileExtension, const std::string& packageFileName) {
  std::string fullModelName("");
  for (const auto& namespaceLocal : namespacesLocal)
    fullModelName += namespaceLocal + ".";

  if (fileName == packageFileName) {
    fullModelName = fullModelName.substr(0, fullModelName.size() - 1);
  } else {
    fullModelName += fileName.substr(0, fileName.size() - fileExtension.size());
  }
  return fullModelName;
}

void searchModelsFilesRec(const std::string& directoryToScan, const std::string& fileExtension, const vector <std::string>& fileExtensionsForbidden,
                          const std::unordered_set<fs::path, PathHash>& pathsToIgnore, const bool searchInSubDirs,
                          const bool /*isPackage*/, const bool packageForcesSubDirsSearch, const bool stopWhenSeePackage,
                          const std::vector<std::string>& namespaces, std::map<std::string, std::string>& filesFound) {
  const fs::path root = directoryToScan;
  static std::string packageFileName = "package.mo";
  const bool isPackageLocal = exists(absolute(packageFileName, root));
  const bool doScan = !(isPackageLocal && stopWhenSeePackage);
  const bool searchInSubDirsLocal = doScan && (searchInSubDirs || (isPackageLocal && packageForcesSubDirsSearch));

  std::vector<std::string> namespacesLocal(namespaces);
  if (isPackageLocal) {
    namespacesLocal.push_back(lastParentDirectory(directoryToScan));
  }

  try {
    if (!exists(root)) return;
    for (fs::directory_iterator it(root); it != fs::directory_iterator(); ++it) {
      // folders scanning
      if (fs::is_directory(*it)) {
        bool ignoredPath = false;
        for (const auto& pathToIgnore : pathsToIgnore) {
          if (boost::filesystem::equivalent(it->path(), pathToIgnore)) {
            ignoredPath = true;
            break;
          }
        }
        if (searchInSubDirsLocal && !ignoredPath) {
          searchModelsFilesRec(it->path().string(), fileExtension, fileExtensionsForbidden, pathsToIgnore,  searchInSubDirsLocal, isPackageLocal,
              packageForcesSubDirsSearch, stopWhenSeePackage, namespacesLocal, filesFound);
        }
      } else if (doScan || (fileNameFromPath(it->path().string()) == packageFileName)) {  // files scanning :
                                                                                          // usually scan everything. When not, only scan package
        // a path is added if the extension is not within forbidden extensions and the extension is within allowed extensions
        const bool fileToKeep = (!extensionFound(it->path().string(), fileExtensionsForbidden))
                                && extensionEquals(it->path().string(), fileExtension);

        if (fileToKeep) {
          const std::string& filePath = it->path().string();
          const std::string& fileNameStr = fileNameFromPath(filePath);

          std::string full_model_name = getFullModelName(fileNameStr, namespacesLocal, fileExtension, packageFileName);

          if (filesFound.find(full_model_name) != filesFound.end()) {
            throw DYNError(DYN::Error::MODELER, DuplicateModelicaModel, full_model_name);
          }
          filesFound[full_model_name] = absolute(filePath);
        }
      }
    }
  } catch (const fs::filesystem_error& ex) {
    DYN::Trace::error() << ex.what() << DYN::Trace::endline;
    throw DYNError(DYN::Error::GENERAL, SystemCallFailed, "filesystem", ex.what());
  }
}

void searchModelicaModels(const std::string& directoryToScan, const std::string& fileExtension, const bool searchInSubDirs,
                          std::vector<std::string>& filesFound) {  // search for Modelica models in a given directory
  fs::path root = directoryToScan;
  if (exists(root)) {
    static std::string packageFileName = "package.mo";
    std::string packagePath;
    bool packageFoundInRoot = false;
    if (exists(absolute(packageFileName, root))) {
      packageFoundInRoot = true;
      packagePath = absolute(packageFileName, directoryToScan);
    }
    if (packageFoundInRoot) {
      filesFound.push_back(packagePath);
    } else {
       // search for model files, only in the current directory
      const std::vector<std::string> noFileExtensionsForbidden;
      searchFilesAccordingToExtension(directoryToScan, fileExtension, noFileExtensionsForbidden, false, filesFound);

       // scan current subdirectories to look for Modelica models
      if (searchInSubDirs) {
        vector <string> forbiddenDirectories;
        for (fs::directory_iterator it(root); it != fs::directory_iterator(); ++it) {
          if (fs::is_directory(*it) && scanThisDirectory(it->path().filename())) {
            searchModelicaModels(it->path().string(), fileExtension, searchInSubDirs, filesFound);
          }
        }
      }
    }
  } else {
    throw DYNError(DYN::Error::GENERAL, FileSystemItemDoesNotExist, root);
  }
}

string canonical(const string& childPath, const string& rootPath) {
  const fs::path root(rootPath);
  const fs::path dir(childPath);
  const fs::path canonicalPath = fs::canonical(dir, root);
  return canonicalPath.string();
}

string absolute(const string& name, const string& rootName) {
  const fs::path root(rootName);
  const fs::path dir(name);
  const fs::path absolutePath = fs::absolute(dir, root);
  return absolutePath.string();
}

string
createAbsolutePath(const string& name, const string& rootName) {
  if (name.empty())
    return std::string("");

  std::string absoluteName = name;
  if (!isAbsolutePath(name))
    absoluteName = absolute(name, rootName);

  return fs::absolute(absoluteName).string();
}

bool exists(const string & path) {
  const fs::path fspath(path);
  return fs::exists(fspath);
}

bool remove(const string & path) {
  const fs::path fspath(path);
  return fs::remove(fspath);
}


void copy(const std::string& oldPath, const std::string& newPath) {
  const fs::path from(oldPath);
  const fs::path to(newPath);
  return fs::copy(from, to);
}

string currentPath() {
  return fs::current_path().string();
}

void currentPath(const std::string& path) {
  const fs::path fspath(path);
  fs::current_path(fspath);
}

string replaceExtension(const std::string& path, const std::string& ext) {
  fs::path fspath(path);
  return fspath.replace_extension("." + ext).string();
}

bool isDirectory(const string& path) {
  const fs::path fspath(path);
  return fs::is_directory(fspath);
}

void createDirectory(const string& inputPath) {
  string path = inputPath;
#if BOOST_VERSION < 106000
  // Needed to avoid a bug in boost (v < 1.6)
  if (path.at(path.size() - 1) == fs::path::preferred_separator) {
    path = path.substr(0, path.size() - 1);
  }
#endif
  const fs::path fspath(path);
  if (!fs::create_directories(fspath)) {
    throw DYNError(DYN::Error::GENERAL, CreateDirectoryFailed, path);
  }
}

string extension(const string& path) {
  const fs::path fspath(path);
  return fs::extension(fspath);
}

bool extensionFound(const string& directoryToScan, const vector <string>& extensionList) {
  return (std::find_if(extensionList.begin(), extensionList.end(), [&directoryToScan] (const string& s) {
    return extensionEquals(directoryToScan, s);
  }) != extensionList.end());
}

bool extensionEquals(const string& path, const string& extension) {
  const std::size_t extLength = extension.size();
  const string fileName = fileNameFromPath(path);

  if (extLength <= fileName.size()) {
    const string fileNameEnd = fileName.substr(fileName.size() - extLength);
    return fileNameEnd == extension;  // would be better if lower case comparison was performed
  } else {
    return false;
  }
}

list<string>
listDirectory(const string& path) {
  list<string> returnList;
  const fs::path fspath(path);
  for (fs::directory_iterator it(fspath); it != fs::directory_iterator(); ++it) {
    returnList.push_back(it->path().string());
  }
  return returnList;
}

string fileNameFromPath(const string& path) {
  const fs::path fspath(path);
  return fspath.filename().string();
}

string removeFileName(const string& path) {
  fs::path fspath(path);
  return fspath.remove_filename().string();
}

std::string parentDirectory(const std::string& childPath) {
  return fs::path(childPath).parent_path().string();
}

std::string lastParentDirectory(const std::string& childPath) {
  std::string parent1;

  if (fs::is_directory(childPath)) {
    parent1 = childPath;
  } else {
    parent1 = parentDirectory(childPath);
  }

  const std::string parent2 = parentDirectory(parent1);

  return parent1.substr(parent2.size() + 1);
}

bool isAbsolutePath(const string& path) {
  const fs::path fspath(path);
  return fspath.is_absolute();
}

void
removeAllInDirectory(const std::string& directory) {
  const fs::path fspath(directory);
  fs::remove_all(fspath);  // delete all contents and path itself
  createDirectory(directory);  // create the new directory
}
