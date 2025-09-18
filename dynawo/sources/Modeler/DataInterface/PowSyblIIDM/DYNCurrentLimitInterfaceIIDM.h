//
// Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DataInterface/PowSyblIIDM/DYNCurrentLimitInterfaceIIDM.h
 *
 * @brief Current limit interface : header file for IIDM interface
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITINTERFACEIIDM_H_

#include "DYNCurrentLimitInterface.h"
#include <boost/optional.hpp>

namespace DYN {

/**
 * class CurrentLimitInterfaceIIDM
 */
class CurrentLimitInterfaceIIDM : public CurrentLimitInterface {
 public:
  /**
   * @brief Constructor
   * @param limit limit of the current limit
   * @param duration authorized duration over the limit (Nan if unset)
   * @param fictitious whether the current limit is fictitious
   */
  CurrentLimitInterfaceIIDM(double limit, unsigned long duration, bool fictitious);

  /**
   * @copydoc CurrentLimitInterface::getLimit() const
   */
  double getLimit() const override;

  /**
   * @copydoc CurrentLimitInterface::getAcceptableDuration() const
   */
  int getAcceptableDuration() const override;

  /**
   * @copydoc CurrentLimitInterface::isFictitious() const
   */
  bool isFictitious() const override;

 private:
  double limit_;                             ///< limit of the current limit
  unsigned long acceptableDuration_;         ///< authorized duration over the limit
  bool fictitious_;                         ///< whether the limit is fictitious
};                                 ///< class for Current limit interface
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCURRENTLIMITINTERFACEIIDM_H_
