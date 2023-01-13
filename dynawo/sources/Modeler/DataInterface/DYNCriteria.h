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

#ifndef MODELER_DATAINTERFACE_DYNCRITERIA_H_
#define MODELER_DATAINTERFACE_DYNCRITERIA_H_

#include <boost/shared_ptr.hpp>
#include <boost/unordered_set.hpp>
#include "CRTCriteriaParams.h"
#include "DYNBusInterface.h"
#include "DYNLoadInterface.h"
#include "DYNGeneratorInterface.h"
#include "TLTimeline.h"
#include <map>

namespace DYN {

/**
 * @brief Criteria class: handle the check of criteria
 */
class Criteria {
 public:
  /**
   * @brief Constructor
   * @param params parameters of the criteria
   */
  explicit Criteria(const boost::shared_ptr<criteria::CriteriaParams>& params);

  /**
   * @brief Destructor
   */
  virtual ~Criteria();

  /**
   * @brief returns true if the criteria is respected, false otherwise
   * @param t current time of the simulation
   * @param finalStep true if this is the final step of the simulation
   * @param timeline timeline
   *
   * @return true if the criteria is respected, false otherwise
   */
  virtual bool checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline = nullptr) = 0;

  /**
   * @brief returns the list of failing criteria
   *
   * @return list of failing criteria
   */
  const std::vector<std::pair<double, std::string> >& getFailingCriteria() const {return failingCriteria_;}

 protected:
  /**
   * @brief Crossed bound for a failing criteria
   */
  enum class Bound {
    MAX = 0,  ///< Upper bound
    MIN       ///< Lower bound
  };
  /**
   * @brief structure containing information about a failing criteria and related methods
   */
  class FailingCriteria {
   public:
    /**
     * @brief constructor
     * @param bound Crossed bound for a failing criteria
     * @param nodeId Node id
     * @param criteriaId Criteria id
     */
    FailingCriteria(Bound bound, std::string nodeId, const std::string& criteriaId);

    /**
     * @brief Destructor
     */
    virtual ~FailingCriteria() = default;

    /**
     * @brief return the distance between the current value tested and the threshold
     * @return the distance between the current value tested and the threshold
     */
    virtual double getDistance() const = 0;

    /**
     * @brief print the failing criteria log in the log file
     */
    virtual void printOneFailingCriteriaIntoLog() const = 0;

    /**
     * @brief print the failing criteria log in the timeline file
     * @param timeline timeline
     * @param failingCriteria list of failing criteria
     * @param currentTime current simulation time
     */
    virtual void printOneFailingCriteriaIntoTimeline(const boost::shared_ptr<timeline::Timeline>& timeline,
                                                      std::vector<std::pair<double, std::string> >& failingCriteria,
                                                      double currentTime) const = 0;

   protected:
    Bound bound_;                   // Crossed bound : min or max
    std::string nodeId_;            // node id
    const std::string criteriaId_;  // criteria id
  };

  /**
   * @brief print all the failing criteria in the log file and the timeline file
   * @param distanceToFailingCriteriaMap map which contains the distance between a specific value and the crossed
   *                                      criteria bound and the related FailingCriteria object
   * @param timeline timeline
   * @param currentTime current simulation time
   */
  void printAllFailingCriteriaIntoLog(std::multimap<double, std::shared_ptr<FailingCriteria> >& distanceToFailingCriteriaMap,
                                      const boost::shared_ptr<timeline::Timeline>& timeline,
                                      double currentTime);

  const boost::shared_ptr<criteria::CriteriaParams>& params_;  ///< parameters of this criteria
  std::vector<std::pair<double, std::string> > failingCriteria_;  ///< keeps the ids of the failing criteria
};

/**
 * @brief BusCriteria class: handle the check of bus criteria
 */
