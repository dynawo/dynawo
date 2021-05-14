within Dynawo.Electrical.Buses;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model InfiniteBusWithVariations "Infinite bus with configurable variations on the voltage or the frequency"
  import Modelica.Constants;

  import Dynawo.Connectors;
  import Dynawo.Types;

  extends AdditionalIcons.Bus;

  Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {-1.42109e-14, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-1.42109e-14, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit U0Pu "Infinite bus constant voltage module in p.u (base UNom)";
  parameter Types.PerUnit UEvtPu "Infinite bus constant voltage module during event in p.u (base UNom)";
  parameter Types.PerUnit omega0Pu "Infinite bus angular frequency in p.u";
  parameter Types.PerUnit omegaEvtPu "Infinite bus angular frequency in p.u";
  parameter Types.Angle UPhase "Infinite bus constant voltage angle in rad";
  parameter Types.Time tUEvtStart "Start time of voltage event in seconds";
  parameter Types.Time tUEvtEnd "Ending time of voltage event in seconds";
  parameter Types.Time tOmegaEvtStart "Start time of frequency event in seconds";
  parameter Types.Time tOmegaEvtEnd "Ending time of frequency event in seconds";

  Types.PerUnit UPu "Voltage magnitude in p.u (base UNom)";
  Types.PerUnit PPu "Active power in p.u (base SnRef) (receptor convention)";
  Types.PerUnit QPu "Reactive power in p.u (base SnRef) (receptor convention)";
  Types.PerUnit OmegaPu "Frequency in p.u (base OmegaNom)";
  Types.Angle UPhaseOffs "Voltage angle in deg";

equation

  // Infinite bus equation
  terminal.V = UPu * ComplexMath.exp(ComplexMath.j *(UPhase - UPhaseOffs));

  // Voltage amplitude variation
  if time < tUEvtStart or time >= tUEvtEnd then
    UPu = U0Pu;
  else
    UPu = UEvtPu;
  end if;

  // Frequency variation
  if time < tOmegaEvtStart then
    OmegaPu = omega0Pu;
    UPhaseOffs = 0;
  elseif time >= tOmegaEvtEnd then
    OmegaPu = omega0Pu;
    UPhaseOffs = (omega0Pu-omegaEvtPu)*(tOmegaEvtEnd-tOmegaEvtStart)*2*Constants.pi*50;
  else
    OmegaPu = omegaEvtPu;
    UPhaseOffs = (omega0Pu-OmegaPu)*(time-tOmegaEvtStart)*2*Constants.pi*50;
  end if;

  // Outputs signals
  PPu = ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i));
  QPu = ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));

annotation(preferredView = "text",
Documentation(info="<html>
<p> Inifite bus extended with step disturbance in voltage and frequency and measurement signals as output signals </p>
</html>"));

end InfiniteBusWithVariations;
