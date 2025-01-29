within Dynawo.Electrical.Sources.IEC.BaseConverters;

/*
  * Copyright (c) 2025, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BaseWTInjector "Converter model and grid interface according to IEC N°61400-27-1 standard for type 3 and 4 wind turbines"
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffInjector;
  extends Dynawo.Electrical.Wind.IEC.Parameters.Circuit;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialGenSystem;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPqGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialComplexUiGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.SNom_;
  
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
  
  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Grid terminal, complex voltage and current in pu (base UNom, SnRef) (receptor convention)" annotation(
    Placement(visible = true, transformation(origin = {105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  
  Types.ActivePowerPu PGenPu(start = -P0Pu) "Active power at terminal in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QGenPu(start = -Q0Pu) "Reactive power at terminal in pu (base SnRef) (generator convention)";
  
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.RealToComplex realToComplex1 annotation(
    Placement(visible = true, transformation(origin = {70, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Sources.IEC.BaseConverters.ElecSystem elecSystem(BesPu = BesPu, GesPu = GesPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, ResPu = ResPu, SNom = SNom, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, XesPu = XesPu, i0Pu = i0Pu, u0Pu = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  PGenPu = ComplexMath.real(terminal.V * ComplexMath.conj(-terminal.i));
  QGenPu = ComplexMath.imag(terminal.V * ComplexMath.conj(-terminal.i));
  
  connect(elecSystem.terminal2, terminal) annotation(
    Line(points = {{62, 0}, {106, 0}}, color = {0, 0, 255}));
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
  connect(elecSystem.uWtRePu, realToComplex1.re) annotation(
    Line(points = {{22, -22}, {22, -86}, {58, -86}}, color = {0, 0, 127}));
  
  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-31, 21}, extent = {{-75, -21}, {75, 21}}, textString = "IEC WT"), Text(origin = {0, -30}, extent = {{-90, -30}, {90, 30}}, textString = "Converter")}, coordinateSystem(initialScale = 0.1)));
end BaseWTInjector;
