//
// Copyright (c) 2026, RTE (http://www.rte-france.com)
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
 * @file MANDATORYPARAMXmlHandler.h
 * @brief Handler for mandatory parameters file : header file
 */

#ifndef API_MANDATORYPARAM_MANDATORYPARAMXMLHANDLER_H_
#define API_MANDATORYPARAM_MANDATORYPARAMXMLHANDLER_H_

#include <memory>
#include <string>

#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>

#include "MANDATORYPARAMCollection.h"

namespace mandatoryParameters {

/**
 * @class ParameterHandler
 * @brief SAX handler for a single mandatoryParameter element
 */
class ParameterHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element XML element name to handle
   */
  explicit ParameterHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  ~ParameterHandler() override;

  /**
   * @brief name getter
   * @return name attribute of the last parsed element
   */
  const std::string& getName() const;

  /**
   * @brief type getter
   * @return type attribute of the last parsed element
   */
  const std::string& getType() const;

 private:
  /**
   * @brief Gather the data from the xml for a mandatory parameter
   * @param attributes xml attribute to read
   */
  void create(attributes_type const& attributes);

  std::string name_;  ///< last parsed parameter name
  std::string type_;  ///< last parsed parameter type
};

/**
 * @class XmlHandler
 * @brief SAX document handler for .mandatoryParam files
 */
class XmlHandler : public xml::sax::parser::ComposableDocumentHandler {
 public:
  /**
   * @brief Default constructor
   */
  XmlHandler();

  /**
   * @brief Destructor
   */
  ~XmlHandler() override;

  /**
   * @brief Parsed collection getter
   * @return collection of mandatory parameters
   */
  std::shared_ptr<Collection> getCollection();

 private:
  /**
   * @brief Add a mandatory parameter to the collection
   */
  void addParameter();

  std::shared_ptr<Collection> collection_;  ///< collection being built
  ParameterHandler parameterHandler_;       ///< handler for each mandatoryParameter element
};

}  // namespace mandatoryParameters

#endif  // API_MANDATORYPARAM_MANDATORYPARAMXMLHANDLER_H_
