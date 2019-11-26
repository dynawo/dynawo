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

//======================================================================
/**
 * @file  DYNLccConverterInterface.h
 *
 * @brief line-commutated converter interface : header file
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNLCCCONVERTERINTERFACE_H_
#define MODELER_DATAINTERFACE_DYNLCCCONVERTERINTERFACE_H_

#include "DYNConverterInterface.h"

namespace DYN {

class LccConverterInterface : public ConverterInterface {
 public:
  /**
   * @brief Destructor
   */
  virtual ~LccConverterInterface() { }

  /**
   * @brief Getter for the power factor of the lcc converter
   * @return The power factor of the lcc converter
   */
  virtual double getPowerFactor() const = 0;
};  ///< Interface class for Lcc Converter

}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNLCCCONVERTERINTERFACE_H_
