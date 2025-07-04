//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  DataInterface/PowSyblIIDM/DYNHvdcLineInterfaceIIDM.h
 *
 * @brief Hvdc Line data interface : header file for IIDM interface
 *
 */
//======================================================================

#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCLINEINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCLINEINTERFACEIIDM_H_

#include "DYNHvdcLineInterface.h"

#include <powsybl/iidm/HvdcLine.hpp>
#include <powsybl/iidm/extensions/iidm/HvdcAngleDroopActivePowerControl.hpp>
#include <powsybl/iidm/extensions/iidm/HvdcOperatorActivePowerRange.hpp>

#include <boost/noncopyable.hpp>

#include <string>

namespace DYN {

/**
 * @brief HVDC line interface IIDM implementation
 */
class HvdcLineInterfaceIIDM : public HvdcLineInterface, public boost::noncopyable {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_P1 = 0,
    VAR_P2,
    VAR_Q1,
    VAR_Q2,
    VAR_STATE1,
    VAR_STATE2
  } indexVar_t;

 public:
  /**
   * @brief Destructor
   */
  ~HvdcLineInterfaceIIDM() override;

  /**
   * @brief Constructor
   * @param hvdcLine hvdc line iidm instance
   * @param conv1 converter 1 data interface instance
   * @param conv2 converter 2 data interface instance
   */
  explicit HvdcLineInterfaceIIDM(powsybl::iidm::HvdcLine& hvdcLine,
                                 const std::shared_ptr<ConverterInterface>& conv1,
                                 const std::shared_ptr<ConverterInterface>& conv2);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters() override;

  /**
   * @copydoc ComponentInterface::isConnected()
   */
  bool isConnected() const override;

  /**
   * @copydoc ComponentInterface::isPartiallyConnected()
   */
  bool isPartiallyConnected() const override;

  /**
   * @copydoc HvdcLineInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @copydoc HvdcLineInterface::getResistanceDC() const
   */
  double getResistanceDC() const override;

  /**
   * @copydoc HvdcLineInterface::getVNom() const
   */
  double getVNom() const override;

  /**
   * @copydoc HvdcLineInterface::getActivePowerSetpoint() const
   */
  double getActivePowerSetpoint() const override;

  /**
   * @copydoc HvdcLineInterface::getPmax() const
   */
  double getPmax() const override;

  /**
   * @copydoc HvdcLineInterface::getConverterMode() const
   */
  ConverterMode_t getConverterMode() const override;

  /**
   * @copydoc HvdcLineInterface::getIdConverter1() const
   */
  std::string getIdConverter1() const override;

  /**
   * @copydoc HvdcLineInterface::getIdConverter2() const
   */
  std::string getIdConverter2() const override;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @copydoc HvdcLineInterface::getConverter1() const
   */
  const std::shared_ptr<ConverterInterface>& getConverter1() const override;

  /**
   * @copydoc HvdcLineInterface::getConverter2() const
   */
  const std::shared_ptr<ConverterInterface>& getConverter2() const override;

  /**
   * @copydoc HvdcLineInterface::getDroop() const
   */
  boost::optional<double> getDroop() const final;
  /**
   * @copydoc HvdcLineInterface::getP0() const
   */
  boost::optional<double> getP0() const final;
  /**
   * @copydoc HvdcLineInterface::isActivePowerControlEnabled() const
   */
  boost::optional<bool> isActivePowerControlEnabled() const final;
  /**
   * @copydoc HvdcLineInterface::getOprFromCS1toCS2() const
   */
  boost::optional<double> getOprFromCS1toCS2() const final;
  /**
   * @copydoc HvdcLineInterface::getOprFromCS2toCS1() const
   */
  boost::optional<double> getOprFromCS2toCS1() const final;

 private:
  powsybl::iidm::HvdcLine& hvdcLineIIDM_;        ///< reference to the iidm line instance
  std::shared_ptr<ConverterInterface> conv1_;  ///< conv1
  std::shared_ptr<ConverterInterface> conv2_;  ///< conv2
  stdcxx::Reference<powsybl::iidm::extensions::iidm::HvdcAngleDroopActivePowerControl> hvdcActivePowerControl_;  ///< HVDC active power control extension
  stdcxx::Reference<powsybl::iidm::extensions::iidm::HvdcOperatorActivePowerRange> hvdcActivePowerRange_;        ///< HVDC active power range extension
};                                               ///< Interface class for Hvdc Line model

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNHVDCLINEINTERFACEIIDM_H_
