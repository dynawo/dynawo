within Dynawo.Electrical.PEIR.Plants.Average;

// =============================================================================
// Author  : Gaia Bergamaschi
//
// Phase-Locked Loop (PLL) for a Grid-Following (GFL) converter.
//
// ── Purpose ──────────────────────────────────────────────────────────────────
//   Estimates the grid voltage phase angle (theta) and frequency (omegaPLLPu)
//   by driving the q-axis component of the grid voltage to zero in the
//   converter's rotating reference frame.
//   When uqgridPu = 0, the internal frame is locked to the grid phasor.
//
// ── Control structure ────────────────────────────────────────────────────────
//   The error signal is uqgridPu (q-axis voltage in the estimated frame).
//   A PI controller acts on this error:
//     - Proportional branch (gain Kp):       fast frequency correction
//     - Integral branch (LimIntegrator, Ki): eliminates steady-state error
//   The PI output represents the frequency deviation from the reference.
//   It is added to omegaRefPu to obtain the estimated frequency omegaPLLPu.
//   The estimated frequency is then integrated (× omegaNom) to obtain theta.
//
// ── Frequency limits ─────────────────────────────────────────────────────────
//   The integral output is saturated between:
//     OmegaMinPu - Omega0Pu  and  OmegaMaxPu - Omega0Pu
//   so that omegaPLLPu stays within [OmegaMinPu, OmegaMaxPu].
// =============================================================================

model pll "Phase-Locked Loop"

  // ── Parameters ───────────────────────────────────────────────
  parameter Types.PerUnit Kp
    "PI proportional gain — sets PLL bandwidth (higher = faster tracking, higher SSO risk)";
  parameter Types.PerUnit Ki
    "PI integral gain — eliminates steady-state phase error";
  parameter Types.PerUnit OmegaMaxPu
    "Upper frequency limit (pu, base OmegaNom)";
  parameter Types.PerUnit OmegaMinPu
    "Lower frequency limit (pu, base OmegaNom)";

  // ── Initial conditions ───────────────────────────────────────
  parameter Types.Angle Theta0
    "Initial phase angle between converter frame and grid frame (rad)";
  parameter Real Omega0Pu
    "Initial grid frequency (pu, base OmegaNom)";
  parameter Real uqgrid0PU
    "Initial q-axis grid voltage in converter frame (pu) — should be 0 at lock";

  // ── Inputs ───────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu)
    "Reference frequency of the system (pu, base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqgridPu(start = uqgrid0PU)
    "Q-axis grid voltage in converter frame — PLL error signal (pu)" annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = Omega0Pu)
    "Estimated grid frequency (pu, base OmegaNom)" annotation(
    Placement(transformation(origin = {150, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput theta(start = Theta0)
    "Estimated grid voltage phase angle (rad)" annotation(
    Placement(transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));

  // ── PI controller ────────────────────────────────────────────
  // Proportional branch: fast response to phase error
  Modelica.Blocks.Math.Gain gain(k = Kp) annotation(
    Placement(visible = true, transformation(origin = {0, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Integral branch: drives steady-state uqgridPu to zero
  // Output saturated to keep frequency within [OmegaMinPu, OmegaMaxPu]
  Modelica.Blocks.Continuous.LimIntegrator limIntegrator(k = Ki, outMax = OmegaMaxPu - Omega0Pu, outMin = OmegaMinPu - Omega0Pu, initType = Modelica.Blocks.Types.Init.InitialOutput, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {0, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // PI sum: frequency deviation = Kp*uq + Ki*∫uq
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // ── Frequency reconstruction ─────────────────────────────────
  // omegaPLLPu = omegaRefPu + PI output (frequency deviation)
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // ── Phase angle integration ──────────────────────────────────
  // theta = ∫ omegaPLLPu × omegaNom dt
  Modelica.Blocks.Continuous.Integrator integrator(y_start = Theta0, k = SystemBase.omegaNom, initType = Modelica.Blocks.Types.Init.InitialOutput) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  connect(uqgridPu, gain.u) annotation(
    Line(points = {{-150, 0}, {-60, 0}, {-60, 20}, {-12, 20}}, color = {0, 0, 127}));
  connect(uqgridPu, limIntegrator.u) annotation(
    Line(points = {{-150, 0}, {-60, 0}, {-60, -20}, {-12, -20}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{11, 20}, {20, 20}, {20, 6}, {38, 6}}, color = {0, 0, 127}));
  connect(limIntegrator.y, add1.u2) annotation(
    Line(points = {{11, -20}, {20, -20}, {20, -6}, {38, -6}}, color = {0, 0, 127}));
  connect(add1.y, integrator.u) annotation(
    Line(points = {{61, 0}, {98, 0}}, color = {0, 0, 127}));
  connect(add1.y, add2.u1) annotation(
    Line(points = {{61, 0}, {80, 0}, {80, -54}, {98, -54}}, color = {0, 0, 127}));
  connect(omegaRefPu, add2.u2) annotation(
    Line(points = {{-150, -80}, {80, -80}, {80, -66}, {98, -66}}, color = {0, 0, 127}));
  connect(add2.y, omegaPLLPu) annotation(
    Line(points = {{121, -60}, {150, -60}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{121, 0}, {150, 0}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
      <p><b>Author:</b> Gaia Bergamaschi</p>
      <p>Phase-Locked Loop for a Grid-Following (GFL) converter.</p>
      <p>Tracks the grid voltage phase by driving the q-axis voltage
      component to zero in the converter's estimated reference frame.
      A PI controller acts on uqgridPu: the proportional branch provides
      fast tracking, the integral branch eliminates steady-state error.</p>
      <p>The PI output is a frequency deviation added to omegaRefPu to
      reconstruct omegaPLLPu, which is then integrated to obtain theta.</p>
      <p><b>SSO note:</b> low Kp/Ki values reduce PLL bandwidth and can
      interact with the outer loop to cause low-frequency oscillations
      (Cheng et al. 2023).</p>
    </html>"),
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}}),
      Text(origin = {-31, 8}, extent = {{-49, 72}, {111, -88}}, textString = "PLL")}));

end pll;