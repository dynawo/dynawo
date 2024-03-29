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
   * @copydoc NetworkInterface::addLine(const boost::shared_ptr<LineInterface>& line)
   */
  void addLine(const boost::shared_ptr<LineInterface>& line);

  /**
   * @copydoc NetworkInterface::addTwoWTransformer(const boost::shared_ptr<TwoWTransformerInterface>& tfo)
   */
  void addTwoWTransformer(const boost::shared_ptr<TwoWTransformerInterface>& tfo);

  /**
   * @copydoc NetworkInterface::addThreeWTransformer(const boost::shared_ptr<ThreeWTransformerInterface>& tfo)
   */
  void addThreeWTransformer(const boost::shared_ptr<ThreeWTransformerInterface>& tfo);

  /**
   * @copydoc NetworkInterface::addVoltageLevel(const boost::shared_ptr<VoltageLevelInterface>& voltageLevel)
   */
  void addVoltageLevel(const boost::shared_ptr<VoltageLevelInterface>& voltageLevel);

  /**
   * @copydoc NetworkInterface::addHvdcLine(const boost::shared_ptr<HvdcLineInterface>& hvdc)
   */
  void addHvdcLine(const boost::shared_ptr<HvdcLineInterface>& hvdc);

  /**
   * @copydoc NetworkInterface::getLines() const
   */
  const std::vector< boost::shared_ptr<LineInterface> >& getLines() const;

  /**
   * @copydoc NetworkInterface::getTwoWTransformers() const
   */
  const std::vector< boost::shared_ptr<TwoWTransformerInterface> >& getTwoWTransformers() const;

  /**
   * @copydoc NetworkInterface::getThreeWTransformers() const
   */
  const std::vector< boost::shared_ptr<ThreeWTransformerInterface> >& getThreeWTransformers() const;

  /**
   * @copydoc NetworkInterface::getVoltageLevels() const
   */
  const std::vector< boost::shared_ptr<VoltageLevelInterface> >& getVoltageLevels() const;

  /**
   * @copydoc NetworkInterface::getHvdcLines() const
   */
  const std::vector< boost::shared_ptr<HvdcLineInterface> >& getHvdcLines() const;

  /**
   * @copydoc NetworkInterface::getSlackNodeBusId
   */
  boost::optional<std::string> getSlackNodeBusId() const;

 private:
  /**
   * @brief Constructor
   */
  NetworkInterfaceIIDM();

  powsybl::iidm::Network& networkIIDM_;                                              ///< reference to the iidm network instance
  std::vector< boost::shared_ptr<LineInterface> > lines_;                            ///< vector of line interface of the network
  std::vector< boost::shared_ptr<TwoWTransformerInterface> > twoWTransformers_;      ///< vector of two windings transformer interface of the network
  std::vector< boost::shared_ptr<ThreeWTransformerInterface> > threeWTransformers_;  ///< vector of three windings transformer interface of the network
  std::vector< boost::shared_ptr<VoltageLevelInterface> > voltageLevels_;            ///< vector of voltage level interface of the network
  std::vector< boost::shared_ptr<HvdcLineInterface> > hvdcs_;                        ///< vector of hvdc line interface of the network
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNNETWORKINTERFACEIIDM_H_
