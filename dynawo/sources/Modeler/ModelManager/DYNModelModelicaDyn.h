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
 * @file  DYNModelModelicaDyn.h
 *
 * @brief Class for native Modelica models used for dynamic model
 *
 */

#ifndef MODELER_MODELMANAGER_DYNMODELMODELICADYN_H_
#define MODELER_MODELMANAGER_DYNMODELMODELICADYN_H_

#include "DYNModelModelica.h"

namespace DYN {

/**
 * @brief ModelModelicaDyn
 *
 * Class for native Modelica models used for dynamic model
 */
class ModelModelicaDyn : public ModelModelica {
 public:
  /**
   * @brief default destructor
   */
  virtual ~ModelModelicaDyn() { }

 public:
  /**
   * @copydoc ModelModelica::initData(DYNDATA* data)
   */
  virtual void initData(DYNDATA* data) = 0;

  /**
   * @copydoc ModelModelica::initRpar()
   */
  virtual void initRpar() = 0;

  /**
   * @copydoc ModelModelica::setFomc(double* f)
   */
  virtual void setFomc(double* f) = 0;

  /**
   * @copydoc ModelModelica::setGomc(state_g* g)
   */
  virtual void setGomc(state_g* g) = 0;

  /**
   * @copydoc ModelModelica::evalMode(const double & t)const
   */
  virtual bool evalMode(const double & t) const = 0;

  /**
   * @copydoc ModelModelica::setZomc()
   */
  virtual void setZomc() = 0;

  /**
   * @copydoc ModelModelica::setY0omc()
   */
  virtual void setY0omc() = 0;

  /**
   * @copydoc ModelModelica::setParameters( boost::shared_ptr<parameters::ParametersSet> params )
   */
  virtual void setParameters(boost::shared_ptr<parameters::ParametersSet> params) = 0;

  /**
   * @copydoc ModelModelica::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  virtual void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) = 0;

  /**
   * @copydoc ModelModelica::defineParameters(std::vector<ParameterModeler>& parameters)
   */
  virtual void defineParameters(std::vector<ParameterModeler>& parameters) = 0;

  /**
   * @copydoc ModelModelica::checkSum(std::string & checkSum)
   */
  virtual void checkSum(std::string & checkSum) = 0;

#ifdef _ADEPT_

  /**
   * @copydoc ModelModelica::evalFAdept(const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F)
   */
  virtual void evalFAdept(const std::vector<adept::adouble> &y, const std::vector<adept::adouble> &yp, std::vector<adept::adouble> &F) = 0;
#endif

  /**
   * @copydoc ModelModelica::getModelManager() const
   */
  virtual ModelManager* getModelManager() const = 0;

  /**
   * @copydoc ModelModelica::setModelManager (ModelManager* model)
   */
  virtual void setModelManager(ModelManager* model) = 0;

  /**
   * @copydoc ModelModelica::setYType_omc(propertyContinuousVar_t* yType)
   */
  virtual void setYType_omc(propertyContinuousVar_t* yType) = 0;

  /**
   * @copydoc ModelModelica::setFType_omc(propertyF_t* fType)
   */
  virtual void setFType_omc(propertyF_t* fType) = 0;

  /**
   * @copydoc ModelModelica::defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement)
   */
  virtual void defineElements(std::vector<Element> &elements, std::map<std::string, int>& mapElement) = 0;
};
}  // namespace DYN

#endif  // MODELER_MODELMANAGER_DYNMODELMODELICADYN_H_
