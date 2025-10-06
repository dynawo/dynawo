within Dynawo.Electrical.PEIR.Plant.Simplified.BaseControls;

model REPCa "WECC Plant Control type A"
  extends Electrical.Controls.WECC.Parameters.REPC.ParamsREPC;
  parameter Types.PerUnit RcPu "Line drop compensation resistance when VcompFlag = 1 in pu (base SnRef, UNom)";
  parameter Types.PerUnit XcPu "Line drop compensation reactance when VcompFlag = 1 in pu (base SnRef, UNom)";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PGen0Pu) "Active power setpoint at regulated bus in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-111, -19}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QRegPu(start = QGen0Pu) "Reactive power at regulated bus in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {-310, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {31, 111}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Voltage setpoint for plant level control in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-50, 160}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UPu annotation(
    Placement(transformation(origin = {-310, 80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-322, 96}, extent = {{-20, -20}, {20, 20}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PInjRefPu(start = PInj0Pu) "Active power setpoint at inverter terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjRefPu(start = QInj0Pu) "Reactive power setpoint at inverter terminal in pu (generator convention) (base SNom)" annotation(
    Placement(visible = true, transformation(origin = {210, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Nonlinear.Limiter QVErrLim(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = EMaxPu, uMin = EMinPu) annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Zero1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {150, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZone(uMax = DbdPu, uMin = -DbdPu) annotation(
    Placement(visible = true, transformation(origin = {50, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add UCtrlErr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-30, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tFilterPC, y_start = if VCompFlag == true then UInj0Pu else U0Pu + Kc*QGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant VCompFlag0(k = VCompFlag) annotation(
    Placement(transformation(origin = {96, 134}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add QVCtrlErr annotation(
    Placement(visible = true, transformation(origin = {-230, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {-270, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  NonElectrical.Blocks.Continuous.LimPIDFreeze limPIDFreeze(Ti = Kp/Ki, K = Kp, Xi0 = QInj0Pu/Kp, YMax = QMaxPu, YMin = QMinPu, Y0 = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 50}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  NonElectrical.Blocks.Continuous.TransferFunction leadLag(a = {tFv, 1}, b = {tFt, 1}, x_start = {QInj0Pu}, y_start = QInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {170, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit PGen0Pu "Start value of active power at regulated bus in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QGen0Pu "Start value of reactive power at regulated bus in pu (generator convention) (base SNom)";
  parameter Types.PerUnit U0Pu "Start value of voltage magnitude at regulated bus in pu (base UNom)";
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at regulated bus in pu (base UNom)";
  parameter Types.PerUnit UInj0Pu "Start value of voltage magnitude at injector terminal in pu (base UNom)";
  parameter Types.ComplexPerUnit iInj0Pu "Start value of complex current at regulated bus in pu (generator convention) (base SNom, UNom)";
  parameter Types.PerUnit PInj0Pu "Start value of active power at injector terminal in pu (generator convention) (base SNom)";
  parameter Types.PerUnit QInj0Pu "Start value of reactive power at injector terminal in pu (generator convention) (base SNom)";
  final parameter Types.PerUnit URef0Pu = if VCompFlag == true then UInj0Pu else U0Pu + Kc*QGen0Pu "Start value of voltage setpoint for plant level control, calculated depending on VcompFlag, in pu (base UNom)";

equation
  connect(gain.u, QRegPu) annotation(
    Line(points = {{-282, 50}, {-310, 50}}, color = {0, 0, 127}));
  connect(deadZone.y, QVErrLim.u) annotation(
    Line(points = {{61, 50}, {78, 50}}, color = {0, 0, 127}));
  connect(firstOrder3.y, UCtrlErr.u2) annotation(
    Line(points = {{-59, 80}, {-42, 80}}, color = {0, 0, 127}));
  connect(gain.y, QVCtrlErr.u2) annotation(
    Line(points = {{-259, 50}, {-242, 50}}, color = {0, 0, 127}));
  connect(QVErrLim.y, limPIDFreeze.u_s) annotation(
    Line(points = {{101, 50}, {118, 50}}, color = {0, 0, 127}));
  connect(Zero1.y, limPIDFreeze.u_m) annotation(
    Line(points = {{139, 90}, {130, 90}, {130, 62}}, color = {0, 0, 127}));
  connect(limPIDFreeze.y, leadLag.u) annotation(
    Line(points = {{141, 50}, {158, 50}}, color = {0, 0, 127}));
  connect(leadLag.y, QInjRefPu) annotation(
    Line(points = {{181, 50}, {210, 50}}, color = {0, 0, 127}));
  connect(URefPu, UCtrlErr.u1) annotation(
    Line(points = {{-50, 160}, {-50, 92}, {-42, 92}}, color = {0, 0, 127}));
  connect(VCompFlag0.y, limPIDFreeze.freeze) annotation(
    Line(points = {{107, 134}, {124, 134}, {124, 62}}, color = {255, 0, 255}));
  connect(PRefPu, PInjRefPu) annotation(
    Line(points = {{-310, -30}, {-260, -30}, {-260, -80}, {210, -80}}, color = {0, 0, 127}));
  connect(UCtrlErr.y, deadZone.u) annotation(
    Line(points = {{-18, 86}, {10, 86}, {10, 50}, {38, 50}}, color = {0, 0, 127}));
  connect(firstOrder3.u, QVCtrlErr.y) annotation(
    Line(points = {{-82, 80}, {-200, 80}, {-200, 56}, {-218, 56}}, color = {0, 0, 127}));
  connect(UPu, QVCtrlErr.u1) annotation(
    Line(points = {{-310, 80}, {-260, 80}, {-260, 62}, {-242, 62}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Documentation(info = "<html>
<p> This block contains the generic WECC PV plant level control model according to (in case page cannot be found, copy link in browser): <a href='https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf/'>https://www.wecc.biz/Reliability/WECC%20Solar%20Plant%20Dynamic%20Modeling%20Guidelines.pdf </a> </p>
<p>Plant level active and reactive power/voltage control. Reactive power or voltage control dependent on RefFlag. Frequency dependent active power control is enabled or disabled with FreqFlag. With voltage control (RefFlag = true), voltage at remote bus can be controlled when VcompFlag == true. Therefore, RcPu and XcPu shall be defined as per real impedance between inverter terminal and regulated bus. If measurements from the regulated bus are available, VcompFlag should be set to false and the measurements from regulated bus shall be connected with the input measurement signals (PRegPu, QRegPu, uPu, iPu). </p>
</html>"),
    Diagram(coordinateSystem(extent = {{-300, -150}, {200, 150}})),
    version = "",
    uses(Modelica(version = "3.2.3")),
    __OpenModelica_commandLineOptions = "",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-29, 11}, extent = {{-41, 19}, {97, -41}}, textString = "REPC A"), Text(origin = {137, 74}, extent = {{-23, 10}, {41, -12}}, textString = "PInjRefPu"), Text(origin = {59, 110}, extent = {{-15, 12}, {11, -12}}, textString = "QPu"), Text(origin = {103, 110}, extent = {{-15, 12}, {11, -12}}, textString = "PPu"), Text(origin = {-53, 110}, extent = {{-15, 12}, {11, -12}}, textString = "iPu"), Text(origin = {-7, 110}, extent = {{-15, 12}, {11, -12}}, textString = "uPu"), Text(origin = {-149, -10}, extent = {{-23, 10}, {21, -10}}, textString = "PRefPu"), Text(origin = {-149, -52}, extent = {{-23, 10}, {21, -10}}, textString = "QRefPu"), Text(origin = {-149, 34}, extent = {{-55, 40}, {21, -10}}, textString = "omegaRefPu"), Text(origin = {-151, 78}, extent = {{-31, 32}, {21, -10}}, textString = "omegaPu"), Text(origin = {139, -46}, extent = {{-23, 10}, {41, -12}}, textString = "QInjRefPu"), Text(origin = {137, 12}, extent = {{-23, 10}, {27, -8}}, textString = "freeze"), Text(origin = {1, -132}, extent = {{-23, 10}, {21, -10}}, textString = "URefPu")}, coordinateSystem(initialScale = 0.1)));
end REPCa;
