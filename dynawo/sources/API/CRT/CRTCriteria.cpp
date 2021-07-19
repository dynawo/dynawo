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
#include "CRTCriteriaImpl.h"

namespace criteria {

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

Criteria::component_id_const_iterator::component_id_const_iterator(const Criteria::Impl* iterated, bool begin) :
impl_(new BaseCompIdConstIteratorImpl(iterated, begin)) { }

Criteria::component_id_const_iterator::component_id_const_iterator(const Criteria::component_id_const_iterator& original) :
impl_(new BaseCompIdConstIteratorImpl(*(original.impl_))) { }

Criteria::component_id_const_iterator::~component_id_const_iterator() {
  delete impl_;
  impl_ = NULL;
}

Criteria::component_id_const_iterator&
Criteria::component_id_const_iterator::operator=(const Criteria::component_id_const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = (other.impl_ == NULL)?NULL:new BaseCompIdConstIteratorImpl(*(other.impl_));
  return *this;
}

Criteria::component_id_const_iterator&
Criteria::component_id_const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

Criteria::component_id_const_iterator
Criteria::component_id_const_iterator::operator++(int) {
  Criteria::component_id_const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

Criteria::component_id_const_iterator&
Criteria::component_id_const_iterator::operator--() {
  --(*impl_);
  return *this;
}

Criteria::component_id_const_iterator
Criteria::component_id_const_iterator::operator--(int) {
  Criteria::component_id_const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
Criteria::component_id_const_iterator::operator==(const Criteria::component_id_const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
Criteria::component_id_const_iterator::operator!=(const Criteria::component_id_const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const Criteria::ComponentId&
Criteria::component_id_const_iterator::operator*() const {
  return *(*impl_);
}

const Criteria::ComponentId*
Criteria::component_id_const_iterator::operator->() const {
  return impl_->operator->();
}


}  // namespace criteria
