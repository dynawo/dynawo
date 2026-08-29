//
// Copyright (c) 2020, RTE (http://www.rte-france.com)
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

//======================================================================
/**
 * @file  DataInterface/PowSyblIIDM/DYNStaticVarCompensatorInterfaceIIDMExtension.h
 *
 * @brief Static var compensator interface extension
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDMEXTENSION_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDMEXTENSION_H_

#include <powsybl/iidm/StaticVarCompensator.hpp>

namespace DYN {

/**
 * class StaticVarCompensatorInterfaceIIDM
 */
class StaticVarCompensatorInterfaceIIDMExtension {
 public:
  /**
   * @brief Destructor
   */
  virtual ~StaticVarCompensatorInterfaceIIDMExtension() = default;

  /**
   * @brief Interface to export the stand by mode of the svc
   * @param standByMode svc in standby or no
   */
  virtual void exportStandByMode(bool standByMode) = 0;

  /**
   * @copydoc StaticVarCompensatorInterface::getUMinActivation() const
   */
  virtual double getUMinActivation() const = 0;

  /**
   * @copydoc StaticVarCompensatorInterface::getUMaxActivation() const
   */
  virtual double getUMaxActivation() const = 0;

  /**
   * @copydoc StaticVarCompensatorInterface::getUSetPointMin() const
   */
  virtual double getUSetPointMin() const = 0;

  /**
   * @copydoc StaticVarCompensatorInterface::getUSetPointMax() const
   */
  virtual double getUSetPointMax() const = 0;

  /**
   * @copydoc StaticVarCompensatorInterface::hasStandbyAutomaton() const
   */
  virtual bool hasStandbyAutomaton() const = 0;

  /**
   * @copydoc StaticVarCompensatorInterface::isStandBy() const
   */
  virtual bool isStandBy() const = 0;

  /**
   * @copydoc StaticVarCompensatorInterface::getB0() const
   */
  virtual double getB0() const = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNSTATICVARCOMPENSATORINTERFACEIIDMEXTENSION_H_