class BusCriteria : public Criteria {
 public:
  /**
   * @brief Constructor
   * @param params parameters of the criteria
   */
  explicit BusCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params);

  /**
   * @brief Destructor
   */
  ~BusCriteria();

  /**
   * @brief check that this criteria can be applied to buses
   * @param params parameters of the criteria
   * @return true if this criteria is compatible with buses
   */
  static bool criteriaEligibleForBus(const boost::shared_ptr<criteria::CriteriaParams>& params);

  /**
   * @brief returns true if the criteria is respected, false otherwise
   * @param t current time of the simulation
   * @param finalStep true if this is the final step of the simulation
   * @param timeline timeline
   *
   * @return true if the criteria is respected, false otherwise
   */
  bool checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline = nullptr);

  /**
   * @brief add a bus to the criteria
   * @param bus bus to add
   */
  void addBus(const boost::shared_ptr<BusInterface>& bus);

  /**
   * @brief returns true if no bus was added
   * @return true if no bus was added
   */
  bool empty() const {return buses_.empty();}

  /**
   * @brief structure containing information about a failing criteria on a bus and related methods
   */
  class BusFailingCriteria : public FailingCriteria {
   public:
    /**
     * @brief Constructor
     * @param bound Crossed bound for a failing criteria
     * @param busId bud id
     * @param v voltage in kV
     * @param vPu voltage in pu
     * @param vBound voltage bound in kV
     * @param vBoundPu voltage bound in pu
     * @param criteriaId criteria id
     */
    BusFailingCriteria(Bound bound,
                        std::string busId,
                        double v,
                        double vPu,
                        double vBound,
                        double vBoundPu,
                        const std::string& criteriaId);

    /**
     * @brief return the distance between the voltage in pu and the crossed criteria bound
     * @return the distance between the voltage in pu and the crossed criteria bound
     */
    double getDistance() const override { return std::abs(vPu_ - vBoundPu_); }

    /**
     * @brief print the failing criteria log in the log file
     */
    void printOneFailingCriteriaIntoLog() const override;

    /**
     * @brief print the failing criteria log in the timeline file
     * @param timeline timeline
     * @param failingCriteria array containing the failing criteria messages
     * @param currentTime current simulation time
     */
    void printOneFailingCriteriaIntoTimeline(const boost::shared_ptr<timeline::Timeline>& timeline,
                                              std::vector<std::pair<double, std::string> >& failingCriteria,
                                              double currentTime) const override;

   private:
    double v_;                      // bus voltage in kV
    double vPu_;                    // bus voltage in pu
    double vBound_;                 // bus voltage limit in kV
    double vBoundPu_;               // bus voltage limit in pu
  };

 private:
  std::vector<boost::shared_ptr<BusInterface> > buses_;  ///< buses of this criteria
};


/**
 * @brief LoadCriteria class: handle the check of load criteria
 */
class LoadCriteria : public Criteria {
 public:
  /**
   * @brief Constructor
   * @param params parameters of the criteria
   */
  explicit LoadCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params);

  /**
   * @brief Destructor
   */
  ~LoadCriteria();

  /**
   * @brief check that this criteria can be applied to loads
   * @param params parameters of the criteria
   * @return true if this criteria is compatible with loads
   */
  static bool criteriaEligibleForLoad(const boost::shared_ptr<criteria::CriteriaParams>& params);

  /**
   * @brief returns true if the criteria is respected, false otherwise
   * @param t current time of the simulation
   * @param finalStep true if this is the final step of the simulation
   * @param timeline timeline
   *
   * @return true if the criteria is respected, false otherwise
   */
  bool checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline = nullptr);

  /**
   * @brief add a load to the criteria
   * @param load load to add
   */
  void addLoad(const boost::shared_ptr<LoadInterface>& load);

  /**
   * @brief returns true if no load was added
   * @return true if no load was added
   */
  bool empty() const {return loads_.empty();}

  /**
   * @brief structure containing information about a failing criteria on a load and related methods
   */
  class LoadFailingCriteria : public FailingCriteria {
   public:
    /**
     * @brief Constructor
     * @param bound Crossed bound for a failing criteria
     * @param loadId load id
     * @param p load power in MW
     * @param pBound load power bound in MW
     * @param criteriaId criteria id
     */
    LoadFailingCriteria(Bound bound,
                        std::string loadId,
                        double p,
                        double pBound,
                        const std::string& criteriaId);

    /**
     * @brief return the distance between the load power in MW and the crossed criteria bound
     * @return the distance between the load power in MW and the crossed criteria bound
     */
    double getDistance() const override { return std::abs(p_ - pBound_); }

     /**
     * @brief print the failing criteria log in the log file
     */
    void printOneFailingCriteriaIntoLog() const override;

    /**
     * @brief print the failing criteria log in the timeline file
     * @param timeline timeline
     * @param failingCriteria array containing the failing criteria messages
     * @param currentTime current simulation time
     */
    void printOneFailingCriteriaIntoTimeline(const boost::shared_ptr<timeline::Timeline>& timeline,
                                              std::vector<std::pair<double, std::string> >& failingCriteria,
                                              double currentTime) const override;

   private:
    double p_;                      // load power in MW
    double pBound_;                 // load power limit in MW
  };

 private:
  /**
   * @brief check criteria in type LOCAL_VALUE or SUM
   *
   * @param load load to check
   * @param loadActivePower active power of the load to check
   * @param loadToSourcesAddedIntoSumMap map associating active power to the related load
   * @param distanceToLoadFailingCriteriaMap map associating the distance between active power and the crossed bound, and the related load
   * @param alreadyChecked set containing the loads already checked to not check them several times
   * @param isCriteriaOk true if criteria is ok, false otherwise
   * @param sum sum of network loads active powers
   * @param atLeastOneEligibleLoadWasFound true if there is at least one load to calculate the sum of network loads active powers
   */
  void checkCriteriaInLocalValueOrSumType(boost::shared_ptr<DYN::LoadInterface> load,
                                          double loadActivePower,
                                          std::multimap<double, boost::shared_ptr<LoadInterface> >& loadToSourcesAddedIntoSumMap,
                                          std::multimap<double, std::shared_ptr<FailingCriteria> >& distanceToLoadFailingCriteriaMap,
                                          std::unordered_set<std::string>& alreadyChecked,
                                          bool& isCriteriaOk,
                                          double& sum,
                                          bool& atLeastOneEligibleLoadWasFound);

  std::vector<boost::shared_ptr<LoadInterface> > loads_;  ///< loads of this criteria
};


