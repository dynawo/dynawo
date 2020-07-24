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
#include <sunlinsol/sunlinsol_klu.h>
#include <sundials/sundials_types.h>
#include <sundials/sundials_math.h>
#include <sundials/sundials_sparse.h>
#include <nvector/nvector_serial.h>
#include <cstring>
#include <vector>
#include <cmath>
#include <map>
#include <iomanip>

#include "DYNSolverKINSubModel.h"
#include "DYNSolverCommon.h"
#include "DYNSubModel.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNSparseMatrix.h"
#include "DYNTimer.h"

using std::vector;
using std::map;
using std::string;
using std::stringstream;
using boost::shared_ptr;

namespace DYN {

SolverKINSubModel::SolverKINSubModel() :
SolverKINCommon(),
subModel_(NULL),
yBuffer_(NULL),
fBuffer_(NULL) {
}

SolverKINSubModel::~SolverKINSubModel() {
  clean();
}

void
SolverKINSubModel::init(SubModel* subModel, const double t0, double* yBuffer, double *fBuffer, int mxiter, double fnormtol, double initialaddtol,
    double scsteptol, double mxnewtstep, int msbset, int printfl) {
  // (1) Attributes
  // --------------
  clean();

  subModel_ = subModel;
  t0_ = t0;
  yBuffer_ = yBuffer;
  fBuffer_ = fBuffer;

  // (2) Size of the problem to solve
  // --------------------------------
  nbF_ = subModel_->sizeF();  // All the equations
  if (nbF_ == 0)
    return;

  vYy_.assign(nbF_, 0);

  yy_ = N_VMake_Serial(nbF_, &(vYy_[0]));
  if (yy_ == NULL)
    throw DYNError(Error::SUNDIALS_ERROR, SolverCreateYY);

  initCommon("KLU", fnormtol, initialaddtol, scsteptol, mxnewtstep, msbset, mxiter, printfl, evalFInit_KIN, evalJInit_KIN);

  vYy_.assign(yBuffer, yBuffer + nbF_);
}

int
SolverKINSubModel::evalFInit_KIN(N_Vector yy, N_Vector rr, void *data) {
  SolverKINSubModel * solv = reinterpret_cast<SolverKINSubModel*> (data);
  SubModel* subModel = solv->getSubModel();

  // evalF has already been called in the scaling part so it doesn't have to be called again for the first iteration
  if (solv->getFirstIteration()) {
    solv->setFirstIteration(false);
  } else {  // update of F
    realtype *iyy = NV_DATA_S(yy);
    int yL = NV_LENGTH_S(yy);
    std::copy(iyy, iyy+yL, solv->yBuffer_);
    subModel->evalF(solv->t0_, UNDEFINED_EQ);
  }

  // copy of values in output vector
  realtype *irr = NV_DATA_S(rr);
  memcpy(irr, solv->fBuffer_, solv->nbF_ * sizeof(solv->fBuffer_[0]));

  return (0);
}

int
SolverKINSubModel::evalJInit_KIN(N_Vector yy, N_Vector /*rr*/,
        SUNMatrix JJ, void* data, N_Vector /*tmp1*/, N_Vector /*tmp2*/) {
  SolverKINSubModel* solv = reinterpret_cast<SolverKINSubModel*> (data);
  SubModel* subModel = solv->getSubModel();

  realtype *iyy = NV_DATA_S(yy);
  int yL = NV_LENGTH_S(yy);
  std::copy(iyy, iyy+yL, solv->yBuffer_);

  // Sparse matrix
  // -------------
  SparseMatrix smj;
  int size = subModel->sizeY();
  smj.init(size, size);

  // Arbitrary value for cj
  double cj = 1;
  subModel->evalJt(solv->t0_, cj, smj, 0);
  SolverCommon::propagateMatrixStructureChangeToKINSOL(smj, JJ, size, solv->lastRowVals_, solv->LS_, solv->linearSolverName_, false);

  return (0);
}

int
SolverKINSubModel::solve() {
#if defined(_DEBUG_) || defined(PRINT_TIMERS)
  Timer timer("SolverKINSubModel::solve");
#endif

  if (nbF_ == 0)
    return KIN_SUCCESS;

  SubModel* subModel = getSubModel();

  subModel->evalF(t0_, UNDEFINED_EQ);
  firstIteration_ = true;

  fScale_.assign(subModel->sizeF(), 1.0);
  for (unsigned int i = 0; i < nbF_; ++i) {
    if (std::abs(fBuffer_[i])  > 1.)
      fScale_[i] = 1 / std::abs(fBuffer_[i]);
  }
  yScale_.assign(subModel->sizeY(), 1.0);

  // SubModel initialization can fail, especially on switch currents.
  // This failure shouldn't be stopping the simulation.
  return solveCommon();
}
}  // namespace DYN
