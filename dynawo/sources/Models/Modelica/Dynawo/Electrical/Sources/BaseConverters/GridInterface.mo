within Dynawo.Electrical.Sources.BaseConverters;

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

model GridInterface

/*
  Equivalent circuit and conventions:

      iPccPu
------->--(Rtransformer,Ltransformer)---(terminal)
    |
uFilterPu                         uPccPu
(Cfilter)
    |
--------------------------------------------------

*/

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the converter to the grid" annotation(
        Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {-105, -1}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));

  parameter Types.ApparentPowerModule SNom  "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Rtransformer      "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit Ltransformer      "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.ActivePowerPu P0Pu    "Start value of active power at the PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ReactivePowerPu Q0Pu  "Start value of reactive power at the PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ComplexPerUnit u0Pu   "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu   "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.Angle Theta0        "Start value of the phase shift between the converter's rotating frame and the grid rotating frame in radians";
  parameter Types.PerUnit UdFilter0Pu   "Start value of the d-axis voltage at the converter terminal (filter) in pu (base UNom)";

  Modelica.Blocks.Interfaces.BooleanInput running(start = true) annotation(
        Placement(visible = true, transformation(origin = {-66, 0}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput theta(start = Theta0) "Phase shift between the converter's rotating frame and the grid rotating frame in radians" annotation(
        Placement(visible = true, transformation(origin = {-66, -25}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter angular frequency in pu (base OmegaNom)" annotation(
        Placement(visible = true, transformation(origin = {-65.5, -49.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {-66, 50}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = 0) "q-axis voltage at the converter terminal (filter) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {-66, 25}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  Modelica.Blocks.Interfaces.RealOutput idPccPu(start = (-i0Pu.re*cos(Theta0) - i0Pu.im*sin(Theta0)) * SystemBase.SnRef / SNom) "d-axis current injected at the PCC in pu (base UNom, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {74.5, -25.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {110.5, -0.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu(start = (i0Pu.re*sin(Theta0) - i0Pu.im*cos(Theta0)) * SystemBase.SnRef / SNom) "q-axis current injected at the PCC in pu  (base UNom, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {74.5, -45.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {110.5, -40.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udPccPu(start = u0Pu.re*cos(Theta0) + u0Pu.im*sin(Theta0)) "d-axis voltage at the PCC in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {74, 45}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {37, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90))) ;
  Modelica.Blocks.Interfaces.RealOutput uqPccPu(start = -u0Pu.re*sin(Theta0) + u0Pu.im*cos(Theta0)) "q-axis voltage at the PCC in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {74, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {73, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Types.PerUnit UPccPu(start = sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Module of the voltage at PCC (base UNom)";
  Types.PerUnit PGenPu(start = -P0Pu) "Active power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit QGenPu(start = -Q0Pu) "Reactive power generated by the converter at the PCC in pu (base UNom, SnRef) (generator convention)";
  Types.PerUnit PGenPuBaseSNom(start = -P0Pu * (SystemBase.SnRef / SNom)) "Active power generated by the converter at the PCC in pu (base UNom, SNom) (generator convention)";
  Types.PerUnit QGenPuBaseSNom(start = -Q0Pu * (SystemBase.SnRef / SNom)) "Reactive power generated by the converter at the PCC in pu (base UNom, SNom) (generator convention) ";

equation

  if running then

    /* DQ reference frame change from network reference to converter reference and pu base change */
    [udPccPu; uqPccPu] = [cos(theta), sin(theta); -sin(theta), cos(theta)] * [terminal.V.re; terminal.V.im];
    [idPccPu; iqPccPu] = -[cos(theta), sin(theta); -sin(theta), cos(theta)] * [terminal.i.re; terminal.i.im] * SystemBase.SnRef / SNom;

    /* RL Transformer dynamic equation */
/*    Ltransformer / SystemBase.omegaNom * der(idPccPu) = udFilterPu - Rtransformer * idPccPu + omegaPu * Ltransformer * iqPccPu - udPccPu;
    Ltransformer / SystemBase.omegaNom * der(iqPccPu) = uqFilterPu - Rtransformer * iqPccPu - omegaPu * Ltransformer * idPccPu - uqPccPu; */

    0 = udFilterPu - Rtransformer * idPccPu + omegaPu * Ltransformer * iqPccPu - udPccPu;
    0 = uqFilterPu - Rtransformer * iqPccPu - omegaPu * Ltransformer * idPccPu - uqPccPu;

    /* Voltage module at PCC in pu (base UNom) */
    UPccPu = sqrt(udPccPu ^ 2 + uqPccPu ^ 2);

    /* Injected power at PCC and system bases */
    PGenPuBaseSNom = udPccPu * idPccPu + uqPccPu * iqPccPu;
    QGenPuBaseSNom = uqPccPu * idPccPu - udPccPu * iqPccPu;
    PGenPu = PGenPuBaseSNom * SNom / SystemBase.SnRef;
    QGenPu = QGenPuBaseSNom * SNom / SystemBase.SnRef;

  else

    udPccPu = 0;
    uqPccPu = 0;
    terminal.i.re = 0;
    terminal.i.im = 0;
    idPccPu = 0;
    iqPccPu = 0;
    UPccPu = 0;
    PGenPu = 0;
    QGenPu = 0;
    PGenPuBaseSNom = 0;
    QGenPuBaseSNom = 0;

  end if;

annotation(
        preferredView = "text",
        Diagram(coordinateSystem(grid = {1, 1}, extent = {{-55, -60}, {64, 60}})),
        Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-32, 57}, extent = {{-19, -18}, {82, -96}}, textString = "GI")}));

end GridInterface;
