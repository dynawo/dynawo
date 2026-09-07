within Dynawo.Examples;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

package ENTSOE
  extends Icons.Package;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body><div>This package contains the test cases mentioned in this ENTSOE report available <a href=\"https://eepublicdownloads.entsoe.eu/clean-documents/pre2015/publications/entsoe/RG_SOC_CE/131127_Controller_Test_Report.pdf\">here</a>.&nbsp;</div><div><br></div>The characteristics of the test cases are summarized below :<br><br><br><table>
  <style>
table, th, td {
  border: 1px solid black;
}

table {
  width: 100%;
}
</style>
  <colgroup>
    <col span=\"1\" style=\"background-color:gray\">
  </colgroup>
  <tbody><tr align=\"center\" style=\"background-color:gray\">
    <td>Test case</td>
    <td>Generator connected to ...</td>
    <td>Simulated event</td>
  </tr>
  <tr align=\"center\">
    <td>1</td>
    <td>&nbsp;Zero current bus</td>
    <td>Voltage reference step</td>
  </tr>
  <tr align=\"center\">
    <td>2</td>
    <td>Power-consuming load</td>
    <td>Load active power variation</td>
  </tr>
  <tr align=\"center\">
    <td>3</td>
    <td>Infinite bus</td>
    <td>Node fault</td>
  </tr></tbody></table><div><br></div></body></html>"));
end ENTSOE;
