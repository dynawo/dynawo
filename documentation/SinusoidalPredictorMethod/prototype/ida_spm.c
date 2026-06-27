/*
 * -----------------------------------------------------------------
 * Sinusoidal Predictor Method (SPM) add-on for IDA 6.3.0.
 * Port of the SUNDIALS 2.7.0 IDASPM prototype (Gibert et al.).
 *
 * Estimator design (faithful to the original Dynawo IDASPM):
 *   - the state/derivative Jacobians are pushed once per IDA Jacobian update
 *     (IDASPMSetJacobians) and reused for all quadrature samples and steps;
 *   - the 2ds x 2ds normal-equations matrix Muv is assembled and LU-factorized
 *     only when the Jacobian changed (newMuvMat), and the factors are reused for
 *     back-substitution on the intervening steps;
 *   - only the gradient ruv and the residual samples are recomputed each step.
 * The d*d Jacobians are CSR sparse and never densified; the per-step work is
 * O(nnz) plus one 2ds back-substitution.
 * -----------------------------------------------------------------
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#include "ida_spm_impl.h"
#include <nvector/nvector_serial.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <sundials/sundials_math.h>

#define ZERO RCONST(0.0)
#define ONE  RCONST(1.0)
#define TWO  RCONST(2.0)

/* ===================================================================
 *  Dense LU (column-major, partial pivoting) split into factor + solve so the
 *  factorization can be reused across steps.
 * =================================================================== */
static int spmDenseFactor(realtype *A, int n, int *piv) {
  int i, j, k, p;
  for (k = 0; k < n; k++) {
    realtype amax = fabs(A[k + n*k]); p = k;
    for (i = k+1; i < n; i++) { realtype a = fabs(A[i + n*k]); if (a > amax) { amax = a; p = i; } }
    piv[k] = p;
    if (amax == ZERO) return 1;            /* singular */
    if (p != k) for (j = 0; j < n; j++) { realtype t = A[k + n*j]; A[k + n*j] = A[p + n*j]; A[p + n*j] = t; }
    realtype akk = A[k + n*k];
    for (i = k+1; i < n; i++) {
      realtype f = A[i + n*k] / akk; A[i + n*k] = f;
      for (j = k+1; j < n; j++) A[i + n*j] -= f * A[k + n*j];
    }
  }
  return 0;
}

static void spmDenseBackSolve(realtype *A, int n, int *piv, realtype *b) {
  int i, k;
  for (k = 0; k < n; k++) { if (piv[k] != k) { realtype t = b[k]; b[k] = b[piv[k]]; b[piv[k]] = t; } }
  for (k = 0; k < n; k++) for (i = k+1; i < n; i++) b[i] -= A[i + n*k] * b[k];
  for (k = n-1; k >= 0; k--) { b[k] /= A[k + n*k]; for (i = 0; i < k; i++) b[i] -= A[i + n*k] * b[k]; }
}

/* deep-copy a CSR SUNMatrix into *dst (clone on first use / pattern change) */
static void spmStoreCSR(SUNMatrix src, SUNMatrix *dst) {
  if (*dst != NULL) SUNMatDestroy(*dst);
  *dst = SUNMatClone(src);
  SUNMatCopy(src, *dst);
}

/* ===================================================================
 *  Public init : IDASetSPM
 * =================================================================== */
