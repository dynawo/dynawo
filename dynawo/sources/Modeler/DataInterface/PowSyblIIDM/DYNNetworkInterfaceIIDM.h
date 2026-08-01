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
 * @file  DataInterface/PowSyblIIDM/DYNNetworkInterfaceIIDM.h
 *
 * @brief Network data interface : header file for IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNNETWORKINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNNETWORKINTERFACEIIDM_H_

#include "DYNNetworkInterface.h"

#include <powsybl/iidm/Network.hpp>

#include <vector>


namespace DYN {

/**
 * class NetworkInterfaceIIDM
 */
class NetworkInterfaceIIDM : public NetworkInterface {
 public:
  /**
   * @brief Constructor
   * @param network the network's iidm instance
   */
  explicit NetworkInterfaceIIDM(powsybl::iidm::Network& network);

  /**
   * @copydoc NetworkInterface::addLine(const std::shared_ptr<LineInterface>& line)
   */
  void addLine(const std::shared_ptr<LineInterface>& line) override;

  /**
   * @copydoc NetworkInterface::addTwoWTransformer(const std::shared_ptr<TwoWTransformerInterface>& tfo)
   */
  void addTwoWTransformer(const std::shared_ptr<TwoWTransformerInterface>& tfo) override;

  /**
   * @copydoc NetworkInterface::addThreeWTransformer(const std::shared_ptr<ThreeWTransformerInterface>& tfo)
   */
  void addThreeWTransformer(const std::shared_ptr<ThreeWTransformerInterface>& tfo) override;

  /**
   * @copydoc NetworkInterface::addVoltageLevel(const std::shared_ptr<VoltageLevelInterface>& voltageLevel)
   */
  void addVoltageLevel(const std::shared_ptr<VoltageLevelInterface>& voltageLevel) override;

  /**
   * @copydoc NetworkInterface::addHvdcLine(const std::shared_ptr<HvdcLineInterface>& hvdc)
   */
  void addHvdcLine(const std::shared_ptr<HvdcLineInterface>& hvdc) override;

  /**
   * @copydoc NetworkInterface::getLines() const
   */
  const std::vector<std::shared_ptr<LineInterface> >& getLines() const override;

  /**
   * @copydoc NetworkInterface::getTwoWTransformers() const
   */
  const std::vector<std::shared_ptr<TwoWTransformerInterface> >& getTwoWTransformers() const override;

  /**
   * @copydoc NetworkInterface::getThreeWTransformers() const
   */
  const std::vector<std::shared_ptr<ThreeWTransformerInterface> >& getThreeWTransformers() const override;

  /**
   * @copydoc NetworkInterface::getVoltageLevels() const
   */
  const std::vector<std::shared_ptr<VoltageLevelInterface> >& getVoltageLevels() const override;

  /**
   * @copydoc NetworkInterface::getHvdcLines() const
   */
  const std::vector<std::shared_ptr<HvdcLineInterface> >& getHvdcLines() const override;

  /**
   * @copydoc NetworkInterface::getSlackNodeBusId
   */
  boost::optional<std::string> getSlackNodeBusId() const override;

 private:
  /**
   * @brief Constructor
   */
  NetworkInterfaceIIDM();

  powsybl::iidm::Network& networkIIDM_;                                              ///< reference to the iidm network instance
  std::vector<std::shared_ptr<LineInterface> > lines_;                            ///< vector of line interface of the network
  std::vector<std::shared_ptr<TwoWTransformerInterface> > twoWTransformers_;      ///< vector of two windings transformer interface of the network
  std::vector<std::shared_ptr<ThreeWTransformerInterface> > threeWTransformers_;  ///< vector of three windings transformer interface of the network
  std::vector<std::shared_ptr<VoltageLevelInterface> > voltageLevels_;            ///< vector of voltage level interface of the network
  std::vector<std::shared_ptr<HvdcLineInterface> > hvdcs_;                        ///< vector of hvdc line interface of the network
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNNETWORKINTERFACEIIDM_H_
