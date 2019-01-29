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

#include <string>
#include <boost/shared_ptr.hpp>

#include "CRVExport.h"

namespace curves {
class Point;

/**
 * @class Curve
 * @brief Curve interface class
 *
 * Interface class for curve object.
 */
class __DYNAWO_CRV_EXPORT Curve {
 public:
  /**
   * @brief Destructor
   */
  virtual ~Curve() { }

  /**
   * @brief Add a new point to the curve
   * @param time time associated to the new point created
   */
  virtual void update(const double& time) = 0;

  /**
   * @brief Setter for curve's model name
   * @param modelName curve's model name
   */
  virtual void setModelName(const std::string& modelName) = 0;

  /**
   * @brief Setter for curve's variable
   * @param variable curve's variable
   */
  virtual void setVariable(const std::string& variable) = 0;

  /**
   * @brief Setter for curve's name found
   * @param name curve's name found
   */
  virtual void setFoundVariableName(const std::string& name) = 0;

  /**
   * @brief Setter for curve's available attribute
   * @param isAvailable @b true if curve is available, @b false else
   */
  virtual void setAvailable(bool isAvailable) = 0;

  /**
   * @brief Setter for curve's negated attribute
   * @param negated @b true if the variable must be negated at the export, @b false else
   */
  virtual void setNegated(bool negated) = 0;

  /**
   * @brief Setter for curve's buffer
   * @param buffer buffer where the curve should find the value to store
   */
  virtual void setBuffer(double* buffer) = 0;

  /**
   * @brief Getter for curve's model name
   * @return model name associated to this curve
   */
  virtual std::string getModelName() const = 0;

  /**
   * @brief Getter for curve's variable
   * @return variable name associated to this curve
   */
  virtual std::string getVariable() const = 0;

  /**
   * @brief Getter for curve's found variable name
   * @return variable name found in model associated to this curve
   */
  virtual std::string getFoundVariableName() const = 0;

  /**
   * @brief Getter for curve's available attribute
   * @return @b true if curve is available, @b false else
   */
  virtual bool getAvailable() const = 0;

  /**
   * @brief Getter for curve's negated attribute
   * @return @b true if the variable must be negated at the export, @b false else
   */
  virtual bool getNegated() const = 0;

  /**
   * @brief Getter for curve's buffer
   * @return buffer where the curve should find the value to store
   */
  virtual double* getBuffer() const = 0;

  /**
   * @brief curve is for variable or for parameter
   * @return @b true if parameter, @b false if variable
   */
  virtual bool isParameterCurve() const = 0;

  /**
   * @brief set curve for variable or curve for parameter
   * @param isParameterCurve @b true if curve for parameter, @b false else
   */
  virtual void setAsParameterCurve(bool isParameterCurve) = 0;

  /**
   * @brief Get if curve is a calculated variable curve
   * @return @b true if the curve is a calculated variable curve
   */
  virtual bool isCalculatedVariableCurve() const = 0;

  /**
   * @brief Set curve as a calculated variable curve
   * @param isCalculatedVariableCurve : @b true if the curve is a calculated variable curve, @b false otherwise
   */
  virtual void setAsCalculatedVariableCurve(bool isCalculatedVariableCurve) = 0;

  /**
   * @brief update parameter curve value
   * @param parameterName
   * @param parameterValue
   */
  virtual void updateParameterCurveValue(std::string parameterName, double parameterValue) = 0;

  class Impl;

 protected:
  class BaseConstIteratorImpl;  // Abstract class for the interface

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
     * @returns Created const_iterator.
     */
    const_iterator(const Curve::Impl* iterated, bool begin);
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
     * @returns Created const_iterator.
     */
    const_iterator(const Curve::Impl* iterated, bool begin, int i);

    /**
     * @brief Copy constructor
     * @param original : const_iterator to copy
     */
    const_iterator(const const_iterator& original);

    /**
     * @brief Destructor
     */
    ~const_iterator();

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
    const boost::shared_ptr<Point>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the Point pointed to by this
     */
    const boost::shared_ptr<Point>* operator->() const;

   private:
    BaseConstIteratorImpl* impl_;  ///<  Pointer to the implementation of the const iterator
  };

  /**
   * @brief Get a const_iterator to the beginning of points' container
   * @return a const_iterator to the beginning of points' container
   */
  virtual const_iterator cbegin() const = 0;

  /**
   * @brief Get a const_iterator to the end of points' container
   * @return a const_iterator to the end of points' container
   */
  virtual const_iterator cend() const = 0;

  /**
   * @brief Get a const_iterator at the i th position points' container
   * @param i : position of the const_iterator to get
   *
   * @return a const_iterator at the i th position points' container
   */
  virtual const_iterator at(int i) const = 0;
};

}  // namespace curves

#endif  // API_CRV_CRVCURVE_H_
