within Dynawo.Electrical.Sources.IEC;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WT4Injector "Converter model and grid interface according to IEC N°61400-27-1 standard for type 4A wind turbines"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Circuit parameters
  parameter Types.PerUnit BesPu "Shunt susceptance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit GesPu "Shunt conductance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit ResPu "Serial resistance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));
  parameter Types.PerUnit XesPu "Serial reactance in pu (base UNom, SNom)" annotation(
    Dialog(tab = "Electrical"));

  //Control parameters
  parameter Types.PerUnit DipMaxPu "Maximum active current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMaxPu "Maximum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit DiqMinPu "Minimum reactive current ramp rate in pu/s (base UNom, SNom) (generator convention)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kipaw "Anti-windup gain for active current in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
  parameter Types.PerUnit Kiqaw "Anti-windup gain for reactive current in pu/s (base UNom, SNom)" annotation(
    Dialog(tab = "Control"));
  parameter Types.Time tG "Current generation time constant in s" annotation(
    Dialog(tab = "Control"));

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Grid terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.BooleanInput fOCB(start = false) "Open Circuit Breaker flag" annotation(
    Placement(visible = true, transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput ipCmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput ipMaxPu(start = IpMax0Pu) "Maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 79}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMaxPu(start = IqMax0Pu) "Maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iqMinPu(start = IqMin0Pu) "Minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput theta(start = UPhase0) "Phase shift between the converter and the grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {-40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-60, 110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));

  //Output variables
  Modelica.ComplexBlocks.Interfaces.ComplexOutput iWtPu(re(start = -i0Pu.re * SystemBase.SnRef / SNom), im(start = -i0Pu.im * SystemBase.SnRef / SNom)) "Complex current at grid terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PAgPu(start = PAg0Pu) "Generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-80, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uWtPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.ActivePowerPu PGenPu(start = -P0Pu) "Active power at terminal in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QGenPu(start = -Q0Pu) "Reactive power at terminal in pu (base SnRef) (generator convention)";

  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex1 annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.ElecSystem elecSystem(BesPu = BesPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, ResPu = ResPu, SNom = SNom, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, XesPu = XesPu, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.GenSystem4 genSystem(DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kipaw = Kipaw, Kiqaw = Kiqaw, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, tG = tG) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit IGsIm0Pu "Initial imaginary component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit IGsRe0Pu "Initial real component of the current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit IpMax0Pu "Initial maximum active current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMax0Pu "Initial maximum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit IqMin0Pu "Initial minimum reactive current at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PAg0Pu "Initial generator (air gap) power in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit UGsIm0Pu "Initial imaginary component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));
  parameter Types.PerUnit UGsRe0Pu "Initial real component of the voltage at converter terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));

equation
  PGenPu = ComplexMath.real(terminal.V * ComplexMath.conj(-terminal.i));
  QGenPu = ComplexMath.imag(terminal.V * ComplexMath.conj(-terminal.i));
  genSystem.running = running.value;
  connect(theta, genSystem.theta) annotation(
    Line(points = {{-40, 110}, {-40, 22}}, color = {0, 0, 127}));
  connect(genSystem.terminal, elecSystem.terminal1) annotation(
    Line(points = {{-18, 0}, {18, 0}}, color = {0, 0, 255}));
  connect(elecSystem.terminal2, terminal) annotation(
    Line(points = {{62, 0}, {106, 0}}, color = {0, 0, 255}));
  connect(ipMaxPu, genSystem.ipMaxPu) annotation(
    Line(points = {{-110, 40}, {-80, 40}, {-80, 16}, {-62, 16}}, color = {0, 0, 127}));
  connect(ipCmdPu, genSystem.ipCmdPu) annotation(
    Line(points = {{-110, 20}, {-82, 20}, {-82, 8}, {-62, 8}}, color = {0, 0, 127}));
  connect(iqMaxPu, genSystem.iqMaxPu) annotation(
    Line(points = {{-110, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(iqCmdPu, genSystem.iqCmdPu) annotation(
    Line(points = {{-110, -20}, {-82, -20}, {-82, -8}, {-62, -8}}, color = {0, 0, 127}));
  connect(iqMinPu, genSystem.iqMinPu) annotation(
    Line(points = {{-110, -40}, {-80, -40}, {-80, -16}, {-62, -16}}, color = {0, 0, 127}));
  connect(realToComplex1.y, uWtPu) annotation(
    Line(points = {{82, -80}, {110, -80}}, color = {85, 170, 255}));
  connect(realToComplex.y, iWtPu) annotation(
    Line(points = {{82, -40}, {110, -40}}, color = {85, 170, 255}));
  connect(elecSystem.iWtImPu, realToComplex.im) annotation(
    Line(points = {{36, -22}, {36, -34}, {58, -34}}, color = {0, 0, 127}));
  connect(elecSystem.iWtRePu, realToComplex.re) annotation(
    Line(points = {{32, -22}, {32, -46}, {58, -46}}, color = {0, 0, 127}));
  connect(elecSystem.uWtImPu, realToComplex1.im) annotation(
    Line(points = {{26, -22}, {26, -74}, {58, -74}}, color = {0, 0, 127}));
  connect(fOCB, genSystem.fOCB) annotation(
    Line(points = {{40, 110}, {40, 60}, {-32, 60}, {-32, 22}}, color = {255, 0, 255}));
  connect(genSystem.PAgPu, PAgPu) annotation(
    Line(points = {{-18, -16}, {0, -16}, {0, -50}, {-80, -50}, {-80, -110}}, color = {0, 0, 127}));
  connect(elecSystem.uWtRePu, realToComplex1.re) annotation(
    Line(points = {{22, -22}, {22, -86}, {58, -86}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-90, -30}, {90, 30}}, textString = "IEC WT4"), Text(origin = {0, -30}, extent = {{-90, -30}, {90, 30}}, textString = "Converter")}, coordinateSystem(initialScale = 0.1)));
end WT4Injector;
