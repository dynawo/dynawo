within Dynawo.Electrical.Controls.IEC.IEC63406.Protections.AuxiliaryProtections;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model FRTCurrentCalculation "Current orders calculation during FRT (IEC63406)"

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  //Parameters
  parameter Types.PerUnit iPSetPu "Active current setting during LVRT or HVRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit iQSetPu "Reactive current setting during LVRT or HVRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K1Ip "Active current factor 1 during LVRT or HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K2Ip "Active current factor 2 during LVRT or HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K1Iq "Reactive current factor 1 during LVRT or HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit K2Iq "Reactive current factor 2 during LVRT or HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit KpRT "Active power factor during LVRT or HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit KqRT "Reactive power factor during LVRT or HVRT" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ActivePowerPu pSetPu "Active power setting during LVRT or HVRT in pu (base SNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.ReactivePowerPu qSetPu "Reactive power setting during LVRT or HVRT in pu (base SNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit uHVRTPu "HVRT threshold value in pu (base UNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit uLVRTPu "LVRT threshold value in pu (base UNom)" annotation(
    Dialog(tab = "FRT"));
  parameter Types.PerUnit uRTPu "LVRT or HVRT threshold value in pu (base UNom)" annotation(
    Dialog(tab = "FRT"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput iPcmdPu(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iQcmdPu(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current command at converter terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pMeasPu(start = -P0Pu * SystemBase.SnRef / SNom) "Measured (and filtered) active power component in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qMeasPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uMeasPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput ipRTPu0(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current in pu (base SNom, UNom) calculated by the FRT module and used if H/LVRT_IN_PFlag = 0 (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ipRTPu1(start = -P0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Active current in pu (base SNom, UNom) calculated by the FRT module and used if H/LVRT_IN_PFlag = 1 (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRTPu0(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current in pu (base SNom, UNom) calculated by the FRT module and used if H/LVRT_IN_QFlag = 0 (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqRTPu1(start = Q0Pu * SystemBase.SnRef / (SNom * U0Pu)) "Reactive current in pu (base SNom, UNom) calculated by the FRT module and used if H/LVRT_IN_QFlag = 1 (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.ActivePowerPu pPreFaultPu(start = 0) "Active power measured on the time step preceding a fault in pu (base SNom)";
  Types.ReactivePowerPu qPreFaultPu(start = 0) "Reactive power measured on the time step preceding a fault in pu (base SNom)";

  //Initial parameters
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(group = "Operating point"));

equation
  //PreFault powers for the fault control loop
  when uMeasPu < uLVRTPu then
    pPreFaultPu = pre(pMeasPu);
    qPreFaultPu = pre(qMeasPu);
  elsewhen uMeasPu > uHVRTPu then
    pPreFaultPu = pre(pMeasPu);
    qPreFaultPu = pre(qMeasPu);
  end when;

  ipRTPu0 = K1Ip * uMeasPu + K2Ip * iPcmdPu + iPSetPu;
  ipRTPu1 = (KpRT * pPreFaultPu + pSetPu) / uMeasPu;
  iqRTPu0 = K1Iq * (uRTPu - uMeasPu) + K2Iq * iQcmdPu + iQSetPu;
  iqRTPu1 = (KqRT * qPreFaultPu + qSetPu) / uMeasPu;

  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-100, 100}, {100, -100}}, textString = "FRT
Current
Calculat°")}));
end FRTCurrentCalculation;
