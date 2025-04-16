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
 * @file  CRVXmlHandler.h
 *
 * @brief Handler for outputs collection file : header file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * outputs collection files.
 *
 */
#ifndef API_STPO_STPOXMLHANDLER_H_
#define API_STPO_STPOXMLHANDLER_H_

#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>


namespace stepOutputs {
class OutputsCollection;
class Output;

/**
 * @class OutputHandler
 * @brief Handler used to parse output element
 */
class OutputHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit OutputHandler(elementName_type const& root_element);

  /**
   * @brief Destructor
   */
  virtual ~OutputHandler();

  /**
   * @brief return the output read in xml file
   * @return output object build thanks to infos read in xml file
   */
  std::shared_ptr<Output> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  std::shared_ptr<Output> outputRead_;  ///< current output
};

/**
 * @class XmlHandler
 * @brief Outputs file handler class
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * outputs' input files.
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
  virtual ~XmlHandler();

  /**
   * @brief Parsed outputs collection getter
   *
   * @return Outputs collection parsed.
   */
  std::shared_ptr<OutputsCollection> getOutputsCollection();

 private:
  /**
   * @brief add a output to the outputs collection
   */
  void addOutput();

  std::shared_ptr<OutputsCollection> outputsCollection_;  ///< Outputs collection parsed
  OutputHandler outputHandler_;  ///< handler used to read output element
};


}  // namespace stepOutputs

#endif  // API_STPO_STPOXMLHANDLER_H_
