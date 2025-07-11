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

/**
 * @file  DataInterface/PowSyblIIDM/DYNBusInterfaceIIDM.h
 *
 * @brief Bus data interface : header file for IIDM interface
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNBUSINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNBUSINTERFACEIIDM_H_

#include <powsybl/iidm/Bus.hpp>

#include <boost/optional.hpp>

#include "DYNBusInterface.h"

namespace DYN {

/**
 * @class BusInterfaceIIDM
 * @brief Specialization of BusInterface class for IIDM
 */
class BusInterfaceIIDM : public BusInterface {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_V = 0,
    VAR_ANGLE = 1
  } indexVar_t;

  /**
   * @brief Constructor
   * @param bus : bus' iidm instance
   */
  explicit BusInterfaceIIDM(powsybl::iidm::Bus& bus);

  /**
   * @copydoc BusInterface::getV0() const
   */
  double getV0() const override;

  /**
   * @copydoc BusInterface::getVMin() const
   */
  double getVMin() const override;

  /**
   * @copydoc BusInterface::getVMax() const
   */
  double getVMax() const override;

  /**
   * @copydoc BusInterface::getAngle0() const
   */
  double getAngle0() const override;

  /**
   * @copydoc BusInterface::getVNom() const
   */
  double getVNom() const override;

  /**
   * @copydoc BusInterface::getStateVarV() const
   */
  double getStateVarV() const override;

  /**
   * @copydoc BusInterface::getStateVarAngle() const
   */
  double getStateVarAngle() const override;

  /**
   * @copydoc BusInterface::getID() const
   */
  const std::string& getID() const override;

  /**
   * @copydoc BusInterface::hasConnection(bool hasConnection)
   */
  void hasConnection(bool hasConnection) override;

  /**
   * @brief Getter for the bus' connection attribute
   * @return @b true if the bus has an outside connection, @b false else
   */
  bool hasConnection() const override;

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters() override;
  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent() override;

  /**
   * @copydoc BusInterface::getBusBarSectionIdentifiers() const
   */
  const std::vector<std::string>& getBusBarSectionIdentifiers() const override {
    static std::vector<std::string> empty;
    return empty;
  }

  /**
   * @copydoc BusInterface::isFictitious() const
   */
  bool isFictitious() const final {
    return false;
  }

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const override;

  /**
   * @copydoc BusInterface::getBusIndex() const
   */
  inline int getBusIndex() const override {
    return 0;  // The bus index is non 0 only for a calculated bus
  }

  /**
   * @brief Getter for the bus' country
   * @return the bus country
   */
  inline const std::string& getCountry() const {
    return country_;
  }

  /**
   * @brief Setter for the bus' country
   * @param country bus country
   */
  inline void setCountry(const std::string& country) {
    country_ = country;
  }

 private:
  powsybl::iidm::Bus& busIIDM_;        ///< reference to the iidm bus instance
  bool hasConnection_;                 ///< @b true if the bus has an outside connection, @b false else
  // state variables
  boost::optional<double> U0_;         ///< initial voltage
  boost::optional<double> angle0_;     ///< initial angle
  std::string country_;                ///< country of the bus
};  ///< Interface class for Bus Model
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNBUSINTERFACEIIDM_H_
