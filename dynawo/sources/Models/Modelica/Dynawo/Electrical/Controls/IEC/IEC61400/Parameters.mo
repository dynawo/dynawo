within Dynawo.Electrical.Controls.IEC.IEC61400;

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

package Parameters "Parameters of lookup tables for variable dependencies in the context of IEC N°61400-27-1"
  extends Icons.Package;
  
  record InitialQControl
    parameter Types.ReactivePowerPu QMax0Pu "Initial maximum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.ReactivePowerPu QMin0Pu "Initial minimum reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Dialog(group = "Initialization"));
  parameter Types.PerUnit XWT0Pu "Initial reactive power or voltage reference at grid terminal in pu (base SNom or UNom) (generator convention)" annotation(
    Dialog(tab = "Operating point"));
  end InitialQControl;
  
record GridMeasurementControl
  parameter Types.PerUnit DfcMaxPu "Maximum frequency control ramp rate in pu/s (base fNom)" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tfcFilt "Filter time constant for frequency control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tIcFilt "Filter time constant for current control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tPcFilt "Filter time constant for active power control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tQcFilt "Filter time constant for reactive power control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
  parameter Types.Time tUcFilt "Filter time constant for voltage control measurement in s" annotation(
    Dialog(tab = "MeasurementC"));
end GridMeasurementControl;

record GridMeasurementProtection
  parameter Types.PerUnit DfpMaxPu "Maximum frequency protection ramp rate in pu/s (base fNom)" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tfpFilt "Filter time constant for frequency protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tIpFilt "Filter time constant for current protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tPpFilt "Filter time constant for active power protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tQpFilt "Filter time constant for reactive power protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
  parameter Types.Time tUpFilt "Filter time constant for voltage protection measurement in s" annotation(
    Dialog(tab = "MeasurementP"));
end GridMeasurementProtection;

record Mechanical
  parameter Types.PerUnit CdrtPu "Drive train damping in pu (base SNom, omegaNom)" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.Time Hgen "Generator inertia time constant in s" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.Time Hwtr "WT rotor inertia time constant in s" annotation(
    Dialog(tab = "Mechanical"));
  parameter Types.PerUnit KdrtPu "Drive train stiffness in pu (base SNom, omegaNom)" annotation(
    Dialog(tab = "Mechanical"));
end Mechanical;

record ControlSubstructureQ
  parameter Types.VoltageModulePu DUdb1Pu "Voltage change dead band lower limit (typically negative) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu DUdb2Pu "Voltage change dead band upper limit (typically positive) in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.PerUnit Kpufrt "Voltage PI controller proportional gain during FRT in pu (base UNom, SNom)" annotation(
    Dialog(tab = "QControl"));
  parameter Integer Mqfrt "FRT Q control modes (0-3) (see Table 29, section 7.7.5, page 60 of the IEC norm N°61400-27-1:2020)" annotation(
    Dialog(tab = "QControl"));
  parameter Types.Time tUss "Steady-state voltage filter time constant in s" annotation(
    Dialog(tab = "QControl"));
  parameter Types.VoltageModulePu UqRisePu "Voltage threshold for OVRT detection in Q control in pu (base UNom)" annotation(
    Dialog(tab = "QControl"));
end ControlSubstructureQ;

record ControlSubstructure4bP
  extends ControlSubstructure4P;
  parameter Types.PerUnit DPMaxP4BPu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4BPu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4BPu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPAero "Reference power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4B "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  end ControlSubstructure4bP;

record ControlSubstructure4aP
  extends ControlSubstructure4P;
  parameter Types.PerUnit DPMaxP4APu "Maximum WT power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMax4APu "Maximum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.PerUnit DPRefMin4APu "Minimum WT reference power ramp rate in pu/s (base SNom) (generator convention)" annotation(
    Dialog(tab = "PControl"));
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPOrdP4A "Power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.Time tPWTRef4A "Reference power order lag time constant in s" annotation(
    Dialog(tab = "PControl"));
  parameter Types.VoltageModulePu UpDipPu "Voltage dip threshold for power control in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));
end ControlSubstructure4aP;

record ControlSubstructure4P
  parameter Boolean MpUScale "Voltage scaling for power reference during voltage dip (true: u scaling, false: no scaling)" annotation(
    Dialog(tab = "PControl"));
 parameter Types.VoltageModulePu UpDipPu "Voltage dip threshold for power control in pu (base UNom)" annotation(
    Dialog(tab = "PControl"));
end ControlSubstructure4P;

record TableCurrentLimit
  parameter Real TableIpMaxUwt11 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt12 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt21 = 0.1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt22 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt31 = 0.15 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt32 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt41 = 0.9 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt42 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt51 = 0.925 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt52 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt61 = 1.075 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt62 = 1.0001 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt71 = 1.1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt72 = 1.0001 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIpMaxUwt[:,:] = [TableIpMaxUwt11, TableIpMaxUwt12; TableIpMaxUwt21, TableIpMaxUwt22; TableIpMaxUwt31, TableIpMaxUwt32; TableIpMaxUwt41, TableIpMaxUwt42; TableIpMaxUwt51, TableIpMaxUwt52; TableIpMaxUwt61, TableIpMaxUwt62; TableIpMaxUwt71, TableIpMaxUwt72] "Voltage dependency of active current limits" annotation(
    Dialog(tab = "CurrentLimitTables"));

  parameter Real TableIqMaxUwt11 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt12 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt21 = 0.1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt22 = 0 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt31 = 0.15 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt32 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt41 = 0.9 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt42 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt51 = 0.925 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt52 = 0.33 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt61 = 1.075 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt62 = 0.33 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt71 = 1.1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt72 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt81 = 1.1001 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt82 = 1 annotation(
    Dialog(tab = "CurrentLimitTables"));
  parameter Real TableIqMaxUwt[:,:] = [TableIqMaxUwt11, TableIqMaxUwt12; TableIqMaxUwt21, TableIqMaxUwt22; TableIqMaxUwt31, TableIqMaxUwt32; TableIqMaxUwt41, TableIqMaxUwt42; TableIqMaxUwt51, TableIqMaxUwt52; TableIqMaxUwt61, TableIqMaxUwt62; TableIqMaxUwt71, TableIqMaxUwt72; TableIqMaxUwt81, TableIqMaxUwt82] "Voltage dependency of reactive current limits" annotation(
    Dialog(tab = "CurrentLimitTables"));
end TableCurrentLimit;

record TableGridProtection
  parameter Real TabletUoverUwtfilt11 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt12 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt21 = 1.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt22 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt31 = 2 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt32 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt41 = 2.01 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt42 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt51 = 2.02 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt52 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt61 = 2.03 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt62 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt71 = 2.04 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt72 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt81 = 2.05 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt82 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUoverUwtfilt[:,:] = [TabletUoverUwtfilt11, TabletUoverUwtfilt12; TabletUoverUwtfilt21, TabletUoverUwtfilt22; TabletUoverUwtfilt31, TabletUoverUwtfilt32; TabletUoverUwtfilt41, TabletUoverUwtfilt42; TabletUoverUwtfilt51, TabletUoverUwtfilt52; TabletUoverUwtfilt61, TabletUoverUwtfilt62; TabletUoverUwtfilt71, TabletUoverUwtfilt72; TabletUoverUwtfilt81, TabletUoverUwtfilt82] "Disconnection time versus over voltage lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real TabletUunderUwtfilt11 = 0 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt12 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt21 = 0.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt22 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt31 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt32 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt41 = 1.01 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt42 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt51 = 1.02 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt52 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt61 = 1.03 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt62 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt71 = 1.04 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt72 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real TabletUunderUwtfilt[:,:] = [TabletUunderUwtfilt11, TabletUunderUwtfilt12; TabletUunderUwtfilt21, TabletUunderUwtfilt22; TabletUunderUwtfilt31, TabletUunderUwtfilt32; TabletUunderUwtfilt41, TabletUunderUwtfilt42; TabletUunderUwtfilt51, TabletUunderUwtfilt52; TabletUunderUwtfilt61, TabletUunderUwtfilt62; TabletUunderUwtfilt71, TabletUunderUwtfilt72] "Disconnection time versus under voltage lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real Tabletfoverfwtfilt11 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt12 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt21 = 1.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt22 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt31 = 2 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt32 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt41 = 2.01 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt42 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfoverfwtfilt[:,:] = [Tabletfoverfwtfilt11, Tabletfoverfwtfilt12; Tabletfoverfwtfilt21, Tabletfoverfwtfilt22; Tabletfoverfwtfilt31, Tabletfoverfwtfilt32; Tabletfoverfwtfilt41, Tabletfoverfwtfilt42] "Disconnection time versus over frequency lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));

  parameter Real Tabletfunderfwtfilt11 = 0 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt12 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt21 = 0.5 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt22 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt31 = 1 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt32 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt41 = 1.01 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt42 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt51 = 1.02 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt52 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt61 = 1.03 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt62 = 0.33 annotation(
    Dialog(tab = "GridProtectionTables"));
  parameter Real Tabletfunderfwtfilt[:,:] = [Tabletfunderfwtfilt11, Tabletfunderfwtfilt12; Tabletfunderfwtfilt21, Tabletfunderfwtfilt22; Tabletfunderfwtfilt31, Tabletfunderfwtfilt32; Tabletfunderfwtfilt41, Tabletfunderfwtfilt42; Tabletfunderfwtfilt51, Tabletfunderfwtfilt52; Tabletfunderfwtfilt61, Tabletfunderfwtfilt62] "Disconnection time versus under frequency lookup table" annotation(
    Dialog(tab = "GridProtectionTables"));
end TableGridProtection;

record TablePControl
  parameter Real TablePwpBiasfwpFiltCom11 = 0.95 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom12 = 1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom21 = 1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom22 = 0 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom31 = 1.05 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom32 = -1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom41 = 1.06 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom42 = -1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom51 = 1.07 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom52 = -1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom61 = 1.08 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom62 = -1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom71 = 1.09 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom72 = -1 annotation(
    Dialog(tab = "PControlTables"));
  parameter Real TablePwpBiasfwpFiltCom[:,:] = [TablePwpBiasfwpFiltCom11, TablePwpBiasfwpFiltCom12; TablePwpBiasfwpFiltCom21, TablePwpBiasfwpFiltCom22; TablePwpBiasfwpFiltCom31, TablePwpBiasfwpFiltCom32; TablePwpBiasfwpFiltCom41, TablePwpBiasfwpFiltCom42; TablePwpBiasfwpFiltCom51, TablePwpBiasfwpFiltCom52; TablePwpBiasfwpFiltCom61, TablePwpBiasfwpFiltCom62; TablePwpBiasfwpFiltCom71, TablePwpBiasfwpFiltCom72] "Table for defining power variation versus frequency" annotation(
    Dialog(tab = "PControlTables"));
end TablePControl;

record TableQControl2015
  parameter Real TableQwpUErr11 = -0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr12 = 1.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr21 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr22 = 0.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr31 = 0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr32 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr41 = 0.06 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr42 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr51 = 0.07 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr52 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr61 = 0.08 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr62 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr[:,:] = [TableQwpUErr11, TableQwpUErr12; TableQwpUErr21, TableQwpUErr22; TableQwpUErr31, TableQwpUErr32; TableQwpUErr41, TableQwpUErr42; TableQwpUErr51, TableQwpUErr52; TableQwpUErr61, TableQwpUErr62] "Table for the UQ static mode" annotation(
    Dialog(tab = "QControlTables"));
end TableQControl2015;

