within Dynawo.Examples.SMIB.Standard;

model TwoMachines
  import Dynawo;
  import Modelica;
  extends Icons.Example;

  parameter Types.ActivePowerPu PLoadPu = 15.8263;
  parameter Types.ReactivePowerPu QLoadPu = -1.95242;
  parameter Real A = 2;
  parameter Real B = 2;

  // OmegaRefPu;

  parameter Real gen1_P = 0.5 ;
  parameter Real gen2_P = 0.5 ;

  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous1(Ce0Pu = 0.903, Cm0Pu = 0.903, Cos2Eta0 = 0.68888, DPu = 0, Efd0Pu = 2.4659, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 3.5, IRotor0Pu = 2.4659, IStator0Pu = 22.2009, Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262, LDPPu = 0.16634, LQ1PPu = 0.92815, LQ2PPu = 0.12046, LambdaAD0Pu = 0.89347, LambdaAQ0Pu = -0.60044, LambdaAirGap0Pu = 1.0764, LambdaD0Pu = 0.89243, LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458, Lambdaq0Pu = -0.65934, LdPPu = 0.15, LfPPu = 0.16990, LqPPu = 0.15, MdPPu = 1.66, MdSat0PPu = 1.5792, Mds0Pu = 1.5785, Mi0Pu = 1.5637, MqPPu = 1.61, MqSat0PPu = 1.5292, Mqs0Pu = 1.530930, MrcPPu = 0, MsalPu = 0.05, P0Pu = -19.98, PGen0Pu = 19.98, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.903, Q0Pu = -9.68, QGen0Pu = 9.6789, QStator0Pu = 9.6789, RDPPu = 0.03339, RQ1PPu = 0.00924, RQ2PPu = 0.02821, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.00074, SNom = 2220, Sin2Eta0 = 0.31111, SnTfo = 2220, Theta0 = 1.2107, ThetaInternal0 = 0.71622, U0Pu = 1, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, UPhase0 = 0.494442, UStator0Pu = 1, Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434, XTfPu = 0, md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {-60, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));

  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous2(Ce0Pu = 0.903, Cm0Pu = 0.903, Cos2Eta0 = 0.68888, DPu = 0, Efd0Pu = 2.4659, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 3.5, IRotor0Pu = 2.4659, IStator0Pu = 22.2009, Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262, LDPPu = 0.16634, LQ1PPu = 0.92815, LQ2PPu = 0.12046, LambdaAD0Pu = 0.89347, LambdaAQ0Pu = -0.60044, LambdaAirGap0Pu = 1.0764, LambdaD0Pu = 0.89243, LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458, Lambdaq0Pu = -0.65934, LdPPu = 0.15, LfPPu = 0.16990, LqPPu = 0.15, MdPPu = 1.66, MdSat0PPu = 1.5792, Mds0Pu = 1.5785, Mi0Pu = 1.5637, MqPPu = 1.61, MqSat0PPu = 1.5292, Mqs0Pu = 1.530930, MrcPPu = 0, MsalPu = 0.05, P0Pu = -19.98, PGen0Pu = 19.98, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.903, Q0Pu = -9.68, QGen0Pu = 9.6789, QStator0Pu = 9.6789, RDPPu = 0.03339, RQ1PPu = 0.00924, RQ2PPu = 0.02821, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.00074, SNom = 2220, Sin2Eta0 = 0.31111, SnTfo = 2220, State0 = Dynawo.Electrical.Constants.state.Undefined, Theta0 = 1.2107, ThetaInternal0 = 0.71622, U0Pu = 1, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, UPhase0 = 0.494442, UStator0Pu = 1, Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434, XTfPu = 0, md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {60, 20}, extent = {{12, -12}, {-12, 12}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional goverProportional(KGover = 2, PMax = 3000, PMin = 0, PNom = 2000, Pm0Pu = generatorSynchronous1.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, -20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportionalIntegral vRProportionalIntegral(Efd0Pu = generatorSynchronous1.Efd0Pu, EfdMaxPu = 5, EfdMinPu = -5, Gain = 20, LagEfdMax = 0, LagEfdMin = 0, Us0Pu = generatorSynchronous1.U0Pu, UsRef0Pu = generatorSynchronous1.U0Pu, UsRefMaxPu = 5, UsRefMinPu = -5, tIntegral = 1, yIntegrator0 = generatorSynchronous1.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-62, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant PmRefPu(k = generatorSynchronous1.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-91, -17}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous1.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-92, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = generatorSynchronous2.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {92, 54}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportionalIntegral vRProportionalIntegral1(Efd0Pu = generatorSynchronous2.Efd0Pu, EfdMaxPu = 5, EfdMinPu = -5, Gain = 20, LagEfdMax = 0, LagEfdMin = 0, Us0Pu = generatorSynchronous2.U0Pu, UsRef0Pu = generatorSynchronous2.U0Pu, UsRefMaxPu = 5, UsRefMinPu = -5, tIntegral = 1, yIntegrator0 = generatorSynchronous2.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {58, 54}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = generatorSynchronous2.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {92, -16}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional goverProportional1(KGover = 2, PMax = 3000, PMin = 0, PNom = 2000, Pm0Pu = generatorSynchronous2.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, -20}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0.0000375, GPu = 0, XPu = 0.03370, RPu = 0.016854) annotation(
    Placement(visible = true, transformation(origin = {-18, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line1(BPu = 0.0000375, GPu = 0, XPu = 0.03370, RPu = 0.016854) annotation(
    Placement(visible = true, transformation(origin = {22, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.0001, XPu = 0.001, tBegin = 1, tEnd = 1.4)  annotation(
    Placement(visible = true, transformation(origin = {0, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta loadAlphaBeta(alpha = 2, beta = 2, u0Pu = Complex(1, 0))  annotation(
    Placement(visible = true, transformation(origin = {-8, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = 2) annotation(
    Placement(visible = true, transformation(origin = {-15, -83}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant constant3(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-3, -83}, extent = {{-5, -5}, {5, 5}}, rotation = 90)));
equation
  generatorSynchronous1.omegaRefPu.value =  gen1_P * generatorSynchronous1.omegaPu.value + gen2_P * generatorSynchronous2.omegaPu.value ;
  generatorSynchronous2.omegaRefPu.value = gen1_P * generatorSynchronous1.omegaPu.value + gen2_P * generatorSynchronous2.omegaPu.value ;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  loadAlphaBeta.switchOffSignal1.value = false;
  loadAlphaBeta.switchOffSignal2.value = false;
  generatorSynchronous1.switchOffSignal1.value = false;
  generatorSynchronous1.switchOffSignal2.value = false;
  generatorSynchronous1.switchOffSignal3.value = false;
  generatorSynchronous2.switchOffSignal1.value = false;
  generatorSynchronous2.switchOffSignal2.value = false;
  generatorSynchronous2.switchOffSignal3.value = false;

  connect(PmRefPu.y, goverProportional.PmRefPu) annotation(
    Line(points = {{-83, -17}, {-69, -17}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral.UsRefPu, UsRefPu.y) annotation(
    Line(points = {{-71, 54}, {-85, 54}}, color = {0, 0, 127}));
  connect(goverProportional.PmPu, generatorSynchronous1.PmPu_in) annotation(
    Line(points = {{-54, -20}, {-52, -20}, {-52, 10}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral.EfdPu, generatorSynchronous1.efdPu_in) annotation(
    Line(points = {{-54, 54}, {-48, 54}, {-48, 40}, {-80, 40}, {-80, 0}, {-68, 0}, {-68, 10}}, color = {0, 0, 127}));
  connect(generatorSynchronous1.omegaPu_out, goverProportional.omegaPu) annotation(
    Line(points = {{-50, 16}, {-40, 16}, {-40, -40}, {-80, -40}, {-80, -24}, {-70, -24}}, color = {0, 0, 127}));
  connect(generatorSynchronous1.UsPu_out, vRProportionalIntegral.UsPu) annotation(
    Line(points = {{-50, 30}, {-40, 30}, {-40, 42}, {-80, 42}, {-80, 52}, {-66, 52}}, color = {0, 0, 127}));
  connect(constant1.y, vRProportionalIntegral1.UsRefPu) annotation(
    Line(points = {{86, 54}, {66, 54}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral1.UsPu, generatorSynchronous2.UsPu_out) annotation(
    Line(points = {{62, 52}, {70, 52}, {70, 40}, {40, 40}, {40, 30}, {50, 30}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral1.EfdPu, generatorSynchronous2.efdPu_in) annotation(
    Line(points = {{50, 54}, {40, 54}, {40, 42}, {80, 42}, {80, 0}, {68, 0}, {68, 10}}, color = {0, 0, 127}));
  connect(constant2.y, goverProportional1.PmRefPu) annotation(
    Line(points = {{85, -16}, {70, -16}}, color = {0, 0, 127}));
  connect(goverProportional1.omegaPu, generatorSynchronous2.omegaPu_out) annotation(
    Line(points = {{70, -24}, {80, -24}, {80, -40}, {40, -40}, {40, 16}, {50, 16}}, color = {0, 0, 127}));
  connect(goverProportional1.PmPu, generatorSynchronous2.PmPu_in) annotation(
    Line(points = {{54, -20}, {52, -20}, {52, 10}}, color = {0, 0, 127}));
  connect(generatorSynchronous1.terminal, line.terminal1) annotation(
    Line(points = {{-60, 20}, {-28, 20}}, color = {0, 0, 255}));
  connect(generatorSynchronous2.terminal, line1.terminal2) annotation(
    Line(points = {{60, 20}, {32, 20}}, color = {0, 0, 255}));
  connect(line.terminal2, line1.terminal1) annotation(
    Line(points = {{-8, 20}, {12, 20}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line.terminal1) annotation(
    Line(points = {{0, 60}, {0, 31}, {-28, 31}, {-28, 20}}, color = {0, 0, 255}));
  connect(loadAlphaBeta.terminal, line.terminal2) annotation(
    Line(points = {{-8, -18}, {-8, 20}}, color = {0, 0, 255}));
  connect(constant3.y, loadAlphaBeta.QRefPu) annotation(
    Line(points = {{-3, -77.5}, {-2, -77.5}, {-2, -26}}, color = {0, 0, 127}));
  connect(const1.y, loadAlphaBeta.PRefPu) annotation(
    Line(points = {{-15, -77.5}, {-14, -77.5}, {-14, -26}}, color = {0, 0, 127}));
end TwoMachines;
