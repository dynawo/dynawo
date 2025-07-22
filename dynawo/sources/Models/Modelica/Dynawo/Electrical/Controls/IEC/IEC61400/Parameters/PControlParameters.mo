within Dynawo.Electrical.Controls.IEC.IEC61400.Parameters;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

record PControlParameters
  parameter Real TablePwpBiasfwpFiltCom[:,:] = [0.95, 1; 1, 0; 1.05, -1; 1.06, -1; 1.07, -1; 1.08, -1; 1.09, -1] "Table for defining power variation versus frequency" annotation(
    Dialog(tab = "PControlTables"));

  annotation(
    preferredView = "text");
end PControlParameters;
