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

model IECElecSystem
  /*
  Equivalent circuit and conventions:
  */
  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;
  /*Constructive parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.PerUnit Res "Electrical system resistance in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Les "Electrical system inductance in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical system shunt conductance in p.u (base UNom, SNom)" annotation(Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in p.u (base UNom, SNom)"annotation(Dialog(group = "group", tab = "Electrical"));
  /*Parameters for initialization from load flow*/
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in p.u (base UNom)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in p.u (base UNom, SnRef) (receptor convention)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in p.u (base SnRef) (receptor convention)" annotation(Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in p.u (base SnRef) (receptor convention)" annotation(Dialog(group = "group", tab = "Operating point"));
  /*Parameters for internal initialization*/
  final parameter Types.PerUnit UGsRe0Pu = u0Pu.re - Res * (i0Pu.re* SystemBase.SnRef / SNom) + SystemBase.omegaRef0Pu * Les * (i0Pu.im* SystemBase.SnRef / SNom) "Start value of the real component of the voltage at the converter's terminals (generator system) in p.u (base UNom)";
  final parameter Types.PerUnit UGsIm0Pu = u0Pu.im - Res * (i0Pu.im* SystemBase.SnRef / SNom) - SystemBase.omegaRef0Pu * Les * (i0Pu.re* SystemBase.SnRef / SNom) "Start value of the imaginary component of the voltage at the converter's terminals (generator system) in p.u (base UNom)";
  final parameter Types.PerUnit IGsRe0Pu = (-i0Pu.re * SystemBase.SnRef / SNom) + (u0Pu.re * Ges - u0Pu.im * Bes) "Start value of the real component of the current at the converter's terminals (generator system) in p.u (Ubase, SNom) in generator convention";
  final parameter Types.PerUnit IGsIm0Pu = (-i0Pu.im * SystemBase.SnRef / SNom) + (u0Pu.re * Bes + u0Pu.im * Ges) "Start value of the imaginary component of the current at the converter's terminals (generator system) in p.u (Ubase, SNom) in generator convention";

  /*Inputs*/
  Modelica.Blocks.Interfaces.BooleanInput running(start = true) "FOCB in the IEC standart which is the breaker position" annotation(
        Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iGsRePu(start = IGsRe0Pu) "Real component of the current at the converter's terminals (generator system) in p.u (Ubase, SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iGsImPu(start = IGsIm0Pu) "Imaginary component of the current at the converter's terminals (generator system) in p.u (Ubase, SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  /*Ouputs*/
  Modelica.Blocks.Interfaces.RealOutput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine terminals (electrical system) in p.u (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {40, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine terminals (electrical system) in p.u (base UNom) " annotation(
        Placement(visible = true, transformation(origin = {70, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtRePu(start = -i0Pu.re* SystemBase.SnRef / SNom) "Real component of the current at the wind turbine terminals in p.u (Ubase, SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {70, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-80, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtImPu(start = -i0Pu.im* SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals in p.u (Ubase, SNom) in generator convention" annotation(
        Placement(visible = true, transformation(origin = {70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-40, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uWtPu(start = sqrt(u0Pu.re*u0Pu.re + u0Pu.im*u0Pu.im)) "Module of the voltage at wind turbine terminals in p.u (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));

  /*Other calculated variables*/
  Types.PerUnit uGsRePu(start = UGsRe0Pu) "Real component of the voltage at the converter's terminals (generator system) in p.u (base UNom)";
  Types.PerUnit uGsImPu(start = UGsIm0Pu) "Real component of the voltage at the converter's terminals (generator system) in p.u (base UNom)";
  Types.PerUnit UConvPu(start = sqrt(UGsRe0Pu^2 + UGsIm0Pu^2)) "Module of the voltage at converter side in p.u (base UNom)";
  Types.PerUnit IWtPu(start = sqrt(i0Pu.re*i0Pu.re + i0Pu.im*i0Pu.im)* SystemBase.SnRef / SNom) "Module of the current at PCC in p.u (base UNom, SNom)";
  Types.PerUnit IGsPu(start = sqrt(IGsRe0Pu^2 + IGsIm0Pu^2)) "Module of the current at converter side in p.u (base UNom, SNom)";
  Types.PerUnit PGenPu(start = -P0Pu) "Active power generated by the converter at the PCC in p.u (base UNom, SnRef) (generator convention)";
  Types.PerUnit QGenPu(start = -Q0Pu) "Reactive power generated by the converter at the PCC in p.u (base UNom, SnRef) (generator convention)";
  Types.PerUnit PGenPuBaseSNom(start = -P0Pu * (SystemBase.SnRef / SNom)) "Active power generated by the converter at the PCC in p.u (base UNom, SNom) (generator convention)";
  Types.PerUnit QGenPuBaseSNom(start = -Q0Pu * (SystemBase.SnRef / SNom)) "Reactive power generated by the converter at the PCC in p.u (base UNom, SNom) (generator convention) ";
  /*Blocks*/
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the converter to the grid" annotation(
        Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {-105, -1}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
//
equation
  /* Voltage at WT terminals (before breaker, so grid side) */
  uWtRePu = terminal.V.re;
  uWtImPu = terminal.V.im;
  //
  if running then
    /* Injected current at WT terminals (grid side, generator convention and base SNom, UNom) */
    iWtRePu = -terminal.i.re * (SystemBase.SnRef / SNom);
    iWtImPu = -terminal.i.im * (SystemBase.SnRef / SNom);
    /* Voltage at generator (converter side, base UNom) */
    //Les / SystemBase.omegaNom * der(iWtRePu) = uGsRePu - Res * iWtRePu + SystemBase.omegaRef0Pu * Les * iWtImPu - uWtRePu;
    //Les / SystemBase.omegaNom * der(iWtImPu) = uGsImPu - Res * iWtImPu - SystemBase.omegaRef0Pu * Les * iWtRePu - uWtImPu;
    0 = uGsRePu - Res * iWtRePu + SystemBase.omegaRef0Pu * Les * iWtImPu - uWtRePu;
    0 = uGsImPu - Res * iWtImPu - SystemBase.omegaRef0Pu * Les * iWtRePu - uWtImPu;
    /* Current at generator (converter side, generator convention and base SNom, UNom) */
    iGsRePu = iWtRePu + (uGsRePu * Ges - uGsImPu * Bes);
    iGsImPu = iWtImPu + (uGsRePu * Bes + uGsImPu * Ges);
    /* Module of the voltage and currents at grid and converter side in p.u. (base UNom) */
    uWtPu = sqrt(uWtRePu ^ 2 + uWtImPu ^ 2);
    UConvPu = sqrt(uGsRePu ^ 2 + uGsImPu ^ 2);
    IWtPu= sqrt(iWtRePu ^ 2 + iWtImPu ^ 2);
    IGsPu= sqrt(iGsRePu ^ 2 + iGsImPu ^ 2);
    /* Injected power at PCC in nominal and system bases */
    PGenPuBaseSNom = uWtRePu * iWtRePu + uWtImPu* iWtImPu;
    QGenPuBaseSNom = uWtImPu * iWtRePu - uWtRePu * iWtImPu;
    PGenPu = PGenPuBaseSNom * SNom / SystemBase.SnRef;
    QGenPu = QGenPuBaseSNom * SNom / SystemBase.SnRef;
  else
    uGsRePu = 0;
    uGsImPu = 0;
    iGsRePu = 0;
    iGsImPu = 0;
    iWtRePu = 0;
    iWtImPu = 0;
    //terminal.i.re = 0;
    //terminal.i.im = 0;
    uWtPu=0;
    UConvPu=0;
    IWtPu=0;
    IGsPu=0;
    PGenPu = 0;
    QGenPu = 0;
    PGenPuBaseSNom = 0;
    QGenPuBaseSNom = 0;
  end if;
  annotation(
        preferredView = "text",
        Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -60}, {60, 60}})),
        Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Electrical"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));
end IECElecSystem;
