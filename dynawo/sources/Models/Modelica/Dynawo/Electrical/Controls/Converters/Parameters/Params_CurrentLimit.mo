within Dynawo.Electrical.Controls.Converters.Parameters;

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

record Params_CurrentLimit

  parameter Real tableIpMaxUwt11 = 0;
  parameter Real tableIpMaxUwt12 = 0;
  parameter Real tableIpMaxUwt21 = 0.15;
  parameter Real tableIpMaxUwt22 = 1;
  parameter Real tableIpMaxUwt31 = 0.9;
  parameter Real tableIpMaxUwt32 = 1;
  parameter Real tableIpMaxUwt41 = 0.925;
  parameter Real tableIpMaxUwt42 = 1;
  parameter Real tableIpMaxUwt51 = 1.075;
  parameter Real tableIpMaxUwt52 = 1.0001;
  parameter Real tableIpMaxUwt61 = 1.1;
  parameter Real tableIpMaxUwt62 = 1.0001;
  parameter Real tableIpMaxUwt[:,:] = [tableIpMaxUwt11,tableIpMaxUwt12;tableIpMaxUwt21,tableIpMaxUwt22;tableIpMaxUwt31,tableIpMaxUwt32;tableIpMaxUwt41,tableIpMaxUwt42;tableIpMaxUwt51,tableIpMaxUwt52;tableIpMaxUwt61,tableIpMaxUwt62] "IU diagram Max";

  parameter Real tableIqMaxUwt11 = 0;
  parameter Real tableIqMaxUwt12 = 0;
  parameter Real tableIqMaxUwt21 = 0.15;
  parameter Real tableIqMaxUwt22 = 1;
  parameter Real tableIqMaxUwt31 = 0.9;
  parameter Real tableIqMaxUwt32 = 1;
  parameter Real tableIqMaxUwt41 = 0.925;
  parameter Real tableIqMaxUwt42 = 0.33;
  parameter Real tableIqMaxUwt51 = 1.075;
  parameter Real tableIqMaxUwt52 = 0.33;
  parameter Real tableIqMaxUwt61 = 1.1;
  parameter Real tableIqMaxUwt62 = 1;
  parameter Real tableIqMaxUwt[:,:] = [tableIqMaxUwt11,tableIqMaxUwt12;tableIqMaxUwt21,tableIqMaxUwt22;tableIqMaxUwt31,tableIqMaxUwt32;tableIqMaxUwt41,tableIqMaxUwt42;tableIqMaxUwt51,tableIqMaxUwt52;tableIqMaxUwt61,tableIqMaxUwt62] "IU diagram Max";

end Params_CurrentLimit;
