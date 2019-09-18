within Dynawo.Electrical.Controls.Voltage.StaticVarCompensator;

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

model SVarCControl_INIT "Control initialization for standard static var compensator model"
  import Dynawo.Electrical.SystemBase;

  parameter Types.VoltageModule UNom "Static var compensator nominal voltage in kV";
  parameter Types.ApparentPowerModule SNom "Static var compensator nominal apparent power in MVA";
  parameter Types.PerUnit Lambda "Statism of the regulation law URefPu = UPu - Lambda*QPu";

  Types.PerUnit G0Pu "Start value of the conductance in p.u (base SNom)";
  Types.PerUnit B0Pu "Start value of the susceptance in p.u (base SNom)";
  Types.VoltageModulePu U0Pu  "Start value of voltage amplitude in p.u (base UNom)";
  Types.ReactivePowerPu Q0Pu  "Start value of reactive power in p.u (base SnRef) (receptor convention)";
  Types.VoltageModule URef0  "Start value of voltage reference in kV";

equation

  URef0 = (U0Pu - Lambda*Q0Pu*SystemBase.SnRef/SNom) * UNom;

end SVarCControl_INIT;
