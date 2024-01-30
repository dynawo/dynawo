within Dynawo.Examples.KundurTwoArea.Grid;

model LoadFlow
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
  extends Dynawo.Examples.KundurTwoArea.Grid.BaseClasses.NetworkWithLoadsGenerators(
  P0PuGen01 = 7.0,
  Q0PuGen01 = 1.85,
  U0PuGen01 = 1.03,
  UAngle0Gen01 = 20.2 /180*Modelica.Constants.pi,
  P0PuGen02 = 7.0,
  Q0PuGen02 = 2.35,
  U0PuGen02 = 1.01,
  UAngle0Gen02 = 10.5 /180*Modelica.Constants.pi,
  P0PuGen03 = 7.19,
  Q0PuGen03 = 1.76,
  U0PuGen03 = 1.03,
  UAngle0Gen03 = -6.8 /180*Modelica.Constants.pi,
  P0PuGen04 = 7.0,
  Q0PuGen04 = 2.02,
  U0PuGen04 = 1.01,
  UAngle0Gen04 = -17.6 /180*Modelica.Constants.pi
  );
  extends Icons.Example;
  
equation
  
end LoadFlow;
