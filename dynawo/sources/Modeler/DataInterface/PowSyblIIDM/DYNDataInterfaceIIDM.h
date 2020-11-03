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
 * @file  DataInterface/PowSyblIIDM/DYNDataInterfaceIIDM.h
 *
 * @brief Data interface : header file of IIDM implementation
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDATAINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDATAINTERFACEIIDM_H_

#include "DYNDataInterface.h"
#include "DYNSwitchInterface.h"
#include "DYNShuntCompensatorInterface.h"
#include "DYNDanglingLineInterface.h"
#include "DYNStaticVarCompensatorInterface.h"
#include "DYNTwoWTransformerInterface.h"
#include "DYNThreeWTransformerInterface.h"
#include "DYNVscConverterInterface.h"
#include "DYNLccConverterInterface.h"
#include "DYNHvdcLineInterface.h"
#include "DYNLineInterface.h"
#include "DYNCriteria.h"
#include <powsybl/iidm/Network.hpp>
#include <boost/unordered_set.hpp>

namespace DYN {

class DataInterfaceIIDM : public DataInterface {
 public:
  /**
   * @brief Build an instance of this class by reading a file
   * @param iidmFilePath iidm file path
   * @return The data interface built from the input file
   */
  static boost::shared_ptr<DataInterface> build(std::string iidmFilePath);
  /**
   * @brief Constructor
   * @param networkIIDM instance of iidm network
   */
  explicit DataInterfaceIIDM(powsybl::iidm::Network& networkIIDM);

  /**
   * @brief Destructor
   */
  ~DataInterfaceIIDM();

  /**
   * @brief init dataInterface from iidm network
   */
  void initFromIIDM();

  /**
   * @brief getter for the instance of IIDM network
   * @return the instance of IIDM network
   */
  powsybl::iidm::Network& getNetworkIIDM();

  /**
   * @brief dump the network to a file with the proper format
   * @param filepath file to create
   */
  void dumpToFile(const std::string& filepath) const;

  /**
   * @copydoc DataInterface::getNetwork() const
   */
  boost::shared_ptr<NetworkInterface> getNetwork() const;

  /**
   * @copydoc DataInterface::hasDynamicModel(const std::string& id)
   */
  void hasDynamicModel(const std::string& id);

  /**
   * @copydoc DataInterface::setDynamicModel(const std::string& componentId, const boost::shared_ptr<SubModel>& model)
   */
  void setDynamicModel(const std::string& componentId, const boost::shared_ptr<SubModel>& model);

  /**
   * @copydoc DataInterface::setModelNetwork(const boost::shared_ptr<SubModel>& model)
   */
  void setModelNetwork(const boost::shared_ptr<SubModel>& model);

  /**
   * @copydoc DataInterface::setReference(const std::string& componentVar, const std::string& staticId ,const std::string& modelId, const std::string& modelVar)
   */
  void setReference(const std::string& componentVar, const std::string& staticId, const std::string& modelId, const std::string& modelVar);

  /**
   * @copydoc DataInterface::mapConnections()
   */
  void mapConnections();

  /**
   * @copydoc DataInterface::updateFromModel(bool filterForCriteriaCheck)
   */
  void updateFromModel(bool filterForCriteriaCheck);

  /**
   * @copydoc DataInterface::getStateVariableReference()
   */
  void getStateVariableReference();

  /**
   * @copydoc DataInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc DataInterface::exportStateVariables()
   */
  void exportStateVariables();

#ifdef _DEBUG_
  /**
   * @brief export values from static variables directly into the IIDM model without updating them
   */
  void exportStateVariablesNoReadFromModel();
#endif

  /**
   * @copydoc DataInterface::configureCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria)
   */
  void configureCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @copydoc DataInterface::checkCriteria(double t, bool finalStep)
   */
  bool checkCriteria(double t, bool finalStep);

  /**
   * @brief fill a vector with the ids of the failing criteria
   * @param failingCriteria vector to fill
   */
  void getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const;

