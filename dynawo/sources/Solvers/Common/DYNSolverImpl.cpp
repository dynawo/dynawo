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
 * @file  DYNSolverImpl.cpp
 *
 * @brief Dynawo solvers : implementation file
 *
 */
#include <fstream>
#include <iostream>
#include <iomanip>
#include <sstream>
#include <nvector/nvector_serial.h>
#include <boost/static_assert.hpp>

#include "DYNSolverImpl.h"

#include "DYNMacrosMessage.h"
#include "DYNMessage.h"
#include "DYNModel.h"
#include "DYNTimer.h"
#include "DYNTrace.h"

#include "PARParametersSet.h"
#include "PARParameter.h"
#include "TLTimeline.h"

using std::endl;
using std::make_pair;
using std::map;
using std::min;
using std::ofstream;
using std::setfill;
using std::setw;
using std::string;
using std::stringstream;
using std::vector;


using timeline::Timeline;

namespace DYN {

namespace conditions {
#if defined LANG_CXX11 || defined LANG_CXX0X
/**
 * @brief Test is the type defining double in sundials is equivalent to double type
 */
static_assert(sizeof (double) == sizeof (realtype), "wrong size of sundials::realtype");
#else
/**
 * @brief Test is the type defining double in sundials is equivalent to double type
 */
BOOST_STATIC_ASSERT_MSG(sizeof (double) == sizeof (realtype), "wrong size of sundials::realtype");
#endif
}  // namespace conditions

Solver::Impl::Impl() :
yy_(NULL),
yp_(NULL),
yId_(NULL),
fnormtolAlg_(1e-4),
initialaddtolAlg_(0.1),
scsteptolAlg_(1e-4),
mxnewtstepAlg_(100000),
msbsetAlg_(5),
mxiterAlg_(30),
printflAlg_(0),
fnormtolAlgJ_(1e-4),
initialaddtolAlgJ_(0.1),
scsteptolAlgJ_(1e-4),
mxnewtstepAlgJ_(100000),
msbsetAlgJ_(1),
mxiterAlgJ_(50),
printflAlgJ_(0),
minimalAcceptableStep_(1e-6),
maximumNumberSlowStepIncrease_(10),
enableSilentZ_(true),
optimizeReinitAlgebraicResidualsEvaluations_(true),
minimumModeChangeTypeForAlgebraicRestoration_(ALGEBRAIC_MODE),
tSolve_(0.),
previousReinit_(None) { }

Solver::Impl::~Impl() {
  clean();
}

void
Solver::Impl::clean() {
  if (yy_ != NULL) N_VDestroy_Serial(yy_);
  if (yp_ != NULL) N_VDestroy_Serial(yp_);
  if (yId_ != NULL) N_VDestroy_Serial(yId_);
}

void
Solver::Impl::init(const double& t0, const boost::shared_ptr<Model> & model) {
  model_ = model;
  model_->setEnableSilentZ(enableSilentZ_);

  // Problem size
  // ---------------------------
  // Continuous variables
  int nbEq = model->sizeY();
  if (nbEq != model->sizeF())
    throw DYNError(Error::SUNDIALS_ERROR, SolverYvsF, nbEq, model->sizeF());

  vYy_.resize(nbEq);
  yy_ = N_VMake_Serial(nbEq, &(vYy_[0]));
  if (yy_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);

  // Derivatives
  vYp_.resize(nbEq);
  yp_ = N_VMake_Serial(nbEq, &(vYp_[0]));
  if (yp_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYP);

  // Algebraic or differential variable indicator (vector<int>)
  yId_ = N_VNew_Serial(nbEq);
  if (yId_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateID);

  // Solver parameters
  // ---------------------
  vYId_.resize(nbEq);
  std::copy(model->getYType(), model->getYType() + model->sizeY(), vYId_.begin());

  double *idx = NV_DATA_S(yId_);
  for (int ieq = 0; ieq < model->sizeY(); ++ieq) {
    idx[ieq] = RCONST(1.0);
    if (vYId_[ieq] != DYN::DIFFERENTIAL)  // Algebraic or external variable
      idx[ieq] = RCONST(0.0);
  }

  // Initial values
  // -----------------
  model_->getY0(t0, vYy_, vYp_);
}

void
Solver::Impl::printHeader() const {
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  Trace::info() << DYNLog(SolverNbYVar, model_->sizeY()) << Trace::endline;
  Trace::info() << DYNLog(SolverNbZVar, model_->sizeZ()) << Trace::endline;
  Trace::info() << DYNLog(NbRootFunctions, model_->sizeG()) << Trace::endline;

  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  stringstream ss;
  ss << "        time ";

  printHeaderSpecific(ss);
  Trace::info() << ss.str() << Trace::endline;
  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
}

void
Solver::Impl::printSolve() const {
  std::stringstream msg;
  msg << setfill(' ') << setw(12) << std::fixed << std::setprecision(3) << getTSolve() << " ";

  printSolveSpecific(msg);

  Trace::info() << msg.str() << Trace::endline;
}

void
Solver::Impl::printParameterValues() const {
  if (!parameters_.empty()) {
    Trace::debug(Trace::parameters()) << "------------------------------" << Trace::endline;
    Trace::debug(Trace::parameters()) << solverType() << " parameters" << " initial parameters"<< Trace::endline;
    Trace::debug(Trace::parameters()) << "------------------------------" << Trace::endline;
  }

  for (std::map<std::string, ParameterSolver>::const_iterator it = parameters_.begin(), itEnd = parameters_.end(); it != itEnd; ++it) {
    const ParameterSolver& parameter = it->second;
    if (!parameter.hasValue()) {
      Trace::debug(Trace::parameters()) << DYNLog(ParamNoValueFound, it->first) << Trace::endline;
      continue;
    }
    switch (parameter.getValueType()) {
      case VAR_TYPE_BOOL: {
        const bool value = parameter.getValue<bool>();
        Trace::debug(Trace::parameters()) << DYNLog(ParamValueInOrigin, it->first, origin2Str(PAR), value) << Trace::endline;
        break;
      }
      case VAR_TYPE_INT: {
        const int value = parameter.getValue<int>();
        Trace::debug(Trace::parameters()) << DYNLog(ParamValueInOrigin, it->first, origin2Str(PAR), value) << Trace::endline;
        break;
      }
      case VAR_TYPE_DOUBLE: {
        const double& value = parameter.getValue<double>();
        Trace::debug(Trace::parameters()) << DYNLog(ParamValueInOrigin, it->first, origin2Str(PAR), value) << Trace::endline;
        break;
      }
      case VAR_TYPE_STRING: {
        const string& value = parameter.getValue<string>();
        Trace::debug(Trace::parameters()) << DYNLog(ParamValueInOrigin, it->first, origin2Str(PAR), value) << Trace::endline;
        break;
      }
      default:
      {
        throw DYNError(Error::MODELER, ParameterNoTypeDetected, it->first);
      }
    }
  }
}

void
Solver::Impl::resetStats() {
  // Statistics reinitialization
  // -------------------------------
  stats_.nst_ = 0;
  stats_.nre_ = 0;
  stats_.nni_ = 0;
  stats_.nje_ = 0;
  stats_.netf_ = 0;
  stats_.ncfn_ = 0;
  stats_.nge_ = 0;
  stats_.nze_ = 0;
  stats_.nme_ = 0;
}

void
Solver::Impl::solve(double tAim, double &tNxt) {
  // Solving
  state_.reset();
  model_->reinitMode();
  model_->rotateBuffers();
  solveStep(tAim, tNxt);

  // Updating values
  tSolve_ = tNxt;
}

bool
Solver::Impl::evalZMode(vector<state_g> &G0, vector<state_g> &G1, const double & time) {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverIMPL::evalZMode");
#endif
  bool change = false;

  // evalZ part
  bool nonSilentZChange;
  int i = 0;
  do {
    nonSilentZChange = false;
    model_->evalZ(time);
    ++stats_.nze_;

    zChangeType_t zChangeType = model_->getSilentZChangeType();
    if (zChangeType == NOT_SILENT_Z_CHANGE
        || zChangeType == NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE) {
      // at least one discrete variable that is used in discrete equations has been modified: continue the propagation
      model_->evalG(time, G1);
      ++stats_.nge_;
      nonSilentZChange = true;
      change = true;
#ifdef _DEBUG_
      printUnstableRoot(time, G0, G1);
      std::copy(G1.begin(), G1.end(), G0.begin());
#endif
    }

    if (zChangeType == NOT_SILENT_Z_CHANGE) {
      state_.setFlags(NotSilentZChange);
    } else if (zChangeType == NOT_USED_IN_CONTINUOUS_EQ_Z_CHANGE) {
      state_.setFlags(SilentZNotUsedInContinuousEqChange);
    } else if (zChangeType == NOT_USED_IN_DISCRETE_EQ_Z_CHANGE) {
      state_.setFlags(SilentZNotUsedInDiscreteEqChange);
    }
    ++i;
    if (i >= maxNumberUnstableRoots)
      throw DYNError(Error::SOLVER_ALGO, SolverUnstableZMode);
  } while (nonSilentZChange);

  std::copy(G1.begin(), G1.end(), G0.begin());

  // evalMode part
  model_->evalMode(time);
  ++stats_.nme_;
  if (model_->modeChange()) {
    change = true;
    state_.setFlags(ModeChange);
  }

  return change;
}

void
Solver::Impl::printUnstableRoot(double t, const vector<state_g> &G0, const vector<state_g> &G1) const {
  int i = 0;
  vector<state_g>::const_iterator iG0(G0.begin());
  vector<state_g>::const_iterator iG1(G1.begin());
  for (; iG0 < G0.end(); iG0++, iG1++, i++) {
    if ((*iG0) != (*iG1)) {
      Trace::debug() << DYNLog(SolverInstableRoot, i, (*iG0), (*iG1), t) << Trace::endline;
      std::string subModelName("");
      int localGIndex(0);
      std::string gEquation("");
      model_->getGInfos(i, subModelName, localGIndex, gEquation);
      Trace::debug() << DYNLog(RootGeq, i, subModelName, gEquation) << Trace::endline;
    }
  }
  Trace::debug() << DYNLog(SolverInstableRootFound) << Trace::endline;
}

void
Solver::Impl::checkUnusedParameters(boost::shared_ptr<parameters::ParametersSet> params) {
  vector<string> unusedParamNameList = params->getParamsUnused();
  for (vector<string>::iterator it = unusedParamNameList.begin();
          it != unusedParamNameList.end();
          ++it) {
    Trace::warn() << DYNLog(ParamUnused, *it, "SOLVER") << Trace::endline;
  }
}

void Solver::Impl::defineParameters() {
  defineCommonParameters();
  defineSpecificParameters();
}

void
Solver::Impl::defineCommonParameters() {
  const bool optional = false;
  // Parameters for the algebraic restoration
  parameters_.insert(make_pair("fnormtolAlg", ParameterSolver("fnormtolAlg", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("initialaddtolAlg", ParameterSolver("initialaddtolAlg", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("scsteptolAlg", ParameterSolver("scsteptolAlg", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("mxnewtstepAlg", ParameterSolver("mxnewtstepAlg", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("msbsetAlg", ParameterSolver("msbsetAlg", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("mxiterAlg", ParameterSolver("mxiterAlg", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("printflAlg", ParameterSolver("printflAlg", VAR_TYPE_INT, optional)));

  // Parameters for the algebraic restoration with J recalculation
  parameters_.insert(make_pair("fnormtolAlgJ", ParameterSolver("fnormtolAlgJ", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("initialaddtolAlgJ", ParameterSolver("initialaddtolAlgJ", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("scsteptolAlgJ", ParameterSolver("scsteptolAlgJ", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("mxnewtstepAlgJ", ParameterSolver("mxnewtstepAlgJ", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("msbsetAlgJ", ParameterSolver("msbsetAlgJ", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("mxiterAlgJ", ParameterSolver("mxiterAlgJ", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("printflAlgJ", ParameterSolver("printflAlgJ", VAR_TYPE_INT, optional)));

  // Parameters related to time-step evolution
  parameters_.insert(make_pair("minimalAcceptableStep", ParameterSolver("minimalAcceptableStep", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("maximumNumberSlowStepIncrease", ParameterSolver("maximumNumberSlowStepIncrease", VAR_TYPE_INT, optional)));

  // Parameters for performance optimization
  parameters_.insert(make_pair("enableSilentZ", ParameterSolver("enableSilentZ", VAR_TYPE_BOOL, optional)));
  parameters_.insert(make_pair("optimizeReinitAlgebraicResidualsEvaluations",
      ParameterSolver("optimizeReinitAlgebraicResidualsEvaluations", VAR_TYPE_BOOL, optional)));
  parameters_.insert(make_pair("minimumModeChangeTypeForAlgebraicRestoration",
      ParameterSolver("minimumModeChangeTypeForAlgebraicRestoration", VAR_TYPE_STRING, optional)));
}

bool
Solver::Impl::hasParameter(const string & nameParameter) {
  map<string, ParameterSolver>::iterator it = parameters_.find(nameParameter);
  return it != parameters_.end();
}

ParameterSolver&
Solver::Impl::findParameter(const string& name) {
  map<string, ParameterSolver>::iterator it = parameters_.find(name);
  if (it == parameters_.end())
    throw DYNError(Error::GENERAL, ParameterNotDefined, name);
  return parameters_.find(name)->second;
}

const std::map<std::string, ParameterSolver>&
Solver::Impl::getParametersMap() const {
  return parameters_;
}

void
Solver::Impl::setParameterFromSet(const string& parName, const boost::shared_ptr<parameters::ParametersSet> parametersSet) {
  if (parametersSet) {
    ParameterSolver& parameter = findParameter(parName);

     // Check if parameter is present in set
    if (parametersSet->hasParameter(parName)) {
      // Set the parameter value with the information given in PAR file
      switch (parameter.getValueType()) {
        case VAR_TYPE_BOOL: {
          const bool value = parametersSet->getParameter(parName)->getBool();
          setParameterValue(parameter, value);
          break;
        }
        case VAR_TYPE_INT: {
          const int value = parametersSet->getParameter(parName)->getInt();
          setParameterValue(parameter, value);
          break;
        }
        case VAR_TYPE_DOUBLE: {
          const double& value = parametersSet->getParameter(parName)->getDouble();
          setParameterValue(parameter, value);
          break;
        }
        case VAR_TYPE_STRING: {
          const string& value = parametersSet->getParameter(parName)->getString();
          setParameterValue(parameter, value);
          break;
        }
        default:
        {
          throw DYNError(Error::GENERAL, ParameterNoTypeDetected, parName);
        }
      }
    } else if (parameter.isMandatory()) {
      throw DYNError(Error::GENERAL, SolverMissingParam, parameter.getName(), parametersSet->getId(), parametersSet->getFilePath());
    }
  } else {
    throw DYNError(Error::GENERAL, ParameterNotReadFromOrigin, origin2Str(PAR), parName);
  }
}

void Solver::Impl::setSolverParameters() {
  setSolverCommonParameters();
  setSolverSpecificParameters();
}

void Solver::Impl::setSolverCommonParameters() {
  const ParameterSolver& fnormtolAlg = findParameter("fnormtolAlg");
  if (fnormtolAlg.hasValue())
    fnormtolAlg_ = fnormtolAlg.getValue<double>();
  const ParameterSolver& initialaddtolAlg = findParameter("initialaddtolAlg");
  if (initialaddtolAlg.hasValue())
    initialaddtolAlg_ = initialaddtolAlg.getValue<double>();
  const ParameterSolver& scsteptolAlg = findParameter("scsteptolAlg");
  if (scsteptolAlg.hasValue())
    scsteptolAlg_ = scsteptolAlg.getValue<double>();
  const ParameterSolver& mxnewtstepAlg = findParameter("mxnewtstepAlg");
  if (mxnewtstepAlg.hasValue())
    mxnewtstepAlg_ = mxnewtstepAlg.getValue<double>();
  const ParameterSolver& msbsetAlg = findParameter("msbsetAlg");
  if (msbsetAlg.hasValue())
    msbsetAlg_ = msbsetAlg.getValue<int>();
  const ParameterSolver& mxiterAlg = findParameter("mxiterAlg");
  if (mxiterAlg.hasValue())
    mxiterAlg_ = mxiterAlg.getValue<int>();
  const ParameterSolver& printflAlg = findParameter("printflAlg");
  if (printflAlg.hasValue())
    printflAlg_ = printflAlg.getValue<int>();

  const ParameterSolver& fnormtolAlgJ = findParameter("fnormtolAlgJ");
  if (fnormtolAlgJ.hasValue())
    fnormtolAlgJ_ = fnormtolAlgJ.getValue<double>();
  const ParameterSolver& initialaddtolAlgJ = findParameter("initialaddtolAlgJ");
  if (initialaddtolAlgJ.hasValue())
    initialaddtolAlgJ_ = initialaddtolAlgJ.getValue<double>();
  const ParameterSolver& scsteptolAlgJ = findParameter("scsteptolAlgJ");
  if (scsteptolAlgJ.hasValue())
    scsteptolAlgJ_ = scsteptolAlgJ.getValue<double>();
  const ParameterSolver& mxnewtstepAlgJ = findParameter("mxnewtstepAlgJ");
  if (mxnewtstepAlgJ.hasValue())
    mxnewtstepAlgJ_ = mxnewtstepAlgJ.getValue<double>();
  const ParameterSolver& msbsetAlgJ = findParameter("msbsetAlgJ");
  if (msbsetAlgJ.hasValue())
    msbsetAlgJ_ = msbsetAlgJ.getValue<int>();
  const ParameterSolver& mxiterAlgJ = findParameter("mxiterAlgJ");
  if (mxiterAlgJ.hasValue())
    mxiterAlgJ_ = mxiterAlgJ.getValue<int>();
  const ParameterSolver& printflAlgJ = findParameter("printflAlgJ");
  if (printflAlgJ.hasValue())
    printflAlgJ_ = printflAlgJ.getValue<int>();

  const ParameterSolver& minimalAcceptableStep = findParameter("minimalAcceptableStep");
  if (minimalAcceptableStep.hasValue())
     minimalAcceptableStep_ = minimalAcceptableStep.getValue<double>();
  const ParameterSolver& maximumNumberSlowStepIncrease = findParameter("maximumNumberSlowStepIncrease");
  if (maximumNumberSlowStepIncrease.hasValue())
    maximumNumberSlowStepIncrease_ = maximumNumberSlowStepIncrease.getValue<int>();

  const ParameterSolver& enableSilentZ = findParameter("enableSilentZ");
  if (enableSilentZ.hasValue())
    enableSilentZ_ = enableSilentZ.getValue<bool>();
  const ParameterSolver& optimizeReinitAlgebraicResidualsEvaluations = findParameter("optimizeReinitAlgebraicResidualsEvaluations");
  if (optimizeReinitAlgebraicResidualsEvaluations.hasValue())
    optimizeReinitAlgebraicResidualsEvaluations_ = optimizeReinitAlgebraicResidualsEvaluations.getValue<bool>();
  const ParameterSolver& minimumModeChangeTypeForAlgebraicRestoration = findParameter("minimumModeChangeTypeForAlgebraicRestoration");
  if (minimumModeChangeTypeForAlgebraicRestoration.hasValue()) {
    std::string value = minimumModeChangeTypeForAlgebraicRestoration.getValue<string>();
    if (value == "ALGEBRAIC")
      minimumModeChangeTypeForAlgebraicRestoration_ = ALGEBRAIC_MODE;
    else if (value == "ALGEBRAIC_J_UPDATE")
      minimumModeChangeTypeForAlgebraicRestoration_ = ALGEBRAIC_J_UPDATE_MODE;
    else
      Trace::warn() << DYNLog(IncoherentParamMinimumModeChangeType, value) << Trace::endline;
  }
}

void
Solver::Impl::setParametersFromPARFile(const boost::shared_ptr<parameters::ParametersSet>& params) {
  // Set values of parameters
  for (map<string, ParameterSolver>::iterator it=parameters_.begin(); it != parameters_.end(); ++it) {
    setParameterFromSet(it->second.getName(), params);
  }
}

void
Solver::Impl::setParameters(const boost::shared_ptr<parameters::ParametersSet>& params) {
  parameters_.clear();
  defineParameters();
  setParametersFromPARFile(params);
  setSolverParameters();
}

void
Solver::Impl::setTimeline(const boost::shared_ptr<Timeline>& timeline) {
  timeline_ = timeline;
}

void
Solver::Impl::printEnd() const {
  // (1) Print on the standard output
  // -----------------------------------
  Trace::info() << Trace::endline;
  Trace::info() << DYNLog(SolverExecutionStats) << Trace::endline;
  Trace::info() << Trace::endline;

  Trace::info() << DYNLog(SolverNbIter, stats_.nst_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbResEval, stats_.nre_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbJacEval, stats_.nje_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbNonLinIter, stats_.nni_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbErrorTestFail, stats_.netf_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbNonLinConvFail, stats_.ncfn_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbRootFuncEval, stats_.nge_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbDiscreteVarsEval, stats_.nze_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbModeEval, stats_.nme_) << Trace::endline;
}


}  // end namespace DYN
