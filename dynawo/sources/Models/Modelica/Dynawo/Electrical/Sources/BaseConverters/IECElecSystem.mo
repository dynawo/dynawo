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
  parameter Types.PerUnit Res "Electrical system serial resistance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Xes "Electrical system serial reactance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Ges "Electrical system shunt conductance in pu (base UNom, SNom)" annotation(
  Dialog(group = "group", tab = "Electrical"));
  parameter Types.PerUnit Bes "Electrical system shunt susceptance in pu (base UNom, SNom)"annotation(
  Dialog(group = "group", tab = "Electrical"));

  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.Angle UPhase0 "Start value of voltage angle at plan terminal (PCC) in radians" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)" annotation(
  Dialog(group = "group", tab = "Operating point"));

  /*Parameters for internal initialization*/
  parameter Types.ComplexPerUnit u0Pu "Start value of the complex voltage at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of the complex current at plant terminal (PCC) in pu (base UNom, SnRef) (receptor convention)";
  parameter Types.PerUnit UGsRe0Pu "Start value of the real component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  parameter Types.PerUnit UGsIm0Pu "Start value of the imaginary component of the voltage at the converter's terminals (generator system) in pu (base UNom)";
  parameter Types.PerUnit IGsRe0Pu "Start value of the real component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)";
  parameter Types.PerUnit IGsIm0Pu "Start value of the imaginary component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)";

  /*Inputs*/
  Modelica.Blocks.Interfaces.BooleanInput running(start = true) "FOCB in the IEC standart which is the breaker position" annotation(
        Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iGsRePu(start = IGsRe0Pu) "Real component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {-70, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealInput iGsImPu(start = IGsIm0Pu) "Imaginary component of the current at the converter's terminals (generator system) in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {-70, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  /*Ouputs*/
  Modelica.Blocks.Interfaces.RealOutput uWtRePu(start = u0Pu.re) "Real component of the voltage at the wind turbine terminals (electrical system) in pu (base UNom)" annotation(
        Placement(visible = true, transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-20, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uWtImPu(start = u0Pu.im) "Imaginary component of the voltage at the wind turbine terminals (electrical system) in pu (base UNom) " annotation(
        Placement(visible = true, transformation(origin = {70, 25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {20, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtRePu(start = -i0Pu.re* SystemBase.SnRef / SNom) "Real component of the current at the wind turbine terminals in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {70, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-90, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput iWtImPu(start = -i0Pu.im* SystemBase.SnRef / SNom) "Imaginary component of the current at the wind turbine terminals in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-55, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uGsRePu(start = UGsRe0Pu) "Real component of the current at the wind turbine terminals in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {70, -25}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {90, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput uGsImPu(start = UGsIm0Pu) "Imaginary component of the current at the wind turbine terminals in pu (Ubase, SNom) (generator convention)" annotation(
        Placement(visible = true, transformation(origin = {70, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {55, -110}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));

  /*Other calculated variables*/
  Types.PerUnit uGsPu(start = sqrt(UGsRe0Pu^2 + UGsIm0Pu^2)) "Module of the voltage at converter side in pu (base UNom)";
  Types.PerUnit iGsPu(start = sqrt(IGsRe0Pu^2 + IGsIm0Pu^2)) "Module of the current at converter side in pu (base UNom, SNom)";

  /*Blocks*/
  Dynawo.Connectors.ACPower terminal(V(re(start = u0Pu.re), im(start = u0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Connector used to connect the converter to the grid" annotation(
        Placement(visible = true, transformation(extent = {{0, 0}, {0, 0}}, rotation = 0), iconTransformation(origin = {-105, -1}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
//

equation

  /* Voltage at WT terminals (before breaker, so grid side) */
  uWtRePu = max(terminal.V.re, 0.001);
//  uWtRePu = terminal.V.re;
  uWtImPu = terminal.V.im;
  //
  if running then

    /* Injected current at WT terminals (grid side, generator convention and base SNom, UNom) */
    iWtRePu = -terminal.i.re * (SystemBase.SnRef / SNom);
    iWtImPu = -terminal.i.im * (SystemBase.SnRef / SNom);

    /* Voltage at generator (converter side, base UNom) */
    uWtRePu = uGsRePu - Res * iWtRePu + Xes * iWtImPu;
    uWtImPu = uGsImPu - Res * iWtImPu - Xes * iWtRePu;
    iGsRePu = iWtRePu + (uGsRePu * Ges - uGsImPu * Bes);
    iGsImPu = iWtImPu + (uGsRePu * Bes + uGsImPu * Ges);

    /* Module of the voltage and currents at grid and converter side in pu (base UNom) */
    uGsPu = sqrt(uGsRePu ^ 2 + uGsImPu ^ 2);
    iGsPu = sqrt(iGsRePu ^ 2 + iGsImPu ^ 2);

  else

    uGsRePu = 0;
    uGsImPu = 0;
    iGsRePu = 0;
    iGsImPu = 0;
    iWtRePu = 0;
    iWtImPu = 0;
    uGsPu=0;
    iGsPu=0;

  end if;

annotation(
        preferredView = "text",
        Diagram(coordinateSystem(grid = {1, 1}, extent = {{-60, -60}, {60, 60}})),
        Icon(coordinateSystem(grid = {1, 1}, initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {0, 30}, extent = {{-100, -20}, {100, 20}}, textString = "Electrical"), Text(origin = {0, -30}, extent = {{-100, -20}, {100, 20}}, textString = "System")}));

end IECElecSystem;
