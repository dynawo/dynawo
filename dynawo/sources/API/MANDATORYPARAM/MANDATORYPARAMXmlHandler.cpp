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
 * @file MANDATORYPARAMXmlHandler.cpp
 * @brief Handler for mandatory parameters file : implementation file
 */

#include <xml/sax/parser/Attributes.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include "MANDATORYPARAMXmlHandler.h"

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

namespace mandatoryParameters {

ParameterHandler::ParameterHandler(elementName_type const& root_element) {
  onStartElement(root_element,
    lambda::bind(&ParameterHandler::create, lambda::ref(*this), lambda_args::arg2));
}

ParameterHandler::~ParameterHandler() {}

void
ParameterHandler::create(attributes_type const& attributes) {
  name_ = attributes.get<std::string>("name");
  type_ = attributes.get<std::string>("type");
}

const std::string&
ParameterHandler::getName() const {
  return name_;
}

const std::string&
ParameterHandler::getType() const {
  return type_;
}

XmlHandler::XmlHandler() :
collection_(std::make_shared<Collection>()),
parameterHandler_(parser::ElementName("mandatoryParameter")) {
  onElement(parser::namespace_uri::empty()("mandatoryParameters/mandatoryParameter"), parameterHandler_);
  parameterHandler_.onEnd(lambda::bind(&XmlHandler::addParameter, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {}

std::shared_ptr<Collection>
XmlHandler::getCollection() {
  return collection_;
}

void
XmlHandler::addParameter() {
  collection_->addParameter(parameterHandler_.getName(), parameterHandler_.getType());
}

}  // namespace mandatoryParameters
