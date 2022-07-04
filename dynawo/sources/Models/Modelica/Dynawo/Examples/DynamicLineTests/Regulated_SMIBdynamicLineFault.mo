within Dynawo.Examples.DynamicLineTests;

model Regulated_SMIBdynamicLineFault"Node fault on a line for SMIB model with dynamic lines"
  import Dynawo;
  import Modelica;

  extends Icons.Example;

  parameter Real x = 0.75 "Emplacement of the fault relative to the line lenght : x= default location /line lenght";
  parameter Real theta_seuil = Modelica.Constants.pi * 270 / 180 "Maximum value of theta for a stable configuration in rad";
  parameter Types.Time deltat = 0.2 "Fault duration in seconds";
  parameter Real tbegin = 1 "Start time for the node fault";

  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(Ce0Pu = 0.903, Cm0Pu = 0.903, Cos2Eta0 = 0.68888, DPu = 0, Efd0Pu = 2.4659, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 3.5, IRotor0Pu = 2.4659, IStator0Pu = 22.2009, Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262, LDPPu = 0.16634, LQ1PPu = 0.92815, LQ2PPu = 0.12046, LambdaAD0Pu = 0.89347, LambdaAQ0Pu = -0.60044, LambdaAirGap0Pu = 1.0764, LambdaD0Pu = 0.89243, LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458, Lambdaq0Pu = -0.65934, LdPPu = 0.15, LfPPu = 0.16990, LqPPu = 0.15, MdPPu = 1.66, MdSat0PPu = 1.5792, Mds0Pu = 1.5785, Mi0Pu = 1.5637, MqPPu = 1.61, MqSat0PPu = 1.5292, Mqs0Pu = 1.530930, MrcPPu = 0, MsalPu = 0.05, P0Pu = -19.98, PGen0Pu = 19.98, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.903, Q0Pu = -9.68, QGen0Pu = 9.6789, QStator0Pu = 9.6789, RDPPu = 0.03339, RQ1PPu = 0.00924, RQ2PPu = 0.02821, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.00074, SNom = 2220, Sin2Eta0 = 0.31111, SnTfo = 2220, Theta0 = 1.2107, ThetaInternal0 = 0.71622, U0Pu = 1, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, UPhase0 = 0.494442, UStator0Pu = 1, Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434, XTfPu = 0, md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {86, -28}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {60, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Electrical.Lines.DynamicLine line2(CPu = 0.0000375, GPu = 0, LPu = 0.0375, RPu = 0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), iGC10Pu = Complex(3.2352e-05, -3.626336e-06), iGC20Pu = Complex(3.330437e-05, 1.203307e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.86272, -0.0967023), u20Pu = Complex(0.8881162, 0.3208823)) annotation(
      Placement(visible = true, transformation(origin = {-14, 0}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine line1(CPu = (1 - x) * 0.0000375, GPu = 0, LPu = (1 - x) * 0.0375, RPu = (1 - x) * 0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), iGC10Pu = Complex(3.2352e-05, -3.626336e-06), iGC20Pu = Complex(3.330437e-05, 1.203307e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.86272, -0.0967023), u20Pu = Complex(0.869069, 0.007693398)) annotation(
      Placement(visible = true, transformation(origin = {-34, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));

  Dynawo.Electrical.Lines.DynamicLine line3(CPu = x * 0.0000375, GPu = 0, LPu = x * 0.0375, RPu = x * 0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), iGC10Pu = Complex(3.2352e-05, -3.626336e-06), iGC20Pu = Complex(3.330437e-05, 1.203307e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.869069, 0.007693398), u20Pu = Complex(0.8881162, 0.3208823)) annotation(
    Placement(visible = true, transformation(origin = {24, 60}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));


  Modelica.Blocks.Sources.Constant PmRefPu(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UsRefPu(k = generatorSynchronous.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-70, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional goverProportional(KGover = 1, PMax = 3000, PMin = 0, PNom = 2000, Pm0Pu = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {-6, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified.VRProportionalIntegral vRProportionalIntegral(Efd0Pu = generatorSynchronous.Efd0Pu, EfdMaxPu = 5, EfdMinPu = -5, Gain = 20, LagEfdMax = 0, LagEfdMin = 0, Us0Pu = generatorSynchronous.U0Pu, UsRef0Pu = generatorSynchronous.U0Pu, UsRefMaxPu = 5, UsRefMinPu = -5, tIntegral = 1, yIntegrator0 = generatorSynchronous.Efd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-12, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.0001, XPu = 0.0001, tBegin = tbegin, tEnd = tbegin + deltat) annotation(
    Placement(visible = true, transformation(origin = {-16, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = -18.96118, UPu = 0.8681228) annotation(
    Placement(visible = true, transformation(origin = {-80, 30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  line1.omegaPu = generatorSynchronous.omegaRefPu.value;
  line2.omegaPu = generatorSynchronous.omegaRefPu.value;
  line3.omegaPu = generatorSynchronous.omegaRefPu.value;
  assert(generatorSynchronous.theta < Modelica.Constants.pi * 270 / 180, "temps critique atteint");
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
  connect(generatorSynchronous.omegaRefPu, Omega0Pu.setPoint);
  connect(line1.terminal2, line3.terminal1) annotation(
    Line(points = {{-18, 60}, {8, 60}}, color = {0, 0, 255}));
 connect(line3.terminal2, transformer.terminal1) annotation(
    Line(points = {{40, 60}, {40, 30}}, color = {0, 0, 255}));
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
    Line(points = {{40, 30}, {40, 0}, {0, 0}}, color = {0, 0, 255}));
 connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{80, 30}, {86, 30}, {86, -28}}, color = {0, 0, 255}));
  connect(goverProportional.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{6, -36}, {76, -36}, {76, -35}}, color = {0, 0, 127}));
  connect(nodeFault.terminal, line3.terminal1) annotation(
    Line(points = {{-16, 94}, {8, 94}, {8, 60}}, color = {0, 0, 255}));
 connect(line1.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-50, 60}, {-60, 60}, {-60, 30}, {-80, 30}}, color = {0, 0, 255}));
 connect(line2.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-28, 0}, {-60, 0}, {-60, 30}, {-80, 30}}, color = {0, 0, 255}));


    annotation( preferredView = "text", experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06),
    Documentation(info = "<html><head></head><body>The purpose of this test case is to evaluate the transient stability of an regulated SMIB model with dynamic lines, using a governor for frequency regulation and a PI for voltage regulation, by evaluating the rotor angle Theta for a node fault starting at (t_begin = 1 s) and (t_end = t_begin + delta_t).
    The following figures show the excepted evolution of the generator rotor angle a if delta_t < CCT (the critical clearing time).

    <figure>
    <img width=\"400\" src=\"modelica://Dynawo/Examples/DynamicLineTests/Images/regultheta.png\">
    </figure>
The results show that for the same parameters used for SMIBdynamicLineFault, the CCT is higher for the regulated SMIB.
For delta_t > CCT, we represent the loss of synchronism with an assert stopping the simulation if theta exceeds 270 degrees.
    </body></html>"));
end Regulated_SMIBdynamicLineFault;
