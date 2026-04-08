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
  parameter Real Q0Pu     "Initial reactive power (pu)  in receptor convection";
  parameter Real P0Pu     "Initial active power (pu)  in receptor convection";
  parameter Real Omega0Pu  "Initial frequency (pu) - nominal";
  parameter Real QInj0Pu  "Intial reactive power in pu in gnerator convenction";
  parameter Real PInj0Pu "Intial reactive power in pu in gnerator convenction";

  // URef0: error = URef - (U + lambda*Q) = 0 at t=0
  final parameter Real URef0Pu = U0Pu - Lambda * Q0Pu;
  // PRef0: frequency error = 0 at t=0 => PRef0 = P0
  final parameter Real PRef0Pu = -P0Pu;

  // ── Inputs ───────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu)
    "Voltage setpoint (pu)" annotation(
    Placement(transformation(origin = {-160, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-60, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealInput UfiltPu(start = U0Pu)
    "Filtered PCC voltage magnitude (pu)" annotation(
    Placement(transformation(origin = {-160, 61}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-6, 111}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealInput QfiltPu(start = -Q0Pu)
    "Filtered reactive power (pu)" annotation(
    Placement(transformation(origin = {-160, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {40, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu)
    "Active power setpoint - constant (pu)" annotation(
    Placement(transformation(origin = {-160, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-112, 52}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput PfiltPu(start = -P0Pu)
    "Filtered active power (pu)" annotation(
    Placement(transformation(origin = {-156, -100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -8}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = Omega0Pu)
    "Frequency setpoint - external input (pu)" annotation(
    Placement(transformation(origin = {-162, -47}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -67}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = Omega0Pu)
    "Measured frequency from PLL (pu)" annotation(
    Placement(transformation(origin = {-160, -61}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // ── Outputs ──────────────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInj0Pu) 
    "Reactive power reference to outer loop (pu)" annotation(
    Placement(transformation(origin = {166, 70}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, -50}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = PInj0Pu)
    "Active power reference to outer loop (pu)" annotation(
    Placement(transformation(origin = {174, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {116, 38}, extent = {{-10, -10}, {10, 10}})));

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
    xi_start = QInj0Pu / Kp_q,
    y_start  = QInj0Pu,
    initType = Modelica.Blocks.Types.InitPID.InitialState) annotation(
    Placement(transformation(origin = {72, 70}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant zeroQ(k = 0) annotation(
    Placement(transformation(origin = {72, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // --- Active power path with frequency droop ------------------

  // omega_ref - omega_PLL
  Modelica.Blocks.Math.Add freqErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {-126, -53}, extent = {{-10, -10}, {10, 10}})));

  // Deadband on frequency error
  Modelica.Blocks.Nonlinear.DeadZone freqDeadband(
    uMax =  FDbd2Pu,
    uMin = -FDbd1Pu) annotation(
    Placement(transformation(origin = {-95, -53}, extent = {{-10, -10}, {10, 10}})));

  // Frequency droop: Kdroop * delta_omega
  Modelica.Blocks.Math.Gain droopGain(k = Kdroop) annotation(
    Placement(transformation(origin = {-69, -52}, extent = {{-5, -5}, {5, 5}})));

  // Limiter on frequency droop output
  Modelica.Blocks.Nonlinear.Limiter freqErrLim(
    uMax = FEMaxPu,
    uMin = FEMinPu) annotation(
    Placement(transformation(origin = {-38, -49}, extent = {{-10, -10}, {10, 10}})));

  // PRef_eff = PRef + Kdroop*(omega_ref - omega_PLL)
  Modelica.Blocks.Math.Add PRefEff(k1 = +1, k2 = +1) annotation(
    Placement(transformation(origin = {-8, -21}, extent = {{-10, -10}, {10, 10}})));

  // PRef_eff - P_filt
  Modelica.Blocks.Math.Add activePowerErr(k1 = +1, k2 = -1) annotation(
    Placement(transformation(origin = {28, -39}, extent = {{-10, -10}, {10, 10}})));

  // P PI controller
  Modelica.Blocks.Continuous.LimPID piP(
    controllerType = Modelica.Blocks.Types.SimpleController.PI,
    k        = Kp_p,
    Ti       = Kp_p / Ki_p,
    yMax     = PMaxPu,
    yMin     = PMinPu,
    xi_start = PInj0Pu / Kp_p,
    y_start  = PInj0Pu,
    initType = Modelica.Blocks.Types.InitPID.InitialState) annotation(
    Placement(transformation(origin = {94, -39}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant zeroP(k = 0) annotation(
    Placement(transformation(origin = {94, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

equation
  // ── Reactive / voltage path ──────────────────────────────────
  connect(QfiltPu, lambdaGain.u) annotation(
    Line(points = {{-160, 40}, {-90, 40}, {-90, 20}, {-84, 20}}, color = {0, 0, 127}));
  connect(UfiltPu, uLambdaQ.u1) annotation(
    Line(points = {{-160, 61}, {-60, 61}, {-60, 44}, {-40, 44}}, color = {0, 0, 127}));
  connect(lambdaGain.y, uLambdaQ.u2) annotation(
    Line(points = {{-61, 20}, {-50, 20}, {-50, 32}, {-40, 32}}, color = {0, 0, 127}));
  connect(URefPu, voltageErr.u1) annotation(
    Line(points = {{-160, 80}, {-10, 80}, {-10, 66}, {0, 66}}, color = {0, 0, 127}));
  connect(uLambdaQ.y, voltageErr.u2) annotation(
    Line(points = {{-20, 38}, {-10, 38}, {-10, 54}, {0, 54}}, color = {0, 0, 127}));
  connect(voltageErr.y, voltDeadband.u) annotation(
    Line(points = {{20, 60}, {25, 60}}, color = {0, 0, 127}));
  connect(voltDeadband.y, piQ.u_s) annotation(
    Line(points = {{45, 60}, {52.5, 60}, {52.5, 70}, {60, 70}}, color = {0, 0, 127}));
  connect(zeroQ.y, piQ.u_m) annotation(
    Line(points = {{72, 43}, {72, 58}}, color = {0, 0, 127}));
  connect(piQ.y, QInjRefPu) annotation(
    Line(points = {{83, 70}, {166, 70}}, color = {0, 0, 127}));

  // ── Active power path ────────────────────────────────────────
  connect(omegaRefPu, freqErr.u1) annotation(
    Line(points = {{-162, -47}, {-138, -47}}, color = {0, 0, 127}));
  connect(omegaPLLPu, freqErr.u2) annotation(
    Line(points = {{-160, -61}, {-149, -61}, {-149, -59}, {-138, -59}}, color = {0, 0, 127}));
  connect(freqErr.y, freqDeadband.u) annotation(
    Line(points = {{-115, -53}, {-107, -53}}, color = {0, 0, 127}));
  connect(freqDeadband.y, droopGain.u) annotation(
    Line(points = {{-84, -53}, {-84, -52}, {-75, -52}}, color = {0, 0, 127}));
  connect(droopGain.y, freqErrLim.u) annotation(
    Line(points = {{-63.5, -52}, {-62.5, -52}, {-62.5, -49}, {-50, -49}}, color = {0, 0, 127}));
  connect(PRefPu, PRefEff.u1) annotation(
    Line(points = {{-160, 0}, {-20, 0}, {-20, -15}}, color = {0, 0, 127}));
  connect(PRefEff.y, activePowerErr.u1) annotation(
    Line(points = {{3, -21}, {8.5, -21}, {8.5, -33}, {16, -33}}, color = {0, 0, 127}));
  connect(PfiltPu, activePowerErr.u2) annotation(
    Line(points = {{-156, -100}, {0, -100}, {0, -45}, {16, -45}}, color = {0, 0, 127}));

  connect(activePowerErr.y, piP.u_s) annotation(
    Line(points = {{39, -39}, {82, -39}}, color = {0, 0, 127}));
  connect(zeroP.y, piP.u_m) annotation(
    Line(points = {{94, -63}, {94, -51}}, color = {0, 0, 127}));
  connect(PRefEff.u2, freqErrLim.y) annotation(
    Line(points = {{-20, -27}, {-20, -49.5}, {-27, -49.5}, {-27, -49}}, color = {0, 0, 127}));
  connect(piP.y, PInjRefPu) annotation(
    Line(points = {{105, -39}, {105, -40}, {174, -40}}, color = {0, 0, 127}));
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