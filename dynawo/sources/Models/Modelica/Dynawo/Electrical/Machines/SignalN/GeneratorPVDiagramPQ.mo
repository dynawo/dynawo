within Dynawo.Electrical.Machines.SignalN;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model GeneratorPVDiagramPQ "Model for generator PV based on SignalN for the frequency handling with an N points PQ diagram."

  import Dynawo.Connectors;
  import Dynawo.Electrical.Machines;
  import Modelica;
  extends Machines.BaseClasses.BaseGeneratorSimplified;
  extends AdditionalIcons.Machine;

    parameter Types.ActivePowerPu PMinPu "Minimum active power in p.u (base SnRef)";
    parameter Types.ActivePowerPu PMaxPu "Maximum active power in p.u (base SnRef)";
    parameter Types.ReactivePowerPu QMin0Pu "Start value of the minimum reactive power in p.u (base SnRef)";
    parameter Types.ReactivePowerPu QMax0Pu "Start value of the maximum reactive power in p.u (base SnRef)";
    parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
    parameter Types.ActivePower PNom "Nominal power in MW";
    final parameter Real Alpha = PNom * KGover "Participation of the considered generator in the frequency regulation";
    parameter Types.Time tFilter "Filter time constant to update QMin/QMax";
    parameter String QMinTableName "Name of the table in the text file to get QMinPu from PGenPu";
    parameter String QMaxTableName "Name of the table in the text file to get QMaxPu from PGenPu";
    parameter String QMinTableFile "Text file that contains the table to get QMinPu from PGenPu";
    parameter String QMaxTableFile "Text file that contains the table to get QMaxPu from PGenPu";

    Connectors.ImPin N "Signal to change the active power reference setpoint of all the generators in the system in p.u (base SnRef)";
    Connectors.ZPin alpha "Participation of the considered generator in the frequency regulation";
    Connectors.ZPin alphaSum "Sum of all the participations of all generators in the frequency regulation";
    Connectors.ZPin URefPu (value(start = U0Pu)) "Voltage regulation set point in p.u (base UNom)";
    Modelica.Blocks.Tables.CombiTable1D tableQMin(tableOnFile = true, tableName = QMinTableName, fileName = QMinTableFile) "Table to get QMinPu from PGenPu";
    Modelica.Blocks.Tables.CombiTable1D tableQMax(tableOnFile = true, tableName = QMaxTableName, fileName = QMaxTableFile) "Table to get QMaxPu from PGenPu";
    Types.ReactivePowerPu QMinPu(start = QMin0Pu) "Minimum reactive power in p.u (base SnRef)";
    Types.ReactivePowerPu QMaxPu(start = QMax0Pu) "Maximum reactive power in p.u (base SnRef)";

  protected

    Types.ActivePowerPu PGenRawPu (start = PGen0Pu) "Active power generation without taking limits into account in p.u (base SnRef) (generator convention)";

  equation

    PGenPu = tableQMin.u[1];
    tFilter * der(QMinPu) + QMinPu = tableQMin.y[1];

    PGenPu = tableQMax.u[1];
    tFilter * der(QMaxPu) + QMaxPu = tableQMax.y[1];

    if running.value then
      PGenRawPu = PGen0Pu + (Alpha / alphaSum.value) * N.value;
      PGenPu = if PGenRawPu >= PMaxPu then PMaxPu elseif PGenRawPu <= PMinPu then PMinPu else PGenRawPu;

      if QGenPu >= QMaxPu and UPu <= URefPu.value then
            QGenPu = QMaxPu;
      elseif QGenPu <= QMinPu and UPu >= URefPu.value then
            QGenPu = QMinPu;
      else
            UPu = URefPu.value;
      end if;

      alpha.value = if (N.value > 0 and PGenRawPu >= PMaxPu) then 0 else if (N.value < 0 and PGenRawPu <= PMinPu) then 0 else Alpha;

    else
      PGenRawPu = 0;
      PGenPu = 0;
      QGenPu = 0;
      alpha.value = 0;
    end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>  This generator provides an active power PGenPu that depends on an emulated frequency regulation (signal N and total generators participation alphaSum) and regulates the voltage UPu unless its reactive power generation hits its limits QMinPu or QMaxPu. These limits are calculated in the model depending on PGenPu.</div></body></html>"));
end GeneratorPVDiagramPQ;
