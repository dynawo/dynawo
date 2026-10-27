within Dynawo.Electrical.Controls.PEIR.BaseControls.Average;

model OuterLoop "Outer loop controller for a Grid-Following (GFL) converter"

  // Parameters

  parameter Real DidMax "Max rate of change of idRefPu in pu/s";
  parameter Real DidMin "Min rate of change of idRefPu in pu/s";
  parameter Real DyMaxd "Max rate of change of d-axis PI output in pu/s";
  parameter Real DyMaxq "Max rate of change of q-axis PI output in pu/s";
  parameter Real IqBoostMaxPu "Max reactive current boost in pu";
  parameter Real IqBoostMinPu "Min reactive current boost in pu";
  parameter Real IMaxPu "Maximum total current magnitude in pu";
  parameter Real Kpd "Proportional gain of d-axis PI in pu";
  parameter Real Kid "Integral gain of d-axis PI in pu/s";
  parameter Real Kpq "Proportional gain of q-axis PI in pu";
  parameter Real Kiq "Integral gain of q-axis PI in pu/s";
  parameter Real Kqv "Reactive boost boost gain  in pu/pu, 0 to disable";
  parameter Boolean PQFlag "Priority flag: true = P priority, false = Q priority";
  parameter Boolean PControlFlag "true: bypass P PI, use idRefPu = PRefPu/ULVPu | false: use PI regulator (default)";
  parameter Boolean QControlFlag "true: bypass Q PI, use i_q_ref = QRefPu/ULVPu | false: use PI regulator (default)";
  parameter Real UBoostHighPu "High voltage limit for reactiv power boost in pu";
  parameter Real UBoostLowPu "Low voltage limit for reactiv power boost in pu";
  parameter Real tBoost "Time constant of first-order filter on iqBoostPu in s to delay the reactive boost response. Set 0 to disable";
  parameter Real tPlant "Time constant of plant-to-outer-loop delay in s";
  parameter Real tSid "Sample time of idRefPu ramp limiter in s";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PInj0Pu) "Active power reference in pu (base SNom)" annotation(
    Placement(transformation(origin = {-220, 82}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, 60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput PLVPu(start = PInj0Pu) "Measured active power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-220, 52}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, 160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu(start = QInj0Pu) "Reactive power reference in pu (base SNom)" annotation(
    Placement(transformation(origin = {-220, 18}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput QLVPu(start = QInj0Pu) "Measured reactive power in pu (base SNom)" annotation(
    Placement(transformation(origin = {-220, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-220, -160}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu(start = UFilter0Pu) "Measured voltage in pu (base UNom)" annotation(
    Placement(transformation(origin = {-220, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-93, 219}, extent = {{-13, -13}, {13, 13}}, rotation = -90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = idRef0Pu) "d-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {224, 62}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = -iqRef0Pu) "q-axis current in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(transformation(origin = {210, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {220, -80}, extent = {{-20, -20}, {20, 20}})));

  // ── Plant communication delay ─────────────────────────────────
  // Models the delay between the plant-level controller and this outer loop.
  // A first-order filter with time constant tPlant is used.
  // ── Sum nodes (PRefPu - PLVPu, QRefPu - QLVPu) ───────────────
  Modelica.Blocks.Math.Feedback sum_node_p annotation(
    Placement(transformation(origin = {-88, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback sum_node_q annotation(
    Placement(transformation(origin = {-74, 20}, extent = {{-10, -10}, {10, 10}})));

  // ── PI controllers (green path, default) ─────────────────────
  // Anti-windup PI regulators. Active when k_direct_control_* = false.
  // Note: interaction between PI bandwidth and PLL is a known cause
  // of low-frequency SSO (Cheng et al. 2023, third mechanism).
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupIntegral piAntiwind(Kp = Kpd, tI = 1/Kid, Y0 = y_start_outer_d, DyMax = DyMaxd, YMax = IMaxPu) annotation(
    Placement(transformation(origin = {-28, 82}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.NonElectrical.Blocks.Continuous.PIAntiWindupIntegral piAntiwind1(Kp = Kpq, tI = 1/(Kiq), Y0 = -y_start_outer_q, DyMax = DyMaxq, YMax = IMaxPu) annotation(
    Placement(transformation(origin = {-24, 20}, extent = {{-20, -20}, {20, 20}})));

  // ── Direct path (orange path) ─────────────────────────────────
  // Stateless feedforward: idRefPu = PRefPu / ULVPu
  //                        iqRefPu = QRefPu / ULVPu
  // Active when k_direct_control_* = true.
  // Useful for diagnostics when PI parameters are unknown or mistuned.
  Modelica.Blocks.Math.Division division1 annotation(
    Placement(transformation(origin = {-66, 42}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Division division annotation(
    Placement(transformation(origin = {-50, -36}, extent = {{-10, -10}, {10, 10}})));

  // ── Mode switches ─────────────────────────────────────────────
  // Modelica Switch: output = u1 if u2 is TRUE, else u3.
  // u3 = direct path (orange), u1 = PI path (green).
  // So: k_direct_control_* = false  → direct, true → PI.
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {34, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch2 annotation(
    Placement(transformation(origin = {46, 18}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = PControlFlag) annotation(
    Placement(transformation(origin = {6, 70}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k = QControlFlag) annotation(
    Placement(transformation(origin = {13, 11}, extent = {{-5, -5}, {5, 5}})));

  // ── Current limiter with reactive boost ──────────────────────
  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.CurrentLimiterReactiveBoost current_limiter_outer_loop(IMaxPu = IMaxPu, PQFlag = PQFlag, UBoostHighPu = UBoostHighPu, UBoostLowPu = UBoostLowPu, Kqv = Kqv, IqBoostMaxPu = IqBoostMaxPu, IqBoostMinPu = IqBoostMinPu, U0Pu = UFilter0Pu, tBoost = tBoost) annotation(
    Placement(transformation(origin = {129, 47}, extent = {{-39, -39}, {39, 39}})));

  // ── Output ramp limiter on idRefPu ────────────────────────────
  NonElectrical.Blocks.NonLinear.RampLimiter rampLimiter(DuMax = DidMax, DuMin = DidMin, tS = tSid, Y0 = idRef0Pu, y(start = idRef0Pu)) annotation(
    Placement(transformation(origin = {192, 62}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tPlant, y_start = PInj0Pu, y(start = PInj0Pu)) annotation(
    Placement(transformation(origin = {-170, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tPlant) annotation(
    Placement(transformation(origin = {-148, 20}, extent = {{-10, -10}, {10, 10}})));

  // Initial conditions
  parameter Types.PerUnit idRef0Pu "Initial d-axis current reference in pu (base SNom, UNom)";
  parameter Types.PerUnit iqRef0Pu "Initial q-axis current reference in pu (base SNom, UNom)";
  parameter Types.ActivePowerPu PInj0Pu "Initial injected active power in pu (base SNom)";
  parameter Types.ReactivePowerPu QInj0Pu "Initial injected reactive power in pu (base SNom)";
  parameter Types.VoltageModulePu UFilter0Pu "Initial filter voltage magnitude in pu (base UNom)";
  parameter Real y_start_outer_d "Initial output of d-axis PI (pu)";
  parameter Real y_start_outer_q "Initial output of q-axis PI (pu)";

equation
  connect(PLVPu, sum_node_p.u2) annotation(
    Line(points = {{-220, 52}, {-88, 52}, {-88, 74}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_p.y, piAntiwind.u) annotation(
    Line(points = {{-79, 82}, {-50, 82}}, color = {46, 194, 126}, thickness = 0.75));
  connect(QLVPu, sum_node_q.u2) annotation(
    Line(points = {{-220, -20}, {-74, -20}, {-74, 10}, {-72, 10}, {-72, 12}, {-74, 12}}, color = {46, 194, 126}, thickness = 0.75));
  connect(sum_node_q.y, piAntiwind1.u) annotation(
    Line(points = {{-65, 20}, {-46, 20}}, color = {46, 194, 126}, thickness = 0.75));
  connect(division1.u2, ULVPu) annotation(
    Line(points = {{-78, 36}, {-190, 36}, {-190, -60}, {-220, -60}}, color = {230, 97, 0}, thickness = 0.75));
  connect(division.u2, ULVPu) annotation(
    Line(points = {{-62, -42}, {-172, -42}, {-172, -60}, {-220, -60}}, color = {230, 97, 0}, thickness = 0.75));
  connect(booleanConstant.y, switch1.u2) annotation(
    Line(points = {{22, 74}, {13, 74}, {13, 70}}, color = {255, 0, 255}));
  connect(division1.y, switch1.u1) annotation(
    Line(points = {{-55, 42}, {22, 42}, {22, 82}}, color = {230, 97, 0}, thickness = 0.75));
  connect(piAntiwind.y, switch1.u3) annotation(
    Line(points = {{-6, 82}, {22, 82}, {22, 66}}, color = {46, 194, 126}, thickness = 0.75));
  connect(booleanConstant1.y, switch2.u2) annotation(
    Line(points = {{18.5, 11}, {10, 11}, {10, 18}, {34, 18}}, color = {255, 0, 255}));
  connect(division.y, switch2.u1) annotation(
    Line(points = {{-38, -36}, {28, -36}, {28, 26}, {34, 26}}, color = {230, 97, 0}, thickness = 0.75));
  connect(piAntiwind1.y, switch2.u3) annotation(
    Line(points = {{-2, 20}, {-2, 22}, {34, 22}, {34, 10}}, color = {46, 194, 126}, thickness = 0.75));
  connect(switch1.y, current_limiter_outer_loop.idRawPu) annotation(
    Line(points = {{46, 74}, {46, 62}, {86, 62}}, color = {0, 0, 127}));
  connect(switch2.y, current_limiter_outer_loop.iqRawPu) annotation(
    Line(points = {{57, 18}, {69, 18}, {69, 44}, {86, 44}}, color = {0, 0, 127}));
  connect(ULVPu, current_limiter_outer_loop.ULVPu) annotation(
    Line(points = {{-220, -60}, {86, -60}, {86, 27.5}}, color = {0, 0, 127}));
  connect(current_limiter_outer_loop.idLimPu, rampLimiter.u) annotation(
    Line(points = {{172, 62}, {180, 62}}, color = {0, 0, 127}));
  connect(rampLimiter.y, idRefPu) annotation(
    Line(points = {{203, 62}, {224, 62}}, color = {0, 0, 127}));
  connect(iqRefPu, current_limiter_outer_loop.iqLimPu) annotation(
    Line(points = {{210, 32}, {172, 31}}, color = {0, 0, 127}));
  connect(PRefPu, firstOrder.u) annotation(
    Line(points = {{-220, 82}, {-182, 82}, {-182, 80}}, color = {0, 0, 127}));
  connect(firstOrder.y, sum_node_p.u1) annotation(
    Line(points = {{-158, 80}, {-96, 80}, {-96, 82}}, color = {0, 0, 127}));
  connect(division1.u1, firstOrder.y) annotation(
    Line(points = {{-78, 48}, {-158, 48}, {-158, 80}}, color = {0, 0, 127}));
  connect(QRefPu, firstOrder1.u) annotation(
    Line(points = {{-220, 18}, {-164, 18}, {-164, 20}, {-160, 20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, sum_node_q.u1) annotation(
    Line(points = {{-136, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(division.u1, firstOrder1.y) annotation(
    Line(points = {{-62, -30}, {-136, -30}, {-136, 20}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3")),
    Icon(coordinateSystem(extent = {{-200, -200}, {200, 200}}), graphics = {Rectangle(extent = {{-200, 200}, {200, -200}}), Text(origin = {0, 70}, extent = {{-80, 20}, {80, -20}}, textString = "Outer Loop"), Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}}, textString = "P/Q/V control"), Text(origin = {0, -50}, extent = {{-80, 15}, {80, -15}}, textString = "PI / Direct switchable")}),
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}}), graphics = {Text(origin = {-5, -118}, extent = {{-147, 38}, {147, -38}}, textString = "Author: Gaia Bergamaschi
Model of the outer loop of a GFL converter.
Green path (default): PI regulators for P and Q.
Orange path: direct control via PRefPu/V and QRefPu/V.
k_direct_control_p/q = false → PI (default)
k_direct_control_p/q = true  → direct (bypass PI)")}),
    Documentation(info = "<html><head></head><body><p><b>Author:</b> Gaia Bergamaschi</p>
      <p>Outer loop controller for a Grid-Following (GFL) converter.</p>
      <ul>
        <li><b>Green path (default):</b> anti-windup PI regulators for P and Q.</li>
        <li><b>Orange path:</b> stateless direct control — i_d = PRefPu/V, i_q = QRefPu/V.</li>
      </ul>
      <p>Set <code>k_direct_control_p = true</code> and/or <code>k_direct_control_q = true</code>
      to bypass the PI on the corresponding axis. Useful when PI parameters are
      unknown or cause low-frequency oscillations (SSO).</p><p><span style=\"color: rgb(0, 150, 0); font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">Two control modes are available, selectable independently for P and Q:</span></p><p><span style=\"color: rgb(0, 150, 0); font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">&nbsp; &nbsp;- PI mode (default, green):    error signal → PI regulator → current ref</span></p><p><span style=\"color: rgb(0, 150, 0); font-family: 'DejaVu Sans Mono'; font-size: 11pt;\">&nbsp; &nbsp;- Direct mode (orange):        PRefPu/V or QRefPu/V → current ref directly</span></p><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"color: rgb(0, 150, 0); font-family: 'DejaVu Sans Mono'; font-size: 11pt;\"> Use direct mode if the PI parameters are unknown or cause instability.</span></pre><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"> k_direct_control_p = false  →  bypass P PI, use idRefPu = PRefPu / ULVPu</span></pre><p>





</p><pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\" font-family:'DejaVu Sans Mono'; font-size:11pt; color:#009600;\"> k_direct_control_q = false  →  bypass Q PI, use iqRefPu = QRefPu / ULVPu</span><!--EndFragment--></pre><p><br></p><p><br></p><p><br></p><p><br></p>
    </body></html>"));
end OuterLoop;
