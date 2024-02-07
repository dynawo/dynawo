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
 * @brief Handler for curves collection file : header file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * curves collection files.
 *
 */
#ifndef API_CRV_CRVXMLHANDLER_H_
#define API_CRV_CRVXMLHANDLER_H_

#include <boost/shared_ptr.hpp>
#include <xml/sax/parser/ComposableDocumentHandler.h>
#include <xml/sax/parser/ComposableElementHandler.h>


namespace curves {
class CurvesCollection;
class Curve;

/**
 * @class CurveHandler
 * @brief Handler used to parse curve element
 */
class CurveHandler : public xml::sax::parser::ComposableElementHandler {
 public:
  /**
   * @brief Constructor
   * @param root_element complete name of the element read by the handler
   */
  explicit CurveHandler(elementName_type const& root_element);

  /**
   * @brief return the curve read in xml file
   * @return curve object build thanks to infos read in xml file
   */
  boost::shared_ptr<Curve> get() const;

 protected:
  /**
   * @brief Called when the XML element opening tag is read
   * @param attributes attributes of the element
   */
  void create(attributes_type const& attributes);

 private:
  boost::shared_ptr<Curve> curveRead_;  ///< current curve
};

/**
 * @class XmlHandler
 * @brief Curves file handler class
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * curves' input files.
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
  ~XmlHandler();

  /**
   * @brief Parsed curves collection getter
   *
   * @return Curves collection parsed.
   */
  boost::shared_ptr<CurvesCollection> getCurvesCollection();

 private:
  /**
   * @brief add a curve to the curves collection
   */
  void addCurve();

  boost::shared_ptr<CurvesCollection> curvesCollection_;  ///< Curves collection parsed
  CurveHandler curveHandler_;  ///< handler used to read curve element
};


}  // namespace curves

#endif  // API_CRV_CRVXMLHANDLER_H_
