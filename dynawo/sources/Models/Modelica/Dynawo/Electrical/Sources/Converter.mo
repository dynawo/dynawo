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

model Converter "Converter model for grid forming and grid following applications"

/*
  Equivalent circuit and conventions:
                       __________
IdcSourcePu     IdcPu |          |iConvPu                           iPccPu
-------->-------->----|          |-->-----(RFilter,LFilter)---------->--(RTransformer,LTransformer)---(terminal)
              |       |          |                                |
UdcSourcePu (Cdc)     |  DC/AC   |  uConvPu         uFilterPu (CFilter)                      uPccPu
              |       |          |                                |
              |       |          |                                |
----------------------|__________|---------------------------------------------------------------------

*/
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffGenerator;

  Connectors.ACPower terminal (V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the converter to the grid" annotation(
    Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {0, -105}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  parameter Types.PerUnit RFilter "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilter "Filter inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit CFilter "Filter capacitance in pu (base UNom, SNom)";
  parameter Types.PerUnit RTransformer "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LTransformer "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power module for the converter";
  parameter Types.PerUnit Cdc "DC capacitance in pu (base UdcNom, SNom)";

  Modelica.Blocks.Interfaces.RealInput IdcSourcePu(start = IdcSource0Pu) "DC current in pu (base UdcNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 0}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, 30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -30}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -40}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in rad" annotation(
    Placement(visible = true, transformation(origin = {-58, 50}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, 90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-58, -50}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {-105, -90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UdcSourceRefPu(start = UdcSource0Pu) "DC voltage reference in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {0, 63}, extent = {{-3, -3}, {3, 3}}, rotation = -90), iconTransformation(origin = { -105, -70}, extent = {{5, -5}, {-5, 5}}, rotation = 180)));

  Modelica.Blocks.Interfaces.RealOutput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 60}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {67, -60}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -90}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, 20}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 30}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, -20}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -30}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idPccPu(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, 40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {67, -40}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, -60}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UdcSourcePu(start = UdcSource0Pu) "DC voltage in pu (base UdcNom)" annotation(
    Placement(visible = true, transformation(origin = {67, 0}, extent = {{-3, -3}, {3, 3}}, rotation = 0), iconTransformation(origin = {105, 0}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PFilterPu(start = PFilter0Pu) "Active power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-30, -63}, extent = {{-3, -3}, {3, 3}}, rotation = -90), iconTransformation(origin = {-70, -105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput QFilterPu(start = QFilter0Pu) "Reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {40, -63}, extent = {{-3, -3}, {3, 3}}, rotation = -90), iconTransformation(origin = {70, -105}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));

  Types.PerUnit udConvPu(start = UdConv0Pu) "d-axis modulation voltage in pu (base UNom)";
  Types.PerUnit uqConvPu(start = UqConv0Pu) "q-axis modulation voltage in pu (base UNom)";
  Types.PerUnit udPccPu(start = UdPcc0Pu) "d-axis voltage at the PCC in pu (base UNom)";
  Types.PerUnit uqPccPu(start = UqPcc0Pu) "q-axis voltage at the PCC in pu (base UNom)";
  Types.PerUnit IdcPu(start = IdcSource0Pu) "DC Current entering the converter in pu (base UdcNom, SNom)";
  Types.PerUnit IConvPu(start = IConv0Pu) "Module of the current injected by the converter in pu (base UNom, SNom)";
  Types.PerUnit PGenPu(start = PGen0Pu) "Active power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit QGenPu(start = QGen0Pu) "Reactive power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  Types.Angle UPhase(start = UPhase0) "Voltage angle at terminal in rad";
  Types.VoltageModulePu UPu(start = U0Pu) "Voltage module at terminal in pu (base UNom)";

  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at terminal in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at terminal in pu (base UNom)";
  parameter Types.PerUnit UdPcc0Pu "Start value of the d-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit UqPcc0Pu "Start value of the q-axis voltage at the PCC in pu (base UNom)";
  parameter Types.PerUnit IdcSource0Pu "Start value of DC current in pu (base UdcNom, SNom)";
  parameter Types.PerUnit UdcSource0Pu "Start value of DC voltage in pu (base UdcNom)";
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.Angle Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  parameter Types.ActivePowerPu PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  parameter Types.Angle UPhase0 "Start value of voltage angle at terminal in rad";
  parameter Types.PerUnit IConv0Pu "Start value of module of the current injected by the converter in pu (base UNom, SNom)";
  parameter Types.PerUnit PGen0Pu "Start value of active power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  parameter Types.PerUnit QGen0Pu "Start value of reactive power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  parameter Types.VoltageModulePu U0Pu "Start value of voltage module at terminal in pu (base UNom)";

equation
  if running.value then
    /* DQ reference frame change from network reference to converter reference and pu base change */
    [udPccPu; uqPccPu] = [cos(theta), sin(theta); -sin(theta), cos(theta)] * [terminal.V.re; terminal.V.im];
    [idPccPu; iqPccPu] = - [cos(theta), sin(theta); -sin(theta), cos(theta)] * [terminal.i.re; terminal.i.im] * SystemBase.SnRef / SNom;

    /* RL Transformer */
    LTransformer / SystemBase.omegaNom * der(idPccPu) = udFilterPu - RTransformer * idPccPu + omegaPu * LTransformer * iqPccPu - udPccPu;
    LTransformer / SystemBase.omegaNom * der(iqPccPu) = uqFilterPu - RTransformer * iqPccPu - omegaPu * LTransformer * idPccPu - uqPccPu;

    /* RLC Filter */
    LFilter / SystemBase.omegaNom * der(idConvPu) = udConvPu - RFilter * idConvPu + omegaPu * LFilter * iqConvPu - udFilterPu;
    LFilter / SystemBase.omegaNom * der(iqConvPu) = uqConvPu - RFilter * iqConvPu - omegaPu * LFilter * idConvPu - uqFilterPu;
    CFilter / SystemBase.omegaNom * der(udFilterPu) = idConvPu + omegaPu * CFilter * uqFilterPu - idPccPu;
    CFilter / SystemBase.omegaNom * der(uqFilterPu) = iqConvPu - omegaPu * CFilter * udFilterPu - iqPccPu;
    IConvPu = sqrt (idConvPu * idConvPu + iqConvPu * iqConvPu);

    /* DC Side */
    Cdc * der(UdcSourcePu) = IdcSourcePu - IdcPu;

    /* AC Voltage Source */
    udConvPu = udConvRefPu * UdcSourcePu / UdcSourceRefPu;
    uqConvPu = uqConvRefPu * UdcSourcePu / UdcSourceRefPu;

    /* Power Conservation */
    udConvPu * idConvPu + uqConvPu * iqConvPu = UdcSourcePu * IdcPu;

    /* Power Calculation */
    PGenPu = (udPccPu * idPccPu + uqPccPu * iqPccPu) * SNom / SystemBase.SnRef;
    QGenPu = (uqPccPu * idPccPu - udPccPu * iqPccPu) * SNom / SystemBase.SnRef;
    PFilterPu = udFilterPu * idPccPu + uqFilterPu * iqPccPu;
    QFilterPu = uqFilterPu * idPccPu - udFilterPu * iqPccPu;

    /* Phase calculation */
    UPhase = Modelica.ComplexMath.arg(terminal.V);
    UPu = Modelica.ComplexMath.'abs'(terminal.V);

  else
    udPccPu = 0;
    uqPccPu = 0;
    terminal.i.re = 0;
    terminal.i.im = 0;
    idPccPu = 0;
    iqPccPu = 0;
    idConvPu = 0;
    iqConvPu = 0;
    udFilterPu = 0;
    uqFilterPu = 0;
    IConvPu = 0;
    IdcPu = 0;
    udConvPu = 0;
    uqConvPu = 0;
    UdcSourcePu = 0;
    PGenPu = 0;
    QGenPu = 0;
    PFilterPu = 0;
    QFilterPu = 0;
    UPhase = 0;
    UPu = 0;
  end if;

  annotation(preferredView = "text",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
    Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-133, -85.5}, extent = {{-25, 5.5}, {8, -4.5}}, textString = "omegaPu"), Text(origin = {-133, 4.5}, extent = {{-35, 14.5}, {8, -4.5}}, textString = "IdcSourcePu"), Text(origin = {-133, 44.5}, extent = {{-39, 12.5}, {8, -4.5}}, textString = "udConvRefPu"), Text(origin = {-133, 94.5}, extent = {{-17, 5.5}, {8, -4.5}}, textString = "theta"), Text(origin = {-131, -66.5}, extent = {{-43, 16.5}, {8, -4.5}}, textString = "UdcSourceRefPu"), Text(origin = {119, 100.5}, extent = {{-8, 4.5}, {38, -12.5}}, textString = "udFilterPu"), Text(origin = {-133, -35.5}, extent = {{-41, 14.5}, {8, -4.5}}, textString = "uqConvRefPu"), Text(origin = {119, 68.5}, extent = {{-8, 4.5}, {25, -9.5}}, textString = "idPccPu"), Text(origin = {117, 10.5}, extent = {{-8, 4.5}, {38, -16.5}}, textString = "UdcSourcePu"), Text(origin = {118, 37.5}, extent = {{-8, 4.5}, {25, -9.5}}, textString = "idConvPu"), Text(origin = {118, -21.5}, extent = {{-8, 4.5}, {30, -10.5}}, textString = "iqConvPu"), Text(origin = {118, -51.5}, extent = {{-8, 4.5}, {24, -12.5}}, textString = "iqPccPu"), Text(origin = {118, -78.5}, extent = {{-8, 4.5}, {35, -16.5}}, textString = "uqFilterPu"), Text(origin = {17, -107.5}, extent = {{-8, 4.5}, {14, -7.5}}, textString = "ACPower"), Text(origin = {5, 6}, extent = {{-95, 56}, {90, -68}}, textString = "Converter"), Text(origin = {-58, -104.5}, extent = {{-8, 4.5}, {38, -12.5}}, textString = "PFilterPu"), Text(origin = {81, -104.5}, extent = {{-8, 4.5}, {38, -12.5}}, textString = "QFilterPu")}));
end Converter;