  /**
   * @copydoc DataInterface::getStaticParameterDoubleValue(const std::string& staticID, const std::string& refOrigName)
   */
  double getStaticParameterDoubleValue(const std::string& staticID, const std::string& refOrigName);

  /**
   * @copydoc DataInterface::getStaticParameterIntValue(const std::string& staticID, const std::string& refOrigName)
   */
  int getStaticParameterIntValue(const std::string& staticID, const std::string& refOrigName);

  /**
   * @copydoc DataInterface::getStaticParameterBoolValue(const std::string& staticID, const std::string& refOrigName)
   */
  bool getStaticParameterBoolValue(const std::string& staticID, const std::string& refOrigName);

  /**
   * @copydoc DataInterface::getBusName(const std::string& staticID, const std::string& labelNode)
   */
  std::string getBusName(const std::string& staticID, const std::string& labelNode);

  /**
   * @brief find a component thanks to its id
   * @param id : id of the component to find
   *
   * @return instance of component interface found
   */
  boost::shared_ptr<ComponentInterface>& findComponent(const std::string& id);

 private:
  /**
   * @brief find a bus interface thanks to its id
   * @param id: id of the bus interface to find
   *
   * @return instance of bus interface found
   */
  boost::shared_ptr<BusInterface> findBusInterface(const std::string& id) const;

  /**
   * @brief find a voltage level interface thanks to its id
   * @param id: id of the voltage level interface to find
   *
   * @return instance of voltage level interface found
   */
  boost::shared_ptr<VoltageLevelInterface> findVoltageLevelInterface(const std::string& id) const;

  /**
   * @brief import and create a voltage level interface thanls to the IIDM instance
   *
   * @param voltageLevelIIDM IIDM instance to use to create voltageLevelInterface
   * @param country country of the parent substation
   * @return the instance VoltageLevelInterface created
   */
  boost::shared_ptr<VoltageLevelInterface> importVoltageLevel(powsybl::iidm::VoltageLevel& voltageLevelIIDM,
      const stdcxx::optional<powsybl::iidm::Country>& country);

  /**
   * @brief import and create a switch interface thanks to the IIDM instance
   *
   * @param switchIIDM IIDM instance to use to create switchInterface
   * @param bus1 bus on side 1
   * @param bus2 bus on side 2
   * @return the instance of switchInterface created
   */
  boost::shared_ptr<SwitchInterface> importSwitch(powsybl::iidm::Switch& switchIIDM, const boost::shared_ptr<BusInterface>& bus1
      , const boost::shared_ptr<BusInterface>& bus2);

  /**
   * @brief import and create a generator interface thanks to the IIDM instance
   *
   * @param generatorIIDM IIDM instance to use to create generatorInterface
   * @param country country of the parent substation
   * @return the instance of GeneratorInterface created
   */
  boost::shared_ptr<GeneratorInterface> importGenerator(powsybl::iidm::Generator & generatorIIDM, const std::string& country);

  /**
   * @brief import and create a load interface thanks to the IIDM instance
   *
   * @param loadIIDM IIDM instance to use to create loadInterface
   * @param country country of the parent substation
   * @return the instance of loadInterface created
   */
  boost::shared_ptr<LoadInterface> importLoad(powsybl::iidm::Load& loadIIDM, const std::string& country);

  /**
   * @brief import and create a shunt interface thanks to the IIDM instance
   *
   * @param shuntIIDM IIDM instance to use to create shuntInterface
   * @return the instance of shuntCompensatorInterface created
   */
  boost::shared_ptr<ShuntCompensatorInterface> importShuntCompensator(powsybl::iidm::ShuntCompensator& shuntIIDM);

  /**
   * @brief import and create a danglingLine interface thanks to the IIDM instance
   *
   * @param danglingLineIIDM IIDM instance to use to create danglingLineInterface
   * @return the instance of danglingLineInterface created
   */
  boost::shared_ptr<DanglingLineInterface> importDanglingLine(powsybl::iidm::DanglingLine& danglingLineIIDM);

