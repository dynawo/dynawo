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
 * @file PARParametersSet.h
 * @brief Dynawo parameters set : interface file
 *
 */

#ifndef API_PAR_PARPARAMETERSSET_H_
#define API_PAR_PARPARAMETERSSET_H_

#include <string>
#include <vector>
#include <map>

#include <boost/shared_ptr.hpp>
#include <boost/enable_shared_from_this.hpp>
#include <boost/unordered_map.hpp>

namespace parameters {

class Parameter;
class Reference;

/**
 * @class ParametersSet
 * @brief Parameters set interface class
 *
 * ParametersSet objects describe a set of parameters.
 * Available types are those availables in @p Parameter class
 */
class ParametersSet : public boost::enable_shared_from_this<ParametersSet> {
 public:
  /**
   * @brief Destructor
   */
  virtual ~ParametersSet() { }

  /**
   * @brief Getter for parameters' set id
   *
   * @returns Parameters' set id
   */
  virtual const std::string& getId() const = 0;

  /**
   * @brief Getter for parameters' set file path
   *
   * @returns Parameters' set file path
   */
  virtual const std::string& getFilePath() const = 0;

  /**
   * @brief Setter for parameters' set file path
   *
   * @param filepath Parameters' set file path
   */
  virtual void setFilePath(const std::string& filepath) = 0;

  /**
   * @brief Add a parameter alias in the parameters set
   *
   * The alias will be a reference to another parameter
   *
   * @param aliasName : Name of the parameter alias
   * @param origName : name of the origin parameter to rely on
   * @returns Shared pointer to current ParametersSet instance
   * @throws if the origin parameter does not exist, or the destination parameter already exists
   */
  virtual boost::shared_ptr<ParametersSet> createAlias(const std::string& aliasName, const std::string& origName) = 0;

  /**
   * @brief Adds a bool parameter in the parameters set
   *
   * Adds a new bool parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const bool value) = 0;

  /**
   * @brief Adds an int parameter in the parameters set
   *
   * Adds a new int parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const int value) = 0;

  /**
   * @brief Adds a double parameter in the parameters set
   *
   * Adds a new double parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const double value) = 0;

  /**
   * @brief Adds a string parameter in the parameters set
   *
   * Adds a new string parameter in the parameters set with given name and value.
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @returns Shared pointer to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const std::string& value) = 0;

  /**
   * @brief Adds a bool parameter in the parameters set
   *
   * Adds a new bool parameter in the parameters set with given name and value.
   * For the case of a parameter inside an array
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @param row : row of the parameter inside its array (in case of array parameter)
   * @param column : column of the parameter inside its array
   * @returns Shared pointer to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const bool value,
                                                           const std::string& row, const std::string& column) = 0;

  /**
   * @brief Adds an int parameter in the parameters set
   *
   * Adds a new int parameter in the parameters set with given name and value.
   * For the case of a parameter inside an array
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @param row : row of the parameter inside its array (in case of array parameter)
   * @param column : column of the parameter inside its array
   * @returns Shared pointer to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const int value,
                                                           const std::string& row, const std::string& column) = 0;

  /**
   * @brief Adds a double parameter in the parameters set
   *
   * Adds a new double parameter in the parameters set with given name and value.
   * For the case of a parameter inside an array
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @param row : row of the parameter inside its array (in case of array parameter)
   * @param column : column of the parameter inside its array
   * @returns Shared pointer to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const double value,
                                                           const std::string& row, const std::string& column) = 0;

  /**
   * @brief Adds a string parameter in the parameters set
   *
   * Adds a new string parameter in the parameters set with given name and value.
   * For the case of a parameter inside an array
   *
   * @param name : Name of the parameter
   * @param value : Value of the parameter
   * @param row : row of the parameter inside its array (in case of array parameter)
   * @param column : column of the parameter inside its array
   * @returns Shared pointer to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> createParameter(const std::string& name, const std::string& value,
                                                           const std::string& row, const std::string& column) = 0;

  /**
   * @brief Add a new parameter in the map
   *
   * Add a new parameter in the underlying map if it does not already exists
   *
   * @param[in] param Parameter to add to the set
   * @returns Reference to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> addParameter(const boost::shared_ptr<Parameter>& param) = 0;

  /**
   * @brief Add a new reference in the map
   *
   * Add a new reference in the underlying map if it does not already exists
   *
   * @param[in] ref Reference to add to the set
   * @returns Reference to current ParametersSet instance
   */
  virtual boost::shared_ptr<ParametersSet> addReference(boost::shared_ptr<Reference> ref) = 0;

  /**
   * @brief Get a parameter from the parameters set
   *
   * Get the parameter with given name in the parameter set
   *
   * @param name : Name of the parameter
   * @returns Shared pointer to the parameter
   * @throws API exception if the parameter is not found
   */
  virtual const boost::shared_ptr<Parameter> getParameter(const std::string& name) const = 0;

  /**
   * @brief Get a reference from the parameters set
   *
   * Get the reference with given name in the parameter set
   *
   * @param name : Name of the reference
   * @returns Shared pointer to the reference
   * @throws API exception if the reference is not found
   */
  virtual const boost::shared_ptr<Reference> getReference(const std::string& name) const = 0;

  /**
   * @brief Check if a parameter is in the parameters set
   *
   * Check if a parameter with given name exists in the parameter set
   *
   * @param name : Name of the parameter
   * @returns Existence of the parameter in the set
   */
  virtual bool hasParameter(const std::string& name) const = 0;

  /**
   * @brief Check if a reference is in the parameters set
   *
   * Check if a reference with given name exists in the parameter set
   *
   * @param name : Name of the reference
   * @returns Existence of the reference in the set
   */
  virtual bool hasReference(const std::string& name) const = 0;

