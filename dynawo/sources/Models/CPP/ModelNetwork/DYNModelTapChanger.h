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

#include <vector>
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
   * @brief  unique constructor
   *
   * @param id : name of the tap changer
   * @param lowIndex : index of first step being kept inside model
   */
  inline explicit ModelTapChanger(const std::string& id, int lowIndex)
      : id_(id),
        currentStepIndex_(0),
        regulating_(false),
        fictitious_(false),
        lowStepIndex_(lowIndex),
        highStepIndex_(0),
        tFirst_(60),
        tNext_(10) {}

  /**
   * @brief  return the name of the tap changer
   * @return name of the tap changer
   */
  inline const std::string& id() const { return id_; }

  /**
   * @brief return the step associated to the index
   * @param index index
   * @return step associated to the index
   */
  inline const TapChangerStep& getStep(int index) const {
    try {
      return steps_.at(index - getLowStepIndex());
    } catch ( const std::out_of_range &) {
      throw DYNError(Error::MODELER, UndefinedStep, index, id_);
    }
  }

  /**
   * @brief  add a new TapChangerStep to the steps vector
   * @param step tap changer step
   */
  inline void addStep(const TapChangerStep& step) {
    steps_.push_back(step);
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
   * @param index step index
   */
  inline void setCurrentStepIndex(int index) { currentStepIndex_ = index; }

  /**
   * @brief   get the current step index
   * @return current step index
   */
  inline int getCurrentStepIndex() const { return currentStepIndex_; }

  /**
   * @brief   get the lowest step index
   * lowStepIndex_ is set by the ctor and cannot be changed
   * @return index
   */
  inline int getLowStepIndex() const { return lowStepIndex_; }

  /**
   * @brief   get the highest step index
   * @return index
   */
  inline int getHighStepIndex() const { return highStepIndex_; }

  /**
   * @brief  set the highest step index
   * @param index step index
   */
  inline void setHighStepIndex(int index) { highStepIndex_ = index; }

  /**
   * @brief get if the tap changer is regulating
   * @return regulating
   */
  inline bool getRegulating() const { return regulating_; }

  /**
   * @brief set if the tap changer is regulating
   * @param regulating regulating
   */
  inline void setRegulating(bool regulating) { regulating_ = regulating; }

  /**
   * @brief   get the time to wait before changing of step for the first time
   * @return time
   */
  inline double getTFirst() const { return tFirst_; }

  /**
   * @brief   set the time to wait before changing of step for the first time
   * @param time time
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
   * @param time time
   */
  inline void setTNext(double time) { tNext_ = time; }

  /**
   * @brief set fictitious property
   *
   * @param fictitious fictitious
   */
  inline void setFictitious(bool fictitious) { fictitious_ = fictitious; }

  /**
   * @brief wether the tap changer is fictitious
   * @return fictitious
   */
  inline bool isFictitious() const { return fictitious_; }

 private:
  std::string id_;  ///< id of the tap changer
  std::vector<TapChangerStep>
      steps_;             ///< vector of TapChangerStep
  int currentStepIndex_;  ///< index of the current step
  bool regulating_;       ///< is the tapChanger regulating ?
  bool fictitious_;       ///< wether the tap changer comes from an iidm object or not
  const int lowStepIndex_;      ///< Lowest step
  int highStepIndex_;     ///< Highest step
  double tFirst_;  ///< time to wait before changing of step for the first time
  double tNext_;   ///< time to wait before changing of step if it's not the
                   ///< first time
};                 // class ModelTapChanger
}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNMODELTAPCHANGER_H_
