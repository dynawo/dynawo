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

#include "DYNDataInterfaceImpl.h"
#include "DYNSwitchInterfaceIIDM.h"
#include "DYNShuntCompensatorInterfaceIIDM.h"
#include "DYNDanglingLineInterfaceIIDM.h"
#include "DYNStaticVarCompensatorInterfaceIIDM.h"
#include "DYNTwoWTransformerInterfaceIIDM.h"
#include "DYNThreeWTransformerInterfaceIIDM.h"
#include "DYNVscConverterInterfaceIIDM.h"
#include "DYNLccConverterInterfaceIIDM.h"
#include "DYNHvdcLineInterfaceIIDM.h"
#include "DYNLineInterfaceIIDM.h"
#include "DYNCalculatedBusInterfaceIIDM.h"
#include "DYNBatteryInterfaceIIDM.h"
#include "DYNBusInterfaceIIDM.h"
#include "DYNLoadInterfaceIIDM.h"
#include "DYNGeneratorInterfaceIIDM.h"
#include "DYNCriteria.h"
#include "DYNNetworkInterfaceIIDM.h"
#include "DYNServiceManagerInterfaceIIDM.h"
#include <powsybl/iidm/Network.hpp>

#include <mutex>

namespace DYN {

/**
 * class DataInterfaceIIDM
 */
class DataInterfaceIIDM : public DataInterfaceImpl {
 public:
  /**
   * @brief Build an instance of this class by reading a file
   * @param iidmFilePath iidm file path
   * @param nbVariants number of variants of the network
   * @return The data interface built from the input file
   */
  static boost::shared_ptr<DataInterface> build(const std::string& iidmFilePath, unsigned int nbVariants = 1);

  /**
   * @brief Constructor
   * @param networkIIDM instance of iidm network
   */
  explicit DataInterfaceIIDM(const boost::shared_ptr<powsybl::iidm::Network>& networkIIDM);

  /**
   * @brief Destructor
   */
  ~DataInterfaceIIDM() override = default;

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
   * @brief getter for the instance of IIDM network
   * @return the instance of IIDM network
   */
  const powsybl::iidm::Network& getNetworkIIDM() const;

  /**
   * @brief dump the network to a file with the proper format
   * @param filepath file to create
   */
  void dumpToFile(const std::string& filepath) const override;

  /**
   * @brief dump the final state of the network in a stream
   * @param stream the stream to export to
   */
  void dumpToFile(std::stringstream& stream) const override;

  /**
   * @copydoc DataInterface::canUseVariant() const
   */
  bool canUseVariant() const override;

  /**
   * @copydoc DataInterface::selectVariant(const std::string& variantName)
   */
  void selectVariant(const std::string& variantName) override;

  /**
   * @copydoc DataInterface::getNetwork() const
   */
  boost::shared_ptr<NetworkInterface> getNetwork() const override;

  /**
   * @copydoc DataInterface::hasDynamicModel(const std::string& id)
   */
  void hasDynamicModel(const std::string& id) override;

  /**
   * @copydoc DataInterface::setDynamicModel(const std::string& componentId, const boost::shared_ptr<SubModel>& model)
   */
  void setDynamicModel(const std::string& componentId, const boost::shared_ptr<SubModel>& model) override;

  /**
   * @copydoc DataInterface::setModelNetwork(const boost::shared_ptr<SubModel>& model)
   */
  void setModelNetwork(const boost::shared_ptr<SubModel>& model) override;

  /**
   * @copydoc DataInterface::setReference(const std::string& componentVar, const std::string& staticId ,const std::string& modelId, const std::string& modelVar)
   */
  void setReference(const std::string& componentVar, const std::string& staticId, const std::string& modelId, const std::string& modelVar) override;

  /**
   * @copydoc DataInterface::mapConnections()
   */
  void mapConnections() override;

  /**
   * @copydoc DataInterface::updateFromModel(bool filterForCriteriaCheck)
   */
  void updateFromModel(bool filterForCriteriaCheck) override;

  /**
   * @copydoc DataInterface::getStateVariableReference()
   */
  void getStateVariableReference() override;

  /**
   * @copydoc DataInterface::importStaticParameters()
   */
  void importStaticParameters() override;

