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
 * @file  DataInterface/IIDM/DYNLccConverterInterfaceIIDM.h
 *
 * @brief Lcc converter interface : header file for IIDM implementation
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_IIDM_DYNLCCCONVERTERINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNLCCCONVERTERINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNLccConverterInterface.h"
#include "DYNInjectorInterfaceIIDM.h"

namespace IIDM {
class LccConverterStation;
}

namespace DYN {

/**
 * class LccConverterInterfaceIIDM
 */
class LccConverterInterfaceIIDM : public LccConverterInterface, public InjectorInterfaceIIDM<IIDM::LccConverterStation> {
 public:
  /**
   * @brief Destructor
   */
  ~LccConverterInterfaceIIDM();

  /**
   * @brief Constructor
   * @param lcc: lcc converter iidm instance
   */
  explicit LccConverterInterfaceIIDM(IIDM::LccConverterStation& lcc);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc LccConverterInterface::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc LccConverterInterface::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc LccConverterInterface::getBusInterface() const
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @copydoc LccConverterInterface::getInitialConnected()
   */
  bool getInitialConnected();

  /**
   * @copydoc LccConverterInterface::getVNom() const
   */
  double getVNom() const;

  /**
   * @copydoc LccConverterInterface::hasP()
   */
  bool hasP();

  /**
   * @copydoc LccConverterInterface::hasQ()
   */
  bool hasQ();

  /**
   * @copydoc LccConverterInterface::getP()
   */
  double getP();

  /**
   * @copydoc LccConverterInterface::getQ()
   */
  double getQ();

  /**
   * @copydoc LccConverterInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc LccConverterInterface::getLossFactor() const
   */
  double getLossFactor() const;

  /**
   * @copydoc LccConverterInterface::getPowerFactor() const
   */
  double getPowerFactor() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

  /**
   * @brief Getter for the reference to the iidm lcc converter istance
   * @return the iidm lcc converter istance
   */
  IIDM::LccConverterStation& getLccIIDM();

 private:
  IIDM::LccConverterStation& lccConverterIIDM_;  ///< reference to the iidm lcc converter instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNLCCCONVERTERINTERFACEIIDM_H_
