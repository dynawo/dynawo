//
// Copyright (c) 2025, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite of
// simulation tools for power systems.
//

/**
 * @file  DYNModelSecondaryVoltageControlSimplified.h
 *
 * @brief simplified discrete secondary voltage control
 *
 */

#ifndef MODELS_CPP_CONTROLS_VOLTAGE_MODELSECONDARYVOLTAGECONTROLSIMPLIFIED_DYNMODELSECONDARYVOLTAGECONTROLSIMPLIFIED_H_
#define MODELS_CPP_CONTROLS_VOLTAGE_MODELSECONDARYVOLTAGECONTROLSIMPLIFIED_DYNMODELSECONDARYVOLTAGECONTROLSIMPLIFIED_H_

#include "DYNModelCPP.h"
#include "DYNModelConstants.h"
#include "DYNSubModelFactory.h"

namespace DYN {
class DataInterface;
/**
 * @brief ModelSecondaryVoltageControlSimplified factory
 *
 * Implementation of @p SubModelFactory template for
 * ModelSecondaryVoltageControlSimplified model
 */
class ModelSecondaryVoltageControlSimplifiedFactory : public SubModelFactory {
 public:
  /**
   * @brief default destructor
   *
   */
  virtual ~ModelSecondaryVoltageControlSimplifiedFactory() = default;
  /**
   * @brief ModelSecondaryVoltageControlSimplified getter
   *
   * @return A pointer to a new instance of ModelSecondaryVoltageControlSimplified
   */
  SubModel *create() const;
  /**
   * @brief ModelSecondaryVoltageControlSimplified destroy
   */
  void destroy(SubModel *) const;
};

/**
 * @brief ModelSecondaryVoltageControlSimplified class
 */
class ModelSecondaryVoltageControlSimplified : public ModelCPP {
 public:
  /**
   * @brief default constructor
   */
  ModelSecondaryVoltageControlSimplified();
  /**
   * @brief get check sum number
   * @return the check sum number associated to the model
   */
  std::string getCheckSum() const override;
  /**
   * @brief  calculated variables type
   */
  typedef enum {
    levelNum_ = 0,
    nbCalculatedVariables_ = 1
  } CalculatedVars_t;
  /**
   * @brief discrete variables indexing
   */
  typedef enum {
    UpRefPuNum_ = 0,
    tLastActivationNum_ = 1,
    levelValNum_ = 2,
    firstIndexBlockerNum_ = 3
  } IndexDiscreteVariable_t;
  /**
   * @brief continuous variables indexing
   */
  typedef enum {
    UpPuNum_ = 0,
    nbContinuousVariables_ = 1
  } IndexContinuousVariable_t;
  /**
   * @brief root variables indexing
   */
  typedef enum {
    ActivationNum_ = 0,
    BlockingNum_ = 1
  } IndexRootVariable_t;

