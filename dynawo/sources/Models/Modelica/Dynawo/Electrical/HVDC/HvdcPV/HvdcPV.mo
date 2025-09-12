within Dynawo.Electrical.HVDC.HvdcPV;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model HvdcPV "Model of PV HVDC link. Each terminal can regulate the voltage or the reactive power, depending on the user's choice."
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseHvdcPFixedReactiveLimits;
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseQStatus;
  extends Dynawo.Electrical.HVDC.BaseClasses.BaseVoltageRegulation;
  extends Dynawo.Electrical.HVDC.BaseClasses.BasePV(QInj1PuQNom(start = - s10Pu.im * SystemBase.SnRef / Q1Nom), QInj2PuQNom(start = - s20Pu.im * SystemBase.SnRef / Q2Nom));

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------HVDC-------<-- (terminal2)

*/

// blocks
  Modelica.Blocks.Sources.BooleanExpression blockingSide1(y = (q1Status == QStatus.AbsorptionMax or q1Status == QStatus.GenerationMax or runningSide1.value == false)) "Expression determining if reactive power limits have been reached on converter side 1 or if the hvdc is disconnected on side 1" annotation(
    Placement(transformation(origin = {70, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput blockerSide1 "If true, reactive power limits have been reached on converter side 1 or the hvdc is disconnected on side 1" annotation(
    Placement(transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression blockingSide2(y = (q2Status == QStatus.AbsorptionMax or q2Status == QStatus.GenerationMax or runningSide2.value == false)) "Expression determining if reactive power limits have been reached on converter side 2 or if the hvdc is disconnected on side 2" annotation(
    Placement(transformation(origin = {70, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput blockerSide2 "If true, reactive power limits have been reached on converter side 2 or the hvdc is disconnected on side 2" annotation(
    Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}})));

equation
  QInj1PuQNom = QInj1Pu * SystemBase.SnRef / Q1Nom;
  QInj2PuQNom = QInj2Pu * SystemBase.SnRef / Q2Nom;

  when QInj1Pu >= Q1MaxPu and U1Pu + Lambda1Pu * QInj1Pu <= U1RefPu then
    q1Status = QStatus.GenerationMax;
    limUQDown1 = false;
    limUQUp1 = true;
  elsewhen QInj1Pu <= Q1MinPu and U1Pu + Lambda1Pu * QInj1Pu >= U1RefPu then
    q1Status = QStatus.AbsorptionMax;
    limUQDown1 = true;
    limUQUp1 = false;
  elsewhen (QInj1Pu < Q1MaxPu or U1Pu + Lambda1Pu * QInj1Pu > U1RefPu) and (QInj1Pu > Q1MinPu or U1Pu + Lambda1Pu * QInj1Pu < U1RefPu) then
    q1Status = QStatus.Standard;
    limUQDown1 = false;
    limUQUp1 = false;
  end when;

  when QInj2Pu >= Q2MaxPu and U2Pu + Lambda2Pu * QInj2Pu <= U2RefPu then
    q2Status = QStatus.GenerationMax;
    limUQDown2 = false;
    limUQUp2 = true;
  elsewhen QInj2Pu <= Q2MinPu and U2Pu + Lambda2Pu * QInj2Pu >= U2RefPu then
    q2Status = QStatus.AbsorptionMax;
    limUQDown2 = true;
    limUQUp2 = false;
  elsewhen (QInj2Pu < Q2MaxPu or U2Pu + Lambda2Pu * QInj2Pu > U2RefPu) and (QInj2Pu > Q2MinPu or U2Pu + Lambda2Pu * QInj2Pu < U2RefPu) then
    q2Status = QStatus.Standard;
    limUQDown2 = false;
    limUQUp2 = false;
  end when;

  //Voltage/Reactive power regulation at terminal 1
  if runningSide1.value then
    if modeU1 then
      if q1Status == QStatus.GenerationMax then
        QInj1Pu = Q1MaxPu;
      elseif q1Status == QStatus.AbsorptionMax then
        QInj1Pu = Q1MinPu;
      else
        if UseLambda1 then
          U1Pu + Lambda1Pu * QInj1Pu = U1RefPu;
        else
          U1Pu = U1RefPu;
        end if;
      end if;
    else
      if - Q1RefPu <= Q1MinPu then
        QInj1Pu = Q1MinPu;
      elseif - Q1RefPu >= Q1MaxPu then
        QInj1Pu = Q1MaxPu;
      else
        Q1Pu = Q1RefPu;
      end if;
    end if;
  else
    QInj1Pu = 0;
  end if;

  //Voltage/Reactive power regulation at terminal 2
  if runningSide2.value then
    if modeU2 then
      if q2Status == QStatus.GenerationMax then
        QInj2Pu = Q2MaxPu;
      elseif q2Status == QStatus.AbsorptionMax then
        QInj2Pu = Q2MinPu;
      else
        if UseLambda2 then
          U2Pu + Lambda2Pu * QInj2Pu = U2RefPu;
        else
          U2Pu = U2RefPu;
        end if;
      end if;
    else
      if - Q2RefPu <= Q2MinPu then
        QInj2Pu = Q2MinPu;
      elseif - Q2RefPu >= Q2MaxPu then
        QInj2Pu = Q2MaxPu;
      else
        Q2Pu = Q2RefPu;
      end if;
    end if;
  else
    QInj2Pu = 0;
  end if;

  connect(blockingSide1.y, blockerSide1) annotation(
    Line(points = {{82, 40}, {110, 40}}, color = {255, 0, 255}));
  connect(blockingSide2.y, blockerSide2) annotation(
    Line(points = {{82, -40}, {110, -40}}, color = {255, 0, 255}));

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This HVDC link regulates the active power flowing through itself. It also regulates the voltage or the reactive power at each of its terminals. The active power setpoint is given as an input and can be modified during the simulation, as well as the voltage references and the reactive power references.</div></body></html>"));
end HvdcPV;
