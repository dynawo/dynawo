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
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SVarCPVRemoteModeHandling "PV static var compensator model with remote voltage regulation, slope and mode handling"
  import Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode;

  extends BaseClasses.BaseSVarC;
  extends BaseClasses.BaseModeHandling;
  extends BaseControls.Parameters.ParamsModeHandling;

  parameter Types.VoltageModule UNomRemote "Static var compensator remote nominal voltage in kV";

  input Types.VoltageModule URef(start = URef0Pu * UNomRemote) "Voltage reference for the regulation in kV";
  input Types.VoltageModulePu URegulatedPu "Regulated voltage in pu (base UNomRemote)";

  BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UNom = UNomRemote, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0Pu * UNomRemote);

equation
  URegulatedPu = modeHandling.UPu;
  URef = modeHandling.URef;
  URefPu = modeHandling.URefPu;
  selectModeAuto = modeHandling.selectModeAuto;
  setModeManual = modeHandling.setModeManual;

  when BVarPu >= BMaxPu and URegulatedPu <= URefPu then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarPu <= BMinPu and URegulatedPu >= URefPu then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarPu < BMaxPu or URegulatedPu > URefPu) and (BVarPu > BMinPu or URegulatedPu < URefPu) then
    bStatus = BStatus.Standard;
  end when;

  if modeHandling.mode.value == Mode.RUNNING_V then
    BPu = BVarPu + BShuntPu;
  elseif modeHandling.mode.value == Mode.STANDBY then
    BPu = BShuntPu;
  else
    BPu = 0;
  end if;

  if (running.value) then
    if modeHandling.mode.value == Mode.RUNNING_V then
      if bStatus == BStatus.Standard then
        URegulatedPu = URefPu;
      elseif bStatus == BStatus.SusceptanceMax then
        BVarPu = BMaxPu;
      else
        BVarPu = BMinPu;
      end if;
    else
      BVarPu = 0;
    end if;
  else
    BVarPu = 0;
  end if;

  annotation(preferredView = "text");
end SVarCPVRemoteModeHandling;
