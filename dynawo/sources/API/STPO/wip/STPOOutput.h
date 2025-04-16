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
 * @file  CRVCurve.h
 *
 * @brief Dynawo curve : interface file
 *
 */
#ifndef API_STPO_STPOOUTPUT_H_
#define API_STPO_STPOOUTPUT_H_


// #include <limits>
// #include <string>
// #include <vector>
// #include <memory>

#include "make_unique.hpp"

namespace stepOutputs {

 /**
  * @class OutputFactory
  * @brief Output factory class
  *
  * OutputFactory encapsulates methods for creating new
  * @p Output objects.
  */
class OutputFactory {
 public:
  /**
  * @brief Create new Output instance
  *
  * @returns a unique pointer to a new @p Output
  */
  static std::unique_ptr<Output> newOutput();
};

 /**
 * @class Output
 * @brief Output interface class
 *
 * class for output object.
 */
class Output {
 public:
  /**
   * @brief Constructor
   */
  Output();

  /**
   * defined type of variables
   */
  typedef enum { UNDEFINED, CALCULATED_VARIABLE, DISCRETE_VARIABLE, CONTINUOUS_VARIABLE } OutputType_t;  ///< type on constraint

  /**
   * @brief Get current value
   */
  double getValue();

  /**
   * @brief Setter for curve's model name
   * @param modelName curve's model name
   */
  void setModelName(const std::string& modelName);

  /**
   * @brief Setter for curve's variable
   * @param variable curve's variable
   */
  void setVariable(const std::string& variable);

  /**
   * @brief Setter for curve's name found
   * @param name curve's name found
   */
  void setFoundVariableName(const std::string& name);

  /**
   * @brief Setter for curve's available attribute
   * @param isAvailable @b true if curve is available, @b false else
   */
  void setAvailable(bool isAvailable);

  /**
   * @brief Setter for curve's negated attribute
   * @param negated @b true if the variable must be negated at the export, @b false else
   */
  void setNegated(bool negated);

  /**
   * @brief Setter for curve's buffer
   * @param buffer buffer where the curve should find the value to store
   */
  void setBuffer(const double* buffer);

  /**
   * @brief Setter for curve's index in global table
   * @param index curve's index in global table
   */
  void setGlobalIndex(size_t index);

  /**
   * @brief Getter for curve's index in global table
   * @return index curve's index in global table
   */
  size_t getGlobalIndex();

  /**
   * @brief Getter for curve's model name
   * @return model name associated to this curve
   */
  const std::string& getModelName() const;

  /**
   * @brief Getter for curve's variable
   * @return variable name associated to this curve
   */
  const std::string& getVariable() const;

  /**
   * @brief Getter for curve's found variable name
   * @return variable name found in model associated to this curve
   */
  const std::string& getFoundVariableName() const;

  /**
   * @brief Getter for curve's available attribute
   * @return @b true if curve is available, @b false else
   */
  bool getAvailable() const;

  /**
   * @brief Getter for curve's negated attribute
   * @return @b true if the variable must be negated at the export, @b false else
   */
  bool getNegated() const;

  /**
   * @brief Getter for curve's buffer
   * @return buffer where the curve should find the value to store
   */
  const double* getBuffer() const;


  /**
   * @brief Get the curve type (calculated variable, continuous, discrete)
   * @return the curve type (calculated variable, continuous, discrete)
   */
  OutputType_t getOutputType() const {
    return outputType_;
  }

  /**
   * @brief Set the curve type (calculated variable, continuous, discrete)
   * @param outputType : curve type (calculated variable, continuous, discrete)
   */
  void setOutputType(OutputType_t outputType) {
    outputType_ = outputType;
  }

  // /**
  //  * @brief update parameter curve value
  //  * @param parameterName name of parameter
  //  * @param parameterValue value of parameter
  //  */
  // void updateParameterCurveValue(std::string parameterName, double parameterValue);

 private:
  std::string modelName_;        ///< Model's name for which we want have a curve
  std::string variable_;         ///< Variable name
  std::string alias_;            ///< Variable alias
  bool available_;               ///< @b true if the variable is available, @b false else
  bool negated_;                 ///< @b true if the variable must be negated at the export, @b false else
  const double* buffer_;         ///< address buffer where to find value
  double value_;                 ///< value snapshot at time time
  double time_;                  ///< time of value snapshot
  OutputType_t outputType_;      ///< @b true if a calculated variable curve, @b false if variable
  size_t indexInGlobalTable_;    ///< curve's index in global table
};

}  // namespace stepOutputs

#endif  // API_STPO_STPOOUTPUT_H_
