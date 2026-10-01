within Dynawo.Electrical.Machines.OmegaRef.BaseClasses_INIT;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

function MdPPuEfdNomCalculation "Function that calculates MdPPuEfdNom"
  extends Icons.Function;

  input Types.ActivePower PNomAlt "Nominal active (alternator) power in MW";
  input Types.PerUnit MdPu "Direct axis mutual inductance in pu";
  input Types.PerUnit MqPu "Quadrature axis mutual inductance in pu";
  input Types.PerUnit LdPu "Direct axis stator leakage in pu";
  input Types.PerUnit LqPu "Quadrature axis stator leakage in pu";
  input Types.PerUnit RaPu "Armature resistance in pu";
  input Types.PerUnit rTfoPu "Ratio of the generator transformer in pu (base UBaseHV, UBaseLV)";
  input Types.PerUnit RTfoPu "Resistance of the generator transformer in pu (base SNom, UNom)";
  input Types.PerUnit XTfoPu "Reactance of the generator transformer in pu (base SNom, UNom)";
  input Types.ApparentPowerModule SNom "Nominal apparent power in MVA";
  input Real md "Parameter for direct axis mutual inductance saturation modelling";
  input Real mq "Parameter for quadrature axis mutual inductance saturation modelling";
  input Real nd "Parameter for direct axis mutual inductance saturation modelling";
  input Real nq "Parameter for quadrature axis mutual inductance saturation modelling";

  output Types.PerUnit MdPPuEfdNom "Direct axis mutual inductance used to determine the excitation voltage in nominal conditions in pu";

protected
  // Intermediate variables calculated once at the beginning of the algorithm
  Types.PerUnit MdPPu "Direct axis mutual inductance in pu";
  Types.PerUnit MqPPu "Quadrature axis mutual inductance in pu";
  Types.PerUnit LdPPu "Direct axis stator leakage in pu";
  Types.PerUnit LqPPu "Quadrature axis stator leakage in pu";
  Types.PerUnit RaPPu "Armature resistance in pu";
  Types.ComplexCurrentPu i0PuNom "Complex current at terminal in pu (base UNom, SNom)";

  // Intermediate values calculated in the while loop to determine the rotor angle
  Types.PerUnit XqPPu "Quadrature axis reactance in pu";
  Types.PerUnit MsalPu "Constant difference between direct and quadrature axis saturated mutual inductances in pu";
  Types.Angle Theta0 "Start value of rotor angle: angle between machine rotor frame and port phasor frame";
  Types.VoltageModulePu Ud0PuNom "Start value of voltage of direct axis in pu";
  Types.VoltageModulePu Uq0PuNom "Start value of voltage of quadrature axis in pu";
  Types.CurrentModulePu Id0PuNom "Start value of current of direct axis in pu";
  Types.CurrentModulePu Iq0PuNom "Start value of current of quadrature axis in pu";
  Types.PerUnit LambdaAD0PuNom "Start value of common flux of direct axis in pu";
  Types.PerUnit LambdaAQ0PuNom "Start value of common flux of quadrature axis in pu";
  Types.PerUnit LambdaAirGap0PuNom "Start value of total air gap flux in pu";
  Types.PerUnit Mds0PuNom "Start value of direct axis saturated mutual inductance in the case when the total air gap flux is aligned on the direct axis in pu";
  Types.PerUnit Mqs0PuNom "Start value of quadrature axis saturated mutual inductance in the case when the total air gap flux is aligned on the quadrature axis in pu";
  Types.PerUnit Cos2Eta0 "Start value of the common flux of direct axis contribution to the total air gap flux in pu";
  Types.PerUnit Sin2Eta0 "Start value of the common flux of quadrature axis contribution to the total air gap flux in pu";
  Types.PerUnit Mi0PuNom "Start value of intermediate axis saturated mutual inductance in pu";
  Types.PerUnit MdSat0PPuNom "Start value of direct axis saturated mutual inductance in pu";
  Types.PerUnit MqSat0PPuNom "Start value of quadrature axis saturated mutual inductance in pu";

  // Intermediate values dealing with the algorithm loop condition
  Types.PerUnit MdSat0PPuNomSave "Previous value for MdSat0PPuNom";
  Types.PerUnit MqSat0PPuNomSave "Previous value for MqSat0PPuNom";
  Types.PerUnit deltaMdSat0PPuNom "Variation of MdSat0PPuNom during the current iteration";
  Types.PerUnit deltaMqSat0PPuNom "Variation of MqSat0PPuNom during the current iteration";
  Integer nbIterations "Current number of iterations in the fix point algorithm";
  Boolean iterate "Indicates if the while loop should continue";

