within Dynawo.Examples.Nordic.Components.GeneratorWithControl;

model InjectorIDQWithControl
  extends Dynawo.AdditionalIcons.Machine;
  //Terminal
  Dynawo.Connectors.ACPower terminal "Connector used to connect the generator to the grid" annotation(
    Placement(transformation(origin = {110, 10}, extent = {{-10, -10}, {10, 10}}), iconTransformation(extent = {{-10, -10}, {10, 10}})));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at terminal in pu (base SnRef) (receptor convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude in pu (base UNom)";
  parameter Types.Angle UPhase0 "Start value of voltage angle in rad";
  parameter Real Snom;
  parameter Types.ComplexCurrentPu i0Pu;
  parameter Types.CurrentModulePu Id0Pu;
  parameter Types.CurrentModulePu Iq0Pu;
  parameter Types.ComplexApparentPowerPu s0Pu;
  parameter Types.ComplexVoltagePu u0Pu;
  parameter Types.CurrentModulePu Imax;
  Modelica.Units.SI.Voltage Vt(start=U0Pu);
  Electrical.Sources.InjectorIDQ injectorIDQ(SwitchOffSignal20 = false, SNom = Snom, i0Pu = i0Pu, Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, P0Pu = P0Pu, Q0Pu = Q0Pu, s0Pu = s0Pu, U0Pu = U0Pu, u0Pu = u0Pu, UPhase0 = UPhase0) annotation(
    Placement(transformation(origin = {40, 3.55271e-15}, extent = {{-20, -20}, {20, 20}})));
  ElectricalControlNordic electricalControlNordic(t1 = 1, t2 = 1, t3 = 1, t4 = 1, t5 = 1, t6 = 1, Kp = 5, Ki = 0.01, Imax = Imax, Vt0 = U0Pu, Q0Pu = Q0Pu, P0Pu = P0Pu, U0Pu = U0Pu, baseratio = 100/Snom, Iq0Pu = Iq0Pu) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y = Vt) annotation(
    Placement(transformation(origin = {-142, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression realExpression2(y = U0Pu) annotation(
    Placement(transformation(origin = {-114, -8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput VReg annotation(
    Placement(transformation(origin = {0, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
  Electrical.Controls.PLL.PLL pll(Ki = 1, Kp = 1, u0Pu = u0Pu, OmegaMaxPu = 60, OmegaMinPu = 40)  annotation(
    Placement(transformation(origin = {40, 68}, extent = {{20, -20}, {-20, 20}})));
  Modelica.Blocks.Sources.RealExpression realExpression3(y = 1.0) annotation(
    Placement(transformation(origin = {116, 56}, extent = {{10, -10}, {-10, 10}}, rotation = -0)));
  Modelica.Blocks.Sources.RealExpression realExpression4(y = -P0Pu*100/Snom)  annotation(
    Placement(transformation(origin = {-142, -16}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput VRef annotation(
    Placement(transformation(origin = {-80, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}})));
equation
  Vt =Modelica.ComplexMath.abs(terminal.V);
  injectorIDQ.idPu = Id0Pu;
  injectorIDQ.iqPu = Iq0Pu;
  injectorIDQ.UPhase = UPhase0;
//  connect(electricalControlNordic.IdRef, injectorIDQ.idPu) annotation(
//    Line(points = {{-18, 12}, {17, 12}}, color = {0, 0, 127}));
//  connect(electricalControlNordic.IqRef, injectorIDQ.iqPu) annotation(
//    Line(points = {{-18, -12}, {0, -12}, {0, -8}, {18, -8}}, color = {0, 0, 127}));
  connect(realExpression3.y, pll.omegaRefPu) annotation(
    Line(points = {{106, 56}, {62, 56}}, color = {0, 0, 127}));
  connect(realExpression2.y, electricalControlNordic.VtRef) annotation(
    Line(points = {{-102, -8}, {-64, -8}}, color = {0, 0, 127}));
  connect(realExpression.y, electricalControlNordic.Vt) annotation(
    Line(points = {{-131, 0}, {-64, 0}}, color = {0, 0, 127}));
  connect(VReg, electricalControlNordic.VReg) annotation(
    Line(points = {{0, -120}, {0, -60}, {-86, -60}, {-86, 8}, {-64, 8}}, color = {0, 0, 127}));
  connect(injectorIDQ.terminal, terminal) annotation(
    Line(points = {{64, -16}, {110, -16}, {110, 10}}, color = {0, 0, 255}));
//  connect(pll.phi, injectorIDQ.UPhase) annotation(
//    Line(points = {{18, 70}, {0, 70}, {0, 40}, {40, 40}, {40, 24}}, color = {0, 0, 127}));
  connect(injectorIDQ.uPu, pll.uPu) annotation(
    Line(points = {{64, -6}, {86, -6}, {86, 80}, {62, 80}}, color = {85, 170, 255}));
  connect(realExpression4.y, electricalControlNordic.PRef) annotation(
    Line(points = {{-131, -16}, {-64, -16}}, color = {0, 0, 127}));
  connect(VRef, electricalControlNordic.VRef) annotation(
    Line(points = {{-80, -120}, {-80, -70}, {-166, -70}, {-166, 16}, {-64, 16}}, color = {0, 0, 127}));
  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The controlled generator frame functions as the regulated synchronous generator of the Nordic 32 test system.<div>It consists of a 3 windings initialized synchronous generator, which models hydro-power plants. The regulating elements comprise automatic voltage regulation (AVR), exciter (EXC), overexcitation limitation (OEL), power system stabilizer (PSS) and speed control by a governor (GOV).</div><div>Parameters are automatically chosen according to a preset defined in the GeneratorParameters. Then, only initial values need to be supplied.</div><div>To add another configuration, append a new line to \"genFrameParamValues\", \"govParamValues\" and \"vrParamValues\"&nbsp;in GeneratorParameters and append a fitting name in the \"genFramePreset\" enumeration.</div>
</body></html>"),
    Icon(graphics = {Rectangle(lineThickness = 0.75, extent = {{-100, 100}, {100, -100}}), Rectangle(lineColor = {0, 170, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, lineThickness = 0.5, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 77}, textColor = {0, 0, 255}, extent = {{-35, 15}, {35, -15}}, textString = "%name"), Line(origin = {0, 40}, points = {{-80, 0}, {80, 0}, {80, 0}}, color = {0, 170, 0}, thickness = 0.5), Line(origin = {0, -40}, points = {{-80, 0}, {80, 0}, {80, 0}}, color = {0, 170, 0}, thickness = 0.5), Line(origin = {-20, -40}, points = {{-40, 80}, {-10, 0}, {20, 80}}, color = {0, 170, 0}, thickness = 0.5), Line(origin = {40, 40}, points = {{-40, -80}, {-10, 0}, {20, -80}}, color = {0, 170, 0}, thickness = 0.5)}),
    Diagram);
end InjectorIDQWithControl;