int IDASetSPM(void *ida_mem, N_Vector isAC, realtype wbar, N_Vector id, int nnz) {
  IDAMem IDA_mem = (IDAMem) ida_mem;
  SPMMem spm_mem;
  int j, maxcol;

  spm_mem = (SPMMem) malloc(sizeof(struct SPMMemRec));
  if (spm_mem == NULL) return 1;

  spm_mem->d   = (int) N_VGetLength(isAC);
  spm_mem->ds  = (int) (N_VDotProd(isAC, isAC) + RCONST(0.5));
  spm_mem->wbar = wbar;
  spm_mem->Tbar = TWO*PI/wbar;
  spm_mem->useSPM = ONE;
  spm_mem->Ns = 5;
  spm_mem->sinbarpred = ZERO;
  spm_mem->cosbarpred = ZERO;
  spm_mem->id = id;
  (void) nnz;

  spm_mem->xi    = N_VClone(isAC);
  spm_mem->xip   = N_VClone(isAC);
  spm_mem->ybar  = N_VClone(isAC);
  spm_mem->ybarp = N_VClone(isAC);
  spm_mem->ubar  = N_VClone(isAC);
  spm_mem->vbar  = N_VClone(isAC);
  spm_mem->isAC  = N_VClone(isAC);
  spm_mem->iGlobaltoAC = N_VClone(isAC);

  N_VScale(ONE, isAC, spm_mem->isAC);
  N_VConst(ZERO, spm_mem->ubar);
  N_VConst(ZERO, spm_mem->vbar);
  N_VConst(ZERO, spm_mem->ybar);
  N_VConst(ZERO, spm_mem->ybarp);
  N_VConst(ZERO, spm_mem->xi);
  N_VConst(ZERO, spm_mem->xip);

  {
    realtype *isACv = N_VGetArrayPointer(spm_mem->isAC);
    realtype *g2ac  = N_VGetArrayPointer(spm_mem->iGlobaltoAC);
    int c = 0;
    for (j = 0; j < spm_mem->d; j++) {
      if (isACv[j] != ZERO) { g2ac[j] = (realtype)c; c++; }
      else                  { g2ac[j] = -ONE; }
    }
  }

  maxcol = SUNMAX(IDA_mem->ida_maxord, 3);
  for (j = 0; j <= maxcol; j++) {
    spm_mem->phixi[j]   = N_VClone(isAC);
    spm_mem->phiybar[j] = N_VClone(isAC);
    N_VConst(ZERO, spm_mem->phixi[j]);
    N_VConst(ZERO, spm_mem->phiybar[j]);
    spm_mem->phisinbar[j] = ZERO;
    spm_mem->phicosbar[j] = ZERO;
  }

  spm_mem->yyts = N_VClone(isAC);
  spm_mem->ypts = N_VClone(isAC);
  spm_mem->Fnts = N_VClone(isAC);
  N_VConst(ZERO, spm_mem->yyts);
  N_VConst(ZERO, spm_mem->ypts);
  N_VConst(ZERO, spm_mem->Fnts);
  spm_mem->ruv = N_VNew_Serial(2*spm_mem->ds, IDA_mem->ida_sunctx);
  N_VConst(ZERO, spm_mem->ruv);

  spm_mem->JFnts = NULL;
  spm_mem->JFntsdot = NULL;
  spm_mem->haveJac = 0;
  spm_mem->haveJacXdot = 0;

  spm_mem->Muv    = (realtype*) calloc((size_t)4*spm_mem->ds*spm_mem->ds, sizeof(realtype));
  spm_mem->pivots = (int*) calloc((size_t)2*spm_mem->ds, sizeof(int));
  spm_mem->newMuvMat = 1;
  spm_mem->MuvReady = 0;

  spm_mem->rowU = (realtype*) calloc((size_t)spm_mem->ds, sizeof(realtype));
  spm_mem->rowV = (realtype*) calloc((size_t)spm_mem->ds, sizeof(realtype));
  spm_mem->rowTouched = (int*) calloc((size_t)spm_mem->ds, sizeof(int));
  spm_mem->rowMark = (int*) calloc((size_t)spm_mem->ds, sizeof(int));

  IDA_mem->ida_spm = (void*) spm_mem;

  IDASPMInitializePhiArrays(IDA_mem, IDA_mem->ida_phi[0], IDA_mem->ida_phi[1]);
  return 0;
}

/* Push the current Jacobians and flag a refactorization of Muv. */
int IDASPMSetJacobians(void *ida_mem, SUNMatrix dFdX, SUNMatrix dFdXdot) {
  IDAMem IDA_mem = (IDAMem) ida_mem;
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  if (spm_mem == NULL) return 1;
  spmStoreCSR(dFdX, &spm_mem->JFnts);
  if (dFdXdot != NULL) { spmStoreCSR(dFdXdot, &spm_mem->JFntsdot); spm_mem->haveJacXdot = 1; }
  spm_mem->haveJac = 1;
  spm_mem->newMuvMat = 1;
  return 0;
}

/* ===================================================================
 *  Core interface routines (faithful port)
 * =================================================================== */

void IDASPMEvaluateybarkd(IDAMem IDA_mem, realtype tt, int kd, N_Vector ybarkd) {
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  if (spm_mem->useSPM != ZERO) {
    realtype kdr = (realtype)kd;
    realtype wk  = pow(spm_mem->wbar, kdr);
    realtype skd = wk * sin(spm_mem->wbar*tt + kdr*PI/TWO);
    realtype ckd = wk * cos(spm_mem->wbar*tt + kdr*PI/TWO);
    N_VLinearSum(skd, spm_mem->ubar, ckd, spm_mem->vbar, ybarkd);
  } else {
    N_VConst(ZERO, ybarkd);
  }
}

