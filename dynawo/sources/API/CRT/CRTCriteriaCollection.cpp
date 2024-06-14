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

#include "CRTCriteriaCollection.h"

using boost::shared_ptr;

namespace criteria {

void
CriteriaCollection::add(const CriteriaCollectionType_t type, const boost::shared_ptr<Criteria> & criteria) {
  switch (type) {
  case CriteriaCollection::BUS:
    busCriteria_.push_back(criteria);
    break;
  case CriteriaCollection::LOAD:
    loadCriteria_.push_back(criteria);
    break;
  case CriteriaCollection::GENERATOR:
    generatorCriteria_.push_back(criteria);
    break;
  }
}

void
CriteriaCollection::merge(const boost::shared_ptr<CriteriaCollection>& other) {
  const boost::shared_ptr<CriteriaCollection> otherImpl = boost::dynamic_pointer_cast<CriteriaCollection>(other);
  if (!otherImpl) return;
  busCriteria_.insert(busCriteria_.end(), otherImpl->busCriteria_.begin(), otherImpl->busCriteria_.end());
  loadCriteria_.insert(loadCriteria_.end(), otherImpl->loadCriteria_.begin(), otherImpl->loadCriteria_.end());
  generatorCriteria_.insert(generatorCriteria_.end(), otherImpl->generatorCriteria_.begin(), otherImpl->generatorCriteria_.end());
}

}  // namespace criteria
