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

model GeneratorPVTfo_INIT "Initialisation model for generator PV based on SignalN for the frequency handling, with a transformer and a voltage regulation at stator. The voltage module reference at stator is calculated using the voltage module reference at terminal."
  import Dynawo;
  import Dynawo.Electrical.Machines;
  import Modelica.ComplexMath;

  extends Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends AdditionalIcons.Init;

  parameter Types.ActivePower PMin "Minimum active power in MW (generator convention)";
  parameter Types.ActivePower PMax "Maximum active power in MW (generator convention)";
  parameter Types.ReactivePower QMin "Minimum reactive power in Mvar (generator convention)";
  parameter Types.ReactivePower QMax "Maximum reactive power in Mvar (generator convention)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the generator in MVA";
  parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator in Mvar";
  parameter Types.PerUnit RTfoPu "Resistance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit rTfoPu "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";
  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point at terminal in pu (base UNom)";

  Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef) (generator convention)";
  Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef (generator convention))";
  Types.ReactivePowerPu QMinPu "Minimum reactive power in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QMaxPu "Maximum reactive power in pu (base SnRef) (generator convention)";
  Types.VoltageModulePu UStatorRef0Pu "Start value of voltage regulation set point at stator in pu (base UNom)";
  Types.VoltageModulePu UStator0Pu "Start value of voltage module at stator in pu (base UNom)";
  Types.ComplexVoltagePu uStatorRef0Pu "Start value of complex voltage regulation set point at stator in pu (base UNom)";
  Types.ComplexVoltagePu uStator0Pu "Start value of complex voltage at stator in pu (base UNom)";
  Types.ComplexCurrentPu iStator0Pu "Start value of complex current at stator in pu (base UNom, SNom) (generator convention)";
  Types.ComplexApparentPowerPu sStator0Pu "Start value of complex apparent power at stator in pu (base UNom, SNom) (generator convention)";
  Types.ReactivePowerPu QStator0Pu "Start value of stator reactive power in pu (base QNomAlt) (generator convention)";

protected
  Types.ComplexVoltagePu uRef0Pu "Start value of complex voltage reference at terminal in pu (base UNom)";
  Types.ComplexCurrentPu iRef0Pu "Start value of complex current reference at terminal in pu (base UNom, SnRef) (receptor convention)";

equation
  PMinPu = PMin / Dynawo.Electrical.SystemBase.SnRef;
  QMinPu = QMin / Dynawo.Electrical.SystemBase.SnRef;
  PMaxPu = PMax / Dynawo.Electrical.SystemBase.SnRef;
  QMaxPu = QMax / Dynawo.Electrical.SystemBase.SnRef;

  uRef0Pu = ComplexMath.fromPolar(URef0Pu, UPhase0);
  Complex(P0Pu, Q0Pu) = uRef0Pu * ComplexMath.conj(iRef0Pu);

  uStator0Pu = 1 / rTfoPu * (u0Pu - i0Pu * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom);
  uStatorRef0Pu = 1 / rTfoPu * (uRef0Pu - iRef0Pu * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom);
  UStator0Pu = ComplexMath.'abs'(uStator0Pu);
  UStatorRef0Pu = ComplexMath.'abs'(uStatorRef0Pu);
  iStator0Pu = - i0Pu * SystemBase.SnRef / SNom;
  sStator0Pu = uStator0Pu * ComplexMath.conj(iStator0Pu);
  QStator0Pu = sStator0Pu.im * SNom / QNomAlt;

  annotation(preferredView = "text");
end GeneratorPVTfo_INIT;
