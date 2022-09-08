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

model GeneratorPVTfo "Model for generator PV based on SignalN for the frequency handling, with a transformer and a voltage regulation at stator"
  import Dynawo;

  extends Dynawo.Electrical.Machines.SignalN.BaseClasses.BaseGeneratorSignalN;
  extends AdditionalIcons.Machine;

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power at terminal in pu (base SnRef) (generator convention)";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power at terminal in pu (base SnRef) (generator convention)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the generator in MVA";
  parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator in Mvar";
  parameter Types.PerUnit RTfoPu "Resistance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit rTfoPu "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";

  input Types.VoltageModulePu UStatorRefPu(start = UStatorRef0Pu) "Voltage regulation set point at stator in pu (base UNom)";

  Types.VoltageModulePu UStatorPu(start = UStator0Pu) "Voltage module at stator in pu (base UNom)";
  Types.ComplexVoltagePu uStatorPu(re(start = uStator0Pu.re), im(start = uStator0Pu.im)) "Complex voltage at stator in pu (base UNom)";
  Types.ComplexCurrentPu iStatorPu(re(start = iStator0Pu.re), im(start = iStator0Pu.im)) "Complex current at stator in pu (base UNom, SNom) (generator convention)";
  Types.ComplexApparentPowerPu sStatorPu(re(start = sStator0Pu.re), im(start = sStator0Pu.im)) "Complex apparent power at stator in pu (base UNom, SNom) (generator convention)";
  Types.ReactivePowerPu QStatorPu(start = QStator0Pu) "Stator reactive power in pu (base QNomAlt) (generator convention)";
  Boolean limUQUp(start = false) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator)";
  Boolean limUQDown(start = false) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator)";

  parameter Types.VoltageModulePu UStatorRef0Pu "Start value of voltage regulation set point at stator in pu (base UNom)";
  parameter Types.VoltageModulePu UStator0Pu "Start value of voltage module at stator in pu (base UNom)";
  parameter Types.ComplexVoltagePu uStator0Pu "Start value of complex voltage at stator in pu (base UNom)";
  parameter Types.ComplexCurrentPu iStator0Pu "Start value of complex current at stator in pu (base UNom, SNom) (generator convention)";
  parameter Types.ComplexApparentPowerPu sStator0Pu "Start value of complex apparent power at stator in pu (base UNom, SNom) (generator convention)";
  parameter Types.ReactivePowerPu QStator0Pu "Start value of stator reactive power in pu (base QNomAlt) (generator convention)";

protected
  QStatus qStatus(start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation
  when QGenPu <= QMinPu and UStatorPu >= UStatorRefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQUp = false;
    limUQDown = true;
  elsewhen QGenPu >= QMaxPu and UStatorPu <= UStatorRefPu then
    qStatus = QStatus.GenerationMax;
    limUQUp = true;
    limUQDown = false;
  elsewhen (QGenPu > QMinPu or UStatorPu < UStatorRefPu) and (QGenPu < QMaxPu or UStatorPu > UStatorRefPu) then
    qStatus = QStatus.Standard;
    limUQUp = false;
    limUQDown = false;
  end when;

  if running.value then
    if qStatus == QStatus.GenerationMax then
      QGenPu = QMaxPu;
    elseif qStatus == QStatus.AbsorptionMax then
      QGenPu = QMinPu;
    else
      UStatorPu = UStatorRefPu;
    end if;
  else
    terminal.i.im = 0;
  end if;

  UStatorPu = ComplexMath.'abs'(1 / rTfoPu * (terminal.V - terminal.i * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom));
  uStatorPu = 1 / rTfoPu * (terminal.V - terminal.i * Complex(RTfoPu, XTfoPu) * SystemBase.SnRef / SNom);
  iStatorPu = - terminal.i * SystemBase.SnRef / SNom;
  sStatorPu = uStatorPu * ComplexMath.conj(iStatorPu);
  QStatorPu = sStatorPu.im * SNom / QNomAlt;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator regulates the voltage UStatorPu unless its reactive power generation hits its limits QMinPu or QMaxPu at terminal (in this case, the generator provides QMinPu or QMaxPu at terminal and the voltage is no longer regulated at stator).</div></body></html>"));
end GeneratorPVTfo;
