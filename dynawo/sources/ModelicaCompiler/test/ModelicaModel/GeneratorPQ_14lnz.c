/* Linearization */
#include "GeneratorPQ_model.h"
#include "GeneratorPQ_16dae.h"
#if defined(__cplusplus)
extern "C" {
#endif
const char *GeneratorPQ_linear_model_frame()
{
  return "model linearized_model \"GeneratorPQ\"\n"
  "  parameter Integer n = 4 \"number of states\";\n"
  "  parameter Integer m = 0 \"number of inputs\";\n"
  "  parameter Integer p = 0 \"number of outputs\";\n"
  "  parameter Real x0[n] = %s;\n"
  "  parameter Real u0[m] = %s;\n"
  "\n"
  "  parameter Real A[n, n] =\n\t[%s];\n\n"
  "  parameter Real B[n, m] = zeros(n, m);%s\n\n"
  "  parameter Real C[p, n] = zeros(p, n);%s\n\n"
  "  parameter Real D[p, m] = zeros(p, m);%s\n\n"
  "\n"
  "  Real x[n](start=x0);\n"
  "  input Real u[m];\n"
  "  output Real y[p];\n"
  "\n"
  "  Real 'x_generator.deltaPmRefPu.value' = x[1];\n"
  "  Real 'x_generator.omegaRefPu.value' = x[2];\n"
  "  Real 'x_generator.terminal.V.im' = x[3];\n"
  "  Real 'x_generator.terminal.V.re' = x[4];\n"
  "equation\n"
  "  der(x) = A * x + B * u;\n"
  "  y = C * x + D * u;\n"
  "end linearized_model;\n";
}
const char *GeneratorPQ_linear_model_datarecovery_frame()
{
  return "model linearized_model \"GeneratorPQ\"\n"
  "  parameter Integer n = 4 \"number of states\";\n"
  "  parameter Integer m = 0 \"number of inputs\";\n"
  "  parameter Integer p = 0 \"number of outputs\";\n"
  "  parameter Integer nz = 8 \"data recovery variables\";\n"
  "  parameter Real x0[4] = %s;\n"
  "  parameter Real u0[0] = %s;\n"
  "  parameter Real z0[8] = %s;\n"
  "\n"
  "  parameter Real A[n, n] =\n\t[%s];\n\n"
  "  parameter Real B[n, m] = zeros(n, m);%s\n\n"
  "  parameter Real C[p, n] = zeros(p, n);%s\n\n"
  "  parameter Real D[p, m] = zeros(p, m);%s\n\n"
  "  parameter Real Cz[nz, n] =\n\t[%s];\n\n"
  "  parameter Real Dz[nz, m] = zeros(nz, m);%s\n\n"
  "\n"
  "  Real x[n](start=x0);\n"
  "  input Real u[m];\n"
  "  output Real y[p];\n"
  "  output Real z[nz];\n"
  "\n"
  "  Real 'x_generator.deltaPmRefPu.value' = x[1];\n"
  "  Real 'x_generator.omegaRefPu.value' = x[2];\n"
  "  Real 'x_generator.terminal.V.im' = x[3];\n"
  "  Real 'x_generator.terminal.V.re' = x[4];\n"
  "  Real 'z_generator.PGen' = z[1];\n"
  "  Real 'z_generator.PGenPu' = z[2];\n"
  "  Real 'z_generator.PGenRawPu' = z[3];\n"
  "  Real 'z_generator.SGenPu.im' = z[4];\n"
  "  Real 'z_generator.UPu' = z[5];\n"
  "  Real 'z_generator.genState' = z[6];\n"
  "  Real 'z_generator.terminal.i.im' = z[7];\n"
  "  Real 'z_generator.terminal.i.re' = z[8];\n"
  "equation\n"
  "  der(x) = A * x + B * u;\n"
  "  y = C * x + D * u;\n"
  "  z = Cz * x + Dz * u;\n"
  "end linearized_model;\n";
}
#if defined(__cplusplus)
}
#endif