record TableQControl2020
  parameter Real TableQwpMaxPwpFiltCom11 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom12 = 0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom21 = 0.5 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom22 = 0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom31 = 1 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom32 = 0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMaxPwpFiltCom[:,:] = [TableQwpMaxPwpFiltCom11, TableQwpMaxPwpFiltCom12; TableQwpMaxPwpFiltCom21, TableQwpMaxPwpFiltCom22; TableQwpMaxPwpFiltCom31, TableQwpMaxPwpFiltCom32] "Power dependent reactive power maximum limit" annotation(
    Dialog(tab = "QControlTables"));

  parameter Real TableQwpMinPwpFiltCom11 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom12 = -0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom21 = 0.5 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom22 = -0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom31 = 1 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom32 = -0.33 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpMinPwpFiltCom[:,:] = [TableQwpMinPwpFiltCom11, TableQwpMinPwpFiltCom12; TableQwpMinPwpFiltCom21, TableQwpMinPwpFiltCom22; TableQwpMinPwpFiltCom31, TableQwpMinPwpFiltCom32] "Power dependent reactive power minimum limit" annotation(
    Dialog(tab = "QControlTables"));

  parameter Real TableQwpUErr11 = -0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr12 = 1.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr21 = 0 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr22 = 0.21 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr31 = 0.05 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr32 = -0.79 annotation(
    Dialog(tab = "QControlTables"));
  parameter Real TableQwpUErr[:,:] = [TableQwpUErr11, TableQwpUErr12; TableQwpUErr21, TableQwpUErr22; TableQwpUErr31, TableQwpUErr32] "Table for the UQ static mode" annotation(
    Dialog(tab = "QControlTables"));
end TableQControl2020;

record TableQLimit
  parameter Real TableQMaxUwtcFilt11 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt12 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt21 = 0.001 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt22 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt31 = 0.8 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt32 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt41 = 1.2 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt42 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt51 = 1.21 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt52 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt61 = 1.22 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt62 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxUwtcFilt[:,:] = [TableQMaxUwtcFilt11, TableQMaxUwtcFilt12; TableQMaxUwtcFilt21, TableQMaxUwtcFilt22; TableQMaxUwtcFilt31, TableQMaxUwtcFilt32; TableQMaxUwtcFilt41, TableQMaxUwtcFilt42; TableQMaxUwtcFilt51, TableQMaxUwtcFilt52; TableQMaxUwtcFilt61, TableQMaxUwtcFilt62] "Voltage dependency of reactive power maximum limit" annotation(
    Dialog(tab = "QLimitTables"));

  parameter Real TableQMinUwtcFilt11 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt12 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt21 = 0.001 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt22 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt31 = 0.8 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt32 = -0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt41 = 1.2 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt42 = -0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinUwtcFilt[:,:] = [TableQMinUwtcFilt11, TableQMinUwtcFilt12; TableQMinUwtcFilt21, TableQMinUwtcFilt22; TableQMinUwtcFilt31, TableQMinUwtcFilt32; TableQMinUwtcFilt41, TableQMinUwtcFilt42] "Voltage dependency of reactive power minimum limit" annotation(
    Dialog(tab = "QLimitTables"));

  parameter Real TableQMaxPwtcFilt11 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt12 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt21 = 0.001 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt22 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt31 = 0.3 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt32 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt41 = 1 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt42 = 0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMaxPwtcFilt[:,:] = [TableQMaxPwtcFilt11, TableQMaxPwtcFilt12; TableQMaxPwtcFilt21, TableQMaxPwtcFilt22; TableQMaxPwtcFilt31, TableQMaxPwtcFilt32; TableQMaxPwtcFilt41, TableQMaxPwtcFilt42] "Active power dependency of reactive power maximum limit" annotation(
    Dialog(tab = "QLimitTables"));

  parameter Real TableQMinPwtcFilt11 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt12 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt21 = 0.001 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt22 = 0 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt31 = 0.3 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt32 = -0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt41 = 1 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt42 = -0.33 annotation(
    Dialog(tab = "QLimitTables"));
  parameter Real TableQMinPwtcFilt[:,:] = [TableQMinPwtcFilt11, TableQMinPwtcFilt12; TableQMinPwtcFilt21, TableQMinPwtcFilt22; TableQMinPwtcFilt31, TableQMinPwtcFilt32; TableQMinPwtcFilt41, TableQMinPwtcFilt42] "Active power dependency of reactive power minimum limit" annotation(
    Dialog(tab = "QLimitTables"));
end TableQLimit;

  annotation(
    preferredView = "text");
end Parameters;
