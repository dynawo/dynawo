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
 * @file  DYNSolverKINAlgRestoration.cpp
 *
 * @brief Implementation of solver based on sundials/KINSOL solver
 *
 */


#include <kinsol/kinsol.h>
#include <sunlinsol/sunlinsol_klu.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <nvector/nvector_serial.h>
#include <string.h>
#include <vector>
#include <cmath>
#include <map>
#include <algorithm>
#include <iomanip>

#include "DYNSolverKINAlgRestoration.h"
#include "DYNSolverCommon.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"

using std::vector;
using std::map;
using std::string;
using std::stringstream;
using boost::shared_ptr;

namespace DYN {

SolverKINAlgRestoration::SolverKINAlgRestoration() :
SolverKINCommon(),
mode_(KIN_NORMAL) {
#if _DEBUG_
  checkJacobian_ = false;
#endif
}

SolverKINAlgRestoration::~SolverKINAlgRestoration() {
  clean();
}

void
SolverKINAlgRestoration::init(const shared_ptr<Model>& model, modeKin_t mode, double fnormtol, double initialaddtol, double scsteptol,
                              double mxnewtstep, int msbset, int mxiter, int printfl) {
  // (1) Arguments
  // --------------
  clean();

  model_ = model;
  mode_ = mode;
  initVarAndEqTypes();

  if (nbF_ == 0)
    return;

  switch (mode) {
    case KIN_NORMAL:
      initCommon("KLU", fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJ_KIN);
      break;
    case KIN_YPRIM:
      initCommon("KLU", fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJPrim_KIN);
      break;
  }
}


void
SolverKINAlgRestoration::initVarAndEqTypes() {
  // For some specific models, the equation type could vary during the simulation.
  model_->evalDynamicFType();
  model_->evalDynamicYType();

  // (2) Size of the problem
  // -------------------------------
  fType_.resize(model_->sizeF());
  std::copy(model_->getFType(), model_->getFType() + model_->sizeF(), fType_.begin());

  vId_.resize(model_->sizeY());
  std::copy(model_->getYType(), model_->getYType() + model_->sizeY(), vId_.begin());
  switch (mode_) {
    case KIN_NORMAL:
      nbF_ = count(fType_.begin(), fType_.end(), DYN::ALGEBRAIC_EQ);  // Only algebraic equation
      break;
    case KIN_YPRIM:
      nbF_ = count(fType_.begin(), fType_.end(), DYN::DIFFERENTIAL_EQ);  // Only differential equation
      break;
  }

  if (nbF_ == 0)
    return;

  F_.resize(model_->sizeF());
  vYy_.assign(nbF_, 0);

  yy_ = N_VMake_Serial(nbF_, &(vYy_[0]));
  if (yy_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);
  // Analyze variables to find differential variables and differential equation
  // depending of the kind of the problem to solve, keep differential variables/equation or algebraic variables/equation
  ignoreY_.clear();  // variables to ignore
  ignoreF_.clear();  // equations to ignore
  indexY_.clear();  // variables to keep
  indexF_.clear();  // equations to keep

  // As sizeF and sizeY are equal, it is possible to fill F and Y vectors in the same loop
  switch (mode_) {
    case KIN_NORMAL: {
      for (int i = 0; i < model_->sizeF(); ++i) {
        if (fType_[i] > 0)
          ignoreF_.insert(i);
        else
          indexF_.push_back(i);

        if (vId_[i] > 0)
          ignoreY_.insert(i);
        else
          indexY_.push_back(i);
      }
      break;
    }
    case KIN_YPRIM: {
      for (int i = 0; i < model_->sizeF(); ++i) {
        if (fType_[i] < 0)
          ignoreF_.insert(i);
        else
          indexF_.push_back(i);

        if (vId_[i] < 0)
          ignoreY_.insert(i);
        else
          indexY_.push_back(i);
      }
      break;
    }
  }

  if (ignoreF_.size() != ignoreY_.size() || indexF_.size() != indexY_.size()) {
#ifdef _DEBUG_
    for (int i = 0; i < model_->sizeF(); ++i) {
      std::string fEquation("");
      std::string subModelName;
      int localFIndex = -1;
      model_->getFInfos(i, subModelName, localFIndex, fEquation);
      Trace::debug() << DYNLog(SolverEquationsType, i, ((fType_[i] > 0)? "differential":"algebraic"), fEquation) << Trace::endline;
    }
    for (int i = 0; i < model_->sizeY(); ++i) {
      Trace::debug() << DYNLog(SolverVariablesType, model_->getVariableName(i), i, ((vId_[i] > 0)? "differential":"algebraic")) << Trace::endline;
    }
#endif
    throw DYNError(Error::SOLVER_ALGO, SolverUnbalanced);
  }
}
void
SolverKINAlgRestoration::modifySettings(double fnormtol, double initialaddtol, double scsteptol, double mxnewtstep,
                  int msbset, int mxiter, int printfl) {
  if (nbF_ == 0)
    return;

  initVarAndEqTypes();

  // Modify tolerances
  int flag = KINSetFuncNormTol(KINMem_, fnormtol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetFuncNormTol");

  flag = KINSetInitialAdditionalTolerance(KINMem_, initialaddtol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetInitialAdditionalTolerance");

  flag = KINSetScaledStepTol(KINMem_, scsteptol);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetScaledStepTol");

  // Modify the maximum allowable scaled step length
  flag = KINSetMaxNewtonStep(KINMem_, mxnewtstep);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxNewtonStep");

  // Modify the maximum number of nonlinear iterations allowed
  flag = KINSetNumMaxIters(KINMem_, mxiter);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNumMaxIters");

  // Modify the maximum number of iteration without preconditionner call (passing 0 means keeping the KINSOL default value, currently 10)
  // Passing 1 means an exact Newton resolution
  flag = KINSetMaxSetupCalls(KINMem_, msbset);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetMaxSetupCalls");

  // Modify the options for error/info messages
  flag = KINSetPrintLevel(KINMem_, printfl);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetPrintLevel");
}

int
SolverKINAlgRestoration::evalF_KIN(N_Vector yy, N_Vector rr, void *data) {
  SolverKINAlgRestoration * solv = reinterpret_cast<SolverKINAlgRestoration*> (data);
  shared_ptr<Model> model = solv->getModel();

  double *irr = NV_DATA_S(rr);
  double *iyy = NV_DATA_S(yy);

  // evalF has already been called in the scaling part so it doesn't have to be called again for the first iteration
  if (solv->getFirstIteration()) {
    solv->setFirstIteration(false);
  } else {
    if (solv->mode_ == KIN_NORMAL) {
      // add current values of algebraic variables
      for (unsigned int i = 0; i < solv->indexY_.size(); ++i) {
        solv->Y_[solv->indexY_[i]] = iyy[i];
      }
      model->evalF(solv->t0_, &solv->Y_[0], &solv->yp0_[0], &solv->F_[0]);
    } else if (solv->mode_ == KIN_YPRIM) {
      for (unsigned int i = 0; i < solv->indexY_.size(); ++i) {
        solv->YP_[solv->indexY_[i]] = iyy[i];
      }
      model->evalFDiff(solv->t0_, &solv->y0_[0], &solv->YP_[0], &solv->F_[0]);
    }
  }

  for (unsigned int i = 0; i < solv->indexF_.size(); ++i) {
    irr[i] = solv->F_[solv->indexF_[i]];
  }

#ifdef _DEBUG_
  // Print the current residual norms, the first one is used as a stopping criterion
  double weightedInfNorm = SolverCommon::weightedInfinityNorm(solv->F_, solv->indexF_, solv->fScale_);
  double wL2Norm = SolverCommon::weightedL2Norm(solv->F_, solv->indexF_, solv->fScale_);
  long int current_nni = 0;
  KINGetNumNonlinSolvIters(solv->KINMem_, &current_nni);
  Trace::debug() << DYNLog(SolverKINResidualNorm, current_nni, weightedInfNorm, wL2Norm) << Trace::endline;

  const int nbErr = 10;
  Trace::debug() << DYNLog(KinLargestErrors, nbErr) << Trace::endline;
  vector<std::pair<double, size_t> > fErr;
  for (size_t i = 0; i < solv->indexF_.size(); ++i)
    fErr.push_back(std::pair<double, size_t>(solv->F_[solv->indexF_[i]], solv->indexF_[i]));
  SolverCommon::printLargestErrors(fErr, model, nbErr);
#endif
  return (0);
}

#if _DEBUG_
void
SolverKINAlgRestoration::checkJacobian(const SparseMatrix& smj, const boost::shared_ptr<Model>& model) {
  SparseMatrix::CheckError error = smj.check();
  std::string sub_model_name;
  std::string equation;
  std::string equation_bis;
  int local_index;
  switch (error.code) {
  case SparseMatrix::CHECK_ZERO_ROW:
    throw DYNError(DYN::Error::SOLVER_ALGO, SolverJacobianWithNulRow, error.info, model->getVariableName(error.info));
  case SparseMatrix::CHECK_ZERO_COLUMN:
    model->getFInfos(error.info, sub_model_name, local_index, equation);
    throw DYNError(DYN::Error::SOLVER_ALGO, SolverJacobianWithNulColumn, error.info, equation);
  case SparseMatrix::CHECK_OK:
    // do nothing
    break;
  }
}
#endif

int
SolverKINAlgRestoration::evalJ_KIN(N_Vector /*yy*/, N_Vector /*rr*/,
         SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKINAlgRestoration* solv = reinterpret_cast<SolverKINAlgRestoration*> (data);
  shared_ptr<Model> model = solv->getModel();

  double cj = 1;
  SparseMatrix smj;
  smj.init(model->sizeY(), model->sizeY());
  model->evalJt(solv->t0_, cj, smj);

  // Erase useless values in the jacobian
  SparseMatrix smjKin;
  int size = solv->indexY_.size();
  smjKin.reserve(size);
  smj.erase(solv->ignoreY_, solv->ignoreF_, smjKin);
#if _DEBUG_
  if (solv->checkJacobian_) {
    checkJacobian(smj, model);
  }
#endif
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smjKin, JJ, size, &solv->lastRowVals_, solv->LS_, solv->linearSolverName_, true);

  return (0);
}

int
SolverKINAlgRestoration::evalJPrim_KIN(N_Vector /*yy*/, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKINAlgRestoration* solv = reinterpret_cast<SolverKINAlgRestoration*> (data);
  shared_ptr<Model> model = solv->getModel();

  double cj = 1;

  SparseMatrix smj;
  smj.init(model->sizeY(), model->sizeY());
  model->evalJtPrim(solv->t0_, cj, smj);

  // Erase useless values in the jacobian
  SparseMatrix smjKin;
  int size = solv->indexY_.size();
  smjKin.reserve(size);
  smj.erase(solv->ignoreY_, solv->ignoreF_, smjKin);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smjKin, JJ, size, &solv->lastRowVals_, solv->LS_, solv->linearSolverName_, true);

  return (0);
}

int
SolverKINAlgRestoration::solve(bool noInitSetup, bool evaluateOnlyModeAtFirstIter) {
  if (nbF_ == 0)
    return KIN_SUCCESS;

  int flag = KINSetNoInitSetup(KINMem_, noInitSetup);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNoInitSetup");

  // first evaluation of F in order to fill the scaling vector
  firstIteration_ = true;
  if (evaluateOnlyModeAtFirstIter)
    model_->evalFMode(t0_, &y0_[0], &yp0_[0], &F_[0]);
  else
    model_->evalF(t0_, &y0_[0], &yp0_[0], &F_[0]);

  // fScale
  fScale_.assign(indexF_.size(), 1.0);
  for (unsigned int i = 0; i < indexF_.size(); ++i) {
    if ( std::abs(F_[indexF_[i]]) > RCONST(1.0))
      fScale_[i] = 1. / std::abs(F_[indexF_[i]]);
  }

  // yScale
  yScale_.assign(indexY_.size(), 1.0);
  for (unsigned int i = 0; i < indexY_.size(); ++i) {
    if (std::abs(vYy_[i]) > RCONST(1.0)) {
      yScale_[i] = 1. / std::abs(vYy_[i]);
    }
  }

  flag = solveCommon();
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverSolveErrorKINSOL);

  return flag;
}

void
SolverKINAlgRestoration::setInitialValues(const double& t, const vector<double>& y, const vector<double>& yp) {
  t0_ = t;
  yp0_.assign(yp.begin(), yp.end());
  y0_.assign(y.begin(), y.end());

  switch (mode_) {
    case KIN_NORMAL: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        vYy_[i] = y0_[indexY_[i]];
      }
      Y_.assign(y0_.begin(), y0_.end());
      break;
    }
    case KIN_YPRIM: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        vYy_[i] = yp0_[indexY_[i]];
      }
      YP_.assign(model_->sizeY(), 0.);
      break;
    }
  }
}

void
SolverKINAlgRestoration::getValues(vector<double>& y, vector<double>& yp) {
  switch (mode_) {
    case KIN_NORMAL: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        y0_[indexY_[i]] = vYy_[i];
      }
      y.assign(y0_.begin(), y0_.end());
      break;
    }
    case KIN_YPRIM: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        yp0_[indexY_[i]] = vYy_[i];
      }
      yp.assign(yp0_.begin(), yp0_.end());
      break;
    }
  }
}

}  // namespace DYN
