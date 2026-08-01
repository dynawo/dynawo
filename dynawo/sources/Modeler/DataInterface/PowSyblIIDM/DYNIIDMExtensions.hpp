//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file DYNIIDMExtensions.hpp
 * @brief File for external IIDM extensions management
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_

#include "DYNIIDMExtensionsTraits.hpp"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"
#include "DYNCommon.h"

#include <boost/dll.hpp>
#include <boost/filesystem.hpp>
#include <functional>
#include <mutex>
#include <string>
#include <tuple>
#include <unordered_map>
#include <unordered_set>

namespace DYN {

/// @brief IIDM extensions management wrapper
class IIDMExtensions {
 public:
  /// @brief Alias type for base extension create function
  template<class T>
  using CreateFunctionBase = T*(typename IIDMExtensionTrait<T>::NetworkComponentType&);

  /// @brief Alias type for extension create function with STL wrapper
  template<class T>
  using CreateFunction = std::function<CreateFunctionBase<T> >;

  /// @brief Alias type for extension destruction function
  template<class T>
  using DestroyFunctionBase = void(T*);
  /// @brief Alias type for extension destruction function with STL wrapper
  template<class T>
  using DestroyFunction = std::function<DestroyFunctionBase<T> >;

  /// @brief Alias type for extension definition (creation/destruction)
  template<class T>
  using ExtensionDefinition = std::tuple<CreateFunction<T>, DestroyFunction<T> >;

  /// @brief Extension enum to make access to Extension Definition fields easier
  enum ExtensionDefinitionIndex {
    CREATE_FUNCTION = 0,  ///< Extension creation function
    DESTROY_FUNCTION      ///< Extension destruction function
  };

  /**
   * @brief Find library path from DYNAMO environment
   * @returns the IIDM extension library path
   */
  static boost::filesystem::path findLibraryPath();

 public:
  /**
   * @brief Retrieve the extension definition
   *
   * This will extract the create/destroy functions with a name pattern
   *
   * @param libPath the path of the library containing the extension
   * @returns the extension definition
   */
  template<class T>
  static ExtensionDefinition<T> getExtension(const std::string& libPath) {
    if (libPath.empty()) {
      // This corresponds to default case if environment variable for external IIDM extensions paths is not set
      return buildDefaultExtensionDefinition<T>();
    }
    const auto& name = IIDMExtensionTrait<T>::name;
    std::shared_ptr<boost::dll::shared_library> extensionLibrary;
    std::unique_lock<std::mutex> lock(librariesMutex_);
    if (getLibraries().count(libPath) > 0) {
      extensionLibrary = getLibraries().at(libPath);
    } else {
      try {
        extensionLibrary = std::make_shared<boost::dll::shared_library>(libPath);
      } catch (const std::exception& e) {
        if (getLibrariesLoadingIssues().count(libPath) == 0) {
          // put the log only once
          Trace::warn() << DYNLog(IIDMExtensionLibraryNotLoaded, libPath, name, e.what()) << Trace::endline;
          getLibrariesLoadingIssues().insert(libPath);
        }
        return buildDefaultExtensionDefinition<T>();
      }
      getLibraries()[libPath] = extensionLibrary;
    }
    lock.unlock();

    std::string createName = "create" + std::string(name);
    if (!extensionLibrary->has(createName)) {
      // warning here because if the extension is not implemented, it may not be a problem for the simulation
      Trace::warn() << DYNLog(IIDMExtensionNoCreate, name, libPath, createName) << Trace::endline;
      return buildDefaultExtensionDefinition<T>();
    }
#if (BOOST_VERSION >= 107600)
    auto createFunc = boost::dll::import_symbol<CreateFunctionBase<T>>(*extensionLibrary, createName.c_str());
#else
    auto createFunc = boost::dll::import<CreateFunctionBase<T>>(*extensionLibrary, createName.c_str());
#endif

    std::string destroyName = "destroy" + std::string(name);
    if (!extensionLibrary->has(destroyName)) {
      // warning here because if the extension is not implemented, it may not be a problem for the simulation
      Trace::warn() << DYNLog(IIDMExtensionNoDestroy, name, libPath, destroyName) << Trace::endline;
      return buildDefaultExtensionDefinition<T>();
    }
#if (BOOST_VERSION >= 107600)
    auto destroyFunc = boost::dll::import_symbol<DestroyFunctionBase<T>>(*extensionLibrary, destroyName.c_str());
#else
    auto destroyFunc = boost::dll::import<DestroyFunctionBase<T>>(*extensionLibrary, destroyName.c_str());
#endif

    return ExtensionDefinition<T>(createFunc, destroyFunc);
  }

 private:
  ///< Alias for library path in map
  using LibraryPath = std::string;

 public:
  /**
   * @brief Get list of loaded libraries
   * @return the list of loaded libraries
   */
  static std::unordered_map<IIDMExtensions::LibraryPath, std::shared_ptr<boost::dll::shared_library> >& getLibraries() {
    static std::unordered_map<IIDMExtensions::LibraryPath, std::shared_ptr<boost::dll::shared_library> > libraries;
    return libraries;
  }

  /**
   * @brief Get list of libraries path for which a loading issue was detected
   * @return the list of libraries path for which a loading issue was detected
   */
  static std::unordered_set<LibraryPath>& getLibrariesLoadingIssues() {
    static std::unordered_set<LibraryPath> librariesLoadingIssues;
    return librariesLoadingIssues;
  }

 private:
  /**
   * @brief Build a default extension definition
   *
   * By default, the create function returns a NULL pointer
   * By default the destroy function does nothing
   *
   * @returns an extension definition that does nothing
   */
  template<class T>
  static inline ExtensionDefinition<T> buildDefaultExtensionDefinition() {
    auto defaultCreate = [](typename IIDMExtensionTrait<T>::NetworkComponentType&) { return nullptr; };
    auto defaultDestroy = [](T*) {
      // do nothing
    };
    return ExtensionDefinition<T>(defaultCreate, defaultDestroy);
  }

 private:
  static std::mutex librariesMutex_;                               ///< Mutex to access libraries
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_
