within Dynawo.Electrical.Controls.IEC.IEC61400.BaseClasses;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model BaseWPPControl "Base control model for IEC N°61400-27-1 standard WPP"
  extends Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.PControlParameters;

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //PControl parameters
  parameter Types.PerUnit DPRefMaxPu "Maximum positive ramp rate for PD power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPRefMinPu "Minimum negative ramp rate for PD power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPwpRefMaxPu "Maximum positive ramp rate for WP power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit DPwpRefMinPu "Minimum negative ramp rate for WP power reference in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit Kiwpp "Power PI controller integration gain in pu/s (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit Kpwpp "Power PI controller proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.PerUnit KwppRef "Power reference gain in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PKiwppMaxPu "Maximum active power reference from integration in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PKiwppMinPu "Minimum active power reference from integration in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PRefMaxPu "Maximum PD power reference in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));
  parameter Types.ActivePowerPu PRefMinPu "Minimum PD power reference in pu (base SNom)" annotation(
    Dialog(tab = "PControlWP"));

  //QControl parameters
  parameter Types.PerUnit DXRefMaxPu "Maximum positive ramp rate for WT reactive power or voltage reference in pu/s (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit DXRefMinPu "Minimum negative ramp rate for WT reactive power or voltage reference in pu/s (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kiwpx "Reactive power or voltage PI controller integral gain in pu/s (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kpwpx "Reactive power or voltage PI controller proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit KwpqRef "Reactive power reference gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain in pu (base SNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.Time tUqFilt "Time constant for the UQ static mode in s" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.VoltageModulePu UwpqDipPu "Voltage threshold for UVRT detection in pu (base UNom)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMaxPu "Maximum WT reactive power or voltage reference from integration in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XKiwpxMinPu "Minimum WT reactive power or voltage reference from integration in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMaxPu "Maximum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));
  parameter Types.PerUnit XRefMinPu "Minimum WT reactive power or voltage reference in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "QControlWP"));

  //Input variables
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = -i0Pu.re * SystemBase.SnRef / SNom), im(start = -i0Pu.im * SystemBase.SnRef / SNom)) "Complex current at grid terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PWPRefPu(start = -P0Pu * SystemBase.SnRef / SNom) "Reference active power in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-200, 86}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-200, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput y(start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = false, transformation(origin = {-8, -56}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu PPDRefCom0Pu "Initial reference active power communicated to WT in pu (base SNom) (generator convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit X0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));

  annotation(
    preferredView = "diagram",
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-65, 110}, extent = {{-35, 26}, {167, -132}}, textString = "WP control and"), Text(origin = {-68, 58}, extent = {{-36, 28}, {172, -140}}, textString = "communication"), Text(origin = {-23, -64}, extent = {{-41, 26}, {87, -6}}, textString = "module")}),
  Diagram(coordinateSystem(extent = {{-180, -120}, {180, 120}})));
end BaseWPPControl;
