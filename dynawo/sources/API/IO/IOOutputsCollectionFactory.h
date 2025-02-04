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

#ifndef API_IO_IOOUTPUTSCOLLECTIONFACTORY_H_
#define API_IO_IOOUTPUTSCOLLECTIONFACTORY_H_

#include "IOOutputsCollection.h"


namespace io {
/**
 * @class IOOutputsCollectionFactory
 * @brief Outputs collection factory class
 *
 * OutputsCollectionFactory encapsulate methods for creating new
 * @p OutputsCollection objects.
 */
class OutputsCollectionFactory {
 public:
  /**
   * @brief Create new OutputsCollection instance
   *
   * @return shared pointer to a new empty @p OutputsCollection
   */
  static std::shared_ptr<OutputsCollection> newInstance();
};
}  // namespace criteria

#endif  // API_IO_IOOUTPUTSCOLLECTIONFACTORY_H_
