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
 * @file  DYNModelPhaseTapChanger.h
 *
 * @brief Model of phase tap changer : header file
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELPHASETAPCHANGER_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELPHASETAPCHANGER_H_

#include "DYNModelTapChanger.h"

namespace DYN {

/**
 * @brief ModelPhaseTapChanger class
 */
class ModelPhaseTapChanger : public ModelTapChanger {
 public:
  /**
   * @brief default constructor
   *
   * @param id : name of the tap changer
   */
  explicit ModelPhaseTapChanger(const std::string& id);

  /**
   * @brief destructor
   */
  ~ModelPhaseTapChanger();

  /**
   * @brief  evaluate the zero crossing functions
   *
   * @param t : time to use during the evaluation
   * @param iValue: current monitored by the tap changer
   * @param nodeOff: unused
   * @param g : value of the zero crossing function
   * @param disable : is the tap changer disabled ?
   * @param locked : is the tap changer locked ?
   * @param tfoClosed : is the transformer connected ?
   */
  void evalG(double t, double iValue, bool nodeOff, state_g* g, double disable, double locked, bool tfoClosed);

  /**
   * @brief  evaluate discrete values
   * @param t time to use during the evaluation
   * @param g: root values
   * @param network : network of the transformer
   * @param disable : is the tap changer disabled ?
   * @param P1SupP2 : is the active power evaluated at side 1 is superior to the active power evaluated at side 2  ?
   * @param locked : is the tap changer locked ?
   * @param tfoClosed :is the transformer connected ?
   */
  void evalZ(double t, state_g* g, ModelNetwork* network, double disable, bool P1SupP2, double locked, bool tfoClosed);

  /**
   * @copydoc ModelTapChanger::sizeG()
   */
  int sizeG() const;

  /**
   * @copydoc ModelTapChanger::sizeZ()
   */
  int sizeZ() const;

  /**
   * @brief set the current threshold over which the current should not go
   *
   * @param threshold current threshold
   */
  void setThresholdI(const double& threshold);

 private:
  /**
   * @brief decide whether we should increase/decrease tap depending on tap description and power flow
   * @param P1SupP2 @b true if P at side 1 is superior to P at side 2
   * @return @b true if a tap up increase the phase
   */
  bool getIncreaseTap(bool P1SupP2);

 private:
  double thresholdI_;  ///< threshold of I
  double whenUp_;  ///< when the current reached a value over the threshold
  double whenDown_;  ///< when the current reached a value under the threshold
  double whenLastTap_;  ///< last time when a tap changer
  bool moveUp_;  ///< @b true if tap should be increased
  bool moveDown_;  ///< @b false if tap should be decreased
  int tapRefDown_;  ///< initial tap when trying to decrease tap
  int tapRefUp_;  ///<  initial tap when trying to increase tap
  bool currentOverThresholdState_;  ///< @b true if the current is over the threshold
};
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELPHASETAPCHANGER_H_
