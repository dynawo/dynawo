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
 * @file PARReference.h
 * @brief Dynawo references : interface file
 *
 */

#ifndef API_PAR_PARREFERENCE_H_
#define API_PAR_PARREFERENCE_H_

#include <string>

#ifndef LANG_CXX11
#include <boost/static_assert.hpp>
#endif

#include "PARExport.h"

namespace parameters {

/**
 * @class Reference
 * @brief Reference interface class
 *
 * Interface class for reference objects. These are containers for references
 *
 */
class __DYNAWO_PAR_EXPORT Reference {
 public:
  /**
   * @brief Available reference origin data sets
   */
  enum OriginData {
    IIDM,  ///< the parameter is written in the IIDM file
    SIZE_OF_ENUM  ///< value to use ONLY to assess the enumeration size
  };

  /**
   * @brief Setter for reference type
   *
   * @param type Reference's type
   */
  virtual void setType(const std::string& type) = 0;

  /**
   * @brief Setter for reference origin data
   *
   * @param origData Reference's origin data
   * @throws API exception if the origin data is unkown
   */
  virtual void setOrigData(const std::string& origData) = 0;

  /**
   * @brief Setter for reference origin data
   *
   * @param origData Reference's origin data
   */
  virtual void setOrigData(const OriginData& origData) = 0;

  /**
   * @brief Setter for reference origin name
   *
   * @param origName Reference's origin name
   */
  virtual void setOrigName(const std::string& origName) = 0;

  /**
   * @brief Setter for the component id where the reference should be found
   *
   * @param id Component's id
   */
  virtual void setComponentId(const std::string& id) = 0;

  /**
   * @brief Getter for reference type
   * @returns Reference's type
   */
  virtual std::string getType() const = 0;

  /**
   * @brief Getter for reference name
   * @returns Reference's name
   */
  virtual std::string getName() const = 0;

  /**
   * @brief Getter for reference origin data
   * @returns Reference's origin data
   */
  virtual OriginData getOrigData() const = 0;

  /**
   * @brief Getter for reference origin data as a string
   * @returns Reference's origin data
   */
  virtual std::string getOrigDataStr() const = 0;

  /**
   * @brief Getter for reference origin name
   * @returns Reference's origin name
   */
  virtual std::string getOrigName() const = 0;

  /**
   * @brief Getter for the component id where the reference should be found
   * @return Component's id
   */
  virtual std::string getComponentId() const = 0;

  class Impl;  ///< implementation class
};
static const char* ReferenceOriginNames[Reference::SIZE_OF_ENUM] = {"IIDM"};  ///< string conversion of enum values
// statically check that the size of ParameterTypeNames fits the number of ParameterTypes
#ifdef LANG_CXX11
/**
 * @brief Test is the size of ParameterTypeNames is relevant with the enumeration size
 */
static_assert(sizeof (ReferenceOriginNames) / sizeof (char*) == Reference::SIZE_OF_ENUM, "Parameters string size does not match ParameterType enumeration");
#else
/**
 * @brief Test is the size of ParameterTypeNames is relevant with the enumeration size
 */
BOOST_STATIC_ASSERT_MSG(sizeof (ReferenceOriginNames) / sizeof (char*) == Reference::SIZE_OF_ENUM,
                        "Parameters string size does not match ParameterType enumeration");
#endif
}  // namespace parameters

#endif  // API_PAR_PARREFERENCE_H_
