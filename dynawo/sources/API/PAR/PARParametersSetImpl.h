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
 * @file PARParametersSetImpl.h
 * @brief Dynawo parameters set : header file
 *
 */

#ifndef API_PAR_PARPARAMETERSSETIMPL_H_
#define API_PAR_PARPARAMETERSSETIMPL_H_

#include <map>
#include <vector>

#include <boost/shared_ptr.hpp>
#include <boost/unordered_map.hpp>

#include "PARParametersSet.h"
#include "PARParameter.h"
#include "PARReference.h"

namespace parameters {

/**
 * @class ParametersSet::Impl
 * @brief Parameters set implemented class
 *
 * Implementation of ParametersSet interface class
 */
class ParametersSet::Impl : public ParametersSet {
 public:
  /**
   * @brief constructor
   *
   * @param id id of the set of parameters
   */
  explicit Impl(const std::string& id);

  /**
   * @brief Destructor
   */
  ~Impl();

  /**
   * @copydoc ParametersSet::getId()
   */
  const std::string& getId() const;

  /**
   * @copydoc ParametersSet::getFilePath()
   */
  const std::string& getFilePath() const;

  /**
   * @copydoc ParametersSet::setFilePath()
   */
  void setFilePath(const std::string& filepath);

  /**
   * @copydoc ParametersSet::createAlias(const std::string& aliasName, const std::string& origName)
   */
  boost::shared_ptr<ParametersSet> createAlias(const std::string& aliasName, const std::string& origName);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const bool value)
   */
  boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const bool value);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const int value)
   */
  boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const int value);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const double value)
   */
  boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const double value);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const std::string& value)
   */
  boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const std::string& value);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const bool value, const std::string& row, const std::string& column)
   */
  boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const bool value, const std::string& row, const std::string& column);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const int value, const std::string& row, const std::string& column)
   */
  boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const int value, const std::string& row, const std::string& column);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const double value, const std::string& row, const std::string& column)
   */
  boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const double value, const std::string& row, const std::string& column);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const std::string& value, const std::string& row, const std::string& column)
   */
  boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const std::string& value, const std::string& row, const std::string& column);

  /**
   * @copydoc ParametersSet::createParameter(const std::string& name, const std::string& value, const std::string& row, const std::string& column)
   */
  template<typename T>
  boost::shared_ptr<ParametersSet> addParameter(const std::string& name, T value, const std::string& row, const std::string& column) {
    const std::vector<std::string>& parNames = tableParameterNames(name, row, column);
    std::string firstParName;
    bool isFirstParName = true;
    for (std::vector<std::string>::const_iterator itName = parNames.begin(); itName != parNames.end(); ++itName) {
      const std::string itParName = *itName;
      if (isFirstParName) {
        createParameter(itParName, value);
        firstParName = itParName;
        isFirstParName = false;
      } else {
        createAlias(itParName, firstParName);
      }
    }

    return shared_from_this();
  }

  /**
   * @copydoc ParametersSet::addParameter(const boost::shared_ptr<Parameter>& param)
   */
  boost::shared_ptr<ParametersSet> addParameter(const boost::shared_ptr<Parameter>& param);

  /**
   * @copydoc ParametersSet::addReference(boost::shared_ptr<Reference> ref)
   */
  boost::shared_ptr<ParametersSet> addReference(boost::shared_ptr<Reference> ref);

  /**
   * @brief Get a parameter from the parameters set
   *
   * Get the parameter with given name in the parameter set
   *
   * @param name : Name of the parameter
   * @returns Shared pointer to the parameter
   * @throws API exception if the parameter is not found
   */
  const boost::shared_ptr<Parameter> getParameter(const std::string& name) const;

  /**
   * @brief Get a reference from the parameters set
   *
   * Get the reference with given name in the parameter set
   *
   * @param name : Name of the reference
   * @returns Shared pointer to the reference
   * @throws API exception if the reference is not found
   */
  const boost::shared_ptr<Reference> getReference(const std::string& name) const;

  /**
   * @copydoc ParametersSet::hasParameter()
   */
  bool hasParameter(const std::string& name) const;

  /**
   * @copydoc ParametersSet::hasReference()
   */
  bool hasReference(const std::string& name) const;

  /**
   * @copydoc ParametersSet::extend()
   */
  void extend(boost::shared_ptr<ParametersSet> parametersSet);

  /**
   * @copydoc ParametersSet::getParametersNames()
   */
  std::vector<std::string> getParametersNames() const;

  /**
   * @copydoc ParametersSet::getParamsUnused()
   */
  std::vector<std::string> getParamsUnused() const;

  /**
   * @copydoc ParametersSet::getReferencesNames()
   */
  std::vector<std::string> getReferencesNames() const;

  /**
   * @copydoc ParametersSet::getParameters()
   */
  std::map<std::string, boost::shared_ptr<Parameter> >& getParameters();

  /**
   * @copydoc ParametersSet::cbeginParameter()
   */
  parameter_const_iterator cbeginParameter() const;

  /**
   * @copydoc ParametersSet::cendParameter()
   */
  parameter_const_iterator cendParameter() const;

  /**
   * @copydoc ParametersSet::cbeginReference()
   */
  reference_const_iterator cbeginReference() const;

  /**
   * @copydoc ParametersSet::cendReference()
   */
  reference_const_iterator cendReference() const;

  friend class ParametersSet::BaseIteratorImpl;
  friend class ParametersSet::BaseIteratorRefImpl;

 private:
  /**
   * @brief Constructor
   */