  /**
   * @brief import and create a svc interface thanks to the IIDM instance
   *
   * @param svcIIDM IIDM instance to use to create svcInterface
   * @return the instance of staticVarCompensatorInterface created
   */
  boost::shared_ptr<StaticVarCompensatorInterface> importStaticVarCompensator(powsybl::iidm::StaticVarCompensator& svcIIDM);

  /**
   * @brief import and create a two windings transformer interface thanks to the IIDM instance
   *
   * @param twoWTfo IIDM instance to use to create twoWindingsTransformer Interface
   * @return the instance of TwoWTransformerInterface created
   */
  boost::shared_ptr<TwoWTransformerInterface> importTwoWindingsTransformer(powsybl::iidm::TwoWindingsTransformer & twoWTfo);

  /**
   * @brief import and create a three windings transformer interface thanks to the IIDM instance
   *
   * @param threeWTfo IIDM instance to use to create threeWindingsTransformer Interface
   * @return the instance of ThreeWTransformerInterface created
   */
  boost::shared_ptr<ThreeWTransformerInterface> importThreeWindingsTransformer(powsybl::iidm::ThreeWindingsTransformer & threeWTfo);

   /**
   * @brief import and create a line interface thanks to the IIDM instance
   *
   * @param lineIIDM IIDM instance to use to create line Interface
   * @return the instance of LineInterface created
   */
  boost::shared_ptr<LineInterface>  importLine(powsybl::iidm::Line& lineIIDM);

  /**
   * @brief import and create a vsc converter interface thanks to the IIDM instance
   *
   * @param vscIIDM: IIDM instance to use to create vsc converter interface
   * @return the instance of vscConverterInterface created
   */
  boost::shared_ptr<VscConverterInterface> importVscConverter(powsybl::iidm::VscConverterStation& vscIIDM);

  /**
   * @brief import and create a lcc converter interface thanks to the IIDM instance
   *
   * @param lccIIDM: IIDM instance to use to create lcc converter interface
   * @return the instance of lccConverterInterface created
   */
  boost::shared_ptr<LccConverterInterface> importLccConverter(powsybl::iidm::LccConverterStation& lccIIDM);

   /**
   * @brief import and create a hvdc line interface thanks to the IIDM instance
   *
   * @param hvdcLineIIDM IIDM instance to use to create hvdc line Interface
   * @return the instance of HvdcLineInterface created
   */
  boost::shared_ptr<HvdcLineInterface> importHvdcLine(powsybl::iidm::HvdcLine& hvdcLineIIDM);

  /**
   * @brief configure the bus criteria
   *
   * @param criteria criteria to be used
   */
  void configureBusCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @brief configure the load criteria
   *
   * @param criteria criteria to be used
   */
  void configureLoadCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @brief configure the generator criteria
   *
   * @param criteria criteria to be used
   */
  void configureGeneratorCriteria(const boost::shared_ptr<criteria::CriteriaCollection>& criteria);

 private:
  powsybl::iidm::Network& networkIIDM_;                                                            ///< instance of the IIDM network
  boost::shared_ptr<NetworkInterface> network_;                                                    ///< instance of the network interface
  boost::unordered_map<std::string, boost::shared_ptr<ComponentInterface> > components_;           ///< map of components
  boost::unordered_map<std::string, boost::shared_ptr<VoltageLevelInterface> > voltageLevels_;     ///< map of voltageLevel by name
  boost::unordered_map<std::string, boost::shared_ptr<BusInterface> > busComponents_;              ///< map of bus by name
  boost::unordered_map<std::string, boost::shared_ptr<LoadInterface> > loadComponents_;            ///< map of loads by name
  std::vector<boost::shared_ptr<Criteria> > criteria_;                                             ///< table of criteria to check
  boost::unordered_map<std::string, boost::shared_ptr<GeneratorInterface> > generatorComponents_;  ///< map of generators by name
};  ///< Generic data interface for IIDM format files
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDATAINTERFACEIIDM_H_
