within Dynawo.Electrical.PEIR.Plants.Average;

model LCDynFilter
  "LC filter in RI coordinates (pu) between a left port (voltage source) and a right node (to network)"

  // ── Initial conditions for states and I/O (pu) ───────────────
  // Left-side voltage (es. convertitore)
  parameter Real uLeft_rePu0  "Initial left-side real-axis voltage (pu)";
  parameter Real uLeft_imPu0  "Initial left-side imag-axis voltage (pu)";

  // Currents drawn by the external network at the right node
  // (positive from filter node to external network)
  parameter Real iRight_rePu0 "Initial real-axis current from right node to network (pu)";
  parameter Real iRight_imPu0 "Initial imag-axis current from right node to network (pu)";

  // Electrical frequency
  parameter Real omegaPu0     "Initial per-unit electrical frequency (pu)";

  // Inductor current from left into the filter branch
  parameter Real iLeft_rePu0  "Initial real-axis inductor current from left into filter (pu)";
  parameter Real iLeft_imPu0  "Initial imag-axis inductor current from left into filter (pu)";

  // Right node voltage (node connected to network)
  parameter Real uRight_rePu0 "Initial real-axis right-node voltage (pu)";
  parameter Real uRight_imPu0 "Initial imag-axis right-node voltage (pu)";

  // Series RL (between left side and right node)
  parameter Real RfPu "Series resistance R_f (pu)";
  parameter Real LfPu "Series inductance L_f (pu)";

  // Shunt capacitance at right node
  parameter Real CfPu "Shunt capacitance C_f at right node (pu)";

  // Nominal angular frequency (base), e.g. SystemBase.omegaNom
  parameter Real omegaNom "Nominal angular frequency (rad/s or pu base)";

  // ── Inputs ──────────────────────────────────────────────────
  // Left-side voltages (re/im) in pu
  Modelica.Blocks.Interfaces.RealInput uLeft_rePu (start = uLeft_rePu0)
    "Left-side real-axis voltage (pu)" annotation(
      Placement(transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput uLeft_imPu (start = uLeft_imPu0)
    "Left-side imag-axis voltage (pu)" annotation(
      Placement(transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {-120, 8}, extent = {{-20, -20}, {20, 20}})));

  // Currents drawn by the network at the right node (pu)
  // Positive when flowing from right node into the external network
  Modelica.Blocks.Interfaces.RealInput iRight_rePu (start = iRight_rePu0)
    "Real-axis current from right node to network (pu)" annotation(
      Placement(transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {120, -34}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealInput iRight_imPu (start = iRight_imPu0)
    "Imag-axis current from right node to network (pu)" annotation(
      Placement(transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {120, -82}, extent = {{-20, -20}, {20, 20}})));

  // PLL frequency (per-unit)
  Modelica.Blocks.Interfaces.RealInput omegaPu (start = omegaPu0)
    "Per-unit electrical frequency (pu, from PLL)" annotation(
      Placement(transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {-60, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));

  // ── Outputs ─────────────────────────────────────────────────
  // Inductor current on left side: current flowing from left into filter branch
  Modelica.Blocks.Interfaces.RealOutput iLeft_rePu (start = iLeft_rePu0)
    "Real-axis current from left into filter (pu)" annotation(
      Placement(transformation(origin = {120, -20}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  Modelica.Blocks.Interfaces.RealOutput iLeft_imPu (start = iLeft_imPu0)
    "Imag-axis current from left into filter (pu)" annotation(
      Placement(transformation(origin = {120, -60}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));

  // Right node voltage (node connected to network)
  Modelica.Blocks.Interfaces.RealOutput uRight_rePu (start = uRight_rePu0)
    "Right-node real-axis voltage (pu)" annotation(
      Placement(transformation(origin = {120, 60}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {120, 72}, extent = {{-20, -20}, {20, 20}})));

  Modelica.Blocks.Interfaces.RealOutput uRight_imPu (start = uRight_imPu0)
    "Right-node imag-axis voltage (pu)" annotation(
      Placement(transformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}}),
                iconTransformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}})));

protected
  // States: inductor currents (left side) and node voltage (right side)
  Real iLeft_re   "Inductor real-axis current from left into filter (pu)";
  Real iLeft_im   "Inductor imag-axis current from left into filter (pu)";
  Real uRight_re  "Right-node real-axis voltage (pu)";
  Real uRight_im  "Right-node imag-axis voltage (pu)";

equation
  // ── Inductor dynamics (series branch between left and right node) ──
  // Lf/omegaNom * d(i_d)/dt = u_d_left - Rf*i_d + omegaPu*Lf*i_q - u_d_right
  // Lf/omegaNom * d(i_q)/dt = u_q_left - Rf*i_q - omegaPu*Lf*i_d - u_q_right

  LfPu/omegaNom * der(iLeft_re) =
    uLeft_rePu - RfPu * iLeft_re + omegaPu * LfPu * iLeft_im - uRight_re;

  LfPu/omegaNom * der(iLeft_im) =
    uLeft_imPu - RfPu * iLeft_im - omegaPu * LfPu * iLeft_re - uRight_im;

  // ── Capacitor dynamics at right node (shunt Cf to ground) ──
  // Cf/omegaNom * d(u_d_right)/dt = i_d_left + omegaPu*Cf*u_q_right - i_d_right
  // Cf/omegaNom * d(u_q_right)/dt = i_q_left - omegaPu*Cf*u_d_right - i_q_right

  CfPu/omegaNom * der(uRight_re) =
    iLeft_re + omegaPu * CfPu * uRight_im - iRight_rePu;

  CfPu/omegaNom * der(uRight_im) =
    iLeft_im - omegaPu * CfPu * uRight_re - iRight_imPu;

  // ── Outputs ────────────────────────────────────────────────
  iLeft_rePu  = iLeft_re;
  iLeft_imPu  = iLeft_im;

  uRight_rePu = uRight_re;
  uRight_imPu = uRight_im;

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}}),
      Text(origin = {-4, 12}, extent = {{-80, 20}, {80, -20}},
           textString = "RLC 
filter")
    }),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end LCDynFilter;