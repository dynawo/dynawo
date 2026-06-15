within Dynawo.Examples.GridCodeSimulations.BaseSheetSimulations;
model BaseSheetI5
  extends BaseParameters;

  Electrical.Buses.InfiniteBusWithVariations infiniteBus(U0Pu = UInfPu, UEvtPu = UInfPu, UPhase = 0, omega0Pu = 1, omegaEvtPu = 1, tOmegaEvtEnd = 0, tOmegaEvtStart = 0, tUEvtEnd = 0, tUEvtStart = 0) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Electrical.Lines.Line line(RPu = 0, XPu = XbPu, GPu = 0, BPu = 0) annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{-20, -20}, {20, 20}})));
  Dynawo.Electrical.Lines.Line line21(BPu = 0, GPu = 0, RPu = 0, XPu = 3*XbPu*0.99) annotation(
    Placement(transformation(origin = {-64, 0}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Lines.Line line22(BPu = 0, GPu = 0, RPu = 0, XPu = 3*XbPu*0.01) annotation(
    Placement(transformation(origin = {-36, 0}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.0001, tBegin = 2, tEnd = 2.15) annotation(
    Placement(transformation(origin = {-50, 20}, extent = {{-20, -20}, {20, 20}}, rotation = -0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = 1) annotation(
    Placement(transformation(origin = {90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));

equation
  // Switches
  line.switchOffSignal1 = false;
  line.switchOffSignal2 = false;
  line21.switchOffSignal1 = if time < 2.1501 then false else true;
  line21.switchOffSignal2 = if time < 2.1501 then false else true;
  line22.switchOffSignal1 = if time < 2.1501 then false else true;
  line22.switchOffSignal2 = if time < 2.1501 then false else true;

  // If the fault test doesn't run, try changing the switches equations with those below
  //  line21.switchOffSignal1 = false;
  //  line21.switchOffSignal2 = false;
  //  line22.switchOffSignal1 = false;
  //  line22.switchOffSignal2 = false;

  connect(infiniteBus.terminal, line.terminal1) annotation(
    Line(points = {{-100, 0}, {-80, 0}, {-80, 50}, {-70, 50}}, color = {0, 0, 255}));
  connect(line21.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-74, 0}, {-100, 0}}, color = {0, 0, 255}));
  connect(line21.terminal2, line22.terminal1) annotation(
    Line(points = {{-54, 0}, {-46, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line22.terminal1) annotation(
    Line(points = {{-50, 20}, {-50, 0}, {-46, 0}}, color = {0, 0, 255}));

  annotation(preferredView = "diagram");
end BaseSheetI5;
