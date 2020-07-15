within Dynawo.Electrical.Loads;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model LoadAlphaBetaRestorative "Generic model of a restorative Alpha-Beta load."
  extends BaseClasses.BaseLoad;
  extends AdditionalIcons.Load;

  public
    parameter Types.Time tFilter "Time constant of the load restoration";
    parameter Types.VoltageModulePu UMinPu "Minimum value of the voltage amplitude at terminal in p.u (base UNom) that ensures the P/Q restoration";
    parameter Types.VoltageModulePu UMaxPu "Maximum value of the voltage amplitude at terminal in p.u (base UNom) that ensures the P/Q restoration";
    parameter Real Alpha "Active load sensitivity to voltage";
    parameter Real Beta  "Reactive load sensitivity to voltage";

    // in order to change the load set-point, connect an event to PRefPu or QRefPu
    Connectors.ZPin PRefPu (value (start = s0Pu.re)) "Active power request in p.u (base SnRef)";
    Connectors.ZPin QRefPu (value (start = s0Pu.im)) "Reactive power request in p.u (base SnRef)";

  protected
    Types.VoltageModulePu UFilteredRawPu (start = ComplexMath.'abs' (u0Pu)) "Filtered voltage amplitude at terminal in p.u (base UNom)";
    Types.VoltageModulePu UFilteredPu (start = ComplexMath.'abs' (u0Pu)) "Bounded filtered voltage amplitude at terminal in p.u (base UNom)";

  equation
    if (running.value) then
      tFilter * der(UFilteredRawPu) = ComplexMath.'abs' (terminal.V) - UFilteredRawPu;
      UFilteredPu = if UFilteredRawPu >= UMaxPu then UMaxPu elseif UFilteredRawPu <= UMinPu then UMinPu else UFilteredRawPu;
      PPu = PRefPu.value * ((ComplexMath.'abs' (terminal.V) / UFilteredPu) ^ Alpha);
      QPu = QRefPu.value * ((ComplexMath.'abs' (terminal.V) / UFilteredPu) ^ Beta);
    else
      UFilteredRawPu = 0;
      UFilteredPu = 0;
      terminal.i = Complex(0);
    end if;

annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>  After an event, the load goes back to its initial PPu/QPu unless the voltage at its terminal is lower than UMinPu or higher than UMaxPu. In this case, the load behaves as a classical Alpha-Beta load.<div>This load restoration emulates the behaviour of a tap changer transformer that connects the load to the system and regulates the voltage at its terminal.</div></body></html>"));
end LoadAlphaBetaRestorative;
