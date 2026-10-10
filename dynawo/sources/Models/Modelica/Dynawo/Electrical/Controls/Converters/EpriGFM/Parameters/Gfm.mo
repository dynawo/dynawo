within Dynawo.Electrical.Controls.Converters.EpriGFM.Parameters;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

record Gfm "GFM parameters"
  parameter Types.PerUnit DD "VSM damping factor, example value = 0.11" annotation(
  Dialog(tab = "GFM"));
  parameter Types.PerUnit DeltaOmegaMaxPu "Frequency deviation maximum in pu/s (base omegaNom), example value = 75(rad/s)/omegaNom" annotation(
Dialog(tab = "GFM"));
  parameter Types.PerUnit DeltaOmegaMinPu "Frequency deviation minimum in pu/s (base omegaNom), example value = -75(rad/s)/omegaNom" annotation(
  Dialog(tab = "GFM"));
  parameter Types.PerUnit K1 "Gain, set according to OmegaFlag" annotation(
  Dialog(tab = "GFM"));
  parameter Types.PerUnit K2 "Gain, set according to OmegaFlag" annotation(
  Dialog(tab = "GFM"));
  parameter Types.PerUnit K2Dvoc "Gain, set according to OmegaFlag" annotation(
  Dialog(tab = "GFM"));
  parameter Types.PerUnit KD "Gain of the active damping, Set according to OmegaFlag" annotation(
  Dialog(tab = "GFM"));
  parameter Types.PerUnit MF "VSM inertia constant, example value = 0.15" annotation(
  Dialog(tab = "GFM"));
  parameter Types.Time tF "Time constant in s, set according to OmegaFlag" annotation(
  Dialog(tab = "GFM"));
  parameter Types.Time tR "Transducer time constant in s, example value = 0.005" annotation(
  Dialog(tab = "GFM"));
  parameter Types.Time tV "Time constant in s, set according to OmegaFlag" annotation(
  Dialog(tab = "GFM"));

  annotation(
  preferredView = "text");
end Gfm;
