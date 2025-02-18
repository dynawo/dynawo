within Dynawo.Electrical.Loads;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model ElectronicLoad "Constant power load with disconnection and reconnections depending on the voltage"
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  parameter Types.VoltageModulePu Ud1Pu "Voltage at which the load starts to disconnect in pu (base UNom)";
  parameter Types.VoltageModulePu Ud2Pu "Voltage at which the load is completely disconnected in pu (base UNom)";
  parameter Real recoveringShare "Share of the load that recovers from low voltage trip";
  parameter Types.Time tFilter = 1e-2 "Time constant for estimation of UMinPu in s";

  Types.VoltageModulePu UMinPu(start = ComplexMath.abs(u0Pu)) "Minimum voltage during the simulation (with lower bound at Ud2Pu) in pu (base UNom)";
  Real connectedShare(start = 1) "Share of the load that is currently connected";

equation
  if (running.value) then
    UMinPu + tFilter * der(UMinPu) = if (UPu.value < UMinPu and UMinPu > Ud2Pu) then UPu.value else UMinPu;

    if UPu.value < Ud2Pu then
      connectedShare = 0;
    elseif UPu.value < Ud1Pu then
      if UPu.value <= UMinPu then  // Voltage currently decreasing (below UMinPu)
        connectedShare = (UPu.value - Ud2Pu) / (Ud1Pu - Ud2Pu);
      else  // Voltage recovering, so partial reconnection
        connectedShare = ((UMinPu - Ud2Pu) + recoveringShare * (UPu.value - UMinPu)) / (Ud1Pu - Ud2Pu);
      end if;
    else
      if UMinPu >= Ud1Pu then  // Voltage never dropped below Ud1Pu
        connectedShare = 1;
      else
        connectedShare = ((UMinPu - Ud2Pu) + recoveringShare * (Ud1Pu - UMinPu)) / (Ud1Pu - Ud2Pu);
      end if;
    end if;

    PPu = PRefPu * (1 + deltaP) * connectedShare;
    QPu = QRefPu * (1 + deltaQ) * connectedShare;
  else
    terminal.i = Complex(0);
    connectedShare = 0;
    UMinPu = 0;
  end if;

  annotation(preferredView = "text");
end ElectronicLoad;
