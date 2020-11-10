//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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

//======================================================================
/**
 * @file  DataInterface/PowSyblIIDM/DYNStaticVarCompensatorInterfaceIIDMNoStandByAutomaton.h
 *
 * @brief Static var compensator interface extension with no stand by automaton
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDMNOSTANDBYAUTOMATON_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDMNOSTANDBYAUTOMATON_H_

#include "DYNStaticVarCompensatorInterfaceIIDMExtension.h"

namespace DYN {

/**
 * class StaticVarCompensatorInterfaceIIDM
 */
class StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton : StaticVarCompensatorInterfaceIIDMExtension {
 public:
  /**
   * @brief Destructor
   */
  ~StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton();

  /**
   * @brief Constructor
   */
  explicit StaticVarCompensatorInterfaceIIDMExtensionNoStandByAutomaton(powsybl::iidm::StaticVarCompensator& svc);

  /**
   * @copydoc StaticVarCompensatorInterfaceIIDMExtension::exportStandByMode()
   */
  void exportStandByMode(bool standByMode);

  /**
   * @copydoc StaticVarCompensatorInterface::getUMinActivation() const
   */
  double getUMinActivation() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getUMaxActivation() const
   */
  double getUMaxActivation() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getUSetPointMin() const
   */
  double getUSetPointMin() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getUSetPointMax() const
   */
  double getUSetPointMax() const;

  /**
   * @copydoc StaticVarCompensatorInterface::hasStandbyAutomaton() const
   */
  bool hasStandbyAutomaton() const;

  /**
   * @copydoc StaticVarCompensatorInterface::isStandBy() const
   */
  bool isStandBy() const;

  /**
   * @copydoc StaticVarCompensatorInterface::getB0() const
   */
  double getB0() const;

 private:
  powsybl::iidm::StaticVarCompensator& staticVarCompensatorIIDM_;  ///< reference to the iidm static var compensator instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDMNOSTANDBYAUTOMATON_H_
