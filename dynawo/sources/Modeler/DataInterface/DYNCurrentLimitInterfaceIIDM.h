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
 * @file  DYNCurrentLimitInterfaceIIDM.h
 *
 * @brief Current limit interface : header file for IIDM interface
 *
 */
#ifndef MODELER_DATAINTERFACE_DYNCURRENTLIMITINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNCURRENTLIMITINTERFACEIIDM_H_

#include <boost/optional.hpp>

#include "DYNCurrentLimitInterface.h"

namespace DYN {

class CurrentLimitInterfaceIIDM : public CurrentLimitInterface {
 public:
  /**
   * @brief Destructor
   */
  ~CurrentLimitInterfaceIIDM();

  /**
   * @brief Constructor
   * @param limit limit of the current limit
   * @param duration authorized duration over the limit (Nan if unset)
   */
  CurrentLimitInterfaceIIDM(const boost::optional<double>& limit, const boost::optional<int>& duration);

  /**
   * @copydoc CurrentLimitInterface::getLimit() const
   */
  double getLimit() const;

  /**
   * @copydoc CurrentLimitInterface::getAcceptableDuration() const
   */
  int getAcceptableDuration() const;

 private:
  boost::optional<double> limit_;  ///< limit of the current limit
  int acceptableDuration_;  ///< authorized duration over the limit
};  ///< class for Current limit interface
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCURRENTLIMITINTERFACEIIDM_H_
