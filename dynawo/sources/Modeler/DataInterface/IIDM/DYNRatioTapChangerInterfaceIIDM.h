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
 * @file  DYNRatioTapChangerInterfaceIIDM.h
 *
 * @brief Ratio tap changer data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_IIDM_DYNRATIOTAPCHANGERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNRATIOTAPCHANGERINTERFACEIIDM_H_

#include "DYNRatioTapChangerInterface.h"

namespace IIDM {
class RatioTapChanger;
}

namespace DYN {

/**
 * class RatioTapChangerInterfaceIIDM
 */
class RatioTapChangerInterfaceIIDM : public RatioTapChangerInterface {
 public:
  /**
   * @brief Destructor
   */
  ~RatioTapChangerInterfaceIIDM();

  /**
   * @brief Constructor
   * @param tapChanger ratioTapChanger's iidm instance
   * @param parentName parent Transformer2WindingsBuilder id
   */
  explicit RatioTapChangerInterfaceIIDM(IIDM::RatioTapChanger& tapChanger, const std::string& parentName);

  /**
   * @copydoc RatioTapChangerInterface::getSteps() const
   */
  std::vector<boost::shared_ptr<StepInterface> > getSteps() const;

  /**
   * @copydoc RatioTapChangerInterface::addStep(const boost::shared_ptr<StepInterface>& step)
   */
  void addStep(const boost::shared_ptr<StepInterface>& step);

  /**
   * @copydoc RatioTapChangerInterface::getCurrentPosition() const
   */
  int getCurrentPosition() const;

  /**
   * @copydoc RatioTapChangerInterface::setCurrentPosition(const int& position)
   */
  void setCurrentPosition(const int& position);

  /**
   * @copydoc RatioTapChangerInterface::getLowPosition() const
   */
  int getLowPosition() const;

  /**
   * @copydoc RatioTapChangerInterface::getNbTap() const
   */
  unsigned int getNbTap() const;

  /**
   * @copydoc RatioTapChangerInterface::hasLoadTapChangingCapabilities() const
   */
  bool hasLoadTapChangingCapabilities() const;

  /**
   * @copydoc RatioTapChangerInterface::getRegulating() const
   */
  bool getRegulating() const;

  /**
   * @copydoc RatioTapChangerInterface::getTargetV() const
   */
  double getTargetV() const;

  /**
   * @copydoc RatioTapChangerInterface::getTerminalRefId() const
   */
  std::string getTerminalRefId() const;

  /**
   * @copydoc RatioTapChangerInterface::getTerminalRefSide() const
   */
  std::string getTerminalRefSide() const;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentR() const
   */
  double getCurrentR() const;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentX() const
   */
  double getCurrentX() const;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentB() const
   */
  double getCurrentB() const;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentG() const
   */
  double getCurrentG() const;

  /**
   * @copydoc RatioTapChangerInterface::getCurrentRho() const
   */
  double getCurrentRho() const;

 private:
  /**
  * @brief sanity check to make sure the ratio tap changer is properly built
  * @param parentName parent Transformer2WindingsBuilder id
  */
  void sanityCheck(const std::string& parentName) const;

 private:
  std::vector<boost::shared_ptr<StepInterface> > steps_;  ///< steps of the ratio tap changer
  IIDM::RatioTapChanger& tapChangerIIDM_;  ///< reference to the iidm ratioTapChanger's instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNRATIOTAPCHANGERINTERFACEIIDM_H_
