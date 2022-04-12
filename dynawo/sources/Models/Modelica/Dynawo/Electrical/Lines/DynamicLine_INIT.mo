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

model DynamicLine_INIT "Initialization for dynamic PI line"
  import Dynawo.Types;

  extends AdditionalIcons.Init;

  parameter Types.PerUnit RPu=0.016854 "Resistance in pu  (base SnRef, UNom) ";
  parameter Types.PerUnit LPu=0.03370 "Reactance in pu (base SnRef, UNom)";
  parameter Types.PerUnit GPu=0 "Half-capacitance in pu (base SnRef, UNom)";
  parameter Types.PerUnit CPu=0.0000375 "Half-susceptance in pu (base SnRef, UNom)";
  parameter Types.ComplexVoltagePu u10Pu=Complex(0.715983, -0.0570824) "Start value of the complex voltage on side 1 base UNom ";
  parameter Types.ComplexVoltagePu u20Pu=Complex(0.886712, 0.32476) "Start value of the complex voltage on side 2 base Unom ";


  Types.ComplexCurrentPu i10Pu "Start value of the complex current on side 1 in pu (base SnRef, UNom)(receptor convention) ";
  Types.ComplexCurrentPu i20Pu "Start value of the complex current on side 2 in pu (base SnRef, UNom)(receptor convention)";
  Types.ComplexCurrentPu iRL0Pu "Start value of the complex current in the R,L part of the line in pu (base SnRef, UNom)(receptor convention)";
  Types.ComplexCurrentPu iGC10Pu "Start value of the complex current in the G,C part of the line on side 1 in pu (base SnRef, UNom) (receptor convention)" ;
  Types.ComplexCurrentPu iGC20Pu  "Start value of the complex current in the G,C part of the line on side 2 in pu (base SnRef, UNom) (receptor convention)" ;

equation
  i10Pu = iGC10Pu + iRL0Pu;
  i20Pu = iGC20Pu- iRL0Pu;
  iGC10Pu = Complex(GPu, CPu) * u10Pu;
  u10Pu - u20Pu = Complex(RPu, LPu) * iRL0Pu;
  iGC20Pu = Complex(GPu, CPu) * u20Pu;

annotation(
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end DynamicLine_INIT;
