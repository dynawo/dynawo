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
 * @file  DataInterface/PowSyblIIDM/DYNRatioTapChangerInterfaceIIDM.h
 *
 * @brief Ratio tap changer data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNRATIOTAPCHANGERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNRATIOTAPCHANGERINTERFACEIIDM_H_

#include "DYNRatioTapChangerInterface.h"

#include <powsybl/iidm/RatioTapChanger.hpp>

#include <string>
#include <vector>

namespace DYN {

/**
 * class RatioTapChangerInterfaceIIDM
 */
class RatioTapChangerInterfaceIIDM : public RatioTapChangerInterface {
 public:
  /**
   * @brief Constructor
   * @param tapChanger ratioTapChanger's iidm instance
   * @param terminalRefSide terminal reference side
   */
  explicit RatioTapChangerInterfaceIIDM(powsybl::iidm::RatioTapChanger& tapChanger, const std::string& terminalRefSide);

  /**
   * @copydoc RatioTapChangerInterface::getSteps() const
   */
  const std::vector<std::unique_ptr<StepInterface> >& getSteps() const override;

  /**
   * @copydoc RatioTapChangerInterface::addStep(std::unique_ptr<StepInterface> step)
   */
  void addStep(std::unique_ptr<StepInterface> step) override;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentPosition() const
   */
  int getCurrentPosition() const override;

  /**
   * @copydoc RatioTapChangerInterface::setCurrentPosition(const int& position)
   */
  void setCurrentPosition(const int& position) override;

  /**
   * @copydoc RatioTapChangerInterface::getLowPosition() const
   */
  int getLowPosition() const override;

  /**
   * @copydoc RatioTapChangerInterface::getNbTap() const
   */
  unsigned int getNbTap() const override;

  /**
   * @copydoc RatioTapChangerInterface::hasLoadTapChangingCapabilities() const
   */
  bool hasLoadTapChangingCapabilities() const override;

  /**
   * @copydoc RatioTapChangerInterface::getRegulating() const
   */
  bool getRegulating() const override;

  /**
   * @copydoc RatioTapChangerInterface::getTargetV() const
   */
  double getTargetV() const override;

  /**
   * @copydoc RatioTapChangerInterface::getTerminalRefId() const
   */
  std::string getTerminalRefId() const override;

  /**
   * @copydoc RatioTapChangerInterface::getTerminalRefSide() const
   */
  std::string getTerminalRefSide() const override;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentR() const
   */
  double getCurrentR() const override;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentX() const
   */
  double getCurrentX() const override;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentB() const
   */
  double getCurrentB() const override;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentG() const
   */
  double getCurrentG() const override;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentRho() const
   */
  double getCurrentRho() const override;

  /**
   * @copydoc RatioTapChangerInterface::getTargetDeadBand() const
   */
  double getTargetDeadBand() const override;

 private:
  std::vector<std::unique_ptr<StepInterface> > steps_;  ///< steps of the ratio tap changer
  powsybl::iidm::RatioTapChanger& tapChangerIIDM_;        ///< reference to the iidm ratioTapChanger's instance
  const std::string terminalRefSide_;                     ///< terminal reference side
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNRATIOTAPCHANGERINTERFACEIIDM_H_
