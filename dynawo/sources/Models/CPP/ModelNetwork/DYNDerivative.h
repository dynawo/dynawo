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
 * @file  DYNDerivative.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_MODELNETWORK_DYNDERIVATIVE_H_
#define MODELS_CPP_MODELNETWORK_DYNDERIVATIVE_H_

#include <map>
#include <unordered_map>

namespace DYN {
// Structure dedicated to the network Jacobian filling
// -------------------------------------------------------

/**
 * define derivative Ir, Ii type
 */
typedef enum {
  IR_DERIVATIVE = 0,
  II_DERIVATIVE = 1
} typeDerivative_t;

/**
 * class Derivatives
 */
class Derivatives {
 public:
  /**
   * @brief reset
   */
  void reset();

  void init();

  /**
   * @brief add value
   * @param numVar number of variable
   * @param value value
   */
  void addValue(int numVar, double value);

  /**
   * @brief get values
   * @return map of variables' values
   */
  /*inline const std::unordered_map<int, double>& getValues() const {
    return values_;
  }*/
  inline const std::vector<double>& getValues() const {
    return values_;
  }

  inline const std::vector<int>& getIndices() const {
    return indices_;
  }

  /**
   * @brief state whether empty
   * @return @b empty
   */
  inline bool empty() const {
    return values_.empty();
  }

 private:
  // values_->first : num of the variable
  // values_->second: value of the derivative
  // @I/@Y[values_->first]= values_->second
  // std::unordered_map<int, double> values_;  ///< associated num var with value of the derivative
  std::vector<double> values_;
  std::vector<int> indices_;
};

/**
 * class Bus Derivatives
 */
class BusDerivatives {
 public:
  /**
   * @brief reset
   */
  void reset();

  void init();

  /**
   * @brief add derivative
   *
   * @param type derivative type
   * @param numVar number of variable
   * @param value number of value
   */
  void addDerivative(typeDerivative_t type, int numVar, double value);

  /**
   * @brief get values
   * @param type type of derivatives
   * @return map of variables' values
   */
  // const std::unordered_map<int, double>& getValues(typeDerivative_t type) const;

  const std::vector<double>& getValues(typeDerivative_t type) const;

  const std::vector<int>& getIndices(typeDerivative_t type) const;

  /**
   * @brief state whether empty
   * @return @b empty_
   */
  inline bool empty() const {
    return irDerivatives_.empty() && iiDerivatives_.empty();
  }

  /**
   * @brief get values
   * @param type derivative type
   * @return Derivatives of variables' values
   */
  Derivatives& getDerivatives(typeDerivative_t type);

 private:
  Derivatives irDerivatives_;  ///< ir derivative
  Derivatives iiDerivatives_;  ///< ii derivative
};  ///< Class for Derivative elements of Bus Model

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNDERIVATIVE_H_
