within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

model IEEE_AC4A
  import Modelica.Blocks;
  import Dynawo.NonElectrical.Blocks.NonLinear.FirstOrderWithNonWindUpLimiter;
  import Dynawo.NonElectrical.Blocks.NonLinear.LeadLag;
  parameter Types.Time Tc = 3 "Lead time constant";
  parameter Types.Time Tb = 10 "Lag delay time constant";
  parameter Types.PerUnit Ka = 200 "Overall equivalent gain";
  parameter Types.Time Ta = 0.05 "Overall time constant";
  parameter Types.PerUnit VrMax = 4 "Output voltage max limit in p.u.";
  parameter Types.PerUnit VrMin = 0 "Output voltage min limit in p.u.";
  Blocks.Interfaces.RealInput VsPu(start = Vs0Pu) "PSS output p.u" annotation(
    Placement(visible = true, transformation(origin = {-140, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput VcPu(start = Vc0Pu) "Machine terminal voltage p.u." annotation(
    Placement(visible = true, transformation(origin = {-140, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealInput VrefPu(start = Vref0Pu) "Voltage reference p.u." annotation(
    Placement(visible = true, transformation(origin = {-140, -30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Interfaces.RealOutput efdPu(start = efd0Pu) "Exciter output voltage p.u." annotation(
    Placement(visible = true, transformation(origin = {68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add3 addIng(k1 = +1, k2 = -1, k3 = +1) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  LeadLag leadLag(T1 = Tc, T2 = Tb, K = 1, y0 = efd0Pu / Ka, u0 = efd0Pu / Ka) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  FirstOrderWithNonWindUpLimiter firstOrderLim(T = Ta, K = Ka, YMax = VrMax, YMin = VrMin, y0 = efd0Pu, u0 = efd0Pu / Ka) annotation(
    Placement(visible = true, transformation(origin = {18, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ImPin EfdPuPin(value(start = efd0Pu)) "Exciter field voltage Pin";
protected
  parameter Types.VoltageModulePu Vref0Pu "Initial control voltage";
  // p.u. = Unom
  parameter Types.VoltageModulePu Vs0Pu "Initial stator voltage";
  // p.u. = Unom
  parameter Types.VoltageModulePu Vc0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";
  parameter Types.VoltageModulePu efd0Pu "Initial Efd, i.e Efd0PuLF if compliant with saturations";
equation
  connect(leadLag.y, firstOrderLim.u) annotation(
    Line(points = {{-18, 0}, {6, 0}, {6, 0}, {6, 0}}, color = {0, 0, 127}));
  connect(addIng.y, leadLag.u) annotation(
    Line(points = {{-68, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(firstOrderLim.y, efdPu) annotation(
    Line(points = {{29, 0}, {68, 0}}, color = {0, 0, 127}));
  connect(VrefPu, addIng.u3) annotation(
    Line(points = {{-140, -30}, {-108, -30}, {-108, -8}, {-92, -8}, {-92, -8}}, color = {0, 0, 127}));
  connect(VsPu, addIng.u1) annotation(
    Line(points = {{-140, 30}, {-108, 30}, {-108, 8}, {-92, 8}, {-92, 8}}, color = {0, 0, 127}));
  connect(VcPu, addIng.u2) annotation(
    Line(points = {{-140, 0}, {-94, 0}, {-94, 0}, {-92, 0}}, color = {0, 0, 127}));
  connect(EfdPuPin.value, efdPu);
  annotation(
    Icon(coordinateSystem(grid = {0.1, 0.1}, initialScale = 0.1), graphics = {Rectangle(origin = {0, 1}, extent = {{-100, 99}, {100, -101}}), Text(origin = {24, 4}, extent = {{-94, 70}, {56, -72}}, textString = "IEEE\nAC4A")}),
    Diagram(coordinateSystem(extent = {{-200, -100}, {200, 100}})),
    Documentation(info = "<html><head></head><body><span style=\"font-size: 12px;\">The class implements a model of a static exictation system according to the&nbsp;</span><span style=\"font-size: 12px;\">IEEE Std 421.5TM-2005.</span><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\">The type implemented is the AC4A, described in the chapter 6.4 of the same&nbsp;IEEE Std 421.5TM-2005.</div><div style=\"font-size: 12px;\"><br></div><div style=\"font-size: 12px;\"><span class=\"tlid-translation translation\">Unlike the aforementioned standard, the output voltage ceiling limitation is fixed to VrMax, while in the standard it depends to the field current IFd.</span></div></body></html>"));
end IEEE_AC4A;
