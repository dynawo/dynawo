within Dynawo.Electrical.Controls.Utilities.Average;


model MeasurementBlock
  /**
   * Author Gaia Bergamaschi
   * Electrical measurement and filtering block for the GFL model.
   *
   * Computes all electrical measurements required by the GFL converter and
   * plant controllers, starting from PCC and internal LV bus voltages/currents,
   * and provides filtered quantities in dq and scalar form (P, Q, U, I).
   */
  // ============================================================================
  // MeasurementBlock – Electrical Measurement and Filtering Block
  //
  // This block computes all the electrical measurements needed by the GFL
  // converter controller and the plant controller, starting from the raw
  // instantaneous voltages and currents at the PCC and at the internal LV bus.
  //
  // Processing pipeline for each measured quantity:
  //   1. Receive real/imaginary components in the network (αβ) reference frame.
  //   2. Transform to the rotating dq frame using the PLL angle θ_PLL.
  //   3. Compute the desired scalar (power, voltage magnitude, current component).
  //   4. Apply a first-order low-pass filter with rate limiting (RateLimFirstOrder)
  //      to smooth out noise before the signals reach the control loops.
  //
  // Outputs summary:
  //   - UPccPu : filtered PCC voltage magnitude                  (pu)
  //   - U_pcc_q      : q-axis PCC voltage (PLL error signal)           (pu)
  //   - PPccPu / QPccPu : filtered active/reactive power at PCC      (pu)
  //   - PLVPu / QLVPu  : filtered active/reactive power at LV node       (pu)
  //   - udLVPu / uqLVPu : dq-axis LV node voltage                     (pu)
  //   - idConvPu / iqConvPu : dq-axis converter output current         (pu)
  //
  // Sign convention: generator convention (positive = injected into the grid).
  // All quantities are in per-unit on the machine base (UNom, SNom).
  // ============================================================================
  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 1 – Initialisation parameters
  // These define the steady-state (t = 0) values used to initialise the
  // filter states and output signals so that the simulation starts in
  // equilibrium without any transient at t = 0.
  // ──────────────────────────────────────────────────────────────────────────
  // PCC voltage initial conditions (network αβ frame)
  parameter Real UrPcc0Pu "Initial real part of PCC voltage (pu)";
  parameter Real UiPcc0Pu "Initial imaginary part of PCC voltage (pu)";
  // PCC current initial conditions (network αβ frame, generator convention)
  parameter Real IrPcc0Pu "Initial real part of PCC current (pu)";
  parameter Real IiPcc0Pu "Initial imaginary part of PCC current (pu)";
  // PLL initial angle
  parameter Real Theta0 "Initial PLL angle θ₀ (rad)";
  // Scalar initial values for filter pre-loading
  parameter Real U0_pcc "Initial PCC voltage magnitude (pu)";
  parameter Real KFilter "Measurement low-pass filter gain (pu/pu)";
  parameter Real tFilter "Measurement low-pass filter time constant (s)";
  //parameter Real tFilter_v "Measurement low-pass filter time constant (s)";
  //parameter Real tFilter_pll "Measurement low-pass filter time constant (s)";
  // Initial power values at PCC (generator convention)
  parameter Real P0_pcc "Initial active power at PCC (pu, generator convention)";
  parameter Real Q0_pcc "Initial reactive power at PCC (pu, generator convention)";
  // Initial power values at the internal LV node (generator convention)
  parameter Real P0_LV "Initial active power at LV node (pu, generator convention)";
  parameter Real Q0_LV "Initial reactive power at LV node (pu, generator convention)";
  // Initial q-axis PCC voltage in the PLL frame (should be ≈ 0 at PLL lock)
  parameter Real U_pcc_q_0 "Initial q-axis PCC voltage in PLL frame (pu)";
  // Initial converter dq current components
  parameter Real idConvPu_0 "Initial d-axis converter current (pu)";
  parameter Real iqConvPu_0 "Initial q-axis converter current (pu)";
  // Initial LV node dq voltage components
  parameter Real udLVPu_0 "Initial d-axis voltage at LV node (pu)";
  parameter Real uqLVPu_0 "Initial q-axis voltage at LV node (pu)";
  // Initial LV node voltage in αβ frame
  parameter Real u_LV_re_0 "Initial real part of LV node voltage (pu)";
  parameter Real u_LV_im_0 "Initial imaginary part of LV node voltage (pu)";
  // Initial converter current in αβ frame
  parameter Real I_conv_re_0 "Initial real part of converter output current (pu)";
  parameter Real I_conv_im_0 "Initial imaginary part of converter output current (pu)";
  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 2 – Input signals (raw instantaneous values from the network)
  // ──────────────────────────────────────────────────────────────────────────
  // PCC voltage components in the network αβ reference frame
  // PCC current components in αβ frame (generator convention)
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu annotation(
    Placement(transformation(origin = {-110, 76}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPccPu annotation(
    Placement(transformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uLVPu annotation(
    Placement(transformation(origin = {-110, -4}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iConvPu "Complex current in αβ frame (pu)" annotation(
    Placement(transformation(origin = {-110, -44}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uFiltPu annotation(
    Placement(transformation(origin = {-110, -84}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}})));

  // PLL angle (shared by all αβ → dq transformers in this block)

  Modelica.Blocks.Interfaces.RealInput thetaPLL(start = Theta0) "PLL angle θ_PLL used for αβ → dq frame transformation (rad)" annotation(
    Placement(transformation(origin = {-110, 52}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  // Internal LV bus voltage components in αβ frame
  // Converter output current components in αβ frame
  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 3 – Output signals (filtered, ready for control loops)
  // ──────────────────────────────────────────────────────────────────────────
  // PCC voltage magnitude (filtered) – fed to plant controller Q–U loop
  Modelica.Blocks.Interfaces.RealOutput UPccPu(start = U0_pcc) "Filtered PCC voltage magnitude (pu)" annotation(
    Placement(transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {44, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  // q-axis PCC voltage in dq frame – used as PLL error signal in GFL control
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = U_pcc_q_0) "q-axis PCC voltage in PLL dq frame; ≈ 0 at PLL lock (pu)" annotation(
    Placement(transformation(origin = {110, -112}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {82, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // dq-axis converter output currents – fed to inner current controller
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = idConvPu_0) "d-axis converter output current (pu)" annotation(
    Placement(transformation(origin = {110, -54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = iqConvPu_0) "q-axis converter output current (pu)" annotation(
    Placement(transformation(origin = {110, -68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}})));
  // dq-axis LV node voltage – fed to outer loop feed-forward paths
  Modelica.Blocks.Interfaces.RealOutput udLVPu(start = udLVPu_0) "d-axis voltage at internal LV node (pu)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqLVPu(start = uqLVPu_0) "q-axis voltage at internal LV node (pu)" annotation(
    Placement(transformation(origin = {110, -14}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}})));
  // Plant-level powers at PCC (filtered) – fed to plant controller
  Modelica.Blocks.Interfaces.RealOutput PPccPu(start = P0_pcc) "Filtered active power at PCC, generator convention (pu)" annotation(
    Placement(transformation(origin = {109, 79}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput QPccPu(start = Q0_pcc) "Filtered reactive power at PCC, generator convention (pu)" annotation(
    Placement(transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {16, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  // LV node powers (filtered) – fed to GFL converter outer loop
  Modelica.Blocks.Interfaces.RealOutput PLVPu(start = P0_LV) "Filtered active power at internal LV node, generator convention (pu)" annotation(
    Placement(transformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QLVPu(start = Q0_LV) "Filtered reactive power at internal LV node, generator convention (pu)" annotation(
    Placement(transformation(origin = {110, -84}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 4 – αβ → dq transformers
  // Each TransformRItoDQ block rotates a phasor (re, im) from the static
  // network reference frame into the rotating dq frame defined by θ_PLL.
  // The same PLL angle is used by all four transformers so they share a
  // common reference frame with the converter controller.
  // ──────────────────────────────────────────────────────────────────────────
  // Transformer for PCC voltage V_pcc → (Ud_pcc, Uq_pcc)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(transformation(origin = {-30, 70}, extent = {{-10, -10}, {10, 10}})));
  // Transformer for PCC current I_pcc → (Id_pcc, Iq_pcc)
  // (used to compute plant-level P and Q at the PCC)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ1 annotation(
    Placement(transformation(origin = {-30, 30}, extent = {{-10, -10}, {10, 10}})));
  // Transformer for LV node voltage u_LV → (udLVPu, uqLVPu)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ2 annotation(
    Placement(transformation(origin = {-30, -10}, extent = {{-10, -10}, {10, 10}})));
  // Transformer for converter output current I_conv → (idConvPu, iqConvPu)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ3 annotation(
    Placement(transformation(origin = {-30, -50}, extent = {{-10, -10}, {10, 10}})));
  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 5 – Instantaneous power and voltage expressions
  // Powers are computed using the dq dot-product formula:
  //   P = Ud · Id + Uq · Iq
  //   Q = Uq · Id − Ud · Iq
  // These are instantaneous values; the filters below produce the smoothed
  // signals that are actually sent to the controllers.
  // ──────────────────────────────────────────────────────────────────────────
  // PCC voltage magnitude: |V_pcc| = sqrt(re² + im²)
  Modelica.Blocks.Sources.RealExpression abs_value(y = sqrt(uPccPu.re^2 + uPccPu.im^2)) "Instantaneous PCC voltage magnitude (pu)" annotation(
    Placement(transformation(origin = {30, 20}, extent = {{-10, -10}, {10, 10}})));
  // Plant-level active power at PCC: P = Ud_pcc · Id_pcc + Uq_pcc · Iq_pcc
  Modelica.Blocks.Sources.RealExpression PPccPu_expre(y = transformRItoDQ.ud*transformRItoDQ1.ud + transformRItoDQ.uq*transformRItoDQ1.uq) "Instantaneous active power at PCC in dq frame (pu)" annotation(
    Placement(transformation(origin = {30, 80}, extent = {{-10, -10}, {10, 10}})));

  // Plant-level reactive power at PCC: Q = Uq_pcc · Id_pcc − Ud_pcc · Iq_pcc
  Modelica.Blocks.Sources.RealExpression QPccPu_expre(y = transformRItoDQ.uq*transformRItoDQ1.ud - transformRItoDQ.ud*transformRItoDQ1.uq) "Instantaneous reactive power at PCC in dq frame (pu)" annotation(
    Placement(transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}})));
  // Active power at LV node: PLVPu = udLVPu · Id_pcc + uqLVPu · Iq_pcc
  // (uses PCC current as the branch current flowing through the LV node)
  Modelica.Blocks.Sources.RealExpression PLVPu_expre(y = transformRItoDQ2.ud*transformRItoDQ1.ud + transformRItoDQ2.uq*transformRItoDQ1.uq) "Instantaneous active power at LV node in dq frame (pu)" annotation(
    Placement(transformation(origin = {30, -34}, extent = {{-10, -10}, {10, 10}})));
  // Reactive power at LV node: QLVPu = uqLVPu · Id_pcc − udLVPu · Iq_pcc
  Modelica.Blocks.Sources.RealExpression QLVPu_expr(y = transformRItoDQ2.uq*transformRItoDQ1.ud - transformRItoDQ2.ud*transformRItoDQ1.uq) "Instantaneous reactive power at LV node in dq frame (pu)" annotation(
    Placement(transformation(origin = {30, -84}, extent = {{-10, -10}, {10, 10}})));
  // Alternative P calculation directly from αβ components:
  // P = V_re · I_re + V_im · I_im  (cross-check / unused output)
  Modelica.Blocks.Sources.RealExpression P_from_RI(y = uPccPu.re*iPccPu.re + uPccPu.im*iPccPu.im) "Active power computed directly in αβ frame (pu) – diagnostic / cross-check";
  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 6 – First-order low-pass filters with rate limiting
  // Each filter smooths the corresponding instantaneous expression before
  // sending it to the control loops.  All filters share the same gain
  // KFilter and time constant tFilter.
  // The RateLimFirstOrderFreeze variant freezes the output when a freeze
  // condition is active (e.g., during fault ride-through).
  // ──────────────────────────────────────────────────────────────────────────
  // Filter for PCC voltage magnitude → UPccPu
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(k = KFilter, T = tFilter, Y0 = U0_pcc) "Low-pass filter for PCC voltage magnitude" annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));
  // Filter for plant-level active power at PCC → PPccPu
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(k = KFilter, T = tFilter, Y0 = P0_pcc) "Low-pass filter for active power at PCC" annotation(
    Placement(transformation(origin = {70, 80}, extent = {{-10, -10}, {10, 10}})));
  // Filter for plant-level reactive power at PCC → QPccPu
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze2(k = KFilter, T = tFilter, Y0 = Q0_pcc) "Low-pass filter for reactive power at PCC" annotation(
    Placement(transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}})));
  // Filter for active power at LV node → PLVPu
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze3(k = KFilter, T = tFilter, Y0 = P0_LV) "Low-pass filter for active power at internal LV node" annotation(
    Placement(transformation(origin = {70, -34}, extent = {{-10, -10}, {10, 10}})));
  // Filter for reactive power at LV node → QLVPu
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze4(k = KFilter, T = tFilter, Y0 = Q0_LV) "Low-pass filter for reactive power at internal LV node" annotation(
    Placement(transformation(origin = {70, -84}, extent = {{-10, -10}, {10, 10}})));
  Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ4 annotation(
    Placement(transformation(origin = {-30, -90}, extent = {{-10, -10}, {10, 10}})));


equation
// ──────────────────────────────────────────────────────────────────────────
// SECTION 7 – PLL angle distribution
// The same θ_PLL is broadcast to all four αβ → dq transformers so that
// every measurement uses the identical rotating reference frame.
// ──────────────────────────────────────────────────────────────────────────
  connect(transformRItoDQ.phi, thetaPLL) annotation(
    Line(points = {{-41, 64}, {-88.5, 64}, {-88.5, 52}, {-110, 52}}, color = {0, 0, 127}));
// PLL angle → PCC voltage transformer
  connect(transformRItoDQ1.phi, thetaPLL) annotation(
    Line(points = {{-41, 24}, {-88, 24}, {-88, 52}, {-110, 52}}, color = {0, 0, 127}));
// PLL angle → PCC current transformer
  connect(transformRItoDQ2.phi, thetaPLL) annotation(
    Line(points = {{-41, -16}, {-88, -16}, {-88, 52}, {-110, 52}}, color = {0, 0, 127}));
// PLL angle → LV node voltage transformer
  connect(transformRItoDQ3.phi, thetaPLL) annotation(
    Line(points = {{-41, -56}, {-88, -56}, {-88, 52}, {-110, 52}}, color = {0, 0, 127}));
// PLL angle → converter current transformer
// ──────────────────────────────────────────────────────────────────────────
// SECTION 8 – Algebraic assignments: αβ inputs → transformer ports
// The TransformRItoDQ blocks expose a complex input u = u.re + j·u.im.
// These equations map the scalar RealInput signals to the complex port.
// ──────────────────────────────────────────────────────────────────────────

// ──────────────────────────────────────────────────────────────────────────
// SECTION 9 – Signal routing: transformer outputs → block outputs and filters
// ──────────────────────────────────────────────────────────────────────────
// LV node voltage dq components – direct pass-through (no filter needed
// because these are used as feed-forward, not as slow plant feedback)
// d-axis LV node voltage → output port udLVPu
// q-axis LV node voltage → output port uqLVPu
// q-axis PCC voltage – direct pass-through (used as PLL error; must not be
// delayed by a filter to preserve PLL bandwidth)
// q-axis PCC voltage → output port U_pcc_q (PLL error signal)
// Converter current dq components – direct pass-through to inner current loop
// d-axis converter current → output port idConvPu
// q-axis converter current → output port iqConvPu
// PCC voltage magnitude: expression → filter → output
  connect(abs_value.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{41, 20}, {58, 20}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, UPccPu) annotation(
    Line(points = {{81, 20}, {110, 20}}, color = {0, 0, 127}));
// Active power at PCC: expression → filter → output
  connect(PPccPu_expre.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{41, 80}, {58, 80}}, color = {0, 0, 127}));
  connect(PPccPu, rateLimFirstOrderFreeze1.y) annotation(
    Line(points = {{109, 79}, {100.5, 79}, {100.5, 80}, {81, 80}}, color = {0, 0, 127}));
// Reactive power at PCC: expression → filter → output
  connect(rateLimFirstOrderFreeze2.u, QPccPu_expre.y) annotation(
    Line(points = {{58, 50}, {41, 50}}, color = {0, 0, 127}));
  connect(QPccPu, rateLimFirstOrderFreeze2.y) annotation(
    Line(points = {{110, 50}, {81, 50}}, color = {0, 0, 127}));
// Active power at LV node: expression → filter → output
  connect(PLVPu_expre.y, rateLimFirstOrderFreeze3.u) annotation(
    Line(points = {{41, -34}, {58, -34}}, color = {0, 0, 127}));
  connect(PLVPu, rateLimFirstOrderFreeze3.y) annotation(
    Line(points = {{110, -34}, {81, -34}}, color = {0, 0, 127}));
// Reactive power at LV node: expression → filter → output
  connect(QLVPu_expr.y, rateLimFirstOrderFreeze4.u) annotation(
    Line(points = {{41, -84}, {58, -84}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze4.y, QLVPu) annotation(
    Line(points = {{81, -84}, {110, -84}}, color = {0, 0, 127}));
  connect(transformRItoDQ4.uq, uqFilterPu) annotation(
    Line(points = {{-19, -96}, {48.5, -96}, {48.5, -112}, {110, -112}}, color = {0, 0, 127}));
  connect(transformRItoDQ3.uq, iqConvPu) annotation(
    Line(points = {{-19, -56}, {45.5, -56}, {45.5, -68}, {110, -68}}, color = {0, 0, 127}));
  connect(transformRItoDQ3.ud, idConvPu) annotation(
    Line(points = {{-19, -44}, {45.5, -44}, {45.5, -54}, {110, -54}}, color = {0, 0, 127}));
  connect(transformRItoDQ2.uq, uqLVPu) annotation(
    Line(points = {{-19, -16}, {52, -16}, {52, -14}, {110, -14}}, color = {0, 0, 127}));
  connect(transformRItoDQ2.ud, udLVPu) annotation(
    Line(points = {{-19, -4}, {52, -4}, {52, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(uPccPu, transformRItoDQ.u) annotation(
    Line(points = {{-110, 76}, {-41, 76}}, color = {85, 170, 255}));
  connect(iPccPu, transformRItoDQ1.u) annotation(
    Line(points = {{-110, 36}, {-40, 36}}, color = {85, 170, 255}));
  connect(uLVPu, transformRItoDQ2.u) annotation(
    Line(points = {{-110, -4}, {-41, -4}}, color = {85, 170, 255}));
  connect(iConvPu, transformRItoDQ3.u) annotation(
    Line(points = {{-110, -44}, {-41, -44}}, color = {85, 170, 255}));
  connect(uFiltPu, transformRItoDQ4.u) annotation(
    Line(points = {{-110, -84}, {-41, -84}}, color = {85, 170, 255}));
  connect(thetaPLL, transformRItoDQ4.phi) annotation(
    Line(points = {{-110, 52}, {-88, 52}, {-88, -96}, {-40, -96}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(origin = {0, -10},fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 110}, {100, -110}}), Text(extent = {{-90, 20}, {90, -20}}, textString = "measurement filters")}, coordinateSystem(extent = {{-100, -120}, {100, 100}})),
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Diagram(coordinateSystem(extent = {{-100, -120}, {100, 100}})));
end MeasurementBlock;