  /**
   * @brief Extends parameters set with the content of given parameters set
   *
   * Extends parameters set with the parameters included in the parameters set
   * given as argument
   *
   * @param parametersSet : ParametersSet to use for extension
   */
  virtual void extend(boost::shared_ptr<ParametersSet> parametersSet) = 0;

  /**
   * @brief Get a vector of parameter names
   *
   * @returns Vector of parameters' name
   */
  virtual std::vector<std::string> getParametersNames() const = 0;

  /**
   * @brief Get a vector of unused parameters' names
   *
   * @returns Vector of unused parameters' names
   */
  virtual std::vector<std::string> getParamsUnused() const = 0;

  /**
   * @brief Get a vector of references names
   *
   * @returns Vector of references' name
   */
  virtual std::vector<std::string> getReferencesNames() const = 0;

  /**
   * @brief Get a reference to the map of parameters
   *
   * @returns Reference to the map of parameters
   */
  virtual std::map<std::string, boost::shared_ptr<Parameter> >& getParameters() = 0;

  class Impl;  ///< implementation class

 protected:
  class BaseIteratorImpl;  ///< Abstract class, for the interface
  class BaseIteratorRefImpl;  ///< Abstract class, for the interface

 public:
  /**
   * @class parameter_const_iterator
   * @brief Const iterator over parameters
   *
   * Const iterator over parameters described in a set of parameters.
   */
  class parameter_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on parameter's set. Can create an iterator to the
     * beginning of the parameters' container or to the end. Parameters
     * cannot be modified.
     *
     * @param iterated Pointer to the parameters' set iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the parameters' container.
     * @returns Created parameter_const_iterator.
     */
    parameter_const_iterator(const ParametersSet::Impl* iterated, bool begin);

    /**
     * @brief Copy constructor
     * @param original : const iterator to copy
     */
    parameter_const_iterator(const parameter_const_iterator& original);

    /**
     * @brief Destructor
     */
    ~parameter_const_iterator();

    /**
     * @brief assignment
     * @param other : parameter_const_iterator to assign
     *
     * @returns Reference to this parameter_const_iterator
     */
    parameter_const_iterator& operator=(const parameter_const_iterator& other);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this parameter_const_iterator
     */
    parameter_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this parameter_const_iterator
     */
    parameter_const_iterator operator++(int);

    /**
     * @brief Prefix-decrement operator
     *
     * @returns Reference to this parameter_const_iterator
     */
    parameter_const_iterator& operator--();

    /**
     * @brief Postfix-decrement operator
     *
     * @returns Copy of this parameter_const_iterator
     */
    parameter_const_iterator operator--(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const parameter_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const parameter_const_iterator& other) const;

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
    BaseIteratorImpl* impl_; /**< Pointer to the implementation of iterator */
  };

  /**
   * @brief Get a parameter_const_iterator to the beginning of the parameters' set
   * @return beginning of constant iterator
   */
  virtual parameter_const_iterator cbeginParameter() const = 0;

  /**
   * @brief Get a parameter_const_iterator to the end of the parameters' set
   * @return end of constant iterator
   */
  virtual parameter_const_iterator cendParameter() const = 0;

  /**
   * @class reference_const_iterator
   * @brief Const iterator over references
   *
   * Const iterator over references described in a set of parameters.
   */
  class reference_const_iterator {
   public:
    /**
     * @brief Constructor
     *
     * Constructor based on parameter's set. Can create an iterator to the
     * beginning of the references' container or to the end. References
     * cannot be modified.
     *
     * @param iterated Pointer to the references' set iterated
     * @param begin Flag indicating if the iterator point to the beginning (true)
     * or the end of the references' container.
     * @returns Created reference_const_iterator.
     */
    reference_const_iterator(const ParametersSet::Impl* iterated, bool begin);

    /**
     * @brief Copy constructor
     * @param original : const iterator ref to copy
     */
    reference_const_iterator(const reference_const_iterator& original);

    /**
     * @brief Destructor
     */
    ~reference_const_iterator();

    /**
     * @brief assignment
     * @param other : reference_const_iterator to assign
     *
     * @returns Reference to this reference_const_iterator
     */
    reference_const_iterator& operator=(const reference_const_iterator& other);

    /**
     * @brief Prefix-increment operator
     *
     * @returns Reference to this reference_const_iterator
     */
    reference_const_iterator& operator++();

    /**
     * @brief Postfix-increment operator
     *
     * @returns Copy of this reference_const_iterator
     */
    reference_const_iterator operator++(int);

    /**
     * @brief Equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are equals, else false
     */
    bool operator==(const reference_const_iterator& other) const;

    /**
     * @brief Not equal to operator
     *
     * @param other Iterator to be compared with this
     * @returns true if iterators are different, else false
     */
    bool operator!=(const reference_const_iterator& other) const;

    /**
     * @brief Indirection operator
     *
     * @returns Reference pointed to by this
     */
    const boost::shared_ptr<Reference>& operator*() const;

    /**
     * @brief Structure dereference operator
     *
     * @returns Pointer to the Reference pointed to by this
     */
    const boost::shared_ptr<Reference>* operator->() const;

   private:
    BaseIteratorRefImpl* impl_; /**< Pointer to the implementation of iterator */
  };

  /**
   * @brief Get a reference_const_iterator to the beginning of the references' set
   * @return beginning of constant iterator_ref
   */
  virtual reference_const_iterator cbeginReference() const = 0;

  /**
   * @brief Get a reference_const_iterator to the end of the references' set
   * @return end of constant iterator_ref
   */
  virtual reference_const_iterator cendReference() const = 0;
};

}  // namespace parameters

#endif  // API_PAR_PARPARAMETERSSET_H_
