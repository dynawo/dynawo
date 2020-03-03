model InfiniteBus "Infinite bus"
  /* Changed by MNu!
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
  import Dynawo.Connectors;
  import Modelica.SIunits;
  import Modelica.ComplexMath;
  import Modelica.Constants;

  Connectors.ACPower terminal;

  parameter SIunits.PerUnit U0Pu "Infinite bus constant voltage module";
  parameter SIunits.PerUnit UEvtPu "Infinite bus constant voltage module during event";
  parameter SIunits.PerUnit omega0Pu "Infinite bus angular frequency";
  parameter SIunits.PerUnit omegaEvtPu "Infinite bus angular frequency";
  parameter SIunits.Angle UPhase "Infinite bus constant voltage angle";
  parameter SIunits.Time tVEvtStart "Start time voltage event";
  parameter SIunits.Time tVEvtEnd "Ending time voltage event";
  parameter SIunits.Time tomegaEvtStart "Start time frequency event";
  parameter SIunits.Time tomegaEvtEnd "Ending time frequency event";

  SIunits.PerUnit UPu "Voltage magnitude (pu UNom)";
  SIunits.PerUnit PPu "Absorbed active power (pu base SnRef)";
  SIunits.PerUnit QPu "Absorbed inductive reactive (pu base SnRef)";
  SIunits.PerUnit OmegaPu "Frequency (pu base omegaNom)";
  SIunits.Angle UPhaseOffs "Angle offset due to frequency changes in deg";

  SIunits.PerUnit UPuCalc "Voltage magnitude (pu UNom)";

equation

  if time < tVEvtStart or time >= tVEvtEnd then
    UPu = U0Pu;
  else
    UPu = UEvtPu;
  end if;

  if time < tomegaEvtStart then
    OmegaPu = omega0Pu;
    UPhaseOffs = 0;
  elseif time >= tomegaEvtEnd then
    OmegaPu = omega0Pu;
    UPhaseOffs = (omega0Pu-omegaEvtPu)*(tomegaEvtEnd-tomegaEvtStart)*2*Constants.pi*50;
  else
    OmegaPu = omegaEvtPu;
    UPhaseOffs = (omega0Pu-OmegaPu)*(time-tomegaEvtStart)*2*Constants.pi*50;
  end if;

  terminal.V = UPu * ComplexMath.exp(ComplexMath.j *(UPhase - UPhaseOffs));
  UPuCalc = ComplexMath.'abs'(terminal.V);

  // Power Calculation in receptor convention
  PPu = ComplexMath.real(terminal.V * ComplexMath.conj(terminal.i));
  QPu = ComplexMath.imag(terminal.V * ComplexMath.conj(terminal.i));

annotation(
Documentation(info="<html>
<p> Inifite bus extended with step disturbance in voltage and frequency and measurement signals as output signals </p>
</html>"));

end InfiniteBus;
