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

model GeneratorPVTfoDiagramPQ "Model for generator PV based on SignalN for the frequency handling, with a transformer, a voltage regulation at stator and with an N points PQ diagram."
  import Modelica;
  import Dynawo;

  extends Dynawo.Electrical.Machines.SignalN.BaseClasses.BaseGeneratorSignalN;
  extends AdditionalIcons.Machine;

  type QStatus = enumeration (Standard "Reactive power is fixed to its initial value",
                              AbsorptionMax "Reactive power is fixed to its absorption limit",
                              GenerationMax "Reactive power is fixed to its generation limit");

  parameter Types.Time tFilter "Filter time constant to update QMin/QMax";
  parameter String QMinTableName "Name of the table in the text file to get QMinPu from PGenPu";
  parameter String QMaxTableName "Name of the table in the text file to get QMaxPu from PGenPu";
  parameter String QMinTableFile "Text file that contains the table to get QMinPu from PGenPu";
  parameter String QMaxTableFile "Text file that contains the table to get QMaxPu from PGenPu";
  parameter Types.ApparentPowerModule SNom "Nominal apparent power of the generator in MVA";
  parameter Types.ApparentPowerModule SnTfo "Nominal apparent power of the generator transformer in MVA";
  parameter Types.VoltageModule UNomHV "Nominal voltage on the network side of the transformer in kV";
  parameter Types.VoltageModule UNomLV "Nominal voltage on the generator side of the transformer in kV";
  parameter Types.VoltageModule UBaseHV "Base voltage on the network side of the transformer in kV";
  parameter Types.VoltageModule UBaseLV "Base voltage on the generator side of the transformer in kV";
  parameter Types.PerUnit RTfPu "Resistance of the generator transformer in pu (base UBaseHV, SnTfo)";
  parameter Types.PerUnit XTfPu "Reactance of the generator transformer in pu (base UBaseHV, SnTfo)";

  input Types.VoltageModulePu UStatorRefPu(start = UStatorRef0Pu) "Voltage regulation set point at stator in pu (base UNom)";
  Types.VoltageModulePu UStatorPu(start = UStator0Pu) "Voltage module at stator in pu (base UNom)";

  Modelica.Blocks.Tables.CombiTable1D tableQMin(tableOnFile = true, tableName = QMinTableName, fileName = QMinTableFile) "Table to get QMinPu from PGenPu";
  Modelica.Blocks.Tables.CombiTable1D tableQMax(tableOnFile = true, tableName = QMaxTableName, fileName = QMaxTableFile) "Table to get QMaxPu from PGenPu";
  Types.ReactivePowerPu QMinPu(start = QMin0Pu) "Minimum reactive power in pu (base SnRef)";
  Types.ReactivePowerPu QMaxPu(start = QMax0Pu) "Maximum reactive power in pu (base SnRef)";

  parameter Types.ReactivePowerPu QMin0Pu "Start value of the minimum reactive power in pu (base SnRef)";
  parameter Types.ReactivePowerPu QMax0Pu "Start value of the maximum reactive power in pu (base SnRef)";
  parameter Types.VoltageModulePu UStatorRef0Pu "Start value of voltage regulation set point at stator in pu (base UNom)";
  parameter Types.VoltageModulePu UStator0Pu "Start value of voltage module at stator in pu (base UNom)";

protected
  final parameter Types.PerUnit RTfoPu = RTfPu * (UNomHV / UBaseHV) ^ 2 * (SNom / SnTfo) "Resistance of the generator transformer in pu (base SNom, UNomHV)";
  final parameter Types.PerUnit XTfoPu = XTfPu * (UNomHV / UBaseHV) ^ 2 * (SNom / SnTfo) "Reactance of the generator transformer in pu (base SNom, UNomHV)";
  final parameter Types.PerUnit rTfoPu = if RTfPu > 0.0 or XTfPu > 0.0 then UNomHV / UBaseHV / (UNomLV / UBaseLV) else 1.0 "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";
  QStatus qStatus(start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation
  PGenPu = tableQMin.u[1];
  tFilter * der(QMinPu) + QMinPu = tableQMin.y[1];
  PGenPu = tableQMax.u[1];
  tFilter * der(QMaxPu) + QMaxPu = tableQMax.y[1];

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
end GeneratorPVTfoDiagramPQ;
