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
 * @file  CRVCurve.cpp
 *
 * @brief Curve : implementation for iterator
 *
 */
#include "CRVCurve.h"
#include "CRVCurveImpl.h"
#include "CRVPoint.h"

using boost::shared_ptr;

namespace curves {

Curve::const_iterator::const_iterator(const Curve::Impl* iterated, bool begin) {
  impl_ = new BaseConstIteratorImpl(iterated, begin);
}

Curve::const_iterator::const_iterator(const Curve::Impl* iterated, bool begin, int i) {
  impl_ = new BaseConstIteratorImpl(iterated, begin, i);
}

Curve::const_iterator::const_iterator(const Curve::const_iterator& original) {
  impl_ = new BaseConstIteratorImpl(*(original.impl_));
}

Curve::const_iterator::~const_iterator() {
  delete impl_;
  impl_ = NULL;
}

Curve::const_iterator&
Curve::const_iterator::operator=(const Curve::const_iterator& other) {
  if (this == &other)
    return *this;
  delete impl_;
  impl_ = new BaseConstIteratorImpl(*(other.impl_));
  return *this;
}

Curve::const_iterator&
Curve::const_iterator::operator++() {
  ++(*impl_);
  return *this;
}

Curve::const_iterator
Curve::const_iterator::operator++(int) {
  Curve::const_iterator previous = *this;
  (*impl_)++;
  return previous;
}

Curve::const_iterator&
Curve::const_iterator::operator--() {
  --(*impl_);
  return *this;
}

Curve::const_iterator
Curve::const_iterator::operator--(int) {
  Curve::const_iterator previous = *this;
  (*impl_)--;
  return previous;
}

bool
Curve::const_iterator::operator==(const Curve::const_iterator& other) const {
  return *impl_ == *(other.impl_);
}

bool
Curve::const_iterator::operator!=(const Curve::const_iterator& other) const {
  return *impl_ != *(other.impl_);
}

const shared_ptr<Point>&
Curve::const_iterator::operator*() const {
  return *(*impl_);
}

const shared_ptr<Point>*
Curve::const_iterator::operator->() const {
  return impl_->operator->();
}


}  // namespace curves
