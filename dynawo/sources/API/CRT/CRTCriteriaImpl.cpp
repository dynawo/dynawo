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


#include "CRTCriteriaImpl.h"

namespace criteria {

void
Criteria::Impl::setParams(const boost::shared_ptr<CriteriaParams>& params) {
  params_ = params;
}

const boost::shared_ptr<CriteriaParams>&
Criteria::Impl::getParams() const {
  return params_;
}

void
Criteria::Impl::addComponentId(const std::string& id) {
  compIds_.push_back(id);
}

Criteria::component_id_const_iterator
Criteria::Impl::begin() const {
  return Criteria::component_id_const_iterator(this, true);
}

Criteria::component_id_const_iterator
Criteria::Impl::end() const {
  return Criteria::component_id_const_iterator(this, false);
}

Criteria::BaseCompIdConstIteratorImpl::BaseCompIdConstIteratorImpl(const Criteria::Impl* iterated, bool begin) :
current_((begin ? iterated->compIds_.begin() : iterated->compIds_.end())) { }

Criteria::BaseCompIdConstIteratorImpl::~BaseCompIdConstIteratorImpl() {
}

Criteria::BaseCompIdConstIteratorImpl&
Criteria::BaseCompIdConstIteratorImpl::operator++() {
  ++current_;
  return *this;
}

Criteria::BaseCompIdConstIteratorImpl
Criteria::BaseCompIdConstIteratorImpl::operator++(int) {
  Criteria::BaseCompIdConstIteratorImpl previous = *this;
  current_++;
  return previous;
}

Criteria::BaseCompIdConstIteratorImpl&
Criteria::BaseCompIdConstIteratorImpl::operator--() {
  --current_;
  return *this;
}

Criteria::BaseCompIdConstIteratorImpl
Criteria::BaseCompIdConstIteratorImpl::operator--(int) {
  Criteria::BaseCompIdConstIteratorImpl previous = *this;
  current_--;
  return previous;
}

bool
Criteria::BaseCompIdConstIteratorImpl::operator==(const Criteria::BaseCompIdConstIteratorImpl& other) const {
  return current_ == other.current_;
}

bool
Criteria::BaseCompIdConstIteratorImpl::operator!=(const Criteria::BaseCompIdConstIteratorImpl& other) const {
  return current_ != other.current_;
}

const std::string&
Criteria::BaseCompIdConstIteratorImpl::operator*() const {
  return *current_;
}

const std::string*
Criteria::BaseCompIdConstIteratorImpl::operator->() const {
  return &(*current_);
}

}  // namespace criteria
