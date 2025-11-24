within Dynawo.Electrical.PEIR.Plant.Simplified.BaseControls;

model PlantControllerPI "Simplified plant model with PI controller"
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
  parameter Types.ReactivePower QMaxRegPu "Maximum reactive power at regulated bus in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum plant level reactive power command in pu (base SNom)";
  parameter Types.ReactivePower QMinRegPu "Minimum reactive power at regulated bus in pu (base SNom)";
  parameter Boolean VRegFlag "If false, constant injection, if true, U+lambdaQ regulation";

  final parameter Types.PerUnit AlphaPu = AlphaPuPNom*PNom/SNom "Frequency sensitivity in pu (base SN-+
  om, OmegaNom)";
  final parameter Types.PerUnit LambdaPu = LambdaPuSNom*SystemBase.SnRef/SNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SnRef)";
  final parameter Types.ActivePowerPu PMinPu = PMin/SNom "Minimum active power in pu (base SNom)";
  final parameter Types.ActivePowerPu PMaxPu = PMax/SNom "Maximum active power in pu (base SNom)";

  // Input variables
  Modelica.Blocks.Interfaces.RealInput deltaPmRefPu(start = 0) "Additional active power reference in pu (base PNom)" annotation(
    Placement(transformation(origin = {-190, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Network angular reference frequency in pu (base OmegaNom)" annotation(
    Placement(transformation(origin = {-190, -60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QReg0Pu) "Reactive power at regulated bus in pu (base SnRef) (receptor convention)" annotation(
    Placement(transformation(origin = {-50, 150}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {1, 109}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URegPu(start = UReg0Pu) "Voltage amplitude at regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage regulation set point in pu (base UNom)" annotation(
    Placement(transformation(origin = {-190, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput PInjPu(start = PInj0Pu) "Active power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {170, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput QInjPu(start = QInj0Pu) "Reactive power at injector terminal in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {170, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Math.Add UCtrlErr(k2 = -1) annotation(
    Placement(transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add QVCtrlErr(k1 = -1) annotation(
    Placement(transformation(origin = {-30, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = 1/LambdaPuSNom) annotation(
    Placement(transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter QVErrLim(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = EMaxPu, uMin = EMinPu) annotation(
    Placement(transformation(origin = {50, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter reactiveLimits(uMax = QMaxRegPu, uMin = QMinRegPu, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const(k = PInj0Pu) annotation(
    Placement(transformation(origin = {-10, -100}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add3 add3 annotation(
    Placement(transformation(origin = {50, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain1(k = PNom/SNom) annotation(
    Placement(transformation(origin = {-132, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain2(k = AlphaPu) annotation(
    Placement(transformation(origin = {-10, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant omega0Pu(k = SystemBase.omega0Pu) annotation(
    Placement(transformation(origin = {-90, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(transformation(origin = {-50, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = PMaxPu, uMin = PMinPu, homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy) annotation(
    Placement(transformation(origin = {90, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain baseQReg(k = -SystemBase.SnRef/SNom)  annotation(
    Placement(transformation(origin = {-50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.NonElectrical.Blocks.Continuous.LimitedPI limitedPI(Ki = Ki, Kp = Kp, YMax = QMaxPu, YMin = QMinPu, Y0 = QInj0Pu, Tol = 1e-4)  annotation(
    Placement(transformation(origin = {90, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = DbdPu)  annotation(
    Placement(transformation(origin = {10, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(transformation(origin = {130, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.Constant const2(k = QInj0Pu)  annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant VFlag(k = VRegFlag) annotation(
    Placement(transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QReg0Pu "Start value of reactive power at regulated bus in pu (receptor convention) (base SnRef)";
  parameter Types.PerUnit UReg0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";

  final parameter Types.PerUnit URef0Pu = UReg0Pu - LambdaPuSNom*QReg0Pu*SystemBase.SnRef/SNom "Start value of voltage setpoint for plant level control in pu (base UNom)";

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

  connect(URefPu, UCtrlErr.u1) annotation(
    Line(points = {{-190, 100}, {-172, 100}, {-172, 86}, {-162, 86}}, color = {0, 0, 127}));
  connect(URegPu, UCtrlErr.u2) annotation(
    Line(points = {{-190, 60}, {-168, 60}, {-168, 74}, {-162, 74}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, gain.u) annotation(
    Line(points = {{-139, 80}, {-123, 80}}, color = {0, 0, 127}));
  connect(const.y, add3.u3) annotation(
    Line(points = {{1, -100}, {23, -100}, {23, -88}, {38, -88}}, color = {0, 0, 127}));
  connect(deltaPmRefPu, gain1.u) annotation(
    Line(points = {{-190, -80}, {-144, -80}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u2) annotation(
    Line(points = {{-121, -80}, {38, -80}}, color = {0, 0, 127}));
  connect(gain2.y, add3.u1) annotation(
    Line(points = {{1, -40}, {20, -40}, {20, -72}, {38, -72}}, color = {0, 0, 127}));
  connect(omega0Pu.y, feedback.u1) annotation(
    Line(points = {{-79, -40}, {-58, -40}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback.u2) annotation(
    Line(points = {{-190, -60}, {-50, -60}, {-50, -48}}, color = {0, 0, 127}));
  connect(feedback.y, gain2.u) annotation(
    Line(points = {{-41, -40}, {-22, -40}}, color = {0, 0, 127}));
  connect(add3.y, limiter.u) annotation(
    Line(points = {{61, -80}, {78, -80}}, color = {0, 0, 127}));
  connect(reactiveLimits.y, QVCtrlErr.u2) annotation(
    Line(points = {{-59, 80}, {-50.5, 80}, {-50.5, 74}, {-42, 74}}, color = {0, 0, 127}));
  connect(limiter.y, PInjPu) annotation(
    Line(points = {{101, -80}, {170, -80}}, color = {0, 0, 127}));
  connect(gain.y, reactiveLimits.u) annotation(
    Line(points = {{-99, 80}, {-83, 80}}, color = {0, 0, 127}));
  connect(QRegPu, baseQReg.u) annotation(
    Line(points = {{-50, 150}, {-50, 122}}, color = {0, 0, 127}));
  connect(baseQReg.y, QVCtrlErr.u1) annotation(
    Line(points = {{-50, 99}, {-50, 85.5}, {-42, 85.5}, {-42, 86}}, color = {0, 0, 127}));
  connect(QVCtrlErr.y, deadZone.u) annotation(
    Line(points = {{-19, 80}, {-2, 80}}, color = {0, 0, 127}));
  connect(deadZone.y, QVErrLim.u) annotation(
    Line(points = {{21, 80}, {38, 80}}, color = {0, 0, 127}));
  connect(const2.y, switch1.u3) annotation(
    Line(points = {{82, 0}, {108, 0}, {108, 32}, {118, 32}}, color = {0, 0, 127}));
  connect(switch1.y, QInjPu) annotation(
    Line(points = {{141, 40}, {170, 40}}, color = {0, 0, 127}));
  connect(VFlag.y, switch1.u2) annotation(
    Line(points = {{82, 40}, {118, 40}}, color = {255, 0, 255}));
  connect(QVErrLim.y, limitedPI.u) annotation(
    Line(points = {{62, 80}, {78, 80}}, color = {0, 0, 127}));
  connect(limitedPI.y, switch1.u1) annotation(
    Line(points = {{102, 80}, {110, 80}, {110, 48}, {118, 48}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-180, -140}, {160, 140}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "PI Plant Controller")}),
  Documentation(info = "<html><head></head><body>Simplified plant model for active and reactive control :<div><br></div><div>Active power is frequency dependent if AlphaPu &gt;0.</div><div><br></div><div>Reactive power :&nbsp;</div><div>- if VRegFlag is true : URefPu = URegPu - LambdaPu * QRegPu (QReg is in receptor convention). QInjPu is controlled with a PI controller.</div><div>- if VRegFlag is false : QInjPu = QInj0Pu (constant).</div><div><br></div></body></html>"));
end PlantControllerPI;
