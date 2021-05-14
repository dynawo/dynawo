within Dynawo.Electrical.Sources;

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

model VSCIdcSource "Converter Model as controlled AC voltage source with DC bus capacitor and current source"

/*
  Equivalent circuit and conventions:
                       __________
IdcSourcePu     IdcPu |          |iConvPu                           iPccPu
-------->-------->----|          |-->-----(Rfilter,Lfilter)---------->--(Rtransformer,Ltransformer)---(terminal)
              |       |          |                                |
UdcSourcePu (Cdc)     |  DC/AC   |  uConvPu         uFilterPu (Cfilter)                      uPccPu
              |       |          |                                |
              |       |          |                                |
----------------------|__________|---------------------------------------------------------------------

*/

  import Modelica;
  import Modelica.Math;
  import Modelica.ComplexMath;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffGenerator;

  parameter Types.ApparentPowerModule SNom  "Nominal converter apparent power in MVA";
  parameter Types.PerUnit ConvFixLossPu     "Converter fix losses in p.u (base SNom), such that PlossPu=ConvFixLossPu+Plvar";
  parameter Types.PerUnit ConvVarLossPu     "Converter variable losses in p.u (base UNom, SNom), such that Plvar=ConvVarLossPu*Idc";

  parameter Types.PerUnit Rtransformer      "Transformer resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Ltransformer      "Transformer inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Rfilter           "Converter filter resistance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Lfilter           "Converter filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Cfilter           "Converter filter capacitance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Cdc               "DC bus capacitance in p.u (base UNom, SNom)";

  parameter Types.ActivePowerPu P0Pu    "Start value of active power at the PCC in p.u (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power at the PCC in p.u (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu   "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)";
  parameter Types.ComplexPerUnit i0Pu   "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)";
  parameter Types.Angle Theta0          "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians";
  parameter Types.PerUnit UdFilter0Pu   "Start value of the d-axis voltage at the converter terminal (filter) in p.u (base UNom)";
  parameter Types.PerUnit UdConv0Pu     "Start value of the d-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit UqConv0Pu     "Start value of the q-axis converter modulated voltage in p.u (base UNom)";
  parameter Types.PerUnit IdConv0Pu     "Start value of the d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu     "Start value of the q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu      "Start value of the d-axis current injected at the PCC in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu      "Start value of the q-axis current injected at the PCC in p.u (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdcSource0Pu  "Start value of the DC bus voltage in p.u (base UNom)";
  parameter Types.PerUnit IdcSource0Pu  "Start value of the DC source current in p.u (base UNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
    Placement(visible = true, transformation(origin = {-108, -48}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {108, 80}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter angular frequency in p.u (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, -60}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {108, 40}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udConvPu(start = UdConv0Pu) "d-axis converter modulated voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, -74}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {108, 0}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvPu(start = UqConv0Pu) "q-axis converter modulated voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, -86}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {108, -40}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput IdcSourcePu(start = IdcSource0Pu) "DC source injected current in p.u (base UNom, SNom)" annotation(
        Placement(visible = true, transformation(origin = {-108, -100}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {108, -80}, extent = {{8, -8}, {-8, 8}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput udPccPu(start = u0Pu.re*cos(Theta0) + u0Pu.im*sin(Theta0)) "d-axis voltage at the PCC in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {108, 94}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-89, -109}, extent = {{9, -9}, {-9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uqPccPu(start = -u0Pu.re*sin(Theta0) + u0Pu.im*cos(Theta0)) "q-axis voltage at the PCC in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {108, 84}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-67, -109}, extent = {{9, -9}, {-9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {108, 70}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {23, -109}, extent = {{9, -9}, {-9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = 0) "q-axis voltage at the converter terminal (filter) in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {108, 58}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {45, -109}, extent = {{9, -9}, {-9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = IdConv0Pu) "d-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {108, 18}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {67, -109}, extent = {{9, -9}, {-9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "q-axis valve current (before filter) in p.u (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {108, 6}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {89, -109}, extent = {{9, -9}, {-9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput UdcPu(start = UdcSource0Pu) "DC bus voltage in p.u (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {108, -20}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {1, -109}, extent = {{9, -9}, {-9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput PFilterPu(start = UdFilter0Pu * IdConv0Pu) "Active Power at converter terminal, after filter (base SNom)" annotation(
        Placement(visible = true, transformation(origin = {108, 43}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-44, -109}, extent = {{9, -9}, {-9, 9}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput QFilterPu(start =- UdFilter0Pu * IqConv0Pu) "Rective Power at converter terminal, after filter (base SNom)" annotation(
        Placement(visible = true, transformation(origin = {108, 31}, extent = {{-8, -8}, {8, 8}}, rotation = 0), iconTransformation(origin = {-21, -109}, extent = {{9, 9}, {-9, -9}}, rotation = 90)));

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Sources.BaseConverters.GridInterface gridInterface(Ltransformer = Ltransformer, P0Pu = P0Pu, Q0Pu = Q0Pu, Rtransformer = Rtransformer, SNom = SNom, Theta0 = Theta0, UdFilter0Pu = UdFilter0Pu, i0Pu = i0Pu, u0Pu = u0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-60, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Electrical.Sources.BaseConverters.VSCAverage vSCAverage(Cfilter = Cfilter, IdConv0Pu = IdConv0Pu, IdPcc0Pu = IdPcc0Pu, IqConv0Pu = IqConv0Pu, IqPcc0Pu = IqPcc0Pu, Lfilter = Lfilter, Rfilter = Rfilter, UdConv0Pu = UdConv0Pu, UdFilter0Pu = UdFilter0Pu, UqConv0Pu = UqConv0Pu)  annotation(
    Placement(visible = true, transformation(origin = {8, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.Electrical.Sources.BaseConverters.DCbusIdcSource dCbusIdcSource(Cdc = Cdc, ConvFixLossPu = ConvFixLossPu, ConvVarLossPu = ConvVarLossPu, IdcSource0Pu = IdcSource0Pu, UdcSource0Pu = UdcSource0Pu)  annotation(
    Placement(visible = true, transformation(origin = {68, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

equation
  running.value = gridInterface.running;
  running.value = vSCAverage.running;
  running.value = dCbusIdcSource.running;
 connect(gridInterface.idPccPu, vSCAverage.idPccPu) annotation(
    Line(points = {{-38, -20}, {-14, -20}}, color = {0, 0, 127}));
 connect(gridInterface.iqPccPu, vSCAverage.iqPccPu) annotation(
    Line(points = {{-38, -28}, {-14, -28}}, color = {0, 0, 127}));
 connect(vSCAverage.udFilterPu, gridInterface.udFilterPu) annotation(
    Line(points = {{-14, -12}, {-38, -12}}, color = {0, 0, 127}));
 connect(vSCAverage.uqFilterPu, gridInterface.uqFilterPu) annotation(
    Line(points = {{-14, -4}, {-38, -4}}, color = {0, 0, 127}));
 connect(vSCAverage.PConvPu, dCbusIdcSource.PConvPu) annotation(
    Line(points = {{30, -20}, {46, -20}}, color = {0, 0, 127}));
 connect(gridInterface.terminal, terminal) annotation(
    Line(points = {{-81, -20}, {-110, -20}}, color = {0, 0, 255}));
 connect(theta, gridInterface.theta) annotation(
    Line(points = {{-108, -48}, {-60, -48}, {-60, -42}}, color = {0, 0, 127}));
 connect(omegaPu, gridInterface.omegaPu) annotation(
    Line(points = {{-108, -60}, {-20, -60}, {-20, -36}, {-38, -36}}, color = {0, 0, 127}));
 connect(omegaPu, vSCAverage.omegaPu) annotation(
    Line(points = {{-108, -60}, {-20, -60}, {-20, -36}, {-14, -36}}, color = {0, 0, 127}));
 connect(udConvPu, vSCAverage.udConvPu) annotation(
    Line(points = {{-108, -74}, {0, -74}, {0, -42}}, color = {0, 0, 127}));
 connect(uqConvPu, vSCAverage.uqConvPu) annotation(
    Line(points = {{-108, -86}, {17, -86}, {17, -42}}, color = {0, 0, 127}));
 connect(IdcSourcePu, dCbusIdcSource.IdcSourcePu) annotation(
    Line(points = {{-108, -100}, {68, -100}, {68, -42}}, color = {0, 0, 127}));
 connect(vSCAverage.iqConvPu, iqConvPu) annotation(
    Line(points = {{24, 2}, {24, 6}, {108, 6}}, color = {0, 0, 127}));
 connect(vSCAverage.idConvPu, idConvPu) annotation(
    Line(points = {{16, 2}, {16, 18}, {108, 18}}, color = {0, 0, 127}));
 connect(vSCAverage.uqFilterPu, uqFilterPu) annotation(
    Line(points = {{-14, -12}, {-20, -12}, {-20, 58}, {108, 58}}, color = {0, 0, 127}));
 connect(vSCAverage.udFilterPu, udFilterPu) annotation(
    Line(points = {{-14, -4}, {-32, -4}, {-32, 70}, {108, 70}}, color = {0, 0, 127}));
 connect(dCbusIdcSource.UdcPu, UdcPu) annotation(
    Line(points = {{90, -20}, {102, -20}, {102, -20}, {108, -20}}, color = {0, 0, 127}));
 connect(vSCAverage.PFilterPu, PFilterPu) annotation(
    Line(points = {{0, 2}, {0, 43}, {108, 43}}, color = {0, 0, 127}));
 connect(vSCAverage.QFilterPu, QFilterPu) annotation(
    Line(points = {{8, 2}, {8, 31}, {108, 31}}, color = {0, 0, 127}));
 connect(gridInterface.udPccPu, udPccPu) annotation(
    Line(points = {{-52, 2}, {-52, 2}, {-52, 94}, {108, 94}, {108, 94}}, color = {0, 0, 127}));
 connect(gridInterface.uqPccPu, uqPccPu) annotation(
    Line(points = {{-46, 2}, {-44, 2}, {-44, 84}, {108, 84}, {108, 84}}, color = {0, 0, 127}));
annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-3, 6}, extent = {{-49, 42}, {49, -42}}, textString = "VSC")}, coordinateSystem(initialScale = 0.1)));

end VSCIdcSource;
