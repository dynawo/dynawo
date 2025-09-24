within Dynawo.Electrical.PEIR.Plant.Simplified;

model PlantControllerPI
  parameter Types.PerUnit DbdPu "Reactive power (RefFlag = 0) or voltage (RefFlag = 1) deadband in pu (base SNom or UNom) (typical: 0..0.1)";
  parameter Types.PerUnit EMaxPu "Maximum Volt/VAR error in pu (base UNom or SNom)";
  parameter Types.PerUnit EMinPu "Minimum Volt/VAR error in pu (base UNom or SNom)";
  parameter Types.PerUnit Kc "Reactive droop when VCompFlag = 0";
  parameter Types.PerUnit Ki "Volt/VAR regulator integral gain";
  parameter Types.PerUnit Kp "Volt/VAR regulator proportional gain" ;
  parameter Types.ReactivePowerPu QMaxPu "Maximum plant level reactive power command in pu (base SNom)";
  parameter Types.ReactivePowerPu QMinPu "Minimum plant level reactive power command in pu (base SNom)";
  parameter Types.Time tFilterPC "Voltage and reactive power filter time constant in s (typical: 0.01..0.02)";
  parameter Types.Time tFt "Plant controller Q output lead time constant in s";
  parameter Types.Time tFv "Plant controller Q output lag time constant in s (typical: 0.15..5)";
  // Input variables
  Modelica.Blocks.Interfaces.BooleanInput freeze(start = false) annotation(
    Placement(transformation(origin = {104, 100}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QGen0Pu) annotation(
    Placement(transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {31, 111}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = U0Pu) annotation(
    Placement(transformation(origin = {-190, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-190, 38}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) annotation(
    Placement(transformation(origin = {-60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInj0Pu) annotation(
    Placement(transformation(origin = {190, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Sources.Constant Zero1(k = 0) annotation(
    Placement(transformation(origin = {150, 90}, extent = {{10, -10}, {-10, 10}})));
  Modelica.Blocks.Math.Add UCtrlErr(k2 = -1) annotation(
    Placement(transformation(origin = {-8, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tFilterPC, y_start = U0Pu + Kc*QGen0Pu) annotation(
    Placement(transformation(origin = {-70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add QVCtrlErr annotation(
    Placement(transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain gain(k = Kc) annotation(
    Placement(transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.LimPIDFreeze limPIDFreeze(K = Kp, Ti = Kp/Ki, Xi0 = QInj0Pu/Kp, Y0 = QInj0Pu, YMax = QMaxPu, YMin = QMinPu) annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, 10}, {10, -10}})));
  Dynawo.NonElectrical.Blocks.Continuous.TransferFunction leadLag(a = {tFv, 1}, b = {tFt, 1}, x_start = {QInj0Pu}, y_start = QInj0Pu) annotation(
    Placement(transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(transformation(origin = {30, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter QVErrLim(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = EMaxPu, uMin = EMinPu) annotation(
    Placement(transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Types.PerUnit PGen0Pu "Start value of active power at regulated bus in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QGen0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SNom)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";

  final parameter Types.PerUnit URef0Pu = U0Pu + Kc * QGen0Pu "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  connect(gain.u, QRegPu) annotation(
    Line(points = {{-162, 0}, {-190, 0}}, color = {0, 0, 127}));
  connect(firstOrder3.y, UCtrlErr.u2) annotation(
    Line(points = {{-59, 20}, {-39.5, 20}, {-39.5, 34}, {-20, 34}}, color = {0, 0, 127}));
  connect(gain.y, QVCtrlErr.u2) annotation(
    Line(points = {{-139, 0}, {-132.75, 0}, {-132.75, 14}, {-122, 14}}, color = {0, 0, 127}));
  connect(limPIDFreeze.y, leadLag.u) annotation(
    Line(points = {{121, 40}, {138, 40}}, color = {0, 0, 127}));
  connect(leadLag.y, QInjRefPu) annotation(
    Line(points = {{161, 40}, {190, 40}}, color = {0, 0, 127}));
  connect(URefPu, UCtrlErr.u1) annotation(
    Line(points = {{-60, 70}, {-60, 46}, {-20, 46}}, color = {0, 0, 127}));
  connect(QVCtrlErr.y, firstOrder3.u) annotation(
    Line(points = {{-99, 20}, {-82, 20}}, color = {0, 0, 127}));
  connect(UPu, QVCtrlErr.u1) annotation(
    Line(points = {{-190, 40}, {-140, 40}, {-140, 26}, {-122, 26}}, color = {0, 0, 127}));
  connect(freeze, limPIDFreeze.freeze) annotation(
    Line(points = {{104, 100}, {104, 52}, {103, 52}}, color = {255, 0, 255}));
  connect(UCtrlErr.y, deadZone.u) annotation(
    Line(points = {{4, 40}, {18, 40}}, color = {0, 0, 127}));
  connect(deadZone.y, QVErrLim.u) annotation(
    Line(points = {{42, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(QVErrLim.y, limPIDFreeze.u_s) annotation(
    Line(points = {{82, 40}, {98, 40}}, color = {0, 0, 127}));
  connect(Zero1.y, limPIDFreeze.u_m) annotation(
    Line(points = {{140, 90}, {110, 90}, {110, 52}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-180, -100}, {180, 100}})));
end PlantControllerPI;
