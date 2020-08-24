within Dynawo.Electrical.Controls.Shunts;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model SectionControl "Section control for shunts with sections. The section of the shunt is changed depending on a measured voltage that is compared to its reference."
  import Dynawo.Connectors;
  import Dynawo.Types;
  import Modelica;

  Connectors.ZPin URefPu(value(start = URef0Pu)) "Voltage regulation set point in p.u (base UNom)";
  Connectors.ZPin section(value(start = section0)) "section position of the shunt";

  parameter Real section0 "Initial section of the shunt";
  parameter Real sectionMax "Maximum section of the shunt";
  parameter Real sectionMin "Minimum section of the shunt";
  parameter Real DeadbandUPu "Deadband of the section control in p.u (base UNom)";
  parameter Boolean isSelf "Boolean that states if the shunt is a self (true) or a condenser (false)";
  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in p.u (base UNom)";

  input Real URegulatedPu "Regulated voltage in p.u (base UNom)";

equation

 if isSelf then
   if URegulatedPu < URefPu.value - DeadbandUPu and pre(section.value) > sectionMin then
     section.value = pre(section.value) - 1;
   elseif URegulatedPu > URefPu.value + DeadbandUPu and pre(section.value) < sectionMax then
     section.value = pre(section.value) + 1;
   else
     section.value = pre(section.value);
   end if;
 else
   if URegulatedPu < URefPu.value - DeadbandUPu and pre(section.value) < sectionMax then
     section.value = pre(section.value) + 1;
   elseif URegulatedPu > URefPu.value + DeadbandUPu and pre(section.value) > sectionMin then
     section.value = pre(section.value) - 1;
   else
     section.value = pre(section.value);
   end if;
 end if;

annotation(preferredView = "text");
end SectionControl;
