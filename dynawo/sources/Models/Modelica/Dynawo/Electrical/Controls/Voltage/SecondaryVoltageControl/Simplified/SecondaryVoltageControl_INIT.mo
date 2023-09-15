within Dynawo.Electrical.Controls.Voltage.SecondaryVoltageControl.Simplified;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SecondaryVoltageControl_INIT "Initialisation model for simplified secondary voltage control"

  parameter Integer NbMaxGen = 50 "Maximum number of generators that should participate in the considered secondary voltage control";
  parameter Boolean[NbMaxGen] Participate0 = fill(false, NbMaxGen) "If true, the generator participates in the secondary voltage control (for each generator connected to the SVC).";
  parameter Types.ActivePowerPu[NbMaxGen] P0Pu = zeros(NbMaxGen) "Start value of active power in pu (receptor convention) (base SnRef) (for each generator connected to the SVC)";
  parameter Types.ReactivePowerPu[NbMaxGen] Q0Pu = zeros(NbMaxGen) "Start value of reactive power in pu (receptor convention) (base SnRef) (for each generator connected to the SVC)";
  parameter Types.ReactivePower[NbMaxGen] Qr = zeros(NbMaxGen) "Participation factor of the generators to the secondary voltage control in Mvar (for each generator connected to the SVC)";
  parameter Types.ApparentPowerModule[NbMaxGen] SNom = ones(NbMaxGen) * SystemBase.SnRef "Nominal apparent power of the generator in MVA (for each generator connected to the SVC) (SnRef by default)";
  parameter Types.VoltageModulePu[NbMaxGen] U0Pu = ones(NbMaxGen) "Start value of voltage module in pu (base UNom) (for each generator connected to the SVC)";
  parameter Types.PerUnit[NbMaxGen] XTfoPu = zeros(NbMaxGen) "Reactance of the generator transformer in pu (base UNom, SNom) (for each generator connected to the SVC)";

  Types.PerUnit Level0 "Initial level demand (between -1 and 1)";

protected
  Types.PerUnit[NbMaxGen] ISquare0Pu "Start value of the square of the current in pu (base UNom, SnRef) (for each generator connected to the SVC)";
  Integer[NbMaxGen] Participate0Int "If 1, the generator participates in the secondary voltage control. If 0, the generator does not participate in the secondary voltage control (for each generator connected to the SVC)";
  Types.ReactivePowerPu[NbMaxGen] QStator0Pu "Start value of reactive power at stator in pu (receptor convention) (base SnRef) (for each generator connected to the SVC)";
  Types.ReactivePowerPu[NbMaxGen] QTfo0Pu "Start value of reactive power consumed by the transformer in pu (base SnRef) (for each generator connected to the SVC)";

equation
  for i in 1:NbMaxGen loop
    Participate0Int[i] = if Participate0[i] then 1 else 0;
  end for;
  ISquare0Pu = (P0Pu .^ 2 .+ Q0Pu .^ 2) ./ (U0Pu .^ 2);
  QTfo0Pu = ISquare0Pu .* XTfoPu .* SystemBase.SnRef ./ SNom;
  QStator0Pu = Q0Pu .- QTfo0Pu;
  Level0 = sum(-QStator0Pu .* SystemBase.SnRef .* Participate0Int) / sum(Qr .* Participate0Int);

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-140, -100}, {140, 100}})));
end SecondaryVoltageControl_INIT;
