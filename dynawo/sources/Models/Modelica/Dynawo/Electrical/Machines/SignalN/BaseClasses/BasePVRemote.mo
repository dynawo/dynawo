within Dynawo.Electrical.Machines.SignalN.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

partial model BasePVRemote "Base dynamic model for a remote voltage regulation"
  input Types.VoltageModule URef(start = URef0) "Voltage regulation set point in kV";
  input Types.VoltageModule URegulated(start = URegulated0) "Regulated voltage in kV";

  parameter Types.VoltageModule URef0 "Start value of the voltage regulation set point in kV";
  parameter Types.VoltageModule URegulated0 "Start value of the regulated voltage in kV";
  parameter Types.VoltageModulePu UDeadBandPu(min = 0) "Voltage deadband around the target in pu (base UNom)";
  parameter Types.ReactivePowerPu QDeadBandPu(min = 0) "Reactive power deadband around the target in pu (base SnRef)";

  annotation(preferredView = "text");
end BasePVRemote;