void IDASPMEvaluatePriorModel(IDAMem IDA_mem, realtype tt) {
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  IDASPMEvaluateybarkd(IDA_mem, tt, 0, spm_mem->ybar);
  IDASPMEvaluateybarkd(IDA_mem, tt, 1, spm_mem->ybarp);
}

void IDASPMEvaluateSolution(IDAMem IDA_mem) {
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  N_VLinearSum(ONE, spm_mem->xi,  ONE, spm_mem->ybar,  IDA_mem->ida_yy);
  N_VLinearSum(ONE, spm_mem->xip, ONE, spm_mem->ybarp, IDA_mem->ida_yp);
}

void IDASPMApplyCorrection(IDAMem IDA_mem) {
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  N_VLinearSum(ONE, spm_mem->xi,  -ONE,              IDA_mem->ida_delta, spm_mem->xi);
  N_VLinearSum(ONE, spm_mem->xip, -IDA_mem->ida_cj, IDA_mem->ida_delta, spm_mem->xip);
  IDASPMEvaluateSolution(IDA_mem);
}

void IDASPMContinuityCondition(IDAMem IDA_mem) {
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  N_VLinearSum(ONE, IDA_mem->ida_yy, -ONE, spm_mem->ybar,  spm_mem->xi);
  N_VLinearSum(ONE, IDA_mem->ida_yp, -ONE, spm_mem->ybarp, spm_mem->xip);
}

void IDASPMContinuityConditionphi(IDAMem IDA_mem) {
  int j;
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  for (j = 0; j <= IDA_mem->ida_kk; j++)
    N_VLinearSum(ONE, IDA_mem->ida_phi[j], -ONE, spm_mem->phiybar[j], spm_mem->phixi[j]);
}

void IDASPMEvaluatePriorModelphi(IDAMem IDA_mem) {
  int j;
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  for (j = 0; j <= IDA_mem->ida_kk; j++)
    N_VLinearSum(spm_mem->phisinbar[j], spm_mem->ubar,
                 spm_mem->phicosbar[j], spm_mem->vbar, spm_mem->phiybar[j]);
}

void IDASPMEvaluateSolutionphi(IDAMem IDA_mem) {
  int j;
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  for (j = 0; j <= IDA_mem->ida_kk; j++)
    N_VLinearSum(ONE, spm_mem->phixi[j], ONE, spm_mem->phiybar[j], IDA_mem->ida_phi[j]);
}

/* ===================================================================
 *  Fourier coefficient estimator (stored sparse Jacobian, lazy Muv)
 *
 *  Minimises R(u,v) = int_tn^{tn+T} ||F(t, ybar, ybar')||^2 dt by one Newton
 *  step. Basis matrices (restricted to oscillating columns):
 *    Mu = sin(w t) dF/dX + w cos(w t) dF/dXdot
 *    Mv = cos(w t) dF/dX - w sin(w t) dF/dXdot
 *  Normal equations  [Mu Mv]^T [Mu Mv] [du;dv] = -[Mu Mv]^T F.  The left-hand
 *  side is ~constant over a period (periodic integral) and over the Jacobian's
 *  validity window, so it is assembled+factorized only on newMuvMat and reused.
 * =================================================================== */
