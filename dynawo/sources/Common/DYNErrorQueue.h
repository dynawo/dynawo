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

#ifndef COMMON_DYNERRORQUEUE_H_
#define COMMON_DYNERRORQUEUE_H_

#include <queue>
#include <boost/core/noncopyable.hpp>
#include <boost/shared_ptr.hpp>

#include "DYNError.h"

namespace DYN {

/**
 * @class DYNErrorQueue
 * @brief class to register multiple errors before failing
 */
class DYNErrorQueue  : private boost::noncopyable{
 public:
  /**
   * @brief get singleton
   *
   * @return singleton
   */
  static DYNErrorQueue& instance();

  /**
   * @brief register a new error in the queue
   *
   * @param exception error to register
   */
  void push(const DYN::Error& exception);

  /**
   * @brief throw errors if the queue is not empty, otherwise do nothing
   */
  void flush();

  /**
   * @brief Get the maximum number of errors displayed
   *
   * @return maximum number of errors displayed
   */
  size_t getMaxDisplayedError() const;

 private:
  DYNErrorQueue() = default;

 private:
  std::queue< DYN::Error > exceptionQueue_;  ///< error queue
};

} /* namespace DYN */

#endif  // COMMON_DYNERRORQUEUE_H_
