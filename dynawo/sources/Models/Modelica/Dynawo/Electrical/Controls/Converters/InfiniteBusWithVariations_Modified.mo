within Dynawo.Electrical.Controls.Converters;

model InfiniteBusWithVariations_Modified "Infinite bus with configurable variations on the voltage module and on the frequency"
  /*
  * Copyright (c) 2021, RTE (http://www.rte-france.com)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at http://mozilla.org/MPL/2.0/.
  * SPDX-License-Identifier: MPL-2.0
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
  */
  extends AdditionalIcons.Bus;
  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  parameter Types.PerUnit U0Pu "Infinite bus voltage module before and after event in pu (base UNom)";
  parameter Types.PerUnit UEvtPu "Infinite bus voltage module during event in pu (base UNom)";
  parameter Types.PerUnit omega0Pu "Infinite bus angular frequency before and after event in pu (base OmegaNom)";
  parameter Types.PerUnit omegaEvtPu "Infinite bus angular frequency during event in pu (base OmegaNom)";
  parameter Types.Angle UPhase "Infinite bus voltage angle before event in rad";
  parameter Types.Time tUEvtStart "Start time of voltage event in s";
  parameter Types.Time tUEvtEnd "Ending time of voltage event in s";
  parameter Types.Time tOmegaEvtStart "Start time of frequency event in s";
  parameter Types.Time tOmegaEvtEnd "Ending time of frequency event in s";
  Types.PerUnit UPu "Infinite bus voltage module in pu (base UNom)";
  Types.PerUnit PPu "Infinite bus active power in pu (base SnRef) (receptor convention)";
  Types.PerUnit QPu "Infinite bus reactive power in pu (base SnRef) (receptor convention)";
  Types.PerUnit omegaPu "Infinite bus angular frequency in pu (base OmegaNom)";
  Types.Angle UPhaseOffs "Infinite bus voltage phase shift in rad";
  Modelica.Blocks.Interfaces.RealOutput omegaPu_out annotation(
    Placement(visible = true, transformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
// Infinite bus equation
  terminal.V = UPu * ComplexMath.exp(ComplexMath.j * (UPhase - UPhaseOffs));
// Voltage amplitude variation
  if time < tUEvtStart or time >= tUEvtEnd then
    UPu = U0Pu;
  else
    UPu = UEvtPu;
  end if;
// Frequency variation
  if time < tOmegaEvtStart then
    omegaPu = omega0Pu;
    UPhaseOffs = 0;
  elseif time >= tOmegaEvtEnd then
    omegaPu = omega0Pu;
    UPhaseOffs = (omega0Pu - omegaEvtPu) * (tOmegaEvtEnd - tOmegaEvtStart) * SystemBase.omegaNom;
  else
    omegaPu = omegaEvtPu;
    UPhaseOffs = (omega0Pu - omegaPu) * (time - tOmegaEvtStart) * SystemBase.omegaNom;
  end if;
// Outputs signals
  PPu = ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i));
  QPu = ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));
  
  omegaPu_out=omegaPu;
  annotation(
    preferredView = "text",
    Documentation(info = "<html>
<p> Infinite bus extended with step disturbance in voltage and frequency and measurement signals as output signals </p>
</html>"));
end InfiniteBusWithVariations_Modified;