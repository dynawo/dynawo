within Dynawo.Electrical.Controls.Converters.BaseControls;

model IECWT4AMeasures
  // PLL
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
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  /*Nominal Parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  /*Grid Measurement Parameters*/
  parameter Types.Time Tpfilt "Time constant in active power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time Tqfilt "Time constant in reactive power measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time Tufilt "Time constant in voltage measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time Tffilt "Time constant in frequency measurement filter" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time dfMax "Maximum rate of change of frequency" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  parameter Types.Time dfMin "Mmum rate of change of frequency" annotation(
    Dialog(group = "group", tab = "GridMeasurement"));
  /*Operational Parameters*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in rad" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
    Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef)";
  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput iWtRePu(start = -i0Pu.re * SystemBase.SnRef / SNom) "WTT active current phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iWtImPu(start = -i0Pu.im * SystemBase.SnRef / SNom) "WTT reactive current phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-120, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWtRePu(start = u0Pu.re) "WTT active voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWtImPu(start = u0Pu.im) "WTT reactive voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Global power system grid frequency applied for frequency measurements because angles are calculated in the corresponding stationary reference frame" annotation(
    Placement(visible = true, transformation(origin = {-120, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput pWTCfiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered WTT active power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {120, 100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput qWTCfiltPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered WTT reactive power (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uWTCPu(start = U0Pu) "WTT voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {120, 19.5}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uWTCfiltPu(start = U0Pu) "Filtered WTT voltage phasor in power system coordinates (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {120, -19.5}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = UPhase0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaRefFiltPu(start = SystemBase.omegaRef0Pu) "Filtered global power system grid frequency applied for frequency measurements because angles are calculated in the corresponding stationary reference frame" annotation(
    Placement(visible = true, transformation(origin = {120, -100.5}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  /*Other calculated variables*/
  Types.PerUnit PGenPu(start = -P0Pu) "Active power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit QGenPu(start = -Q0Pu) "Reactive power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit PGenPuBaseSNom(start = -P0Pu * (SystemBase.SnRef / SNom)) "Active power generated by the converter at the PCC in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit QGenPuBaseSNom(start = -Q0Pu * (SystemBase.SnRef / SNom)) "Reactive power generated by the converter at the PCC in pu (base UNom, SNom) (generator convention) ";
  Types.PerUnit IWtPu(start = sqrt(P0Pu ^ 2 + Q0Pu ^ 2) * SystemBase.SnRef / (SNom * U0Pu)) "Module of the current at PCC in pu (base UNom, SNom)";
  Types.PerUnit uWtPu(start = U0Pu) "Module of the voltage at PCC in pu (base UNom, SNom)";
  /*Blocks*/
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = Tpfilt, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {60, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = Tqfilt, y_start = -Q0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {60, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = Tufilt, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {60, -19.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {80, -100.5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-40, 105}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-40, 77}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product2 annotation(
    Placement(visible = true, transformation(origin = {-40, 49}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product3 annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.RectangularToPolar rectangularToPolar1 annotation(
    Placement(visible = true, transformation(origin = {-48, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tffilt, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {52, -79.5}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = 0.0001, y_start = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {-77, -85}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-53, -81}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / SystemBase.omegaNom) annotation(
    Placement(visible = true, transformation(origin = {-27, -75}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {-2, -80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 0.0001) annotation(
    Placement(visible = true, transformation(origin = {-35, -95}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRamp firstOrderRamp(DuMax = dfMax, DuMin = dfMin, T = 0.0001, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {24, -80}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
equation
/* Non filtered Module of the voltage and the injected current at PCC in pu (base UNom, SNom) */
  uWtPu = sqrt(uWtRePu ^ 2 + uWtImPu ^ 2);
  IWtPu = sqrt(iWtRePu ^ 2 + iWtImPu ^ 2);
/* Injected power at PCC in nominal and system bases */
  PGenPuBaseSNom = uWtRePu * iWtRePu + uWtImPu * iWtImPu;
  QGenPuBaseSNom = uWtImPu * iWtRePu - uWtRePu * iWtImPu;
  PGenPu = PGenPuBaseSNom * SNom / SystemBase.SnRef;
  QGenPu = QGenPuBaseSNom * SNom / SystemBase.SnRef;
/*Connectors*/
  connect(firstOrder1.y, qWTCfiltPu) annotation(
    Line(points = {{71, 60}, {120, 60}}, color = {0, 0, 127}));
  connect(add2.y, firstOrder1.u) annotation(
    Line(points = {{21, 60}, {48, 60}}, color = {0, 0, 127}));
  connect(add.y, omegaRefFiltPu) annotation(
    Line(points = {{91, -100.5}, {120, -100.5}}, color = {0, 0, 127}));
  connect(product2.y, add2.u1) annotation(
    Line(points = {{-29, 49}, {-20, 49}, {-20, 66}, {-2, 66}}, color = {0, 0, 127}));
  connect(iWtRePu, product.u1) annotation(
    Line(points = {{-120, 100}, {-80, 100}, {-80, 111}, {-52, 111}}, color = {0, 0, 127}));
  connect(uWtRePu, product.u2) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, 100}, {-52, 100}, {-52, 99}}, color = {0, 0, 127}));
  connect(iWtImPu, product1.u1) annotation(
    Line(points = {{-120, 50}, {-92, 50}, {-92, 83}, {-52, 83}}, color = {0, 0, 127}));
  connect(uWtImPu, product1.u2) annotation(
    Line(points = {{-120, -50}, {-70, -50}, {-70, 71}, {-52, 71}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_abs, firstOrder3.u) annotation(
    Line(points = {{-37, -38}, {0, -38}, {0, -19.5}, {48, -19.5}}, color = {0, 0, 127}));
  connect(firstOrder3.y, uWTCfiltPu) annotation(
    Line(points = {{71, -19.5}, {120, -19.5}}, color = {0, 0, 127}));
  connect(uWtImPu, rectangularToPolar1.u_im) annotation(
    Line(points = {{-120, -50}, {-60, -50}}, color = {0, 0, 127}));
  connect(iWtRePu, product2.u1) annotation(
    Line(points = {{-120, 100}, {-80, 100}, {-80, 54}, {-52, 54}, {-52, 55}}, color = {0, 0, 127}));
  connect(uWtImPu, product2.u2) annotation(
    Line(points = {{-120, -50}, {-70, -50}, {-70, 42}, {-52, 42}, {-52, 43}}, color = {0, 0, 127}));
  connect(firstOrder2.y, pWTCfiltPu) annotation(
    Line(points = {{72, 100}, {120, 100}}, color = {0, 0, 127}));
  connect(add1.y, firstOrder2.u) annotation(
    Line(points = {{21, 100}, {48, 100}}, color = {0, 0, 127}));
  connect(product3.y, add2.u2) annotation(
    Line(points = {{-28, 20}, {-12, 20}, {-12, 52}, {-2, 52}, {-2, 54}}, color = {0, 0, 127}));
  connect(iWtImPu, product3.u1) annotation(
    Line(points = {{-120, 50}, {-92, 50}, {-92, 26}, {-52, 26}}, color = {0, 0, 127}));
  connect(uWtRePu, product3.u2) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, 14}, {-52, 14}}, color = {0, 0, 127}));
  connect(product1.y, add1.u2) annotation(
    Line(points = {{-28, 78}, {-20, 78}, {-20, 94}, {-2, 94}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_arg, theta) annotation(
    Line(points = {{-37, -50}, {80, -50}, {80, -60}, {120, -60}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u2) annotation(
    Line(points = {{-120, -100}, {-100, -100}, {-100, -106.5}, {68, -106.5}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_abs, uWTCPu) annotation(
    Line(points = {{-37, -38}, {0, -38}, {0, 19.5}, {120, 19.5}}, color = {0, 0, 127}));
  connect(product.y, add1.u1) annotation(
    Line(points = {{-29, 105}, {-15, 105}, {-15, 106}, {-2, 106}}, color = {0, 0, 127}));
  connect(uWtRePu, rectangularToPolar1.u_re) annotation(
    Line(points = {{-120, 0}, {-60, 0}, {-60, -38}}, color = {0, 0, 127}));
  connect(firstOrder.y, add.u1) annotation(
    Line(points = {{61, -79.5}, {68, -79.5}, {68, -94}}, color = {0, 0, 127}));
  connect(firstOrder4.y, add3.u2) annotation(
    Line(points = {{-69, -85}, {-61, -85}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_arg, add3.u1) annotation(
    Line(points = {{-36, -50}, {-32, -50}, {-32, -60}, {-61, -60}, {-61, -77}}, color = {0, 0, 127}));
  connect(gain.y, division.u1) annotation(
    Line(points = {{-21.5, -75}, {-12, -75}}, color = {0, 0, 127}));
  connect(division.y, firstOrderRamp.u) annotation(
    Line(points = {{7, -80}, {13, -80}}, color = {0, 0, 127}));
  connect(firstOrderRamp.y, firstOrder.u) annotation(
    Line(points = {{35, -80}, {42, -80}}, color = {0, 0, 127}));
  connect(const.y, division.u2) annotation(
    Line(points = {{-30, -94}, {-20, -94}, {-20, -85}, {-12, -85}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-46, -80}, {-40, -80}, {-40, -75}, {-33, -75}}, color = {0, 0, 127}));
  connect(rectangularToPolar1.y_arg, firstOrder4.u) annotation(
    Line(points = {{-36, -50}, {-32, -50}, {-32, -60}, {-94, -60}, {-94, -86}, {-86, -86}, {-86, -84}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -120}, {100, 120}}, initialScale = 0.1)),
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {16, -23}, extent = {{-108, -24}, {76, 10}}, textString = "Module"), Text(origin = {8, 35}, extent = {{-100, -30}, {88, 20}}, textString = "Measurement")}));
end IECWT4AMeasures;
