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
#include "CRTCriteriaParamsVoltageLevel.h"


using std::string;
using std::map;
using boost::shared_ptr;

namespace lambda = boost::phoenix;
namespace lambda_args = lambda::placeholders;
namespace parser = xml::sax::parser;

namespace criteria {

// namespace used to read xml file
static parser::namespace_uri& namespace_uri() {
  static parser::namespace_uri namespace_uri("http://www.rte-france.com/dynawo");
  return namespace_uri;
}

XmlHandler::XmlHandler() :
criteriaCollection_(CriteriaCollectionFactory::newInstance()),
busCriteriaHandler_(parser::ElementName(namespace_uri(), "busCriteria")) ,
loadCriteriaHandler_(parser::ElementName(namespace_uri(), "loadCriteria")),
genCriteriaHandler_(parser::ElementName(namespace_uri(), "generatorCriteria")) {
  onElement(namespace_uri()("criteria/busCriteria"), busCriteriaHandler_);
  onElement(namespace_uri()("criteria/loadCriteria"), loadCriteriaHandler_);
  onElement(namespace_uri()("criteria/generatorCriteria"), genCriteriaHandler_);
  busCriteriaHandler_.onEnd(lambda::bind(&XmlHandler::addBusCriteria, lambda::ref(*this)));
  loadCriteriaHandler_.onEnd(lambda::bind(&XmlHandler::addLoadCriteria, lambda::ref(*this)));
  genCriteriaHandler_.onEnd(lambda::bind(&XmlHandler::addGenCriteria, lambda::ref(*this)));
}

XmlHandler::~XmlHandler() {}

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
criteriaParamsHandler_(parser::ElementName(namespace_uri(), "parameters")),
cmpHandler_(parser::ElementName(namespace_uri(), "component")),
countryHandler_(parser::ElementName(namespace_uri(), "country")) {
  onStartElement(root_element, lambda::bind(&CriteriaHandler::create, lambda::ref(*this), lambda_args::arg2));
  onElement(root_element + namespace_uri()("parameters"), criteriaParamsHandler_);
  onElement(root_element + namespace_uri()("component"), cmpHandler_);
  onElement(root_element + namespace_uri()("country"), countryHandler_);
  criteriaParamsHandler_.onEnd(lambda::bind(&CriteriaHandler::addCriteriaParams, lambda::ref(*this)));
  cmpHandler_.onEnd(lambda::bind(&CriteriaHandler::addComponent, lambda::ref(*this)));
  countryHandler_.onEnd(lambda::bind(&CriteriaHandler::addCountry, lambda::ref(*this)));
}

CriteriaHandler::~CriteriaHandler() {}

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
  criteriaRead_->addComponentId(cmpHandler_.getId(), cmpHandler_.getVoltageLevelId());
}

void
CriteriaHandler::addCountry() {
  criteriaRead_->addCountry(countryHandler_.getId());
}


CriteriaParamsHandler::CriteriaParamsHandler(elementName_type const& root_element) :
    criteriaParamsVoltageLevelHandler_(parser::ElementName(namespace_uri(), "voltageLevel")) {
  onStartElement(root_element, lambda::bind(&CriteriaParamsHandler::create, lambda::ref(*this), lambda_args::arg2));
  onElement(root_element + namespace_uri()("voltageLevel"), criteriaParamsVoltageLevelHandler_);
  criteriaParamsVoltageLevelHandler_.onEnd(lambda::bind(&CriteriaParamsHandler::addCriteriaParamsVoltageLevel, lambda::ref(*this)));
}

CriteriaParamsHandler::~CriteriaParamsHandler() {}

