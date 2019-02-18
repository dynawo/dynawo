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

const unsigned int affMax = 4;  ///< number of variables to print

/**
 * \def ZERO
 * @brief define the zero value Sundials solver
 *
 * \def ONE
 * @brief define the one value  for Sundials solver
 */
#define ZERO RCONST(0.0);
#define ONE  RCONST(1.0);

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
model_() {
  yy_ = NULL;
  yp_ = NULL;
  yz_ = NULL;
  yId_ = NULL;
}

Solver::Impl::~Impl() {
  clean();
}

void
Solver::Impl::clean() {
  if (yy_ != NULL) N_VDestroy_Serial(yy_);
  if (yz_ != NULL) N_VDestroy_Serial(yz_);
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

  // Discrete variables
  int nbZ = model->sizeZ();
  vYz_.resize(nbZ);
  yz_ = N_VMake_Serial(nbZ, &(vYz_[0]));
  if (yz_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYZ);

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
    idx[ieq] = ONE;
    if (vYId_[ieq] != DYN::DIFFERENTIAL)  // Algebraic or external variable
      idx[ieq] = ZERO;
  }

  // Initial values
  // -----------------
  model_->getY0(t0, vYy_, vYp_, vYz_);
}

void
Solver::Impl::printHeader() {
  Trace::debug() << "-----------------------------------------------------------------------" << Trace::endline;
  stringstream ss;
  ss << DYNLog(SolverNbYVar, model_->sizeY());
  if (affMax < vYy_.size())
    ss << " (" << DYNLog(SolverVarDisplayLimit, affMax) << ")";
  Trace::debug() << ss.str() << Trace::endline;

  Trace::debug() << DYNLog(SolverNbZVar, model_->sizeZ()) << Trace::endline;

  Trace::debug() << "-----------------------------------------------------------------------" << Trace::endline;
  ss.str(std::string());
  ss << "    t        ";
  for (unsigned int i = 0; i < affMax; i++) {
    if (i >= vYy_.size()) break;
    ss << "      y" << i + 1 << "      ";
  }
  ss << "| nst k      h";
  Trace::debug() << ss.str() << Trace::endline;
  Trace::debug() << "-----------------------------------------------------------------------" << Trace::endline;
}

void
Solver::Impl::printSolve() {
  int64_t nst;
  int kused;
  double hused;
  getLastConf(nst, kused, hused);
  std::stringstream msg;
  std::streamsize precision = msg.precision();
  msg << setfill(' ') << setw(12) << std::fixed << std::setprecision(3) << getTSolve() << " ";

  for (unsigned int i = 0; i < affMax; i++) {
    if (i >= vYy_.size()) break;
    double val = vYy_[i];
    msg << std::setprecision(precision) << std::scientific << setw(13) << val << " ";
  }

  msg << "| " << setw(3) << nst << " "
          << setw(1) << kused << " "
          << setw(12) << hused << " ";

  Trace::debug() << msg.str() << Trace::endline;
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
Solver::Impl::solve(double tAim, double &tNxt, std::vector<double> &yNxt, std::vector<double> &ypNxt,
                    std::vector<double> &zNxt, bool &algebraicModeFound) {
  // Solving
  algebraicModeFound = false;
  model_->rotateBuffers();
  solve(tAim, tNxt, algebraicModeFound);

  // Updating values
  yNxt = vYy_;
  ypNxt = vYp_;
  zNxt = vYz_;
  tSolve_ = tNxt;
}

bool
Solver::Impl::evalZMode(vector<state_g> &G0, vector<state_g> &G1, const double & time) {
  Timer timer("SolverIMPL::evalZMode");
  bool zChange = false;
  bool modeChange = false;
  bool change = false;
  for (int i = 0; i < 10; ++i) {
    // evalZ
    model_->evalZ(time, vYy_, vYp_, vYz_);
    zChange = model_->zChange();

    // evalMode
    model_->evalMode(time, vYy_, vYp_, vYz_);
    modeChange = model_->modeChange();

    // evaluate G and compare with previous values
    bool stableRoot = detectUnstableRoot(G0, G1, time);

    if (!zChange && !modeChange && stableRoot)
      return change;
    else
      change = true;
  }

  throw DYNError(Error::SOLVER_ALGO, SolverUnstableZMode);
}

bool
Solver::Impl::detectUnstableRoot(vector<state_g> &vGout0, vector<state_g> &vGout1, const double & time) {
  Timer timer("SolverIMPL::detectUnstableRoot");

  // Evaluate roots after propagation of previous changes
  // ----------------------------------------------------
  model_->evalG(time, vYy_, vYp_, vYz_, vGout1);
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
    Trace::debug() << DYNLog(ParamUnused, *it, "SOLVER") << Trace::endline;
  }
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
        case BOOL: {
          const bool value = parametersSet->getParameter(parName)->getBool();
          setParameterValue(parameter, value);
          Trace::debug("PARAMETERS") << DYNLog(ParamValueInOrigin, parName, origin2Str(PAR), value) << Trace::endline;
          break;
        }
        case INT: {
          const int value = parametersSet->getParameter(parName)->getInt();
          setParameterValue(parameter, value);
          Trace::debug("PARAMETERS") << DYNLog(ParamValueInOrigin, parName, origin2Str(PAR), value) << Trace::endline;
          break;
        }
        case DOUBLE: {
          const double& value = parametersSet->getParameter(parName)->getDouble();
          setParameterValue(parameter, value);
          Trace::debug("PARAMETERS") << DYNLog(ParamValueInOrigin, parName, origin2Str(PAR), value) << Trace::endline;
          break;
        }
        case STRING: {
          const string& value = parametersSet->getParameter(parName)->getString();
          setParameterValue(parameter, value);
          Trace::debug("PARAMETERS") << DYNLog(ParamValueInOrigin, parName, origin2Str(PAR), value) << Trace::endline;
          break;
        }
        default:
        {
          throw DYNError(Error::GENERAL, ParameterNoTypeDetected, parName);
        }
      }
    } else {
      Trace::debug("PARAMETERS") << DYNLog(ParamNoValueInOriginData, parName, origin2Str(PAR)) << Trace::endline;
    }
  } else {
    throw DYNError(Error::GENERAL, ParameterNotReadFromOrigin, origin2Str(PAR), parName);
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

}  // end namespace DYN
