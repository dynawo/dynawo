//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file DYNIIDMExtensions.hpp
 * @brief File for external IIDM extensions management
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_

#include "DYNIIDMExtensionsTraits.hpp"
#include "DYNMacrosMessage.h"
#include "DYNTrace.h"

#include <boost/dll.hpp>
#include <boost/filesystem.hpp>
#include <functional>
#include <mutex>
#include <string>
#include <tuple>
#include <unordered_map>

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
    std::shared_ptr<boost::dll::shared_library> extensionLibrary;
    std::unique_lock<std::mutex> lock(librariesMutex_);
    if (libraries_.count(libPath) > 0) {
      extensionLibrary = libraries_.at(libPath);
    } else {
      try {
        extensionLibrary = std::make_shared<boost::dll::shared_library>(libPath);
      } catch (const std::exception&) {
        // no log here because if extension library cannot be loaded, this will happen
        // for every network element supporting an external extension, resulting in a polluted logging file
        return buildDefaultExtensionDefinition<T>();
      }
      libraries_[libPath] = extensionLibrary;
    }
    lock.unlock();
    const auto& name = IIDMExtensionTrait<T>::name;

    std::string createName = "create" + std::string(name);
    if (!extensionLibrary->has(createName)) {
      // warning here because if the extension is not implemented, it may not be a problem for the simulation
      Trace::warn() << DYNLog(IIDMExtensionNoCreate, name, libPath, createName);
      return buildDefaultExtensionDefinition<T>();
    }
    auto createFunc = boost::dll::import<CreateFunctionBase<T> >(*extensionLibrary, createName);

    std::string destroyName = "destroy" + std::string(name);
    if (!extensionLibrary->has(destroyName)) {
      // warning here because if the extension is not implemented, it may not be a problem for the simulation
      Trace::warn() << DYNLog(IIDMExtensionNoDestroy, name, libPath, destroyName);
      return buildDefaultExtensionDefinition<T>();
    }
    auto destroyFunc = boost::dll::import<DestroyFunctionBase<T> >(*extensionLibrary, destroyName);

    return ExtensionDefinition<T>(createFunc, destroyFunc);
  }

 private:
  ///< Alias for library path in map
  using LibraryPath = std::string;

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
  static std::unordered_map<LibraryPath, std::shared_ptr<boost::dll::shared_library> > libraries_;  ///< List of loaded libraries
  static std::mutex librariesMutex_;                                                                ///< Mutex to access libraries
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_
