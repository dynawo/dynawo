within Dynawo.Electrical.Loads;

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

model LoadAlphaBetaRestorativeLimitsRecalc_INIT "Initialization model for restorative alpha-beta load with a limits recalculation"
  extends Load_INIT;

  parameter Types.VoltageModulePu UMin0Pu "Minimum value of the voltage amplitude at terminal in pu (base UNom) that ensures the P/Q restoration";
  parameter Types.VoltageModulePu UMax0Pu "Maximum value of the voltage amplitude at terminal in pu (base UNom) that ensures the P/Q restoration";
  parameter Types.VoltageModulePu UDeadBandPu "Deadband of the limits recalculation in pu (base UNom)";

  Types.VoltageModulePu UMinPu "Recalculated minimum value of the voltage amplitude at terminal in pu (base UNom) that ensures the P/Q restoration";
  Types.VoltageModulePu UMaxPu "Recalculated maximum value of the voltage amplitude at terminal in pu (base UNom) that ensures the P/Q restoration";

equation
  UMinPu = if U0Pu - UDeadBandPu < UMin0Pu then U0Pu - UDeadBandPu else UMin0Pu;
  UMaxPu = if U0Pu + UDeadBandPu > UMax0Pu then U0Pu + UDeadBandPu else UMax0Pu;

  annotation(preferredView = "text");
end LoadAlphaBetaRestorativeLimitsRecalc_INIT;
