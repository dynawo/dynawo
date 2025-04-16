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
 * @file  STPOXmlHandler.cpp
 *
 * @brief Handler for outputs collection file : implementation file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * outputs collection files.
 *
 */
#include <xml/sax/parser/Attributes.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include "STPOOutputFactory.h"
#include "STPOOutputsCollectionFactory.h"
#include "STPOOutputsCollection.h"
#include "STPOXmlHandler.h"
#include "STPOOutput.h"

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

namespace stepOutputs {

// namespace used to read xml file
static parser::namespace_uri& namespace_uri() {
  static parser::namespace_uri namespace_uri("http://www.rte-france.com/dynawo");
  return namespace_uri;
}

XmlHandler::XmlHandler() :
outputsCollection_(OutputsCollectionFactory::newInstance("")),
outputHandler_(parser::ElementName(namespace_uri(), "output")) {
  onElement(namespace_uri()("outputsInput/output"), outputHandler_);
  outputHandler_.onEnd(lambda::bind(&XmlHandler::addOutput, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {}

std::shared_ptr<OutputsCollection>
XmlHandler::getOutputsCollection() {
  return outputsCollection_;
}

void
XmlHandler::addOutput() {
  outputsCollection_->add(outputHandler_.get());
}

OutputHandler::OutputHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&OutputHandler::create, lambda::ref(*this), lambda_args::arg2));
}

OutputHandler::~OutputHandler() {}

void OutputHandler::create(attributes_type const & attributes) {
  outputRead_ = OutputFactory::newOutput();
  outputRead_->setModelName(attributes["model"]);
  outputRead_->setVariable(attributes["variable"]);
  outputRead_->setAlias(attributes["alias"]);
}

std::shared_ptr<Output>
OutputHandler::get() const {
  return outputRead_;
}

}  // namespace stepOutputs
