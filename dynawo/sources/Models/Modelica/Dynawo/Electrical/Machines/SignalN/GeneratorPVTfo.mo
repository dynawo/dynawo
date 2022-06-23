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

  parameter Types.ReactivePowerPu QMinPu "Minimum reactive power at terminal in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMaxPu "Maximum reactive power at terminal in pu (base SnRef)";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the generator in MVA";
  parameter Types.PerUnit RTfoPu "Resistance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base UNomHV, SNom)";
  parameter Types.PerUnit rTfoPu "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";

  input Types.VoltageModulePu UStatorRefPu(start = UStatorRef0Pu) "Voltage regulation set point at stator in pu (base UNom)";
  Types.VoltageModulePu UStatorPu(start = UStator0Pu) "Voltage module at stator in pu (base UNom)";

  parameter Types.VoltageModulePu UStatorRef0Pu "Start value of voltage regulation set point at stator in pu (base UNom)";
  parameter Types.VoltageModulePu UStator0Pu "Start value of voltage module at stator in pu (base UNom)";

protected
  QStatus qStatus(start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation
  when QGenPu <= QMinPu and UStatorPu >= UStatorRefPu then
    qStatus = QStatus.AbsorptionMax;
  elsewhen QGenPu >= QMaxPu and UStatorPu <= UStatorRefPu then
    qStatus = QStatus.GenerationMax;
  elsewhen (QGenPu > QMinPu or UStatorPu < UStatorRefPu) and (QGenPu < QMaxPu or UStatorPu > UStatorRefPu) then
    qStatus = QStatus.Standard;
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

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator regulates the voltage UStatorPu unless its reactive power generation hits its limits QMinPu or QMaxPu at terminal (in this case, the generator provides QMinPu or QMaxPu at terminal and the voltage is no longer regulated at stator).</div></body></html>"));
end GeneratorPVTfo;
