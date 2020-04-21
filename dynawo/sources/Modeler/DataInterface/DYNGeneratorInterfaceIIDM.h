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
 * @file  DYNGeneratorInterfaceIIDM.h
 *
 * @brief Generator data interface : header file for IIDM interface
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_DYNGENERATORINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_DYNGENERATORINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>

#include "DYNGeneratorInterface.h"
#include "DYNInjectorInterfaceIIDM.h"

namespace IIDM {
class Generator;
}

namespace DYN {

/**
 * class GeneratorInterfaceIIDM
 */
class GeneratorInterfaceIIDM : public GeneratorInterface, public InjectorInterfaceIIDM<IIDM::Generator> {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_P = 0,
    VAR_Q,
    VAR_STATE
  } indexVar_t;

 public:
  /**
   * @brief Destructor
   */
  ~GeneratorInterfaceIIDM();

  /**
   * @brief Constructor
   * @param generator: generator's iidm instance
   */
  explicit GeneratorInterfaceIIDM(IIDM::Generator& generator);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc GeneratorInterface::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc GeneratorInterface::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc GeneratorInterface::getBusInterface() const
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @copydoc GeneratorInterface::getInitialConnected()
   */
  bool getInitialConnected();

  /**
   * @copydoc GeneratorInterface::getP()
   */
  double getP();

  /**
   * @copydoc GeneratorInterface::getPMin()
   */
  double getPMin();

  /**
   * @copydoc GeneratorInterface::getPMax()
   */
  double getPMax();

  /**
   * @copydoc GeneratorInterface::getQ()
   */
  double getQ();

  /**
   * @copydoc GeneratorInterface::getQMax()
   */
  double getQMax();

  /**
   * @copydoc GeneratorInterface::getQMin()
   */
  double getQMin();

  /**
   * @copydoc GeneratorInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

 private:
  IIDM::Generator& generatorIIDM_;  ///< reference to the iidm generator instance
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNGENERATORINTERFACEIIDM_H_
