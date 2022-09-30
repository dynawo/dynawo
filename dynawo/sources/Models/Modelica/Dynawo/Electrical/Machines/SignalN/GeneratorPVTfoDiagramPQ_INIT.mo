within Dynawo.Electrical.Machines.SignalN;

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

model GeneratorPVTfoDiagramPQ_INIT "Initialisation model for generator PV based on SignalN for the frequency handling, with a transformer, a voltage regulation at stator and with an N points PQ diagram. The voltage module reference at stator is calculated using the voltage module reference at terminal."
  import Dynawo;
  import Dynawo.Electrical.Machines;
  import Modelica.ComplexMath;

  extends Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends AdditionalIcons.Init;

  parameter Types.ActivePowerPu PMin "Minimum active power in MW";
  parameter Types.ActivePowerPu PMax "Maximum active power in MW";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the generator in MVA";
  parameter Types.PerUnit RTfoPu "Resistance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit rTfoPu "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";
  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point at terminal in pu (base UNom)";
  parameter Types.ReactivePowerPu QMin0 "Start value of minimum reactive power in Mvar";
  parameter Types.ReactivePowerPu QMax0 "Start value of maximum reactive power in Mvar";

  Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
  Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
  Types.ReactivePowerPu QMin0Pu "Start value of minimum reactive power in pu (base SnRef)";
  Types.ReactivePowerPu QMax0Pu "Start value of maximum reactive power in pu (base SnRef)";
  Types.VoltageModulePu UStatorRef0Pu "Start value of voltage regulation set point at stator in pu (base UNom)";
  Types.VoltageModulePu UStator0Pu "Start value of voltage module at stator in pu (base UNom)";

protected
  Types.ComplexVoltagePu uRef0Pu "Start value of complex voltage reference at terminal in pu (base UNom)";
  Types.ComplexCurrentPu iRef0Pu "Start value of complex current reference at terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  PMinPu = PMin / Dynawo.Electrical.SystemBase.SnRef;
  QMin0Pu = QMin0 / Dynawo.Electrical.SystemBase.SnRef;
  PMaxPu = PMax / Dynawo.Electrical.SystemBase.SnRef;
  QMax0Pu = QMax0 / Dynawo.Electrical.SystemBase.SnRef;

  uRef0Pu = ComplexMath.fromPolar(URef0Pu, UPhase0);
  Complex(P0Pu, Q0Pu) = uRef0Pu * ComplexMath.conj(iRef0Pu);

  UStator0Pu = ComplexMath.'abs'(1 / rTfoPu * (u0Pu - i0Pu * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom));
  UStatorRef0Pu = ComplexMath.'abs'(1 / rTfoPu * (uRef0Pu - iRef0Pu * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom));

  annotation(preferredView = "text");
end GeneratorPVTfoDiagramPQ_INIT;
