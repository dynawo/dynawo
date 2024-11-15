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
#include <sundials/sundials_types.h>
#include <nvector/nvector_serial.h>

#include <string>
#include <vector>
#include <cmath>

#include "DYNSolverKINAlgRestoration.h"
#include "DYNModel.h"
#include "DYNSolverCommon.h"
#include "DYNSparseMatrix.h"

#include "DYNTrace.h"
#include "DYNMacrosMessage.h"

using std::vector;
using std::string;

namespace DYN {

string
SolverKINAlgRestoration::stringFromMode(const modeKin_t mode) {
  switch (mode) {
    case KIN_ALGEBRAIC:
      return "algebraic";
    case KIN_DERIVATIVES:
      return "derivatives";
    default:
      throw DYNError(Error::GENERAL, InvalidAlgebraicMode, static_cast<int>(mode));
  }
}

SolverKINAlgRestoration::SolverKINAlgRestoration() :
SolverKINCommon(),
mode_(KIN_ALGEBRAIC) {
#if _DEBUG_
  checkJacobian_ = false;
#endif
}

SolverKINAlgRestoration::~SolverKINAlgRestoration() {
  cleanAlgebraicVectors();
}

void
SolverKINAlgRestoration::cleanAlgebraicVectors() {
  if (sundialsVectorY_ != NULL) {
    N_VDestroy_Serial(sundialsVectorY_);
    sundialsVectorY_ = NULL;
  }
}

void SolverKINAlgRestoration::resetAlgebraicRestoration() {
  clean();
  cleanAlgebraicVectors();
  numF_ = 0;
}

void
SolverKINAlgRestoration::init(const std::shared_ptr<Model>& model, const modeKin_t mode) {
  model_ = model;
  mode_ = mode;
}

unsigned int
SolverKINAlgRestoration::initVarAndEqTypes() {
  // For some specific models, the equation type could vary during the simulation.
  model_->evalDynamicFType();
  model_->evalDynamicYType();

  const vector<propertyF_t>& modelFType = model_->getFType();
  const vector<propertyContinuousVar_t>& modelYType = model_->getYType();

  // Analyze variables to find differential variables and differential equation
  // depending of the kind of the problem to solve, keep differential variables/equation or algebraic variables/equation
  ignoreY_.clear();  // variables to ignore
  ignoreF_.clear();  // equations to ignore
  indexY_.clear();  // variables to keep
  indexF_.clear();  // equations to keep
  unsigned int numF = 0;

  // As sizeF and sizeY are equal, it is possible to fill F and Y vectors in the same loop
  switch (mode_) {
    case KIN_ALGEBRAIC: {
      for (int i = 0; i < model_->sizeF(); ++i) {
        if (modelFType[i] > 0) {
          ignoreF_.insert(i);
        } else {
          indexF_.push_back(i);
          ++numF;
        }

        if (modelYType[i] > 0)
          ignoreY_.insert(i);
        else
          indexY_.push_back(i);
      }
      break;
    }
    case KIN_DERIVATIVES: {
      for (int i = 0; i < model_->sizeF(); ++i) {
        if (modelFType[i] < 0) {
          ignoreF_.insert(i);
        } else {
          indexF_.push_back(i);
          ++numF;
        }

        if (modelYType[i] < 0)
          ignoreY_.insert(i);
        else
          indexY_.push_back(i);
      }
      break;
    }
  }

  assert(numF == indexY_.size());

  if (ignoreF_.size() != ignoreY_.size() || indexF_.size() != indexY_.size()) {
#ifdef _DEBUG_
    for (int i = 0; i < model_->sizeF(); ++i) {
      string fEquation("");
      string subModelName;
      int localFIndex = -1;
      model_->getFInfos(i, subModelName, localFIndex, fEquation);
      Trace::debug() << DYNLog(SolverEquationsType, i, ((modelFType[i] > 0)? "differential":"algebraic"), fEquation) << Trace::endline;
    }
    for (int i = 0; i < model_->sizeY(); ++i) {
      Trace::debug() << DYNLog(SolverVariablesType, model_->getVariableName(i), i, ((modelYType[i] > 0)? "differential":"algebraic")) << Trace::endline;
    }
#endif
    throw DYNError(Error::SOLVER_ALGO, SolverUnbalanced);
  }

  return numF;
}

void
SolverKINAlgRestoration::setupNewAlgebraicRestoration(const double fnormtol, const double initialaddtol, const double scsteptol,
  const double mxnewtstep, const int msbset, const int mxiter, int const printfl) {
  const unsigned int numFPrevious = numF_;
  numF_ = initVarAndEqTypes();
  if (numF_ == 0)
    return;
  const bool initKinsol = numFPrevious != numF_;
  if (initKinsol) {
    // warning: model_->sizeF() != numF_
    // model_->sizeF() is fixed during the whole simulation
    // numF_ could vary
    vectorF_.resize(model_->sizeF());

    vectorYOrYpSolution_.assign(numF_, 0.);
    cleanAlgebraicVectors();
    sundialsVectorY_ = N_VMake_Serial(numF_, &(vectorYOrYpSolution_[0]), sundialsContext_);

    if (sundialsVectorY_ == NULL)
      throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);

    clean();
    switch (mode_) {
      case KIN_ALGEBRAIC:
        initCommon(fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJ_KIN, sundialsVectorY_);
        break;
      case KIN_DERIVATIVES:
        initCommon(fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalF_KIN, evalJPrim_KIN, sundialsVectorY_);
        break;
    }
  } else {
    updateKINSOLSettings(fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl);
  }
}

