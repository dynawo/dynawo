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
 * @file  DYNBusBarSectionInterfaceIIDM.h
 *
 * @brief Bus bar section data interface : header file for IIDM interface
 *
 */
#ifndef MODELER_DATAINTERFACE_IIDM_DYNBUSBARSECTIONINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNBUSBARSECTIONINTERFACEIIDM_H_

#include <IIDM/components/BusBarSection.h>
#include <boost/optional.hpp>
#include <boost/shared_ptr.hpp>

#include "DYNBusBarSectionInterface.h"

namespace IIDM {
class BusBarSection;
}  // namespace IIDM

namespace DYN {

#ifdef __clang__
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wweak-vtables"
#endif  // __clang__

/**
 * @class BusBarSectionInterfaceIIDM
 * @brief Specialisation of BusBarSectionInterface class for IIDM
 */
class BusBarSectionInterfaceIIDM : public BusBarSectionInterface {
 public:
  /**
   * @brief Destructor
   */
  ~BusBarSectionInterfaceIIDM() { }

  /**
   * @brief Constructor
   * @param bbs : BusBarSection's iidm instance
   */
  explicit BusBarSectionInterfaceIIDM(IIDM::BusBarSection& bbs) : bbs_(bbs) { }

  /**
   * @copydoc BusBarSectionInterface::id() const
   */
  inline std::string id() const {
    return bbs_.id();
  }

  /**
   * @copydoc BusBarSectionInterface::setV( const double& v)
   */
  inline void setV(const double& v) {
    bbs_.v(v);
  }

  /**
   * @copydoc BusBarSectionInterface::setAngle( const double& angle)
   */
  inline void setAngle(const double& angle) {
    bbs_.angle(angle);
  }

 private:
  IIDM::BusBarSection& bbs_;  ///< instance of IIDM bus bar section
};  ///< Interface class for BusBarSection

#ifdef __clang__
#pragma clang diagnostic pop
#endif  // __clang__

}  ///< namespace DYN
#endif  // MODELER_DATAINTERFACE_IIDM_DYNBUSBARSECTIONINTERFACEIIDM_H_
