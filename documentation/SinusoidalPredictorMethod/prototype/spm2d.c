/*
 * 2x2 NON-SYMMETRIC oscillating test for IDASPM.
 *
 * Validates the CSC Jacobian orientation in the estimator -- a transpose bug
 * is invisible on the 1x1 test but corrupts the Newton direction here (A is
 * non-symmetric), so a wrong orientation fails to grow the step size.
 *
 *   X'(t) = A X(t) + b(t),   A = [[a11,a12],[a21,a22]]  (a12 != a21)
 *   F(t,X,X') = X' - A X - b(t) = 0      => dF/dX = -A,  dF/dX' = I
 *
 * Manufactured solution per component i:
 *   Xi(t) = ui(t) sin(w t) + vi(t) cos(w t),  ui,vi = ui_inf + (ui0-ui_inf)e^{l t}
 * b(t) = X'(t) - A X(t) from the closed form.  Both components oscillating.
 */
#include <stdio.h>
#include <math.h>
#include <ida/ida.h>
#include <ida/ida_spm.h>
#include <nvector/nvector_serial.h>
#include <sunmatrix/sunmatrix_dense.h>
#include <sunmatrix/sunmatrix_sparse.h>
#include <sunlinsol/sunlinsol_dense.h>

#define N 2
static const double A[N][N] = {{-1.0, 4.0}, {-0.3, -2.0}};   /* non-symmetric */
static double W, LAM;
static double uinf[N], vinf[N], u0[N], v0[N];

static void coeffs(double t, double *u, double *v) {
  double e = exp(LAM*t);
  for (int i=0;i<N;i++){ u[i]=uinf[i]+(u0[i]-uinf[i])*e; v[i]=vinf[i]+(v0[i]-vinf[i])*e; }
}
static void exact(double t, double *X) {
  double u[N],v[N]; coeffs(t,u,v);
  for (int i=0;i<N;i++) X[i]=u[i]*sin(W*t)+v[i]*cos(W*t);
}
static void exactdot(double t, double *Xd) {
  double e=exp(LAM*t), u[N],v[N],ud[N],vd[N]; coeffs(t,u,v);
  for(int i=0;i<N;i++){ ud[i]=LAM*(u0[i]-uinf[i])*e; vd[i]=LAM*(v0[i]-vinf[i])*e;
    Xd[i]=ud[i]*sin(W*t)+u[i]*W*cos(W*t)+vd[i]*cos(W*t)-v[i]*W*sin(W*t); }
}
static void bvec(double t, double *b) {
  double X[N],Xd[N]; exact(t,X); exactdot(t,Xd);
  for(int i=0;i<N;i++){ double ax=0; for(int j=0;j<N;j++) ax+=A[i][j]*X[j]; b[i]=Xd[i]-ax; }
}

static int resfn(realtype t, N_Vector yy, N_Vector yp, N_Vector rr, void *ud) {
  (void)ud; realtype *y=N_VGetArrayPointer(yy), *yd=N_VGetArrayPointer(yp), *r=N_VGetArrayPointer(rr);
  double b[N]; bvec(t,b);
  for(int i=0;i<N;i++){ double ax=0; for(int j=0;j<N;j++) ax+=A[i][j]*y[j]; r[i]=yd[i]-ax-b[i]; }
  return 0;
}
static void *g_mem=NULL; static SUNContext g_ctx=NULL; static int g_spm=0;
/* full dense IDA Jacobian J = -A + cj I; also push CSR dF/dX, dF/dXdot to SPM */
static int jacfn(realtype t, realtype cj, N_Vector yy,N_Vector yp,N_Vector rr,
                 SUNMatrix JJ,void*ud,N_Vector t1,N_Vector t2,N_Vector t3){
  (void)t;(void)yy;(void)yp;(void)rr;(void)ud;(void)t1;(void)t2;(void)t3;
  realtype *J=SUNDenseMatrix_Data(JJ);            /* column-major */
  for(int c=0;c<N;c++) for(int r=0;r<N;r++) J[r+N*c]= -A[r][c] + (r==c?cj:0.0);
  if (g_spm) {
    SUNMatrix dFdX=SUNSparseMatrix(N,N,N*N,CSR_MAT,g_ctx);
    SUNMatrix dFdXdot=SUNSparseMatrix(N,N,N,CSR_MAT,g_ctx);
    { sunindextype *rp=SM_INDEXPTRS_S(dFdX),*cv=SM_INDEXVALS_S(dFdX); realtype *da=SM_DATA_S(dFdX);
      int k=0; for(int i=0;i<N;i++){rp[i]=k; for(int j=0;j<N;j++){cv[k]=j; da[k]=-A[i][j]; k++;}} rp[N]=k; }
    { sunindextype *rp=SM_INDEXPTRS_S(dFdXdot),*cv=SM_INDEXVALS_S(dFdXdot); realtype *da=SM_DATA_S(dFdXdot);
      for(int i=0;i<N;i++){rp[i]=i; cv[i]=i; da[i]=1.0;} rp[N]=N; }
    IDASPMSetJacobians(g_mem,dFdX,dFdXdot);
    SUNMatDestroy(dFdX); SUNMatDestroy(dFdXdot);
  }
  return 0;
}

