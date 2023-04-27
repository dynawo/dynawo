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

model SVarCPVModeHandling "PV static var compensator model with mode handling"
  import Dynawo.Electrical.StaticVarCompensators.BaseControls.Mode;

  extends BaseClasses.BaseSVarC;
  extends BaseClasses.BaseModeHandling;
  extends BaseControls.Parameters.Params_ModeHandling;

  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";

  input Types.VoltageModule URef(start = URef0Pu * UNom) "Voltage reference for the regulation in kV";

  BaseControls.ModeHandling modeHandling(Mode0 = Mode0, UNom = UNom, URefDown = URefDown, URefUp = URefUp, UThresholdDown = UThresholdDown, UThresholdUp = UThresholdUp, tThresholdDown = tThresholdDown, tThresholdUp = tThresholdUp, URef0 = URef0Pu * UNom);

equation
  UPu = modeHandling.UPu;
  URef = modeHandling.URef;
  URefPu = modeHandling.URefPu;
  selectModeAuto = modeHandling.selectModeAuto;
  setModeManual = modeHandling.setModeManual;

  when BVarPu >= BMaxPu and UPu <= URefPu then
    bStatus = BStatus.SusceptanceMax;
  elsewhen BVarPu <= BMinPu and UPu >= URefPu then
    bStatus = BStatus.SusceptanceMin;
  elsewhen (BVarPu < BMaxPu or UPu > URefPu) and (BVarPu > BMinPu or UPu < URefPu) then
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
        UPu = URefPu;
      elseif bStatus == BStatus.SusceptanceMax then
        BVarPu = BMaxPu;
      else
        BVarPu = BMinPu;
      end if;
    else
      BVarPu = 0;
    end if;
  else
    BVarPu = 0.;
  end if;

  annotation(preferredView = "text");
end SVarCPVModeHandling;
