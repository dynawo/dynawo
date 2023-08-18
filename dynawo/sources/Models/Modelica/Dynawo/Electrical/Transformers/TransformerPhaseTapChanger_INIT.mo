within Dynawo.Electrical.Transformers;

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

model TransformerPhaseTapChanger_INIT "Initialization model for TransformerPhaseTapChanger"
  extends TransformerFixedRatioAndPhase_INIT(AlphaTfo0 = AlphaTfoMin + (AlphaTfoMax - AlphaTfoMin) * (Tap0 / (NbTap - 1)));

  parameter Integer NbTap "Number of taps";
  parameter Types.Angle AlphaTfoMin "Minimum phase shift in rad";
  parameter Types.Angle AlphaTfoMax "Maximum phase shift in rad";

  parameter Integer Tap0 "Start value of transformer tap";

end TransformerPhaseTapChanger_INIT;
