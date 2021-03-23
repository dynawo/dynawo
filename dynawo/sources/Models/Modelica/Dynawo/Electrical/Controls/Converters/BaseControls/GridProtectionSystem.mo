within Dynawo.Electrical.Controls.Converters.BaseControls;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GridProtectionSystem "Phase-locked loop"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Controls.Converters.Parameters.Params_GProtection;

//Grid Protection parameters
  parameter Types.PerUnit uOver "WT over voltage protection activation threshold" annotation(
    Dialog(group = "group", tab = "GridProtection"));
  parameter Types.PerUnit uUnder "WT under voltage protection activation threshold" annotation(
    Dialog(group = "group", tab = "GridProtection"));
  parameter Types.PerUnit fOver "WT over frequency protection activation threshold" annotation(
    Dialog(group = "group", tab = "GridProtection"));
  parameter Types.PerUnit fUnder "WT under frequency protection activation threshold" annotation(
    Dialog(group = "group", tab = "GridProtection"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  //Inputs
  Modelica.Blocks.Interfaces.RealInput uWTPfiltPu(start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefFiltPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Outputs
  Modelica.Blocks.Interfaces.BooleanOutput Focb(start=false) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Blocks
  Modelica.Blocks.Logical.Timer timer annotation(
    Placement(visible = true, transformation(origin = {-8, 92}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer1 annotation(
    Placement(visible = true, transformation(origin = {-8, 14}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer2 annotation(
    Placement(visible = true, transformation(origin = {-8, -12}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Timer timer3 annotation(
    Placement(visible = true, transformation(origin = {-8, -92}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less annotation(
    Placement(visible = true, transformation(origin = {27, 25}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Less less1 annotation(
    Placement(visible = true, transformation(origin = {27, -75}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {27, 65}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(visible = true, transformation(origin = {27, -41}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {58, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or11 annotation(
    Placement(visible = true, transformation(origin = {60, -60}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or12 annotation(
    Placement(visible = true, transformation(origin = {82, 0}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = tableTuunderuWTfilt)  annotation(
    Placement(visible = true, transformation(origin = {-8, 40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D1(table = tableTuoveruWTfilt)  annotation(
    Placement(visible = true, transformation(origin = {-8, 68}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D2(table = tableTfunderfWTfilt)  annotation(
    Placement(visible = true, transformation(origin = {-8, -68}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D3(table = tableTfoverfWTfilt)  annotation(
    Placement(visible = true, transformation(origin = {-8, -40}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater2 annotation(
    Placement(visible = true, transformation(origin = {-47, 93}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater3 annotation(
    Placement(visible = true, transformation(origin = {-47, 13}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater4 annotation(
    Placement(visible = true, transformation(origin = {-47, -13}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater5 annotation(
    Placement(visible = true, transformation(origin = {-47, -87}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = fUnder)  annotation(
    Placement(visible = true, transformation(origin = {-80, -94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = fOver)  annotation(
    Placement(visible = true, transformation(origin = {-80, -12}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = uUnder)  annotation(
    Placement(visible = true, transformation(origin = {-80, 8}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = uOver)  annotation(
    Placement(visible = true, transformation(origin = {-80, 94}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));

equation
  connect(or1.y, or12.u1) annotation(
    Line(points = {{66, 40}, {72, 40}, {72, 0}, {72, 0}}, color = {255, 0, 255}));
  connect(or11.y, or12.u2) annotation(
    Line(points = {{68, -60}, {72, -60}, {72, -6}, {72, -6}}, color = {255, 0, 255}));
  connect(greater1.y, or11.u1) annotation(
    Line(points = {{34, -40}, {50, -40}, {50, -60}, {50, -60}}, color = {255, 0, 255}));
  connect(less1.y, or11.u2) annotation(
    Line(points = {{34, -74}, {50, -74}, {50, -66}, {50, -66}}, color = {255, 0, 255}));
  connect(greater.y, or1.u1) annotation(
    Line(points = {{34, 66}, {48, 66}, {48, 40}, {48, 40}}, color = {255, 0, 255}));
  connect(less.y, or1.u2) annotation(
    Line(points = {{34, 26}, {48, 26}, {48, 34}, {48, 34}}, color = {255, 0, 255}));
  connect(timer1.y, less.u2) annotation(
    Line(points = {{1, 14}, {9, 14}, {9, 20}, {18, 20}}, color = {0, 0, 127}));
  connect(timer.y, greater.u1) annotation(
    Line(points = {{1, 92}, {18, 92}, {18, 66}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], greater.u2) annotation(
    Line(points = {{0, 68}, {8, 68}, {8, 60}, {18, 60}, {18, 60}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], less.u1) annotation(
    Line(points = {{0, 40}, {18, 40}, {18, 26}, {18, 26}}, color = {0, 0, 127}));
  connect(timer2.y, greater1.u1) annotation(
    Line(points = {{0, -12}, {18, -12}, {18, -40}, {18, -40}}, color = {0, 0, 127}));
  connect(combiTable1D3.y[1], greater1.u2) annotation(
    Line(points = {{0, -40}, {8, -40}, {8, -46}, {18, -46}, {18, -46}}, color = {0, 0, 127}));
  connect(combiTable1D2.y[1], less1.u1) annotation(
    Line(points = {{0, -68}, {18, -68}, {18, -74}, {18, -74}}, color = {0, 0, 127}));
  connect(timer3.y, less1.u2) annotation(
    Line(points = {{0, -92}, {18, -92}, {18, -80}, {18, -80}}, color = {0, 0, 127}));
  connect(greater3.y, timer1.u) annotation(
    Line(points = {{-40, 14}, {-18, 14}, {-18, 14}, {-18, 14}}, color = {255, 0, 255}));
  connect(greater4.y, timer2.u) annotation(
    Line(points = {{-40, -12}, {-18, -12}, {-18, -12}, {-18, -12}}, color = {255, 0, 255}));
  connect(greater5.y, timer3.u) annotation(
    Line(points = {{-39, -87}, {-29, -87}, {-29, -92}, {-18, -92}}, color = {255, 0, 255}));
  connect(const.y, greater5.u2) annotation(
    Line(points = {{-74, -94}, {-56, -94}, {-56, -92}, {-56, -92}}, color = {0, 0, 127}));
  connect(const2.y, greater3.u2) annotation(
    Line(points = {{-74, 8}, {-56, 8}, {-56, 8}, {-56, 8}}, color = {0, 0, 127}));
  connect(const1.y, greater4.u1) annotation(
    Line(points = {{-74, -12}, {-56, -12}, {-56, -12}, {-56, -12}}, color = {0, 0, 127}));
  connect(const3.y, greater2.u1) annotation(
    Line(points = {{-74, 94}, {-56, 94}, {-56, 94}, {-56, 94}}, color = {0, 0, 127}));
  connect(uWTPfiltPu, greater2.u2) annotation(
    Line(points = {{-120, 50}, {-60, 50}, {-60, 88}, {-56, 88}, {-56, 88}}, color = {0, 0, 127}));
  connect(uWTPfiltPu, combiTable1D1.u[1]) annotation(
    Line(points = {{-120, 50}, {-40, 50}, {-40, 68}, {-18, 68}, {-18, 68}}, color = {0, 0, 127}));
  connect(uWTPfiltPu, combiTable1D.u[1]) annotation(
    Line(points = {{-120, 50}, {-40, 50}, {-40, 40}, {-18, 40}, {-18, 40}}, color = {0, 0, 127}));
  connect(uWTPfiltPu, greater3.u1) annotation(
    Line(points = {{-120, 50}, {-60, 50}, {-60, 12}, {-56, 12}, {-56, 14}}, color = {0, 0, 127}));
  connect(omegaRefFiltPu, combiTable1D3.u[1]) annotation(
    Line(points = {{-120, -50}, {-40, -50}, {-40, -40}, {-18, -40}, {-18, -40}}, color = {0, 0, 127}));
  connect(omegaRefFiltPu, combiTable1D2.u[1]) annotation(
    Line(points = {{-120, -50}, {-40, -50}, {-40, -68}, {-18, -68}, {-18, -68}}, color = {0, 0, 127}));
  connect(omegaRefFiltPu, greater4.u2) annotation(
    Line(points = {{-120, -50}, {-60, -50}, {-60, -18}, {-56, -18}, {-56, -18}}, color = {0, 0, 127}));
  connect(omegaRefFiltPu, greater5.u1) annotation(
    Line(points = {{-120, -50}, {-60, -50}, {-60, -86}, {-56, -86}, {-56, -86}}, color = {0, 0, 127}));
  connect(greater2.y, timer.u) annotation(
    Line(points = {{-40, 94}, {-18, 94}, {-18, 92}, {-18, 92}}, color = {255, 0, 255}));
  connect(or12.y, Focb) annotation(
    Line(points = {{90, 0}, {102, 0}, {102, 0}, {110, 0}}, color = {255, 0, 255}));
annotation(
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {10, 5}, extent = {{-52, 43}, {32, 7}}, textString = "Grid"), Text(origin = {-10, -27}, extent = {{-76, 65}, {98, -71}}, textString = "Protection")}));
end GridProtectionSystem;
