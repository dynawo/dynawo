within Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical;

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

record PitchAngleControlParameters
  parameter Real DThetaCMax "Pitch maximum positive ramp rate of power PI controller, example value = 6" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real DThetaCMin  "Pitch dependent term of aerodynamic power partial derivative with respect to changes in Wind Turbine Rotor speed, example value = -3" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real DThetaMax "Pitch maximum positive ramp rate in degrees/s, example value = 6" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real DThetaMin "Pitch maximum negative ramp rate in degrees/s, example value = -3" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real DThetaOmegaMax "Pitch maximum positive ramp rate of speed PI controller in degrees/s, example value = 6" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real DThetaOmegaMin "Pitch maximum negative ramp rate of speed PI controller in degrees/s, example value = -3" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Types.PerUnit KIcPu "Integration gain of power PI controller, example value = 1e-9" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Types.PerUnit KIomegaPu "Integration gain of Speed PI controller, example value = 15" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Types.PerUnit KPcPu "Proportional gain of power PI controller, example value = 0" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Types.PerUnit KPomegaPu "Proportional gain of speed PI controller, example value = 15" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Types.PerUnit KPXPu "Cross coupling pitch gain , example value = 1" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real ThetaCMax "Maximum WT pitch angle of power PI controller in degrees, example value = 35" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real ThetaCMin "Minimum WT pitch angle of power PI controller in degrees, example value = 0" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real ThetaMax "Maximum WT pitch angle in degrees, example value = 35" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real ThetaMin "Minimum WT pitch angle in degrees, example value = 0" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real ThetaOmegaMax "Maximum WT pitch angle of speed PI controller in degrees, example value = 35" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Real ThetaOmegaMin "Minimum WT pitch angle of speed PI controller in degrees, example value = 0" annotation(
  Dialog(tab = "PitchAngleCtrl"));
  parameter Types.Time TTheta "WT pitch time constant in s, example value = 0.25" annotation(
  Dialog(tab = "PitchAngleCtrl"));

  annotation(
    preferredView = "text");
end PitchAngleControlParameters;
