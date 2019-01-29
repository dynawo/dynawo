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
 * @file  CRVXmlHandler.cpp
 *
 * @brief Handler for curves collection file : implementation file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * curves collection files.
 *
 */
#include <xml/sax/parser/Attributes.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include "CRVCurveFactory.h"
#include "CRVCurvesCollectionFactory.h"
#include "CRVCurvesCollection.h"
#include "CRVXmlHandler.h"
#include "CRVCurveImpl.h"


using std::string;
using std::map;
using boost::shared_ptr;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

xml::sax::parser::namespace_uri crv_ns("http://www.rte-france.com/dynawo");  ///< namespace used to read crv xml file

namespace curves {

XmlHandler::XmlHandler() :
curvesCollection_(CurvesCollectionFactory::newInstance("")),
curveHandler_(parser::ElementName(crv_ns, "curve")) {
  onElement(crv_ns("curvesInput/curve"), curveHandler_);
  curveHandler_.onEnd(lambda::bind(&XmlHandler::addCurve, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {
}

shared_ptr<CurvesCollection>
XmlHandler::getCurvesCollection() {
  return curvesCollection_;
}

void
XmlHandler::addCurve() {
  curvesCollection_->add(curveHandler_.get());
}

CurveHandler::CurveHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&CurveHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void CurveHandler::create(attributes_type const & attributes) {
  curveRead_ = CurveFactory::newCurve();
  curveRead_->setModelName(attributes["model"]);
  curveRead_->setVariable(attributes["variable"]);
}

shared_ptr<Curve>
CurveHandler::get() const {
  return curveRead_;
}

}  // namespace curves


