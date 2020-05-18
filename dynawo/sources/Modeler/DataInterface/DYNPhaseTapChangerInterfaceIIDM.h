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
 * @file  DYNPhaseTapChangerInterfaceIIDM.h
 *
 * @brief Phase tap changer data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNPHASETAPCHANGERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNPHASETAPCHANGERINTERFACEIIDM_H_

#include "DYNPhaseTapChangerInterface.h"

namespace IIDM {
class PhaseTapChanger;
}

namespace DYN {

class PhaseTapChangerInterfaceIIDM : public PhaseTapChangerInterface {
 public:
  /**
   * @brief Destructor
   */
  ~PhaseTapChangerInterfaceIIDM();

  /**
   * @brief Constructor
   * @param tapChanger phaseTapChanger's iidm instance
   */
  explicit PhaseTapChangerInterfaceIIDM(IIDM::PhaseTapChanger& tapChanger);

  /**
   * @copydoc PhaseTapChangerInterface::getSteps() const
   */
  std::vector<boost::shared_ptr<StepInterface> > getSteps() const;

  /**
   * @copydoc PhaseTapChangerInterface::addStep(const boost::shared_ptr<StepInterface>& step)
   */
  void addStep(const boost::shared_ptr<StepInterface>& step);


  /**
   * @copydoc PhaseTapChangerInterface::getCurrentPosition() const
   */
  int getCurrentPosition() const;

  /**
   * @copydoc PhaseTapChangerInterface::setCurrentPosition(const int& position)
   */
  void setCurrentPosition(const int& position);


  /**
   * @copydoc PhaseTapChangerInterface::getLowPosition() const
   */
  int getLowPosition() const;

  /**
   * @copydoc PhaseTapChangerInterface::getNbTap() const
   */
  unsigned int getNbTap() const;

  /**
   * @copydoc PhaseTapChangerInterface::isCurrentLimiter() const
   */
  bool isCurrentLimiter() const;

  /**
   * @copydoc PhaseTapChangerInterface::getRegulating() const
   */
  bool getRegulating() const;

  /**
   * @copydoc PhaseTapChangerInterface::getThresholdI() const
   */
  double getThresholdI() const;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentR() const
   */
  double getCurrentR() const;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentX() const
   */
  double getCurrentX() const;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentB() const
   */
  double getCurrentB() const;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentG() const
   */
  double getCurrentG() const;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentRho() const
   */
  double getCurrentRho() const;

  /**
   * @copydoc PhaseTapChangerInterface::getCurrentAlpha() const
   */
  double getCurrentAlpha() const;

 private:
  std::vector<boost::shared_ptr<StepInterface> > steps_;  ///< steps of the phase tap changer
  IIDM::PhaseTapChanger& tapChangerIIDM_;  ///< reference to the iidm phaseTapChanger's instance
};  ///< Interface calss for phase tap changer
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNPHASETAPCHANGERINTERFACEIIDM_H_
