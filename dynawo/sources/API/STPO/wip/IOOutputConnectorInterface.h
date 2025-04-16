//
// Copyright (c) 2024, RTE (http://www.rte-france.com)
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
#include <memory>

#include "IOOutputsCollection.h"

namespace io {
/**
 * @class OutputPublisherInterface
 * @brief Interaface of output connector
 *
 *  for step output connectors
 */
class OutputPublisherInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~OutputPublisherInterface() = default;

  virtual void init() = 0;

  virtual void publish() = 0;

  private:
    std::shared_ptr<OutputsCollection> outputsCollection_;
};

}  // namespace io