  /**
   * @brief define parameters
   * @param parameters vector to fill with the generic parameters
   */
  void defineParameters(std::vector<ParameterModeler> &parameters) override;
  /**
   * @brief ModelSecondaryVoltageControlSimplified parameters setter
   */
  void setSubModelParameters() override;
  /**
   * @brief initialize variables of the model
   *
   * A variable is a structure which contained all information needed to
   * interact with the model
   * @param variables vector to fill with each variables
   */
  void defineVariables(std::vector<boost::shared_ptr<Variable> > &variables) override;
  /**
   * @brief ModelSecondaryVoltageControlSimplified model initialization
   * @param t0 : initial time of the simulation
   */
  void init(const double t0) override;
  /**
   * @brief set the silent flag for discrete variables
   * @param silentZTable flag table
   */
  void collectSilentZ(BitMask *silentZTable) override;
  /**
   * @brief ModelSecondaryVoltageControlSimplified model's sizes getter
   *
   * Get the sizes of the vectors and matrices used by the solver to simulate
   * ModelSecondaryVoltageControlSimplified instance. Used by @p ModelMulti to generate
   * right size matrices and vector for the solver.
   */
  void getSize() override;
  /**
   * @copydoc ModelCPP::evalStaticYType()
   */
  void evalStaticYType() override;
  /**
   * @copydoc ModelCPP::evalDynamicYType()
   */
  void evalDynamicYType() override { /* not needed */ }
  /**
   * @copydoc ModelCPP::evalStaticFType()
   */
  void evalStaticFType() override { /* not needed */ }
  /**
   * @copydoc ModelCPP::evalDynamicFType()
   */
  void evalDynamicFType() override { /* not needed */ }
  /**
   * @brief ModelSecondaryVoltageControlSimplified F(t,y,y') function evaluation
   *
   * Get the residues' values at a certain instant time with given state
   * variables, state variables derivatives
   *
   * @param t Simulation instant
   * @param[in] type type of the residues to compute (algebraic, differential or
   * both)
   */
  void evalF(double t, propertyF_t type) override;
  /**
   * @copydoc ModelCPP::setFequations()
   */
  void setFequations() override { /* not need */ }
  /**
   * @brief ModelSecondaryVoltageControlSimplified transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y + cj*@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param jt jacobian matrix to fullfill
   * @param rowOffset offset to use to identify the row where data should be
   * added
   */
  void evalJt(double t, double cj, int rowOffset, SparseMatrix &jt) override;
  /**
   * @brief ModelSecondaryVoltageControlSimplified G(t,y,y') function evaluation
   *
   * Get the root's value
   *
   * @param t Simulation instant
   */
  void evalG(const double t) override;
  /**
   * @brief ModelSecondaryVoltageControlSimplified discrete variables evaluation
   *
   * Get the discrete variables' value depending on current simulation instant
   * and current state variables values.
   *
   * @param t Simulation instant
   */
  void evalZ(const double t) override;
  /**
   * @copydoc ModelCPP::getY0()
   */
  void getY0() override;
  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() override { /* not needed */ }
  /**
   * @brief initialize the model from data interface
   *
   * @param data data interface to use to initialize the model
   */
  void initializeFromData(const boost::shared_ptr<DataInterface> &data) override;
  /**
   * @copydoc ModelCPP::initializeStaticData()
   */
  void initializeStaticData() override { /* not needed */ }
  /**
   * @brief calculate calculated variables
   */
  void evalCalculatedVars() override;
  /**
   * @brief evaluate the jacobian associated to a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param res values of the jacobian
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double> &res) const override;
  /**
   * @brief  ModelSecondaryVoltageControlSimplified transposed jacobian evaluation
   *
   * Get the sparse transposed jacobian \f$ Jt=@F/@y' \f$
   *
   * @param t Simulation instant
   * @param cj Jacobian prime coefficient
   * @param rowOffset offset to use to identify the row where data should be
   * added
   * @param jtPrim jacobian matrix to fullfill
   */
  void evalJtPrim(double t, double cj, int rowOffset, SparseMatrix& jtPrim) override;
  /**
   * @brief Model mode change type evaluation
   *
   * Set the mode change type value depending on current simulation instant and
   * current state variables values.
   * @param[in] t Simulation instant
   * @return mode change type value
   */
  modeChangeType_t evalMode(const double t) override;
  /**
   * @brief get the global indexes of the variables used to compute a calculated
   * variable
   *
   * @param iCalculatedVar index of the calculated variable
   * @param indexes vector to fill with the indexes
   *
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int> &indexes) const override;
  /**
   * @copydoc ModelCPP::setGequations()
   */
  void setGequations() override;
  /**
   * @brief evaluate the value of a calculated variable
   *
   * @param iCalculatedVar index of the calculated variable
   *
   * @return value of the calculated variable
   */
  double evalCalculatedVarI(unsigned iCalculatedVar) const override;
  /**
   * @brief ModelSecondaryVoltageControlSimplified elements initializer
   *
   * Define elements for this model (elements to be seen by other models)
   *
   * @param elements  Reference to elements' vector
   * @param mapElement Map associating each element index in the elements vector
   * to its name
   */
  void defineElements(std::vector<Element> &elements, std::map<std::string, int> &mapElement) override;

  /**
   * @copydoc SubModel::dumpUserReadableElementList()
   */
  void dumpUserReadableElementList(const std::string& nameElement) const override;

 protected:
  /**
   * @brief export the internal variables values of the sub model for dump in a stream
   *
   * @param streamVariables : stringstream with binary formated internalVariables
   */
  void dumpInternalVariables(boost::archive::binary_oarchive& streamVariables) const override;

  /**
   * @brief load the internal variables values from a previous dump
   *
   * @param streamVariables : stringstream with binary formated internalVariables
   */
  void loadInternalVariables(boost::archive::binary_iarchive& streamVariables) override;

  void evalStaticYTypeLinearize() override;
  void evalDynamicYTypeLinearize() override;
  void evalStaticFTypeLinearize() override;
  void evalDynamicFTypeLinearize() override;
  void getSizeLinearize() override;
  void defineVariablesLinearize(std::vector<boost::shared_ptr<Variable> >& variables) override;
  void defineParametersLinearize(std::vector<ParameterModeler>& parameters) override;

 private:
  /**
   * @brief evaluate end set antiwindup correction
   */
  void antiWindUpCorrection();

 private:
  int nbGenerators_;              ///< number of generators
  double UDeadBandPu_;            ///< deadband width on difference bewteen UpPu and UpRefPu, in pu (base UNom)
  double alpha_;                  ///< integral gain
  double beta_;                   ///< proportional gain
  double UpRef0Pu_;               ///< initial voltage regulation set point in pu (base UNom)
  double tSample_;                ///< sample time of the SVC in s
  double iTerm_;                  ///< integral tem
  double feedBackCorrection_;     ///< feedback correction
  std::vector<double> Qr_;        ///< participation factor of the generators to the secondary voltage control in Mvar
  std::vector<double> Q0Pu_;      ///< start value of reactive power in pu (receptor convention) (base SnRef) (for each generator connected to the SVC)

  static constexpr double LEVEL_MAX = 1.0;   ///< Maximal admissible level
  static constexpr double LEVEL_MIN = -1.0;  ///< Minimal admissible level
};

}  // namespace DYN

#endif  // MODELS_CPP_CONTROLS_VOLTAGE_MODELSECONDARYVOLTAGECONTROLSIMPLIFIED_DYNMODELSECONDARYVOLTAGECONTROLSIMPLIFIED_H_
