within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.LimitsCalculation;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model BaseLimitsCalculation "Reactive and active currents limits calculation base model for the HVDC VSC model"
  import Modelica;
  import Dynawo;

  extends Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters.ParamsLimitsCalculation;

  //Input variables
  Modelica.Blocks.Interfaces.RealInput ipRefPu(start = Ip0Pu) "Active current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {0, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput iqModPu(start = 0) "Additional reactive current in case of fault or overvoltage in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-60,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqRefPu(start = Iq0Pu) "Reactive current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {0,-120}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput iqMaxPu(start = sqrt(InPu ^ 2 - Ip0Pu ^ 2)) "Maximum reactive current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput iqMinPu(start = -sqrt(InPu ^ 2 - Ip0Pu ^ 2)) "Minimum reactive current reference in pu (base SNom, UNom) (DC to AC)" annotation(
    Placement(visible = true, transformation(origin = {-110, -30}, extent = {{10, -10}, {-10, 10}}, rotation = 0), iconTransformation(origin = { -110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));

  parameter Types.PerUnit Ip0Pu "Start value of active current in pu (base SNom, UNom) (DC to AC)";
  parameter Types.PerUnit Iq0Pu "Start value of reactive current in pu (base SNom, UNom) (DC to AC)";

equation
  if iqModPu == 0 then
    iqMaxPu = max(0.001, sqrt(InPu ^ 2 - min(InPu ^ 2, ipRefPu ^ 2)));
  else
    iqMaxPu = InPu;
  end if;

  iqMinPu = -iqMaxPu;

  annotation(preferredView = "text");
end BaseLimitsCalculation;
