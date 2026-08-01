//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
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

namespace parameters {

/**
 * @class Reference
 * @brief Reference interface class
 *
 * Interface class for reference objects. These are containers for references
 *
 */
class Reference {
 public:
  /**
   * @brief Available reference origin data sets
   */
  enum OriginData {
    IIDM,         ///< the parameter is written in the IIDM file
    PAR,          ///< the parameter is written in the PAR file
    SIZE_OF_ENUM  ///< value to use ONLY to assess the enumeration size
  };

  /**
   * @brief Constructor of reference
   *
   * @param[in] name reference name
   * @param origData reference's origin data
   */
  explicit Reference(const std::string& name, OriginData origData);

  /**
   * @brief Setter for reference type
   *
   * @param type Reference's type
   */
  void setType(const std::string& type);

  /**
   * @brief Setter for reference origin name
   *
   * @param origName Reference's origin name
   */
  void setOrigName(const std::string& origName);

  /**
   * @brief Setter for the component id where the reference should be found
   *
   * @param id Component's id
   */
  void setComponentId(const std::string& id);

  /**
   * @brief Setter for the par id where the reference should be found
   *
   * @param parId Par's id
   */
  void setParId(const std::string& parId);

  /**
   * @brief Setter for the par file where the reference should be found
   *
   * @param parFile Par's file
   */
  void setParFile(const std::string& parFile);

  /**
   * @brief Getter for reference type
   * @returns Reference's type
   */
  const std::string& getType() const;

  /**
   * @brief Getter for reference name
   * @returns Reference's name
   */
  const std::string& getName() const;

  /**
   * @brief Getter for reference origin data
   * @returns Reference's origin data
   */
  OriginData getOrigData() const;

  /**
   * @brief Getter for reference origin data as a string
   * @returns Reference's origin data
   */
  std::string getOrigDataStr() const;

  /**
   * @brief Getter for reference origin name
   * @returns Reference's origin name
   */
  const std::string& getOrigName() const;

  /**
   * @brief Getter for the component id where the reference should be found
   * @return Component's id
   */
  const std::string& getComponentId() const;

  /**
   * @brief Getter for the par id where the reference should be found
   * @return Par's id
   */
  const std::string& getParId() const;

  /**
   * @brief Getter for the par file where the reference should be found
   * @return Par's file
   */
  const std::string& getParFile() const;

 private:
  std::string type_;         ///< Reference's type
  std::string name_;         ///< Reference's name
  OriginData origData_;      ///< Reference's origin data
  std::string origName_;     ///< Reference's origin name
  std::string componentId_;  ///< Reference's component id
  std::string parId_;        ///< Reference's parId
  std::string parFile_;      ///< Reference's par file
};
static const char* ReferenceOriginNames[Reference::SIZE_OF_ENUM] = {"IIDM", "PAR"};  ///< string conversion of enum values
// statically check that the size of ParameterTypeNames fits the number of ParameterTypes
/**
 * @brief Test is the size of ParameterTypeNames is relevant with the enumeration size
 */
static_assert(sizeof(ReferenceOriginNames) / sizeof(char*) == Reference::SIZE_OF_ENUM, "Parameters string size does not match ParameterType enumeration");
}  // namespace parameters

#endif  // API_PAR_PARREFERENCE_H_
