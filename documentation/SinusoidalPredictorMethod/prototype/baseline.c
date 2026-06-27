/*
 * Baseline: integrate the Dahlquist-with-oscillating-forcing problem with plain
 * IDA 6.3.0 (dense), one step at a time, and report:
 *   - number of internal steps
 *   - max abs error vs the closed-form solution
 *   - mean / max step size
 *
 * This establishes the reference the ported IDASPM must beat on step count while
 * matching on accuracy.
 */
#include <stdio.h>
#include <math.h>

#include <ida/ida.h>
#include <nvector/nvector_serial.h>
#include <sunmatrix/sunmatrix_dense.h>
#include <sunlinsol/sunlinsol_dense.h>
#include <sundials/sundials_types.h>

#include "dahlquist.h"

static DahlParams P;

static int resfn(realtype t, N_Vector yy, N_Vector yp, N_Vector rr, void *ud) {
  (void)ud;
  realtype *y  = N_VGetArrayPointer(yy);
  realtype *yd = N_VGetArrayPointer(yp);
  realtype *r  = N_VGetArrayPointer(rr);
  r[0] = yd[0] - P.lambda*y[0] - dahl_bbar(&P, t);
  return 0;
}

/* J = dF/dy + cj dF/dyp = -lambda + cj */
static int jacfn(realtype t, realtype cj, N_Vector yy, N_Vector yp, N_Vector rr,
                 SUNMatrix JJ, void *ud, N_Vector t1, N_Vector t2, N_Vector t3) {
  (void)t;(void)yy;(void)yp;(void)rr;(void)ud;(void)t1;(void)t2;(void)t3;
  realtype *J = SUNDenseMatrix_Data(JJ);
  J[0] = -P.lambda + cj;
  return 0;
}

int main(int argc, char **argv) {
  double tol = (argc > 1) ? atof(argv[1]) : 1e-4;
  double tend = (argc > 2) ? atof(argv[2]) : 2.0;
  P = dahl_default();
  if (argc>4){P.u0=atof(argv[3]);P.v0=atof(argv[4]);}
  if (argc>6){P.lambda=atof(argv[5]);P.w=atof(argv[6]);}

  SUNContext ctx;
  SUNContext_Create(NULL, &ctx);

  N_Vector yy = N_VNew_Serial(1, ctx);
  N_Vector yp = N_VNew_Serial(1, ctx);
  N_VGetArrayPointer(yy)[0] = dahl_exact(&P, 0.0);
  N_VGetArrayPointer(yp)[0] = dahl_exact_dot(&P, 0.0);

  void *mem = IDACreate(ctx);
  IDAInit(mem, resfn, 0.0, yy, yp);
  IDASStolerances(mem, tol, tol);
  IDASetUserData(mem, NULL);
  IDASetMaxOrd(mem, 2);

  SUNMatrix A = SUNDenseMatrix(1, 1, ctx);
  SUNLinearSolver LS = SUNLinSol_Dense(yy, A, ctx);
  IDASetLinearSolver(mem, LS, A);
  IDASetJacFn(mem, jacfn);
  IDASetStopTime(mem, tend);

  double maxerr = 0.0, sumh = 0.0, maxh = 0.0;
  long nsteps = 0;
  double t = 0.0, tret;
  int flag;
  FILE *f = fopen("baseline_curve.csv", "w");
  fprintf(f, "t,y,exact,err,h\n");
  double tprev = 0.0;
  while (t < tend - 1e-12) {
    flag = IDASolve(mem, tend, &tret, yy, yp, IDA_ONE_STEP);
    if (flag < 0) { printf("IDA error flag=%d at t=%g\n", flag, tret); break; }
    t = tret;
    double yv = N_VGetArrayPointer(yy)[0];
    double ex = dahl_exact(&P, t);
    double err = fabs(yv - ex);
    if (err > maxerr) maxerr = err;
    double h = t - tprev; tprev = t;
    sumh += h; if (h > maxh) maxh = h;
    nsteps++;
    fprintf(f, "%.10g,%.10g,%.10g,%.3e,%.3e\n", t, yv, ex, err, h);
    if (flag == IDA_TSTOP_RETURN) break;
  }
  fclose(f);

  long nst=0, nre=0, nje=0, nni=0, netf=0;
  IDAGetNumSteps(mem, &nst);
  IDAGetNumResEvals(mem, &nre);
  IDAGetNumJacEvals(mem, &nje);
  IDAGetNumNonlinSolvIters(mem, &nni);
  IDAGetNumErrTestFails(mem, &netf);

  printf("=== IDA (plain) baseline ===\n");
  printf("tol=%.1e  tend=%g\n", tol, tend);
  printf("internal steps (nst)   : %ld\n", nst);
  printf("residual evals (nre)   : %ld\n", nre);
  printf("jacobian evals (nje)   : %ld\n", nje);
  printf("nonlin iters   (nni)   : %ld\n", nni);
  printf("err test fails (netf)  : %ld\n", netf);
  printf("mean step size         : %.3e\n", sumh/(nsteps>0?nsteps:1));
  printf("max  step size         : %.3e\n", maxh);
  printf("max abs error vs exact : %.3e\n", maxerr);

  IDAFree(&mem);
  SUNLinSolFree(LS);
  SUNMatDestroy(A);
  N_VDestroy(yy); N_VDestroy(yp);
  SUNContext_Free(&ctx);
  return 0;
}
