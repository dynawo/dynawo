within Dynawo.Electrical.StaticVarCompensators;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SVarCPVPropModeHandling "PV static var compensator model with slope and mode handling"
  import Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode;

  extends BaseClasses.BaseSVarC;
  extends BaseClasses.BaseModeHandling;
  extends BaseControls.Parameters.ParamsModeHandling;

  parameter Types.PerUnit LambdaPu "Statism of the regulation law URefPu = UPu + LambdaPu*QPu in pu (base UNom, SnRef)";
  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";

  input Types.VoltageModule URef(start = URef0Pu * UNom) "Voltage reference for the regulation in kV";

  Types.PerUnit BVarRawPu(start = BVar0Pu) "Raw variable susceptance of the static var compensator in pu (base UNom, SnRef)";

  BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UNom = UNom, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0Pu * UNom);

equation
  UPu = modeHandling.UPu;
  URef = modeHandling.URef;
  URefPu = modeHandling.URefPu;
  selectModeAuto = modeHandling.selectModeAuto;
  setModeManual = modeHandling.setModeManual;

  when BVarRawPu >= BMaxPu and pre(bStatus) <> BStatus.SusceptanceMax then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarRawPu <= BMinPu and pre(bStatus) <> BStatus.SusceptanceMin then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarRawPu < BMaxPu and BVarRawPu > BMinPu) and pre(bStatus) <> BStatus.Standard then
    bStatus = BStatus.Standard;
  end when;

  URefPu = UPu + LambdaPu * (BVarRawPu + BShuntPu) * UPu ^ 2;
  BVarPu = if BVarRawPu > BMaxPu then BMaxPu elseif BVarRawPu < BMinPu then BMinPu else BVarRawPu;

  if modeHandling.mode.value == Mode.RUNNING_V then
    BPu = BVarPu + BShuntPu;
  elseif modeHandling.mode.value == Mode.STANDBY then
    BPu = BShuntPu;
  else
    BPu = 0;
  end if;

  annotation(preferredView = "text");
end SVarCPVPropModeHandling;