  /**
   * @copydoc DataInterface::exportStateVariables()
   */
  void exportStateVariables() override;

#ifdef _DEBUG_
  /**
   * @brief export values from static variables directly into the IIDM model without updating them
   */
  void exportStateVariablesNoReadFromModel() const;
#endif

  /**
   * @copydoc DataInterface::findConnectedComponents()
   */
  std::shared_ptr<std::vector<std::shared_ptr<ComponentInterface> > > findConnectedComponents() override;

  /**
   * @copydoc DataInterface::findLostEquipments()
   */
  std::unique_ptr<lostEquipments::LostEquipmentsCollection>
    findLostEquipments(const std::shared_ptr<std::vector<std::shared_ptr<ComponentInterface> > >& connectedComponents) override;

  /**
   * @copydoc DataInterface::configureCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria)
   */
  void configureCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria) override;

  /**
   * @copydoc DataInterface::checkCriteria(double t, bool finalStep)
   */
  bool checkCriteria(double t, bool finalStep) override;

  /**
   * @brief fill a vector with the ids of the failing criteria
   * @param failingCriteria vector to fill
   */
  void getFailingCriteria(std::vector<std::pair<double, std::string> >& failingCriteria) const override;

  /**
   * @copydoc DataInterface::getStaticParameterDoubleValue(const std::string& staticID, const std::string& refOrigName)
   */
  double getStaticParameterDoubleValue(const std::string& staticID, const std::string& refOrigName) override;

  /**
   * @copydoc DataInterface::getStaticParameterIntValue(const std::string& staticID, const std::string& refOrigName)
   */
  int getStaticParameterIntValue(const std::string& staticID, const std::string& refOrigName) override;

  /**
   * @copydoc DataInterface::getStaticParameterBoolValue(const std::string& staticID, const std::string& refOrigName)
   */
  bool getStaticParameterBoolValue(const std::string& staticID, const std::string& refOrigName) override;

  /**
   * @copydoc DataInterface::getBusName(const std::string& staticID, const std::string& labelNode)
   */
  std::string getBusName(const std::string& staticID, const std::string& labelNode) override;

  /**
   * @brief find a component thanks to its id
   * @param id : id of the component to find
   *
   * @return instance of component interface found
   */
  std::shared_ptr<ComponentInterface>& findComponent(const std::string& id);

  /**
   * @brief find a component thanks to its id
   * @param id : id of the component to find
   *
   * @return instance of component interface found
   */
  const std::shared_ptr<ComponentInterface>& findComponent(const std::string& id) const;

  /**
   * @copydoc DataInterface::getServiceManager
   */
  boost::shared_ptr<ServiceManagerInterface> getServiceManager() const override {
    return serviceManager_;
  }

  /**
   * @brief Clone data interface
   *
   * This does NOT clone criteria and IIDM network
   *
   * @returns clone of current data interface
   */
  boost::shared_ptr<DataInterface> clone() const final;

  /**
   * @brief find a bus interface thanks to the terminal (works for node_breaker and bus_breaker)
   * @param terminal terminal of the bus interface to find
   *
   * @return instance of bus interface found
   */
  std::shared_ptr<BusInterface> findBusInterface(const powsybl::iidm::Terminal& terminal) const;

 private:
  /**
   * @brief find a bus interface thanks to its iidm
   * @param bus bus interface to find
   *
   * @return instance of bus interface found
   */
  std::shared_ptr<BusInterface> findBusBreakerBusInterface(const powsybl::iidm::Bus& bus) const;
  /**
   * @brief find a bus interface thanks to its iidm voltage level and node
   * @param vl bus voltage level
   * @param node bus node number
   *
   * @return instance of bus interface found
   */
  std::shared_ptr<CalculatedBusInterfaceIIDM> findNodeBreakerBusInterface(const powsybl::iidm::VoltageLevel& vl, const int node) const;

  /**
   * @brief find a voltage level interface thanks to its id
   * @param id id of the voltage level interface to find
   *
   * @return instance of voltage level interface found
   */
  std::shared_ptr<VoltageLevelInterface> findVoltageLevelInterface(const std::string& id) const;

  /**
   * @brief find a calculated bus interface thanks to its voltageLevel id and a bus bar section id
   * @param voltageLevelId id of the voltageLevel where the bus should be found
   * @param bbsId id of a bus bar section associated to the bus to be found
   *
   * @return instance of the calculated bus interface
   */
  std::shared_ptr<BusInterface> findCalculatedBusInterface(const std::string& voltageLevelId, const std::string& bbsId) const;

