within Dynawo.Electrical.Switches;

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

model IdealSwitchAdaptedV2 "Ideal switch"
  /*
    When the switch is closed (running = true), the voltage on both terminals are equal and the current is going through the switch.
    When the switch is open (running = false), the current going through the switch is equal to zero.

    Equivalent circuit and conventions:

               I1                  I2
    (terminal1) -->-------/ -------<-- (terminal2)

  */
  extends AdditionalIcons.Switch;
  extends Dynawo.Electrical.Controls.Basics.SwitchOff.SwitchOffIdealSwitch;

  Dynawo.Connectors.ACPower terminal1 "Switch side 1" annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Connectors.ACPower terminal2 "Switch side 2" annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Types.ComplexVoltagePu VTerminal1 "Complex AC voltage of terminal 1";
  //Types.ComplexVoltagePu VTerminal2 "Complex AC voltage of terminal 2";

  // Variables for display
  Types.ActivePowerPu P1Pu "Active power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu "Reactive power on side 1 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P1GenPu "Active power on side 1 in pu (base SnRef) (generator convention)";
  Types.ReactivePowerPu Q1GenPu "Reactive power on side 1 in pu (base SnRef) (generator convention)";

  Types.ActivePowerPu P2Pu "Active power on side 2 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu "Reactive power on side 2 in pu (base SnRef) (receptor convention)";

equation
  // When the switch is closed, V and i are equal on both sides. Otherwise, the currents are zero.
  if (running.value) then
    terminal1.i = - terminal2.i;
    terminal1.V = terminal2.V;
    P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
    Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
    P1GenPu = - P1Pu;
    Q1GenPu = - Q1Pu;
    P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
    Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));
  else
    terminal1.i = terminal2.i;
    terminal1.i = Complex(0);
    //terminal1.V = VTerminal1;
    //terminal2.V = VTerminal2;
    //terminal2.V = Complex(0);
    P1Pu = 0;
    Q1Pu = 0;
    P1GenPu = 0;
    Q1GenPu = 0;
    P2Pu = 0;
    Q2Pu = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>When the switch is closed, the voltage on both terminals ar equal and the current is going through the switch.<div>When the switch is open, the current going through the switch is zero.</div><div><br></div><div>The equivalent circuit and conventions is:</div><div>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><!--StartFragment--><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1                  I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">    (terminal1) --&gt;-------/ -------&lt;-- (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><br><!--EndFragment--></pre></div></body></html>"));

end IdealSwitchAdaptedV2;
