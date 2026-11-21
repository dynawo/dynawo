//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain simulation tool for power systems.
//

/**
 * @file  DYNMessageTimeline.hpp
 *
 * @brief DYNMessageTimeline header to implement template operator ,
 *
 */

#ifndef COMMON_DYNMESSAGETIMELINE_HPP_
#define COMMON_DYNMESSAGETIMELINE_HPP_

namespace DYN {

template <typename T>
MessageTimeline& MessageTimeline::operator,(T& x) {
  return static_cast<MessageTimeline&>(Message::operator,(x));
}

template <typename T>
MessageTimeline& MessageTimeline::operator,(const T& x) {
  return static_cast<MessageTimeline&>(Message::operator,(x));
}

}  // namespace DYN

#endif  // COMMON_DYNMESSAGETIMELINE_HPP_
