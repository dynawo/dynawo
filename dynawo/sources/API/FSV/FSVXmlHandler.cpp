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
 * @file  FSVXmlHandler.cpp
 *
 * @brief Handler for final state values collection file : implementation file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * final state values collection files.
 *
 */
#include "FSVXmlHandler.h"

#include "FSVFinalStateValue.h"
#include "FSVFinalStateValueFactory.h"
#include "FSVFinalStateValuesCollection.h"
#include "FSVFinalStateValuesCollectionFactory.h"

#include <boost/phoenix/bind.hpp>
#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <xml/sax/parser/Attributes.h>

using boost::shared_ptr;
using std::map;
using std::string;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

namespace finalStateValues {

// namespace used to read xml file
static parser::namespace_uri&
namespace_uri() {
  static parser::namespace_uri namespace_uri("http://www.rte-france.com/dynawo");
  return namespace_uri;
}

XmlHandler::XmlHandler() :
    finalStateValuesCollection_(FinalStateValuesCollectionFactory::newInstance("")),
    finalStateValueHandler_(parser::ElementName(namespace_uri(), "finalStateValue")) {
  onElement(namespace_uri()("finalStateValuesInput/finalStateValue"), finalStateValueHandler_);
  finalStateValueHandler_.onEnd(lambda::bind(&XmlHandler::addFinalStateValue, lambda::ref(*this)));
}

shared_ptr<FinalStateValuesCollection>
XmlHandler::getFinalStateValuesCollection() {
  return finalStateValuesCollection_;
}

void
XmlHandler::addFinalStateValue() {
  finalStateValuesCollection_->add(finalStateValueHandler_.get());
}

FinalStateValueHandler::FinalStateValueHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&FinalStateValueHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void
FinalStateValueHandler::create(attributes_type const& attributes) {
  finalStateValueRead_ = FinalStateValueFactory::newFinalStateValue();
  finalStateValueRead_->setModelName(attributes["model"]);
  finalStateValueRead_->setVariable(attributes["variable"]);
}

shared_ptr<FinalStateValue>
FinalStateValueHandler::get() const {
  return finalStateValueRead_;
}

}  // namespace finalStateValues
