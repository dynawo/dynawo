within Dynawo.Examples.DynamicLineTests;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model AdvancedRegulated_SMIB "Node fault on a line for an advanced regulated SMIB model with dynamic lines"

  import Dynawo;
  import Modelica;

  extends Icons.Example;

  parameter Real x = 0.5 "Emplacement of the fault relative to the line lenght : x= default location /line lenght";
  parameter Real theta_seuil = Modelica.Constants.pi * 270 / 180 "Maximum value of theta for a stable configuration in rad";
  parameter Types.Time deltat = 0.335 "Fault duration in seconds";
  parameter Real tbegin = 1 "Start time for the node fault";

  Dynawo.Examples.BaseClasses.GeneratorSynchronousInterfaces generatorSynchronous(Ce0Pu = 0.903, Cm0Pu = 0.903, Cos2Eta0 = 0.68888, DPu = 0, Efd0Pu = 2.4659, ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NominalStatorVoltageNoLoad, H = 3.5, IRotor0Pu = 2.4659, IStator0Pu = 22.2009, Id0Pu = -0.91975, If0Pu = 1.4855, Iq0Pu = -0.39262, LDPPu = 0.16634, LQ1PPu = 0.92815, LQ2PPu = 0.12046, LambdaAD0Pu = 0.89347, LambdaAQ0Pu = -0.60044, LambdaAirGap0Pu = 1.0764, LambdaD0Pu = 0.89243, LambdaQ10Pu = -0.60044, LambdaQ20Pu = -0.60044, Lambdad0Pu = 0.75547, Lambdaf0Pu = 1.1458, Lambdaq0Pu = -0.65934, LdPPu = 0.15, LfPPu = 0.16990, LqPPu = 0.15, MdPPu = 1.66, MdSat0PPu = 1.5792, Mds0Pu = 1.5785, Mi0Pu = 1.5637, MqPPu = 1.61, MqSat0PPu = 1.5292, Mqs0Pu = 1.530930, MrcPPu = 0, MsalPu = 0.05, P0Pu = -19.98, PGen0Pu = 19.98, PNomAlt = 2200, PNomTurb = 2220, Pm0Pu = 0.903, Q0Pu = -9.68, QGen0Pu = 9.6789, QStator0Pu = 9.6789, RDPPu = 0.03339, RQ1PPu = 0.00924, RQ2PPu = 0.02821, RTfPu = 0, RaPPu = 0.003, RfPPu = 0.00074, SNom = 2220, Sin2Eta0 = 0.31111, SnTfo = 2220, Theta0 = 1.2107, ThetaInternal0 = 0.71622, U0Pu = 1, UBaseHV = 24, UBaseLV = 24, UNom = 24, UNomHV = 24, UNomLV = 24, UPhase0 = 0.494442, UStator0Pu = 1, Ud0Pu = 0.65654, Uf0Pu = 0.00109, Uq0Pu = 0.75434, XTfPu = 0, md = 0.031, mq = 0.031, nd = 6.93, nq = 6.93) annotation(
    Placement(visible = true, transformation(origin = {84, 20}, extent = {{-12, -12}, {12, 12}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio transformer(BPu = 0, GPu = 0, RPu = 0, XPu = 0.00675, rTfoPu = 1) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine line2(CPu = 0.0000375, GPu = 0, LPu = 0.0375, RPu = 0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), iGC10Pu = Complex(3.2352e-05, -3.626336e-06), iGC20Pu = Complex(3.330437e-05, 1.203307e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.86272, -0.0967023), u20Pu = Complex(0.8881162, 0.3208823)) annotation(
          Placement(visible = true, transformation(origin = {-16, 20}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine line1(CPu = (1 - x) * 0.0000375, GPu = 0, LPu = (1 - x) * 0.0375, RPu = (1 - x) * 0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), iGC10Pu = Complex(3.2352e-05, -3.626336e-06), iGC20Pu = Complex(3.330437e-05, 1.203307e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.86272, -0.0967023), u20Pu = Complex(0.869069, 0.007693398)) annotation(
          Placement(visible = true, transformation(origin = {-36, 80}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Lines.DynamicLine line3(CPu = x * 0.0000375, GPu = 0, LPu = x * 0.0375, RPu = x * 0.00375, i10Pu = Complex(-11.09235, -0.4320015), i20Pu = Complex(11.09241, 0.4320099), iGC10Pu = Complex(3.2352e-05, -3.626336e-06), iGC20Pu = Complex(3.330437e-05, 1.203307e-05), iRL0Pu = Complex(-11.09238, -0.4319979), u10Pu = Complex(0.869069, 0.007693398), u20Pu = Complex(0.8881162, 0.3208823)) annotation(
        Placement(visible = true, transformation(origin = {22, 80}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Dynawo.Electrical.Controls.Basics.SetPoint Omega0Pu(Value0 = 1);
  Dynawo.Electrical.Events.NodeFault nodeFault(RPu = 0.0001, XPu = 0.0001, tBegin = tbegin, tEnd = tbegin + deltat) annotation(
    Placement(visible = true, transformation(origin = {2, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus1(UPhase = -12.65041, UPu = 0.7182655) annotation(
    Placement(visible = true, transformation(origin = {-82, 40}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Controls.Machines.PowerSystemStabilizers.Standard.PssIEEE2B pss(Ks1 = 12, Ks2 = 0.2, Ks3 = 1, PGen0Pu = -generatorSynchronous.P0Pu, SNom = generatorSynchronous.SNom, Vsi1MaxPu = 2, Vsi1MinPu = -2, Vsi2MaxPu = 2, Vsi2MinPu = -2, VstMaxPu = 0.1, VstMinPu = -0.1, t1 = 0.12, t10 = 0.01, t11 = 0.01, t2 = 0.02, t3 = 0.3, t4 = 0.02, t6 = 0.01, t7 = 2, t8 = 0.2, t9 = 0.1, tw1 = 2, tw2 = 2, tw3 = 2, tw4 = 1e-5) annotation(
    Placement(visible = true, transformation(origin = {60, -50}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {93, -91}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constant1(k = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {45, -77}, extent = {{7, -7}, {-7, 7}}, rotation = -90)));
  Modelica.Blocks.Sources.Constant constant2(k = generatorSynchronous.U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-79, -41}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Controls.Machines.Governors.Simplified.GoverProportional goverProportional(KGover = 10, PMax = 3000, PMin = 0, PNom = 2000, Pm0Pu = generatorSynchronous.Pm0Pu) annotation(
    Placement(visible = true, transformation(origin = {22, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Controls.Machines.VoltageRegulators.Standard.ExcIEEEST4B avr(Efd0Pu = generatorSynchronous.Efd0Pu, Ifd0Pu = generatorSynchronous.Ir0Pu,Kc = 0.113, Kg = 0.1, Ki = 0, Kim = 0, Kir = 5, Kp = 9.3, Kpm = 1, Kpr = 0.1, Thetap = 0, UOel0Pu = 10, Ub0Pu = 11.61 , Us0Pu = generatorSynchronous.U0Pu, VbMaxPu = 11.63, VmMaxPu = 99, VmMinPu = -99, VrMaxPu = 1, VrMinPu = -0.87, XlPu = 0.124, it0Pu = generatorSynchronous.i0Pu, tA = 0.02, tR = 0.02, ut0Pu = generatorSynchronous.u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-26, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

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
    Line(points = {{-26, 60}, {2, 60}}, color = {0, 0, 255}));
  connect(line3.terminal2, transformer.terminal1) annotation(
    Line(points = {{22, 60}, {22, 61}, {40, 61}, {40, 40}}, color = {0, 0, 255}));
  connect(transformer.terminal1, line2.terminal2) annotation(
    Line(points = {{40, 40}, {40, 20}, {0, 20}}, color = {0, 0, 255}));
  connect(transformer.terminal2, generatorSynchronous.terminal) annotation(
    Line(points = {{60, 40}, {84, 40}, {84, 20}}, color = {0, 0, 255}));
  connect(nodeFault.terminal, line3.terminal1) annotation(
    Line(points = {{2, 80}, {2, 60}}, color = {0, 0, 255}));
  connect(line1.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-46, 60}, {-62, 60}, {-62, 40}, {-82, 40}}, color = {0, 0, 255}));
  connect(line2.terminal1, infiniteBus1.terminal) annotation(
    Line(points = {{-20, 20}, {-62, 20}, {-62, 40}, {-82, 40}}, color = {0, 0, 255}));
  connect(generatorSynchronous.iStatorPu_out, complexToReal.u) annotation(
    Line(points = {{94, 24}, {98, 24}, {98, -26}, {93, -26}, {93, -85}}, color = {85, 170, 255}));
  connect(generatorSynchronous.omegaPu_out, pss.omegaPu) annotation(
    Line(points = {{80, 10}, {80, -26}, {54, -26}, {54, -38}}, color = {0, 0, 127}));
  connect(generatorSynchronous.PGenPu_out, pss.PGenPu) annotation(
    Line(points = {{90, 10}, {90, -34}, {66, -34}, {66, -38}}, color = {0, 0, 127}));
  connect(goverProportional.omegaPu, generatorSynchronous.omegaPu_out) annotation(
    Line(points = {{16, -34}, {16, -26}, {80, -26}, {80, 10}}, color = {0, 0, 127}));
  connect(constant1.y, goverProportional.PmRefPu) annotation(
    Line(points = {{45, -69}, {44, -69}, {44, -30}, {28, -30}, {28, -34}}, color = {0, 0, 127}));
  connect(goverProportional.PmPu, generatorSynchronous.PmPu_in) annotation(
    Line(points = {{22, -62}, {22, -66}, {8, -66}, {8, 12}, {74, 12}}, color = {0, 0, 127}));
  connect(constant2.y, avr.UsRefPu) annotation(
    Line(points = {{-71, -41}, {-58, -41}, {-58, -14}, {-38, -14}}, color = {0, 0, 127}));
  connect(generatorSynchronous.IRotorPu_out, avr.IfdPu) annotation(
    Line(points = {{94, 16}, {96, 16}, {96, -12}, {-8, -12}, {-8, -46}, {-20, -46}, {-20, -32}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{94, 10}, {94, -4}, {-52, -4}, {-52, -20}, {-38, -20}}, color = {0, 0, 127}));
  connect(pss.UPssPu, avr.UPssPu) annotation(
    Line(points = {{60, -60}, {60, -92}, {-48, -92}, {-48, -26}, {-38, -26}}, color = {0, 0, 127}));
  connect(complexToReal.im, avr.itPuIm) annotation(
    Line(points = {{90, -97}, {-30, -97}, {-30, -32}}, color = {0, 0, 127}));
  connect(complexToReal.re, avr.itPuRe) annotation(
    Line(points = {{96, -97}, {0, -97}, {0, -32}, {-34, -32}}, color = {0, 0, 127}));
  connect(generatorSynchronous.UsPu_out, avr.UsPu) annotation(
    Line(points = {{94, 10}, {29, 10}, {29, -20}, {-38, -20}}, color = {0, 0, 127}));
  connect(avr.EfdPu, generatorSynchronous.efdPu_in) annotation(
    Line(points = {{-15, -20}, {63.5, -20}, {63.5, 28}, {74, 28}}, color = {0, 0, 127}));
  connect(generatorSynchronous.uPu_out, avr.utPu) annotation(
    Line(points = {{94, 30}, {94, 6}, {-26, 6}, {-26, -32}}, color = {85, 170, 255}));


  annotation(
    preferredView = "text",
    experiment(StartTime = 0, StopTime = 10, Tolerance = 1e-06), Documentation(info="<html><head></head><body>The purpose of this test case is to evaluate the transient stability of a SMIB model with advanced regulations compared to the Regulated_SMIBdynamicLineFault, using an AVR regulation and a PSS for the voltage control and a proportional governor to regulate the power, by evaluating the rotor angle Theta for a node fault starting at (t_begin = 1 s) and (t_end = t_begin + delta_t).
    The following figures show the excepted evolution of the generator rotor angle a if delta_t < CCT (the critical clearing time).

    </body></html>"))
   ;
end AdvancedRegulated_SMIB;
