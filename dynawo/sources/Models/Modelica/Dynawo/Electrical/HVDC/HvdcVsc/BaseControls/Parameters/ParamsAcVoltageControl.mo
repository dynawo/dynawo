within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;

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

record ParamsAcVoltageControl "Parameters of AC voltage control"
  extends ParamsQRefLim;
  extends ParamsQRefQU;

  parameter String IqModTableName "Name of the table in the text file for additional current as a function of voltage";
  parameter String TablesFile "Text file that contains the table for the function calculating the reactive power limits";
  parameter Types.Time tQ "Time constant of the first order filter for the AC voltage control in s";

  annotation(preferredView = "text");
end ParamsAcVoltageControl;
