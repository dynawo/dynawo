within Dynawo.Examples.SMIB;

model SMIBdynamicLineTest
  import Dynawo;
  extends Icons.Example;

  Dynawo.Electrical.Transformers.TransformerFixedRatio transformerFixedRatio(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1)  annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = 0, UPu = 0.90081)  annotation(
    Placement(visible = true, transformation(origin = {-62, -2}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous generatorSynchronous(Ce0Pu = 0.903, Cm0Pu = 0.903, Cos2Eta0 = 0.68888, DPu = 0, Efd0Pu = 2.4659, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 3.5, IRotor0Pu = 2.4659, IStator0Pu = 22.2009, Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262, LDPPu = 0.16634, LQ1PPu = 0.92815, LQ2PPu = 0.12046, LambdaAD0Pu = 0.89347, LambdaAQ0Pu = -0.60044, LambdaAirGap0Pu = 1.0764, LambdaD0Pu = 0.89243, LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458, Lambdaq0Pu = -0.65934, LdPPu = 0.15, LfPPu = 0.16990, LqPPu = 0.15, MdPPu = 1.66, MdSat0PPu = 1.5792, Mds0Pu = 1.5785, Mi0Pu = 1.5637, MqPPu = 1.61, MqSat0PPu = 1.5292, Mqs0Pu = 1.5309, MrcPPu = 0, MsalPu = 0.05, P0Pu = -19.98, PGen0Pu = 19.98, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.903, Q0Pu = -9.68, QGen0Pu = 9.6789, QStator0Pu = 9.6789, RDPPu = 0.03339, RQ1PPu = 0.00924, RQ2PPu = 0.02821, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.00074, SNom = 2220, Sin2Eta0 = 0.31111, SnTfo = 2220, Theta0 = 1.2107, ThetaInternal0 = 0.71622, U0Pu = 1, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, UPhase0 = 0.494442, UStator0Pu = 1, Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434, XTfPu = 0, md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {80, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 180)));
  Dynawo.Electrical.Controls.Basics.Step PmPu(Value0 = 0.903, Height = 0.02, tStep = 1200);
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint EfdPu(Value0 = 2.4659);
  Dynawo.Electrical.Lines.dynamicLine dynamicLine(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375) annotation(
    Placement(visible = true, transformation(origin = {-18, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.dynamicLine dynamicLine1(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375) annotation(
    Placement(visible = true, transformation(origin = {-18, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
initial equation
  der(generatorSynchronous.lambdafPu) = 0;
  der(generatorSynchronous.lambdaDPu) = 0;
  der(generatorSynchronous.lambdaQ1Pu) = 0;
  der(generatorSynchronous.lambdaQ2Pu) = 0;
  der(generatorSynchronous.theta) = 0;
  der(generatorSynchronous.omegaPu.value) = 0;
equation
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(generatorSynchronous.PmPu, PmPu.step);
  connect(generatorSynchronous.efdPu, EfdPu.setPoint);
  dynamicLine.switchOffSignal1.value = false;
  dynamicLine.switchOffSignal2.value = false;
  dynamicLine1.switchOffSignal1.value = false;
  dynamicLine1.switchOffSignal2.value = false;
  transformerFixedRatio.switchOffSignal1.value = false;
  transformerFixedRatio.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal1.value = false;
  generatorSynchronous.switchOffSignal2.value = false;
  generatorSynchronous.switchOffSignal3.value = false;
  connect(dynamicLine.terminal2, transformerFixedRatio.terminal1) annotation(
    Line(points = {{-8, 18}, {20, 18}, {20, 0}}, color = {0, 0, 255}));
  connect(transformerFixedRatio.terminal1, dynamicLine1.terminal2) annotation(
    Line(points = {{20, 0}, {20, -20}, {-8, -20}}, color = {0, 0, 255}));
  connect(dynamicLine.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-28, 18}, {-62, 18}, {-62, -2}}, color = {0, 0, 255}));
  connect(dynamicLine1.terminal1, infiniteBus.terminal) annotation(
    Line(points = {{-28, -20}, {-62, -20}, {-62, -2}}, color = {0, 0, 255}));
  connect(transformerFixedRatio.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{40, 0}, {80, 0}}, color = {0, 0, 255}));
end SMIBdynamicLineTest;
