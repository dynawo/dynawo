within Dynawo.Electrical.Wind.WECC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

partial model BaseWT4A "Base model for WECC Wind Turbine 4A"
  import Modelica;
  import Dynawo;

  extends Dynawo.Electrical.Wind.WECC.BaseClasses.BaseWT4;
  extends Dynawo.Electrical.Controls.WECC.Parameters.Params_DriveTrain;

  Dynawo.Electrical.Controls.WECC.DriveTrainPmConstant driveTrainPmConstrant(Dshaft = Dshaft, Hg = Hg, Ht = Ht, Kshaft = Kshaft, PInj0Pu = PInj0Pu, PePu(start = PInj0Pu)) annotation(
    Placement(visible = true, transformation(origin = {17.1733, -32.936}, extent = {{-7.38218, -5.33158}, {7.38218, 5.33158}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRef(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-21, -32}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));

equation
  connect(OmegaRef.y, driveTrainPmConstrant.omegaRefPu) annotation(
    Line(points = {{-17, -32}, {10, -32}}, color = {0, 0, 127}));
  connect(driveTrainPmConstrant.omegaGPu, wecc_reec.omegaGPu) annotation(
    Line(points = {{22, -26}, {22, -24}, {-26, -24}, {-26, -15}}, color = {0, 0, 127}));
  connect(driveTrainPmConstrant.PePu, injector.PInjPuSn) annotation(
    Line(points = {{27, -32}, {81.5, -32}, {81.5, -8}, {75, -8}}, color = {0, 0, 127}));
  annotation(
    Icon);
end BaseWT4A;
