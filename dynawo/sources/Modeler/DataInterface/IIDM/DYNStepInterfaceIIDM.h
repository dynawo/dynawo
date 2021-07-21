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
 * @file  DataInterface/IIDM/DYNStepInterfaceIIDM.h
 *
 * @brief Step data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_IIDM_DYNSTEPINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNSTEPINTERFACEIIDM_H_

#include <IIDM/components/TapChanger.h>
#include <boost/optional.hpp>

#include "DYNStepInterface.h"

namespace IIDM {
struct PhaseTapChangerStep;
struct RatioTapChangerStep;
}

namespace DYN {

/**
 * @brief IIDM Step interface implementation
 */
class StepInterfaceIIDM : public StepInterface {
 public:
  /**
   * @brief Destructor
   */
  ~StepInterfaceIIDM();

  /**
   * @brief Constructor
   * @param step: phase tap changer step's iidm instance
   */
  explicit StepInterfaceIIDM(const IIDM::PhaseTapChangerStep& step);

  /**
   * @brief Constructor
   * @param step :ratio tap changer step's iidm instance
   */
  explicit StepInterfaceIIDM(const IIDM::RatioTapChangerStep& step);

  /**
   * @copydoc StepInterface::getR() const
   */
  double getR() const;

  /**
   * @copydoc StepInterface::getX() const
   */
  double getX() const;

  /**
   * @copydoc StepInterface::getB() const
   */
  double getB() const;

  /**
   * @copydoc StepInterface::getG() const
   */
  double getG() const;

  /**
   * @copydoc StepInterface::getRho() const
   */
  double getRho() const;

  /**
   * @copydoc StepInterface::getAlpha() const
   */
  double getAlpha() const;

 private:
  /**
   * @brief default constructor
   */
  StepInterfaceIIDM();

  boost::optional<IIDM::PhaseTapChangerStep> phaseStep_;  ///< reference to the iidm phase tap changer step instance
  boost::optional<IIDM::RatioTapChangerStep> ratioStep_;  ///< reference to the iidm ratio tap changer step instance
  bool isPhaseStep_;  ///< @b true if the step belongs to a phase tap changer
};  ///< interface class for step of tap changer

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNSTEPINTERFACEIIDM_H_
