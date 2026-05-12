within Dynawo.Electrical.PEIR.Plants.Average;

model LCDynFilter
  "LC filter in RI coordinates (pu) between a left port (VSC) and a right AC terminal (to network)"

  // ── Initial conditions for states and I/O (pu) ───────────────
  // Left-side voltage (e.g. converter)
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

  // ── Inputs (left side + omega) ─────────────────────────────
  Modelica.Blocks.Interfaces.RealInput uLeft_rePu (start = uLeft_rePu0)
    "Left-side real-axis voltage (pu)" annotation(
      Placement(transformation(origin = {-120, 80}, extent = {{-20,-20},{20,20}}),
                iconTransformation(origin = {-120, 60}, extent = {{-20,-20},{20,20}})));

  Modelica.Blocks.Interfaces.RealInput uLeft_imPu (start = uLeft_imPu0)
    "Left-side imag-axis voltage (pu)" annotation(
      Placement(transformation(origin = {-120, 40}, extent = {{-20,-20},{20,20}}),
                iconTransformation(origin = {-120, 8}, extent = {{-20,-20},{20,20}})));

  Modelica.Blocks.Interfaces.RealInput omegaPu (start = omegaPu0)
    "Per-unit electrical frequency (pu, from PLL)" annotation(
      Placement(transformation(origin = {-120, 0}, extent = {{-20,-20},{20,20}}),
                iconTransformation(origin = {-60, -120}, extent = {{-20,-20},{20,20}}, rotation = 90)));

  // ── Outputs (left-side inductor current) ────────────────────
  Modelica.Blocks.Interfaces.RealOutput iLeft_rePu (start = iLeft_rePu0)
    "Real-axis current from left into filter (pu)" annotation(
      Placement(transformation(origin = {120, -18}, extent = {{-20,-20},{20,20}}),
                iconTransformation(origin = {-120, -34}, extent = {{-20,-20},{20,20}}, rotation = 180)));

  Modelica.Blocks.Interfaces.RealOutput iLeft_imPu (start = iLeft_imPu0)
    "Imag-axis current from left into filter (pu)" annotation(
      Placement(transformation(origin = {120, -60}, extent = {{-20,-20},{20,20}}),
                iconTransformation(origin = {-120, -80}, extent = {{-20,-20},{20,20}}, rotation = 180)));

  // ── Right node: AC terminal (to transformer / network) ─────
  Dynawo.Connectors.ACPower terminalRight
    "Right node electrical terminal (to transformer / grid)" annotation(
      Placement(transformation(origin = {12, 42}, extent = {{90, -10}, {110, 10}}),
                iconTransformation(extent = {{90,-10},{110,10}})));

  // Internal state variables
  Real iLeft_re(start = iLeft_rePu0, fixed = false);
  Real iLeft_im(start = iLeft_imPu0, fixed = false);
  Real uRight_re(start = uRight_rePu0, fixed = false);
  Real uRight_im(start = uRight_imPu0, fixed = false);
initial equation
  der(iLeft_re)  = 0;
  der(iLeft_im)  = 0;
  der(uRight_re) = 0;
  der(uRight_im) = 0;

equation
  // ── Inductor dynamics (series branch between left and right node) ──
  // Lf/omegaNom * d(i_d)/dt = u_d_left - Rf*i_d + omegaPu*Lf*i_q - u_d_right
  // Lf/omegaNom * d(i_q)/dt = u_q_left - Rf*i_q - omegaPu*Lf*i_d - u_q_right

  LfPu/omegaNom * der(iLeft_re) =
    uLeft_rePu - RfPu * iLeft_re + omegaPu * LfPu * iLeft_im - uRight_re;

  LfPu/omegaNom * der(iLeft_im) =
    uLeft_imPu - RfPu * iLeft_im - omegaPu * LfPu * iLeft_re - uRight_im;

  // ── Capacitor dynamics at right node (shunt Cf to ground) ──
  // Cf/omegaNom * d(u_d_right)/dt = i_d_left + omegaPu*Cf*u_q_right - i_d_network
  // Cf/omegaNom * d(u_q_right)/dt = i_q_left - omegaPu*Cf*u_d_right - i_q_network
  //
  // Convention: terminalRight.i is the current injected INTO the node
  //             (Dynawo.Connectors.ACPower.flow).
  // Currents "from right node to network" = -terminalRight.i.

  CfPu/omegaNom * der(uRight_re) =
    iLeft_re + omegaPu * CfPu * uRight_im - (-terminalRight.i.re);

  CfPu/omegaNom * der(uRight_im) =
    iLeft_im - omegaPu * CfPu * uRight_re - (-terminalRight.i.im);

  // ── Outputs ────────────────────────────────────────────────
  iLeft_rePu  = iLeft_re;
  iLeft_imPu  = iLeft_im;

  // Right node voltage = terminal potential
  terminalRight.V.re = uRight_re;
  terminalRight.V.im = uRight_im;

  annotation(
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}}),
      Text(origin = {-4, 12}, extent = {{-80, 20}, {80, -20}},
           textString = "RLC\nfilter AC")
    }),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end LCDynFilter;