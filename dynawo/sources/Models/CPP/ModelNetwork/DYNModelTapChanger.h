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
 * @file  DYNModelTapChanger.h
 *
 * @brief Model of tap changer : header file
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNMODELTAPCHANGER_H_
#define MODELS_CPP_MODELNETWORK_DYNMODELTAPCHANGER_H_

#include <map>
#include <string>

#include "DYNEnumUtils.h"
#include "DYNMacrosMessage.h"
#include "DYNModelTapChangerStep.h"

namespace DYN {
class ModelNetwork;

/**
 * @brief Generic tap-changer model
 */
class ModelTapChanger {
 public:
  /**
   * @brief default constructor
   *
   * @param id : name of the tap changer
   */
  inline explicit ModelTapChanger(const std::string& id)
      : id_(id),
        currentStepIndex_(0),
        regulating_(false),
        lowStepIndex_(0),
        highStepIndex_(0),
        tFirst_(60),
        tNext_(10) {}

  /**
   * @brief destructor
   */
  virtual ~ModelTapChanger() {}

  /**
   * @brief  return the name of the tap changer
   * @return name of the tap changer
   */
  inline const std::string& id() const { return id_; }

  /**
   * @brief return the step associated to the index
   * @param key associated to the index
   * @return step associated to the index
   */
  inline const TapChangerStep& getStep(int key) const {
    if (steps_.find(key) != steps_.end()) {
      return steps_.find(key)->second;
    } else {
      throw DYNError(Error::MODELER, UndefinedStep, key, id_);
    }
  }

  /**
   * @brief  add a new TapChangerStep to the steps vector
   * @param index
   * @param step
   */
  inline void addStep(int index, const TapChangerStep& step) {
    steps_[index] = step;
  }

  /**
   * @brief  get the current TapChangerStep object
   * @return tap changer step
   */
  inline const TapChangerStep& getCurrentStep() const {
    return getStep(currentStepIndex_);
  }

  /**
   * @brief  return the name of the tap changer
   * @return name of the tap changer
   */
  inline size_t size() const { return steps_.size(); }

  /**
   * @brief  set the current step to a new index
   * @param index
   */
  inline void setCurrentStepIndex(int index) { currentStepIndex_ = index; }

  /**
   * @brief   get the current step index
   * @return current step index
   */
  inline int getCurrentStepIndex() const { return currentStepIndex_; }

  /**
   * @brief   get the lowest step index
   * @return index
   */
  inline int getLowStepIndex() const { return lowStepIndex_; }

  /**
   * @brief   set the lowest step index
   * @param index
   */
  inline void setLowStepIndex(int index) { lowStepIndex_ = index; }

  /**
   * @brief   get the highest step index
   * @return index
   */
  inline int getHighStepIndex() const { return highStepIndex_; }

  /**
   * @brief  set the highest step index
   * @param index
   */
  inline void setHighStepIndex(int index) { highStepIndex_ = index; }

  /**
   * @brief get if the tap changer is regulating
   * @return regulating
   */
  inline bool getRegulating() const { return regulating_; }

  /**
   * @brief set if the tap changer is regulating
   * @param regulating
   */
  inline void setRegulating(bool regulating) { regulating_ = regulating; }

  /**
   * @brief   get the time to wait before changing of step for the first time
   * @return time
   */
  inline double getTFirst() const { return tFirst_; }

  /**
   * @brief   set the time to wait before changing of step for the first time
   * @param time
   */
  inline void setTFirst(double time) { tFirst_ = time; }

  /**
   * @brief   get the time to wait before changing of step if it's not the first
   * time
   * @return time
   */
  inline double getTNext() const { return tNext_; }

  /**
   * @brief  set the time to wait before changing of step if it's not the first
   * time
   * @param time
   */
  inline void setTNext(double time) { tNext_ = time; }

 public:
  /**
   * @brief evaluate the zero crossing functions
   * @param t time to use during the evaluation
   * @param valueMonitored : value monitored by the tap changer
   * @param nodeOff : is the node monitored by the tap changer off ?
   * @param g : value of the zero crossing function
   * @param disable : is the tap changer disabled ?
   * @param locked : is the tap changer locked ?
   * @param tfoClosed : is the transformer connected ?
   */
  virtual void evalG(double /* t */, double /* valueMonitored */, bool /* nodeOff */, state_g* /* g */,
                     double /* disable */, double /* locked */, bool /* tfoClosed */) {
    // not needed
  }

  /**
   * @brief  evaluate discrete values
   * @param t time to use during the evaluation
   * @param g: root values
   * @param network : network of the transformer
   * @param disable : is the tap changer disabled ?
   * @param nodeOff : is the node monitored by the tap changer off ?
   * @param locked : is the tap changer locked ?
   * @param tfoClosed :is the transformer connected ?
   */
  virtual void evalZ(double /* t */, state_g* /* g */, ModelNetwork* /* network */,
                     double /* disable */, bool /* nodeOff */, double /* locked */,
                     bool /* tfoClosed */) {
    // not needed
  }

  /**
   * @brief  get the size of the local G function
   * @return size of G function
   */
  virtual int sizeG() const { return 0; }

  /**
   * @brief  get size of discrete variables
   * @return number of discrete variables
   */
  virtual int sizeZ() const { return 0; }

 private:
  std::string id_;  ///< id of the tap changer
  std::map<int, TapChangerStep>
      steps_;             ///< map of TapChangerStep : index -> step
  int currentStepIndex_;  ///< index of the current step
  bool regulating_;       ///< is the tapChanger regulating ?
  int lowStepIndex_;      ///< Lowest step
  int highStepIndex_;     ///< Highest step
  double tFirst_;  ///< time to wait before changing of step for the first time
  double tNext_;   ///< time to wait before changing of step if it's not the
                   ///< first time
};                 // class ModelTapChanger
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELTAPCHANGER_H_
