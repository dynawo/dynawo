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

model GridFormingControl_INIT "Initialization model for the grid forming control"
  extends AdditionalIcons.Init;

  parameter Types.PerUnit KpVI "Proportional gain of the virtual impedance";
  parameter Types.PerUnit XRratio "X/R ratio of the virtual impedance";
  parameter Types.CurrentModulePu IMaxVI "Maximum current before activating the virtual impedance in pu (base UNom, SNom)";

  Types.PerUnit IdcSourceRef0Pu "Start value of DC current reference in pu (base UdcNom, SNom)";
  Types.PerUnitConnector IdcSource0Pu "Start value of DC current in pu (base UdcNom, SNom)";
  Types.PerUnitConnector UdcSource0Pu "Start value of DC voltage in pu (base UdcNom)";
  Types.PerUnit UdcSourceRef0Pu "Start value of DC voltage reference in pu (base UdcNom)";
  Types.PerUnitConnector UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)";
  Types.PerUnitConnector UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)";
  Types.PerUnitConnector IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  Types.PerUnitConnector IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  Types.ActivePowerPu PRef0Pu "Start value of the active power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  Types.ReactivePowerPu QRef0Pu "Start value of the reactive power reference at the converter's capacitor in pu (base SNom) (generator convention)";
  Types.PerUnitConnector IdPcc0Pu "Start value of d-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  Types.PerUnitConnector IqPcc0Pu "Start value of q-axis current in the grid in pu (base UNom, SNom) (generator convention)";
  Types.PerUnitConnector UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  Types.PerUnitConnector UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  Types.AngleConnector Theta0 "Start value of phase shift between the converter's rotating frame and the grid rotating frame in rad";
  Types.ActivePowerPuConnector PFilter0Pu "Start value of active power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  Types.ReactivePowerPuConnector QFilter0Pu "Start value of reactive power generated at the converter's capacitor in pu (base SNom) (generator convention)";
  Types.VoltageModulePu UFilterRef0Pu "Start value of voltage module reference at the converter's capacitor in pu (base UNom)";
  Types.CurrentModulePu IConvSquare0Pu "Start value of square current in the converter in pu (base UNom, SNom)";
  Types.CurrentModulePu DeltaIConvSquare0Pu "Start value of extra square current in the converter in pu (base UNom, SNom)";
  Types.PerUnit RVI0 "Start value of virtual resistance in pu (base UNom, SNom)";
  Types.PerUnit XVI0 "Start value of virtual reactance in pu (base UNom, SNom)";
  Types.PerUnit DeltaVVId0 "Start value of d-axis virtual impedance output in pu (base UNom)";
  Types.PerUnit DeltaVVIq0 "Start value of q-axis virtual impedance output in pu (base UNom)";

equation
  /* External loop */
  PRef0Pu = PFilter0Pu;
  UdFilter0Pu = UFilterRef0Pu;
  QRef0Pu = QFilter0Pu;
  UqFilter0Pu = 0;

  /* DC voltage control */
  IdcSourceRef0Pu = IdcSource0Pu;
  UdcSourceRef0Pu = 1;
  UdcSourceRef0Pu = UdcSource0Pu;

  /* Virtual impedance */
  IConvSquare0Pu = IdConv0Pu ^ 2 + IqConv0Pu ^ 2;
  DeltaIConvSquare0Pu = max((IConvSquare0Pu - IMaxVI ^ 2), 0);
  RVI0 = KpVI * DeltaIConvSquare0Pu;
  XVI0 = RVI0 * XRratio;
  DeltaVVId0 = IdConv0Pu * RVI0 - IqConv0Pu * XVI0;
  DeltaVVIq0 = IqConv0Pu * RVI0 + IdConv0Pu * XVI0;

  annotation(preferredView = "text");
end GridFormingControl_INIT;
