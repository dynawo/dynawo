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

model GlobalDispatchableVirtualOscillatorControl_INIT "Initialization model for the global dispatchable virtual oscillator control"

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  
  parameter Types.PerUnit Lfilter "Filter inductance in p.u (base UNom, SNom)";
  parameter Types.PerUnit Cfilter "Filter capacitance in p.u (base UNom, SNom)";
  
  parameter Types.PerUnit omegaRef0Pu "Start value of the grid frequency in p.u";
  parameter Types.PerUnit Pref0 "Start value of the active power reference at the converter's capacitor in p.u (base SNom) (generator convention)";
  parameter Types.PerUnit Veffref0 "Start value of the voltage reference at the converter's capacitor in p.u (base UNom)";
  parameter Types.PerUnit vdcref0 "Start value of the DC voltage reference";
  
  Types.PerUnit icdref0;
  Types.PerUnit icqref0;
  Types.PerUnit icd0;
  Types.PerUnit icq0;
  Types.PerUnit DeltaVVIq0;
  Types.PerUnit DeltaVVId0;
  Types.PerUnit yIntegratord_voltageLoop0;
  Types.PerUnit yIntegratorq_voltageLoop0;
  Types.PerUnit iod0;
  Types.PerUnit ioq0;
  Types.PerUnit vod0;
  Types.PerUnit voq0;
  Types.PerUnit vodref0;
  Types.PerUnit voqref0;
  Types.PerUnit omega0Pu;
  Types.PerUnit yIntegratord_currentLoop0;
  Types.PerUnit yIntegratorq_currentLoop0;
  Types.PerUnit vcdref0;
  Types.PerUnit vcqref0;
  Types.PerUnit vorefRawmodule0;
  Types.Angle deph0;
  Types.PerUnit idc0;
  Types.PerUnit vdc0;
  
  equation

  vcdref0 = Veffref0 + yIntegratord_currentLoop0 - Lfilter * omegaRef0Pu * icq0;
  vcqref0 = yIntegratorq_currentLoop0 + Lfilter * omegaRef0Pu * icd0;
  icdref0 = iod0 + yIntegratord_voltageLoop0;
  icqref0 = ioq0 + yIntegratorq_voltageLoop0 + Cfilter * omegaRef0Pu * Veffref0;
  vodref0 = vod0;
  voqref0 = voq0;
  icdref0 = icd0;
  icqref0 = icq0;
  omega0Pu = omegaRef0Pu;
  DeltaVVIq0 = 0;
  DeltaVVId0 = 0;
  Pref0 = Veffref0 * iod0;
  voqref0 = 0;
  vodref0 = Veffref0;
  vdc0 = vdcref0;
  vorefRawmodule0 = Veffref0;
  
end GlobalDispatchableVirtualOscillatorControl_INIT;