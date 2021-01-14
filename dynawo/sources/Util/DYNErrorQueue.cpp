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

#include "DYNErrorQueue.h"

#include <boost/lexical_cast.hpp>

#include "DYNTrace.h"
#include "DYNMacrosMessage.h"

namespace DYN {

size_t ErrorQueue::getMaxDisplayedError() {
  static const size_t maxDisplayedError = 100;
  return maxDisplayedError;
}

ErrorQueue::ErrorQueue() {
}

ErrorQueue::~ErrorQueue() {
}

ErrorQueue&
ErrorQueue::instance() {
  static ErrorQueue instance;
  return instance;
}

void
ErrorQueue::push(const DYN::Error& exception) {
  instance().push_(exception);
}

void
ErrorQueue::push_(const DYN::Error& exception) {
  exceptionQueue_.push(exception);
}

void
ErrorQueue::flush() {
  instance().flush_();
}

void
ErrorQueue::flush_() {
  size_t maxDisplayedError = getMaxDisplayedError();
  size_t nbErrors = exceptionQueue_.size();
  if (nbErrors == 1) {
    const DYN::Error e = exceptionQueue_.front();
    exceptionQueue_.pop();
    throw e;
  }
  for (size_t nbErrorDisplayed = 0;
      !exceptionQueue_.empty() && nbErrorDisplayed < maxDisplayedError; ++nbErrorDisplayed, exceptionQueue_.pop()) {
    const DYN::Error e = exceptionQueue_.front();
    ::TraceError() << e.what() << Trace::endline;
  }
  for (; !exceptionQueue_.empty(); exceptionQueue_.pop())
    continue;

  if (nbErrors > 0 && nbErrors <= maxDisplayedError)
    throw DYNError(DYN::Error::GENERAL, MultipleErrors, boost::lexical_cast<std::string>(nbErrors));
  if (nbErrors > maxDisplayedError)
    throw DYNError(DYN::Error::GENERAL, MultipleAndHiddenErrors, boost::lexical_cast<std::string>(maxDisplayedError));
}

} /* namespace DYN */
