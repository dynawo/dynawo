within Dynawo.Electrical.Wind;

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

package IEC "Wind models from IEC N°61400-27-1 standard"
  extends Icons.Package;

  annotation(
    preferredView = "info",
    Documentation(info = "<html><head></head><body>The modeling differences between WT and WPP models are described in the following schematic :
    <figure>
    <img width=\"800\" src=\"modelica://Dynawo/Electrical/Wind/IEC/Resources/WT_WPP.png\">
    </figure>
<br><br></body></html>"));
end IEC;
