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
 * @file  DYNRatioTapChangerInterface.h
 *
 * @brief Ratio tap changer data interface : interface file
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNRATIOTAPCHANGERINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNRATIOTAPCHANGERINTERFACE_H_

#include <vector>
#include <boost/shared_ptr.hpp>

namespace DYN {
class StepInterface;

/**
 * class RatioTapChangerInterface
 */
class RatioTapChangerInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~RatioTapChangerInterface() { }

  /**
   * @brief Getter for steps of the ratio tap changer
   * @return steps of the ratio tap changer
   */
  virtual std::vector<boost::shared_ptr<StepInterface> > getSteps() const = 0;

  /**
   * @brief Add a new step to the ratio tap changer
   * @param step step to add to the ratio tap changer
   */
  virtual void addStep(const boost::shared_ptr<StepInterface>& step) = 0;

  /**
   * @brief Getter for the current tap position
   * @return the current tap position
   */
  virtual int getCurrentPosition() const = 0;

  /**
   * @brief Setter for the current tap position
   * @param position: the current tap position
   */
  virtual void setCurrentPosition(const int& position) = 0;

  /**
   * @brief Getter for the lowest tap position
   * @return the lowest tap position
   */
  virtual int getLowPosition() const = 0;

  /**
   * @brief Getter for the number of tap
   * @return the number of tap
   */
  virtual unsigned int getNbTap() const = 0;

  /**
   * @brief Indicates if the ratio tap changer has load tap changing capabilities
   * @return @b true if the ratio tap changer has load tap changing capabilities
   */
  virtual bool hasLoadTapChangingCapabilities() const = 0;

  /**
   * @brief Getter for the current status of the ratio tap changer
   * @return @b true is the ratio tap changer is regulating, @b false else
   */
  virtual bool getRegulating() const = 0;

  /**
   * @brief Getter for the current target of the ratio tap changer
   * @return the current voltage target
   */
  virtual double getTargetV() const = 0;

  /**
   * @brief Getter for the id of the terminal controlled by the tap changer
   * @return the id of the terminal
   */
  virtual std::string getTerminalRefId() const = 0;

  /**
   * @brief Getter for the side of the terminal controlled by the tap changer
   * @return the side of the terminal
   */
  virtual std::string getTerminalRefSide() const = 0;

  /**
   * @brief Getter for the current step's resistance of the ratio tap changer
   * @return The current step's resistance of the ratio tap changer in ohms
   */
  virtual double getCurrentR() const = 0;

  /**
   * @brief Getter for the current step's reactance of the ratio tap changer
   * @return The current step's reactance of the ratio tap changer in ohms
   */
  virtual double getCurrentX() const = 0;

  /**
   * @brief Getter for the current step's susceptance of the ratio tap changer
   * @return The current step's susceptance of the ratio tap changer in siemens
   */
  virtual double getCurrentB() const = 0;

  /**
   * @brief Getter for the current step's conductance of the ratio tap changer
   * @return The current step's conductance of the ratio tap changer in siemens
   */
  virtual double getCurrentG() const = 0;

  /**
   * @brief Getter for the current ratio of the ratio tap changer
   * @return The current ratio of the ratio tap changer in p.u.
   */
  virtual double getCurrentRho() const = 0;
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNRATIOTAPCHANGERINTERFACE_H_
