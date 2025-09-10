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
 * @file  DYNModelRatioTapChanger.h
 *
 * @brief Model of ratio tap changer : header file
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELRATIOTAPCHANGER_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELRATIOTAPCHANGER_H_

#include <sstream>

#include "DYNModelTapChanger.h"

namespace DYN {

/**
 * @brief ModelRatioTapChanger class
 */
class ModelRatioTapChanger : public ModelTapChanger {
 public:
  /**
   * @brief default constructor
   *
   * @param id : name of the tap changer
   * @param side : side where the voltage is controlled
   * @param lowIndex : lowest step index
   */
  explicit ModelRatioTapChanger(const std::string& id, const std::string& side, int lowIndex);

  /**
   * @brief destructor
   */
  virtual ~ModelRatioTapChanger();

  /**
   * @brief reset internal variables values
   */
  void resetInternalVariables();

  /**
   * @brief  evaluate the zero crossing functions
   *
   * @param t : time to use during the evaluation
   * @param uValue : voltage monitored by the tap changer
   * @param nodeOff : unused
   * @param g : value of the zero crossing function
   * @param disable : is the tap changer disabled ?
   * @param locked : is the tap changer locked ?
   * @param tfoClosed : is the transformer connected ?
   * @param deltaUTarget : delta to be added on target voltage
   */
  void evalG(double t, double uValue, bool nodeOff, state_g* g, double disable,
             double locked, bool tfoClosed, double deltaUTarget);

  /**
   * @brief  evaluate discrete values
   *
   * @param t : time to use during the evaluation
   * @param g : root values
   * @param network : network of the transformer
   * @param disable : is the tap changer disabled ?
   * @param nodeOff : is the node monitored by the tap changer off ?
   * @param locked : is the tap changer locked ?
   * @param tfoClosed :is the transformer connected ?
   */
  void evalZ(double t, state_g* g, ModelNetwork* network, double disable,
             bool nodeOff, double locked, bool tfoClosed);

  /**
   * @brief  get the size of the local G function
   * @return size of G function
   */
  inline int sizeG() const { return 4; }

  /**
   * @brief  get size of discrete variables
   * @return number of discrete variables
   */
  inline int sizeZ() const { return 0; }

  /**
   * @brief set the dead band around the target of the tap changer
   *
   * @param tolerance dead band to use
   */
  inline void setTolV(const double& tolerance) { tolV_ = tolerance; }

  /**
   * @brief set the target of the tap changer
   *
   * @param target target to use
   */
  inline void setTargetV(const double& target) { targetV_ = target; }

  /**
   * @brief get the current dead band of the tap changer
   * @return value of the current dead band
   */
  inline double getTolV() const { return tolV_; }

  /**
   * @brief set the reference side
   *
   * @param side reference side
   */
  inline void setSide(const std::string& side) { side_ = side; }

  /**
   * @brief append the internal variables values to a stringstream
   *
   * @param streamVariables : stringstream with binary formated internalVariables
   */
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const;

  /**
   * @brief import the internal variables values of the component from stringstream
   *
   * @param streamVariables : stringstream with binary formated internalVariables
   */
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables);

  /**
   * @brief get the number of internal variable of the model
   *
   * @return the number of internal variable of the model
   */
  unsigned getNbInternalVariables() const;


 private:
  /**
   * @brief decide whether if the tap changer should increase/decrease tap to increase the target U
   * @return @b true if one tap up increase the voltage
   */
  bool getUpIncreaseTargetU() const;

 private:
  std::string side_;  ///< reference side where the voltage is controlled
  double tolV_;       ///< dead band around targetV
  double targetV_;    ///< target voltage
  double latestUValue_;    ///< latest tested voltage value
  double whenUp_;  ///< when the voltage reached a value over the target+deadBand
  double whenDown_;     ///< when the voltage reached a value under the
                        ///< target-deadBand
  double whenLastTap_;  ///< last time when a tap changer
  bool moveUp_;         ///< @b true if tap should be increased
  bool moveDown_;       ///< @b false if tap should be decreased
  int tapRefDown_;      ///< initial tap when trying to decrease tap
  int tapRefUp_;        ///<  initial tap when trying to increase tap
  bool uMaxState_;      ///< @b true if U > uTarget + uDeadBand + deltaUTarget
  bool uMinState_;      ///< @b true if U < uTarget - uDeadBand + deltaUTarget
  bool uTargetState_;   ///< @b true if uTarget + deltaUTarget - uDeadBand < U < uTarget + deltaUTarget +
                        ///< uDeadBand
};
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELRATIOTAPCHANGER_H_
