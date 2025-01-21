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
#include <iostream>
#include <iomanip>
#include <nvector/nvector_serial.h>

#include "DYNSolverImpl.h"

#include "DYNMacrosMessage.h"
#include "DYNMessage.h"
#include "DYNModel.h"
#include "DYNTimer.h"
#include "DYNTrace.h"

#include "PARParametersSet.h"
#include "TLTimeline.h"

#include "DYNSolverCommon.h"

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
/**
 * @brief Test is the type defining double in sundials is equivalent to double type
 */
static_assert(sizeof (double) == sizeof (realtype), "wrong size of sundials::realtype");
}  // namespace conditions

Solver::~Solver() {}

Solver::Impl::Impl() :
sundialsVectorY_(NULL),
sundialsVectorYp_(NULL),
fnormtolAlg_(1e-4),
fnormtolAlgInit_(1e-4),  // same as fnormtolAlg_
initialaddtolAlg_(0.1),
initialaddtolAlgInit_(0.1),  // same as initialaddtolAlg_
scsteptolAlg_(1e-4),
scsteptolAlgInit_(1e-4),   // same as scsteptolAlg_
mxnewtstepAlg_(100000),
mxnewtstepAlgInit_(100000),   // same as mxnewtstepAlg_
msbsetAlg_(5),
msbsetAlgInit_(5),   // same as msbsetAlg_
mxiterAlg_(30),
mxiterAlgInit_(30),  // same as mxiterAlg_
printflAlg_(0),
printflAlgInit_(0),   // same as printflAlg_
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
minimumModeChangeTypeForAlgebraicRestorationInit_(NO_MODE),
tSolve_(0.),
startFromDump_(false) {
  if (SUNContext_Create(NULL, &sundialsContext_) != 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverContextCreationError);
}

Solver::Impl::~Impl() {
  clean();
  SUNContext_Free(&sundialsContext_);
}

void
Solver::Impl::clean() {
  if (sundialsVectorY_ != NULL) {
    N_VDestroy_Serial(sundialsVectorY_);
    sundialsVectorY_ = NULL;
  }
  if (sundialsVectorYp_ != NULL) {
    N_VDestroy_Serial(sundialsVectorYp_);
    sundialsVectorYp_ = NULL;
  }
}

void
Solver::Impl::init(const double t0, const std::shared_ptr<Model>& model) {
  model_ = model;

  // Problem size
  // ---------------------------
  // Continuous variables
  int nbEq = model->sizeY();
  if (nbEq != model->sizeF())
    throw DYNError(Error::SUNDIALS_ERROR, SolverYvsF, nbEq, model->sizeF());

  vectorY_.resize(nbEq);
  sundialsVectorY_ = N_VMake_Serial(nbEq, &(vectorY_[0]), sundialsContext_);
  if (sundialsVectorY_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);

  // Derivatives
  vectorYp_.assign(nbEq, 0.);
  sundialsVectorYp_ = N_VMake_Serial(nbEq, &(vectorYp_[0]), sundialsContext_);
  if (sundialsVectorYp_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYP);

  // Initial values
  // -----------------
  model_->getY0(t0, vectorY_, vectorYp_);
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
  stringstream msg;
  msg << setfill(' ') << setw(12) << std::scientific << std::setprecision(getPrecisionAsNbDecimal()) << getTSolve() << " ";

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
  stats_.ngeInternal_ = 0;
  stats_.ngeSolver_ = 0;
  stats_.nze_ = 0;
  stats_.nme_ = 0;
  stats_.nreAlgebraic_ = 0;
  stats_.njeAlgebraic_ = 0;
  stats_.nreAlgebraicPrim_ = 0;
  stats_.njeAlgebraicPrim_ = 0;
  stats_.nmeDiff_ = 0;
  stats_.nmeAlg_ = 0;
  stats_.nmeAlgJ_ = 0;
}

void
Solver::Impl::solve(double tAim, double& tNxt) {
  Timer timer("Solver::Impl::solve");
  // Solving
  state_.reset();
  model_->reinitMode();
  model_->rotateBuffers();
  solveStep(tAim, tNxt);

  // Updating values
  tSolve_ = tNxt;
}

