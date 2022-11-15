within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters;

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

model IEEET1 "IEEE type 1 Exciter (IEEET1)"
  import Modelica.Blocks;
  import Dynawo.Types;
  
  parameter Types.Time Ta "Voltage regulator time-delay constant in s";
  parameter Types.Time Te "Exciter time-delay constant in s";
  parameter Types.Time Tf "Exciter rate feedback time-delay constant in s";
  parameter Types.Time Tr "UStatorPu time-delay constant in s";
  parameter Types.PerUnit Ka "Voltage regulator gain constant";
  parameter Types.PerUnit Ke "Exciter gain constant";
  parameter Types.PerUnit Kf "Exciter rate feedback gain constant";
  parameter Types.PerUnit e1 "Exciter saturation point 1 in pu";
  parameter Types.PerUnit e2 "Exciter saturation point 2 in pu";
  parameter Types.PerUnit s1 "Saturation at e1 in pu";
  parameter Types.PerUnit s2 "Saturation at e2 in pu";
  parameter Types.PerUnit Se[:, :] = [e1-1, s1; e1, s1; e2, s2; e2+1, s2] "Points of saturation characteristic";
  parameter Types.VoltageModulePu URegMaxPu "Voltage regulator upper limit";
  parameter Types.VoltageModulePu URegMinPu "Voltage regulator lower limit";
  parameter Types.VoltageModulePu UStator0Pu "Start value of stator terminal voltage in pu (base UNom)";
  parameter Types.VoltageModulePu Efd0Pu "Start value of exciter voltage in pu (base UNom)";
  
  Modelica.Blocks.Interfaces.RealInput UGenPu "Generator terminal voltage in pu (base UNom) ('E_c', synchronous generator voltage after current compensator and voltage transducer)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu "Reference voltage of AVR in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UpssPu "PSS output voltage in pu (base UNom) ('Vs')" annotation(
    Placement(visible = true, transformation(origin = {-160, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput EfdPu "Generator field voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Blocks.Continuous.FirstOrder UGenPuDelay(T = Tr, k = 1, y_start = UStator0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add3 dUGenPu(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-68, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add dURegPu(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add dEfdPu(k1 = -1)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.TransferFunction EfdPuInt(a = {Te, 0}, b = {1}, y_start = Efd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.TransferFunction EfdPu_fb(a = {Tf, 1}, b = {Kf, 0}, y_start = Efd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain EfdPuGain(k = Ke)  annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Blocks.Math.Add EfdsatPuAdd annotation(
    Placement(visible = true, transformation(origin = {46, 32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Product EfdsatPu annotation(
    Placement(visible = true, transformation(origin = {64, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.LimitedFirstOrder URegPuLimInt(K = Ka, Y0 = Efd0Pu,YMax = URegMaxPu, YMin = URegMinPu, tFilter = Ta)  annotation(
    Placement(visible = true, transformation(origin = {4, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds SatMod(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = Se, verboseExtrapolation = false)  annotation(
    Placement(visible = true, transformation(origin = {106, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
  connect(UGenPu, UGenPuDelay.u) annotation(
    Line(points = {{-160, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(UGenPuDelay.y, dUGenPu.u2) annotation(
    Line(points = {{-97, 0}, {-81, 0}}, color = {0, 0, 127}));
  connect(UpssPu, dUGenPu.u3) annotation(
    Line(points = {{-160, -60}, {-90, -60}, {-90, -8}, {-80, -8}}, color = {0, 0, 127}));
  connect(URefPu, dUGenPu.u1) annotation(
    Line(points = {{-160, 60}, {-90, 60}, {-90, 8}, {-80, 8}}, color = {0, 0, 127}));
  connect(dUGenPu.y, dURegPu.u1) annotation(
    Line(points = {{-57, 0}, {-51, 0}, {-51, 6}, {-47, 6}}, color = {0, 0, 127}));
  connect(EfdPu_fb.y, dURegPu.u2) annotation(
    Line(points = {{19, -50}, {-51, -50}, {-51, -6}, {-47, -6}}, color = {0, 0, 127}));
  connect(EfdsatPuAdd.y, dEfdPu.u1) annotation(
    Line(points = {{46, 21}, {46, 6}, {58, 6}}, color = {0, 0, 127}));
  connect(dEfdPu.y, EfdPuInt.u) annotation(
    Line(points = {{81, 0}, {94, 0}}, color = {0, 0, 127}));
  connect(EfdPuInt.y, EfdPu) annotation(
    Line(points = {{117, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(EfdPuGain.y, EfdsatPuAdd.u1) annotation(
    Line(points = {{79, 50}, {52, 50}, {52, 44}}, color = {0, 0, 127}));
  connect(EfdPuInt.y, EfdPu_fb.u) annotation(
    Line(points = {{118, 0}, {126, 0}, {126, -50}, {42, -50}}, color = {0, 0, 127}));
  connect(EfdPuInt.y, EfdPuGain.u) annotation(
    Line(points = {{118, 0}, {126, 0}, {126, 50}, {102, 50}}, color = {0, 0, 127}));
  connect(EfdPuInt.y, EfdsatPu.u2) annotation(
    Line(points = {{118, 0}, {126, 0}, {126, 70}, {84, 70}, {84, 74}, {76, 74}}, color = {0, 0, 127}));
  connect(EfdsatPu.y, EfdsatPuAdd.u2) annotation(
    Line(points = {{53, 80}, {40, 80}, {40, 44}}, color = {0, 0, 127}));
  connect(dURegPu.y, URegPuLimInt.u) annotation(
    Line(points = {{-22, 0}, {-8, 0}}, color = {0, 0, 127}));
  connect(URegPuLimInt.y, dEfdPu.u2) annotation(
    Line(points = {{15, 0}, {26, 0}, {26, -6}, {58, -6}}, color = {0, 0, 127}));
  connect(EfdPuInt.y, SatMod.u) annotation(
    Line(points = {{118, 0}, {126, 0}, {126, 86}, {118, 86}}, color = {0, 0, 127}));
  connect(SatMod.y[1], EfdsatPu.u1) annotation(
    Line(points = {{96, 86}, {76, 86}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(coordinateSystem(extent = {{-140, -100}, {140, 100}}), graphics = {Text(origin = {0, 2}, extent = {{-80, 30}, {80, -30}}, textString = "IEEET1"), Rectangle(extent = {{-140, 100}, {140, -100}})}),
  Documentation(info = "<html><head></head><body>This model implements the IEEE Type 1 Exciter as shown in the&nbsp;<!--StartFragment-->I. C. Report, \"Computer representation of excitation systems,\" in <em>IEEE Transactions on Power Apparatus and Systems</em>, vol. PAS-87, no. 6, pp. 1460-1464, June 1968, doi: 10.1109/TPAS.1968.292114.<!--EndFragment--></body></html>"));
end IEEET1;
