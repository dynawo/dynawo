within Dynawo.Examples.DynamicLineTests;

model test
  import Modelica;
  import Dynawo;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Types.PerUnit CPu = 2.9374375000000003e-08;
  parameter Types.PerUnit RPu = 0.004071878037681818;
  parameter Types.PerUnit LPu = 0.004524308930757575;
  parameter Types.PerUnit GPu = 0;

  Types.PerUnit Ia;
  Types.PerUnit Ib;
  Types.PerUnit Ic;

  Types.PerUnit Ia2;
  Types.PerUnit Ib2;
  Types.PerUnit Ic2;

  Dynawo.Electrical.Lines.DynamicLine dynamicLine(CPu = CPu/2, GPu = GPu/2, LPu = LPu/2, RPu = RPu/2, u10Pu = Complex(0.9882436, -0.2434565), u20Pu = Complex(0.9926094, -0.2207374), i10Pu = Complex(-6.508322, -3.927559), i20Pu = Complex(6.508322, 3.927559), iRL0Pu = Complex(-6.508322, -3.927559), iGC10Pu = Complex(3.575691e-09, 1.451452e-08), iGC20Pu = Complex(3.242012e-09, 1.457864e-08)) annotation(
    Placement(visible = true, transformation(origin = {-8, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = -0.1960672926509973, UPu = 1.01645) annotation(
    Placement(visible = true, transformation(origin = {80, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = -0.24154303966409982, UPu = 1.01779) annotation(
    Placement(visible = true, transformation(origin = {-60, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.DynamicLine dynamicLine1(CPu = CPu/2, GPu = GPu/2, LPu = LPu/2, RPu = RPu/2, u10Pu = Complex(0.9926094, -0.2207374), u20Pu = Complex(0.9969751, -0.1980182), i10Pu = Complex(-6.508324, -3.927606), i20Pu = Complex(6.508324, 3.927606), iRL0Pu = Complex(-6.508324, -3.927606), iGC10Pu = Complex(3.242012e-09, 1.457864e-08), iGC20Pu = Complex(2.90833e-09, 1.464276e-08)) annotation(
    Placement(visible = true, transformation(origin = {30, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus2(UPhase = -0.24154303966409982, UPu = 1.01779) annotation(
    Placement(visible = true, transformation(origin = {-68, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line line(BPu = CPu/2, GPu = GPu/2 , XPu = LPu/2 , RPu = RPu/2) annotation(
    Placement(visible = true, transformation(origin = {-10, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = CPu/2, GPu = GPu/2, XPu = LPu/2 , RPu = RPu/2) annotation(
    Placement(visible = true, transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.00001, XPu = 0.00001, tBegin = 1, tEnd = 1+0.5) annotation(
    Placement(visible = true, transformation(origin = {70, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus3(UPhase = -0.1960672926509973, UPu = 1.01645) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0.00001, XPu = 0.00001, tBegin = 1, tEnd = 1+0.5) annotation(
    Placement(visible = true, transformation(origin = {60, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line2(BPu = CPu, GPu = GPu, RPu = RPu, XPu = LPu) annotation(
    Placement(visible = true, transformation(origin = {10, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine dynamicLine2(CPu = CPu, GPu = GPu, LPu = LPu, RPu = RPu, u10Pu = Complex(0.9882436, -0.2434565), u20Pu = Complex(0.9969751, -0.1980182), i10Pu = Complex(-6.508323, -3.927582), i20Pu = Complex(6.508323, 3.927583), iRL0Pu = Complex(-6.508323, -3.927583), iGC10Pu = Complex(7.151383e-09, 2.902904e-08), iGC20Pu = Complex(5.816661e-09, 2.928552e-08)) annotation(
    Placement(visible = true, transformation(origin = {10, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line3(BPu = 0, GPu = 0, RPu = RPu / 100, XPu = LPu / 100) annotation(
    Placement(visible = true, transformation(origin = {-40, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line4(BPu = 0, GPu = 0, RPu = RPu / 100, XPu = LPu / 100) annotation(
    Placement(visible = true, transformation(origin = {60, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line5(BPu = 0, GPu = 0, RPu = RPu / 100, XPu = LPu / 100) annotation(
    Placement(visible = true, transformation(origin = {-40, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line6(BPu = 0, GPu = 0, RPu = RPu / 100, XPu = LPu / 100) annotation(
    Placement(visible = true, transformation(origin = {60, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

  Ia = sin(100 * Modelica.Constants.pi * time) * dynamicLine1.terminal2.i.re + cos(100 * Modelica.Constants.pi * time) * dynamicLine1.terminal2.i.im;
  Ib = sin(100 * Modelica.Constants.pi * time - 2 * Modelica.Constants.pi / 3) * dynamicLine1.terminal2.i.re + cos(100 * Modelica.Constants.pi * time - 2 * Modelica.Constants.pi / 3) * dynamicLine1.terminal2.i.im;
  Ic = sin(100 * Modelica.Constants.pi * time + 2 * Modelica.Constants.pi / 3) * dynamicLine1.terminal2.i.re + cos(100 * Modelica.Constants.pi * time + 2 * Modelica.Constants.pi / 3) * dynamicLine1.terminal2.i.im;
  Ia2 = sin(100 * Modelica.Constants.pi * time) * line1.terminal2.i.re + cos(100 * Modelica.Constants.pi * time) * line1.terminal2.i.im;
  Ib2 = sin(100 * Modelica.Constants.pi * time - 2 * Modelica.Constants.pi / 3) * line1.terminal2.i.re + cos(100 * Modelica.Constants.pi * time - 2 * Modelica.Constants.pi / 3) * line1.terminal2.i.im;
  Ic2 = sin(100 * Modelica.Constants.pi * time + 2 * Modelica.Constants.pi / 3) * line1.terminal2.i.re + cos(100 * Modelica.Constants.pi * time + 2 * Modelica.Constants.pi / 3) * line1.terminal2.i.im;
  dynamicLine.omegaPu = 1;
  dynamicLine1.omegaPu = 1;
  dynamicLine2.omegaPu = 1;
  dynamicLine1.switchOffSignal1.value = false;
  dynamicLine1.switchOffSignal2.value = false;
  dynamicLine2.switchOffSignal1.value = false;
  dynamicLine2.switchOffSignal2.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  dynamicLine.switchOffSignal1.value = false;
  dynamicLine.switchOffSignal2.value = false;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  line4.switchOffSignal1.value = false;
  line4.switchOffSignal2.value = false;
  line5.switchOffSignal1.value = false;
  line5.switchOffSignal2.value = false;
  line6.switchOffSignal1.value = false;
  line6.switchOffSignal2.value = false;

  connect(dynamicLine.terminal2, dynamicLine1.terminal1) annotation(
    Line(points = {{2, -6}, {20, -6}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, dynamicLine1.terminal1) annotation(
    Line(points = {{70, 6}, {70, 2}, {20, 2}, {20, -6}}, color = {0, 0, 255}));
  connect(nodeFault1.terminal, line1.terminal1) annotation(
    Line(points = {{60, 70}, {60, 59}, {20, 59}, {20, 50}}, color = {0, 0, 255}));
  connect(line.terminal2, line1.terminal1) annotation(
    Line(points = {{0, 50}, {20, 50}}, color = {0, 0, 255}));
  connect(line4.terminal2, infiniteBus.terminal) annotation(
    Line(points = {{70, -20}, {80, -20}}, color = {0, 0, 255}));
  connect(infiniteBus1.terminal, line3.terminal1) annotation(
    Line(points = {{-60, -20}, {-50, -20}}, color = {0, 0, 255}));
  connect(line3.terminal2, dynamicLine.terminal1) annotation(
    Line(points = {{-30, -20}, {-18, -20}, {-18, -6}}, color = {0, 0, 255}));
  connect(dynamicLine2.terminal1, line3.terminal2) annotation(
    Line(points = {{0, -40}, {-18, -40}, {-18, -20}, {-30, -20}}, color = {0, 0, 255}));
  connect(dynamicLine2.terminal2, line4.terminal1) annotation(
    Line(points = {{20, -40}, {40, -40}, {40, -20}, {50, -20}}, color = {0, 0, 255}));
  connect(dynamicLine1.terminal2, line4.terminal1) annotation(
    Line(points = {{40, -6}, {40, -20}, {50, -20}}, color = {0, 0, 255}));
  connect(infiniteBus2.terminal, line5.terminal1) annotation(
    Line(points = {{-68, 40}, {-50, 40}}, color = {0, 0, 255}));
  connect(line5.terminal2, line.terminal1) annotation(
    Line(points = {{-30, 40}, {-30, 50}, {-20, 50}}, color = {0, 0, 255}));
  connect(line2.terminal1, line5.terminal2) annotation(
    Line(points = {{0, 28}, {-30, 28}, {-30, 40}}, color = {0, 0, 255}));
  connect(line2.terminal2, line6.terminal1) annotation(
    Line(points = {{20, 28}, {40, 28}, {40, 40}, {50, 40}}, color = {0, 0, 255}));
  connect(line1.terminal2, line6.terminal1) annotation(
    Line(points = {{40, 50}, {40, 40}, {50, 40}}, color = {0, 0, 255}));
  connect(line6.terminal2, infiniteBus3.terminal) annotation(
    Line(points = {{70, 40}, {80, 40}}, color = {0, 0, 255}));

end test;
