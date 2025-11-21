//
// Copyright (c) 2025, RTE
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
 * @file  DYNModelUpdatableInteger.h
 *
 * @brief Continuous updatable parameter header
 *
 */

#ifndef MODELS_CPP_UPDATABLES_MODELUPDATABLEINTEGER_DYNMODELUPDATABLEINTEGER_H_
#define MODELS_CPP_UPDATABLES_MODELUPDATABLEINTEGER_DYNMODELUPDATABLEINTEGER_H_

#include "DYNModelCPP.h"
#include "DYNModelUpdatable.h"
#include "DYNModelConstants.h"
#include "DYNSubModelFactory.h"
#include "PARParametersSet.h"

namespace DYN {
class DataInterface;
/**
* @brief ModelUpdatableInteger factory
*
* Implementation of @p SubModelFactory template for ModelUpdatableInteger model
*/
class ModelUpdatableIntegerFactory : public SubModelFactory {
 public:
  /**
  * @brief default constructor
  *
  */
  ModelUpdatableIntegerFactory() { /* not needed for DYNModelUpdatableInteger */}
  /**
  * @brief default destructor
  *
  */
  virtual ~ModelUpdatableIntegerFactory() = default;
  /**
  * @brief ModelUpdatableInteger getter
  *
  * @return A pointer to a new instance of ModelUpdatableInteger
  */
  SubModel* create() const;
  /**
  * @brief ModelUpdatableInteger destroy
  */
  void destroy(SubModel*) const;
};

/**
 * class ModelUpdatableInteger
 */
class ModelUpdatableInteger : public ModelUpdatable {
 public:
  /**
   * @brief define type of calculated variables
   *
   */
  typedef enum {
    inputValueIdx_ = 0,
    nbCalculatedVars_ = 1
  } CalculatedVars_t;

  /**
   * @brief Default constructor
   *
   * Creates a new ModelUpdatableInteger instance.
   */
  ModelUpdatableInteger();
  /**
   * @copydoc ModelCPP::getSize()
   */
  void getSize() override;
  /**
   * @copydoc ModelCPP::evalG()
   */
  void evalG(const double t) override;
  /**
   * @copydoc ModelCPP::evalMode()
   */
  modeChangeType_t evalMode(const double t) override;
  /**
   * @copydoc ModelCPP::evalCalculatedVars()
   */
  void evalCalculatedVars() override;
  /**
   * @copydoc ModelCPP::evalCalculatedVarI()
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const override;
  /**
   * @copydoc ModelCPP::setSubModelParameters()
   */
  void setSubModelParameters() override;
  /**
   * @brief Model elements initializer
   * @param[out] elements Reference to elements' vector
   * @param[out] mapElement Map associating each element index in the elements vector to its name
   */
  void defineElements(std::vector<Element>& elements, std::map<std::string, int>& mapElement) override;
  /**
   * @brief initialize variables of the model
   *
   * A variable is a structure which contained all information needed to interact with the model
   * @param[out] variables vector to fill with each variables
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) override;
  /**
   * @brief define parameters
   * @param[out] parameters vector to fill with each parameters
   */
  void defineParameters(std::vector<ParameterModeler>& parameters) override;
  /**
   * @copydoc ModelCPP::getCheckSum()
   */
  std::string getCheckSum() const override;
   /**
   * @copydoc ModelCPP::setGequations()
   */
  void setGequations() override;
  /**
   * @copydoc ModelCPP::dumpInternalVariables()
   */
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const override;
  /**
   * @copydoc ModelCPP::loadInternalVariables()
   */
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables) override;
  /**
   * @copydoc SubModel::dumpUserReadableElementList()
   */
  void dumpUserReadableElementList(const std::string& nameElement) const override;
};

}  // namespace DYN

#endif  // MODELS_CPP_UPDATABLES_MODELUPDATABLEINTEGER_DYNMODELUPDATABLEINTEGER_H_
