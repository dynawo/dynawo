within Dynawo.Electrical.Controls.Machines.UnderExcitationLimiters.Standard;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model Uel2c_INIT "IEEE overexcitation limiter type UEL2C initialization model"
  extends AdditionalIcons.Init;

  //Regulation parameters
  parameter Types.PerUnit K1 "Voltage exponent for active power input to UEL table";
  parameter Types.PerUnit K2 "Voltage exponent for reactive power output of UEL table";
  parameter Types.VoltageModulePu VBiasPu "UEL voltage bias in pu (base UNom)";

  //Table parameters
  parameter String FPQTableName "Name of table in text file for the reactive power as a function of active power";
  parameter String TablesFile "Text file that contains the table for the fpq function";

  Dynawo.Connectors.ActivePowerPuConnector PGen0Pu "Initial active power in pu (base SnRef) (generator convention)";
  Dynawo.Connectors.ReactivePowerPuConnector QGen0Pu "Initial reactive power in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu QRef0Pu "Initial reference reactive power in pu (base SnRef) (generator convention)";
  Types.VoltageModulePu U0Pu "Initial voltage amplitude at terminal in pu (base UNom)";
  Dynawo.Connectors.VoltageModulePuConnector UsRef0Pu "Initial reference stator voltage in pu (base UNom)";
  Dynawo.Connectors.ComplexVoltagePuConnector ut0Pu "Initial complex stator voltage in pu (base UNom)";
  Types.VoltageModulePu VBias0Pu "Initial calculated voltage bias in pu (base UNom)";

  Modelica.Blocks.Tables.CombiTable1Ds combiTable1DsInit(fileName = TablesFile, tableName = FPQTableName, tableOnFile = true);

equation
  if U0Pu > 1 then
    VBias0Pu = U0Pu;
  elseif U0Pu <= VBiasPu then
    VBias0Pu = U0Pu / VBiasPu;
  else
    VBias0Pu = 1;
  end if;

  U0Pu = Modelica.ComplexMath.'abs'(ut0Pu);
  combiTable1DsInit.u = PGen0Pu / (VBias0Pu ^ K1);
  QRef0Pu = (VBias0Pu ^ K2) * combiTable1DsInit.y[1];

  annotation(preferredView = "text");
end Uel2c_INIT;
