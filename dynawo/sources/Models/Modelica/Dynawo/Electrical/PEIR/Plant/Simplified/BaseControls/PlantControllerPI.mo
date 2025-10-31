within Dynawo.Electrical.PEIR.Plant.Simplified.BaseControls;

model PlantControllerPI "Plant model with PI controller"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  type PStatus = enumeration(Standard "Active power is modulated by the frequency deviation", LimitPMin "Active power is fixed to its minimum value", LimitPMax "Active power is fixed to its maximum value");
  type QStatus = enumeration(Standard "Reactive power is fixed to its initial value", AbsorptionMax "Reactive power is fixed to its absorption limit", GenerationMax "Reactive power is fixed to its generation limit");

  // Nominal parameter
  parameter Types.ActivePower PNom "Nominal active power in MW";
  parameter Types.ApparentPowerModule SNom "Apparent nominal power in MVA";

  parameter Types.PerUnit AlphaPuPNom "Frequency sensitivity in pu (base PNom, OmegaNom)";
  parameter Types.PerUnit DbdPu "Reactive power (RefFlag = 0) or voltage (RefFlag = 1) deadband in pu (base SNom or UNom) (typical: 0..0.1)";
  parameter Types.PerUnit EMaxPu "Maximum Volt/VAR error in pu (base UNom or SNom)";
  parameter Types.PerUnit EMinPu "Minimum Volt/VAR error in pu (base UNom or SNom)";
  parameter Types.PerUnit Ki "Volt/VAR regulator integral gain";
  parameter Types.PerUnit Kp "Volt/VAR regulator proportional gain";
  parameter Types.PerUnit LambdaPuSNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SNom)";
  parameter Types.ActivePower PMax "Maximum active power in MW";
  parameter Types.ActivePower PMin "Minimum active power in MW";
  parameter Types.ReactivePowerPu QMaxPu "Maximum plant level reactive power command in pu (base SNom)";
  parameter Types.ReactivePower QMaxReg "Maximum reactive power at regulated bus in Mvar";
  parameter Types.ReactivePowerPu QMinPu "Minimum plant level reactive power command in pu (base SNom)";
  parameter Types.ReactivePower QMinReg "Minimum reactive power at regulated bus in Mvar";

  final parameter Types.PerUnit AlphaPu = AlphaPuPNom*PNom/SNom "Frequency sensitivity in pu (base SN-+
  om, OmegaNom)";
  final parameter Types.PerUnit LambdaPu = LambdaPuSNom*SystemBase.SnRef/SNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SnRef)";
  final parameter Types.ActivePowerPu PMinPu = PMin/SNom "Minimum active power in pu (base SNom)";
  final parameter Types.ActivePowerPu PMaxPu = PMax/SNom "Maximum active power in pu (base SNom)";
  final parameter Types.ReactivePowerPu QMaxRegPu = QMaxReg/SystemBase.SnRef "Maximum plant level reactive power in pu (base SnRef)";
  final parameter Types.ReactivePowerPu QMinRegPu = QMinReg/SystemBase.SnRef "Minimum plant level reactive power in pu (base SnRef)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput deltaPmRefPu(start = 0) "Additional active power reference in pu (base PNom)" annotation(
    Placement(transformation(origin = {-190, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanInput freeze(start = false) "Boolean to freeze the regulation" annotation(
    Placement(transformation(origin = {124, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Network angular reference frequency in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QReg0Pu) "Reactive power at regulated bus in pu (base SnRef) (generator convention)" annotation(
    Placement(transformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {1, 109}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URegPu(start = UReg0Pu) "Voltage amplitude at regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage regulation set point in pu (base UNom)" annotation(
    Placement(transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput PInjPu(start = PInj0Pu) "Active power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {170, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QInjPu(start = QInj0Pu) "Reactive power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant Zero1(k = 0) annotation(
    Placement(transformation(origin = {150, 90}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add UCtrlErr(k2 = -1) annotation(
    Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add QVCtrlErr(k1 = -1) annotation(
    Placement(transformation(origin = {-30, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 1/LambdaPu) annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze limPIDFreeze(K = Kp, Ti = Kp/Ki, Xi0 = QInj0Pu/Kp, Y0 = QInj0Pu, YMax = QMaxPu, YMin = QMinPu) annotation(
    Placement(transformation(origin = {130, 40}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter QVErrLim(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = EMaxPu, uMin = EMinPu) annotation(
    Placement(transformation(origin = {90, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter reactiveLimits(uMax = QMaxRegPu, uMin = QMinRegPu, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {-70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = PInj0Pu) annotation(
    Placement(transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(transformation(origin = {50, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain1(k = PNom/SNom) annotation(
    Placement(transformation(origin = {-132, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain2(k = AlphaPu) annotation(
    Placement(transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omega0Pu(k = SystemBase.omega0Pu) annotation(
    Placement(transformation(origin = {-90, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = PMaxPu, uMin = PMinPu) annotation(
    Placement(transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain baseQReg(k = SystemBase.SnRef/SNom) annotation(
    Placement(transformation(origin = {10, 40}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QReg0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SnRef)";
  parameter Types.PerUnit UReg0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";

  final parameter Types.PerUnit URef0Pu = UReg0Pu + LambdaPu*QReg0Pu "Start value of voltage setpoint for plant level control in pu (base UNom)";

protected
  PStatus pStatus(start = PStatus.Standard) "Status of the power / frequency regulation function";
  QStatus qStatus(start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation
  when reactiveLimits.y >= QMaxPu and pre(qStatus) <> QStatus.AbsorptionMax then
    qStatus = QStatus.AbsorptionMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMaxQ);
  elsewhen reactiveLimits.y <= QMinPu and pre(qStatus) <> QStatus.GenerationMax then
    qStatus = QStatus.GenerationMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMinQ);
  elsewhen (reactiveLimits.y < QMaxPu and pre(qStatus) == QStatus.AbsorptionMax) or (reactiveLimits.y > QMinPu and pre(qStatus) == QStatus.GenerationMax) then
    qStatus = QStatus.Standard;
    Timeline.logEvent1(TimelineKeys.GeneratorPVBackRegulation);
  end when;

  when limiter.u >= PMaxPu and pre(pStatus) <> PStatus.LimitPMax then
    pStatus = PStatus.LimitPMax;
    Timeline.logEvent1(TimelineKeys.ActivatePMAX);
  elsewhen limiter.u <= PMinPu and pre(pStatus) <> PStatus.LimitPMin then
    pStatus = PStatus.LimitPMin;
    Timeline.logEvent1(TimelineKeys.ActivatePMIN);
  elsewhen limiter.u > PMinPu and pre(pStatus) == PStatus.LimitPMin then
    pStatus = PStatus.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMIN);
  elsewhen limiter.u < PMaxPu and pre(pStatus) == PStatus.LimitPMax then
    pStatus = PStatus.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMAX);
  end when;

  connect(freeze, limPIDFreeze.freeze) annotation(
    Line(points = {{124, 110}, {124, 52}, {123, 52}}, color = {255, 0, 255}));
  connect(deadZone.y, QVErrLim.u) annotation(
    Line(points = {{61, 40}, {78, 40}}, color = {0, 0, 127}));
  connect(Zero1.y, limPIDFreeze.u_m) annotation(
    Line(points = {{139, 90}, {130, 90}, {130, 52}}, color = {0, 0, 127}));
  connect(URefPu, UCtrlErr.u1) annotation(
    Line(points = {{-190, 60}, {-172, 60}, {-172, 46}, {-162, 46}}, color = {0, 0, 127}));
  connect(URegPu, UCtrlErr.u2) annotation(
    Line(points = {{-190, 20}, {-168, 20}, {-168, 34}, {-162, 34}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, gain.u) annotation(
    Line(points = {{-139, 40}, {-123, 40}}, color = {0, 0, 127}));
  connect(gain.y, reactiveLimits.u) annotation(
    Line(points = {{-99, 40}, {-82, 40}}, color = {0, 0, 127}));
  connect(QVErrLim.y, limPIDFreeze.u_s) annotation(
    Line(points = {{101, 40}, {118, 40}}, color = {0, 0, 127}));
  connect(limPIDFreeze.y, QInjPu) annotation(
    Line(points = {{141, 40}, {170, 40}}, color = {0, 0, 127}));
  connect(const.y, add3.u3) annotation(
    Line(points = {{1, -60}, {23, -60}, {23, -48}, {38, -48}}, color = {0, 0, 127}));
  connect(deltaPmRefPu, gain1.u) annotation(
    Line(points = {{-190, -40}, {-144, -40}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u2) annotation(
    Line(points = {{-120, -40}, {38, -40}}, color = {0, 0, 127}));
  connect(gain2.y, add3.u1) annotation(
    Line(points = {{1, 0}, {20, 0}, {20, -32}, {38, -32}}, color = {0, 0, 127}));
  connect(omega0Pu.y, feedback.u1) annotation(
    Line(points = {{-78, 0}, {-58, 0}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback.u2) annotation(
    Line(points = {{-190, -20}, {-50, -20}, {-50, -8}}, color = {0, 0, 127}));
  connect(feedback.y, gain2.u) annotation(
    Line(points = {{-40, 0}, {-22, 0}}, color = {0, 0, 127}));
  connect(add3.y, limiter.u) annotation(
    Line(points = {{62, -40}, {78, -40}}, color = {0, 0, 127}));
  connect(QVCtrlErr.y, baseQReg.u) annotation(
    Line(points = {{-18, 40}, {-2, 40}}, color = {0, 0, 127}));
  connect(baseQReg.y, deadZone.u) annotation(
    Line(points = {{22, 40}, {38, 40}}, color = {0, 0, 127}));
  connect(reactiveLimits.y, QVCtrlErr.u2) annotation(
    Line(points = {{-58, 40}, {-52, 40}, {-52, 34}, {-42, 34}}, color = {0, 0, 127}));
  connect(limiter.y, PInjPu) annotation(
    Line(points = {{102, -40}, {170, -40}}, color = {0, 0, 127}));
  connect(QRegPu, QVCtrlErr.u1) annotation(
    Line(points = {{-50, 110}, {-50, 46}, {-42, 46}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-180, -100}, {160, 100}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "PI Plant Controller")}));
end PlantControllerPI;
