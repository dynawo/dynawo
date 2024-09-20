within Dynawo.Electrical.Machines.OmegaRef.BaseClasses_INIT;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
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

function RotorPositionEstimationKundur "Rotor position estimation and saturation initial values calculations"
  extends Icons.Function;

  input Types.ComplexVoltagePu u0Pu "Complex voltage at terminal in pu (base UNom)";
  input Types.ComplexCurrentPu i0Pu "Complex current at terminal in pu (base UNom, SnRef)";
  input Types.PerUnit MdPu "Direct axis mutual inductance in pu";
  input Types.PerUnit MqPu "Quadrature axis mutual inductance in pu";
  input Types.PerUnit LdPu "Direct axis stator leakage in pu";
  input Types.PerUnit LqPu "Quadrature axis stator leakage in pu";
  input Types.PerUnit RaPu "Armature resistance in pu";
  input Types.PerUnit rTfoPu "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";
  input Types.PerUnit RTfoPu "Resistance of the generator transformer in pu (base SNom, UNom)";
  input Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base SNom, UNom)";
  input Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  input Real ASat "Parameter for mutual inductance saturation modelling";
  input Real BSat "Parameter for mutual inductance saturation modelling";
  input Real lambdaT1 "Parameter for mutual inductance saturation modelling";

  output Types.PerUnit MsalPu "Constant difference between direct and quadrature axis saturated mutual inductances in pu";
  output Types.Angle Theta0 "Start value of rotor angle: angle between machine rotor frame and port phasor frame";
  output Types.VoltageModulePu Ud0Pu "Start value of voltage of direct axis in pu";
  output Types.VoltageModulePu Uq0Pu "Start value of voltage of quadrature axis in pu";
  output Types.CurrentModulePu Id0Pu "Start value of current of direct axis in pu";
  output Types.CurrentModulePu Iq0Pu "Start value of current of quadrature axis in pu";
  output Types.PerUnit LambdaAD0Pu "Start value of common flux of direct axis in pu";
  output Types.PerUnit LambdaAQ0Pu "Start value of common flux of quadrature axis in pu";
  output Types.PerUnit LambdaAirGap0Pu "Start value of total air gap flux in pu";
  output Types.PerUnit MdSat0PPu "Start value of direct axis saturated mutual inductance in pu";
  output Types.PerUnit MqSat0PPu "Start value of quadrature axis saturated mutual inductance in pu";

protected
  // Intermediate variables calculated once at the beginning of the algorithm
  Types.PerUnit MdPPu;
  Types.PerUnit MqPPu;
  Types.PerUnit LdPPu;
  Types.PerUnit LqPPu;
  Types.PerUnit RaPPu;

  // Intermediate values calculated in the while loop to determine the rotor angle
  Types.PerUnit XqPPu "Quadrature axis reactance in pu";

  // Intermediate values dealing with the algorithm loop condition
  Types.PerUnit MdSat0PPuSave "Previous value for MdSat0PPu";
  Types.PerUnit MqSat0PPuSave "Previous value for MqSat0PPu";
  Types.PerUnit deltaMdSat0PPu "Variation of MdSat0PPu during the current iteration";
  Types.PerUnit deltaMqSat0PPu "Variation of MqSat0PPu during the current iteration";
  Integer nbIterations "Current number of iterations in the fix point algorithm";
  Boolean iterate "Indicates if the while loop should continue";

algorithm
  // Initial values calculations
  MdPPu := MdPu * rTfoPu * rTfoPu;
  MqPPu := MqPu * rTfoPu * rTfoPu;
  LdPPu := LdPu * rTfoPu * rTfoPu;
  LqPPu := LqPu * rTfoPu * rTfoPu;
  RaPPu := RaPu * rTfoPu * rTfoPu;
  MsalPu := MdPPu - MqPPu;
  MdSat0PPu := MdPPu;
  MqSat0PPu := MqPPu;
  MdSat0PPuSave := MdSat0PPu;
  MqSat0PPuSave := MqSat0PPu;
  iterate := true;
  nbIterations := 0;

  while iterate loop
    // Theta calculation
    XqPPu := MqSat0PPu + (LqPPu + XTfoPu);
    Theta0 := ComplexMath.arg(u0Pu - Complex(RaPPu + RTfoPu, XqPPu) * i0Pu * SystemBase.SnRef/SNom);

    // Park's transformations
    Ud0Pu := sin(Theta0) * u0Pu.re - cos(Theta0) * u0Pu.im;
    Uq0Pu := cos(Theta0) * u0Pu.re + sin(Theta0) * u0Pu.im;
    Id0Pu := sin(Theta0) * i0Pu.re * SystemBase.SnRef/SNom - cos(Theta0) * i0Pu.im * SystemBase.SnRef/SNom;
    Iq0Pu := cos(Theta0) * i0Pu.re * SystemBase.SnRef/SNom + sin(Theta0) * i0Pu.im * SystemBase.SnRef/SNom;

    // Common flux calculations
    LambdaAD0Pu := Uq0Pu - (RaPPu + RTfoPu) * Iq0Pu - (LdPPu + XTfoPu) * Id0Pu;
    LambdaAQ0Pu := - Ud0Pu + (RaPPu + RTfoPu) * Id0Pu - (LqPPu + XTfoPu) * Iq0Pu;
    LambdaAirGap0Pu := sqrt(LambdaAD0Pu^2 + LambdaAQ0Pu^2);

    // Saturation part
    MdSat0PPu := MdPPu * LambdaAirGap0Pu/(LambdaAirGap0Pu + ASat*exp(BSat*(LambdaAirGap0Pu - lambdaT1)));
    MqSat0PPu := MqPPu * LambdaAirGap0Pu/(LambdaAirGap0Pu + ASat*exp(BSat*(LambdaAirGap0Pu - lambdaT1)));

    // Algorithm stopping conditions
    deltaMdSat0PPu := abs(MdSat0PPu - MdSat0PPuSave);
    deltaMqSat0PPu := abs(MqSat0PPu - MqSat0PPuSave);
    nbIterations := nbIterations + 1;
    MdSat0PPuSave := MdSat0PPu;
    MqSat0PPuSave := MqSat0PPu;
    iterate := (deltaMdSat0PPu > 0.000001 or deltaMqSat0PPu > 0.000001) and nbIterations < 10;
  end while;

  annotation(preferredView = "text");
end RotorPositionEstimationKundur;
