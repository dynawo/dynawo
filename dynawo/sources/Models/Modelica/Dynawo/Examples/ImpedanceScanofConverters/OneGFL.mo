within Dynawo.Examples.ImpedanceScanofConverters;

model OneGFL

  /*Input & Outputs for Scan Frequency*/
  /*=================================*/
  input Real udIn = 0;
  input Real uqIn = 0;
  output Real idOut;
  output Real iqOut;


Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1 (CFilterPu = 1 / 1e5, Kfd = 1, Kfq = 0, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.3819, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 300, tPQFilt = 1 / 111.055, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 / 2000, tVSC = 1 / (2 *2.5e3))  annotation(
    Placement(visible = true, transformation(origin = {-145, -3}, extent = {{-31, -31}, {31, 31}}, rotation = 0)));
Dynawo.Electrical.Lines.DynLine dynLine(LPu = 0.05, P01Pu = -5, P02Pu = 5.05, Q01Pu = 0.21, Q02Pu = 0.508, RPu = 0.005, U01Pu = 1.0847, U02Pu = 1.099, UPhase01 = -0.18, UPhase02 = -0.04) annotation(
    Placement(visible = true, transformation(origin = {-67, -25}, extent = {{-21, -21}, {21, 21}}, rotation = 0)));
Dynawo.Electrical.Sources.InjectorUDQ injectorUDQ( SNomInjector = 1000, UPhase0 = 0, id0Pu = 0, iq0Pu = 0, ud0Pu = 1, uq0Pu = 0) annotation(
    Placement(visible = true, transformation(origin = {43, -3}, extent = {{-35, -35}, {35, 35}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0, offset = 0.021, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-242, -8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
 // GFL1.QFilterRefPu = 0;
  GFL1.PFilterRefPu= 0.5;
  GFL1.omegaRefPu= 1;

/*Adding outputs*/
 // idOut = injectorUDQ.idPu;
 // iqOut = injectorUDQ.iqPu;

  /*Adding outputs*/
//Converting those currents to Snref
  idOut = injectorUDQ.idPu*injectorUDQ.SNomInjector/SystemBase.SnRef;
 iqOut = injectorUDQ.iqPu*injectorUDQ.SNomInjector/SystemBase.SnRef;
/*Adding outputs*/
// idOut = -GFL1.Measurements.idPccPu * GFL1.SNom / SystemBase.SnRef;//In base Snref
// Converting to Snref
//iqOut = -GFL1.Measurements.iqPccPu * GFL1.SNom / SystemBase.SnRef;//In base Snref
  connect(GFL1.terminal, dynLine.terminal1) annotation(
    Line(points = {{-111, -3}, {-88, -3}, {-88, -25}}, color = {0, 0, 255}));
 connect(dynLine.terminal2, injectorUDQ.terminal) annotation(
    Line(points = {{-46, -25}, {-32, -25}, {-32, -76}, {108, -76}, {108, -31}, {83, -31}}, color = {0, 0, 255}));
  connect(step.y, GFL1.QFilterRefPu) annotation(
    Line(points = {{-230, -8}, {-212, -8}, {-212, -16}, {-180, -16}}, color = {0, 0, 127}));

annotation(
    Diagram(coordinateSystem(extent = {{-180, 60}, {120, -80}})));
end OneGFL;
