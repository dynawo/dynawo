/*
 * -----------------------------------------------------------------
 * SPM implementation header: SPMMem block + internal prototypes.
 * Current model: ybar(t) = ubar*sin(w0 t) + vbar*cos(w0 t)
 * (fixed fundamental frequency, no harmonics, piecewise-constant Fourier
 *  coefficients).
 *
 * Estimator: the state/derivative Jacobians are pushed once per IDA Jacobian
 * update (IDASPMSetJacobians) and reused; the 2ds x 2ds normal-equations matrix
 * Muv is assembled and LU-factorized only when the Jacobian changed
 * (newMuvMat), and the factors are reused for back-substitution on the
 * intervening steps. Only the right-hand side ruv (the gradient) and the
 * residual samples are recomputed every step.
 * -----------------------------------------------------------------
 */
#ifndef _IDA_SPM_IMPL_H
#define _IDA_SPM_IMPL_H

#include "ida_impl.h"
#include <ida/ida_spm.h>
#include <sundials/sundials_matrix.h>
#include <math.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifndef PI
#define PI RCONST(3.14159265358979323846)
#endif

typedef struct SPMMemRec {
  int d;                       /* number of unknowns                          */
  int ds;                      /* number of oscillating components            */

  N_Vector phixi[MXORDP1];     /* divided-difference history of the correction */
  N_Vector phiybar[MXORDP1];   /* divided-difference history of the predictor  */
  realtype phisinbar[MXORDP1]; /* divided-difference history of sin(w0 t)      */
  realtype phicosbar[MXORDP1]; /* divided-difference history of cos(w0 t)      */

  N_Vector xi;                 /* correction term  xi  = yy - ybar             */
  N_Vector xip;                /* correction deriv. xi' = yp - ybar'           */
  N_Vector ybar;               /* predictor   ybar(t)  = u sin + v cos         */
  N_Vector ybarp;              /* predictor   ybar'(t)                         */
  N_Vector ubar;               /* sine   Fourier coefficients                  */
  N_Vector vbar;               /* cosine Fourier coefficients                  */
  realtype wbar;               /* reference angular frequency                  */
  realtype Tbar;               /* reference period 2pi/wbar                    */
  N_Vector isAC;               /* 1.0 oscillating / 0.0 non-oscillating        */
  N_Vector iGlobaltoAC;        /* global index -> oscillating index (or -1)    */
  realtype useSPM;             /* on/off switch                                */
  realtype sinbarpred;         /* predicted sin divided-difference sum         */
  realtype cosbarpred;         /* predicted cos divided-difference sum         */

  /* estimator */
  int Ns;                      /* number of quadrature samples over one period */
  N_Vector yyts, ypts, Fnts;   /* sampled prior model, derivative, residual    */
  N_Vector ruv;                /* gradient / solution of the (2ds) linear sys  */
  N_Vector id;                 /* differential/algebraic indicator             */

  /* Jacobian pushed by IDASPMSetJacobians (CSR of J), reused across steps */
  SUNMatrix JFnts;             /* dF/dX                                        */
  SUNMatrix JFntsdot;          /* dF/dXdot (NULL-data => identity on diff vars)*/
  int haveJacXdot;             /* 1 if a real dF/dXdot was pushed              */
  int haveJac;                 /* 1 once a Jacobian has been pushed            */

  /* normal-equations matrix Muv (dense 2ds x 2ds), lazily assembled+factored */
  realtype *Muv;               /* holds LU factors between refactorizations    */
  int      *pivots;            /* 2ds LU pivots                                */
  int newMuvMat;               /* 1 => reassemble + refactorize Muv this pass  */
  int MuvReady;                /* 1 => Muv holds valid LU factors              */

  /* per-equation-row scratch (size ds) for the sparse M assembly */
  realtype *rowU, *rowV;
  int      *rowTouched;
  int      *rowMark;
} *SPMMem;

/* core */
void IDASPMEvaluateybarkd(IDAMem IDA_mem, realtype tt, int kd, N_Vector ybarkd);
void IDASPMEvaluatePriorModel(IDAMem IDA_mem, realtype tt);
void IDASPMEvaluateSolution(IDAMem IDA_mem);
void IDASPMApplyCorrection(IDAMem IDA_mem);
void IDASPMContinuityCondition(IDAMem IDA_mem);
void IDASPMContinuityConditionphi(IDAMem IDA_mem);
void IDASPMEvaluatePriorModelphi(IDAMem IDA_mem);
void IDASPMEvaluateSolutionphi(IDAMem IDA_mem);
void IDASPMUpdatePriorModelParameters(IDAMem IDA_mem);
void IDASPMInitializePhiArrays(IDAMem IDA_mem, N_Vector yy0, N_Vector yp0);
void IDASPMhhScalePhiArrays(IDAMem IDA_mem);
void IDASPMFree(IDAMem IDA_mem);

#ifdef __cplusplus
}
#endif

#endif /* _IDA_SPM_IMPL_H */
