within Dynawo.Electrical.HVDC.BaseClasses;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

  partial model BaseVoltageRegulation "Base dynamic model for Hvdc voltage regulation"
    extends BaseClasses.BaseVoltageRegulationDangling;

    input Boolean modeU2(start = modeU20) "Boolean assessing the mode of the control of converter 2: true if U mode (here a proportional Q regulation), false if Q mode (fixed Q)";
    input Types.ReactivePowerPu Q2RefPu(start = Q2Ref0Pu) "Reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 2";

    parameter Boolean modeU20 "Start value of the boolean assessing the mode of the control of converter 2";
    parameter Types.ReactivePowerPu Q2Ref0Pu "Start value of reactive power regulation set point in pu (base SnRef) (receptor convention) at terminal 2";

    annotation(preferredView = "text");
  end BaseVoltageRegulation;
