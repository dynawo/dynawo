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
 * @file DYNIIDMExtensionsTraits.hpp
 * @brief Traits for IIDM extensions interfaces
 */

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONSTRAITS_HPP_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONSTRAITS_HPP_

#include "DYNActiveSeasonIIDMExtension.h"
#include "DYNCurrentLimitsPerSeasonIIDMExtension.h"
#include "DYNGeneratorActivePowerControlIIDMExtension.h"
#include "DYNStaticVarCompensatorInterfaceIIDMExtension.h"

#include <powsybl/iidm/Generator.hpp>
#include <string>

namespace DYN {
/**
 * @brief Base template class for traits
 *
 * Traits for IIDM extensions are:
 * - NetworkComponentType: the powsybl type of input for the extension
 * - name: the name of the extension, used to build the creation/destruction functions
 */
template<class T>
struct IIDMExtensionTrait {};

/// @brief Specialization trait for StaticVarCompensatorInterfaceIIDMExtension
template<>
struct IIDMExtensionTrait<StaticVarCompensatorInterfaceIIDMExtension> {
  /// @brief Network component type
  using NetworkComponentType = powsybl::iidm::StaticVarCompensator;
  static const char name[];  ///< name of the extension
};

/// @brief Specialization trait for ActiveSeasonIIDMExtension
template<>
struct IIDMExtensionTrait<ActiveSeasonIIDMExtension> {
  /// @brief Network component type
  using NetworkComponentType = powsybl::iidm::Connectable;
  static const char name[];  ///< name of the extension
};

/// @brief Specialization trait for CurrentLimitsPerSeasonIIDMExtension
template<>
struct IIDMExtensionTrait<CurrentLimitsPerSeasonIIDMExtension> {
  /// @brief Network component type
  using NetworkComponentType = powsybl::iidm::Connectable;
  static const char name[];  ///< name of the extension
};

/// @brief Specialization trait for GeneratorActivePowerControlIIDMExtension
template<>
struct IIDMExtensionTrait<GeneratorActivePowerControlIIDMExtension> {
  /// @brief Network component type
  using NetworkComponentType = powsybl::iidm::Generator;
  static const char name[];  ///< name of the extension
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNIIDMEXTENSIONSTRAITS_HPP_
