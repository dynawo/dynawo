within Dynawo.Electrical.Controls.Converters.InnerControls;

/*
* Copyright (c) 2026, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model CurrentSaturation

  parameter Types.CurrentModulePu Imax "Current max threshold to limit a current's module";
  parameter Types.CurrentModulePu Imin "Current min threshold to limit a current's module";
  parameter Real W_CurrentLimit "Bandwidth of the current limitation";
  parameter Types.CurrentModulePu HysteresisPu = 0.01 "Half-width of the dead band around Imax/Imin, to avoid chattering at the activation threshold";
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = idConvRef0Pu) "value of id to be saturated" annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput idPcc(start = IdPcc0Pu) annotation(
    Placement(transformation(origin = {-120, -64}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-34, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = iqConvRef0Pu) "value of iq to be saturated" annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqPcc(start = IqPcc0Pu) annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {56, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.BooleanOutput BlocCurrentSaturation_Enable(start = false) annotation(
    Placement(transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput idConvSatRefPu(start = idConvSatRef0Pu) "value of the satured-value of id" annotation(
    Placement(transformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqConvSatRefPu(start = iqConvSatRef0Pu) "value of the satured-value of iq" annotation(
    Placement(transformation(origin = {110, 46}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}})));

  Types.PerUnit IConvRefFilterModulePu(start = CurrentModule0) "Module of the current in dq representation idConvRefPu,iqConvRefPu ";
  Types.PerUnit IConvRefFilterAnglePu(start = CurrentAngle0) "Phase Angle of the current in dq representation idConvRefPu,iqConvRefPu ";
  Types.PerUnit CurrentModulePcc(start = CurrentModule0) "Module of the current in dq representation idPccPu,iqPccPu ";

  Boolean saturating(start = CurrentModule0 > Imax) "True while the current reference is being clamped";
  Types.PerUnit idConvRefFilterPu(start = idConvRef0Pu) "Value of the Current idConvRefPu after a first order filter ";
  Types.PerUnit iqConvRefFilterPu(start = iqConvRef0Pu) "Value of the Current iqConvRefPu after a first order filter ";
  Types.PerUnit idPccFilterPu(start = IdPcc0Pu) "Value of the Current idPccPu after a predictive (extrapolated) first order term ";
  Types.PerUnit iqPccFilterPu(start = IqPcc0Pu) "Value of the Current iqPccPu after a predictive (extrapolated) first order term ";
  Types.PerUnit iConvSatRefModulePu "Value of the Current saturated given as reference to the voltage control in Pu";

  parameter Types.CurrentModulePu idConvRef0Pu "Start value of id to be saturated";
  parameter Types.CurrentModulePu iqConvRef0Pu "Start value of iq to be saturated";
  parameter Types.CurrentModulePu idConvSatRef0Pu "Start value of the satured-value of id";
  parameter Types.CurrentModulePu iqConvSatRef0Pu "Start value of the satured-value of iq";
  parameter Types.CurrentModulePu CurrentModule0 "Start value of the Module of the current in dq representation idConvPu,iqConvPu";
  parameter Types.CurrentModulePu CurrentAngle0 "Start value of the Phase Angle of the current in dq representation idConvPu,iqConvPu";
  parameter Types.PerUnit IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";

equation

  der(idConvRefFilterPu)*1/W_CurrentLimit + idConvRefFilterPu = idConvRefPu;
  der(iqConvRefFilterPu)*1/W_CurrentLimit + iqConvRefFilterPu = iqConvRefPu;
  IConvRefFilterModulePu = sqrt(idConvRefFilterPu*idConvRefFilterPu + iqConvRefFilterPu*iqConvRefFilterPu);


  IConvRefFilterAnglePu = atan2(iqConvRefFilterPu, idConvRefFilterPu);

  idPccFilterPu = idPcc + der(idPcc)/W_CurrentLimit;
  iqPccFilterPu = iqPcc + der(iqPcc)/W_CurrentLimit;
  CurrentModulePcc = sqrt(idPccFilterPu^2 + iqPccFilterPu^2);

  when IConvRefFilterModulePu > Imax + HysteresisPu or CurrentModulePcc > Imax + HysteresisPu then
    saturating = true;
  elsewhen IConvRefFilterModulePu < Imax - HysteresisPu and CurrentModulePcc < Imax - HysteresisPu then
    saturating = false;
  end when;
  BlocCurrentSaturation_Enable = saturating;
  if saturating then
    idConvSatRefPu = Imax*cos(IConvRefFilterAnglePu);
    iqConvSatRefPu = Imax*sin(IConvRefFilterAnglePu);
  else
    if CurrentModulePcc < Imin then
      idConvSatRefPu = Imin*cos(IConvRefFilterAnglePu);
      iqConvSatRefPu = Imin*sin(IConvRefFilterAnglePu);
    else
      idConvSatRefPu = idConvRefPu;
      iqConvSatRefPu = iqConvRefPu;
    end if;
  end if;

  iConvSatRefModulePu = sqrt(idConvSatRefPu^2 + iqConvSatRefPu^2);

  annotation(
    preferredView = "text",
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {-167, 42}, extent = {{-41, 25}, {41, -25}}, textString = "idConvRefPu"), Text(origin = {-168, 2}, extent = {{-42, 16}, {42, -16}}, textString = "iqConvRefPu"), Text(origin = {174, 54}, textColor = {46, 194, 126}, extent = {{-56, 50}, {56, -50}}, textString = "idConvSatRefPu"), Text(origin = {175, -9}, textColor = {46, 194, 126}, extent = {{-55, 49}, {55, -49}}, textString = "iqConvsatRefPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 2}, extent = {{-98, 84}, {98, -84}}, textString = "%name"), Text(origin = {-28, -132}, extent = {{-42, 16}, {42, -16}}, textString = "idPcc"), Text(origin = {78, -132}, extent = {{-42, 16}, {42, -16}}, textString = "iqPcc"), Text(origin = {53, 132}, textColor = {134, 94, 60}, extent = {{-47, 14}, {47, -14}}, textString = "CurrentSaturation Enable")}));
end CurrentSaturation;
