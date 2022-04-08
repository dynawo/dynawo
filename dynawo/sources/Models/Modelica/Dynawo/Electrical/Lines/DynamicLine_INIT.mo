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

model DynamicLine_INIT "Initialization for dynamic line"
  import Dynawo.Types;
  extends AdditionalIcons.Init;


  public

  parameter Types.PerUnit RPu "Resistance in pu Current through the equivalent impedance G+jB on side 1 in pu (base SnRef, UNom) ";
  parameter Types.PerUnit LPu "Reactance in pu (base SnRef,UNom)";
  parameter Types.PerUnit GPu "Half-conductance in pu (base SnRef,UNom)";
  parameter Types.PerUnit CPu "Half-susceptance in pu (base SnRef,UNom)";


  parameter Types.VoltageModulePu U10Pu "Start value of voltage amplitude at line terminal 1 in pu (base UNom)";
  parameter Types.Angle UPhase10 "Start value of voltage angle at line terminal 1 (in rad)";
  parameter Types.VoltageModulePu U20Pu   "Start value of voltage amplitude at line terminal 2 in pu (base UNom)";
  parameter Types.Angle UPhase20 "Start value of voltage angle at line terminal 2 (in rad)";
  parameter Types.AngularVelocityPu omega0Pu;


  Types.ComplexVoltagePu s10Pu "Start value of the apparent power on side 1 base UNom ";
  Types.ComplexVoltagePu s20Pu "Start value of the apparent power on side 2 base Unom ";
  Types.ComplexVoltagePu u10Pu "Start value of the voltage on side 1 base UNom ";
  Types.ComplexVoltagePu u20Pu "Start value of the voltage on side 2 base Unom ";
  Types.ComplexCurrentPu i10Pu "Start value of the current on side 1 in pu (base UNom, SnRef)(receptor convention) ";
  Types.ComplexCurrentPu i20Pu "Start value of the current on side 2 in pu (base UNom, SnRef) ";
  Types.ComplexCurrentPu iRL0Pu "Start value of the current module in the R,L part of the line in pu (base UNom, SnRef)(receptor convention)";
  Types.ComplexCurrentPu iGC10Pu "Start value of the current module in the G,C part of the line on side 1 in pu (base UNom, SnRef) (receptor convention)" ;
  Types.ComplexCurrentPu iGC20Pu  "Start value of the current module in the G,C part of the line on side 2 in pu (base UNom, SnRef) (receptor convention)" ;


equation

  u10Pu = ComplexMath.fromPolar(U10Pu, UPhase10);
  u20Pu = ComplexMath.fromPolar(U20Pu, UPhase20);
  s10Pu = u10Pu*ComplexMath.conj(i10Pu);
  s20Pu = u20Pu*ComplexMath.conj(i20Pu);
  i10Pu = iGC10Pu+iRL0Pu;
  i20Pu = iGC20Pu-iRL0Pu;
  iGC10Pu = Complex((GPu*u10Pu.re-omega0Pu*CPu*u10Pu.im ), (GPu*u10Pu.im+omega0Pu*CPu*u10Pu.re));
  iRL0Pu = Complex((omega0Pu*LPu*RPu/((omega0Pu*LPu)^2+RPu^2)*((u10Pu.re-u20Pu.re)/(omega0Pu*LPu) + (u10Pu.im-u20Pu.im)/RPu) ), -(omega0Pu*LPu*RPu/((omega0Pu*LPu)^2+RPu^2)*((u10Pu.re-u20Pu.re)/RPu-(u10Pu.im-u20Pu.im)/(omega0Pu*LPu)) ));
  iGC20Pu=Complex((GPu*u20Pu.re-omega0Pu*CPu*u20Pu.im ), (GPu*u20Pu.im+omega0Pu*CPu*u20Pu.re ));

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end DynamicLine_INIT;
