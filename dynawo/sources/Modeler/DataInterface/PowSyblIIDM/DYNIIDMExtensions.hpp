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
 * @brief File for private IIDM extensions management
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_

#include "DYNIIDMExtensionsTraits.hpp"

#include <boost/dll.hpp>
#include <boost/filesystem.hpp>
#include <functional>
#include <string>
#include <tuple>

namespace DYN {

/// @brief IIDM extensions management wrapper
struct IIDMExtensions {
  /// @brief Alias type for base extension create function
  template<class T>
  using CreateFunctionBase = T*(typename IIDMExtTrait<T>::NetworkInputType&);

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
   * @brief Retrieve the extension definition
   *
   * This will extract the create/destroy functions with a name pattern
   *
   * @param libPath the path of the library containing the extension
   * @returns the extension definition
   */
  template<class T>
  static ExtensionDefinition<T> getExtension(const std::string& libPath) {
    boost::dll::shared_library extensionLibrary(libPath);
    const auto& name = IIDMExtTrait<T>::name;

    std::string createName = "createExtension" + name;
    if (!extensionLibrary.has(createName)) {
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, libPath + "::" + createName);
    }
    auto createFunc = boost::dll::import<CreateFunctionBase<T> >(extensionLibrary, createName);

    std::string destroyName = "destroyExtension" + name;
    if (!extensionLibrary.has(destroyName)) {
      throw DYNError(DYN::Error::GENERAL, LibraryLoadFailure, libPath + "::" + destroyName);
    }
    auto destroyFunc = boost::dll::import<DestroyFunctionBase<T> >(extensionLibrary, destroyName);

    return ExtensionDefinition<T>(createFunc, destroyFunc);
  }
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONS_HPP_
