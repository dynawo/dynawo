within Dynawo.Examples.DynamicLineTests;

model TwoMachines
  import Dynawo;
  import Modelica;
  extends Icons.Example;
  // OmegaRefPu;
  // You can go back to a two machines model by removing the generatorSynchronous3 connection to the network and fixing gen3_P = 0
  // Ps : gen1_P + gen2_P + gen3_P should be equal to 1
  parameter Real x = 0.5;
  parameter Real tbegin = 1;
  parameter Real tend = 1.4;
  parameter Real a = 1;
  parameter Real gen1_P = 1/3;
  parameter Real gen2_P = 1/3;
  parameter Real gen3_P = 1/3;
  Modelica.Blocks.Sources.Constant PmRefPu(k = 0.718) annotation(
    Placement(visible = true, transformation(origin = {-119, 21}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous1.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-122, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = generatorSynchronous2.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {104, 52}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant2(k = 0.718) annotation(
    Placement(visible = true, transformation(origin = {118, 20}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional goverProportional1(KGover = 1, PMax = 8000, PMin = 0, PNom = 2000, Pm0Pu = generatorSynchronous2.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {86, -20}, extent = {{6, -6}, {-6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional goverProportional(KGover = 1, PMax = 8000, PMin = 0, PNom = 2000, Pm0Pu = generatorSynchronous1.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-90, -20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k = 10.6699) annotation(
    Placement(visible = true, transformation(origin = {-46, -46}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadAlphaBeta loadAlphaBeta(alpha = 2, beta = 2, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constant4(k = -1.45988) annotation(
    Placement(visible = true, transformation(origin = {-46, -74}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous1(Ce0Pu = 0.76, Cm0Pu = 0.8, Cos2Eta0 = 0.459383, DPu = 0, Efd0Pu = 1.81724, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 4, IRotor0Pu = 1.81724, IStator0Pu = 3.8, Id0Pu = -0.613552, If0Pu = 0.982291, Iq0Pu = -0.448503, LDPPu = 0.19063, LQ1PPu = 0.51659, LQ2PPu = 0.24243, LambdaAD0Pu = 0.682168, LambdaAQ0Pu = -0.740029, LambdaAirGap0Pu = 1.00648, LambdaD0Pu = 0.682168, LambdaQ10Pu = -0.740029, LambdaQ20Pu = -0.740029, Lambdad0Pu = 0.590135, Lambdaf0Pu = 0.902397, Lambdaq0Pu = -0.807305, LdPPu = 0.20, LfPPu = 0.2242 * a, LqPPu = 0.15 / a, MdPPu = 1.85, MdSat0PPu = 1.85, Mds0Pu = 1.85, Mi0Pu = 1.74188, MqPPu = 1.65 / a, MqSat0PPu = 1.65, Mqs0Pu = 1.65, MrcPPu = 0, MsalPu = 0.2, P0Pu = -3.8, PGen0Pu = 3.8, PNomAlt = 475, PNomTurb = 475, Pm0Pu = 0.26, Q0Pu = 0, QGen0Pu = 0, QStator0Pu = 0, RDPPu = 0.02933, RQ1PPu = 0.0035, RQ2PPu = 0.02227, RTfPu = 0, RaPPu = 0, RfPPu = 0.00128 * a, SNom = 500, Sin2Eta0 = 0.540617, SnTfo = 500, State0 = Dynawo.Electrical.Constants.state.Open, Theta0 = 0.93957, ThetaInternal0 = 0.93957, U0Pu = 1, UBaseHV = 400, UBaseLV = 21, UNom = 21, UNomHV = 400, UNomLV = 21, UPhase0 = 0, UStator0Pu = 1, Ud0Pu = 0.807305, Uf0Pu = 0.00125733, Uq0Pu = 0.590135, XTfPu = 0, i0Pu = Complex(-3.8, 0), md = 0, mq = 0, nd = 0, nq = 0, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {-86, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  /*
            Dynawo.Electrical.Lines.Line line3(BPu = 0.0000375, GPu = 0, RPu = x * 0.016854, XPu = x * 0.03370) annotation(
              Placement(visible = true, transformation(origin = {-44, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
          Dynawo.Electrical.Lines.Line line1(BPu = 0.0000375, GPu = 0, RPu = 0.016854, XPu = 0.03370) annotation(
              Placement(visible = true, transformation(origin = {28, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

          Dynawo.Electrical.Lines.Line line(BPu = 0.0000375, GPu = 0, RPu = (1 - x) * 0.016854, XPu = (1 - x) * 0.03370) annotation(
            Placement(visible = true, transformation(origin = {-12, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  */
  Dynawo.Electrical.Lines.DynamicLine line1(CPu = 0.0000375, GPu = 0, LPu = 0.03370, RPu = 0.016854, i10Pu = Complex(3.40865, 0.197732), i20Pu = Complex(-3.40865, -0.197658), iRL0Pu = Complex(3.40865, 0.197732), u10Pu = Complex(0.948241, -0.0741945), u20Pu = Complex(0.999032, 0.0440068)) annotation(
    Placement(visible = true, transformation(origin = {28, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine line(CPu = 0.0000375, GPu = 0, LPu = x * 0.03370, RPu = x * 0.016854, i10Pu = Complex(3.40865, 0.197732), i20Pu = Complex(-3.40865, -0.197658), iRL0Pu = Complex(3.40865, 0.197732), u10Pu = Complex(0.973636, -0.0150933), u20Pu = Complex(0.948241, -0.0741945)) annotation(
    Placement(visible = true, transformation(origin = {-10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine line3(CPu = 0.0000375, GPu = 0, LPu = (1 - x) * 0.03370, RPu = (1 - x) * 0.016854, i10Pu = Complex(3.40865, 0.197732), i20Pu = Complex(-3.40865, -0.197658), iRL0Pu = Complex(3.40865, 0.197732), u10Pu = Complex(0.999029, 0.0440084), u20Pu = Complex(0.973636, -0.0150933)) annotation(
    Placement(visible = true, transformation(origin = {-44, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.0001, XPu = 0.0001, tBegin = tbegin, tEnd = tend) annotation(
    Placement(visible = true, transformation(origin = {-18, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportionalIntegral vRProportionalIntegral(Efd0Pu = generatorSynchronous1.Efd0Pu, EfdMaxPu = 10, EfdMinPu = -10, Gain = 20, LagEfdMax = 0, LagEfdMin = 0, Us0Pu = generatorSynchronous1.U0Pu, UsRef0Pu = generatorSynchronous1.U0Pu, UsRefMaxPu = 10, UsRefMinPu = -10, tIntegral = 1, yIntegrator0 = generatorSynchronous1.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-90, 54}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportionalIntegral vRProportionalIntegral1(Efd0Pu = generatorSynchronous1.Efd0Pu, EfdMaxPu = 10, EfdMinPu = -10, Gain = 20, LagEfdMax = 0, LagEfdMin = 0, Us0Pu = generatorSynchronous1.U0Pu, UsRef0Pu = generatorSynchronous1.U0Pu, UsRefMaxPu = 10, UsRefMinPu = -10, tIntegral = 1, yIntegrator0 = generatorSynchronous1.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {70, 50}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous2(Ce0Pu = 0.76, Cm0Pu = 0.8, Cos2Eta0 = 0.459383, DPu = 0, Efd0Pu = 1.81724, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 4, IRotor0Pu = 1.81724, IStator0Pu = 3.8, Id0Pu = -0.613552, If0Pu = 0.982291, Iq0Pu = -0.448503, LDPPu = 0.19063, LQ1PPu = 0.51659, LQ2PPu = 0.24243, LambdaAD0Pu = 0.682168, LambdaAQ0Pu = -0.740029, LambdaAirGap0Pu = 1.00648, LambdaD0Pu = 0.682168, LambdaQ10Pu = -0.740029, LambdaQ20Pu = -0.740029, Lambdad0Pu = 0.590135, Lambdaf0Pu = 0.902397, Lambdaq0Pu = -0.807305, LdPPu = 0.20, LfPPu = 0.2242 * a, LqPPu = 0.15 / a, MdPPu = 1.85, MdSat0PPu = 1.85, Mds0Pu = 1.85, Mi0Pu = 1.74188, MqPPu = 1.65 / a, MqSat0PPu = 1.65, Mqs0Pu = 1.65, MrcPPu = 0, MsalPu = 0.2, P0Pu = -3.8, PGen0Pu = 3.8, PNomAlt = 475, PNomTurb = 475, Pm0Pu = 0.26, Q0Pu = 0, QGen0Pu = 0, QStator0Pu = 0, RDPPu = 0.02933, RQ1PPu = 0.0035, RQ2PPu = 0.02227, RTfPu = 0, RaPPu = 0, RfPPu = 0.00128 * a, SNom = 500, Sin2Eta0 = 0.540617, SnTfo = 500, State0 = Dynawo.Electrical.Constants.state.Open, Theta0 = 0.93957, ThetaInternal0 = 0.93957, U0Pu = 1, UBaseHV = 400, UBaseLV = 21, UNom = 21, UNomHV = 400, UNomLV = 21, UPhase0 = 0, UStator0Pu = 1, Ud0Pu = 0.807305, Uf0Pu = 0.00125733, Uq0Pu = 0.590135, XTfPu = 0, i0Pu = Complex(-3.8, 0), md = 0, mq = 0, nd = 0, nq = 0, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {74, 20}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous3(Ce0Pu = 0.76, Cm0Pu = 0.8, Cos2Eta0 = 0.459383, DPu = 0, Efd0Pu = 1.81724, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 4, IRotor0Pu = 1.81724, IStator0Pu = 3.8, Id0Pu = -0.613552, If0Pu = 0.982291, Iq0Pu = -0.448503, LDPPu = 0.19063, LQ1PPu = 0.51659, LQ2PPu = 0.24243, LambdaAD0Pu = 0.682168, LambdaAQ0Pu = -0.740029, LambdaAirGap0Pu = 1.00648, LambdaD0Pu = 0.682168, LambdaQ10Pu = -0.740029, LambdaQ20Pu = -0.740029, Lambdad0Pu = 0.590135, Lambdaf0Pu = 0.902397, Lambdaq0Pu = -0.807305, LdPPu = 0.20, LfPPu = 0.2242 * a, LqPPu = 0.15 / a, MdPPu = 1.85, MdSat0PPu = 1.85, Mds0Pu = 1.85, Mi0Pu = 1.74188, MqPPu = 1.65 / a, MqSat0PPu = 1.65, Mqs0Pu = 1.65, MrcPPu = 0, MsalPu = 0.2, P0Pu = -3.8, PGen0Pu = 3.8, PNomAlt = 475, PNomTurb = 475, Pm0Pu = 0.26, Q0Pu = 0, QGen0Pu = 0, QStator0Pu = 0, RDPPu = 0.02933, RQ1PPu = 0.0035, RQ2PPu = 0.02227, RTfPu = 0, RaPPu = 0, RfPPu = 0.00128 * a, SNom = 500, Sin2Eta0 = 0.540617, SnTfo = 500, State0 = Dynawo.Electrical.Constants.state.Open, Theta0 = 0.93957, ThetaInternal0 = 0.93957, U0Pu = 1, UBaseHV = 400, UBaseLV = 21, UNom = 21, UNomHV = 400, UNomLV = 21, UPhase0 = 0, UStator0Pu = 1, Ud0Pu = 0.807305, Uf0Pu = 0.00125733, Uq0Pu = 0.590135, XTfPu = 0, i0Pu = Complex(-3.8, 0), md = 0, mq = 0, nd = 0, nq = 0, u0Pu = Complex(1, 0)) annotation(
    Placement(visible = true, transformation(origin = {6, 114}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant5(k = generatorSynchronous1.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-48, 128}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant6(k = 0.718) annotation(
    Placement(visible = true, transformation(origin = {-73, 99}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportionalIntegral vRProportionalIntegral2(Efd0Pu = generatorSynchronous1.Efd0Pu, EfdMaxPu = 10, EfdMinPu = -10, Gain = 20, LagEfdMax = 0, LagEfdMin = 0, Us0Pu = generatorSynchronous1.U0Pu, UsRef0Pu = generatorSynchronous1.U0Pu, UsRefMaxPu = 10, UsRefMinPu = -10, tIntegral = 1, yIntegrator0 = generatorSynchronous1.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-24, 128}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional goverProportional2(KGover = 1, PMax = 8000, PMin = 0, PNom = 2000, Pm0Pu = generatorSynchronous2.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-32, 96}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Electrical.Lines.DynamicLine dynamicLine(CPu = 0.0000375, GPu = 0, LPu = 0.03370, RPu = 0.016854, i10Pu = Complex(3.40865, 0.197732), i20Pu = Complex(-3.40865, -0.197658), iRL0Pu = Complex(3.40865, 0.197732), u10Pu = Complex(0.948241, -0.0741945), u20Pu = Complex(0.999032, 0.0440068)) annotation(
    Placement(visible = true, transformation(origin = {18, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  assert(generatorSynchronous1.theta < Modelica.Constants.pi * 270 / 180, "temps critique atteint");
  assert(generatorSynchronous2.theta < Modelica.Constants.pi * 270 / 180, "temps critique atteint");
  assert(generatorSynchronous3.theta < Modelica.Constants.pi * 270 / 180, "temps critique atteint");
  generatorSynchronous1.omegaRefPu.value = gen1_P * generatorSynchronous1.omegaPu.value + gen2_P * generatorSynchronous2.omegaPu.value + gen3_P * generatorSynchronous3.omegaPu.value;
  generatorSynchronous2.omegaRefPu.value = gen1_P * generatorSynchronous1.omegaPu.value + gen2_P * generatorSynchronous2.omegaPu.value + gen3_P * generatorSynchronous3.omegaPu.value;
  generatorSynchronous3.omegaRefPu.value = gen1_P * generatorSynchronous1.omegaPu.value + gen2_P * generatorSynchronous2.omegaPu.value + gen3_P * generatorSynchronous3.omegaPu.value;
  line.omegaPu = generatorSynchronous1.omegaRefPu.value;
  line1.omegaPu = generatorSynchronous1.omegaRefPu.value;
  line3.omegaPu = generatorSynchronous1.omegaRefPu.value;
  dynamicLine.omegaPu = generatorSynchronous1.omegaRefPu.value;
  line1.switchOffSignal1.value = false;
  line1.switchOffSignal2.value = false;
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  dynamicLine.switchOffSignal1.value = false;
  dynamicLine.switchOffSignal2.value = false;
  line3.switchOffSignal1.value = false;
  line3.switchOffSignal2.value = false;
  loadAlphaBeta.switchOffSignal1.value = false;
  loadAlphaBeta.switchOffSignal2.value = false;
  generatorSynchronous1.switchOffSignal1.value = false;
  generatorSynchronous1.switchOffSignal2.value = false;
  generatorSynchronous1.switchOffSignal3.value = false;
  generatorSynchronous2.switchOffSignal1.value = false;
  generatorSynchronous2.switchOffSignal2.value = false;
  generatorSynchronous2.switchOffSignal3.value = false;
  generatorSynchronous3.switchOffSignal1.value = false;
  generatorSynchronous3.switchOffSignal2.value = false;
  generatorSynchronous3.switchOffSignal3.value = false;
  connect(constant2.y, goverProportional1.PmRefPu) annotation(
    Line(points = {{111.4, 20}, {101.4, 20}, {101.4, -16}, {95.4, -16}}, color = {0, 0, 127}));
  connect(PmRefPu.y, goverProportional.PmRefPu) annotation(
    Line(points = {{-111, 21}, {-107.3, 21}, {-107.3, -17}, {-97.3, -17}}, color = {0, 0, 127}));
  connect(goverProportional.omegaPu, generatorSynchronous1.omegaPu_out) annotation(
    Line(points = {{-99.6, -23.24}, {-107.6, -23.24}, {-107.6, -31.24}, {-67.6, -31.24}, {-67.6, 16}, {-75, 16}}, color = {0, 0, 127}));
  connect(goverProportional.PmPu, generatorSynchronous1.PmPu_in) annotation(
    Line(points = {{-83.04, -20}, {-79, -20}, {-79, 10}}, color = {0, 0, 127}));
  connect(constant3.y, loadAlphaBeta.PRefPu) annotation(
    Line(points = {{-40, -46}, {-18, -46}, {-18, -54}, {-8.5, -54}}, color = {0, 0, 127}));
  connect(loadAlphaBeta.QRefPu, constant4.y) annotation(
    Line(points = {{-8, -66}, {-18, -66}, {-18, -74}, {-40, -74}}, color = {0, 0, 127}));
  connect(line1.terminal1, loadAlphaBeta.terminal) annotation(
    Line(points = {{18, 20}, {18, -16}, {0, -16}, {0, -60}}, color = {0, 0, 255}));
  connect(line1.terminal1, line.terminal2) annotation(
    Line(points = {{18, 20}, {0, 20}}, color = {0, 0, 255}));
  connect(generatorSynchronous1.terminal, line3.terminal1) annotation(
    Line(points = {{-86, 20}, {-54, 20}}, color = {0, 0, 255}));
  connect(line3.terminal2, line.terminal1) annotation(
    Line(points = {{-34, 20}, {-20, 20}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line3.terminal2) annotation(
    Line(points = {{-18, 58}, {-18, 33}, {-34, 33}, {-34, 20}}, color = {0, 0, 255}));
  connect(UsRefPu.y, vRProportionalIntegral.UsRefPu) annotation(
    Line(points = {{-116, 54}, {-98, 54}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral.EfdPu, generatorSynchronous1.efdPu_in) annotation(
    Line(points = {{-82, 54}, {-76, 54}, {-76, 40}, {-102, 40}, {-102, 4}, {-94, 4}, {-94, 10}}, color = {0, 0, 127}));
  connect(generatorSynchronous1.UsPu_out, vRProportionalIntegral.UsPu) annotation(
    Line(points = {{-76, 30}, {-58, 30}, {-58, 44}, {-104, 44}, {-104, 52}, {-94, 52}}, color = {0, 0, 127}));
  connect(constant1.y, vRProportionalIntegral1.UsRefPu) annotation(
    Line(points = {{98, 52}, {86, 52}, {86, 72}, {42, 72}, {42, 50}, {62, 50}}, color = {0, 0, 127}));
  connect(line1.terminal2, generatorSynchronous2.terminal) annotation(
    Line(points = {{38, 20}, {74, 20}}, color = {0, 0, 255}));
  connect(vRProportionalIntegral1.EfdPu, generatorSynchronous2.efdPu_in) annotation(
    Line(points = {{78, 50}, {82, 50}, {82, 38}, {54, 38}, {54, 4}, {66, 4}, {66, 10}}, color = {0, 0, 127}));
  connect(goverProportional1.PmPu, generatorSynchronous2.PmPu_in) annotation(
    Line(points = {{80, -20}, {74, -20}, {74, 0}, {82, 0}, {82, 10}}, color = {0, 0, 127}));
  connect(generatorSynchronous2.omegaPu_out, goverProportional1.omegaPu) annotation(
    Line(points = {{84, 16}, {96, 16}, {96, -12}, {108, -12}, {108, -24}, {96, -24}}, color = {0, 0, 127}));
  connect(generatorSynchronous2.UsPu_out, vRProportionalIntegral1.UsPu) annotation(
    Line(points = {{84, 30}, {88, 30}, {88, 42}, {54, 42}, {54, 48}, {66, 48}}, color = {0, 0, 127}));
  connect(constant6.y, goverProportional2.PmRefPu) annotation(
    Line(points = {{-65, 99}, {-48, 99}, {-48, 100}, {-40, 100}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral2.UsRefPu, constant5.y) annotation(
    Line(points = {{-33, 128}, {-42, 128}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral2.EfdPu, generatorSynchronous3.efdPu_in) annotation(
    Line(points = {{-16, 128}, {-10, 128}, {-10, 96}, {-2, 96}, {-2, 104}}, color = {0, 0, 127}));
  connect(goverProportional2.PmPu, generatorSynchronous3.PmPu_in) annotation(
    Line(points = {{-26, 96}, {-12, 96}, {-12, 94}, {14, 94}, {14, 104}}, color = {0, 0, 127}));
  connect(generatorSynchronous3.omegaPu_out, goverProportional2.omegaPu) annotation(
    Line(points = {{16, 110}, {28, 110}, {28, 82}, {-52, 82}, {-52, 92}, {-42, 92}}, color = {0, 0, 127}));
  connect(vRProportionalIntegral2.UsPu, generatorSynchronous3.UsPu_out) annotation(
    Line(points = {{-28, 126}, {-34, 126}, {-34, 116}, {-6, 116}, {-6, 134}, {28, 134}, {28, 124}, {16, 124}}, color = {0, 0, 127}));
  connect(dynamicLine.terminal2, generatorSynchronous3.terminal) annotation(
    Line(points = {{28, 44}, {36, 44}, {36, 112}, {6, 112}, {6, 114}}, color = {0, 0, 255}));
  connect(dynamicLine.terminal1, line1.terminal1) annotation(
    Line(points = {{8, 44}, {8, 28}, {18, 28}, {18, 20}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-150, -150}, {150, 150}})),
    Icon(coordinateSystem(extent = {{-150, -150}, {150, 150}})));
end TwoMachines;
