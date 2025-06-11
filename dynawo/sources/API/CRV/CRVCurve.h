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
#ifndef API_CRV_CRVCURVE_H_
#define API_CRV_CRVCURVE_H_

#include "CRVPoint.h"

#include <limits>
#include <string>
#include <vector>
#include <memory>

namespace curves {
/**
 * @class Curve
 * @brief Curve interface class
 *
 * Interface class for curve object.
 */
class Curve {
 public:
  /**
   * @brief Constructor
   */
  Curve();

  /**
   * defined type of variables
   */
  typedef enum { UNDEFINED, CALCULATED_VARIABLE, DISCRETE_VARIABLE, CONTINUOUS_VARIABLE } CurveType_t;  ///< type on constraint

  /**
   * ways in which this curve can be exported
   */
  typedef enum { EXPORT_AS_CURVE, EXPORT_AS_FINAL_STATE_VALUE, EXPORT_AS_BOTH } ExportType_t;

  /**
   * @brief Add a new point to the curve
   * @param time time associated to the new point created
   */
  void update(const double& time);

  /**
   * @brief get last point value
   */
  double getLastValue() const;

  /**
   * @brief get last point time
   */
  double getLastTime() const;

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
   * @brief Set if the user wants to export this as curve
   * @param value a ExportType_t value saying whether we want to export a final state value, a curve or both.
   */
  void setExportType(ExportType_t value);

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
   * @brief curve is for variable or for parameter
   * @return @b true if parameter, @b false if variable
   */
  bool isParameterCurve() const {
    return isParameterCurve_;
  }

  /**
   * @brief The data the user wants out of this curve
   * @return ExportType_t value saying whether we want to export a final state value, a curve or both.
   */
  ExportType_t getExportType() const {
    return exportType_;
  }

  /**
   * @brief set curve for variable or curve for parameter
   * @param isParameterCurve @b true if curve for parameter, @b false else
   */
  void setAsParameterCurve(bool isParameterCurve) {
    isParameterCurve_ = isParameterCurve;
  }
  /**
   * @brief Get the curve type (calculated variable, continuous, discrete)
   * @return the curve type (calculated variable, continuous, discrete)
   */
  CurveType_t getCurveType() const {
    return curveType_;
  }

  /**
   * @brief Set the curve type (calculated variable, continuous, discrete)
   * @param curveType : curve type (calculated variable, continuous, discrete)
   */
  void setCurveType(CurveType_t curveType) {
    curveType_ = curveType;
  }

  /**
   * @brief update parameter curve value
   * @param parameterName name of parameter
   * @param parameterValue value of parameter
   */
  void updateParameterCurveValue(std::string parameterName, double parameterValue);

 public:
  /**
   * @class const_iterator
   * @brief Const iterator over points
   *
   * Const iterator over points stored in curve
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
    const_iterator(const Curve* iterated, bool begin);
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
    const_iterator(const Curve* iterated, bool begin, int i);

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
  std::string modelName_;  ///< Model's name for which we want have a curve
  std::string variable_;   ///< Variable name

  // attributes deduced from models
  std::string foundName_;                          ///< variable name found in models
  bool available_;                                 ///< @b true if the variable is available, @b false else
  bool negated_;                                   ///< @b true if the variable must be negated at the export, @b false else
  const double* buffer_;                           ///< address buffer where to find value
  std::vector<std::unique_ptr<Point> > points_;    ///< vector of each values
  bool isParameterCurve_;                          ///< @b true if a parameter curve, @b false if variable
  CurveType_t curveType_;                          ///< @b true if a calculated variable curve, @b false if variable
  size_t indexInGlobalTable_;                      ///< curve's index in global table

  ExportType_t exportType_;                        ///< Whether this should be exported as a final state value or as a curve
};

}  // namespace curves

#endif  // API_CRV_CRVCURVE_H_
