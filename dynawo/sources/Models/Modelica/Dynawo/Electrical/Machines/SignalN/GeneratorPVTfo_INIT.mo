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

  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the generator in MVA";
  parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator in Mvar";
  parameter Types.PerUnit RTfoPu "Resistance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit rTfoPu "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";
  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point at terminal in pu (base UNom)";

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  QStatus qStatus0(start = QStatus.Standard) "Start voltage regulation status: standard, absorptionMax or generationMax";
  Boolean limUQUp0(start = false) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  Boolean limUQDown0(start = false) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
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
  if QGen0Pu <= QMinPu and UStator0Pu >= UStatorRef0Pu then
    qStatus0 = QStatus.AbsorptionMax;
    limUQUp0 = false;
    limUQDown0 = true;
  elseif QGen0Pu >= QMaxPu and UStator0Pu <= UStatorRef0Pu then
    qStatus0 = QStatus.GenerationMax;
    limUQUp0 = true;
    limUQDown0 = false;
  else
    qStatus0 = QStatus.Standard;
    limUQUp0 = false;
    limUQDown0 = false;
  end if;

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
