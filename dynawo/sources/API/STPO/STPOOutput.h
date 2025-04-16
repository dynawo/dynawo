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
 * @file  STPOOutput.h
 *
 * @brief Dynawo output : interface file
 *
 */
#ifndef API_STPO_STPOOUTPUT_H_
#define API_STPO_STPOOUTPUT_H_

#include "STPOPoint.h"

#include <limits>
#include <string>
#include <vector>
#include <memory>

namespace stepOutputs {
/**
 * @class Output
 * @brief Output interface class
 *
 * Interface class for output object.
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

  // /**
  //  * ways in which this output can be exported
  //  */
  // typedef enum { EXPORT_AS_CURVE, EXPORT_AS_FINAL_STATE_VALUE, EXPORT_AS_BOTH } ExportType_t;

  /**
   * @brief Add a new point to the output
   * @param time time associated to the new point created
   */
  void update(const double& time);

  /**
   * @brief get last point value
   */
  std::unique_ptr<Point> getLastPoint() const;

  /**
   * @brief Setter for output's model name
   * @param modelName output's model name
   */
  void setModelName(const std::string& modelName);

  /**
   * @brief Setter for output's variable
   * @param variable output's variable
   */
  void setVariable(const std::string& variable);

  /**
   * @brief Setter for output's name found
   * @param name output's name found
   */
  void setFoundVariableName(const std::string& name);

  /**
   * @brief Setter for output's available attribute
   * @param isAvailable @b true if output is available, @b false else
   */
  void setAvailable(bool isAvailable);

  /**
   * @brief Setter for output's negated attribute
   * @param negated @b true if the variable must be negated at the export, @b false else
   */
  void setNegated(bool negated);

  /**
   * @brief Setter for output's buffer
   * @param buffer buffer where the output should find the value to store
   */
  void setBuffer(const double* buffer);

  /**
   * @brief Setter for output's index in global table
   * @param index output's index in global table
   */
  void setGlobalIndex(size_t index);

  /**
   * @brief Set if the user wants to export this as output
   * @param value a ExportType_t value saying whether we want to export a final state value, a output or both.
   */
  void setExportType(ExportType_t value);

  /**
   * @brief Getter for output's index in global table
   * @return index output's index in global table
   */
  size_t getGlobalIndex();

  /**
   * @brief Getter for output's model name
   * @return model name associated to this output
   */
  const std::string& getModelName() const;

  /**
   * @brief Getter for output's variable
   * @return variable name associated to this output
   */
  const std::string& getVariable() const;

  /**
   * @brief Getter for output's found variable name
   * @return variable name found in model associated to this output
   */
  const std::string& getFoundVariableName() const;

  /**
   * @brief Getter for output's available attribute
   * @return @b true if output is available, @b false else
   */
  bool getAvailable() const;

  /**
   * @brief Getter for output's negated attribute
   * @return @b true if the variable must be negated at the export, @b false else
   */
  bool getNegated() const;

  /**
   * @brief Getter for output's buffer
   * @return buffer where the output should find the value to store
   */
  const double* getBuffer() const;

  /**
   * @brief output is for variable or for parameter
   * @return @b true if parameter, @b false if variable
   */
  bool isParameterOutput() const {
    return isParameterOutput_;
  }

  /**
   * @brief The data the user wants out of this output
   * @return ExportType_t value saying whether we want to export a final state value, a output or both.
   */
  ExportType_t getExportType() const {
    return exportType_;
  }

  /**
   * @brief set output for variable or output for parameter
   * @param isParameterOutput @b true if output for parameter, @b false else
   */
  void setAsParameterOutput(bool isParameterOutput) {
    isParameterOutput_ = isParameterOutput;
  }
  /**
   * @brief Get the output type (calculated variable, continuous, discrete)
   * @return the output type (calculated variable, continuous, discrete)
   */
  OutputType_t getOutputType() const {
    return outputType_;
  }

  /**
   * @brief Set the output type (calculated variable, continuous, discrete)
   * @param outputType : output type (calculated variable, continuous, discrete)
   */
  void setOutputType(OutputType_t outputType) {
    outputType_ = outputType;
  }

  /**
   * @brief update parameter output value
   * @param parameterName name of parameter
   * @param parameterValue value of parameter
   */
  void updateParameterOutputValue(std::string parameterName, double parameterValue);

 public:
  /**
   * @class const_iterator
   * @brief Const iterator over points
   *
   * Const iterator over points stored in output
   */
  class const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on points. Can create an iterator to the
     * beginning of the points' container or to the end. Points
     * cannot be modified.
     *
     * @param iterated Pointer to the points' vector iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the points' container.
     */
    const_iterator(const Output* iterated, bool begin);
    /**
     * @brief Constructor
     *
     * Constructor based on points. Can create an iterator to the
     * beginning of the points' container or to the end. Points
     * cannot be modified.
     *
     * @param iterated Pointer to the points' vector iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the points' container.
     * @param i Relative position of the iterator comparing to the beginning (true) or the ending (false)
     */
    const_iterator(const Output* iterated, bool begin, int i);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this const_iterator
     */
    const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this const_iterator
     */
    const_iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this const_iterator
     */
    const_iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this const_iterator
     */
    const_iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Point pointed to by this
     */
    const std::unique_ptr<Point>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the Point pointed to by this
     */
    const std::unique_ptr<Point>* operator->() const;

   private:
    std::vector<std::unique_ptr<Point> >::const_iterator current_;  ///< current vector const iterator
  };

  /**
   * @brief Get a const_iterator to the beginning of points' container
   * @return a const_iterator to the beginning of points' container
   */
  const_iterator cbegin() const;

  /**
   * @brief Get a const_iterator to the end of points' container
   * @return a const_iterator to the end of points' container
   */
  const_iterator cend() const;

  /**
   * @brief Get a const_iterator at the i th position points' container
   * @param i : position of the const_iterator to get
   *
   * @return a const_iterator at the i th position points' container
   */
  const_iterator at(int i) const;

 private:
  // attributes read in input file
  std::string modelName_;  ///< Model's name for which we want have a output
  std::string variable_;   ///< Variable name
  std::string alias_;      ///< Alias for variable name in output

  // attributes deduced from models
  std::string foundName_;                          ///< variable name found in models
  bool available_;                                 ///< @b true if the variable is available, @b false else
  bool negated_;                                   ///< @b true if the variable must be negated at the export, @b false else
  const double* buffer_;                           ///< address buffer where to find value
  // std::vector<std::unique_ptr<Point> > points_;    ///< vector of each values
  // bool isParameterOutput_;                          ///< @b true if a parameter output, @b false if variable
  OutputType_t outputType_;                          ///< @b true if a calculated variable output, @b false if variable
  size_t indexInGlobalTable_;                      ///< output's index in global table

  // ExportType_t exportType_;                        ///< Whether this should be exported as a final state value or as a output
};

}  // namespace stepOutputs

#endif  // API_STPO_STPOOUTPUT_H_
