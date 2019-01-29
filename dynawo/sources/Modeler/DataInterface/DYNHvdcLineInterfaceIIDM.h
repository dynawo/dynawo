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

//======================================================================
/**
 * @file  DYNHvdcLineInterfaceIIDM.h
 *
 * @brief Hvdc Line data interface : header file for IIDM interface
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNHVDCLINEINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNHVDCLINEINTERFACEIIDM_H_

#include "DYNHvdcLineInterface.h"

namespace IIDM {
class HvdcLine;
}

namespace DYN {

class HvdcLineInterfaceIIDM : public HvdcLineInterface {
 public:
  /**
   * @brief Destructor
   */
  ~HvdcLineInterfaceIIDM();

  /**
   * @brief Constructor
   * @param hvdcLine: hvdc line iidm instance
   */
  explicit HvdcLineInterfaceIIDM(IIDM::HvdcLine& hvdcLine);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::checkCriteria(bool checkEachIter)
   */
  bool checkCriteria(bool checkEachIter);

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc HvdcLineInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc HvdcLineInterface::getResistanceDC() const
   */
  double getResistanceDC() const;

  /**
   * @copydoc HvdcLineInterface::getVNom() const
   */
  double getVNom() const;

  /**
   * @copydoc HvdcLineInterface::getActivePowerSetpoint() const
   */
  double getActivePowerSetpoint() const;

  /**
   * @copydoc HvdcLineInterface::getPmax() const
   */
  double getPmax() const;

  /**
   * @copydoc HvdcLineInterface::getConverterMode() const
   */
  ConverterMode_t getConverterMode() const;

  /**
   * @copydoc HvdcLineInterface::getIdConverter1() const
   */
  std::string getIdConverter1() const;

  /**
   * @copydoc HvdcLineInterface::getIdConverter2() const
   */
  std::string getIdConverter2() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

 private:
  IIDM::HvdcLine& hvdcLineIIDM_;  ///< reference to the iidm line instance
};  ///< Interface class for Hvdc Line model

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNHVDCLINEINTERFACEIIDM_H_
