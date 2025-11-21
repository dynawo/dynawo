within Dynawo.Electrical.Wind.IEC.WPP;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model WPP4CurrentSource_INIT "Wind Power Plant Type 4 model from IEC 61400-27-1 standard : initialization model"
  extends Dynawo.Electrical.Wind.IEC.WT.WT4CurrentSource_INIT;

  //QControl parameter
  parameter Integer MwpqMode "Control mode (0 : reactive power reference, 1 : power factor reference, 2 : UQ static, 3 : voltage control)";

  Dynawo.Types.PerUnit X0Pu "Initial reactive power or voltage reference in pu (base SNom or UNom) (generator convention)";

equation
  X0Pu = if MwpqMode == 3 then U0Pu else -Q0Pu * SystemBase.SnRef / SNom;

  annotation(
    preferredView = "text",
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})));
end WPP4CurrentSource_INIT;
