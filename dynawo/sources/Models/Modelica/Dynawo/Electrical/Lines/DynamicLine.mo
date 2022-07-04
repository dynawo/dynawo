within Dynawo.Electrical.Lines;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model DynamicLine "AC power line - PI model considering the dynamics of the inductance and the capacitances "

/*
  Equivalent circuit and conventions:

               I1                  I2
   (terminal1) -->-------R+jX-------<-- (terminal2)
                    |           |
                  G+jB         G+jB
                    |           |
                   ---         ---
*/

  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  import Dynawo.Electrical.SystemBase;

  extends SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  parameter Types.PerUnit RPu "Resistance in pu (base SnRef, UNom) ";
  parameter Types.PerUnit LPu "Inductance in pu (base SnRef, UNom, omegaNom)";
  parameter Types.PerUnit GPu "Half-conductance in pu (base SnRef, UNom)";
  parameter Types.PerUnit CPu "Half-capacitance in pu (base SnRef, UNom, omegaNom)";

  parameter Types.ComplexVoltagePu u10Pu "Start value of the complex voltage on side 1 (base UNom) ";
  parameter Types.ComplexVoltagePu u20Pu "Start value of the complex voltage on side 2 (base Unom) ";
  parameter Types.ComplexCurrentPu i10Pu "Start value of the complex current on side 1 in pu (base SnRef, UNom)(receptor convention) ";
  parameter Types.ComplexCurrentPu i20Pu "Start value of the complex current on side 2 in pu (base SnRef, UNom)(receptor convention)";
  parameter Types.ComplexCurrentPu iRL0Pu "Start value of the complex current in the R,L part of the line in pu (base SnRef, UNom)(receptor convention)";
  parameter Types.ComplexCurrentPu iGC10Pu "Start value of the complex current in the G,C part of the line on side 1 in pu (base SnRef, UNom) (receptor convention)" ;
  parameter Types.ComplexCurrentPu iGC20Pu "Start value of the complex current in the G,C part of the line on side 2 in pu (base SnRef, UNom) (receptor convention)" ;

  input Types.AngularVelocityPu omegaPu(start = SystemBase.omega0Pu) "Grid frequency in pu (base omegaNom) ";
  Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


  Types.ComplexCurrentPu iRLPu(re(start = iRL0Pu.re) , im(start = iRL0Pu.im)) "Complex current in the R,L part of the line in pu (base SnRef, UNom)(receptor convention)";
  Types.ComplexCurrentPu iGC1Pu(re(start = iGC10Pu.re) , im(start = iGC10Pu.im)) "Complex current in the G,C part of the line on side 1 in pu (base SnRef, UNom) (receptor convention)" ;
  Types.ComplexCurrentPu iGC2Pu(re(start = iGC20Pu.re) , im(start = iGC20Pu.im)) " Complex current in the G,C part of the line on side 2 in pu (base SnRef, UNom) (receptor convention)";
  Types.ApparentPower s1Pu "Complex apparent power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ApparentPower s2Pu "Complex apparent power at terminal 2 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P1Pu "Active power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q1Pu "Reactive power at terminal 1 in pu (base SnRef) (receptor convention)";
  Types.ActivePowerPu P2Pu "Active power at terminal 2 in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu Q2Pu "Reactive power at terminal 2 in pu (base SnRef) (receptor convention)";


equation

  if (running.value) then
    iGC1Pu.re = GPu * terminal1.V.re + CPu * der(terminal1.V.re / SystemBase.omegaNom) - omegaPu * CPu * terminal1.V.im;
    iGC1Pu.im = GPu * terminal1.V.im + CPu * der(terminal1.V.im / SystemBase.omegaNom) + omegaPu * CPu * terminal1.V.re;
    iGC2Pu.re = GPu * terminal2.V.re + CPu * der(terminal2.V.re / SystemBase.omegaNom) - omegaPu * CPu * terminal2.V.im;
    iGC2Pu.im = GPu * terminal2.V.im + CPu * der(terminal2.V.im / SystemBase.omegaNom) + omegaPu * CPu * terminal2.V.re;
    RPu * iRLPu.re + LPu * der(iRLPu.re / SystemBase.omegaNom) - omegaPu * LPu * iRLPu.im = terminal1.V.re - terminal2.V.re;
    RPu * iRLPu.im + LPu * der(iRLPu.im / SystemBase.omegaNom) + omegaPu * LPu * iRLPu.re = terminal1.V.im - terminal2.V.im;
    terminal1.i = iRLPu + iGC1Pu ;
    terminal2.i = iGC2Pu - iRLPu ;

  else

 //LPu * der(iRLPu.re / SystemBase.omegaNom) = terminal1.V.re - terminal2.V.re;
// LPu * der(iRLPu.im / SystemBase.omegaNom) = terminal1.V.im - terminal2.V.im;
    terminal1.i = Complex(0,0);
    iGC1Pu = Complex(0,0);
    terminal2.i = Complex(0,0);
    iGC2Pu = Complex(0,0);
    iRLPu = Complex(0,0);

  end if;

  s1Pu = terminal1.V * ComplexMath.conj(terminal1.i);
  s2Pu = terminal2.V * ComplexMath.conj(terminal2.i);
  P1Pu = s1Pu.re;
  Q1Pu = s1Pu.im;
  P2Pu = s2Pu.re;
  Q2Pu = s2Pu.im;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
The line model is a PI model considering the dynamics of the inductance and the capacitances with the following equivalent circuit and conventions:<div><br></div><div>
<p style=\"margin: 0px;\"><br></p>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">               I1                  I2</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">   (terminal1) --&gt;-------R+jX-------&lt;-- (terminal2)</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |           |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                  G+jB         G+jB</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                    |           |</span></pre>
<pre style=\"margin-top: 0px; margin-bottom: 0px;\"><span style=\"font-family: 'Courier New'; font-size: 12pt;\">                   ---         ---</span><!--EndFragment--></pre></div><div><div><pre style=\"text-align: center; margin-top: 0px; margin-bottom: 0px;\"><!--EndFragment--></pre></div></div></body></html>"));
end DynamicLine;
