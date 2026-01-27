within Dynawo.ImpedanceScanofConverters;

model OneZlineInfiniteBus
  /*Input & Outputs for Scan Frequency*/
  /*=================================*/
  input Real udIn = 0;
  input Real uqIn = 0;
  output Real idOut;
  output Real iqOut;
  Dynawo.Electrical.Lines.DynLine dynLine(LPu = 0.5, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.05, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {-65, -23}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorUDQ injectorUDQ(SNomInjector = 100,UPhase0 = 0, id0Pu = 0, iq0Pu = 0, ud0Pu = 1, uq0Pu = 0) annotation(
    Placement(visible = true, transformation(origin = {43, -3}, extent = {{-35, -35}, {35, 35}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 2) annotation(
    Placement(visible = true, transformation(origin = {-161, -13}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
equation
/**Adding Switch off*/
  dynLine.switchOffSignal1.value = false;
  dynLine.switchOffSignal2.value = false;

  injectorUDQ.switchOffSignal1.value = false;
  injectorUDQ.switchOffSignal2.value = false;
  injectorUDQ.switchOffSignal3.value = false;
// OmegaRef = 1
  dynLine.omegaPu.value = 1;
/*Adding inputs to variables of the model*/
  injectorUDQ.udPu = 1 + udIn;
  injectorUDQ.uqPu = 0 + uqIn;
  injectorUDQ.UPhase = 0;

/*Adding outputs*/
  idOut = injectorUDQ.idPu;
  iqOut = injectorUDQ.iqPu;
  connect(dynLine.terminal2, injectorUDQ.terminal) annotation(
    Line(points = {{-44, -24}, {-32, -24}, {-32, -76}, {108, -76}, {108, -31}, {83, -31}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, dynLine.terminal1) annotation(
    Line(points = {{-160, -12}, {-86, -12}, {-86, -22}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, 60}, {120, -80}})));
end OneZlineInfiniteBus;