void IDASPMUpdatePriorModelParameters(IDAMem IDA_mem) {
  SPMMem s = (SPMMem) IDA_mem->ida_spm;
  if (!s->haveJac) return;   /* no Jacobian pushed yet */

  int d = s->d, ds = s->ds, Ns = s->Ns;
  int it, eq, k, ic, iac, a, b, nT;
  realtype hs, ts, ws, sinwts, coswts, w = s->wbar;

  realtype *yy   = N_VGetArrayPointer(IDA_mem->ida_yy);
  realtype *idv  = N_VGetArrayPointer(s->id);
  realtype *uv   = N_VGetArrayPointer(s->ubar);
  realtype *vv   = N_VGetArrayPointer(s->vbar);
  realtype *acv  = N_VGetArrayPointer(s->isAC);
  realtype *g2ac = N_VGetArrayPointer(s->iGlobaltoAC);
  realtype *yyts = N_VGetArrayPointer(s->yyts);
  realtype *ypts = N_VGetArrayPointer(s->ypts);
  realtype *Fnts = N_VGetArrayPointer(s->Fnts);
  realtype *ruv  = N_VGetArrayPointer(s->ruv);
  realtype *rowU = s->rowU, *rowV = s->rowV;
  int *touched = s->rowTouched, *mark = s->rowMark;

  sunindextype *Jrp = SM_INDEXPTRS_S(s->JFnts);
  sunindextype *Jcv = SM_INDEXVALS_S(s->JFnts);
  realtype     *Jda = SM_DATA_S(s->JFnts);
  sunindextype *Drp = NULL, *Dcv = NULL; realtype *Dda = NULL;
  if (s->haveJacXdot) { Drp = SM_INDEXPTRS_S(s->JFntsdot); Dcv = SM_INDEXVALS_S(s->JFntsdot); Dda = SM_DATA_S(s->JFntsdot); }

  hs = s->Tbar / (realtype)Ns;
  for (a = 0; a < 2*ds; a++) ruv[a] = ZERO;
  if (s->newMuvMat) memset(s->Muv, 0, (size_t)4*ds*ds*sizeof(realtype));

  for (eq = 0; eq < d; eq++) if (acv[eq] == ZERO) { yyts[eq] = yy[eq]; ypts[eq] = ZERO; }

  for (it = 0; it <= Ns; it++) {
    ts = IDA_mem->ida_tn + (realtype)it*hs;
    ws = hs/TWO*(ONE + (realtype)((it==0)||(it==Ns)));
    sinwts = sin(w*ts);
    coswts = cos(w*ts);

    for (eq = 0; eq < d; eq++) if (acv[eq] != ZERO) {
      yyts[eq] = uv[eq]*sinwts + vv[eq]*coswts;
      ypts[eq] = w*(uv[eq]*coswts - vv[eq]*sinwts);
    }
    if (IDA_mem->ida_res(ts, s->yyts, s->ypts, s->Fnts, IDA_mem->ida_user_data) != 0) {
      printf("SPM: residual evaluation failed\n"); return;
    }

    for (eq = 0; eq < d; eq++) {
      nT = 0;
      /* scatter dF/dX row into rowU/rowV (per oscillating column) */
      for (k = (int)Jrp[eq]; k < (int)Jrp[eq+1]; k++) {
        ic = (int)Jcv[k];
        if (acv[ic] == ZERO) continue;
        iac = (int)g2ac[ic];
        if (!mark[iac]) { mark[iac] = 1; touched[nT++] = iac; rowU[iac] = ZERO; rowV[iac] = ZERO; }
        rowU[iac] += sinwts*Jda[k];
        rowV[iac] += coswts*Jda[k];
      }
      /* add w*cos/-w*sin * dF/dXdot row */
      if (s->haveJacXdot) {
        for (k = (int)Drp[eq]; k < (int)Drp[eq+1]; k++) {
          ic = (int)Dcv[k];
          if (acv[ic] == ZERO) continue;
          iac = (int)g2ac[ic];
          if (!mark[iac]) { mark[iac] = 1; touched[nT++] = iac; rowU[iac] = ZERO; rowV[iac] = ZERO; }
          rowU[iac] += w*coswts*Dda[k];
          rowV[iac] -= w*sinwts*Dda[k];
        }
      } else if (acv[eq] != ZERO && idv[eq] != ZERO) {
        /* semi-explicit DAE: dF/dXdot = I on differential variables */
        iac = (int)g2ac[eq];
        if (!mark[iac]) { mark[iac] = 1; touched[nT++] = iac; rowU[iac] = ZERO; rowV[iac] = ZERO; }
        rowU[iac] += w*coswts;
        rowV[iac] -= w*sinwts;
      }

      /* gradient ruv -= ws * [Mu Mv]^T F */
      for (a = 0; a < nT; a++) {
        iac = touched[a];
        ruv[iac]    -= ws*rowU[iac]*Fnts[eq];
        ruv[iac+ds] -= ws*rowV[iac]*Fnts[eq];
      }
      /* normal-equations matrix (only when refactorizing) */
      if (s->newMuvMat) {
        for (a = 0; a < nT; a++) {
          int ia = touched[a]; realtype mua = rowU[ia], mva = rowV[ia];
          for (b = 0; b < nT; b++) {
            int ib = touched[b]; realtype mub = rowU[ib], mvb = rowV[ib];
            s->Muv[ia      + 2*ds*(ib)    ] += ws*mua*mub;
            s->Muv[ia      + 2*ds*(ib+ds) ] += ws*mua*mvb;
            s->Muv[(ia+ds) + 2*ds*(ib)    ] += ws*mva*mub;
            s->Muv[(ia+ds) + 2*ds*(ib+ds) ] += ws*mva*mvb;
          }
        }
      }
      /* reset row scratch */
      for (a = 0; a < nT; a++) { iac = touched[a]; mark[iac] = 0; rowU[iac] = ZERO; rowV[iac] = ZERO; }
    }
  }

  if (s->newMuvMat) {
    if (spmDenseFactor(s->Muv, 2*ds, s->pivots) != 0) { printf("SPM: estimator matrix singular\n"); return; }
    s->MuvReady = 1;
    s->newMuvMat = 0;
  }
  if (!s->MuvReady) return;

  spmDenseBackSolve(s->Muv, 2*ds, s->pivots, ruv);

  iac = 0;
  for (eq = 0; eq < d; eq++) if (acv[eq] != ZERO) { uv[eq] += ruv[iac]; vv[eq] += ruv[iac+ds]; iac++; }
}

