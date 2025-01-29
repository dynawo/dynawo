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

record ParamsREPC
  parameter Boolean FreqFlag "Governor response disable (0) or enable (1)" annotation(
  Dialog(tab="Plant Control"));
  parameter Boolean RefFlag "Plant level reactive power (0) or voltage control (1)" annotation(
  Dialog(tab="Plant Control"));
  parameter Boolean VCompFlag "Reactive droop (0) or line drop compensation (1) if RefFlag true" annotation(
  Dialog(tab="Plant Control"));

  parameter Types.PerUnit DbdPu "Reactive power (RefFlag = 0) or voltage (RefFlag = 1) deadband in pu (base SNom or UNom) (typical: 0..0.1)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit DDn "Down regulation droop (typical: 20..33.3)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit DUp "Up regulation droop (typical: 0)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit EMaxPu "Maximum Volt/VAR error in pu (base UNom or SNom)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit EMinPu "Minimum Volt/VAR error in pu (base UNom or SNom)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit FDbd1Pu "Overfrequency deadband for governor response in pu (base omegaNom) (typical: 0.004)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit FDbd2Pu "Underfrequency deadband for governor response in pu (base omegaNom)^ (typical: 0.004)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit FEMaxPu "Maximum frequency error in droop regulator in pu (base omegaNom)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit FEMinPu "Minimum frequency error in droop regulator in pu (base omegaNom)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit Kc "Reactive droop when VCompFlag = 0" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit Ki "Volt/VAR regulator integral gain" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit Kig "Droop regulator integral gain" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit Kp "Volt/VAR regulator proportional gain" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.PerUnit Kpg "Droop regulator proportional gain" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.ActivePowerPu PMaxPu "Maximum plant level active power command in pu (base SNom)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.ActivePowerPu PMinPu "Minimum plant level active power command in pu (base SNom)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.ReactivePowerPu QMaxPu "Maximum plant level reactive power command in pu (base SNom)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.ReactivePowerPu QMinPu "Minimum plant level reactive power command in pu (base SNom)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.Time tFilterPC "Voltage and reactive power filter time constant in s (typical: 0.01..0.02)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.Time tFt "Plant controller Q output lead time constant in s" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.Time tFv "Plant controller Q output lag time constant in s (typical: 0.15..5)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.Time tLag "Plant controller P output lag time constant in s(typical: 0.15..5)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.Time tP "Active power filter time constant in s (typical: 0.01..0.02)" annotation(
  Dialog(tab="Plant Control"));
  parameter Types.VoltageModulePu VFrz "Voltage for freezing Volt/VAR regulator integrator (typical: 0..0.9)" annotation(
  Dialog(tab="Plant Control"));

  annotation(preferredView = "text");
end ParamsREPC;
