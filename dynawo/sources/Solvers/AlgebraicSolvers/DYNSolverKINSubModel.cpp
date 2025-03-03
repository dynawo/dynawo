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
 * @file  DYNSolverKINSubModel.cpp
 *
 * @brief Implementation of the solver used to calculate the initial values of the model
 *
 */

#include <kinsol/kinsol.h>
#include <nvector/nvector_serial.h>

#include <algorithm>
#include <cstring>
#include <cmath>

#include "DYNSolverKINSubModel.h"
#include "DYNSolverCommon.h"
#include "DYNSubModel.h"
#include "DYNMacrosMessage.h"
#include "DYNSparseMatrix.h"
#include "DYNTimer.h"

namespace DYN {

SolverKINSubModel::SolverKINSubModel() :
SolverKINCommon(),
subModel_(NULL),
yBuffer_(NULL),
fBuffer_(NULL) {
}

SolverKINSubModel::~SolverKINSubModel() {
  if (sundialsVectorY_ != NULL) {
    N_VDestroy_Serial(sundialsVectorY_);
    sundialsVectorY_ = NULL;
  }
  yBuffer_ = NULL;
  fBuffer_ = NULL;
  subModel_ = NULL;
}

void
SolverKINSubModel::init(SubModel* subModel,
                        const double t0,
                        double* yBuffer,
                        double* fBuffer,
                        std::shared_ptr<parameters::ParametersSet> localInitParameters) {
  // (1) Attributes
  // --------------
  clean();

  subModel_ = subModel;
  t0_ = t0;
  yBuffer_ = yBuffer;
  fBuffer_ = fBuffer;

  // (2) Size of the problem to solve
  // --------------------------------
  numF_ = subModel_->sizeF();  // All the equations
  if (numF_ == 0)
    return;

  vectorYSubModel_.assign(numF_, 0.);

  sundialsVectorY_ = N_VMake_Serial(numF_, &(vectorYSubModel_[0]), sundialsContext_);
  if (sundialsVectorY_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);

  // Local init parameters initialization with default values
  int mxiter = 30;
  double fnormtol = 1e-4;
  double initialaddtol = 0.1;
  double scsteptol = 1e-4;
  double mxnewtstep = 100000;
  int msbset = 0;
  int printfl = 0;

  // Local init parameters parameterization
  if (localInitParameters != nullptr) {
    if (localInitParameters->hasParameter("mxiter"))
      mxiter = localInitParameters->getParameter("mxiter")->getInt();
    if (localInitParameters->hasParameter("fnormtol"))
      fnormtol = localInitParameters->getParameter("fnormtol")->getDouble();
    if (localInitParameters->hasParameter("initialaddtol"))
      initialaddtol = localInitParameters->getParameter("initialaddtol")->getDouble();
    if (localInitParameters->hasParameter("scsteptol"))
      scsteptol = localInitParameters->getParameter("scsteptol")->getDouble();
    if (localInitParameters->hasParameter("mxnewtstep"))
      mxnewtstep = localInitParameters->getParameter("mxnewtstep")->getDouble();
    if (localInitParameters->hasParameter("msbset"))
      msbset = localInitParameters->getParameter("msbset")->getInt();
    if (localInitParameters->hasParameter("printfl"))
      printfl = localInitParameters->getParameter("printfl")->getInt();
  }
  initCommon(fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalFInit_KIN, evalJInit_KIN, sundialsVectorY_);

  vectorYSubModel_.assign(yBuffer, yBuffer + numF_);
}

int
SolverKINSubModel::evalFInit_KIN(N_Vector yy, N_Vector rr, void *data) {
  SolverKINSubModel* solver = reinterpret_cast<SolverKINSubModel*> (data);
  SubModel* subModel = solver->getSubModel();

  // evalF has already been called in the scaling part so it doesn't have to be called again for the first iteration
  if (solver->getFirstIteration()) {
    solver->setFirstIteration(false);
  } else {  // update of F
    realtype* iyy = NV_DATA_S(yy);
    const std::size_t yL = NV_LENGTH_S(yy);
    std::copy(iyy, iyy + yL, solver->yBuffer_);
    subModel->evalF(solver->t0_, UNDEFINED_EQ);
  }

  // copy of values in output vector
  realtype* irr = NV_DATA_S(rr);
  memcpy(irr, solver->fBuffer_, solver->numF_ * sizeof(solver->fBuffer_[0]));

  return 0;
}

int
SolverKINSubModel::evalJInit_KIN(N_Vector yy, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKINSubModel* solver = reinterpret_cast<SolverKINSubModel*> (data);
  SubModel* subModel = solver->getSubModel();

  realtype *iyy = NV_DATA_S(yy);
  std::size_t yL = NV_LENGTH_S(yy);
  std::copy(iyy, iyy+yL, solver->yBuffer_);

  // Sparse matrix
  // -------------
  SparseMatrix smj;
  const int size = subModel->sizeY();
  smj.init(size, size);

  // Arbitrary value for cj
  const double cj = 1.;
  subModel->evalJt(solver->t0_, cj, smj, 0);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smj, JJ, size, &solver->lastRowVals_, solver->linearSolver_, false);

  return 0;
}

int
SolverKINSubModel::solve() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverKINSubModel::solve");
#endif

  if (numF_ == 0)
    return KIN_SUCCESS;

  SubModel* subModel = getSubModel();

  subModel->evalF(t0_, UNDEFINED_EQ);
  firstIteration_ = true;

  vectorFScale_.assign(subModel->sizeF(), 1.);
  for (unsigned int i = 0; i < numF_; ++i) {
    if (std::abs(fBuffer_[i])  > 1.)
      vectorFScale_[i] = 1. / std::abs(fBuffer_[i]);
  }
  vectorYScale_.assign(subModel->sizeY(), 1.);

  // SubModel initialization can fail, especially on switch currents.
  // This failure shouldn't be stopping the simulation.
  return solveCommon(KIN_NONE);
}
}  // namespace DYN
