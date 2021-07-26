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
 * @file  DYNModelCPPImpl.h
 *
 * @brief
 *
 */
#ifndef MODELS_CPP_COMMON_DYNMODELCPPIMPL_H_
#define MODELS_CPP_COMMON_DYNMODELCPPIMPL_H_

#include "DYNModelCPP.h"

namespace DYN {
class SparseMatrix;

/**
 * Class ModelCPP::Impl
 */
class ModelCPP::Impl : public ModelCPP {
 public:
  /**
   * @brief constructor
   */
  Impl();
  /**
   * @brief constructor
   * @param modelType
   */
  explicit Impl(std::string modelType);

  /**
   * @brief desctructor
   */
  virtual ~Impl() { }


  // methods to implement in each derived classes
 public:
  /**
   * @copydoc ModelCPP::init(const double& t0)
   */
  virtual void init(const double &t0) = 0;

  /**
   * @brief get the global indexes of the variables used to compute a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  virtual void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const = 0;

  /**
   * @brief evaluate the jacobian associated to a calculated variable based on the current values of continuous variables
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  virtual void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const = 0;

  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @return value of the calculated variable based on the current values of continuous variables
   */
  virtual double evalCalculatedVarI(unsigned iCalculatedVar) const = 0;

  /**
   * @copydoc ModelCPP::evalF(double t, propertyF_t type)
   */
  virtual void evalF(double t, propertyF_t type) = 0;

  /**
   * @copydoc ModelCPP::evalG()
   */
  virtual void evalG(const double & t) = 0;

  /**
   * @copydoc ModelCPP::evalZ()
   */
  virtual void evalZ(const double & t) = 0;

  /**
   * @copydoc ModelCPP::evalJt()
   */
  virtual void evalJt(const double & t, const double & cj, SparseMatrix& jt, const int& rowOffset) = 0;

  /**
   * @copydoc ModelCPP::evalJtPrim()
   */
  virtual void evalJtPrim(const double & t, const double & cj, SparseMatrix& jt, const int& rowOffset) = 0;

  /**
   * @copydoc ModelCPP::evalMode()
   */
  virtual modeChangeType_t evalMode(const double & t) = 0;

  /**
   * @copydoc ModelCPP::getY0()
   */
  virtual void getY0() = 0;

  /**
   * @copydoc ModelCPP::evalYType()
   */
  virtual void evalYType() = 0;

  /**
   * @copydoc ModelCPP::updateYType()
   */
  virtual void updateYType() = 0;

  /**
   * @copydoc ModelCPP::evalFType()
   */
  virtual void evalFType() = 0;

  /**
   * @copydoc ModelCPP::collectSilentZ()
   */
  virtual void collectSilentZ(BitMask* silentZTable) = 0;

  /**
   * @copydoc ModelCPP::updateFType()
   */
  virtual void updateFType() = 0;

  /**
   * @copydoc ModelCPP::getSize()
   */
  virtual void getSize() = 0;

  /**
   * @copydoc ModelCPP::setSubModelParameters()
   */
  virtual void setSubModelParameters() = 0;

  /**
   * @copydoc ModelCPP::defineElements(std::vector<Element> &elements, std::map<std::string, int >& mapElement)
   */
  virtual void defineElements(std::vector<Element> &elements, std::map<std::string, int >& mapElement) = 0;

  /**
   * @copydoc ModelCPP::evalCalculatedVars()
   */
  virtual void evalCalculatedVars() = 0;

  /**
   * @copydoc ModelCPP::defineVariables(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  virtual void defineVariables(std::vector<boost::shared_ptr<Variable> >& variables) = 0;

  /**
   * @copydoc ModelCPP::defineParameters(std::vector<ParameterModeler>& parameters)
   */
  virtual void defineParameters(std::vector<ParameterModeler>& parameters) = 0;

  /**
   * @brief get checksum
   * @return checksum string
   */
  virtual std::string getCheckSum() const = 0;

  /**
   * @copydoc ModelCPP::initializeStaticData()
   */
  virtual void initializeStaticData() = 0;

  /**
   * @brief initialize the model from data interface
   *
   * @param data data interface to use to initialize the model
   */
  virtual void initializeFromData(const boost::shared_ptr<DataInterface> &data) = 0;

  /**
   * @copydoc ModelCPP::setFequations()
   */
  virtual void setFequations() = 0;

  /**
   * @copydoc ModelCPP::setGequations()
   */
  virtual void setGequations() = 0;

  /**
   * @copydoc ModelCPP::initParams()
   */
  virtual void initParams() = 0;

  /**
   * @copydoc ModelCPP::setFequationsInit()
   */
  virtual void setFequationsInit() { /* no init model for most of CPP models */ }

  /**
   * @copydoc ModelCPP::setGequationsInit()
   */
  void setGequationsInit() { /* no init model for CPP models */ }

  /**
   * @copydoc ModelCPP::initSubBuffers()
   */
  virtual void initSubBuffers() { /* no internal buffers for CPP models excepted the network model */ }

 public:
  /**
   * @copydoc ModelCPP::modelType()
   */
  inline std::string modelType() const {
    return modelType_;
  }

  /**
   * @copydoc ModelCPP::dumpParameters()
   */
  void dumpParameters(std::map< std::string, std::string > & mapParameters);

  /**
   * @copydoc ModelCPP::dumpVariables()
   */
  void dumpVariables(std::map< std::string, std::string > & mapVariables);

  /**
   * @copydoc ModelCPP::loadVariables()
   */
  void loadVariables(const std::string &variables);

  /**
   * @copydoc ModelCPP::loadParameters()
   */
  void loadParameters(const std::string &parameters);

  /**
   * @copydoc ModelCPP::checkDataCoherence()
   */
  virtual void checkDataCoherence(const double& t) = 0;

  /**
   * @copydoc ModelCPP::checkParametersCoherence() const
   */
  void checkParametersCoherence() const;

 public:
  /**
   * @copydoc ModelCPP::rotateBuffers()
   */
  void rotateBuffers() { /* not needed */ }

  /**
   * @copydoc ModelCPP::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables)
   */
  void defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& variables);

  /**
   * @copydoc ModelCPP::defineParametersInit(std::vector<ParameterModeler>& parameters)
   */
  void defineParametersInit(std::vector<ParameterModeler>& parameters);

 private:
  std::string modelType_;  ///< model type
};

}  // namespace DYN

#endif  // MODELS_CPP_COMMON_DYNMODELCPPIMPL_H_