void
SolverKINAlgRestoration::updateKINSOLSettings(const double fnormtol, const double initialaddtol, const double scsteptol, const double mxnewtstep,
                                              const int msbset, const int mxiter, const int printfl) const {
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
  SolverKINAlgRestoration* solver = reinterpret_cast<SolverKINAlgRestoration*>(data);
  Model& model = solver->getModel();

  double* irr = NV_DATA_S(rr);
  double* iyy = NV_DATA_S(yy);

  // evalF has already been called in the scaling part so it doesn't have to be called again for the first iteration
  if (solver->getFirstIteration()) {
    solver->setFirstIteration(false);
  } else {
    try {
      if (solver->mode_ == KIN_ALGEBRAIC) {
        // add current values of algebraic variables
        for (unsigned int i = 0; i < solver->indexY_.size(); ++i) {
          solver->vectorYForRestoration_[solver->indexY_[i]] = iyy[i];
        }
        model.evalF(solver->t0_, &solver->vectorYForRestoration_[0], &solver->vectorYpForRestoration_[0], &solver->vectorF_[0]);
      } else if (solver->mode_ == KIN_DERIVATIVES) {
        for (unsigned int i = 0; i < solver->indexY_.size(); ++i) {
          solver->vectorYpForRestoration_[solver->indexY_[i]] = iyy[i];
        }
        model.evalFDiff(solver->t0_, &solver->vectorYForRestoration_[0], &solver->vectorYpForRestoration_[0], &solver->vectorF_[0]);
      }
    } catch (const DYN::Error& e) {
      if (e.type() == DYN::Error::NUMERICAL_ERROR) {
#ifdef _DEBUG_
       Trace::debug() << e.what() << Trace::endline;
#endif
        return (-1);
      } else {
        throw;
      }
    }
  }

  for (unsigned int i = 0; i < solver->indexF_.size(); ++i) {
    irr[i] = solver->vectorF_[solver->indexF_[i]];
  }

#ifdef _DEBUG_
  // Print the current residual norms, the first one is used as a stopping criterion
  double weightedInfNorm = SolverCommon::weightedInfinityNorm(solver->vectorF_, solver->indexF_, solver->vectorFScale_);
  double wL2Norm = SolverCommon::weightedL2Norm(solver->vectorF_, solver->indexF_, solver->vectorFScale_);
  long int current_nni = 0;
  KINGetNumNonlinSolvIters(solver->KINMem_, &current_nni);
  Trace::debug() << DYNLog(SolverKINResidualNormAlg, stringFromMode(solver->getMode()), current_nni, weightedInfNorm, wL2Norm) << Trace::endline;

  const int nbErr = 50;
  Trace::debug() << DYNLog(KinLargestErrors, nbErr) << Trace::endline;
  vector<std::pair<double, size_t> > fErr;
  for (size_t i = 0; i < solver->indexF_.size(); ++i)
    fErr.push_back(std::pair<double, size_t>(solver->vectorF_[solver->indexF_[i]], solver->indexF_[i]));
  SolverCommon::printLargestErrors(fErr, model, nbErr);
#endif
  return 0;
}

