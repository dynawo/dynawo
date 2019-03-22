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
 * @file  TLTimelineFactory.cpp
 *
 * @brief Dynawo timeline factory :  implementation file
 *
 */

#include "TLTimelineFactory.h"
#include "TLTimelineImpl.h"

using std::string;

namespace timeline {

boost::shared_ptr<Timeline>
TimelineFactory::newInstance(const string& id) {
  return boost::shared_ptr<Timeline>(new Timeline::Impl(id));
}

boost::shared_ptr<Timeline>
TimelineFactory::copyInstance(boost::shared_ptr<Timeline> original) {
  return boost::shared_ptr<Timeline>(new Timeline::Impl(dynamic_cast<Timeline::Impl&> (*original)));
}

boost::shared_ptr<Timeline>
TimelineFactory::copyInstance(const Timeline& original) {
  return boost::shared_ptr<Timeline>(new Timeline::Impl(dynamic_cast<const Timeline::Impl&> (original)));
}

}  // namespace timeline
