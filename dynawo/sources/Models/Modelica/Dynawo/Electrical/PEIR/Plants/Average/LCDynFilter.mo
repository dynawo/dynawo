within Dynawo.Electrical.PEIR.Plants.Average;

model LCDynFilter

  "LC filter in real/imag (RI) coordinates, dynamics similar to DynRLCFilter (all in pu)"

  // Series RL (between converter and filter node)
  parameter Real RfPu "Filter series resistance R_f (pu)";
  parameter Real LfPu "Filter inductance L_f (pu)";

  // Shunt capacitance at filter node
  parameter Real CfPu "Filter shunt capacitance C_f (pu)";

  // Nominal angular frequency (base), e.g. SystemBase.omegaNom
  parameter Real omegaNom "Nominal angular frequency (rad/s or pu base)";

  // ── Inputs ──────────────────────────────────────────────────
  // Converter-side voltages (re/im) in pu
  Modelica.Blocks.Interfaces.RealInput urConvPu
    "Converter real-axis voltage (pu)" annotation(
      Placement(transformation(origin = {-80, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput uiConvPu
    "Converter imag-axis voltage (pu)" annotation(
      Placement(transformation(origin = {-80, -10}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 8}, extent = {{-20, -20}, {20, 20}})));

  // Currents drawn by the network at the filter node (PCC side), in pu
  // Positive when flowing from filter node into the network
  Modelica.Blocks.Interfaces.RealInput iPcc_rePu
    "Real-axis current from filter node to rest of network (pu)" annotation(
      Placement(transformation(origin = {0, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, -34}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput iPcc_imPu
    "Imag-axis current from filter node to rest of network (pu)" annotation(
      Placement(transformation(origin = {40, -80}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, -82}, extent = {{-20, -20}, {20, 20}})));

  // PLL frequency (per-unit)
  Modelica.Blocks.Interfaces.RealInput omegaPu
    "Per-unit electrical frequency (pu, from PLL)" annotation(
      Placement(transformation(origin = {-80, -50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  // ── Outputs ─────────────────────────────────────────────────
  // Inductor current on converter side: current flowing from converter into filter
  Modelica.Blocks.Interfaces.RealOutput iConv_rePu
    "Real-axis current from converter into filter (pu)" annotation(
      Placement(transformation(origin = {80, 30}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  Modelica.Blocks.Interfaces.RealOutput iConv_imPu
    "Imag-axis current from converter into filter (pu)" annotation(
      Placement(transformation(origin = {80, -10}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // Filter node voltage (this is the PCC voltage from filter side)
  Modelica.Blocks.Interfaces.RealOutput uFilt_rePu
    "Real-axis voltage at filter node (pu)" annotation(
      Placement(transformation(origin = {80, 70}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, 72}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput uFilt_imPu
    "Imag-axis voltage at filter node (pu)" annotation(
      Placement(transformation(origin = {80, 50}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}})));

protected
  // States: inductor currents (converter side) and capacitor voltage at filter node
  Real iConv_re   "Lf real-axis current (pu)";
  Real iConv_im   "Lf imag-axis current (pu)";
  Real uFilt_re   "Filter node real-axis voltage (pu)";
  Real uFilt_im   "Filter node imag-axis voltage (pu)";

equation
  // ── Inductor dynamics (series branch between converter and filter node) ──
  // Lf/omegaNom * d(i_d)/dt = u_d_conv - Rf*i_d + omegaPu*Lf*i_q - u_d_filt
  // Lf/omegaNom * d(i_q)/dt = u_q_conv - Rf*i_q - omegaPu*Lf*i_d - u_q_filt

  LfPu/omegaNom * der(iConv_re) =
    urConvPu - RfPu * iConv_re + omegaPu * LfPu * iConv_im - uFilt_re;

  LfPu/omegaNom * der(iConv_im) =
    uiConvPu - RfPu * iConv_im - omegaPu * LfPu * iConv_re - uFilt_im;

  // ── Capacitor dynamics at filter node (shunt Cf to ground) ──
  // Cf/omegaNom * d(u_d_filt)/dt = i_d_conv + omegaPu*Cf*u_q_filt - i_d_PCC
  // Cf/omegaNom * d(u_q_filt)/dt = i_q_conv - omegaPu*Cf*u_d_filt - i_q_PCC

  CfPu/omegaNom * der(uFilt_re) =
    iConv_re + omegaPu * CfPu * uFilt_im - iPcc_rePu;

  CfPu/omegaNom * der(uFilt_im) =
    iConv_im - omegaPu * CfPu * uFilt_re - iPcc_imPu;

  // ── Outputs ────────────────────────────────────────────────
  iConv_rePu = iConv_re;
  iConv_imPu = iConv_im;

  uFilt_rePu = uFilt_re;
  uFilt_imPu = uFilt_im;

  annotation(
    uses(Modelica(version="3.2.3")),
    Icon(graphics = {
      Rectangle(extent={{-100,100},{100,-100}}),
      Text(origin={0,60}, extent={{-80,20},{80,-20}},
           textString="LC Filter")
    }),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));

end LCDynFilter;