int main(int argc,char**argv){
  double tol=(argc>1)?atof(argv[1]):1e-4, tend=(argc>2)?atof(argv[2]):2.0;
  int useSPM=(argc>3)?atoi(argv[3]):1;
  W=2.0*M_PI*50.0; LAM=-1.0;
  uinf[0]=1.0; vinf[0]=0.0; uinf[1]=0.5; vinf[1]=-0.3;
  /* default: start ON the steady sinusoid; pass argv[3]=2 for a transient */
  if (argc>4 && atoi(argv[4])) { u0[0]=uinf[0]-0.8; v0[0]=vinf[0]+0.6; u0[1]=uinf[1]+0.7; v0[1]=vinf[1]-0.5; }
  else { u0[0]=uinf[0]; v0[0]=vinf[0]; u0[1]=uinf[1]; v0[1]=vinf[1]; }

  SUNContext ctx; SUNContext_Create(NULL,&ctx); g_ctx=ctx;
  N_Vector yy=N_VNew_Serial(N,ctx), yp=N_VNew_Serial(N,ctx);
  { double X[N],Xd[N]; exact(0,X); exactdot(0,Xd);
    for(int i=0;i<N;i++){N_VGetArrayPointer(yy)[i]=X[i];N_VGetArrayPointer(yp)[i]=Xd[i];} }

  void*mem=IDACreate(ctx); g_mem=mem; IDAInit(mem,resfn,0.0,yy,yp); IDASStolerances(mem,tol,tol); IDASetMaxOrd(mem,2);
  SUNMatrix Adm=SUNDenseMatrix(N,N,ctx); SUNLinearSolver LS=SUNLinSol_Dense(yy,Adm,ctx);
  IDASetLinearSolver(mem,LS,Adm); IDASetJacFn(mem,jacfn); IDASetStopTime(mem,tend);

  if(useSPM){
    N_Vector isAC=N_VNew_Serial(N,ctx), id=N_VNew_Serial(N,ctx);
    for(int i=0;i<N;i++){N_VGetArrayPointer(isAC)[i]=1.0;N_VGetArrayPointer(id)[i]=1.0;}
    IDASetId(mem,id); g_spm=1;
    int f=IDASetSPM(mem,isAC,W,id,N*N);
    if(f){printf("IDASetSPM failed %d\n",f);return 1;}
  }

  double maxerr=0,maxh=0,t=0,tret,tprev=0; long nst=0; int flag;
  while(t<tend-1e-12){
    flag=IDASolve(mem,tend,&tret,yy,yp,IDA_ONE_STEP);
    if(flag<0){printf("IDA error %d at t=%g\n",flag,tret);break;}
    t=tret; double X[N]; exact(t,X);
    for(int i=0;i<N;i++){double e=fabs(N_VGetArrayPointer(yy)[i]-X[i]); if(e>maxerr)maxerr=e;}
    double h=t-tprev; tprev=t; if(h>maxh)maxh=h;
    if(flag==IDA_TSTOP_RETURN)break;
  }
  IDAGetNumSteps(mem,&nst);
  printf("%s  steps=%ld  maxh=%.3e  maxerr=%.3e\n", useSPM?"IDASPM":"IDA   ", nst, maxh, maxerr);
  return 0;
}