void CriteriaParamsHandler::create(attributes_type const & attributes) {
  criteriaParamsRead_ = CriteriaParamsFactory::newCriteriaParams();
  criteriaParamsRead_->setScope(CriteriaParams::string2Scope(attributes["scope"]));
  criteriaParamsRead_->setType(CriteriaParams::string2Type(attributes["type"]));
  criteriaParamsRead_->setId(attributes["id"]);
  CriteriaParamsVoltageLevel vl;
  if (attributes.has("uMaxPu"))
    vl.setUMaxPu(attributes["uMaxPu"]);
  if (attributes.has("uMinPu"))
    vl.setUMinPu(attributes["uMinPu"]);
  if (attributes.has("uNomMax"))
    vl.setUNomMax(attributes["uNomMax"]);
  if (attributes.has("uNomMin"))
    vl.setUNomMin(attributes["uNomMin"]);
  if (!vl.empty())
    criteriaParamsRead_->addVoltageLevel(vl);
  if (attributes.has("pMax"))
    criteriaParamsRead_->setPMax(attributes["pMax"]);
  if (attributes.has("pMin"))
    criteriaParamsRead_->setPMin(attributes["pMin"]);
}

void
CriteriaParamsHandler::addCriteriaParamsVoltageLevel() {
  if (!criteriaParamsVoltageLevelHandler_.get()->empty())
    criteriaParamsRead_->addVoltageLevel(*criteriaParamsVoltageLevelHandler_.get());
}

shared_ptr<CriteriaParams>
CriteriaParamsHandler::get() const {
  return criteriaParamsRead_;
}

CriteriaParamsVoltageLevelHandler::CriteriaParamsVoltageLevelHandler(elementName_type const& root_element)  {
  onStartElement(root_element, lambda::bind(&CriteriaParamsVoltageLevelHandler::create, lambda::ref(*this), lambda_args::arg2));
}

CriteriaParamsVoltageLevelHandler::~CriteriaParamsVoltageLevelHandler() {}

void CriteriaParamsVoltageLevelHandler::create(attributes_type const & attributes) {
  criteriaParamsVoltageLevelRead_ = shared_ptr<CriteriaParamsVoltageLevel>(new CriteriaParamsVoltageLevel());
  if (attributes.has("uMaxPu"))
    criteriaParamsVoltageLevelRead_->setUMaxPu(attributes["uMaxPu"]);
  if (attributes.has("uMinPu"))
    criteriaParamsVoltageLevelRead_->setUMinPu(attributes["uMinPu"]);
  if (attributes.has("uNomMax"))
    criteriaParamsVoltageLevelRead_->setUNomMax(attributes["uNomMax"]);
  if (attributes.has("uNomMin"))
    criteriaParamsVoltageLevelRead_->setUNomMin(attributes["uNomMin"]);
}

shared_ptr<CriteriaParamsVoltageLevel>
CriteriaParamsVoltageLevelHandler::get() const {
  return criteriaParamsVoltageLevelRead_;
}


ElementWithIdHandler::ElementWithIdHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&ElementWithIdHandler::create, lambda::ref(*this), lambda_args::arg2));
}

ElementWithIdHandler::~ElementWithIdHandler() {}

void ElementWithIdHandler::create(attributes_type const & attributes) {
  idRead_ = attributes["id"].as_string();
}

const std::string&
ElementWithIdHandler::getId() const {
  return idRead_;
}


ComponentHandler::ComponentHandler(elementName_type const& root_element) {
  onStartElement(root_element, lambda::bind(&ComponentHandler::create, lambda::ref(*this), lambda_args::arg2));
}

ComponentHandler::~ComponentHandler() {}

void ComponentHandler::create(attributes_type const & attributes) {
  idRead_ = attributes["id"].as_string();
  if (attributes.has("voltageLevelId"))
    voltageLevelIdRead_ = attributes["voltageLevelId"].as_string();
  else
    voltageLevelIdRead_.clear();
}

const std::string&
ComponentHandler::getId() const {
  return idRead_;
}

const std::string&
ComponentHandler::getVoltageLevelId() const {
  return voltageLevelIdRead_;
}
}  // namespace criteria
