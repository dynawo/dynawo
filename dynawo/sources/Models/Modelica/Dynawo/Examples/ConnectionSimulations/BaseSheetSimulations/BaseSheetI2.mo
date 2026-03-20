within Dynawo.Examples.ConnectionSimulations.BaseSheetSimulations;

model BaseSheetI2
  extends Modelica.Icons.Example;
  extends BaseParameters;

  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = UInfPu, UEvtPu = UInfPu, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Electrical.Lines.Line Xcc_a(BPu = 0, GPu = 0, RPu = 0, XPu = XccPu) annotation(
    Placement(transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}})));
equation
  // Switches
  Xcc_a.switchOffSignal1.value = false;
  Xcc_a.switchOffSignal2.value = false;
  connect(infiniteBus.terminal, Xcc_a.terminal1) annotation(
    Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}));
end BaseSheetI2;
