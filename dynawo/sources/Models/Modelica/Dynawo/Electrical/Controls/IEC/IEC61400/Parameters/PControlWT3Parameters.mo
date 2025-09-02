within Dynawo.Electrical.Controls.IEC.IEC61400.Parameters;

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

record PControlWT3Parameters
  parameter Types.ActivePowerPu DPMaxPu "Maximum ramp rate of wind turbine power, example value = 999" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.ActivePowerPu DPRefMax4abPu "Maximum ramp rate for reference power of the wind turbine, example value = 0.3" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.ActivePowerPu DPRefMin4abPu "Minimum ramp rate for reference power of the wind turbine, example value = -0.3" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.PerUnit KDtd "Active drive train damping: gain, example value = 1.5" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Boolean MOmegaTMax "Mode for source of rotational speed for maximum torque calculation (false: OmegaWtr -- true: OmegaRef), example value = true" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Boolean MOmegaTqpi "Mode for source of rotational speed for torque PI controller error calculation (false: OmegaGen -- true: OmegaWtr), example value = false" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Boolean MpUScale "Enable voltage scaling for power reference during a voltage dip (false: no scaling -- true: u scaling), example value = false" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.AngularVelocityPu OmegaDtdPu "Active drive train damping: frequency, derived from two-mass model parameters, example value = 11.3" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.AngularVelocityPu OmegaOffsetPu "Offset from the reference value to limit controller action during rotor speed changes, example value = 0" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.ActivePowerPu PDtdMaxPu "Active drive train damping: maximum power, example value = 0.15" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Real TableOmegaPPu[:,:] = [0, 0.76; 0.3, 0.76; 0.31, 0.86; 0.4, 0.94; 0.5, 1; 1, 1] "Lookup table for power as a function of speed, example value = [0, 0.76; 0.3, 0.76; 0.31, 0.86; 0.4, 0.94; 0.5, 1; 1, 1]" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.Time tOmegafiltp3 "Filter time constant for measuring generator speed, example value = 0.005" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.Time tOmegaRef "Time constant in the speed reference filter, example value = 0.005" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.Time tPord "Power order lag time constant, example value = 0.01" annotation(
  Dialog(tab = "PControl", group = "WT"));
  parameter Types.PerUnit Zeta "Active drive train damping: damping coefficient, example value = 0.5" annotation(
  Dialog(tab = "PControl", group = "WT"));

  annotation(
    preferredView = "text");
end PControlWT3Parameters;
