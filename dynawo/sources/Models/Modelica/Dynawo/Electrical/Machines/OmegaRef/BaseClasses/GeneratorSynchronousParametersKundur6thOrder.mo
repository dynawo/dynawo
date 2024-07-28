within Dynawo.Electrical.Machines.OmegaRef.BaseClasses;

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

record GeneratorSynchronousParameters "Synchronous machine record: Common parameters to the init and the dynamic models"
  type ExcitationPuType = enumeration(NoLoad "1 pu gives nominal air-gap stator voltage at no load", NoLoadSaturated "1 pu gives nominal air-gap stator voltage at no load, accounting for saturation", UserBase "User defined base for the excitation voltage", Nominal "Base for excitation voltage in nominal conditions (PNomAlt, QNom, UNom)", Kundur "Base voltage as per Kundur, Power System Stability and Control");

  // General parameters of the synchronous machine
  parameter Types.VoltageModule UNom "Nominal voltage in kV";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  parameter Types.ActivePower PNomTurb "Nominal active (turbine) power in MW";
  parameter Types.ActivePower PNomAlt "Nominal active (alternator) power in MW";
  final parameter Types.ReactivePower QNomAlt = sqrt(SNom * SNom - PNomAlt * PNomAlt) "Nominal reactive (alternator) power in Mvar";
  parameter ExcitationPuType ExcitationPu "Choice of excitation base voltage";
  parameter Types.Time H "Kinetic constant = kinetic energy / rated power";
  parameter Types.PerUnit DPu "Damping coefficient of the swing equation in pu";

  // Transformer input parameters
  parameter Types.ApparentPowerModule SnTfo "Nominal apparent power of the generator transformer in MVA";
  parameter Types.VoltageModule UNomHV "Nominal voltage on the network side of the transformer in kV";
  parameter Types.VoltageModule UNomLV "Nominal voltage on the generator side of the transformer in kV";
  parameter Types.VoltageModule UBaseHV "Base voltage on the network side of the transformer in kV";
  parameter Types.VoltageModule UBaseLV "Base voltage on the generator side of the transformer in kV";
  parameter Types.PerUnit RTfPu "Resistance of the generator transformer in pu (base UBaseHV, SnTfo)";
  parameter Types.PerUnit XTfPu "Reactance of the generator transformer in pu (base UBaseHV, SnTfo)";

  // Mutual inductances saturation parameters, Kundur modelisation
  parameter Types.PerUnit ASat "Parameter for direct axis mutual inductance saturation modelling";
  parameter Types.PerUnit BSat "Parameter for quadrature axis mutual inductance saturation modelling";
  parameter Types.PerUnit lambdaT1 "Parameter for direct axis mutual inductance saturation modelling";

  // Transformer internal parameters
  final parameter Types.PerUnit RTfoPu = RTfPu * (UNomHV / UBaseHV) ^ 2 * (SNom / SnTfo) "Resistance of the generator transformer in pu (base SNom, UNom)";
  final parameter Types.PerUnit XTfoPu = XTfPu * (UNomHV / UBaseHV) ^ 2 * (SNom / SnTfo) "Reactance of the generator transformer in pu (base SNom, UNom)";
  final parameter Types.PerUnit rTfoPu = if RTfPu > 0.0 or XTfPu > 0.0 then UNomHV / UBaseHV / (UNomLV / UBaseLV) else 1.0 "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";

  annotation(preferredView = "text");
end GeneratorSynchronousParameters;
