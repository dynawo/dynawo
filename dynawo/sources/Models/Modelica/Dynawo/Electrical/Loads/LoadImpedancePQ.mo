within Dynawo.Electrical.Loads;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model LoadImpedancePQ "Load model with impedance specified by PRef and QRef"

  extends BaseClasses.BaseLoad;

  parameter Types.VoltageModule URef "Reference value of phase-to-phase voltage";

  Complex Z "Internal impedance";

  Connectors.ImPin PRef "Active power consumption at reference voltage, the default binding can be changed when instantiating";
  Connectors.ImPin QRef "Reactive power consumption at reference voltage, the default binding can be changed when instantiating";

equation

  Z = 1/ComplexMath.conj(Complex(PRef.value,QRef.value)/URef^2);
  terminal.V = Z * terminal.i;

end LoadImpedancePQ;
