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
 * @file  DYNFileSystemUtils.h
 *
 * @brief File system utility : BOOST FileSystem wrapper
 *
 */
#ifndef COMMON_DYNFILESYSTEMUTILS_H_
#define COMMON_DYNFILESYSTEMUTILS_H_

#include <string>
#include <list>
#include <map>
#include <vector>
#include <unordered_set>
#include <boost/filesystem.hpp>

/**
 * @brief Hash structure for boost::filesystem::path
 */
struct PathHash {
  /**
   * @brief Operator to retrieve boost::filesystem::path hash value
   *
   * @param path the path to hash
   * @returns the hash value
   */
  size_t operator()(const boost::filesystem::path& path) const {
    return std::hash<std::string>()(path.generic_string());
  }
};

/**
 * @struct UserDefinedDirectory
 * @brief Structure containing a directory and a boolean indicating whether to recursively scan sub-directories of this directory or not
 *
 * Used for precompiled models and modelica models directories
 *
 */
struct UserDefinedDirectory {
  std::string path;  ///< Path to the directory
  bool isRecursive;  ///< Whether to recursively scan sub-directories of the directory
};

/**
 * @brief Search for a file within a directory
 *
 * @param[in] name : the path to the file relative to the root name (or one of the root subdirectories)
 * @param[in] rootDir : the path to the root directory from which to start looking
 * @param[in] searchInSubDirs : whether to search in subdirectories, or to only search in the root directory
 *
 * @return the file path ("" when the file was not found)
 * throw an exception when the rootPath does not exist
 */
std::string searchFile(const std::string & name, const std::string & rootDir, const bool searchInSubDirs);

/**
 * @brief Search for a files which have a given file extension within a directory
 *
 * @param[in] directoryToScan : the directory to scan
 * @param[in] fileExtensionsAllowed : a list of allowed file extensions
 * @param[in] fileExtensionsForbidden : a list of forbidden file extensions
 * @param[in] searchInSubDirs : whether to search in subdirectories, or to only search in the root directory
 * @param[out] filesFound : the list of relevant absolute files paths found
 *
 * throw an exception when the rootPath does not exist
 */
void searchFilesAccordingToExtensions(const std::string & directoryToScan, const std::vector <std::string> & fileExtensionsAllowed,
                                      const std::vector <std::string> & fileExtensionsForbidden, const bool searchInSubDirs,
                                      std::vector <std::string> & filesFound);

/**
 * @brief Search for a files which have a given file extension within a directory
 *
 * @param[in] directoryToScan : the directory to scan
 * @param[in] fileExtensionAllowed : the allowed file extension
 * @param[in] fileExtensionsForbidden : the forbidden file extensions
 * @param[in] searchInSubDirs : whether to search in subdirectories, or to only search in the root directory
 * @param[out] filesFound : the list of relevant files found
 *
 * throw an exception when the rootPath does not exist
 */
void searchFilesAccordingToExtension(const std::string & directoryToScan, const std::string fileExtensionAllowed,
                                     const std::vector <std::string> & fileExtensionsForbidden, const bool searchInSubDirs,
                                     std::vector <std::string> & filesFound);

/**
 * @brief Search for models within a directory
 *
 * @param[in] directoryToScan : the directory to scan
 * @param[in] fileExtension : the allowed file extension
 * @param[in] fileExtensionsForbidden : the forbidden file extension
 * @param[in] pathsToIgnore : paths that shouldn't be explored
 * @param[in] searchInSubDirs : whether to search in subdirectories, or to only search in the root directory
 * @param[in] packageForcesSubDirsSearch : true if for a package we have to look for models in subdirectories
 * @param[in] stopWhenSeePackage : true if for a package we don't want to look for models in subdirectories
 * @param[out] filesFound : map containing the model name and the file path
 *
 * call searchModelsFilesRec
 */
void searchModelsFiles(const std::string & directoryToScan, const std::string& fileExtension, const std::vector<std::string>& fileExtensionsForbidden,
                       const std::unordered_set<boost::filesystem::path, PathHash>& pathsToIgnore, const bool searchInSubDirs,
                       const bool packageForcesSubDirsSearch, const bool stopWhenSeePackage,
                       std::map<std::string, std::string>& filesFound);  // search for models data in a given directory;

/**
 * @brief Search recursively for models within a directory
 *
 * @param[in] directoryToScan : the directory to scan
 * @param[in] fileExtension : the allowed file extension
 * @param[in] fileExtensionsForbidden : the forbidden file extension
 * @param[in] pathsToIgnore : paths that shouldn't be explored
 * @param[in] searchInSubDirs : whether to search in subdirectories, or to only search in the root directory
 * @param[in] isPackage : true if the current directory is a package
 * @param[in] packageForcesSubDirsSearch : true if for a package we have to look for models in subdirectories
 * @param[in] stopWhenSeePackage : true if for a package we don't want to look for models in subdirectories
 * @param[in] namespaces : models name to insert in the filesFound map
 * @param[out] filesFound : map containing the model name and the file path
 *
 * throw an exception when the rootPath does not exist
 */
void searchModelsFilesRec(const std::string& directoryToScan, const std::string& fileExtension, const std::vector<std::string> & fileExtensionsForbidden,
                          const std::unordered_set<boost::filesystem::path, PathHash>& pathsToIgnore, const bool searchInSubDirs,
                          const bool isPackage, const bool packageForcesSubDirsSearch, const bool stopWhenSeePackage,
                          const std::vector <std::string>& namespaces, std::map<std::string, std::string>& filesFound);

