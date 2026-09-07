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
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record ParamsQRefLim "Parameters of reactive power limits calculation"
  parameter Types.ReactivePowerPu QOpMaxPu "Maximum operator value of the reactive power in pu (base SNom) (DC to AC)";
  parameter Types.ReactivePowerPu QOpMinPu "Minimum operator value of the reactive power in pu (base SNom) (DC to AC)";
  parameter String QPMaxTableName "Name of the table in the text file for upper reactive power limit as a function of active power";
  parameter String QPMinTableName "Name of the table in the text file for lower reactive power limit as a function of active power";
  parameter String QUMaxTableName "Name of the table in the text file for upper reactive power limit as a function of voltage";
  parameter String QUMinTableName "Name of the table in the text file for lower reactive power limit as a function of voltage";
  parameter String TablesFile "Text file that contains the table for the function calculating the reactive power limits";
  parameter Types.Time tMeasure "Time constant of the measurement filters in s";

  annotation(preferredView = "text");
end ParamsQRefLim;
