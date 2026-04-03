within Dynawo.Electrical.PEIR.Plants.Average;

model Plant_controller
"Simplified Plant Controller - no internal filters, u+lambdaQ, P with frequency droop, deadbands"

  // ── Parameters ───────────────────────────────────────────────
  parameter Real Kp_q    "PI proportional gain - voltage/Q loop";
  parameter Real Ki_q    "PI integral gain - voltage/Q loop";
  parameter Real Kp_p    "PI proportional gain - active power loop";
  parameter Real Ki_p    "PI integral gain - active power loop";
  parameter Real Lambda  "Voltage droop gain in u + lambdaQ control";
  parameter Real Kdroop  "Frequency droop gain on active power (pu/pu)";
  parameter Real QMaxPu  "Maximum reactive power reference (pu)";
  parameter Real QMinPu  "Minimum reactive power reference (pu)";
  parameter Real PMaxPu  "Maximum active power reference (pu)";
  parameter Real PMinPu  "Minimum active power reference (pu)";
  parameter Real FEMaxPu "Maximum frequency error after droop limiter (pu)";
  parameter Real FEMinPu "Minimum frequency error after droop limiter (pu)";
  parameter Real FDbd1Pu "Frequency deadband lower threshold (pu, positive value)";
  parameter Real FDbd2Pu "Frequency deadband upper threshold (pu, positive value)";
  parameter Real DbdPu   "Voltage error deadband half-width (pu)";

  // ── Start values ─────────────────────────────────────────────
  parameter Real U0Pu     "Initial PCC voltage magnitude (pu)";
  parameter Real Q0Pu     "Initial reactive power (pu)";
  parameter Real P0Pu     "Initial active power (pu)";
  parameter Real Omega0Pu = 1.0 "Initial frequency (pu) - nominal";

  // URef0: error = URef - (U + lambda*Q) = 0 at t=0
  final parameter Real URef0Pu = U0Pu + Lambda * Q0Pu;
  // PRef0: frequency error = 0 at t=0 => PRef0 = P0
  final parameter Real PRef0Pu = P0Pu;

  // ── Inputs ───────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu)
    "Voltage setpoint (pu)" annotation(
    Placement(transformation(origin = {-140, 80}, extent = {{-10, -10}, {10, 10}})),
    iconTransformation(origin = {-100, 80}, extent = {{-10, -10}, {10, 10}}));

  Modelica.Blocks.Interfaces.RealInput UfiltPu(start = U0Pu)
    "Filtered PCC voltage magnitude (pu)" annotation(
    Placement(transformation(origin = {-140, 55}, extent = {{-10, -10}, {10, 10}})),
    iconTransformation(origin = {-100, 55}, extent = {{-10, -10}, {10, 10}}));

  Modelica.Blocks.Interfaces.RealInput QfiltPu(start = Q0Pu)
    "Filtered reactive power (pu)" annotation(
    Placement(transformation(origin = {-140, 30}, extent = {{-10, -10}, {10, 10}})),
    iconTransformation(origin = {-100, 30}, extent = {{-10, -10}, {10, 10}}));

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu)
    "Active power setpoint - constant (pu)" annotation(
    Placement(transformation(origin = {-140, 0}, extent = {{-10, -10}, {10, 10}})),
    iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}));

  Modelica.Blocks.Interfaces.RealInput PfiltPu(start = P0Pu)
    "Filtered active power (pu)" annotation(
    Placement(transformation(origin = {-140, -30}, extent = {{-10, -10}, {10, 10}})),
    iconTransformation(origin = {-100, -30}, extent = {{-10, -10}, {10, 10}}));

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu)
    "Frequency setpoint - external input (pu)" annotation(
    Placement(transformation(origin = {-140, -65}, extent = {{-10, -10}, {10, 10}})),
    iconTransformation(origin = {-100, -65}, extent = {{-10, -10}, {10, 10}}));

  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = Omega0Pu)
    "Measured frequency from PLL (pu)" annotation(
    Placement(transformation(origin = {-140, -85}, extent = {{-10, -10}, {10, 10}})),
    iconTransformation(origin = {-100, -85}, extent = {{-10, -10}, {10, 10}}));

  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = Q0Pu)
    "Reactive power reference to outer loop (pu)" annotation(
    Placement(transformation(origin = {140, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {126, -50}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = P0Pu)
    "Active power reference to outer loop (pu)" annotation(
    Placement(transformation(origin = {140, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {124, 70}, extent = {{-10, -10}, {10, 10}})));

  // ── Internal blocks ──────────────────────────────────────────

  // --- Reactive / voltage path ---------------------------------

  // lambda * Q_filt
  Modelica.Blocks.Math.Gain lambdaGain(k = Lambda) annotation(
    Placement(transformation(origin = {-72, 20}, extent = {{-10, -10}, {10, 10}})));

  // U + lambda*Q
  Modelica.Blocks.Math.Add uLambdaQ(k1 = +1, k2 = +1) annotation(
    Placement(transformation(origin = {-30, 38}, extent = {{-10, -10}, {10, 10}})));

  // URef - (U + lambda*Q)
  Modelica.Blocks.Math.Add voltageErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}})));

  // Deadband on voltage error
  Modelica.Blocks.Nonlinear.DeadZone voltDeadband(
    uMax =  DbdPu,
    uMin = -DbdPu) annotation(
    Placement(transformation(origin = {35, 60}, extent = {{-10, -10}, {10, 10}})));

  // Q PI controller
  Modelica.Blocks.Continuous.LimPID piQ(
    controllerType = Modelica.Blocks.Types.SimpleController.PI,
    k        = Kp_q,
    Ti       = Kp_q / Ki_q,
    yMax     = QMaxPu,
    yMin     = QMinPu,
    xi_start = Q0Pu / Kp_q,
    y_start  = Q0Pu,
    initType = Modelica.Blocks.Types.InitPID.InitialOutput) annotation(
    Placement(transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant zeroQ(k = 0) annotation(
    Placement(transformation(origin = {40, 30}, extent = {{-10, -10}, {10, 10}})));

  // --- Active power path with frequency droop ------------------

  // omega_ref - omega_PLL
  Modelica.Blocks.Math.Add freqErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {-80, -75}, extent = {{-10, -10}, {10, 10}})));

  // Deadband on frequency error
  Modelica.Blocks.Nonlinear.DeadZone freqDeadband(
    uMax =  FDbd2Pu,
    uMin = -FDbd1Pu) annotation(
    Placement(transformation(origin = {-55, -75}, extent = {{-10, -10}, {10, 10}})));

  // Frequency droop: Kdroop * delta_omega
  Modelica.Blocks.Math.Gain droopGain(k = Kdroop) annotation(
    Placement(transformation(origin = {-28, -75}, extent = {{-10, -10}, {10, 10}})));

  // Limiter on frequency droop output
  Modelica.Blocks.Nonlinear.Limiter freqErrLim(
    uMax = FEMaxPu,
    uMin = FEMinPu) annotation(
    Placement(transformation(origin = {0, -75}, extent = {{-10, -10}, {10, 10}})));

  // PRef_eff = PRef + Kdroop*(omega_ref - omega_PLL)
  Modelica.Blocks.Math.Add PRefEff(k1 = +1, k2 = +1) annotation(
    Placement(transformation(origin = {-10, -45}, extent = {{-10, -10}, {10, 10}})));

  // PRef_eff - P_filt
  Modelica.Blocks.Math.Add activePowerErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {30, -35}, extent = {{-10, -10}, {10, 10}})));

  // P PI controller
  Modelica.Blocks.Continuous.LimPID piP(
    controllerType = Modelica.Blocks.Types.SimpleController.PI,
    k        = Kp_p,
    Ti       = Kp_p / Ki_p,
    yMax     = PMaxPu,
    yMin     = PMinPu,
    xi_start = P0Pu / Kp_p,
    y_start  = P0Pu,
    initType = Modelica.Blocks.Types.InitPID.InitialOutput) annotation(
    Placement(transformation(origin = {70, -45}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant zeroP(k = 0) annotation(
    Placement(transformation(origin = {40, -70}, extent = {{-10, -10}, {10, 10}})));

equation
  // ── Reactive / voltage path ──────────────────────────────────
  connect(QfiltPu, lambdaGain.u) annotation(
    Line(points = {{-140, 30}, {-90, 30}, {-90, 20}, {-84, 20}}, color = {0, 0, 127}));
  connect(UfiltPu, uLambdaQ.u1) annotation(
    Line(points = {{-140, 55}, {-60, 55}, {-60, 44}, {-40, 44}}, color = {0, 0, 127}));
  connect(lambdaGain.y, uLambdaQ.u2) annotation(
    Line(points = {{-61, 20}, {-50, 20}, {-50, 32}, {-40, 32}}, color = {0, 0, 127}));
  connect(URefPu, voltageErr.u1) annotation(
    Line(points = {{-140, 80}, {-10, 80}, {-10, 66}, {0, 66}}, color = {0, 0, 127}));
  connect(uLambdaQ.y, voltageErr.u2) annotation(
    Line(points = {{-20, 38}, {-10, 38}, {-10, 54}, {0, 54}}, color = {0, 0, 127}));
  connect(voltageErr.y, voltDeadband.u) annotation(
    Line(points = {{20, 60}, {25, 60}}, color = {0, 0, 127}));
  connect(voltDeadband.y, piQ.u_s) annotation(
    Line(points = {{45, 60}, {56, 60}, {56, 50}}, color = {0, 0, 127}));
  connect(zeroQ.y, piQ.u_m) annotation(
    Line(points = {{50, 30}, {62, 30}, {62, 42}}, color = {0, 0, 127}));
  connect(piQ.y, QInjRefPu) annotation(
    Line(points = {{80, 50}, {120, 50}, {120, 40}, {140, 40}}, color = {0, 0, 127}));

  // ── Active power path ────────────────────────────────────────
  connect(omegaRefPu, freqErr.u1) annotation(
    Line(points = {{-140, -65}, {-110, -65}, {-110, -69}, {-90, -69}}, color = {0, 0, 127}));
  connect(omegaPLLPu, freqErr.u2) annotation(
    Line(points = {{-140, -85}, {-110, -85}, {-110, -81}, {-90, -81}}, color = {0, 0, 127}));
  connect(freqErr.y, freqDeadband.u) annotation(
    Line(points = {{-69, -75}, {-66, -75}}, color = {0, 0, 127}));
  connect(freqDeadband.y, droopGain.u) annotation(
    Line(points = {{-44, -75}, {-40, -75}}, color = {0, 0, 127}));
  connect(droopGain.y, freqErrLim.u) annotation(
    Line(points = {{-17, -75}, {-12, -75}}, color = {0, 0, 127}));
  connect(PRefPu, PRefEff.u1) annotation(
    Line(points = {{-140, 0}, {-30, 0}, {-30, -39}, {-20, -39}}, color = {0, 0, 127}));
  connect(freqErrLim.y, PRefEff.u2) annotation(
    Line(points = {{10, -75}, {20, -75}, {20, -65}, {-20, -65}, {-20, -51}}, color = {0, 0, 127}));
  connect(PRefEff.y, activePowerErr.u1) annotation(
    Line(points = {{0, -45}, {10, -45}, {10, -29}, {20, -29}}, color = {0, 0, 127}));
  connect(PfiltPu, activePowerErr.u2) annotation(
    Line(points = {{-140, -30}, {0, -30}, {0, -41}, {20, -41}}, color = {0, 0, 127}));
  connect(activePowerErr.y, piP.u_s) annotation(
    Line(points = {{40, -35}, {56, -35}, {56, -45}}, color = {0, 0, 127}));
  connect(zeroP.y, piP.u_m) annotation(
    Line(points = {{50, -70}, {62, -70}, {62, -53}}, color = {0, 0, 127}));
  connect(piP.y, PInjRefPu) annotation(
    Line(points = {{80, -45}, {120, -45}, {120, -40}, {140, -40}}, color = {0, 0, 127}));

  annotation(
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}}),
      Text(origin = {0, 40}, extent = {{-80, 20}, {80, -20}},
           textString = "Plant Controller"),
      Text(origin = {0, 10}, extent = {{-80, 15}, {80, -15}},
           textString = "u + lambda·Q"),
      Text(origin = {0, -15}, extent = {{-80, 15}, {80, -15}},
           textString = "P + freq droop"),
      Text(origin = {0, -40}, extent = {{-80, 15}, {80, -15}},
           textString = "deadbands")},
      coordinateSystem(initialScale = 0.1)),
    Diagram(coordinateSystem(extent = {{-150, -110}, {150, 110}})));


end Plant_controller;