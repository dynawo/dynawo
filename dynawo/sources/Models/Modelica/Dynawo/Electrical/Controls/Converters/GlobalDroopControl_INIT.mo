within Dynawo.Electrical.Controls.Converters;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model GlobalDroopControl_INIT "Initialization model for the global droop control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends AdditionalIcons.Init;

  parameter Types.PerUnit Lfilter "Filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Cfilter "Filter capacitance in p.u (base UNom, SNom)";

  Types.PerUnit Pref0 "Start value of the active power reference at the converter's capacitor in p.u (base SNom) (generator convention)";
  Types.PerUnit Qref0 "Start value of the reactive power reference at the converter's capacitor in p.u (base SNom) (generator convention)";
  Types.PerUnit Idcref0 "Start value of the DC current reference";

  Types.PerUnit IConvd0;
  Types.PerUnit IConvq0;
  Types.PerUnit YIntegratord_voltageLoop0;
  Types.PerUnit YIntegratorq_voltageLoop0;
  Types.PerUnit IPCCd0;
  Types.PerUnit IPCCq0;
  Types.PerUnit VFilterd0;
  Types.PerUnit VFilterq0;
  Types.PerUnit YIntegratord_currentLoop0;
  Types.PerUnit YIntegratorq_currentLoop0;
  Types.PerUnit VConvdref0;
  Types.PerUnit VConvqref0;
  Types.Angle Theta0;
  Types.PerUnit Idc0;
  Types.PerUnit Vdc0;
  Types.PerUnit Wref0;

  equation

  VConvdref0 = VFilterd0 + YIntegratord_currentLoop0 - Lfilter * SystemBase.omegaRef0Pu * IConvq0;
  VConvqref0 = YIntegratorq_currentLoop0 + Lfilter * SystemBase.omegaRef0Pu * IConvd0;
  IConvd0 = IPCCd0 + YIntegratord_voltageLoop0;
  IConvq0 = IPCCq0 + YIntegratorq_voltageLoop0 + Cfilter * SystemBase.omegaRef0Pu * VFilterd0;
  Pref0 = VFilterd0 * IPCCd0;
  Pref0 = Idcref0 * Vdc0;
  Qref0 = - VFilterd0 * IPCCq0;
  VFilterq0 = 0;
  Vdc0 = VFilterd0;
  Wref0 = SystemBase.omegaRef0Pu;

annotation(preferredView = "text");

end GlobalDroopControl_INIT;
