within Dynawo.Electrical.Transformers;

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

package BaseClasses_INIT

// Function that estimates the initial tap of a transformer
function TapEstimation "Function that estimate the initial tap of a transformer"

  input Types.AC.Impedance ZPu " Transformer impedance in p.u (base U2Nom, SnRef)";
  input SIunits.PerUnit rTfoMinPu "Minimum transformation ratio in p.u: U2/U1 in no load conditions";
  input SIunits.PerUnit rTfoMaxPu "Maximum transformation ratio in p.u: U2/U1 in no load conditions";
  input Integer NbTap "Number of taps";

  input Types.AC.Voltage u10Pu  "Start value of complex voltage at terminal 1 in p.u (base UNom)";
  input Types.AC.Current i10Pu  "Start value of complex current at terminal 1 in p.u (base UNom, SnRef) (receptor convention)";
  input Types.AC.VoltageModule Uc20Pu "Voltage set-point on side 2 in p.u (base U2Nom)";

  output Integer estimatedTap "Estimated tap";

protected
  Types.AC.ApparentPower s10Pu;
  Real ro;
  Real r2;
  Real estimatedRho;

  Real a;
  Real b;
  Real A;
  Real B;
  Real C;
  Real delta;
  Real estimatedTapReal;

algorithm
  if (rTfoMaxPu == rTfoMinPu) then
    estimatedTap := 0;
    return;
  end if;


  s10Pu := u10Pu * ComplexMath.conj(i10Pu);

  if (ComplexMath.'abs' (u10Pu) > 0) then
    if ((ComplexMath.'abs' (s10Pu) > 0) and (ComplexMath.'abs' (ZPu) > 0)) then
      //(R + j * X) * i1 = rho² * V1 - V2 => deduce rho
      a := ZPu.re * i10Pu.re - ZPu.im * i10Pu.im; // R * ir - X * ii
      b := ZPu.im * i10Pu.re + ZPu.re * i10Pu.im; // R * ii + X * ir
      //solving for Ax² + Bx + C
      A := (u10Pu.re * u10Pu.re + u10Pu.im * u10Pu.im);
      B := - 2 * (a * u10Pu.re + b * u10Pu.im) - Uc20Pu * Uc20Pu;
      C := (a * a + b * b);
      delta := B * B - 4 * A * C;
      assert(delta > 0,"rho supposed to be positive");

      r2 := (-1 * B + sqrt(delta)) / (2 * A); // take the largest x root
      assert(r2 > 0,"r2 supposed to be positive");
      estimatedRho := sqrt(r2);
    else
      estimatedRho := Uc20Pu / ComplexMath.'abs' (u10Pu);
    end if;

    estimatedTapReal := ((estimatedRho - rTfoMinPu) / (rTfoMaxPu - rTfoMinPu)) * (NbTap - 1);
    if (estimatedRho < rTfoMinPu) then
      estimatedTap := 0;
    elseif (estimatedRho > rTfoMaxPu) then
      estimatedTap := NbTap - 1;
    else
      //round the tap estimation (in order to get an integer)
      if (estimatedTapReal - floor(estimatedTapReal) < ceil(estimatedTapReal) - estimatedTapReal) then
        estimatedTap := integer(floor (estimatedTapReal));
      else
        estimatedTap := integer(ceil (estimatedTapReal));
      end if;
    end if;
  else
    estimatedTap := 0;
  end if;

end TapEstimation;

// Base model for initialization of TransformerVariableTap
partial model BaseTransformerVariableTap_INIT "Base model for initialization of TransformerVariableTap"

/*
  Equivalent circuit and conventions:

               I1  r                I2
    U1,P1,Q1 -->---oo----R+jX-------<-- U2,P2,Q2
  (terminal1)                   |      (terminal2)
                               G+jB
                                |
                               ---
*/

  import Dynawo.Electrical.SystemBase;

  public

    // Transformer's parameters
    parameter Types.AC.ApparentPowerModule SNom "Nominal apparent power in MVA";
    parameter SIunits.Resistance R "Resistance in % (base U2Nom, SNom)";
    parameter SIunits.Reactance X "Reactance in % (base U2Nom, SNom)";
    parameter SIunits.Conductance G "Conductance in % (base U2Nom, SNom)";
    parameter SIunits.Susceptance B "Susceptance in % (base U2Nom, SNom)";
    parameter SIunits.PerUnit rTfoMinPu "Minimum transformation ratio in p.u: U2/U1 in no load conditions";
    parameter SIunits.PerUnit rTfoMaxPu "Maximum transformation ratio in p.u: U2/U1 in no load conditions";
    parameter Integer NbTap "Number of taps";
    parameter Types.AC.VoltageModule Uc20Pu "Voltage set-point on side 2 in p.u (base U2Nom)";

  protected

    // Transformer's impedance and susceptance
    parameter Types.AC.Impedance ZPu(re = R / 100 * SystemBase.SnRef/ SNom , im  = X / 100 * SystemBase.SnRef/ SNom) "Transformer impedance in p.u (base U2Nom, SnRef)";
    parameter Types.AC.Admittance YPu(re = G / 100 * SNom / SystemBase.SnRef, im  = B / 100 * SNom / SystemBase.SnRef) "Transformer admittance in p.u (base U2Nom, SnRef)";

    // Transformer start values
    Types.AC.Voltage u20Pu  "Start value of complex voltage at terminal 2 in p.u (base U2Nom)";
    flow Types.AC.Current i20Pu  "Start value of complex current at terminal 2 in p.u (base U2Nom, SnRef) (receptor convention)";
    Types.AC.VoltageModule U20Pu "Start value of voltage amplitude at terminal 2 in p.u (base U2Nom)";

    Integer Tap0 "Start value of transformer tap";
    SIunits.PerUnit rTfo0Pu "Start value of transformer ratio";
    Constants.state state0 = Constants.state.CLOSED "Start value of connection state";

equation

  // Estimation of initial tap
  Tap0 = TapEstimation (ZPu, rTfoMinPu, rTfoMaxPu, NbTap, u10Pu, i10Pu, Uc20Pu);

  // Transformer ratio calculation
  if (NbTap == 1) then
    rTfo0Pu = rTfoMinPu;
  else
    rTfo0Pu = rTfoMinPu + (rTfoMaxPu - rTfoMinPu) * (Tap0 / (NbTap - 1));
  end if;

  // Transformer equations
  i10Pu = rTfo0Pu * (YPu * u20Pu - i20Pu);
  rTfo0Pu * rTfo0Pu * u10Pu = rTfo0Pu * u20Pu + ZPu * i10Pu;

  // Voltage at terminal 2
  U20Pu = ComplexMath.'abs' (u20Pu);

end BaseTransformerVariableTap_INIT;

end BaseClasses_INIT;