  /**
   * @brief import and create a voltage level interface thanls to the IIDM instance
   *
   * @param voltageLevelIIDM IIDM instance to use to create voltageLevelInterface
   * @param country country of the parent substation
   * @return the instance VoltageLevelInterface created
   */
  std::shared_ptr<VoltageLevelInterfaceIIDM> importVoltageLevel(powsybl::iidm::VoltageLevel& voltageLevelIIDM,
                                                                const stdcxx::optional<powsybl::iidm::Country>& country);

  /**
   * @brief import and create a switch interface thanks to the IIDM instance
   *
   * @param switchIIDM IIDM instance to use to create switchInterface
   * @param bus1 bus on side 1
   * @param bus2 bus on side 2
   * @return the instance of switchInterface created
   */
  std::unique_ptr<SwitchInterfaceIIDM> importSwitch(powsybl::iidm::Switch& switchIIDM,
                                                    const std::shared_ptr<BusInterface>& bus1,
                                                    const std::shared_ptr<BusInterface>& bus2) const;

  /**
   * @brief import and create a generator interface thanks to the IIDM instance
   *
   * @param generatorIIDM IIDM instance to use to create generatorInterface
   * @param country country of the parent substation
   * @return the instance of GeneratorInterface created
   */
  std::unique_ptr<GeneratorInterfaceIIDM> importGenerator(powsybl::iidm::Generator& generatorIIDM, const std::string& country) const;

  /**
   * @brief import and create a generator interface thanks to the IIDM instance
   *
   * @param batteryIIDM IIDM instance to use to create generatorInterface
   * @param country country of the parent substation
   * @return the instance of GeneratorInterface created
   */
  std::unique_ptr<BatteryInterfaceIIDM> importBattery(powsybl::iidm::Battery& batteryIIDM, const std::string& country) const;

  /**
   * @brief import and create a load interface thanks to the IIDM instance
   *
   * @param loadIIDM IIDM instance to use to create loadInterface
   * @param country country of the parent substation
   * @return the instance of loadInterface created
   */
  std::unique_ptr<LoadInterfaceIIDM> importLoad(powsybl::iidm::Load& loadIIDM, const std::string& country) const;

  /**
   * @brief import and create a shunt interface thanks to the IIDM instance
   *
   * @param shuntIIDM IIDM instance to use to create shuntInterface
   * @return the instance of shuntCompensatorInterface created
   */
  std::unique_ptr<ShuntCompensatorInterfaceIIDM> importShuntCompensator(powsybl::iidm::ShuntCompensator& shuntIIDM) const;

  /**
   * @brief import and create a danglingLine interface thanks to the IIDM instance
   *
   * @param danglingLineIIDM IIDM instance to use to create danglingLineInterface
   * @return the instance of danglingLineInterface created
   */
  std::unique_ptr<DanglingLineInterfaceIIDM> importDanglingLine(powsybl::iidm::DanglingLine& danglingLineIIDM) const;

  /**
   * @brief import and create a svc interface thanks to the IIDM instance
   *
   * @param svcIIDM IIDM instance to use to create svcInterface
   * @return the instance of staticVarCompensatorInterface created
   */
  std::unique_ptr<StaticVarCompensatorInterfaceIIDM> importStaticVarCompensator(powsybl::iidm::StaticVarCompensator& svcIIDM) const;

  /**
   * @brief import and create a two windings transformer interface thanks to the IIDM instance
   *
   * @param twoWTfo IIDM instance to use to create twoWindingsTransformer Interface
   * @return the instance of TwoWTransformerInterface created
   */
  std::unique_ptr<TwoWTransformerInterfaceIIDM> importTwoWindingsTransformer(powsybl::iidm::TwoWindingsTransformer& twoWTfo) const;

  /**
   * @brief conversion of three windings transformer IIDM instance into three two windings transformers interfaces
   *
   * @param threeWTfo IIDM instance to use to create threeWindingsTransformer Interface
   */
  void convertThreeWindingsTransformers(powsybl::iidm::ThreeWindingsTransformer& threeWTfo);

   /**
   * @brief import and create a line interface thanks to the IIDM instance
   *
   * @param lineIIDM IIDM instance to use to create line Interface
   * @return the instance of LineInterface created
   */
  std::unique_ptr<LineInterfaceIIDM> importLine(powsybl::iidm::Line& lineIIDM) const;

