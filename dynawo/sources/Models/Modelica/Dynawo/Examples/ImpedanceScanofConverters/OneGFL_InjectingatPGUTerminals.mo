within Dynawo.Examples.ImpedanceScanofConverters;

model OneGFL_InjectingatPGUTerminals
  //OneGFL_InjectingatPGUTerminals
  /*Input & Outputs for Scan Frequency*/
  /*=================================*/
  input Real udIn = 0;
  input Real uqIn = 0;
  output Real idOut;
  output Real iqOut;
  Dynawo.Electrical.Sources.InjectorUDQ injectorUDQ(SNomInjector = 1000, UPhase0 = 0, id0Pu = 0, iq0Pu = 0, ud0Pu = 1, uq0Pu = 0) annotation(
    Placement(visible = true, transformation(origin = {43, -3}, extent = {{-35, -35}, {35, 35}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1(CFilterPu = 1e-5, Kfd = 1, Kfq = 1, Ki = 10, Kic = 2.1972, Kid = 25, Kiq = 25, Kp = 2, Kpc = 0.20981, Kpd = 0.1, Kpq = 0.1, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = -5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 111, tQFilt = 1 / 111, tVSC = 0.00004) annotation(
    Placement(visible = true, transformation(origin = {-139, -39}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
equation
/**Adding Switch off*/
//dynLine.switchOffSignal1.value = false;
//dynLine.switchOffSignal2.value = false;
  GFL1.switchOffSignal1.value = false;
  GFL1.switchOffSignal2.value = false;
  GFL1.switchOffSignal3.value = false;
  injectorUDQ.switchOffSignal1.value = false;
  injectorUDQ.switchOffSignal2.value = false;
  injectorUDQ.switchOffSignal3.value = false;
// OmegaRef = 1
//dynLine.omegaPu.value = 1;
/*Adding inputs to variables of the model*/
  injectorUDQ.udPu = 1 + udIn;
  injectorUDQ.uqPu = 0 + uqIn;
  injectorUDQ.UPhase = 0;
  GFL1.QFilterRefPu = 0.021;
  GFL1.PFilterRefPu = 0.5;
  GFL1.omegaRefPu = 1;
/*Adding outputs*/
  idOut = -GFL1.Measurements.idPccPu * GFL1.SNom / 100;//In base Snref
// Converting to Snref
  iqOut = -GFL1.Measurements.iqPccPu * GFL1.SNom / 100;//In base Snref
  connect(GFL1.terminal, injectorUDQ.terminal) annotation(
    Line(points = {{-102, -38}, {-32, -38}, {-32, -80}, {84, -80}, {84, -30}}, color = {0, 0, 255}));
// Converting to Snref
  annotation(
    Diagram(coordinateSystem(extent = {{-180, 60}, {100, -120}})));
end OneGFL_InjectingatPGUTerminals;
