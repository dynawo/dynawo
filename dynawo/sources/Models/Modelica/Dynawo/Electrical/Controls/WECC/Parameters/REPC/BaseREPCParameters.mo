within Dynawo.Electrical.Controls.WECC.Parameters.REPC;

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

record BaseREPCParameters "Common parameters for plant controllers"

  //Common parameters
  parameter Types.PerUnit DbdPu "Reactive power (RefFlag = 0) or voltage (RefFlag = 1) deadband in pu (base SNom or UNom) (typical: 0..0.1)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit DDnPu "Reciprocal of down regulation droop in pu (base SNom, omegaNom) (typical: 20..33.3)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit DUpPu "Reciprocal of up regulation droop in pu (base SNom, omegaNom) (typical: 0)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit EMaxPu "Maximum reactive power or voltage error in pu (base SNom or UNom) (typical: 999)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit EMinPu "Minimum reactive power or voltage error in pu (base SNom or UNom) (typical: -999)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit FDbd1Pu "Frequency deadband downside in pu (base omegaNom) (typical: -0.01.0)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit FDbd2Pu "Frequency deadband upside in pu (base omegaNom) (typical: 0..0.01)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit FEMaxPu "Maximum power error in droop regulator in pu (base SNom) (typical: 999)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit FEMinPu "Minimum power error in droop regulator in pu (base SNom) (typical: -999)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Boolean FreqFlag "Flag to turn on (1) or off (0) the active power control loop within the plant controller" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit Kc "Reactive droop gain in pu (base SNom, UNom)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit Ki "Reactive power or voltage regulator integrator gain in pu/s (base SNom or UNom)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit Kig "Active power control integrator gain in pu (base SNom)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit Kp "Reactive power or voltage regulator proportional gain in pu (base SNom or UNom)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit Kpg "Active power control proportional gain in pu (base SNom)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.ActivePowerPu PMaxPu "Maximum plant level active power command in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.ActivePowerPu PMinPu "Minimum plant level active power command in pu (base SNom) (generator convention)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Integer RefFlag "Plant level reactive power (0) or voltage control (1)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.Time tFilterPC "Voltage or reactive power measurement filter time constant in s (typical: 0.01..0.05)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.Time tFt "Q output lead time constant in s" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.Time tFv "Q output lag time constant in s (typical: 0.15..5)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.Time tLag "P output lag time constant in s (typical: 0.02..0.15)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.Time tP "Active power filter time constant in s (typical: 0.02..0.15)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Boolean UCompFlag "Reactive droop (0) or line drop compensation (1)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));
  parameter Types.PerUnit UFrzPu "Voltage below which plant control integrator state is frozen (typical: 0..0.7)" annotation(
    Dialog(tab = "Plant Controller", group = "Common"));

  annotation(
    preferredView = "text");
end BaseREPCParameters;
