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

record Params_QLimit

  parameter Real tableQMaxuWTCfilt11 = 0;
  parameter Real tableQMaxuWTCfilt12 = 0;
  parameter Real tableQMaxuWTCfilt21 = 0.8;
  parameter Real tableQMaxuWTCfilt22 = 0.33;
  parameter Real tableQMaxuWTCfilt31 = 0.9;
  parameter Real tableQMaxuWTCfilt32 = 0.33;
  parameter Real tableQMaxuWTCfilt[:,:] = [tableQMaxuWTCfilt11,tableQMaxuWTCfilt12;tableQMaxuWTCfilt21,tableQMaxuWTCfilt22;tableQMaxuWTCfilt31,tableQMaxuWTCfilt32] "UQ diagram Max";

  parameter Real tableQMinuWTCfilt11 = 0;
  parameter Real tableQMinuWTCfilt12 = 0;
  parameter Real tableQMinuWTCfilt21 = 0.8;
  parameter Real tableQMinuWTCfilt22 = -0.33;
  parameter Real tableQMinuWTCfilt31 = 0.9;
  parameter Real tableQMinuWTCfilt32 = -0.33;
  parameter Real tableQMinuWTCfilt[:,:] = [tableQMinuWTCfilt11,tableQMinuWTCfilt12;tableQMinuWTCfilt21,tableQMinuWTCfilt22;tableQMinuWTCfilt31,tableQMinuWTCfilt32] "UQ diagram Max";

  parameter Real tableQMaxpWTCfilt11 = 0;
  parameter Real tableQMaxpWTCfilt12 = 0;
  parameter Real tableQMaxpWTCfilt21 = 0.3;
  parameter Real tableQMaxpWTCfilt22 = 0.33;
  parameter Real tableQMaxpWTCfilt31 = 1;
  parameter Real tableQMaxpWTCfilt32 = 0.33;
  parameter Real tableQMaxpWTCfilt[:,:] = [tableQMaxpWTCfilt11,tableQMaxpWTCfilt12;tableQMaxpWTCfilt21,tableQMaxpWTCfilt22;tableQMaxpWTCfilt31,tableQMaxpWTCfilt32] "PQ diagram Max";

  parameter Real tableQMinpWTCfilt11 = 0;
  parameter Real tableQMinpWTCfilt12 = 0;
  parameter Real tableQMinpWTCfilt21 = 0.3;
  parameter Real tableQMinpWTCfilt22 = -0.33;
  parameter Real tableQMinpWTCfilt31 = 1;
  parameter Real tableQMinpWTCfilt32 = -0.33;
  parameter Real tableQMinpWTCfilt[:,:] = [tableQMinpWTCfilt11,tableQMinpWTCfilt12;tableQMinpWTCfilt21,tableQMinpWTCfilt22;tableQMinpWTCfilt31,tableQMinpWTCfilt32] "PQ diagram Max";

end Params_QLimit;