bool
Solver::Impl::evalZMode(vector<state_g>& G0, vector<state_g>& G1, double time) {
  // Timer timer("SolverIMPL::evalZMode");
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
      ++stats_.ngeInternal_;
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
Solver::Impl::printUnstableRoot(double t, const vector<state_g>& G0, const vector<state_g>& G1) const {
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
Solver::Impl::checkUnusedParameters(const std::shared_ptr<parameters::ParametersSet>& params) const {
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
  parameters_.insert(make_pair("fnormtolAlgInit", ParameterSolver("fnormtolAlgInit", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("initialaddtolAlg", ParameterSolver("initialaddtolAlg", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("initialaddtolAlgInit", ParameterSolver("initialaddtolAlgInit", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("scsteptolAlg", ParameterSolver("scsteptolAlg", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("scsteptolAlgInit", ParameterSolver("scsteptolAlgInit", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("mxnewtstepAlg", ParameterSolver("mxnewtstepAlg", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("mxnewtstepAlgInit", ParameterSolver("mxnewtstepAlgInit", VAR_TYPE_DOUBLE, optional)));
  parameters_.insert(make_pair("msbsetAlg", ParameterSolver("msbsetAlg", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("msbsetAlgInit", ParameterSolver("msbsetAlgInit", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("mxiterAlg", ParameterSolver("mxiterAlg", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("mxiterAlgInit", ParameterSolver("mxiterAlgInit", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("printflAlg", ParameterSolver("printflAlg", VAR_TYPE_INT, optional)));
  parameters_.insert(make_pair("printflAlgInit", ParameterSolver("printflAlgInit", VAR_TYPE_INT, optional)));

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
  parameters_.insert(make_pair("minimumModeChangeTypeForAlgebraicRestorationInit",
      ParameterSolver("minimumModeChangeTypeForAlgebraicRestorationInit", VAR_TYPE_STRING, optional)));
}

bool
Solver::Impl::hasParameter(const string& nameParameter) {
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
Solver::Impl::setParameterFromSet(const string& parName, const std::shared_ptr<parameters::ParametersSet>& parametersSet) {
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
          const double value = parametersSet->getParameter(parName)->getDouble();
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
  const ParameterSolver& fnormtolAlgInit = findParameter("fnormtolAlgInit");
  fnormtolAlgInit_ = fnormtolAlgInit.hasValue() ? fnormtolAlgInit.getValue<double>() : fnormtolAlg_;

  const ParameterSolver& initialaddtolAlg = findParameter("initialaddtolAlg");
  if (initialaddtolAlg.hasValue())
    initialaddtolAlg_ = initialaddtolAlg.getValue<double>();
  const ParameterSolver& initialaddtolAlgInit = findParameter("initialaddtolAlgInit");
  initialaddtolAlgInit_ = initialaddtolAlgInit.hasValue() ? initialaddtolAlgInit.getValue<double>() : initialaddtolAlg_;

  const ParameterSolver& scsteptolAlg = findParameter("scsteptolAlg");
  if (scsteptolAlg.hasValue())
    scsteptolAlg_ = scsteptolAlg.getValue<double>();
  const ParameterSolver& scsteptolAlgInit = findParameter("scsteptolAlgInit");
  scsteptolAlgInit_ = scsteptolAlgInit.hasValue() ? scsteptolAlgInit.getValue<double>() : scsteptolAlg_;

  const ParameterSolver& mxnewtstepAlg = findParameter("mxnewtstepAlg");
  if (mxnewtstepAlg.hasValue())
    mxnewtstepAlg_ = mxnewtstepAlg.getValue<double>();
  const ParameterSolver& mxnewtstepAlgInit = findParameter("mxnewtstepAlgInit");
  mxnewtstepAlgInit_ = mxnewtstepAlgInit.hasValue() ? mxnewtstepAlgInit.getValue<double>() : mxnewtstepAlg_;

  const ParameterSolver& msbsetAlg = findParameter("msbsetAlg");
  if (msbsetAlg.hasValue())
    msbsetAlg_ = msbsetAlg.getValue<int>();
  const ParameterSolver& msbsetAlgInit = findParameter("msbsetAlgInit");
  msbsetAlgInit_ = msbsetAlgInit.hasValue() ? msbsetAlgInit.getValue<int>() : msbsetAlg_;

  const ParameterSolver& mxiterAlg = findParameter("mxiterAlg");
  if (mxiterAlg.hasValue())
    mxiterAlg_ = mxiterAlg.getValue<int>();
  const ParameterSolver& mxiterAlgInit = findParameter("mxiterAlgInit");
  mxiterAlgInit_ = mxiterAlgInit.hasValue() ? mxiterAlgInit.getValue<int>() : mxiterAlg_;

  const ParameterSolver& printflAlg = findParameter("printflAlg");
  if (printflAlg.hasValue())
    printflAlg_ = printflAlg.getValue<int>();
  const ParameterSolver& printflAlgInit = findParameter("printflAlgInit");
  printflAlgInit_ = printflAlgInit.hasValue() ? printflAlgInit.getValue<int>() : printflAlg_;

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
  const ParameterSolver& minimumModeChangeTypeForAlgebraicRestorationInit = findParameter("minimumModeChangeTypeForAlgebraicRestorationInit");
  if (minimumModeChangeTypeForAlgebraicRestorationInit.hasValue()) {
    std::string value = minimumModeChangeTypeForAlgebraicRestorationInit.getValue<string>();
    if (value == "ALGEBRAIC")
      minimumModeChangeTypeForAlgebraicRestorationInit_ = ALGEBRAIC_MODE;
    else if (value == "ALGEBRAIC_J_UPDATE")
      minimumModeChangeTypeForAlgebraicRestorationInit_ = ALGEBRAIC_J_UPDATE_MODE;
    else
      Trace::warn() << DYNLog(IncoherentParamMinimumModeChangeType, value) << Trace::endline;
  }
}

void
Solver::Impl::setParametersFromPARFile(const std::shared_ptr<parameters::ParametersSet>& params) {
  // Set values of parameters
  for (map<string, ParameterSolver>::iterator it=parameters_.begin(); it != parameters_.end(); ++it) {
    setParameterFromSet(it->second.getName(), params);
  }
}

void
Solver::Impl::setParameters(const std::shared_ptr<parameters::ParametersSet>& params) {
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
  Trace::info() << Trace::endline;
  Trace::info() << DYNLog(SolverExecutionStats) << Trace::endline;
  Trace::info() << Trace::endline;

  Trace::info() << DYNLog(SolverNbIter, stats_.nst_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbResEval, stats_.nre_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbJacEval, stats_.nje_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbNonLinIter, stats_.nni_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbErrorTestFail, stats_.netf_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbNonLinConvFail, stats_.ncfn_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbSolverRootFuncEval, stats_.ngeSolver_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbInternalRootFuncEval, stats_.ngeInternal_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbDiscreteVarsEval, stats_.nze_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbModeEval, stats_.nme_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbModeEvalDiff, stats_.nmeDiff_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbModeEvalAlg, stats_.nmeAlg_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbModeEvalAlgJ, stats_.nmeAlgJ_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbAlgebraicResEval, stats_.nreAlgebraic_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbAlgebraicJacEval, stats_.njeAlgebraic_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbAlgebraicPrimResEval, stats_.nreAlgebraicPrim_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbAlgebraicPrimJacEval, stats_.njeAlgebraicPrim_) << Trace::endline;
  Trace::info() << DYNLog(SolverNbSymoblicJ, SolverCommon::getNumSymbolicFactorization()) << Trace::endline;
}

void
Solver::Impl::printEndConsole() const {
  std::cout << std::endl;
  std::cout << DYNLog(SolverExecutionStats) << std::endl;
  std::cout << std::endl;

  std::cout << DYNLog(SolverNbIter, stats_.nst_) << std::endl;
  std::cout << DYNLog(SolverNbResEval, stats_.nre_) << std::endl;
  std::cout << DYNLog(SolverNbJacEval, stats_.nje_) << std::endl;
  std::cout << DYNLog(SolverNbNonLinIter, stats_.nni_) << std::endl;
  std::cout << DYNLog(SolverNbErrorTestFail, stats_.netf_) << std::endl;
  std::cout << DYNLog(SolverNbNonLinConvFail, stats_.ncfn_) << std::endl;
  std::cout << DYNLog(SolverNbSolverRootFuncEval, stats_.ngeSolver_) << std::endl;
  std::cout << DYNLog(SolverNbInternalRootFuncEval, stats_.ngeInternal_) << std::endl;
  std::cout << DYNLog(SolverNbDiscreteVarsEval, stats_.nze_) << std::endl;
  std::cout << DYNLog(SolverNbModeEval, stats_.nme_) << std::endl;
  std::cout << DYNLog(SolverNbModeEvalDiff, stats_.nmeDiff_) << std::endl;
  std::cout << DYNLog(SolverNbModeEvalAlg, stats_.nmeAlg_) << std::endl;
  std::cout << DYNLog(SolverNbModeEvalAlgJ, stats_.nmeAlgJ_) << std::endl;
  std::cout << DYNLog(SolverNbAlgebraicResEval, stats_.nreAlgebraic_) << std::endl;
  std::cout << DYNLog(SolverNbAlgebraicJacEval, stats_.njeAlgebraic_) << std::endl;
  std::cout << DYNLog(SolverNbAlgebraicPrimResEval, stats_.nreAlgebraicPrim_) << std::endl;
  std::cout << DYNLog(SolverNbAlgebraicPrimJacEval, stats_.njeAlgebraicPrim_) << std::endl;
  std::cout << DYNLog(SolverNbSymoblicJ, SolverCommon::getNumSymbolicFactorization()) << std::endl;
}

}  // end namespace DYN