/**
 * @brief Search for Modelica models within a directory
 *
 * @param[in] directoryToScan : the directory to scan
 * @param[in] fileExtension : the allowed file extension
 * @param[in] searchInSubDirs : whether to search in subdirectories, or to only search in the root directory
 * @param[out] filesFound : the list of relevant files found
 *
 * if a package.mo file is located at the root of the directory, it is not scanned any further (the Modelica compiler will deal with it)
 * otherwise, the directory is scanned for Modelica files
 * the same algorithm is applied to subdirectories when no package.mo was found in the current directory
 *
 * throw an exception when the rootPath does not exist
 */
void searchModelicaModels(const std::string& directoryToScan, const std::string& fileExtension, const bool searchInSubDirs,
                          std::vector<std::string>& filesFound);

/**
 * @brief Concatenate two paths
 *
 * @param[in] name : the path relative to the root path (may be a file name)
 * @param[in] rootName : the path to the root directory
 *
 * @return the concatenated file path
 * throw an exception when the path does not exist
 */
std::string canonical(const std::string & name, const std::string & rootName = ".");

/**
 * @brief Concatenate two paths
 *
 * @param[in] name : the path relative to the root path (may be a file name)
 * @param[in] rootName : the path to the root directory
 *
 * @return the concatenated file path (even when the path does not exist)
 */
std::string absolute(const std::string & name, const std::string & rootName = ".");

/**
 * @brief return name if name is absolute, else concatenate name and rootName
 *
 *
 * @param name : the path relative to the root path (may be a file name)
 * @param rootName : the path to the root directory
 *
 * @return the concatenated file path (if path is not absolute)
 */
std::string createAbsolutePath(const std::string & name, const std::string & rootName);

/**
 * @brief Check whether a given path exists
 *
 * @param[in] path : the path to check
 *
 * @return whether the path exists
 * Warning : using this function on a canonical path will either return true or throw an exception (when path is not relevant)
 */
bool exists(const std::string & path);

/**
 * @brief Remove a given path
 *
 * @param[in] path : the path to remove
 *
 * @return whether the path existed (before trying to remove it)
 */
bool remove(const std::string & path);

/**
 * @brief copy a given file
 *
 * @param[in] oldPath : the path to copy
 * @param[in] newPath : the copied file
 *
 */
void copy(const std::string & oldPath, const std::string & newPath);

/**
 * @brief Retrieve the current path
 * WARNING : not thread-safe
 *
 * @return the current path as a string (equivalent of cd or pwd)
 */
std::string current_path();

/**
 * @brief Set the current file path
 * WARNING : not thread-safe
 *
 * @param[in] path : the current path as a string

 */
void current_path(const std::string & path);

/**
 * @brief replace the file extension from a file path
 * @param[in] path : the path for which to change the extension
 * @param[in] ext : the new extension without dot (ex: "txt")
 *
 * @return the updated path as a string

 */
std::string replace_extension(const std::string & path, const std::string & ext);

/**
 * @brief Check whether a path points toward a directory
 * @param[in] path : the path to check
 *
 * @return whether the path points toward a directory

 */
bool is_directory(const std::string & path);

/**
 * @brief Create all relevant directories in order to make a path relevant
 * @param[in] path : the path from which to create directories
 */
void create_directory(const std::string & path);

/**
 * @brief Retrieve the file extension from a file path
 * @param[in] path : the path from which to extract the file extension
 *
 * @return the file extension (or an empty string when no extension was found)
 * Warning : extension ("file.txt.tmp") will return ".tmp"
 */
std::string extension(const std::string & path);

/**
 * @brief Check whether given extensions are found in a directory
 * @param[in] directoryToScan : directory to scan
 * @param[in] extensionList : list of extensions to search in the directory
 * @return whether given extensions are found in directory
 */
bool extensionFound(const std::string directoryToScan, const std::vector <std::string> & extensionList);

/**
 * @brief Check whether file path ends with a given extension
 * @param[in] path : the path to compare with the file extension
 * @param[in] extension : given extension to compare with the path
 * @return whether they are equals
 * Warning : extensionEquals ("file.TXT.TMP", ".txt.tmp") will return false
 */
bool extensionEquals(const std::string path, const std::string extension);

/**
 * @brief Retrieve the file list in a directory
 *
 * @param path : the path from which to extract the directories list
 * @return the directories list in the path
 */
std::list<std::string> list_directory(const std::string & path);

/**
 * @brief Retrieve the file name from a file path
 * @param[in] path : the path from which to extract the file name
 *
 * @return the file name (or an empty string when it fails)

 */
std::string file_name(const std::string & path);

/**
 * @brief Remove the file name from a file path
 * @param[in] path : the path from which to remove the file name
 *
 * @return the file path without the file name
 */
std::string remove_file_name(const std::string & path);

/**
 * @brief Delete all contents in a directory
 *
 *
 * @param[in] directory : the directory where all contents are deleted
 */
void remove_all_in_directory(const std::string & directory);

/**
 * @brief Generate the parent directory from a given path
 *
 * @param[in] name : the path from which to find the parent path
 *
 * @return the parent file path (return the input path when it is not possible to find the parent directory)
 * parentDirectory (/users/test/model/alpha.mo) = /users/test/model
 */
std::string parentDirectory(const std::string name);

/**
 * @brief Generate the last directory from a given path
 *
 * @param[in] childPath : the path from which to find the last directory
 *
 * @return the last directory
 * lastParentDirectory (/users/test/model/alpha.mo) = model
 * lastParentDirectory (/users/test/model) = model
 */
std::string lastParentDirectory(const std::string childPath);

/**
 * @brief Check whether a given path is absolute or relative
 * @param[in] path : the path to check
 *
 * @return whether the path is absolute
 */
bool isAbsolutePath(const std::string path);

#endif  // COMMON_DYNFILESYSTEMUTILS_H_
