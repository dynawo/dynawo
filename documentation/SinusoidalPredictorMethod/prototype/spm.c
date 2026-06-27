/*
 * IDASPM harness: same Dahlquist-with-oscillating-forcing problem as baseline.c,
 * but the oscillating variable is flagged AC and IDASetSPM is enabled.
 * Reports step count, accuracy vs closed form, and the IDA(plain) comparison.
 */
#include <stdio.h>
#include <math.h>

#include <ida/ida.h>
#include <ida/ida_spm.h>
#include <nvector/nvector_serial.h>
#include <sunmatrix/sunmatrix_dense.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <sunlinsol/sunlinsol_dense.h>
#include <sundials/sundials_types.h>

#include "dahlquist.h"

static DahlParams P;
static void *g_mem = NULL;          /* for pushing the SPM Jacobian from jacfn */
static SUNContext g_ctx = NULL;
static int g_spm = 0;               /* SPM enabled? */

static int resfn(realtype t, N_Vector yy, N_Vector yp, N_Vector rr, void *ud) {
  (void)ud;
  realtype *y=N_VGetArrayPointer(yy), *yd=N_VGetArrayPointer(yp), *r=N_VGetArrayPointer(rr);
  r[0] = yd[0] - P.lambda*y[0] - dahl_bbar(&P, t);
  return 0;
}
/* full IDA Jacobian J = -lambda + cj; also push dF/dX, dF/dXdot to the SPM */
static int jacfn(realtype t, realtype cj, N_Vector yy, N_Vector yp, N_Vector rr,
                 SUNMatrix JJ, void *ud, N_Vector t1,N_Vector t2,N_Vector t3) {
  (void)t;(void)yy;(void)yp;(void)rr;(void)ud;(void)t1;(void)t2;(void)t3;
  SUNDenseMatrix_Data(JJ)[0] = -P.lambda + cj;
  if (g_spm) {
    SUNMatrix dFdX = SUNSparseMatrix(1,1,1,CSR_MAT,g_ctx);
    SUNMatrix dFdXdot = SUNSparseMatrix(1,1,1,CSR_MAT,g_ctx);
    SM_INDEXPTRS_S(dFdX)[0]=0; SM_INDEXPTRS_S(dFdX)[1]=1; SM_INDEXVALS_S(dFdX)[0]=0; SM_DATA_S(dFdX)[0]=-P.lambda;
    SM_INDEXPTRS_S(dFdXdot)[0]=0; SM_INDEXPTRS_S(dFdXdot)[1]=1; SM_INDEXVALS_S(dFdXdot)[0]=0; SM_DATA_S(dFdXdot)[0]=1.0;
    IDASPMSetJacobians(g_mem, dFdX, dFdXdot);
    SUNMatDestroy(dFdX); SUNMatDestroy(dFdXdot);
  }
  return 0;
}

int main(int argc, char **argv) {
  double tol  = (argc>1)?atof(argv[1]):1e-4;
  double tend = (argc>2)?atof(argv[2]):2.0;
  P = dahl_default();
  if (argc>4){P.u0=atof(argv[3]);P.v0=atof(argv[4]);}
  if (argc>6){P.lambda=atof(argv[5]);P.w=atof(argv[6]);}

  SUNContext ctx; SUNContext_Create(NULL, &ctx); g_ctx=ctx;
  N_Vector yy=N_VNew_Serial(1,ctx), yp=N_VNew_Serial(1,ctx);
  N_VGetArrayPointer(yy)[0]=dahl_exact(&P,0.0);
  N_VGetArrayPointer(yp)[0]=dahl_exact_dot(&P,0.0);

  void *mem=IDACreate(ctx); g_mem=mem;
  IDAInit(mem,resfn,0.0,yy,yp);
  IDASStolerances(mem,tol,tol);
  IDASetMaxOrd(mem,2);

  SUNMatrix A=SUNDenseMatrix(1,1,ctx);
  SUNLinearSolver LS=SUNLinSol_Dense(yy,A,ctx);
  IDASetLinearSolver(mem,LS,A);
  IDASetJacFn(mem,jacfn);
  IDASetStopTime(mem,tend);

  /* enable SPM: the single variable is oscillating and differential */
  N_Vector isAC=N_VNew_Serial(1,ctx); N_VGetArrayPointer(isAC)[0]=1.0;
  N_Vector id  =N_VNew_Serial(1,ctx); N_VGetArrayPointer(id)[0]=1.0;  /* differential */
  IDASetId(mem,id);
  int sflag=IDASetSPM(mem,isAC,P.w,id,1); g_spm=1;
  if (sflag!=0){printf("IDASetSPM failed=%d\n",sflag);return 1;}

  double maxerr=0,sumh=0,maxh=0; long nsteps=0; double t=0,tret,tprev=0; int flag;
  FILE *f=fopen("spm_curve.csv","w"); fprintf(f,"t,y,exact,err,h\n");
  while (t<tend-1e-12) {
    flag=IDASolve(mem,tend,&tret,yy,yp,IDA_ONE_STEP);
    if (flag<0){printf("IDA error flag=%d at t=%g\n",flag,tret);break;}
    t=tret;
    double yv=N_VGetArrayPointer(yy)[0], ex=dahl_exact(&P,t), err=fabs(yv-ex);
    if(err>maxerr)maxerr=err;
    double h=t-tprev; tprev=t; sumh+=h; if(h>maxh)maxh=h; nsteps++;
    fprintf(f,"%.10g,%.10g,%.10g,%.3e,%.3e\n",t,yv,ex,err,h);
    if(flag==IDA_TSTOP_RETURN)break;
  }
  fclose(f);

  long nst=0,nre=0,nje=0,nni=0,netf=0;
  IDAGetNumSteps(mem,&nst); IDAGetNumResEvals(mem,&nre); IDAGetNumJacEvals(mem,&nje);
  IDAGetNumNonlinSolvIters(mem,&nni); IDAGetNumErrTestFails(mem,&netf);
  printf("=== IDASPM ===\n");
  printf("tol=%.1e  tend=%g  wbar=%.4f\n",tol,tend,P.w);
  printf("internal steps (nst)   : %ld\n",nst);
  printf("residual evals (nre)   : %ld\n",nre);
  printf("jacobian evals (nje)   : %ld\n",nje);
  printf("nonlin iters   (nni)   : %ld\n",nni);
  printf("err test fails (netf)  : %ld\n",netf);
  printf("mean step size         : %.3e\n",sumh/(nsteps>0?nsteps:1));
  printf("max  step size         : %.3e\n",maxh);
  printf("max abs error vs exact : %.3e\n",maxerr);

  IDAFree(&mem); SUNLinSolFree(LS); SUNMatDestroy(A);
  N_VDestroy(yy);N_VDestroy(yp);N_VDestroy(isAC);N_VDestroy(id);
  SUNContext_Free(&ctx);
  return 0;
}