/**
 * @brief GeneratorCriteria class: handle the check of generator criteria
 */
class GeneratorCriteria : public Criteria {
 public:
  /**
   * @brief Constructor
   * @param params parameters of the criteria
   */
  explicit GeneratorCriteria(const boost::shared_ptr<criteria::CriteriaParams>& params);

  /**
   * @brief Destructor
   */
  ~GeneratorCriteria();

  /**
   * @brief check that this criteria can be applied to generators
   * @param params parameters of the criteria
   * @return true if this criteria is compatible with generators
   */
  static bool criteriaEligibleForGenerator(const boost::shared_ptr<criteria::CriteriaParams>& params);

  /**
   * @brief returns true if the criteria is respected, false otherwise
   * @param t current time of the simulation
   * @param finalStep true if this is the final step of the simulation
   * @param timeline timeline
   *
   * @return true if the criteria is respected, false otherwise
   */
  bool checkCriteria(double t, bool finalStep, const boost::shared_ptr<timeline::Timeline>& timeline = nullptr);

  /**
   * @brief add a generator to the criteria
   * @param generator generator to add
   */
  void addGenerator(const boost::shared_ptr<GeneratorInterface>& generator);

  /**
   * @brief returns true if no generator was added
   * @return true if no generator was added
   */
  bool empty() const {return generators_.empty();}

 private:
  /**
   * @brief check criteria in type LOCAL_VALUE or SUM
   *
   * @param generator generator to check
   * @param generatorActivePower active power of the generator to check
   * @param generatorToSourcesAddedIntoSumMap map associating active power to the related generator
   * @param distanceToGeneratorFailingCriteriaMap map associating the distance between active power and the crossed bound, and the related generator
   * @param alreadyChecked set containing the generators already checked to not check them several times
   * @param isCriteriaOk true if criteria is ok, false otherwise
   * @param sum sum of network generators active powers
   * @param atLeastOneEligibleGeneratorWasFound true if there is at least one generator to calculate the sum of network generators active powers
   */
  void checkCriteriaInLocalValueOrSumType(boost::shared_ptr<DYN::GeneratorInterface> generator,
                                          double generatorActivePower,
                                          std::multimap<double, boost::shared_ptr<GeneratorInterface> >& generatorToSourcesAddedIntoSumMap,
                                          std::multimap<double, std::shared_ptr<FailingCriteria> >& distanceToGeneratorFailingCriteriaMap,
                                          std::unordered_set<std::string>& alreadyChecked,
                                          bool& isCriteriaOk,
                                          double& sum,
                                          bool& atLeastOneEligibleGeneratorWasFound);

  std::vector<boost::shared_ptr<GeneratorInterface> > generators_;  ///< loads of this criteria
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCRITERIA_H_
