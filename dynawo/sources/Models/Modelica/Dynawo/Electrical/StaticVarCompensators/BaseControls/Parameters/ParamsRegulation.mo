within Dynawo.Electrical.StaticVarCompensators.BaseControls.Parameters;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

record ParamsRegulation

  parameter Types.PerUnit Kp "Proportional gain of the PI controller";
  parameter Types.PerUnit Lambda "Statism of the regulation law URefPu = UPu + Lambda * QPu in pu (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Static var compensator nominal apparent power in MVA";
  parameter Types.Time Ti "Integral time constant of the PI controller in s";

  annotation(preferredView = "text");
end ParamsRegulation;
