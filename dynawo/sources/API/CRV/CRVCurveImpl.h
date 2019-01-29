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
 * @file  CRVCurveImpl.h
 *
 * @brief Dynawo curve : header file
 *
 */
#ifndef API_CRV_CRVCURVEIMPL_H_
#define API_CRV_CRVCURVEIMPL_H_

#include <vector>
#include <boost/shared_ptr.hpp>
#include "CRVCurve.h"

namespace curves {
class Point;

/**
 * @class Curve::Impl
 * @brief Curve implemented class
 *
 * Implementation of curve interface class
 */
class Curve::Impl : public Curve {
 public:
  /**
   * @brief Constructor
   */
  Impl();

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @brief Add a new point to the curve
   * @param time time associated to the new point created
   */
  void update(const double& time);

  /**
   * @copydoc Curve::setModelName(const std::string& modelName)
   */
  void setModelName(const std::string& modelName);

  /**
   * @copydoc Curve::setVariable(const std::string& variable)
   */
  void setVariable(const std::string& variable);

  /**
   * @copydoc Curve::setFoundVariableName(const std::string& name)
   */
  void setFoundVariableName(const std::string& name);

  /**
   * @copydoc Curve::setAvailable(bool isAvailable)
   */
  void setAvailable(bool isAvailable);

  /**
   * @copydoc Curve::setNegated(bool negated)
   */
  void setNegated(bool negated);

  /**
   * @copydoc Curve::setBuffer(double* buffer)
   */
  void setBuffer(double* buffer);

  /**
   * @copydoc Curve::getModelName()
   */
  std::string getModelName() const;

  /**
   * @copydoc Curve::getVariable()
   */
  std::string getVariable() const;

  /**
   * @copydoc Curve::getFoundVariableName()
   */
  std::string getFoundVariableName() const;

  /**
   * @copydoc Curve::getAvailable()
   */
  bool getAvailable() const;

  /**
   * @copydoc Curve::getNegated()
   */
  bool getNegated() const;

  /**
   * @copydoc Curve::getBuffer()
   */
  double* getBuffer() const;

  /**
   * @brief Get a const_iterator to the beginning of points' container
   * @return a const_iterator to the beginning of points' container
   */
  virtual const_iterator cbegin() const;

  /**
   * @brief Get a const_iterator to the end of points' container
   * @return a const_iterator to the end of points' container
   */
  virtual const_iterator cend() const;

  /**
   * @brief Get a const_iterator at the i th position points' container
   * @param i : position of the const_iterator to get
   * @return a const_iterator at the i th position points' container
   */
  virtual const_iterator at(int i) const;

  /**
   * @brief Get if curve is a parameter curve
   * @return @b true if the curve is a parameter curve
   */
  bool isParameterCurve() const {
    return isParameterCurve_;
  }

  /**
   * @brief Set curve as a parameter curve or a variable curve
   * @param isParameterCurve : @b true if the curve is a parameter curve, @b false otherwise
   */
  void setAsParameterCurve(bool isParameterCurve) {
    isParameterCurve_ = isParameterCurve;
  }

  /**
   * @brief Get if curve is a calculated variable curve
   * @return @b true if the curve is a calculated variable curve
   */
  bool isCalculatedVariableCurve() const {
    return isCalculatedVariableCurve_;
  }

  /**
   * @brief Set curve as a calculated variable curve
   * @param isCalculatedVariableCurve : @b true if the curve is a calculated variable curve, @b false otherwise
   */
  void setAsCalculatedVariableCurve(bool isCalculatedVariableCurve) {
    isCalculatedVariableCurve_ = isCalculatedVariableCurve;
  }

  /**
   * @brief Update parameter curve value
   * @param parameterName name of the paramater to plot
   * @param parameterValue value of the parameter
   */
  void updateParameterCurveValue(std::string parameterName, double parameterValue);

  friend class Curve::BaseConstIteratorImpl;

 private:
  // attributes read in input file
  std::string modelName_;  ///< Model's name for which we want have a curve
  std::string variable_;  ///< Variable name

  // attributes deduced from models
  std::string foundName_;  ///< variable name found in models
  bool available_;  ///< @b true if the variable is available, @b false else
  bool negated_;  ///< @b true if the variable must be negated at the export, @b false else
  double *buffer_;  ///< adress buffer where to find value
  std::vector<boost::shared_ptr<Point> > points_;  ///< vector of each values
  bool isParameterCurve_;  ///< @b true if a parameter curve, @b false if variable
  bool isCalculatedVariableCurve_;  ///< @b true if a calculated variable curve, @b false if variable
};

/**
 * @class Curve::BaseConstIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class Curve::BaseConstIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on curve. Can create an implementation for
   * an iterator to the beginning of the points' container or to the end.
   *
   * @param iterated Pointer to the points' set iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the points' container.
   * @returns Created implementation object
   */
  BaseConstIteratorImpl(const Curve::Impl* iterated, bool begin);
  /**
   * @brief Constructor
   *
   * Constructor based on curve. Can create an implementation for
   * an iterator to the beginning of the points' container or to the end.
   *
   * @param iterated Pointer to the points' set iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the points' container.
   * @param i index of curve
   * @returns Created implementation object
   */
  BaseConstIteratorImpl(const Curve::Impl* iterated, bool begin, int i);
  /**
   * @brief Destructor
   */
  ~BaseConstIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this const_iterator
   */
  BaseConstIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this const_iterator
   */
  BaseConstIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Reference to this const_iterator
   */
  BaseConstIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this const_iterator
   */
  BaseConstIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseConstIteratorImpl& other)const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseConstIteratorImpl& other)const;

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
  std::vector<boost::shared_ptr<Point> >::const_iterator current_;  ///< current vector const iterator
};
}  // end of namespace curves

#endif  // API_CRV_CRVCURVEIMPL_H_

