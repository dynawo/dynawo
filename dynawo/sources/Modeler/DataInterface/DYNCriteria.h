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
#include "CRTCriteriaParams.h"
#include "DYNBusInterface.h"
#include "DYNLoadInterface.h"
#include "DYNGeneratorInterface.h"

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
   *
   * @return true if the criteria is respected, false otherwise
   */
  virtual bool checkCriteria(double t, bool finalStep) = 0;

  /**
   * @brief returns the list of failing criteria
   *
   * @return list of failing criteria
   */
  const std::vector<std::pair<double, std::string> >& getFailingCriteria() const {return failingCriteria_;}

 protected:
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
   *
   * @return true if the criteria is respected, false otherwise
   */
  bool checkCriteria(double t, bool finalStep);

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
   *
   * @return true if the criteria is respected, false otherwise
   */
  bool checkCriteria(double t, bool finalStep);

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

 private:
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
   *
   * @return true if the criteria is respected, false otherwise
   */
  bool checkCriteria(double t, bool finalStep);

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
  std::vector<boost::shared_ptr<GeneratorInterface> > generators_;  ///< loads of this criteria
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_DYNCRITERIA_H_
