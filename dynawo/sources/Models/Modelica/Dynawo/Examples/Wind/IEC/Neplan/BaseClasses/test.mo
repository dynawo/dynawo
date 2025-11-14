within Dynawo.Examples.Wind.IEC.Neplan.BaseClasses;

model test

extends Icons.Example;
  extends Dynawo.Examples.Wind.IEC.Neplan.BaseClasses.BaseWindNeplan;

  // Faults
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0, XPu = 0.09, tBegin = 6, tEnd = 6.25) annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Dynawo.Electrical.Events.NodeFault nodeFault1(RPu = 0, XPu = 0.4, tBegin = 12, tEnd = 12.15) annotation(
    Placement(visible = true, transformation(origin = {-90, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));

  // Reference inputs
  Modelica.Blocks.Sources.Pulse omegaRefPu(amplitude = -0.01, nperiod = 1, offset = 1, period = 2, startTime = 20) annotation(
    Placement(visible = true, transformation(origin = {-150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PRefPu(height = -0.5, offset = 1, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step QRefPu(height = 0.41, offset = -0.21, startTime = 4) annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step tanPhi(height = 0, offset = -0.21, startTime = 0) annotation(
    Placement(visible = true, transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Initialization
  Electrical.PEIR.Plant.Simplified.GridFollowingPlant gridFollowingPlant annotation(
    Placement(transformation(origin = {-102, 0}, extent = {{-10, -10}, {10, 10}})));
initial algorithm
  wPP4ACurrentSource.IGsIm0Pu := wPP4CurrentSource_INIT.IGsIm0Pu;
  wPP4ACurrentSource.IGsRe0Pu := wPP4CurrentSource_INIT.IGsRe0Pu;
  wPP4ACurrentSource.IpMax0Pu := wPP4CurrentSource_INIT.IpMax0Pu;
  wPP4ACurrentSource.IqMax0Pu := wPP4CurrentSource_INIT.IqMax0Pu;
  wPP4ACurrentSource.IqMin0Pu := wPP4CurrentSource_INIT.IqMin0Pu;
  wPP4ACurrentSource.PAg0Pu := wPP4CurrentSource_INIT.PAg0Pu;
  wPP4ACurrentSource.QMax0Pu := wPP4CurrentSource_INIT.QMax0Pu;
  wPP4ACurrentSource.QMin0Pu := wPP4CurrentSource_INIT.QMin0Pu;
  wPP4ACurrentSource.UGsIm0Pu := wPP4CurrentSource_INIT.UGsIm0Pu;
  wPP4ACurrentSource.UGsRe0Pu := wPP4CurrentSource_INIT.UGsRe0Pu;
  wPP4ACurrentSource.X0Pu := wPP4CurrentSource_INIT.X0Pu;
  wPP4ACurrentSource.XWT0Pu := wPP4CurrentSource_INIT.XWT0Pu;
  wPP4ACurrentSource.i0Pu.re := wPP4CurrentSource_INIT.i0Pu.re;
  wPP4ACurrentSource.i0Pu.im := wPP4CurrentSource_INIT.i0Pu.im;
  wPP4ACurrentSource.u0Pu.re := wPP4CurrentSource_INIT.u0Pu.re;
  wPP4ACurrentSource.u0Pu.im := wPP4CurrentSource_INIT.u0Pu.im;

equation
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal1.value = false;
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal2.value = false;
  wPP4ACurrentSource.wT4ACurrentSource.wT4Injector.switchOffSignal3.value = false;
  connect(nodeFault.terminal, line.terminal2) annotation(
    Line(points = {{70, -40}, {70, -20}, {60, -20}}, color = {0, 0, 255}));
  connect(gridFollowingPlant.terminal, transformer1.terminal1) annotation(
    Line(points = {{-102, 0}, {-80, 0}}, color = {0, 0, 255}));
end test;
