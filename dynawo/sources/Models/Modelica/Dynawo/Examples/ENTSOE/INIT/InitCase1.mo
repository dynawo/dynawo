within Dynawo.Examples.ENTSOE.INIT;

/*
* Copyright (c) 2021, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model InitCase1 "Synchronous generator starting at 0 MW and 0 Mvar - Start values and parameters calculation from internal parameters"
  import Dynawo;

  Dynawo.Electrical.Machines.OmegaRef.GeneratorSynchronousInt_INIT generatorSynchronousInt_INIT(
  DPu = 0,
  ExcitationPu = Dynawo.Electrical.Machines.OmegaRef.BaseClasses.GeneratorSynchronousParameters.ExcitationPuType.NoLoad,
  H = 4,
  LDPu = 0.19063,
  LQ1Pu = 0.51659,
  LQ2Pu = 0.24243,
  LdPu = 0.15,
  LfPu = 0.23732,
  LqPu = 0.15,
  MdPu = 1.85,
  MdPuEfd = 0.74046,
  MqPu = 1.65,
  MrcPu = 0,
  P0Pu = 0,
  PNomAlt = 475,
  PNomTurb = 475,
  Q0Pu = 0,
  RDPu = 0.02933,
  RQ1Pu = 0.0035,
  RQ2Pu = 0.02227,
  RTfPu = 0,
  RaPu = 0,
  RfPu = 0.00134,
  SNom = 500,
  SnTfo = 500,
  U0Pu = 1,
  UBaseHV = 400,
  UBaseLV = 21,
  UNom = 21,
  UNomHV = 400,
  UNomLV = 21,
  UPhase0 = 0,
  XTfPu = 0,
  md = 0,
  mq = 0,
  nd = 0,
  nq = 0) annotation(
    Placement(visible = true, transformation(origin = {0, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  annotation(preferredView = "text");
end InitCase1;
