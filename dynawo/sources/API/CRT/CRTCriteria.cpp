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

#include "CRTCriteria.h"

namespace criteria {

void
Criteria::setParams(const boost::shared_ptr<CriteriaParams>& params) {
  params_ = params;
}

const boost::shared_ptr<CriteriaParams>&
Criteria::getParams() const {
  return params_;
}

void
Criteria::addComponentId(const std::string& id, const std::string& voltageLevelId) {
  compIds_.push_back(boost::shared_ptr<ComponentId>(new ComponentId(id, voltageLevelId)));
}

void
Criteria::addCountry(const std::string& id) {
  countryIds_.insert(id);
}

Criteria::component_id_const_iterator
Criteria::begin() const {
  return Criteria::component_id_const_iterator(this, true);
}

Criteria::component_id_const_iterator
Criteria::end() const {
  return Criteria::component_id_const_iterator(this, false);
}

bool
Criteria::containsCountry(const std::string& country) const {
  return countryIds_.find(country) != countryIds_.end();
}

bool
Criteria::hasCountryFilter() const {
  return !countryIds_.empty();
}

/////////////////////////////////////////////////

Criteria::ComponentId::ComponentId(const std::string& id, const std::string& voltageLevelId) :
    id_(id),
    voltageLevelId_(voltageLevelId) {}

const std::string&
Criteria::ComponentId::getId() const {
  return id_;
}

const std::string&
Criteria::ComponentId::getVoltageLevelId() const {
  return voltageLevelId_;
}

/////////////////////////////////////////////////

Criteria::component_id_const_iterator::component_id_const_iterator(const Criteria* iterated, bool begin) :
current_((begin ? iterated->compIds_.begin() : iterated->compIds_.end())) { }

Criteria::component_id_const_iterator&
Criteria::component_id_const_iterator::operator++() {
  ++current_;
  return *this;
}

Criteria::component_id_const_iterator
Criteria::component_id_const_iterator::operator++(int) {
  Criteria::component_id_const_iterator previous = *this;
  current_++;
  return previous;
}

Criteria::component_id_const_iterator&
Criteria::component_id_const_iterator::operator--() {
  --current_;
  return *this;
}

Criteria::component_id_const_iterator
Criteria::component_id_const_iterator::operator--(int) {
  Criteria::component_id_const_iterator previous = *this;
  current_--;
  return previous;
}

bool
Criteria::component_id_const_iterator::operator==(const Criteria::component_id_const_iterator& other) const {
  return current_ == other.current_;
}

bool
Criteria::component_id_const_iterator::operator!=(const Criteria::component_id_const_iterator& other) const {
  return current_ != other.current_;
}

const Criteria::ComponentId&
Criteria::component_id_const_iterator::operator*() const {
  return **current_;
}

const Criteria::ComponentId*
Criteria::component_id_const_iterator::operator->() const {
  return &(**current_);
}

}  // namespace criteria
