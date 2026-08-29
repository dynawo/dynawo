//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
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

#include "CRTCriteria.h"

namespace criteria {

void
Criteria::setParams(const std::shared_ptr<CriteriaParams>& params) {
  params_ = params;
}

const std::shared_ptr<CriteriaParams>&
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

bool
Criteria::containsCountry(const std::string& country) const {
  return countryIds_.find(country) != countryIds_.end();
}

bool
Criteria::hasCountryFilter() const {
  return !countryIds_.empty();
}

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

}  // namespace criteria
