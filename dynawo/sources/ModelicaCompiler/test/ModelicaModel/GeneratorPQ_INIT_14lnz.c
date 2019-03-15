/* Linearization */
#include "GeneratorPQ_INIT_model.h"
#include "GeneratorPQ_INIT_16dae.h"
#if defined(__cplusplus)
extern "C" {
#endif

const char *GeneratorPQ_INIT_linear_model_frame()
{
  return "model linear_GeneratorPQ__INIT\n  parameter Integer n = 0 \"number of states\";\n  parameter Integer p = 0 \"number of inputs\";\n  parameter Integer q = 0 \"number of outputs\";\n"
  "\n"
  "  parameter Real x0[n] = %s;\n"
  "  parameter Real u0[p] = %s;\n"
  "\n"
  "  parameter Real A[n, n] = zeros(n, n);%s\n"
  "  parameter Real B[n, p] = zeros(n, p);%s\n"
  "  parameter Real C[q, n] = zeros(q, n);%s\n"
  "  parameter Real D[q, p] = zeros(q, p);%s\n"
  "\n"
  "  Real x[n];\n"
  "  input Real u[p];\n"
  "  output Real y[q];\n"
  "\n"
  "equation\n  der(x) = A * x + B * u;\n  y = C * x + D * u;\nend linear_GeneratorPQ__INIT;\n";
}
const char *GeneratorPQ_INIT_linear_model_datarecovery_frame()
{
  return "model linear_GeneratorPQ__INIT\n  parameter Integer n = 0 \"number of states\";\n  parameter Integer p = 0 \"number of inputs\";\n  parameter Integer q = 0 \"number of outputs\";\n  parameter Integer nz = 8 \"data recovery variables\";\n"
  "\n"
  "  parameter Real x0[0] = %s;\n"
  "  parameter Real u0[0] = %s;\n"
  "  parameter Real z0[8] = %s;\n"
  "\n"
  "  parameter Real A[n, n] = zeros(n, n);%s\n"
  "  parameter Real B[n, p] = zeros(n, p);%s\n"
  "  parameter Real C[q, n] = zeros(q, n);%s\n"
  "  parameter Real D[q, p] = zeros(q, p);%s\n"
  "  parameter Real Cz[nz, n] = zeros(nz, n);%s\n"
  "  parameter Real Dz[nz, p] = zeros(nz, p);%s\n"
  "\n"
  "  Real x[n];\n"
  "  input Real u[p];\n"
  "  output Real y[q];\n"
  "  output Real z[nz];\n"
  "\n"
  "  Real 'z_generator.PGen0Pu' = z[1];\n""  Real 'z_generator.QGen0Pu' = z[2];\n""  Real 'z_generator.i0Pu.im' = z[3];\n""  Real 'z_generator.i0Pu.re' = z[4];\n""  Real 'z_generator.s0Pu.im' = z[5];\n""  Real 'z_generator.s0Pu.re' = z[6];\n""  Real 'z_generator.u0Pu.im' = z[7];\n""  Real 'z_generator.u0Pu.re' = z[8];\n"
  "equation\n  der(x) = A * x + B * u;\n  y = C * x + D * u;\n  z = Cz * x + Dz * u;\nend linear_GeneratorPQ__INIT;\n";
}
#if defined(__cplusplus)
}
#endif

