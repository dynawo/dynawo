/*
 * -----------------------------------------------------------------
 * Sinusoidal Predictor Method (SPM) add-on for IDA  --  public API
 *
 * Speeds up the integration of DAE systems whose solution contains
 * components oscillating at a known reference frequency (e.g. the 50/60 Hz
 * carrier of EMT power-system simulations) by splitting the solution into a
 * sinusoidal predictor and an adaptive-step correction term.
 * See Gibert et al., "Sinusoidal Predictor Method ...".
 *
 * The Fourier-coefficient estimator reuses a single state/derivative Jacobian
 * pushed by the caller whenever IDA updates its Newton Jacobian (via
 * IDASPMSetJacobians), and assembles + factorizes its small normal-equations
 * matrix only then, reusing the factorization across the intervening steps.
 * This mirrors the original Dynawo IDASPM implementation: the Jacobian is
 * evaluated once per IDA Jacobian update (not per quadrature sample), and the
 * estimator matrix is refactorized lazily.
 * -----------------------------------------------------------------
 */
#ifndef _IDA_SPM_H
#define _IDA_SPM_H

#include <sundials/sundials_nvector.h>
#include <sundials/sundials_matrix.h>
#include <sundials/sundials_types.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * IDASetSPM
 * ---------
 * Enable the SPM on an IDA memory block. Must be called after IDAInit and after
 * the linear solver is attached.
 *   isAC : boolean N_Vector, 1.0 oscillating / 0.0 non-oscillating per state
 *   wbar : reference angular frequency (e.g. 100*pi for 50 Hz)
 *   id   : differential/algebraic indicator N_Vector (1.0 differential)
 *   nnz  : nonzero capacity for the internal CSR Jacobian matrices
 */
SUNDIALS_EXPORT int IDASetSPM(void *ida_mem, N_Vector isAC, realtype wbar,
                              N_Vector id, int nnz);

/*
 * IDASPMSetJacobians
 * ------------------
 * Push the current state and derivative Jacobians into the SPM estimator. Call
 * this from the caller's IDA Jacobian function (i.e. whenever IDA updates its
 * Newton Jacobian) so the estimator reuses a fresh Jacobian and refactorizes
 * its normal-equations matrix on the next estimator pass.
 *   dFdX    : dF/dX     as a CSR-of-J SUNMatrix (index pointers over equation
 *             rows, index values = variable columns, entry = dF_eq/dX_var)
 *   dFdXdot : dF/dXdot  in the same CSR-of-J layout; may be NULL, in which case
 *             dF/dXdot is taken as the identity on the variables flagged
 *             differential by id (semi-explicit DAE)
 */
SUNDIALS_EXPORT int IDASPMSetJacobians(void *ida_mem, SUNMatrix dFdX, SUNMatrix dFdXdot);

#ifdef __cplusplus
}
#endif

#endif /* _IDA_SPM_H */
