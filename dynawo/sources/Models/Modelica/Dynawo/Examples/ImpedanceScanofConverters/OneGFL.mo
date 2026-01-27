within Dynawo.Examples.ImpedanceScanofConverters;

model OneGFL

  /*Input & Outputs for Scan Frequency*/
  /*=================================*/
  input Real udIn = 0;
  input Real uqIn = 0;
  output Real idOut;
  output Real iqOut;


Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 2.19, Kid = 25, Kiq = 25, Kp = 2, Kpc = 0.20, Kpd = 0.1, Kpq = 0.1, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = 0.28, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 111, tQFilt = 1 / 111, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {-143, -13}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
Dynawo.Electrical.Lines.DynLine dynLine(LPu = 0.5, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.05, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {-65, -23}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
Dynawo.Electrical.Sources.InjectorUDQ injectorUDQ( SNomInjector = 100, UPhase0 = 0, id0Pu = 0, iq0Pu = 0, ud0Pu = 1, uq0Pu = 0) annotation(
    Placement(visible = true, transformation(origin = {43, -3}, extent = {{-35, -35}, {35, 35}}, rotation = 0)));
equation

  /**Adding Switch off*/
  dynLine.switchOffSignal1.value = false;
  dynLine.switchOffSignal2.value = false;

  GFL1.switchOffSignal1.value = false;
  GFL1.switchOffSignal2.value = false;
  GFL1.switchOffSignal3.value = false;
  injectorUDQ.switchOffSignal1.value = false;
  injectorUDQ.switchOffSignal2.value = false;
  injectorUDQ.switchOffSignal3.value = false;
// OmegaRef = 1
dynLine.omegaPu.value = 1;

/*Adding inputs to variables of the model*/
  injectorUDQ.udPu = 1 + udIn;
  injectorUDQ.uqPu = 0 + uqIn;
  injectorUDQ.UPhase = 0;
  GFL1.QFilterRefPu = 0;
  GFL1.PFilterRefPu= 0.5;
  GFL1.omegaRefPu= 1;

/*Adding outputs*/
  idOut = GFL1.Measurements.idPccPu;
  iqOut = GFL1.Measurements.iqPccPu;

  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{-108, -12}, {-86, -12}, {-86, -24}}, color = {0, 0, 255}));
connect(dynLine.terminal2, injectorUDQ.terminal) annotation(
    Line(points = {{-44, -24}, {-32, -24}, {-32, -76}, {108, -76}, {108, -31}, {83, -31}}, color = {0, 0, 255}));
annotation(
    Diagram(coordinateSystem(extent = {{-180, 60}, {120, -80}})));
end OneGFL;