#ifdef LANG_CXX11
  Impl() = delete;
#else
  Impl();
#endif

  /**
   * @brief generate the table parameter names (used as identifier inside the list of all parameters) for parameters creation
   *
   * @param name the generic parameter table name
   * @param row the row index
   * @param column the column index
   * @returns the full local value parameter name
   */
  std::vector<std::string> tableParameterNames(const std::string& name, const std::string& row, const std::string& column) const;

  std::string id_; /**< Parameters' set id */
  std::string filepath_; /**< Parameters' set filepath */
  std::map<std::string, boost::shared_ptr<Parameter> > parameters_; /**< Map of the parameters */
  boost::unordered_map<std::string, boost::shared_ptr<Reference> > references_; /**< Map of the references */
};

/**
 * @class ParametersSet::BaseIteratorImpl
 * @brief Implementation class for iterators' functions
 */
class ParametersSet::BaseIteratorImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on parameter's set. Can create an implementation for
   * an iterator to the beginning of the parameters' container or to the end.
   *
   * @param iterated Pointer to the parameters' set iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the parameters' container.
   * @returns Created implementation object
   */
  BaseIteratorImpl(const ParametersSet::Impl* iterated, bool begin);

  /**
   * @brief Destructor
   */
  ~BaseIteratorImpl();

  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this const_iterator
   */
  BaseIteratorImpl& operator++();

  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl operator++(int);

  /**
   * @brief Prefix-decrement operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl& operator--();

  /**
   * @brief Postfix-decrement operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorImpl operator--(int);

  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseIteratorImpl& other) const;

  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseIteratorImpl& other) const;

  /**
   * @brief Indirection operator
   *
   * @returns Parameter pointed to by this
   */
  const boost::shared_ptr<Parameter>& operator*() const;

  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Parameter pointed to by this
   */
  const boost::shared_ptr<Parameter>* operator->() const;

 private:
  std::map<std::string, boost::shared_ptr<Parameter> >::const_iterator current_; /**< Hidden map iterator */
};

/**
 * @class ParametersSet::BaseIteratorRefImpl
 * @brief Implementation class for iterators' functions
 */
class ParametersSet::BaseIteratorRefImpl {
 public:
  /**
   * @brief Constructor
   *
   * Constructor based on parameter's set. Can create an implementation for
   * an iterator to the beginning of the references' container or to the end.
   *
   * @param iterated Pointer to the parameters' set iterated
   * @param begin Flag indicating if the iterator point to the beginning (true)
   * or the end of the references' container.
   * @returns Created implementation object
   */
  BaseIteratorRefImpl(const ParametersSet::Impl* iterated, bool begin);
  /**
   * @brief Destructor
   */
  ~BaseIteratorRefImpl();
  /**
   * @brief Prefix-increment operator
   *
   * @returns Reference to this const_iterator
   */
  BaseIteratorRefImpl& operator++();
  /**
   * @brief Postfix-increment operator
   *
   * @returns Copy of this const_iterator
   */
  BaseIteratorRefImpl operator++(int);
  /**
   * @brief Equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are equals, else false
   */
  bool operator==(const BaseIteratorRefImpl& other) const;
  /**
   * @brief Not equal to operator
   *
   * @param other Iterator to be compared with this
   * @returns true if iterators are different, else false
   */
  bool operator!=(const BaseIteratorRefImpl& other) const;
  /**
   * @brief Indirection operator
   *
   * @returns Parameter pointed to by this
   */
  const boost::shared_ptr<Reference>& operator*() const;
  /**
   * @brief Structure dereference operator
   *
   * @returns Pointer to the Parameter pointed to by this
   */
  const boost::shared_ptr<Reference>* operator->() const;

 private:
  boost::unordered_map<std::string, boost::shared_ptr<Reference> >::const_iterator current_; /**< Hidden map iterator */
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSETIMPL_H_
