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

model DynamicLine "AC power line - PI model considerating the dynamics of the inductance and the capacitances "
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;

  extends SwitchOff.SwitchOffLine;
  extends AdditionalIcons.Line;

  Connectors.ACPower terminal1(V(re(start = u10Pu.re), im(start = u10Pu.im)), i(re(start = i10Pu.re), im(start = i10Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Connectors.ACPower terminal2(V(re(start = u20Pu.re), im(start = u20Pu.im)), i(re(start = i20Pu.re), im(start = i20Pu.im))) annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit RPu "Resistance in pu Current through the equivalent impedance G+jB on side 1 in pu (base SnRef, UNom) ";
  parameter Types.PerUnit LPu "Reactance in pu (base SnRef,UNom)";
  parameter Types.PerUnit GPu "Half-conductance in pu (base SnRef,UNom)";
  parameter Types.PerUnit CPu "Half-susceptance in pu (base SnRef,UNom)";




  parameter Types.ComplexVoltagePu u10Pu "Start value of the voltage on side 1 base UNom ";
  parameter Types.ComplexVoltagePu u20Pu "Start value of the voltage on side 2 base Unom ";
  parameter Types.ComplexCurrentPu i10Pu "Start value of the current on side 1 in pu (base UNom, SnRef)(receptor convention) ";
  parameter Types.ComplexCurrentPu i20Pu "Start value of the current on side 2 in pu (base UNom, SnRef) ";

  parameter Types.ComplexCurrentPu iRL0Pu "Start value of the current module in the R,L part of the line in pu (base UNom, SnRef)(receptor convention)";
  parameter Types.ComplexCurrentPu iGC10Pu "Start value of the current module in the G,C part of the line on side 1 in pu (base UNom, SnRef) (receptor convention)" ;
  parameter Types.ComplexCurrentPu iGC20Pu  "Start value of the current module in the G,C part of the line on side 2 in pu (base UNom, SnRef) (receptor convention)" ;

  input Types.AngularVelocityPu omegaPu(start = SystemBase.omega0Pu);

    Types.ComplexCurrentPu iRLPu(re(start = iRL0Pu.re) , im(start = iRL0Pu.im))" Current through the equivalent impedance R+jX in pu (base UNom, SnRef)";
    Types.ComplexCurrentPu iGC1Pu(re(start = iGC10Pu.re) , im(start = iGC10Pu.im)) " Current through the equivalent impedance G+jB on side 1 in pu (base UNom, SnRef) ";
    Types.ComplexCurrentPu iGC2Pu(re(start = iGC20Pu.re) , im(start = iGC20Pu.im))" Current through the equivalent impedance G+jB on side 2 in pu (base UNom, SnRef) ";
    Types.ActivePowerPu P1Pu(start=0) "Active power on side 1 in pu (base SnRef)";
    Types.ReactivePowerPu Q1Pu(start=0) "Reactive power on side 1 in pu (base SnRef)";
    Types.ActivePowerPu P2Pu(start=0) "Active power on side 2 in pu (base SnRef)";
    Types.ReactivePowerPu Q2Pu(start=0) "Reactive power on side 2 in pu (base SnRef)";

equation
  if (running.value) then
    iGC1Pu.re = GPu*terminal1.V.re + CPu*der(terminal1.V.re)/SystemBase.omegaNom - CPu*terminal1.V.im;
    iGC1Pu.im = GPu*terminal1.V.im + CPu*der(terminal1.V.im)/SystemBase.omegaNom + CPu*terminal1.V.re;
    iGC2Pu.re = GPu*terminal2.V.re + CPu*der(terminal2.V.re)/SystemBase.omegaNom - CPu*terminal2.V.im;
    iGC2Pu.im = GPu*terminal2.V.im + CPu*der(terminal2.V.im)/SystemBase.omegaNom + CPu*terminal2.V.re;
    iRLPu.re + LPu*der(iRLPu.re)/SystemBase.omegaNom - LPu*omegaPu*iRLPu.im = terminal1.V.re - terminal2.V.re;
    iRLPu.im + LPu*der(iRLPu.im)/SystemBase.omegaNom + LPu*omegaPu*iRLPu.re = terminal1.V.im - terminal2.V.im;
    terminal1.i = iRLPu+iGC1Pu ;
    terminal2.i = iGC2Pu-iRLPu ;
  else
    terminal1.i = Complex (0);
    terminal2.i = Complex (0);
    iRLPu = Complex (0);
    iGC10Pu = Complex (0);
    iGC20Pu = Complex (0);
  end if;
    P1Pu = ComplexMath.real(terminal1.V * ComplexMath.conj(terminal1.i));
    Q1Pu = ComplexMath.imag(terminal1.V * ComplexMath.conj(terminal1.i));
    P2Pu = ComplexMath.real(terminal2.V * ComplexMath.conj(terminal2.i));
    Q2Pu = ComplexMath.imag(terminal2.V * ComplexMath.conj(terminal2.i));

end DynamicLine;
