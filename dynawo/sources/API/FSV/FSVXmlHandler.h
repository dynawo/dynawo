//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  FSVXmlHandler.h
 *
 * @brief Handler for final state values collection file : header file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * final state values collection files.
 *
 */
#ifndef API_FSV_FSVXMLHANDLER_H_
#define API_FSV_FSVXMLHANDLER_H_

#include "FSVFinalStateValue.h"
#include "FSVFinalStateValuesCollection.h"

#include <boost/shared_ptr.hpp>
#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>

namespace finalStateValues {

/**
 * @class FinalStateValueHandler
 * @brief Handler used to parse final state value element
 */
class FinalStateValueHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit FinalStateValueHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~FinalStateValueHandler() = default;

  /**
   * @brief return the final state value read in xml file
   * @return final state value object build thanks to infos read in xml file
   */
  boost::shared_ptr<FinalStateValue> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<FinalStateValue> finalStateValueRead_;  ///< current final state value
};

/**
 * @class XmlHandler
 * @brief Final state values file handler class
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * final state values' input files.
 */
class XmlHandler : public xml::sax::parser::ComposableDocumentHandler {
 public:
  /**
   * @brief Default constructor
   */
  XmlHandler();

  /**
   * @brief Parsed final state values collection getter
   *
   * @return Final state values collection parsed.
   */
  boost::shared_ptr<FinalStateValuesCollection> getFinalStateValuesCollection();

 private:
  /**
   * @brief add a final state value to the final state values collection
   */
  void addFinalStateValue();

  boost::shared_ptr<FinalStateValuesCollection> finalStateValuesCollection_;  ///< Final state values collection parsed
  FinalStateValueHandler finalStateValueHandler_;                             ///< handler used to read final state value element
};

}  // namespace finalStateValues

#endif  // API_FSV_FSVXMLHANDLER_H_
