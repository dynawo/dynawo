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

#ifndef MODELER_DATAINTERFACE_DYNDATAINTERFACEFACTORY_H_
#define MODELER_DATAINTERFACE_DYNDATAINTERFACEFACTORY_H_

#include "DYNDataInterface.h"
#include <boost/shared_ptr.hpp>
#include <boost/unordered_map.hpp>

namespace DYN {

/**
 * @brief DataInterfaceFactory class: factory to handle the different possible formats of static network inputs
 */
class DataInterfaceFactory {
 public:
  /**
   * @brief Type of possibles inputs
   */
  typedef enum {
    DATAINTERFACE_IIDM  ///< Use IIDM library
  } dataInterfaceType_t;

  /**
   * @brief Build an instance of a static network by reading a file
   * @param type format of the file
   * @param filepath input file path
   * @param nbVariants number of variants to handle (relevant only with basic network models with variant)
   * @return The data interface built from the input file
   */
  static boost::shared_ptr<DataInterface> build(dataInterfaceType_t type, const std::string& filepath, unsigned int nbVariants = 1);
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNDATAINTERFACEFACTORY_H_
