within Dynawo.Electrical.Controls.PEIR.BaseControls.GFM.PowerAngleControls;

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

model VirtualPower "Virtual active power computed from the current references before saturation"

  // Inputs
  Modelica.Blocks.Interfaces.RealInput idConvRefPu "d-axis current reference in the converter before current saturation in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu "q-axis current reference in the converter before current saturation in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput udFilterPu "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, -20}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}})));
  // Output
  Modelica.Blocks.Interfaces.RealOutput PvirtPu "Active virtual power in pu (base SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}})));
equation
  PvirtPu = udFilterPu*idConvRefPu + uqFilterPu*iqConvRefPu;

  annotation(
    preferredView = "text",
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(extent = {{-80, 40}, {80, -40}}, textString = "PVirt")}),
    Documentation(info = "<html><head></head><body>
<p>This block computes a virtual active power from the converter current references before current saturation and the voltage at the filter capacitor:</p>
<p>P<sub>Virt</sub> = u<sub>dFilter</sub> · i<sub>dConvRef</sub> + u<sub>qFilter</sub> · i<sub>qConvRef</sub></p>
<p>Used as the power feedback of the VSM instead of the measured filter power, it keeps the synchronization loop active while the current is saturated: the measured power is clipped, the virtual power is not. This limits the loss of synchronism during current saturation events. In steady state without saturation, P<sub>Virt</sub> = P<sub>Filter</sub>, since the filter capacitor absorbs no active power.</p>
</body></html>"));
end VirtualPower;
