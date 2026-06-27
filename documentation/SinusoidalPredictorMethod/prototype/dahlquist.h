/*
 * Canonical SPM test problem: Dahlquist equation with an oscillating forcing
 * term (SinusoidalPredictorAnalysis.pdf, section 2.1).
 *
 *    X'(t) = lambda * X(t) + bbar(t),   lambda < 0
 *    bbar(t) = ub*sin(w t) + vb*cos(w t)
 *
 * Manufactured (closed-form) solution:
 *    Xth(t) = uth(t) sin(w t) + vth(t) cos(w t)
 *    (uth,vth) = (uinf,vinf) + (u0-uinf, v0-vinf) e^{lambda t}
 * with the forcing chosen so Xth solves the ODE:
 *    ub = -lambda*uinf - w*vinf - w*(v0-vinf) e^{lambda t}
 *    vb = -lambda*vinf + w*uinf - w*(u0-uinf) e^{lambda t}
 *
 * Implicit-DAE residual:  F(t,y,yp) = yp - lambda*y - bbar(t) = 0
 *
 * This single oscillating differential variable is exactly the setting SPM is
 * designed for: a signal that oscillates at w but whose envelope relaxes to a
 * steady sinusoid. A classical adaptive solver is forced to tiny steps by w;
 * SPM should take large steps once the envelope settles.
 */
#ifndef DAHLQUIST_H
#define DAHLQUIST_H

#include <math.h>

/* problem parameters (file-local defaults; shared by baseline & SPM harness) */
typedef struct {
  double lambda;   /* relaxation rate (<0) */
  double w;        /* angular frequency    */
  double uinf, vinf;  /* steady Fourier coeffs */
  double u0,  v0;      /* initial Fourier coeffs */
} DahlParams;

static DahlParams dahl_default(void) {
  DahlParams p;
  p.lambda = -1.0;          /* slow envelope relaxation */
  p.w      = 2.0*M_PI*50.0; /* 50 Hz carrier = 100*pi */
  p.uinf   = 1.0;  p.vinf = 0.0;
  p.u0     = 0.2;  p.v0   = -0.5; /* start off the steady sinusoid */
  return p;
}

static inline double dahl_bbar(const DahlParams *p, double t) {
  double e = exp(p->lambda * t);
  double ub = -p->lambda*p->uinf - p->w*p->vinf - p->w*(p->v0 - p->vinf)*e;
  double vb = -p->lambda*p->vinf + p->w*p->uinf + p->w*(p->u0 - p->uinf)*e;
  return ub*sin(p->w*t) + vb*cos(p->w*t);
}

/* closed-form solution and its derivative */
static inline double dahl_exact(const DahlParams *p, double t) {
  double e = exp(p->lambda * t);
  double uth = p->uinf + (p->u0 - p->uinf)*e;
  double vth = p->vinf + (p->v0 - p->vinf)*e;
  return uth*sin(p->w*t) + vth*cos(p->w*t);
}
static inline double dahl_exact_dot(const DahlParams *p, double t) {
  double e   = exp(p->lambda * t);
  double uth = p->uinf + (p->u0 - p->uinf)*e;
  double vth = p->vinf + (p->v0 - p->vinf)*e;
  double uthd = p->lambda*(p->u0 - p->uinf)*e;
  double vthd = p->lambda*(p->v0 - p->vinf)*e;
  return uthd*sin(p->w*t) + uth*p->w*cos(p->w*t)
       + vthd*cos(p->w*t) - vth*p->w*sin(p->w*t);
}

#endif /* DAHLQUIST_H */
