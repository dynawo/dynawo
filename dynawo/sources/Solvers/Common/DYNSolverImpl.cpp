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
  stringstream ss;
  ss << DYNLog(SolverNbYVar, model_->sizeY());
  Trace::info() << ss.str() << Trace::endline;

  Trace::info() << DYNLog(SolverNbZVar, model_->sizeZ()) << Trace::endline;

  Trace::info() << "-----------------------------------------------------------------------" << Trace::endline;
  ss.str(std::string());
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
  stats_.nje_ = 0;
  stats_.nni_ = 0;
  stats_.netf_ = 0;
  stats_.ncfn_ = 0;
  stats_.nge_ = 0;
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
  Timer timer("SolverIMPL::evalZMode");
  bool zChange = false;
  bool modeChange = false;
  bool stableRoot = true;
  bool change = false;

  for (int i = 0; i < 10; ++i) {
    // evalZ
    model_->evalZ(time);
    zChange = model_->zChange();

    // evaluate G and compare with previous values
    stableRoot = detectUnstableRoot(G0, G1, time);

    if (zChange) {
      change = true;
      state_.setFlags(ZChange);
    } else if (stableRoot) {
      break;
    }
  }

  // evalMode
  model_->evalMode(time);
  modeChange = model_->modeChange();
  if (modeChange) {
    change = true;
    state_.setFlags(ModeChange);
  }
  if (stableRoot)
    return change;

  throw DYNError(Error::SOLVER_ALGO, SolverUnstableZMode);
}

bool
Solver::Impl::detectUnstableRoot(vector<state_g> &vGout0, vector<state_g> &vGout1, const double & time) {
  Timer timer("SolverIMPL::detectUnstableRoot");

  // Evaluate roots after propagation of previous changes
  // ----------------------------------------------------
  model_->evalG(time, vGout1);
  ++stats_.nge_;

  // Find if some roots appears/disappears
  // ---------------------------------------
  bool stableRoot = std::equal(vGout0.begin(), vGout0.end(), vGout1.begin());

  if (!stableRoot) {
#ifdef _DEBUG_
    int i = 0;
    vector<state_g>::const_iterator iG0(vGout0.begin());
    vector<state_g>::const_iterator iG1(vGout1.begin());
    for (; iG0 < vGout0.end(); iG0++, iG1++, i++) {
      if ((*iG0) != (*iG1)) {
        Trace::debug() << DYNLog(SolverInstableRoot, i, (*iG0), (*iG1)) << Trace::endline;
        std::string subModelName("");
        int localGIndex(0);
        std::string gEquation("");
        model_->getGInfos(i, subModelName, localGIndex, gEquation);
        Trace::debug() << DYNLog(RootGeq, i, subModelName, gEquation) << Trace::endline;
      }
    }
    Trace::debug() << DYNLog(SolverInstableRootFound) << Trace::endline;
#endif
    std::copy(vGout1.begin(), vGout1.end(), vGout0.begin());
  }

  return (stableRoot);
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
  // Parameters for the algebraic restoration
  parameters_.insert(make_pair("fnormtolAlg", ParameterSolver("fnormtolAlg", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("initialaddtolAlg", ParameterSolver("initialaddtolAlg", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("scsteptolAlg", ParameterSolver("scsteptolAlg", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("mxnewtstepAlg", ParameterSolver("mxnewtstepAlg", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("msbsetAlg", ParameterSolver("msbsetAlg", VAR_TYPE_INT)));
  parameters_.insert(make_pair("mxiterAlg", ParameterSolver("mxiterAlg", VAR_TYPE_INT)));
  parameters_.insert(make_pair("printflAlg", ParameterSolver("printflAlg", VAR_TYPE_INT)));

  // Parameters for the algebraic restoration with J recalculation
  parameters_.insert(make_pair("fnormtolAlgJ", ParameterSolver("fnormtolAlgJ", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("initialaddtolAlgJ", ParameterSolver("initialaddtolAlgJ", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("scsteptolAlgJ", ParameterSolver("scsteptolAlgJ", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("mxnewtstepAlgJ", ParameterSolver("mxnewtstepAlgJ", VAR_TYPE_DOUBLE)));
  parameters_.insert(make_pair("msbsetAlgJ", ParameterSolver("msbsetAlgJ", VAR_TYPE_INT)));
  parameters_.insert(make_pair("mxiterAlgJ", ParameterSolver("mxiterAlgJ", VAR_TYPE_INT)));
  parameters_.insert(make_pair("printflAlgJ", ParameterSolver("printflAlgJ", VAR_TYPE_INT)));
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
  fnormtolAlg_ = 1e-4;
  initialaddtolAlg_ = 0.1;
  scsteptolAlg_ = 1e-4;
  mxnewtstepAlg_ = 100000;
  msbsetAlg_ = 5;
  mxiterAlg_ = 30;
  printflAlg_ = 0;
  fnormtolAlgJ_ = 1e-4;
  initialaddtolAlgJ_ = 0.1;
  scsteptolAlgJ_ = 1e-4;
  mxnewtstepAlgJ_ = 100000;
  msbsetAlgJ_ = 1;
  mxiterAlgJ_ = 50;
  printflAlgJ_ = 0;

  if (findParameter("fnormtolAlg").hasValue())
    fnormtolAlg_ = findParameter("fnormtolAlg").getValue<double>();
  if (findParameter("initialaddtolAlg").hasValue())
    initialaddtolAlg_ = findParameter("initialaddtolAlg").getValue<double>();
  if (findParameter("scsteptolAlg").hasValue())
    scsteptolAlg_ = findParameter("scsteptolAlg").getValue<double>();
  if (findParameter("mxnewtstepAlg").hasValue())
    mxnewtstepAlg_ = findParameter("mxnewtstepAlg").getValue<double>();
  if (findParameter("msbsetAlg").hasValue())
    msbsetAlg_ = findParameter("msbsetAlg").getValue<int>();
  if (findParameter("mxiterAlg").hasValue())
    mxiterAlg_ = findParameter("mxiterAlg").getValue<int>();
  if (findParameter("printflAlg").hasValue())
    printflAlg_ = findParameter("printflAlg").getValue<int>();

  if (findParameter("fnormtolAlgJ").hasValue())
    fnormtolAlgJ_ = findParameter("fnormtolAlgJ").getValue<double>();
  if (findParameter("initialaddtolAlgJ").hasValue())
    initialaddtolAlgJ_ = findParameter("initialaddtolAlgJ").getValue<double>();
  if (findParameter("scsteptolAlgJ").hasValue())
    scsteptolAlgJ_ = findParameter("scsteptolAlgJ").getValue<double>();
  if (findParameter("mxnewtstepAlgJ").hasValue())
    mxnewtstepAlgJ_ = findParameter("mxnewtstepAlgJ").getValue<double>();
  if (findParameter("msbsetAlgJ").hasValue())
    msbsetAlgJ_ = findParameter("msbsetAlgJ").getValue<int>();
  if (findParameter("mxiterAlgJ").hasValue())
    mxiterAlgJ_ = findParameter("mxiterAlgJ").getValue<int>();
  if (findParameter("printflAlgJ").hasValue())
    printflAlgJ_ = findParameter("printflAlgJ").getValue<int>();
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

}  // end namespace DYN
