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

boost::shared_ptr<DYNErrorQueue> DYNErrorQueue::errorQueue = boost::shared_ptr<DYNErrorQueue>();
const size_t DYNErrorQueue::MaxDisplayedError = 100;

boost::shared_ptr<DYNErrorQueue>&
DYNErrorQueue::get() {
  if (!errorQueue)
    errorQueue.reset(new DYNErrorQueue());
  return errorQueue;
}

void
DYNErrorQueue::push(const DYN::Error& exception) {
  exceptionQueue_.push(exception);
}

void
DYNErrorQueue::flush() {
  size_t nbErrors = exceptionQueue_.size();
  if (nbErrors == 1) {
    const DYN::Error e = exceptionQueue_.front();
    exceptionQueue_.pop();
    throw e;
  }
  for (size_t nbErrorDisplayed = 0;
      !exceptionQueue_.empty() && nbErrorDisplayed < MaxDisplayedError; ++nbErrorDisplayed, exceptionQueue_.pop()) {
    const DYN::Error e = exceptionQueue_.front();
    Trace::error() << e.what() << Trace::endline;
  }
  for (;!exceptionQueue_.empty(); exceptionQueue_.pop());

  if (nbErrors > 0 && nbErrors <= MaxDisplayedError)
    throw DYNError(DYN::Error::GENERAL, MultipleErrors, boost::lexical_cast<std::string>(nbErrors));
  if (nbErrors > MaxDisplayedError)
    throw DYNError(DYN::Error::GENERAL, MultipleAndHiddenErrors, boost::lexical_cast<std::string>(MaxDisplayedError));
}

} /* namespace DYN */