  /**
   * @brief import and create a vsc converter interface thanks to the IIDM instance
   *
   * @param vscIIDM IIDM instance to use to create vsc converter interface
   * @return the instance of vscConverterInterface created
   */
  std::unique_ptr<VscConverterInterfaceIIDM> importVscConverter(powsybl::iidm::VscConverterStation& vscIIDM) const;

  /**
   * @brief import and create a lcc converter interface thanks to the IIDM instance
   *
   * @param lccIIDM IIDM instance to use to create lcc converter interface
   * @return the instance of lccConverterInterface created
   */
  std::unique_ptr<LccConverterInterfaceIIDM> importLccConverter(powsybl::iidm::LccConverterStation& lccIIDM) const;

   /**
   * @brief import and create a hvdc line interface thanks to the IIDM instance
   *
   * @param hvdcLineIIDM IIDM instance to use to create hvdc line Interface
   * @return the instance of HvdcLineInterface created
   */
  std::unique_ptr<HvdcLineInterfaceIIDM> importHvdcLine(powsybl::iidm::HvdcLine& hvdcLineIIDM) const;

  /**
   * @brief configure the bus criteria
   *
   * @param criteria criteria to be used
   */
  void configureBusCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @brief configure the load criteria
   *
   * @param criteria criteria to be used
   */
  void configureLoadCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @brief configure the generator criteria
   *
   * @param criteria criteria to be used
   */
  void configureGeneratorCriteria(const std::shared_ptr<criteria::CriteriaCollection>& criteria);

  /**
   * @brief Copy data interface info
   *
   * This does NOT copy criteria and IIDM network
   *
   * @param other data interface to copy
   */
  void copy(const DataInterfaceIIDM& other);

    /**
   * @brief Copy constructor
   *
   * This does NOT clone criteria and IIDM network
   *
   * @param other data interface to clone
   */
  DataInterfaceIIDM(const DataInterfaceIIDM& other);

  /**
   * @brief Assignement operator
   *
   * This does NOT clone criteria and IIDM network
   *
   * @param other data interface to copy
   * @returns current data interface
   */
  DataInterfaceIIDM& operator=(const DataInterfaceIIDM& other);

  /**
   * @brief Load IIDM extensions
   * @param paths paths list
   */
  static void loadExtensions(const std::vector<std::string>& paths);

  /**
   * @brief Setter for timeline
   * @param timeline timeline output
   */
  void setTimeline(const boost::shared_ptr<timeline::Timeline>& timeline) override;

 private:
  boost::shared_ptr<powsybl::iidm::Network> networkIIDM_;                                          ///< instance of the IIDM network
  boost::shared_ptr<NetworkInterfaceIIDM> network_;                                                ///< instance of the network interface
  std::unordered_map<std::string, std::shared_ptr<ComponentInterface> > components_;           ///< map of components
  std::unordered_map<std::string, std::shared_ptr<VoltageLevelInterface> > voltageLevels_;     ///< map of voltageLevel by name
  std::unordered_map<std::string, std::shared_ptr<BusInterface> > busComponents_;              ///< map of bus by name
  std::unordered_map<std::string, std::shared_ptr<LoadInterfaceIIDM> > loadComponents_;        ///< map of loads by name
  std::vector<std::unique_ptr<Criteria> > criteria_;                                             ///< table of criteria to check
  boost::shared_ptr<timeline::Timeline> timeline_;                                                 ///< instance of the timeline where events are stored
  std::unordered_map<std::string, std::shared_ptr<GeneratorInterface> > generatorComponents_;  ///< map of generators by name
  std::unordered_map<std::string, std::vector<std::shared_ptr<CalculatedBusInterfaceIIDM> > > calculatedBusComponents_;  ///< calculatedBus per voltageLevel
  boost::shared_ptr<ServiceManagerInterfaceIIDM> serviceManager_;  ///< Service manager

  std::unordered_map<std::string, std::string> fict2wtIDto3wtID_;                                  ///< map of fictitious 2WTs and their associated 3WT

  static std::mutex loadExtensionMutex_;  ///< Mutex to protect access to singleton for extension during build
};  ///< Generic data interface for IIDM format files
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNDATAINTERFACEIIDM_H_
