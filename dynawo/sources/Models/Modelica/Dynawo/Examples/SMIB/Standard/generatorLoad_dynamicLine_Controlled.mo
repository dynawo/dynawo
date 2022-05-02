within Dynawo.Examples.SMIB.Standard;

model generatorLoad_dynamicLine_Controlled
  import Dynawo;
  import Modelica;
  extends Icons.Example;
  parameter Real x = 0.5;
  Real theta_seuil = 4.71239;
  parameter Real deltat = 10;

  // Load PQ
  parameter Types.ActivePowerPu PLoadPu = 15.8263;
  parameter Types.ReactivePowerPu QLoadPu = -1.95242;
  parameter Real A = 2;
  parameter Real B = 2;




  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(Ce0Pu = 0.903, Cm0Pu = 0.903,
   Cos2Eta0 = 0.68888,
   DPu = 0,
   Efd0Pu = 2.4659,
   ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad,
   H = 3.5,
   IRotor0Pu = 2.4659,
   IStator0Pu = 22.2009,
   Id0Pu = -0.91975,
   If0Pu = 1.4855,
   Iq0Pu = -0.39262,
   LDPPu = 0.16634,
   LQ1PPu = 0.92815,
   LQ2PPu = 0.12046,
   LambdaAD0Pu = 0.89347,
   LambdaAQ0Pu = -0.60044,
   LambdaAirGap0Pu = 1.0764,
   LambdaD0Pu = 0.89243,
   LambdaQ10Pu = -0.60044,
   LambdaQ20Pu = -0.60044,
   Lambdad0Pu = 0.75547,
   Lambdaf0Pu = 1.1458,
   Lambdaq0Pu = -0.65934,
   LdPPu = 0.15,
   LfPPu = 0.16990,
   LqPPu = 0.15,
   MdPPu = 1.66,
   MdSat0PPu = 1.5792,
   Mds0Pu = 1.5785,
   Mi0Pu = 1.5637,
   MqPPu = 1.61,
   MqSat0PPu = 1.5292,
   Mqs0Pu = 1.530930,
   MrcPPu = 0,
   MsalPu = 0.05,
   P0Pu = -19.98,
   PGen0Pu = 19.98,
   PNomAlt = 2200,
   PNomTurb = 2220,
   Pm0Pu = 0.903,
   Q0Pu = -9.68,
   QGen0Pu = 9.6789,
   QStator0Pu = 9.6789,
   RDPPu = 0.03339,
   RQ1PPu = 0.00924,
   RQ2PPu = 0.02821,
   RTfPu = 0,
   RaPPu = 0.003,
   RfPPu = 0.00074,
   SNom = 2220,
   Sin2Eta0 = 0.31111,
   SnTfo = 2220,
   Theta0 = 1.2107,
   ThetaInternal0 = 0.71622,
   U0Pu = 1,
   UBaseHV = 24,
   UBaseLV = 24,
   UNom = 24,
   UNomHV = 24,
   UNomLV = 24,
   UPhase0 = 0.494442,
   UStator0Pu = 1,
   Ud0Pu = 0.65654,
   Uf0Pu = 0.00109,
   Uq0Pu = 0.75434,
   XTfPu = 0,
   md = 0.031,
   mq = 0.031,
   nd = 6.93,
   nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {86, -28}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {60, 42}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  //Dynawo.Electrical.Lines.DynamicLine line2(CPu = 0.0000375, GPu = 0, LPu = 0.03370, RPu = 0.016854, i10Pu = Complex(-11.0904, -0.48034), i20Pu = Complex(11.0904, 0.48034), iGC10Pu = Complex(0, 0), iGC20Pu = Complex(0, 0), iRL0Pu = Complex(-11.0904, -0.48034), u10Pu = Complex(0.715983, -0.0570824), u20Pu = Complex(0.886712, 0.32476)) annotation(
//    Placement(visible = true, transformation(origin = {-14, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  //Dynawo.Electrical.Lines.DynamicLine line1(CPu = (1 - x) * 0.0000375, GPu = 0, LPu = (1 - x) * 0.03370, RPu = (1 - x) * 0.016854, i10Pu = Complex(-11.0904, -0.48034), i20Pu = Complex(11.0904, 0.48034), iGC10Pu = Complex(0, 0), iGC20Pu = Complex(0, 0), iRL0Pu = Complex(-11.0904, -0.48034), u10Pu = Complex(0.715983, -0.0570824), u20Pu = Complex(0.801348, 0.133839)) annotation(
//    Placement(visible = true, transformation(origin = {-34, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  /* x */
  //Dynawo.Electrical.Lines.DynamicLine line3(CPu = x * 0.0000375, GPu = 0, LPu = x * 0.03370, RPu = x * 0.016854, i10Pu = Complex(-11.0904, -0.48034), i20Pu = Complex(11.0904, 0.48034), iGC10Pu = Complex(0, 0), iGC20Pu = Complex(0, 0), iRL0Pu = Complex(-11.0904, -0.48034), u10Pu = Complex(0.801348, 0.133839), u20Pu = Complex(0.886712, 0.32476)) annotation(
  //  Placement(visible = true, transformation(origin = {18, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  /* x */
    Dynawo.Electrical.Lines.Line line2(BPu = 0.0000375, GPu = 0, XPu = 0.03370, RPu = 0.016854) annotation(
      Placement(visible = true, transformation(origin = {-2, -4}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Dynawo.Electrical.Lines.Line line1(BPu = (1 - x) * 0.0000375, GPu = 0, XPu = (1 - x) * 0.03370, RPu = (1 - x) * 0.016854) annotation(
     Placement(visible = true, transformation(origin = {-30, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Dynawo.Electrical.Lines.Line line3(BPu = x * 0.0000375, GPu = 0, XPu = x * 0.03370, RPu = x * 0.016854) annotation(
      Placement(visible = true, transformation(origin = {20, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Sources.Constant PmRefPu(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional goverProportional(KGover = 2, PMax = 3000, PMin = 0, PNom = 2000, Pm0Pu = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-6, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportionalIntegral vRProportionalIntegral(Efd0Pu = generatorSynchronous.Efd0Pu,EfdMaxPu = 5, EfdMinPu = -5, Gain = 20, LagEfdMax = 0, LagEfdMin = 0, Us0Pu = generatorSynchronous.U0Pu, UsRef0Pu = generatorSynchronous.U0Pu, UsRefMaxPu = 5, UsRefMinPu = -5, tIntegral = 1, yIntegrator0 = generatorSynchronous.Efd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-12, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.00001, XPu = 0.00001, tBegin = 5, tEnd = 5 + deltat)  annotation(
    Placement(visible = true, transformation(origin = {30, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta loadAlphaBeta(alpha = A, beta = B, u0Pu = Complex(0.715988, -0.0570174)) annotation(
    Placement(visible = true, transformation(origin = {-50, 38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constant1(k = PLoadPu) annotation(
    Placement(visible = true, transformation(origin = {-90, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = QLoadPu) annotation(
    Placement(visible = true, transformation(origin = {-90, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
//initial equation
 // der(generatorSynchronous.lambdafPu) = 0;
 // der(generatorSynchronous.lambdaDPu) = 0;
 // der(generatorSynchronous.lambdaQ1Pu) = 0;
 // der(generatorSynchronous.lambdaQ2Pu) = 0;
 // der(generatorSynchronous.theta) = 0;
 //der(generatorSynchronous.omegaPu.value) = 0;
equation
  /*assert(generatorSynchronous.theta < Modelica.Constants.pi * 270 / 180, "temps critique atteint");*/

  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line2.switchOffSignal1.value = false;
  line2.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  transformer.switchOffSignal1.value = false;
  transformer.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  loadAlphaBeta.switchOffSignal1.value = false;
  loadAlphaBeta.switchOffSignal2.value = false;
  connect(generatorSynchronous.omegaRefPu, generatorSynchronous.omegaPu );
  connect(line1.terminal2, line3.terminal1) annotation(
    Line(points = {{-10, 70}, {0, 70}}, color = {0, 0, 255}));
  connect(line3.terminal2, transformer.terminal1) annotation(
    Line(points = {{40, 70}, {40, 42}}, color = {0, 0, 255}));
  connect(goverProportional.PmRefPu, PmRefPu.y) annotation(
    Line(points = {{-21, -30}, {-59, -30}}, color = {0, 0, 127}));
  connect(goverProportional.omegaPu, generatorSynchronous.omegaPu_out) annotation(
    Line(points = {{-22, -41}, {-34, -41}, {-34, -54.4}, {82, -54.4}, {82, -39}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{0, -70}, {46, -70}, {46, -21}, {76, -21}}, color = {0, 0, 127}));
  connect(UsRefPu.y, vRProportionalIntegral.UsRefPu) annotation(
    Line(points = {{-59, -70}, {-26, -70}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, vRProportionalIntegral.UsPu) annotation(
    Line(points = {{97, -39}, {97, -94.8}, {-29.2, -94.8}, {-29.2, -74}, {-18, -74}}, color = {0, 0, 127}));
  connect(transformer.terminal1, line2.terminal2) annotation(
    Line(points = {{40, 42}, {40, -4}, {18, -4}}, color = {0, 0, 255}));
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{80, 42}, {86, 42}, {86, -28}}, color = {0, 0, 255}));
  connect(goverProportional.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{6, -36}, {76, -36}, {76, -35}}, color = {0, 0, 127}));
  connect(constant2.y, loadAlphaBeta.QRefPu) annotation(
    Line(points = {{-79, 10}, {-70, 10}, {-70, 32}, {-58, 32}}, color = {0, 0, 127}));
  connect(constant1.y, loadAlphaBeta.PRefPu) annotation(
    Line(points = {{-79, 50}, {-71, 50}, {-71, 44}, {-58.5, 44}}, color = {0, 0, 127}));
  connect(line2.terminal1, loadAlphaBeta.terminal) annotation(
    Line(points = {{-22, -4}, {-50, -4}, {-50, 38}}, color = {0, 0, 255}));
  connect(line1.terminal1, loadAlphaBeta.terminal) annotation(
    Line(points = {{-50, 70}, {-50, 38}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line1.terminal2) annotation(
    Line(points = {{30, 88}, {-10, 88}, {-10, 70}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 3, Tolerance = 0.0001, Interval = 0.001));
end generatorLoad_dynamicLine_Controlled;
