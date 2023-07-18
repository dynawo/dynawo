within Dynawo.Electrical.InverterBasedGeneration.BaseClasses.GenericIBG;

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

model OverFrequencySupport
  parameter Types.AngularVelocityPu OmegaDeadBandPu "Deadband of the overfrequency contribution in pu (base omegaNom)";
  parameter Types.AngularVelocityPu OmegaMaxPu "Maximum frequency before disconnection in pu (base omegaNom)";

  Modelica.Blocks.Interfaces.RealInput omegaPu annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PextPu annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput deltaP annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if omegaPu < OmegaDeadBandPu then
    deltaP = 0;
  elseif omegaPu < OmegaMaxPu then
    deltaP = PextPu * (omegaPu - OmegaDeadBandPu) / (OmegaMaxPu - OmegaDeadBandPu);
  else
    deltaP = PextPu;
  end if;

  annotation(preferredView = "text");
end OverFrequencySupport;
