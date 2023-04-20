within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.OEL;

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

model InvTimeChar
  import Modelica.Blocks;
  import Dynawo;
  import Dynawo.Types;

  parameter Types.PerUnit XfdRatedPu = 2.6355 "Synchronous generator rated field current or voltage in pu (non-reciprocal base SNom, user-selected base voltage or UNom)";
  parameter Types.PerUnit XfdDesPu = 1 "Field current or field voltage setpoint in pu";
  parameter Types.PerUnit Xfd0Pu = 2 "Initial value of input XfdPu";
  parameter Types.PerUnit XfdRef0Pu = 1 "Initial value of XfdRefPu";
  parameter Types.Time T1 = 60 "Time of first characteristic point in s";
  parameter Types.Time T2 = 30 "Time of second characteristic point in s";
  parameter Types.Time T3 = 15 "Time of third characteristic point in s";
  parameter Types.PerUnit E1 = 1.1 "First field current or field voltage reference characteristic point in pu (base XfdRatedPu)";
  parameter Types.PerUnit E2 = 1.2 "Second field current or field voltage reference characteristic point in pu (base XfdRatedPu)";
  parameter Types.PerUnit E3 = 1.5 "Third field current or field voltage reference characteristic point in pu (base XfdRatedPu)";
  parameter Types.PerUnit XfdPu_activation_threshold = E1 "XfdPu threshold where the OEL activates, should be the rightmost point in the characteristic (in the RVS case, it's 1.5 XfdPu)";
  parameter Types.PerUnit XfdPu_deactivation_threshold = 0.98 * XfdPu_activation_threshold "XfdPu threshold where the OEL deactivates";

  Blocks.Interfaces.RealInput XfdPu(start = Xfd0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Blocks.Interfaces.RealOutput XfdRefPu(start = XfdRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.PerUnit XfdPu_in(start = Xfd0Pu / XfdRatedPu) "Input field current or field voltage in pu (base XfdRatedPu)";
  Types.PerUnit XfdRefPu_out(start = XfdRef0Pu * XfdRatedPu) "output field current or field voltage reference in pu (non-reciprocal base SNom, user-selected base voltage or UNom)";
  Types.Time tstart_OEL(start = 0) "start time of (last) OEL activation in s";
  Types.Time dt_OEL(start = 0) "time elapsed since OEL was triggered in s";

  Blocks.Tables.CombiTable1D invLookup(table = Se_inv, tableName="OEL_inverse_saturation_time_characteristic", extrapolation = Blocks.Types.Extrapolation.HoldLastPoint);
  Blocks.Logical.RSFlipFlop OEL_active(Qini = Xfd0Pu / XfdRatedPu > XfdPu_activation_threshold);
  Types.Time t_OEL(start = 0);

protected
  parameter Types.PerUnit Se_inv[:, :] = [T3-1, E3; T3, E3; T2, E2; T1, E1; T1+1, E1];

equation
  // pu conversion
  XfdPu_in = XfdPu / XfdRatedPu;
  XfdRefPu = XfdRefPu_out * XfdRatedPu;

  // OEL activity boundaries
  OEL_active.S = XfdPu_in > XfdPu_activation_threshold;
  OEL_active.R = XfdPu_in <= XfdPu_deactivation_threshold;

  // timer
  when OEL_active.Q then
    tstart_OEL = time;
  end when;
  t_OEL = if OEL_active.Q then tstart_OEL else time;
  dt_OEL = if OEL_active.Q then time - t_OEL else 0;

  // determination of output
  invLookup.u[1] = dt_OEL;
  XfdRefPu_out = invLookup.y[1];

  annotation(preferredView = "text");
end InvTimeChar;