#if _DEBUG_
void
SolverKINAlgRestoration::checkJacobian(const SparseMatrix& smj, Model& model) {
  SparseMatrix::CheckError error = smj.check();
  string sub_model_name;
  string equation;
  string equation_bis;
  int local_index;
  switch (error.code) {
  case SparseMatrix::CHECK_ZERO_ROW:
    throw DYNError(DYN::Error::SOLVER_ALGO, SolverJacobianWithNulRow, error.info, model.getVariableName(error.info));
  case SparseMatrix::CHECK_ZERO_COLUMN:
    model.getFInfos(error.info, sub_model_name, local_index, equation);
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
  SolverKINAlgRestoration* solver = reinterpret_cast<SolverKINAlgRestoration*> (data);
  Model& model = solver->getModel();

  constexpr double cj = 1.;
  SparseMatrix smj;
  smj.init(model.sizeY(), model.sizeY());
  model.evalJt(solver->t0_, cj, smj);

  // Erase useless values in the jacobian
  SparseMatrix smjKin;
  const int size = static_cast<int>(solver->indexY_.size());
  smjKin.reserve(size);
  smj.erase(solver->ignoreY_, solver->ignoreF_, smjKin);
#if _DEBUG_
  if (solver->checkJacobian_) {
    checkJacobian(smjKin, model);
  }
#endif
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smjKin, JJ, size, &solver->lastRowVals_, solver->linearSolver_, true);

  return 0;
}

int
SolverKINAlgRestoration::evalJPrim_KIN(N_Vector /*yy*/, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKINAlgRestoration* solver = reinterpret_cast<SolverKINAlgRestoration*> (data);
  Model& model = solver->getModel();

  constexpr double cj = 1.;

  SparseMatrix smj;
  smj.init(model.sizeY(), model.sizeY());
  model.evalJtPrim(solver->t0_, cj, smj);

  // Erase useless values in the jacobian
  SparseMatrix smjKin;
  const int size = static_cast<int>(solver->indexY_.size());
  smjKin.reserve(size);
  smj.erase(solver->ignoreY_, solver->ignoreF_, smjKin);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smjKin, JJ, size, &solver->lastRowVals_, solver->linearSolver_, true);

  return 0;
}

int
SolverKINAlgRestoration::solve(const bool noInitSetup, const bool evaluateOnlyModeAtFirstIter) {
  if (numF_ == 0)
    return KIN_SUCCESS;

  int flag = KINSetNoInitSetup(KINMem_, noInitSetup);
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverFuncErrorKINSOL, "KINSetNoInitSetup");

  // first evaluation of F in order to fill the scaling vector
  firstIteration_ = true;
  if (evaluateOnlyModeAtFirstIter)
    model_->evalFMode(t0_, &vectorYForRestoration_[0], &vectorYpForRestoration_[0], &vectorF_[0]);
  else
    model_->evalF(t0_, &vectorYForRestoration_[0], &vectorYpForRestoration_[0], &vectorF_[0]);

  // fScale
  vectorFScale_.assign(indexF_.size(), 1.);
  for (unsigned int i = 0; i < indexF_.size(); ++i) {
    if (std::abs(vectorF_[indexF_[i]]) > RCONST(1.))
      vectorFScale_[i] = 1. / std::abs(vectorF_[indexF_[i]]);
  }

  // yScale
  vectorYScale_.assign(indexY_.size(), 1.);
  for (unsigned int i = 0; i < indexY_.size(); ++i) {
    if (std::abs(vectorYOrYpSolution_[i]) > RCONST(1.)) {
      vectorYScale_[i] = 1. / std::abs(vectorYOrYpSolution_[i]);
    }
  }

  flag = solveCommon();
  if (flag < 0)
    throw DYNError(Error::SUNDIALS_ERROR, SolverSolveErrorKINSOL);

  return flag;
}

void
SolverKINAlgRestoration::setInitialValues(const double t, const vector<double>& y, const vector<double>& yp) {
  t0_ = t;
  vectorYForRestoration_.assign(y.begin(), y.end());
  vectorYpForRestoration_.assign(yp.begin(), yp.end());

  switch (mode_) {
    case KIN_ALGEBRAIC: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        vectorYOrYpSolution_[i] = y[indexY_[i]];
      }
      break;
    }
    case KIN_DERIVATIVES: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        vectorYOrYpSolution_[i] = yp[indexY_[i]];
      }
      break;
    }
  }
}

void
SolverKINAlgRestoration::getValues(vector<double>& y, vector<double>& yp) const {
  switch (mode_) {
    case KIN_ALGEBRAIC: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        y[indexY_[i]] = vectorYOrYpSolution_[i];
      }
      break;
    }
    case KIN_DERIVATIVES: {
      for (unsigned int i = 0; i < indexY_.size(); ++i) {
        yp[indexY_[i]] = vectorYOrYpSolution_[i];
      }
      break;
    }
  }
}

}  // namespace DYN
