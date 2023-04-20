within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model IEEET1 "IEEE type 1 Exciter (IEEET1)"
  import Modelica;
  import Modelica.Blocks;
  import Dynawo;
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
  parameter Types.VoltageModulePu URegMaxPu "Voltage regulator upper limit";
  parameter Types.VoltageModulePu URegMinPu "Voltage regulator lower limit";
  parameter Types.VoltageModulePu UStator0Pu "Start value of stator terminal voltage in pu (base UNom)";
  parameter Types.VoltageModulePu Efd0Pu "Start value of exciter voltage in pu (base UNom)";
  parameter Types.VoltageModulePu URef0Pu(fixed=false) "Initial voltage reference in pu (base UNom)";

  Modelica.Blocks.Interfaces.RealInput UStatorPu(start = UStator0Pu) "Generator terminal voltage in pu (base UNom) ('E_c', synchronous generator voltage after current compensator and voltage transducer)" annotation(
    Placement(visible = true, transformation(origin = {-178, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput URefPu(start = URef0Pu) "Reference voltage of AVR in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-178, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, 62}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPssPu(start = 0) "PSS output voltage correction in pu (base UNom) ('Vs')" annotation(
    Placement(visible = true, transformation(origin = {-178, -42}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UoelPu(start = 0) "OEL output voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-80, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-100, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UuelPu(start = 0) "UEL output voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {-40, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Generator field voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Add3 dUGenPu(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-86, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Math.Add dEfdPu(k1 = -1)  annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.TransferFunction EfdPuInt(a = {Te, 0}, b = {1}, initType = Modelica.Blocks.Types.Init.InitialState, x_start = {Efd0Pu}, y_start = Efd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Blocks.Continuous.TransferFunction EfdPu_fb(a = {Tf, 1}, b = {Kf, 0}, initType = Modelica.Blocks.Types.Init.InitialState, x_start = {Efd0Pu}, y_start = Efd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {30, -50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain EfdPuGain(k = Ke)  annotation(
    Placement(visible = true, transformation(origin = {90, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Blocks.Math.Add EfdsatPuAdd annotation(
    Placement(visible = true, transformation(origin = {46, 32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Add3 dURegPu(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add UelPu annotation(
    Placement(visible = true, transformation(origin = {-64, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.SatChar satChar(e1 = e1, e2 = e2, s1 = s1, s2 = s2)  annotation(
    Placement(visible = true, transformation(origin = {90, 90}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.FirstOrderLimState URegPu(T = Ta, initType = Modelica.Blocks.Types.Init.InitialState, k = Ka, yMax = URegMaxPu, yMin = URegMinPu, y_start = EfdsatAdd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {20, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder UGenPuDelay(T = Tr, initType = Modelica.Blocks.Types.Init.InitialState, k = 1, y_start = UStator0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.VoltageModulePu EfdsatAdd0Pu(fixed=false) "Initial value for regulator integrator.";

initial algorithm
  EfdsatAdd0Pu := Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.SatChar_func(u = UStator0Pu, e1=e1, e2=e2, s1=s1, s2=s2) + Ke * Efd0Pu;
  URef0Pu := if Ka > 0 then UStator0Pu + EfdsatAdd0Pu / Ka else 0;

equation
  connect(UPssPu, dUGenPu.u3) annotation(
    Line(points = {{-178, -42}, {-108, -42}, {-108, -8}, {-98, -8}}, color = {0, 0, 127}));
  connect(URefPu, dUGenPu.u1) annotation(
    Line(points = {{-178, 40}, {-108, 40}, {-108, 8}, {-98, 8}}, color = {0, 0, 127}));
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
  connect(UelPu.y, dURegPu.u1) annotation(
    Line(points = {{-53, 50}, {-52, 50}, {-52, 8}, {-42, 8}}, color = {0, 0, 127}));
  connect(EfdPu_fb.y, dURegPu.u3) annotation(
    Line(points = {{20, -50}, {-52, -50}, {-52, -8}, {-42, -8}}, color = {0, 0, 127}));
  connect(dUGenPu.y, dURegPu.u2) annotation(
    Line(points = {{-75, 0}, {-42, 0}}, color = {0, 0, 127}));
  connect(UuelPu, UelPu.u2) annotation(
    Line(points = {{-120, 120}, {-120, 50}, {-96, 50}, {-96, 44}, {-76, 44}}, color = {0, 0, 127}));
  connect(EfdPuInt.y, satChar.u) annotation(
    Line(points = {{118, 0}, {126, 0}, {126, 90}, {102, 90}}, color = {0, 0, 127}));
  connect(satChar.y, EfdsatPuAdd.u2) annotation(
    Line(points = {{80, 90}, {40, 90}, {40, 44}}, color = {0, 0, 127}));
  connect(dURegPu.y, URegPu.u) annotation(
    Line(points = {{-18, 0}, {-5, 0}, {-5, -6}, {8, -6}}, color = {0, 0, 127}));
  connect(UStatorPu, UGenPuDelay.u) annotation(
    Line(points = {{-178, 0}, {-142, 0}}, color = {0, 0, 127}));
  connect(UGenPuDelay.y, dUGenPu.u2) annotation(
    Line(points = {{-118, 0}, {-98, 0}}, color = {0, 0, 127}));
  connect(URegPu.y, dEfdPu.u2) annotation(
    Line(points = {{31, -6}, {58, -6}}, color = {0, 0, 127}));
  connect(UoelPu, UelPu.u1) annotation(
    Line(points = {{-80, 120}, {-80, 56}, {-76, 56}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})),
    Icon(coordinateSystem(extent = {{-140, -100}, {140, 100}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-140, 100}, {140, -100}}), Rectangle(extent = {{-138, 100}, {-138, 100}}), Text(origin = {0, 1}, extent = {{-120, 81}, {120, -81}}, textString = "IEEET1")}),
  Documentation(info = "<html><head></head><body>This model implements the IEEE Type 1 Exciter as shown in the&nbsp;<!--StartFragment-->I. C. Report, \"Computer representation of excitation systems,\" in <em>IEEE Transactions on Power Apparatus and Systems</em>, vol. PAS-87, no. 6, pp. 1460-1464, June 1968, doi: 10.1109/TPAS.1968.292114.<!--EndFragment--></body></html>"));
end IEEET1;
