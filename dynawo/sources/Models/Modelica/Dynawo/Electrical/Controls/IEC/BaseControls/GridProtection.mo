within Dynawo.Electrical.Controls.IEC.BaseControls;

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

model GridProtection "Grid protection system for wind turbines (IEC N°61400-27-1)"
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Controls.IEC.Parameters.GridProtectionParameters;

  //Grid protection parameters
  parameter Types.AngularVelocityPu fOverPu "WT over frequency protection activation threshold in pu (base omegaNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.AngularVelocityPu fUnderPu "WT under frequency protection activation threshold in pu (base omegaNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.VoltageModulePu UOverPu "WT over voltage protection activation threshold in pu (base UNom)" annotation(
    Dialog(tab = "GridProtection"));
  parameter Types.VoltageModulePu UUnderPu "WT under voltage protection activation threshold in pu (base UNom)" annotation(
    Dialog(tab = "GridProtection"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput UWTPFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaFiltPu(start = SystemBase.omegaRef0Pu) "Filtered grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-180, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variable
  Modelica.Blocks.Interfaces.BooleanOutput fOCB(start = true) "Breaker position, true if closed, false if open" annotation(
    Placement(visible = true, transformation(origin = {170, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D(table = TabletUoverUwtfilt) annotation(
    Placement(visible = true, transformation(origin = {10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D1(table = TabletUunderUwtfilt) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D2(table = Tabletfoverfwtfilt) annotation(
    Placement(visible = true, transformation(origin = {10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1Ds combiTable1D3(table = Tabletfunderfwtfilt) annotation(
    Placement(visible = true, transformation(origin = {10, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual4 annotation(
    Placement(visible = true, transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual5 annotation(
    Placement(visible = true, transformation(origin = {70, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(visible = true, transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual1 annotation(
    Placement(visible = true, transformation(origin = {70, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {10, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual annotation(
    Placement(visible = true, transformation(origin = {-50, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual1 annotation(
    Placement(visible = true, transformation(origin = {-50, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual2 annotation(
    Placement(visible = true, transformation(origin = {-50, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.LessEqual lessEqual3 annotation(
    Placement(visible = true, transformation(origin = {-50, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = UOverPu) annotation(
    Placement(visible = true, transformation(origin = {-130, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = UUnderPu) annotation(
    Placement(visible = true, transformation(origin = {-130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = fOverPu) annotation(
    Placement(visible = true, transformation(origin = {-130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = fUnderPu) annotation(
    Placement(visible = true, transformation(origin = {-130, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(visible = true, transformation(origin = {10, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer2 annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer3 annotation(
    Placement(visible = true, transformation(origin = {10, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.And and1(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {130, 3.55271e-15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameter
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));

equation
  connect(const2.y, lessEqual2.u1) annotation(
    Line(points = {{-118, -20}, {-62, -20}}, color = {0, 0, 127}));
  connect(omegaFiltPu, lessEqual2.u2) annotation(
    Line(points = {{-180, -80}, {-80, -80}, {-80, -28}, {-62, -28}}, color = {0, 0, 127}));
  connect(lessEqual3.y, timer3.u) annotation(
    Line(points = {{-38, -140}, {-2, -140}}, color = {255, 0, 255}));
  connect(lessEqual2.y, timer2.u) annotation(
    Line(points = {{-38, -20}, {-2, -20}}, color = {255, 0, 255}));
  connect(const.y, lessEqual.u1) annotation(
    Line(points = {{-118, 140}, {-62, 140}}, color = {0, 0, 127}));
  connect(UWTPFiltPu, lessEqual.u2) annotation(
    Line(points = {{-180, 80}, {-80, 80}, {-80, 132}, {-62, 132}}, color = {0, 0, 127}));
  connect(lessEqual.y, timer.u) annotation(
    Line(points = {{-38, 140}, {-2, 140}}, color = {255, 0, 255}));
  connect(lessEqual1.y, timer1.u) annotation(
    Line(points = {{-38, 20}, {-2, 20}}, color = {255, 0, 255}));
  connect(UWTPFiltPu, combiTable1D.u) annotation(
    Line(points = {{-180, 80}, {-20, 80}, {-20, 100}, {-2, 100}}, color = {0, 0, 127}));
  connect(UWTPFiltPu, combiTable1D1.u) annotation(
    Line(points = {{-180, 80}, {-20, 80}, {-20, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(omegaFiltPu, combiTable1D2.u) annotation(
    Line(points = {{-180, -80}, {-20, -80}, {-20, -60}, {-2, -60}}, color = {0, 0, 127}));
  connect(omegaFiltPu, combiTable1D3.u) annotation(
    Line(points = {{-180, -80}, {-20, -80}, {-20, -100}, {-2, -100}}, color = {0, 0, 127}));
  connect(timer.y, lessEqual5.u1) annotation(
    Line(points = {{22, 140}, {40, 140}, {40, 120}, {58, 120}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], lessEqual5.u2) annotation(
    Line(points = {{22, 100}, {40, 100}, {40, 112}, {58, 112}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], greaterEqual.u1) annotation(
    Line(points = {{22, 60}, {40, 60}, {40, 40}, {58, 40}}, color = {0, 0, 127}));
  connect(timer1.y, greaterEqual.u2) annotation(
    Line(points = {{22, 20}, {40, 20}, {40, 32}, {58, 32}}, color = {0, 0, 127}));
  connect(timer2.y, lessEqual4.u1) annotation(
    Line(points = {{22, -20}, {40, -20}, {40, -40}, {58, -40}}, color = {0, 0, 127}));
  connect(combiTable1D2.y[1], lessEqual4.u2) annotation(
    Line(points = {{22, -60}, {40, -60}, {40, -48}, {58, -48}}, color = {0, 0, 127}));
  connect(combiTable1D3.y[1], greaterEqual1.u1) annotation(
    Line(points = {{22, -100}, {40, -100}, {40, -120}, {58, -120}}, color = {0, 0, 127}));
  connect(timer3.y, greaterEqual1.u2) annotation(
    Line(points = {{22, -140}, {40, -140}, {40, -128}, {58, -128}}, color = {0, 0, 127}));
  connect(UWTPFiltPu, lessEqual1.u1) annotation(
    Line(points = {{-180, 80}, {-80, 80}, {-80, 20}, {-62, 20}}, color = {0, 0, 127}));
  connect(const1.y, lessEqual1.u2) annotation(
    Line(points = {{-118, 20}, {-100, 20}, {-100, 12}, {-62, 12}}, color = {0, 0, 127}));
  connect(omegaFiltPu, lessEqual3.u1) annotation(
    Line(points = {{-180, -80}, {-80, -80}, {-80, -140}, {-62, -140}}, color = {0, 0, 127}));
  connect(const3.y, lessEqual3.u2) annotation(
    Line(points = {{-118, -140}, {-100, -140}, {-100, -148}, {-62, -148}}, color = {0, 0, 127}));
  connect(and1.y, fOCB) annotation(
    Line(points = {{142, 0}, {170, 0}}, color = {255, 0, 255}));
  connect(lessEqual5.y, and1.u[1]) annotation(
    Line(points = {{82, 120}, {100, 120}, {100, 0}, {120, 0}}, color = {255, 0, 255}));
  connect(greaterEqual.y, and1.u[2]) annotation(
    Line(points = {{82, 40}, {100, 40}, {100, 0}, {120, 0}}, color = {255, 0, 255}));
  connect(lessEqual4.y, and1.u[3]) annotation(
    Line(points = {{82, -40}, {100, -40}, {100, 0}, {120, 0}}, color = {255, 0, 255}));
  connect(greaterEqual1.y, and1.u[4]) annotation(
    Line(points = {{82, -120}, {100, -120}, {100, 0}, {120, 0}}, color = {255, 0, 255}));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {10, 5}, extent = {{-52, 43}, {32, 7}}, textString = "Grid"), Text(origin = {-10, -27}, extent = {{-76, 65}, {98, -71}}, textString = "Protection")}),
  Diagram(coordinateSystem(extent = {{-160, -160}, {160, 160}})));
end GridProtection;
