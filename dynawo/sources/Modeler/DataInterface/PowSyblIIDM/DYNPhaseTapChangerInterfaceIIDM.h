//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DataInterface/PowSyblIIDM/DYNPhaseTapChangerInterfaceIIDM.h
 *
 * @brief Phase tap changer data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNPHASETAPCHANGERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNPHASETAPCHANGERINTERFACEIIDM_H_

#include "DYNPhaseTapChangerInterface.h"
#include "DYNStepInterface.h"

#include <powsybl/iidm/PhaseTapChanger.hpp>

#include <vector>

namespace DYN {

/**
 * class PhaseTapChangerInterfaceIIDM
 */
class PhaseTapChangerInterfaceIIDM : public PhaseTapChangerInterface {
 public:
  /**
   * @brief Constructor
   * @param tapChanger phaseTapChanger's iidm instance
   */
  explicit PhaseTapChangerInterfaceIIDM(powsybl::iidm::PhaseTapChanger& tapChanger);

  /**
   * @copydoc PhaseTapChangerInterface::getSteps() const
   */
  const std::vector<std::unique_ptr<StepInterface> >& getSteps() const override;

  /**
   * @copydoc PhaseTapChangerInterface::addStep(std::unique_ptr<StepInterface> step)
   */
  void addStep(std::unique_ptr<StepInterface> step) override;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentPosition() const
   */
  int getCurrentPosition() const override;

  /**
   * @copydoc PhaseTapChangerInterface::setCurrentPosition(const int& position)
   */
  void setCurrentPosition(const int& position) override;

  /**
   * @copydoc PhaseTapChangerInterface::getLowPosition() const
   */
  int getLowPosition() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getNbTap() const
   */
  unsigned int getNbTap() const override;

  /**
   * @copydoc PhaseTapChangerInterface::isCurrentLimiter() const
   */
  bool isCurrentLimiter() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getRegulating() const
   */
  bool getRegulating() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getRegulationValue() const
   */
  double getRegulationValue() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentR() const
   */
  double getCurrentR() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentX() const
   */
  double getCurrentX() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentB() const
   */
  double getCurrentB() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentG() const
   */
  double getCurrentG() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentRho() const
   */
  double getCurrentRho() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentAlpha() const
   */
  double getCurrentAlpha() const override;

  /**
   * @copydoc PhaseTapChangerInterface::getTargetDeadBand() const
   */
  double getTargetDeadBand() const override;

 private:
  std::vector<std::unique_ptr<StepInterface> > steps_;  ///< steps of the phase tap changer
  powsybl::iidm::PhaseTapChanger& tapChangerIIDM_;        ///< reference to the iidm phaseTapChanger's instance
};  // Interface class for phase tap changer
}   // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNPHASETAPCHANGERINTERFACEIIDM_H_
