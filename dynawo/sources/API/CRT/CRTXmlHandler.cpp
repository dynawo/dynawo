//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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
 * @file  CRTXmlHandler.cpp
 *
 * @brief Handler for criteria collection file : implementation file
 *
 * XmlHandler is the implementation of Dynawo handler for parsing
 * criteria collection files.
 *
 */
#include <xml/sax/parser/Attributes.h>

#include <boost/phoenix/core.hpp>
#include <boost/phoenix/operator/self.hpp>
#include <boost/phoenix/bind.hpp>

#include "CRTXmlHandler.h"
#include "CRTCriteriaCollectionFactory.h"
#include "CRTCriteriaCollection.h"
#include "CRTCriteria.h"
#include "CRTCriteriaFactory.h"
#include "CRTCriteriaParams.h"
#include "CRTCriteriaParamsFactory.h"


using std::string;
using std::map;
using boost::shared_ptr;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

xml::sax::parser::namespace_uri crt_ns("http://www.rte-france.com/dynawo");  ///< namespace used to read crt xml file

namespace criteria {

XmlHandler::XmlHandler() :
criteriaCollection_(CriteriaCollectionFactory::newInstance()),
busCriteriaHandler_(parser::ElementName(crt_ns, "busCriteria")) ,
loadCriteriaHandler_(parser::ElementName(crt_ns, "loadCriteria")),
genCriteriaHandler_(parser::ElementName(crt_ns, "generatorCriteria")) {
  onElement(crt_ns("criteria/busCriteria"), busCriteriaHandler_);
  onElement(crt_ns("criteria/loadCriteria"), loadCriteriaHandler_);
  onElement(crt_ns("criteria/generatorCriteria"), genCriteriaHandler_);
  busCriteriaHandler_.onEnd(lambda::bind(&XmlHandler::addBusCriteria, lambda::ref(*this)));
  loadCriteriaHandler_.onEnd(lambda::bind(&XmlHandler::addLoadCriteria, lambda::ref(*this)));
  genCriteriaHandler_.onEnd(lambda::bind(&XmlHandler::addGenCriteria, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {
}

shared_ptr<CriteriaCollection>
XmlHandler::getCriteriaCollection() {
  return criteriaCollection_;
}

void
XmlHandler::addBusCriteria() {
  criteriaCollection_->add(CriteriaCollection::BUS, busCriteriaHandler_.get());
}

void
XmlHandler::addLoadCriteria() {
  criteriaCollection_->add(CriteriaCollection::LOAD, loadCriteriaHandler_.get());
}

void
XmlHandler::addGenCriteria() {
  criteriaCollection_->add(CriteriaCollection::GENERATOR, genCriteriaHandler_.get());
}

CriteriaHandler::CriteriaHandler(elementName_type const& root_element) :
criteriaParamsHandler_(parser::ElementName(crt_ns, "parameters")),
cmpHandler_(parser::ElementName(crt_ns, "component")),
countryHandler_(parser::ElementName(crt_ns, "country")) {
  onStartElement(root_element, lambda::bind(&CriteriaHandler::create, lambda::ref(*this), lambda_args::arg2));
  onElement(root_element + crt_ns("parameters"), criteriaParamsHandler_);
  onElement(root_element + crt_ns("component"), cmpHandler_);
  onElement(root_element + crt_ns("country"), countryHandler_);
  criteriaParamsHandler_.onEnd(lambda::bind(&CriteriaHandler::addCriteriaParams, lambda::ref(*this)));
  cmpHandler_.onEnd(lambda::bind(&CriteriaHandler::addComponent, lambda::ref(*this)));
  countryHandler_.onEnd(lambda::bind(&CriteriaHandler::addCountry, lambda::ref(*this)));
}

void CriteriaHandler::create(attributes_type const & /*attributes*/) {
  criteriaRead_ = CriteriaFactory::newCriteria();
}

shared_ptr<Criteria>
CriteriaHandler::get() const {
  return criteriaRead_;
}

void
CriteriaHandler::addCriteriaParams() {
  criteriaRead_->setParams(criteriaParamsHandler_.get());
}

void
CriteriaHandler::addComponent() {
  criteriaRead_->addComponentId(cmpHandler_.get());
}

void
CriteriaHandler::addCountry() {
  criteriaRead_->addCountry(countryHandler_.get());
}


CriteriaParamsHandler::CriteriaParamsHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&CriteriaParamsHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void CriteriaParamsHandler::create(attributes_type const & attributes) {
  criteriaParamsRead_ = CriteriaParamsFactory::newCriteriaParams();
  criteriaParamsRead_->setScope(CriteriaParams::string2Scope(attributes["scope"]));
  criteriaParamsRead_->setType(CriteriaParams::string2Type(attributes["type"]));
  criteriaParamsRead_->setId(attributes["id"]);
  if (attributes.has("uMaxPu"))
    criteriaParamsRead_->setUMaxPu(attributes["uMaxPu"]);
  if (attributes.has("uMinPu"))
    criteriaParamsRead_->setUMinPu(attributes["uMinPu"]);
  if (attributes.has("uNomMax"))
    criteriaParamsRead_->setUNomMax(attributes["uNomMax"]);
  if (attributes.has("uNomMin"))
    criteriaParamsRead_->setUNomMin(attributes["uNomMin"]);
  if (attributes.has("pMax"))
    criteriaParamsRead_->setPMax(attributes["pMax"]);
  if (attributes.has("pMin"))
    criteriaParamsRead_->setPMin(attributes["pMin"]);
}

shared_ptr<CriteriaParams>
CriteriaParamsHandler::get() const {
  return criteriaParamsRead_;
}


ElementWithIdHandler::ElementWithIdHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&ElementWithIdHandler::create, lambda::ref(*this), lambda_args::arg2));
}

void ElementWithIdHandler::create(attributes_type const & attributes) {
  cmpRead_ = attributes["id"].as_string();
}

const std::string&
ElementWithIdHandler::get() const {
  return cmpRead_;
}
}  // namespace criteria
