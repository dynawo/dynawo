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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPVTfo_INIT "Initialisation model for generator PV based on SignalN for the frequency handling, with a transformer and a voltage regulation at stator. The voltage module reference at stator is calculated using the voltage module reference at terminal."
  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

  parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator in Mvar";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the generator in MVA";
  parameter Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base UNom, SNom)";

  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point at terminal in pu (base UNom)";

  Types.ComplexCurrentPu iStator0Pu "Start value of complex current at stator in pu (base UNom, SNom) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector QStator0Pu "Start value of stator reactive power in pu (base QNomAlt) (generator convention)";
  Types.ComplexApparentPowerPu sStator0Pu "Start value of complex apparent power at stator in pu (base UNom, SNom) (generator convention)";
  Types.ComplexVoltagePu uStator0Pu "Start value of complex voltage at stator in pu (base UNom)";
  Types.VoltageModulePu UStator0Pu "Start value of voltage module at stator in pu (base UNom)";
  Types.ComplexVoltagePu uStatorRef0Pu "Start value of complex voltage regulation set point at stator in pu (base UNom)";
  Dynawo.Connectors.VoltageModulePuConnector UStatorRef0Pu "Start value of voltage regulation set point at stator in pu (base UNom)";

protected
  Types.ComplexCurrentPu iRef0Pu "Start value of complex current reference at terminal in pu (base UNom, SnRef) (receptor convention)";
  Types.ComplexVoltagePu uRef0Pu "Start value of complex voltage reference at terminal in pu (base UNom)";

equation
  if QGenRaw0Pu <= QMinPu and UStator0Pu >= UStatorRef0Pu then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMinPu;
  elseif QGenRaw0Pu >= QMaxPu and UStator0Pu <= UStatorRef0Pu then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMaxPu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  uRef0Pu = ComplexMath.fromPolar(URef0Pu, UPhase0);
  Complex(P0Pu, Q0Pu) = uRef0Pu * ComplexMath.conj(iRef0Pu);

  uStator0Pu = u0Pu + iStator0Pu * Complex(0, XTfoPu);
  uStatorRef0Pu = uRef0Pu - iRef0Pu * Complex(0, XTfoPu) * SystemBase.SnRef / SNom;
  UStator0Pu = ComplexMath.'abs'(uStator0Pu);
  UStatorRef0Pu = ComplexMath.'abs'(uStatorRef0Pu);
  iStator0Pu = - i0Pu * SystemBase.SnRef / SNom;
  sStator0Pu = uStator0Pu * ComplexMath.conj(iStator0Pu);
  QStator0Pu = sStator0Pu.im * SNom / QNomAlt;

  annotation(preferredView = "text");
end GeneratorPVTfo_INIT;
