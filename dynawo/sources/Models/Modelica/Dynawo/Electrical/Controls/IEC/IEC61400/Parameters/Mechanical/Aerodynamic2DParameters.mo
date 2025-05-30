within Dynawo.Electrical.Controls.IEC.IEC61400.Parameters.Mechanical;

/*
* Copyright (c) 2025, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

record Aerodynamic2DParameters
  parameter Types.ActivePowerPu DPOmegaThetaPu "Aerodynamic power partial derivative, pitch dependent term with respect to changes in Wind Turbine Rotor speed in pu (base SNom/omegaNom), example value = 0.028" annotation(Dialog(tab = "Aerodynamic"));
  parameter Types.ActivePowerPu DPOmega0Pu "Aerodynamic power partial derivative, constant term with respect to changes in Wind Turbine Rotor speed in pu (base SNom/omegaNom), example value = 0.48" annotation(Dialog(tab = "Aerodynamic"));
  parameter Types.ActivePowerPu DPThetaPu "Aerodynamic power partial derivative with respect to changes in pitch angle in pu (base SNom/degrees), example value = -0.03" annotation(Dialog(tab = "Aerodynamic"));
  parameter Types.ActivePowerPu PAvailPu "Available power in pu (base SNom), example value = active power setpoint" annotation(Dialog(tab = "Operating point"));
  parameter Types.PerUnit Theta0 "Pitch angle of the wind turbine in degrees, if not derated, example value = 0.0" annotation(Dialog(tab = "Aerodynamic"));

  annotation(
    preferredView = "text");
end Aerodynamic2DParameters;
