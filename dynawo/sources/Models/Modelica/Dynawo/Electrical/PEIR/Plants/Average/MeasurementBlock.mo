within Dynawo.Electrical.PEIR.Plants.Average;

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
//   - U_pcc_pu_abs : filtered PCC voltage magnitude                  (pu)
//   - U_pcc_q      : q-axis PCC voltage (PLL error signal)           (pu)
//   - P_plant / Q_plant : filtered active/reactive power at PCC      (pu)
//   - P_LV / Q_LV  : filtered active/reactive power at LV node       (pu)
//   - V_LV_d / V_LV_q : dq-axis LV node voltage                     (pu)
//   - I_conv_d / I_conv_q : dq-axis converter output current         (pu)
//
// Sign convention: generator convention (positive = injected into the grid).
// All quantities are in per-unit on the machine base (UNom, SNom).
// ============================================================================
model MeasurementBlock

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 1 – Initialisation parameters
  // These define the steady-state (t = 0) values used to initialise the
  // filter states and output signals so that the simulation starts in
  // equilibrium without any transient at t = 0.
  // ──────────────────────────────────────────────────────────────────────────

  // PCC voltage initial conditions (network αβ frame)
  parameter Real UrPcc0Pu   "Initial real part of PCC voltage (pu)";
  parameter Real UiPcc0Pu   "Initial imaginary part of PCC voltage (pu)";

  // PCC current initial conditions (network αβ frame, generator convention)
  parameter Real IrPcc0Pu   "Initial real part of PCC current (pu)";
  parameter Real IiPcc0Pu   "Initial imaginary part of PCC current (pu)";

  // PLL initial angle
  parameter Real Theta0     "Initial PLL angle θ₀ (rad)";

  // Scalar initial values for filter pre-loading
  parameter Real U0_pcc     "Initial PCC voltage magnitude (pu)";
  parameter Real k_filter   "Measurement low-pass filter gain (pu/pu)";
  parameter Real T_filter   "Measurement low-pass filter time constant (s)";

  // Initial power values at PCC (generator convention)
  parameter Real P0_pcc     "Initial active power at PCC (pu, generator convention)";
  parameter Real Q0_pcc     "Initial reactive power at PCC (pu, generator convention)";

  // Initial power values at the internal LV node (generator convention)
  parameter Real P0_LV      "Initial active power at LV node (pu, generator convention)";
  parameter Real Q0_LV      "Initial reactive power at LV node (pu, generator convention)";

  // Initial q-axis PCC voltage in the PLL frame (should be ≈ 0 at PLL lock)
  parameter Real U_pcc_q_0  "Initial q-axis PCC voltage in PLL frame (pu)";

  // Initial converter dq current components
  parameter Real I_conv_d_0 "Initial d-axis converter current (pu)";
  parameter Real I_conv_q_0 "Initial q-axis converter current (pu)";

  // Initial LV node dq voltage components
  parameter Real V_LV_d_0   "Initial d-axis voltage at LV node (pu)";
  parameter Real V_LV_q_0   "Initial q-axis voltage at LV node (pu)";

  // Initial LV node voltage in αβ frame
  parameter Real u_LV_re_0  "Initial real part of LV node voltage (pu)";
  parameter Real u_LV_im_0  "Initial imaginary part of LV node voltage (pu)";

  // Initial converter current in αβ frame
  parameter Real I_conv_re_0 "Initial real part of converter output current (pu)";
  parameter Real I_conv_im_0 "Initial imaginary part of converter output current (pu)";

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 2 – Input signals (raw instantaneous values from the network)
  // ──────────────────────────────────────────────────────────────────────────

  // PCC voltage components in the network αβ reference frame
  Modelica.Blocks.Interfaces.RealInput V_pcc_re(start = UrPcc0Pu)
    "Real part of PCC voltage in αβ frame (pu)"
    annotation(Placement(transformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {-68, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput V_pcc_im(start = UiPcc0Pu)
    "Imaginary part of PCC voltage in αβ frame (pu)"
    annotation(Placement(transformation(origin = {-110, 74}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {-94, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // PCC current components in αβ frame (generator convention)
  Modelica.Blocks.Interfaces.RealInput I_pcc_re(start = IrPcc0Pu)
    "Real part of PCC current in αβ frame (pu, generator convention)"
    annotation(Placement(transformation(origin = {-110, 32}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {-20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput I_pcc_im(start = IiPcc0Pu)
    "Imaginary part of PCC current in αβ frame (pu, generator convention)"
    annotation(Placement(transformation(origin = {-110, 12}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {-44, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // PLL angle (shared by all αβ → dq transformers in this block)
  Modelica.Blocks.Interfaces.RealInput theta_pll(start = Theta0)
    "PLL angle θ_PLL used for αβ → dq frame transformation (rad)"
    annotation(Placement(transformation(origin = {-112, 52}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {110, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  // Internal LV bus voltage components in αβ frame
  Modelica.Blocks.Interfaces.RealInput u_LV_re(start = u_LV_re_0)
    "Real part of internal LV node voltage in αβ frame (pu)"
    annotation(Placement(transformation(origin = {-109, -9}, extent = {{-9, -9}, {9, 9}}),
               iconTransformation(origin = {32, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput u_LV_im(start = u_LV_im_0)
    "Imaginary part of internal LV node voltage in αβ frame (pu)"
    annotation(Placement(transformation(origin = {-109, -31}, extent = {{-9, -9}, {9, 9}}),
               iconTransformation(origin = {6, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Converter output current components in αβ frame
  Modelica.Blocks.Interfaces.RealInput I_conv_re(start = I_conv_re_0)
    "Real part of converter output current in αβ frame (pu)"
    annotation(Placement(transformation(origin = {-111, -57}, extent = {{-11, -11}, {11, 11}}),
               iconTransformation(origin = {90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput I_conv_im(start = I_conv_im_0)
    "Imaginary part of converter output current in αβ frame (pu)"
    annotation(Placement(transformation(origin = {-111, -81}, extent = {{-11, -11}, {11, 11}}),
               iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 3 – Output signals (filtered, ready for control loops)
  // ──────────────────────────────────────────────────────────────────────────

  // PCC voltage magnitude (filtered) – fed to plant controller Q–U loop
  Modelica.Blocks.Interfaces.RealOutput U_pcc_pu_abs(start = U0_pcc)
    "Filtered PCC voltage magnitude (pu)"
    annotation(Placement(transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {44, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // q-axis PCC voltage in dq frame – used as PLL error signal in GFL control
  Modelica.Blocks.Interfaces.RealOutput U_pcc_q(start = U_pcc_q_0)
    "q-axis PCC voltage in PLL dq frame; ≈ 0 at PLL lock (pu)"
    annotation(Placement(transformation(origin = {110, 68}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {82, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // dq-axis converter output currents – fed to inner current controller
  Modelica.Blocks.Interfaces.RealOutput I_conv_d(start = I_conv_d_0)
    "d-axis converter output current (pu)"
    annotation(Placement(transformation(origin = {110, -54}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput I_conv_q(start = I_conv_q_0)
    "q-axis converter output current (pu)"
    annotation(Placement(transformation(origin = {110, -68}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}})));

  // dq-axis LV node voltage – fed to outer loop feed-forward paths
  Modelica.Blocks.Interfaces.RealOutput V_LV_d(start = V_LV_d_0)
    "d-axis voltage at internal LV node (pu)"
    annotation(Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput V_LV_q(start = V_LV_q_0)
    "q-axis voltage at internal LV node (pu)"
    annotation(Placement(transformation(origin = {110, -14}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}})));

  // Plant-level powers at PCC (filtered) – fed to plant controller
  Modelica.Blocks.Interfaces.RealOutput P_plant(start = P0_pcc)
    "Filtered active power at PCC, generator convention (pu)"
    annotation(Placement(transformation(origin = {109, 83}, extent = {{-9, -9}, {9, 9}}),
               iconTransformation(origin = {-10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput Q_plant(start = Q0_pcc)
    "Filtered reactive power at PCC, generator convention (pu)"
    annotation(Placement(transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {16, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // LV node powers (filtered) – fed to GFL converter outer loop
  Modelica.Blocks.Interfaces.RealOutput P_LV(start = P0_LV)
    "Filtered active power at internal LV node, generator convention (pu)"
    annotation(Placement(transformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput Q_LV(start = Q0_LV)
    "Filtered reactive power at internal LV node, generator convention (pu)"
    annotation(Placement(transformation(origin = {110, -84}, extent = {{-10, -10}, {10, 10}}),
               iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 4 – αβ → dq transformers
  // Each TransformRItoDQ block rotates a phasor (re, im) from the static
  // network reference frame into the rotating dq frame defined by θ_PLL.
  // The same PLL angle is used by all four transformers so they share a
  // common reference frame with the converter controller.
  // ──────────────────────────────────────────────────────────────────────────

  // Transformer for PCC voltage V_pcc → (Ud_pcc, Uq_pcc)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ
    annotation(Placement(transformation(origin = {-22, 74}, extent = {{-10, -10}, {10, 10}})));

  // Transformer for PCC current I_pcc → (Id_pcc, Iq_pcc)
  // (used to compute plant-level P and Q at the PCC)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ1
    annotation(Placement(transformation(origin = {-10, 30}, extent = {{-10, -10}, {10, 10}})));

  // Transformer for LV node voltage u_LV → (V_LV_d, V_LV_q)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ2
    annotation(Placement(transformation(origin = {-19, -7}, extent = {{-11, -11}, {11, 11}})));

  // Transformer for converter output current I_conv → (I_conv_d, I_conv_q)
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ3
    annotation(Placement(transformation(origin = {-23, -61}, extent = {{-11, -11}, {11, 11}})));

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 5 – Instantaneous power and voltage expressions
  // Powers are computed using the dq dot-product formula:
  //   P = Ud · Id + Uq · Iq
  //   Q = Uq · Id − Ud · Iq
  // These are instantaneous values; the filters below produce the smoothed
  // signals that are actually sent to the controllers.
  // ──────────────────────────────────────────────────────────────────────────

  // PCC voltage magnitude: |V_pcc| = sqrt(re² + im²)
  Modelica.Blocks.Sources.RealExpression abs_value(
    y = sqrt(V_pcc_re^2 + V_pcc_im^2))
    "Instantaneous PCC voltage magnitude (pu)"
    annotation(Placement(transformation(origin = {30, 20}, extent = {{-10, -10}, {10, 10}})));

  // Plant-level active power at PCC: P = Ud_pcc · Id_pcc + Uq_pcc · Iq_pcc
  Modelica.Blocks.Sources.RealExpression P_plant_expre(
    y = transformRItoDQ.ud*transformRItoDQ1.ud + transformRItoDQ.uq*transformRItoDQ1.uq)
    "Instantaneous active power at PCC in dq frame (pu)"
    annotation(Placement(transformation(origin = {30, 82}, extent = {{-10, -10}, {10, 10}})));

  // Plant-level reactive power at PCC: Q = Uq_pcc · Id_pcc − Ud_pcc · Iq_pcc
  Modelica.Blocks.Sources.RealExpression Q_plant_expre(
    y = transformRItoDQ.uq*transformRItoDQ1.ud - transformRItoDQ.ud*transformRItoDQ1.uq)
    "Instantaneous reactive power at PCC in dq frame (pu)"
    annotation(Placement(transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}})));

  // Active power at LV node: P_LV = V_LV_d · Id_pcc + V_LV_q · Iq_pcc
  // (uses PCC current as the branch current flowing through the LV node)
  Modelica.Blocks.Sources.RealExpression P_LV_expre(
    y = transformRItoDQ2.ud*transformRItoDQ1.ud + transformRItoDQ2.uq*transformRItoDQ1.uq)
    "Instantaneous active power at LV node in dq frame (pu)"
    annotation(Placement(transformation(origin = {40, -34}, extent = {{-10, -10}, {10, 10}})));


  // Reactive power at LV node: Q_LV = V_LV_q · Id_pcc − V_LV_d · Iq_pcc
  Modelica.Blocks.Sources.RealExpression Q_LV_expr(y = transformRItoDQ2.uq*transformRItoDQ1.ud - transformRItoDQ2.ud*transformRItoDQ1.uq)
    "Instantaneous reactive power at LV node in dq frame (pu)"
    annotation(Placement(transformation(origin = {30, -84}, extent = {{-10, -10}, {10, 10}})));

  // Alternative P calculation directly from αβ components:
  // P = V_re · I_re + V_im · I_im  (cross-check / unused output)
  Modelica.Blocks.Sources.RealExpression P_from_RI(
    y = V_pcc_re*I_pcc_re + V_pcc_im*I_pcc_im)
    "Active power computed directly in αβ frame (pu) – diagnostic / cross-check";

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 6 – First-order low-pass filters with rate limiting
  // Each filter smooths the corresponding instantaneous expression before
  // sending it to the control loops.  All filters share the same gain
  // k_filter and time constant T_filter.
  // The RateLimFirstOrderFreeze variant freezes the output when a freeze
  // condition is active (e.g., during fault ride-through).
  // ──────────────────────────────────────────────────────────────────────────

  // Filter for PCC voltage magnitude → U_pcc_pu_abs
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(
    k = k_filter, T = T_filter, Y0 = U0_pcc)
    "Low-pass filter for PCC voltage magnitude"
    annotation(Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));

  // Filter for plant-level active power at PCC → P_plant
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(
    k = k_filter, T = T_filter, Y0 = P0_pcc)
    "Low-pass filter for active power at PCC"
    annotation(Placement(transformation(origin = {70, 82}, extent = {{-10, -10}, {10, 10}})));

  // Filter for plant-level reactive power at PCC → Q_plant
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze2(
    k = k_filter, T = T_filter, Y0 = Q0_pcc)
    "Low-pass filter for reactive power at PCC"
    annotation(Placement(transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}})));

  // Filter for active power at LV node → P_LV
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze3(
    k = k_filter, T = T_filter, Y0 = P0_LV)
    "Low-pass filter for active power at internal LV node"
    annotation(Placement(transformation(origin = {70, -34}, extent = {{-10, -10}, {10, 10}})));

  // Filter for reactive power at LV node → Q_LV
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze4(
    k = k_filter, T = T_filter, Y0 = Q0_LV)
    "Low-pass filter for reactive power at internal LV node"
    annotation(Placement(transformation(origin = {70, -84}, extent = {{-10, -10}, {10, 10}})));

equation
  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 7 – PLL angle distribution
  // The same θ_PLL is broadcast to all four αβ → dq transformers so that
  // every measurement uses the identical rotating reference frame.
  // ──────────────────────────────────────────────────────────────────────────
  connect(transformRItoDQ.phi,  theta_pll)
    annotation(Line(points = {{-33, 68}, {-88.5, 68}, {-88.5, 52}, {-112, 52}}, color = {0, 0, 127}));
  // PLL angle → PCC voltage transformer

  connect(transformRItoDQ1.phi, theta_pll)
    annotation(Line(points = {{-20, 24}, {-88, 24}, {-88, 52}, {-112, 52}}, color = {0, 0, 127}));
  // PLL angle → PCC current transformer

  connect(transformRItoDQ2.phi, theta_pll)
    annotation(Line(points = {{-31, -14}, {-88, -14}, {-88, 52}, {-112, 52}}, color = {0, 0, 127}));
  // PLL angle → LV node voltage transformer

  connect(transformRItoDQ3.phi, theta_pll)
    annotation(Line(points = {{-35, -68}, {-88, -68}, {-88, 52}, {-112, 52}}, color = {0, 0, 127}));
  // PLL angle → converter current transformer

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 8 – Algebraic assignments: αβ inputs → transformer ports
  // The TransformRItoDQ blocks expose a complex input u = u.re + j·u.im.
  // These equations map the scalar RealInput signals to the complex port.
  // ──────────────────────────────────────────────────────────────────────────
  V_pcc_re   = transformRItoDQ.u.re;   // real part of PCC voltage phasor
  V_pcc_im   = transformRItoDQ.u.im;   // imaginary part of PCC voltage phasor

  I_pcc_re   = transformRItoDQ1.u.re;  // real part of PCC current phasor
  I_pcc_im   = transformRItoDQ1.u.im;  // imaginary part of PCC current phasor

  u_LV_re    = transformRItoDQ2.u.re;  // real part of LV node voltage phasor
  u_LV_im    = transformRItoDQ2.u.im;  // imaginary part of LV node voltage phasor

  I_conv_re  = transformRItoDQ3.u.re;  // real part of converter current phasor
  I_conv_im  = transformRItoDQ3.u.im;  // imaginary part of converter current phasor

  // ──────────────────────────────────────────────────────────────────────────
  // SECTION 9 – Signal routing: transformer outputs → block outputs and filters
  // ──────────────────────────────────────────────────────────────────────────

  // LV node voltage dq components – direct pass-through (no filter needed
  // because these are used as feed-forward, not as slow plant feedback)
  connect(transformRItoDQ2.ud, V_LV_d)
    annotation(Line(points = {{-7, 0},   {110, 0}},   color = {0, 0, 127}));
  // d-axis LV node voltage → output port V_LV_d

  connect(V_LV_q, transformRItoDQ2.uq)
    annotation(Line(points = {{110, -14}, {-7, -14}}, color = {0, 0, 127}));
  // q-axis LV node voltage → output port V_LV_q

  // q-axis PCC voltage – direct pass-through (used as PLL error; must not be
  // delayed by a filter to preserve PLL bandwidth)
  connect(U_pcc_q, transformRItoDQ.uq)
    annotation(Line(points = {{110, 68}, {-10, 68}}, color = {0, 0, 127}));
  // q-axis PCC voltage → output port U_pcc_q (PLL error signal)

  // Converter current dq components – direct pass-through to inner current loop
  connect(I_conv_d, transformRItoDQ3.ud)
    annotation(Line(points = {{110, -54}, {-11, -54}}, color = {0, 0, 127}));
  // d-axis converter current → output port I_conv_d

  connect(transformRItoDQ3.uq, I_conv_q)
    annotation(Line(points = {{-11, -68}, {110, -68}}, color = {0, 0, 127}));
  // q-axis converter current → output port I_conv_q

  // PCC voltage magnitude: expression → filter → output
  connect(abs_value.y,       rateLimFirstOrderFreeze.u)
    annotation(Line(points = {{41, 20}, {58, 20}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, U_pcc_pu_abs)
    annotation(Line(points = {{81, 20}, {110, 20}}, color = {0, 0, 127}));

  // Active power at PCC: expression → filter → output
  connect(P_plant_expre.y,   rateLimFirstOrderFreeze1.u)
    annotation(Line(points = {{41, 82}, {58, 82}}, color = {0, 0, 127}));
  connect(P_plant,           rateLimFirstOrderFreeze1.y)
    annotation(Line(points = {{109, 83}, {104.75, 83}, {104.75, 81},
               {100.5, 81}, {100.5, 82}, {81, 82}}, color = {0, 0, 127}));

  // Reactive power at PCC: expression → filter → output
  connect(rateLimFirstOrderFreeze2.u, Q_plant_expre.y)
    annotation(Line(points = {{58, 50}, {41, 50}}, color = {0, 0, 127}));
  connect(Q_plant,           rateLimFirstOrderFreeze2.y)
    annotation(Line(points = {{110, 50}, {81, 50}}, color = {0, 0, 127}));

  // Active power at LV node: expression → filter → output
  connect(P_LV_expre.y,      rateLimFirstOrderFreeze3.u)
    annotation(Line(points = {{51, -34}, {58, -34}}, color = {0, 0, 127}));
  connect(P_LV,              rateLimFirstOrderFreeze3.y)
    annotation(Line(points = {{110, -34}, {81, -34}}, color = {0, 0, 127}));

  // Reactive power at LV node: expression → filter → output
  connect(Q_LV_expr.y,       rateLimFirstOrderFreeze4.u)
    annotation(Line(points = {{41, -84}, {58, -84}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze4.y, Q_LV)
    annotation(Line(points = {{81, -84}, {110, -84}}, color = {0, 0, 127}));

  annotation(
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}},
                lineColor = {0, 0, 0}, fillColor = {255, 255, 255},
                fillPattern = FillPattern.Solid),
      Text(origin = {0, 0}, extent = {{-90, 20}, {90, -20}},
           textString = "measurement filters")},
      coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Diagram);
end MeasurementBlock;