algorithm
  // Initial values calculations
  i0PuNom := Complex(- PNomAlt, sqrt(SNom ^ 2 - PNomAlt ^ 2)) / SNom;
  MdPPu := MdPu * rTfoPu * rTfoPu;
  MqPPu := MqPu * rTfoPu * rTfoPu;
  LdPPu := LdPu * rTfoPu * rTfoPu;
  LqPPu := LqPu * rTfoPu * rTfoPu;
  RaPPu := RaPu * rTfoPu * rTfoPu;
  MsalPu := MdPPu - MqPPu;
  MdSat0PPuNom := MdPPu;
  MqSat0PPuNom := MqPPu;
  MdSat0PPuNomSave := MdSat0PPuNom;
  MqSat0PPuNomSave := MqSat0PPuNom;
  iterate := true;
  nbIterations := 0;

  while iterate loop
    // Theta calculation
    XqPPu := MqSat0PPuNom + (LqPPu + XTfoPu);
    Theta0 := ComplexMath.arg(Complex(1,0) - Complex(RaPPu + RTfoPu, XqPPu) * i0PuNom);

    // Park's transformations
    Ud0PuNom := sin(Theta0);
    Uq0PuNom := cos(Theta0);
    Id0PuNom := sin(Theta0) * i0PuNom.re - cos(Theta0) * i0PuNom.im;
    Iq0PuNom := cos(Theta0) * i0PuNom.re + sin(Theta0) * i0PuNom.im;

    // Common flux calculations
    LambdaAD0PuNom := Uq0PuNom - (RaPPu + RTfoPu) * Iq0PuNom - (LdPPu + XTfoPu) * Id0PuNom;
    LambdaAQ0PuNom := - Ud0PuNom + (RaPPu + RTfoPu) * Id0PuNom - (LqPPu + XTfoPu) * Iq0PuNom;
    LambdaAirGap0PuNom := sqrt(LambdaAD0PuNom^2 + LambdaAQ0PuNom^2);

    // Saturation part
    Mds0PuNom := MdPPu / (1 + md*LambdaAirGap0PuNom^nd);
    Mqs0PuNom := MqPPu / (1 + mq*LambdaAirGap0PuNom^nq);
    Cos2Eta0 := LambdaAD0PuNom^2 / LambdaAirGap0PuNom^2;
    Sin2Eta0 := LambdaAQ0PuNom^2 / LambdaAirGap0PuNom^2;
    Mi0PuNom := Mds0PuNom*Cos2Eta0 + Mqs0PuNom*Sin2Eta0;
    MdSat0PPuNom := Mi0PuNom + MsalPu*Sin2Eta0;
    MqSat0PPuNom := Mi0PuNom - MsalPu*Cos2Eta0;

    // Algorithm stopping conditions
    deltaMdSat0PPuNom := abs(MdSat0PPuNom - MdSat0PPuNomSave);
    deltaMqSat0PPuNom := abs(MqSat0PPuNom - MqSat0PPuNomSave);
    nbIterations := nbIterations + 1;
    MdSat0PPuNomSave := MdSat0PPuNom;
    MqSat0PPuNomSave := MqSat0PPuNom;
    iterate := (deltaMdSat0PPuNom > 0.000001 or deltaMqSat0PPuNom > 0.000001) and nbIterations < 10;
  end while;

  MdPPuEfdNom := ((rTfoPu * MdSat0PPuNom) / (Uq0PuNom - (RaPPu + RTfoPu) * Iq0PuNom - (MdSat0PPuNom + (LdPPu + XTfoPu)) * Id0PuNom)) * rTfoPu * rTfoPu;

  annotation(preferredView = "text");
end MdPPuEfdNomCalculation;
