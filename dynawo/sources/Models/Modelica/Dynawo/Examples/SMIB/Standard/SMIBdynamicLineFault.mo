within Dynawo.Examples.SMIB.Standard;

model SMIBdynamicLineFault
  import Dynawo;
  extends Icons.Example;
  parameter Real x = 0.5;
  parameter Types.Angle th0 = 1.21;
  parameter Real Pe0 = 1998;
  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronous generatorSynchronous(Ce0Pu = 0.903, Cm0Pu = 0.903, Cos2Eta0 = 0.68888, DPu = 0, Efd0Pu = 2.4659, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 3.5, IRotor0Pu = 2.4659, IStator0Pu = 22.2009, Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262, LDPPu = 0.16634, LQ1PPu = 0.92815, LQ2PPu = 0.12046, LambdaAD0Pu = 0.89347, LambdaAQ0Pu = -0.60044, LambdaAirGap0Pu = 1.0764, LambdaD0Pu = 0.89243, LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458, Lambdaq0Pu = -0.65934, LdPPu = 0.15, LfPPu = 0.16990, LqPPu = 0.15, MdPPu = 1.66, MdSat0PPu = 1.5792, Mds0Pu = 1.5785, Mi0Pu = 1.5637, MqPPu = 1.61, MqSat0PPu = 1.5292, Mqs0Pu = 1.530930, MrcPPu = 0, MsalPu = 0.05, P0Pu = -19.98, PGen0Pu = 19.98, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.903, Q0Pu = -9.68, QGen0Pu = 9.6789, QStator0Pu = 9.6789, RDPPu = 0.03339, RQ1PPu = 0.00924, RQ2PPu = 0.02821, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.00074, SNom = 2220, Sin2Eta0 = 0.31111, SnTfo = 2220, Theta0 = 1.2107, ThetaInternal0 = 0.71622, U0Pu = 1, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, UPhase0 = 0.494442, UStator0Pu = 1, Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434, XTfPu = 0, md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {92, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {46, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPhase = -0.107179, UPu = 0.868122) annotation(
    Placement(visible = true, transformation(origin = {-92, 6}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Basics.Step PmPu(Value0 = 0.903, Height = 0.02, tStep = 1000);
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Basics.SetPoint EfdPu(Value0 = 2.4659);
    Dynawo.Electrical.Lines.dynamicLine line2(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375, Iz0Pu=-11.1008, Iz0Phase=0.0433, I10Pu=-11.1008, I10Phase= 0.0433, I20Pu=11.1008, I20Phase= 0.0433, U10Pu=0.868122, U10Phase =-0.107179, U20Pu = 0.944307, U20Phase = 0.351159 ) annotation(
      Placement(visible = true, transformation(origin = {-28, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Dynawo.Electrical.Lines.dynamicLine line1(BPu = (1-x)*0.0000375, GPu = 0, RPu = (1-x)*0.00375, XPu = (1-x)*0.0375,Iz0Pu=-11.1008, Iz0Phase=0.0433, I10Pu=-11.1008, I10Phase= 0.0433, I20Pu=11.1008, I20Phase= 0.0433, U10Pu=0.868122, U10Phase =-0.107179, U20Pu = 0.882565, U20Phase = 0.131795) annotation(
      Placement(visible = true, transformation(origin = {-60, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
    Dynawo.Electrical.Lines.dynamicLine line3(BPu = x*0.0000375 , GPu = 0, RPu = x*0.00375 , XPu = x*0.0375,Iz0Pu=-11.1008, Iz0Phase=0.0433, I10Pu=-11.1008, I10Phase= 0.0433, I20Pu=11.1008, I20Phase= 0.0433, U10Pu=0.882565, U10Phase =0.131795, U20Pu = 0.944307, U20Phase = 0.351159 ) annotation(
      Placement(visible = true, transformation(origin = {-8, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
//  Dynawo.Electrical.Lines.Line line2(BPu = 0.0000375, GPu = 0, RPu = 0.00375, XPu = 0.0375) annotation(
//    Placement(visible = true, transformation(origin = {-28, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
//  Dynawo.Electrical.Lines.Line line1(BPu = (1 - x) * 0.0000375, GPu = 0, RPu = (1 - x) * 0.00375, XPu = (1 - x) * 0.0375) annotation(
//    Placement(visible = true, transformation(origin = {-60, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
//  Dynawo.Electrical.Lines.Line line3(BPu = x * 0.0000375, GPu = 0, RPu = x * 0.00375, XPu = x * 0.0375) annotation(
//    Placement(visible = true, transformation(origin = {-8, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.00001, XPu = 0.00001, tBegin = 1, tEnd = 1.2) annotation(
    Placement(visible = true, transformation(origin = {-28, 64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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
  connect(infiniteBus.terminal, line1.terminal1) annotation(
    Line(points = {{-92, 6}, {-92, 30}, {-80, 30}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, line2.terminal1) annotation(
    Line(points = {{-92, 6}, {-92, -20}, {-48, -20}}, color = {0, 0, 255}));
  connect(line1.terminal2, line3.terminal1) annotation(
    Line(points = {{-40, 30}, {-28, 30}}, color = {0, 0, 255}));
  connect(line3.terminal2, transformer.terminal1) annotation(
    Line(points = {{12, 30}, {26, 30}, {26, 0}}, color = {0, 0, 255}));
  connect(line2.terminal2, transformer.terminal1) annotation(
    Line(points = {{-8, -20}, {26, -20}, {26, 0}}, color = {0, 0, 255}));
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{66, 0}, {92, 0}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line3.terminal1) annotation(
    Line(points = {{-28, 64}, {-28, 30}}, color = {0, 0, 255}));
  annotation(
    experiment(StartTime = 0, StopTime = 3, Tolerance = 0.0001, Interval = 0.001));
end SMIBdynamicLineFault;
