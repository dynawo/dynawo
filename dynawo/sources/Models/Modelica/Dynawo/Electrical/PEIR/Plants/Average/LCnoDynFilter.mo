within Dynawo.Electrical.PEIR.Plants.Average;

model LCnoDynFilter "Static LC filter in RI coordinates (pu) between a left port (VSC) and a right node (to network)"
  // ── Initial conditions for I/O (pu) ─────────────────────────
  parameter Real uLeft_rePu0 "Initial left-side real-axis voltage (pu)";
  parameter Real uLeft_imPu0 "Initial left-side imag-axis voltage (pu)";
  parameter Real iRight_rePu0 "Initial real-axis current from right node to network (pu)";
  parameter Real iRight_imPu0 "Initial imag-axis current from right node to network (pu)";
  parameter Real omegaPu0 "Initial per-unit electrical frequency (pu)";
  parameter Real iLeft_rePu0 "Initial real-axis current from left into filter (pu)";
  parameter Real iLeft_imPu0 "Initial imag-axis current from left into filter (pu)";
  parameter Real uRight_rePu0 "Initial real-axis right-node voltage (pu)";
  parameter Real uRight_imPu0 "Initial imag-axis right-node voltage (pu)";
  // Filter parameters
  parameter Real RfPu "Series resistance R_f (pu)";
  parameter Real LfPu "Series inductance L_f (pu)";
  parameter Real CfPu "Shunt capacitance C_f at right node (pu)";
  parameter Real omegaNom "Nominal angular frequency (rad/s or pu base)";
  // ── Inputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput uLeft_rePu(start = uLeft_rePu0) "Left-side real-axis voltage (pu)" annotation(
    Placement(transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput uLeft_imPu(start = uLeft_imPu0) "Left-side imag-axis voltage (pu)" annotation(
    Placement(transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 8}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput iRight_rePu(start = iRight_rePu0) "Real-axis current from right node to network (pu)" annotation(
    Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, -34}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput iRight_imPu(start = iRight_imPu0) "Imag-axis current from right node to network (pu)" annotation(
    Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, -82}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = omegaPu0) "Per-unit electrical frequency (pu, from PLL)" annotation(
    Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
  // ── Outputs ─────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput iLeft_rePu(start = iLeft_rePu0) "Real-axis current from left into filter (pu)" annotation(
    Placement(transformation(origin = {120, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iLeft_imPu(start = iLeft_imPu0) "Imag-axis current from left into filter (pu)" annotation(
    Placement(transformation(origin = {120, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput uRight_rePu(start = uRight_rePu0) "Right-node real-axis voltage (pu)" annotation(
    Placement(transformation(origin = {120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, 72}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput uRight_imPu(start = uRight_imPu0) "Right-node imag-axis voltage (pu)" annotation(
    Placement(transformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}})));
protected
  // Variabili interne algebriche (nessuna derivata)
  Real iLeft_re(start = iLeft_rePu0);
  Real iLeft_im(start = iLeft_imPu0);
  Real uRight_re(start = uRight_rePu0);
  Real uRight_im(start = uRight_imPu0);
equation
// ── Induttanza serie (Lf, Rf) in regime stazionario ─────────
// Da eq. dinamiche:
// 0 = uLeft_rePu - RfPu*iLeft_re + omegaPu*LfPu*iLeft_im - uRight_re
// 0 = uLeft_imPu - RfPu*iLeft_im - omegaPu*LfPu*iLeft_re - uRight_im
  0 = uLeft_rePu - RfPu*iLeft_re + omegaPu*LfPu*iLeft_im - uRight_re;
  0 = uLeft_imPu - RfPu*iLeft_im - omegaPu*LfPu*iLeft_re - uRight_im;
// ── Condensatore shunt Cf in regime stazionario ─────────────
// 0 = iLeft_re + omegaPu*CfPu*uRight_im - iRight_rePu
// 0 = iLeft_im - omegaPu*CfPu*uRight_re - iRight_imPu
  0 = iLeft_re + omegaPu*CfPu*uRight_im - iRight_rePu;
  0 = iLeft_im - omegaPu*CfPu*uRight_re - iRight_imPu;
// ── Outputs ────────────────────────────────────────────────
  iLeft_rePu = iLeft_re;
  iLeft_imPu = iLeft_im;
  uRight_rePu = uRight_re;
  uRight_imPu = uRight_im;
  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 12}, extent = {{-80, 20}, {80, -20}}, textString = "RLC\nfilter (static)")}),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end LCnoDynFilter;