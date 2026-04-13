within Dynawo.Examples.ImpedanceScanofConverters;

model OneGFL_InjectingatPGUTerminals
  //OneGFL_InjectingatPGUTerminals
  /*Input & Outputs for Scan Frequency*/
  /*=================================*/
  input Real udIn = 0;
  input Real uqIn = 0;
   Real iqOut_inject "Value of current in q axis (base UNom, SnRef)";
   Real idOut_inject "Value of current in d axis (base UNom, SnRef)";
  output Real idOut "Value of current in d axis (base UNom, SnRef)";
  output Real iqOut "Value of current in q axis (base UNom, SnRef)";
  Dynawo.Electrical.Sources.InjectorUDQ injectorUDQ(SNomInjector = 1000, UPhase0 = 0, id0Pu = 0, iq0Pu = 0, ud0Pu = 1, uq0Pu = 0) annotation(
    Placement(visible = true, transformation(origin = {43, -3}, extent = {{-35, -35}, {35, 35}}, rotation = 0)));
  Dynawo.Electrical.PEIR.Converters.General.Average.GridFollowing.DynGFLMeasurementFiltered GFL1 (CFilterPu = 1 / 1e5, Kfd = 1, Kfq = 0, Ki = 7.95, Kic = 3.60, Kid = 10, Kiq = 10, Kp = 0.318, Kpc = 0.3819, Kpd = 0.033, Kpq = 0.033, LFilterPu = 0.1, LTransformerPu = 0.05, OmegaMaxPu = 1.1, OmegaMinPu = 0.9, P0Pu = 5, Q0Pu = -0.21, RFilterPu = 0.003, RTransformerPu = 0.002, SNom = 1000, U0Pu = 1.0847, UPhase0 = -0.18, tPFilt = 1 / 300, tPQFilt = 1 / 111.055, tQFilt = 1 / 300, tUFilt = 1 / 6283.18, tUqPLL = 1 / 2000, tVSC = 1 / (2 *2.5e3)) annotation(
    Placement(visible = true, transformation(origin = {-139, -39}, extent = {{-33, -33}, {33, 33}}, rotation = 0)));
  Modelica.Blocks.Sources.Step step(height = 0, offset = 0.021, startTime = 2) annotation(
    Placement(visible = true, transformation(origin = {-234, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
 // GFL1.QFilterRefPu = 0.021;
  GFL1.PFilterRefPu = 0.5;
  GFL1.omegaRefPu = 1;

  /*Adding outputs*/
//Converting those currents to Snref
   idOut= injectorUDQ.idPu*injectorUDQ.SNomInjector/SystemBase.SnRef;
   iqOut= injectorUDQ.iqPu*injectorUDQ.SNomInjector/SystemBase.SnRef;

/*Adding outputs*/
  idOut_inject = -GFL1.Measurements.idPccPu * GFL1.SNom / SystemBase.SnRef;//In base Snref
// Converting to Snref
 iqOut_inject = -GFL1.Measurements.iqPccPu * GFL1.SNom / SystemBase.SnRef;//In base Snref

  connect(GFL1.terminal, injectorUDQ.terminal) annotation(
    Line(points = {{-102, -38}, {-32, -38}, {-32, -80}, {84, -80}, {84, -30}}, color = {0, 0, 255}));
  connect(step.y, GFL1.QFilterRefPu) annotation(
    Line(points = {{-223, -52}, {-176, -52}}, color = {0, 0, 127}));
// Converting to Snref
  annotation(
    Diagram(coordinateSystem(extent = {{-180, 60}, {100, -120}})));
end OneGFL_InjectingatPGUTerminals;
