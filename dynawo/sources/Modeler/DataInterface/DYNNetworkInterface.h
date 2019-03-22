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
 * @file  DYNNetworkInterface.h
 *
 * @brief Network data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNNETWORKINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNNETWORKINTERFACE_H_

#include <vector>
#include <boost/shared_ptr.hpp>

namespace DYN {
class LineInterface;
class TwoWTransformerInterface;
class ThreeWTransformerInterface;
class VoltageLevelInterface;
class HvdcLineInterface;

class NetworkInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~NetworkInterface() { }

  /**
   * @brief Add a new instance of line interface to the network interface
   * @param line instance of line interface to add
   */
  virtual void addLine(const boost::shared_ptr<LineInterface>& line) = 0;

  /**
   * @brief Add a new instance of two windings transformer interface to the network interface
   * @param tfo instance of two windings transformer interface to add
   */
  virtual void addTwoWTransformer(const boost::shared_ptr<TwoWTransformerInterface>& tfo) = 0;

  /**
   * @brief Add a new instance of three windings transformer interface to the network interface
   * @param tfo instance of three windings transformer interface to add
   */
  virtual void addThreeWTransformer(const boost::shared_ptr<ThreeWTransformerInterface>& tfo) = 0;

  /**
   * @brief Add a new instance of voltage level interface to the network interface
   * @param voltageLevel instance of voltageLevel interface to add
   */
  virtual void addVoltageLevel(const boost::shared_ptr<VoltageLevelInterface>& voltageLevel) = 0;

  /**
   * @brief Add a new instance of hvdc line interface to the network interface
   * @param hvdc: instance of hvdc line interface to add
   */
  virtual void addHvdcLine(const boost::shared_ptr<HvdcLineInterface>& hvdc) = 0;

  /**
   * @brief Getter for the vector of line interface
   * @return vector of line interface of the newtork interface
   */
  virtual const std::vector< boost::shared_ptr<LineInterface> >& getLines() const = 0;

  /**
   * @brief Getter for the vector of two windings transformer interface
   * @return vector of two windings transformer interface of the newtork interface
   */
  virtual const std::vector< boost::shared_ptr<TwoWTransformerInterface> >& getTwoWTransformers() const = 0;

  /**
   * @brief Getter for the vector of three windings transformer interface
   * @return vector of three windings transformer interface of the newtork interface
   */
  virtual const std::vector< boost::shared_ptr<ThreeWTransformerInterface> >& getThreeWTransformers() const = 0;

  /**
   * @brief Getter for the vector of voltageLevel interface
   * @return vector of voltageLevel of the newtork interface
   */
  virtual const std::vector< boost::shared_ptr<VoltageLevelInterface> >& getVoltageLevels() const = 0;

  /**
   * @brief Getter for the vector of hvdc line interface
   * @return vector of hvdc line of the newtork interface
   */
  virtual const std::vector< boost::shared_ptr<HvdcLineInterface> >& getHvdcLines() const = 0;
};  ///< class for network data interface

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNNETWORKINTERFACE_H_