/* ===================================================================
 *  phi-array seeding / scaling / teardown
 * =================================================================== */
void IDASPMInitializePhiArrays(IDAMem IDA_mem, N_Vector yy0, N_Vector yp0) {
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  realtype w = spm_mem->wbar, t0 = IDA_mem->ida_t0;
  IDASPMEvaluatePriorModel(IDA_mem, t0);

  N_VScale(ONE, spm_mem->ybar,  spm_mem->phiybar[0]);
  N_VScale(ONE, spm_mem->ybarp, spm_mem->phiybar[1]);

  spm_mem->phisinbar[0] = sin(w*t0);
  spm_mem->phicosbar[0] = cos(w*t0);
  spm_mem->phisinbar[1] =  w*cos(w*t0);
  spm_mem->phicosbar[1] = -w*sin(w*t0);

  N_VLinearSum(ONE, yy0, -ONE, spm_mem->ybar,  spm_mem->xi);
  N_VLinearSum(ONE, yp0, -ONE, spm_mem->ybarp, spm_mem->xip);

  N_VScale(ONE, spm_mem->xi,  spm_mem->phixi[0]);
  N_VScale(ONE, spm_mem->xip, spm_mem->phixi[1]);
}

void IDASPMhhScalePhiArrays(IDAMem IDA_mem) {
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  realtype hh = IDA_mem->ida_hh;
  N_VScale(hh, spm_mem->phixi[1],   spm_mem->phixi[1]);
  N_VScale(hh, spm_mem->phiybar[1], spm_mem->phiybar[1]);
  spm_mem->phisinbar[1] *= hh;
  spm_mem->phicosbar[1] *= hh;
}

void IDASPMFree(IDAMem IDA_mem) {
  int i, maxcol;
  SPMMem spm_mem = (SPMMem) IDA_mem->ida_spm;
  if (spm_mem == NULL) return;

  N_VDestroy(spm_mem->xi);    N_VDestroy(spm_mem->xip);
  N_VDestroy(spm_mem->ybar);  N_VDestroy(spm_mem->ybarp);
  N_VDestroy(spm_mem->ubar);  N_VDestroy(spm_mem->vbar);
  N_VDestroy(spm_mem->isAC);  N_VDestroy(spm_mem->iGlobaltoAC);
  N_VDestroy(spm_mem->yyts);  N_VDestroy(spm_mem->ypts);
  N_VDestroy(spm_mem->Fnts);  N_VDestroy(spm_mem->ruv);

  maxcol = SUNMAX(IDA_mem->ida_maxord, 3);
  for (i = 0; i <= maxcol; i++) {
    N_VDestroy(spm_mem->phixi[i]);
    N_VDestroy(spm_mem->phiybar[i]);
  }
  if (spm_mem->JFnts != NULL) SUNMatDestroy(spm_mem->JFnts);
  if (spm_mem->JFntsdot != NULL) SUNMatDestroy(spm_mem->JFntsdot);
  free(spm_mem->Muv); free(spm_mem->pivots);
  free(spm_mem->rowU); free(spm_mem->rowV); free(spm_mem->rowTouched); free(spm_mem->rowMark);
  free(spm_mem);
  IDA_mem->ida_spm = NULL;
}
