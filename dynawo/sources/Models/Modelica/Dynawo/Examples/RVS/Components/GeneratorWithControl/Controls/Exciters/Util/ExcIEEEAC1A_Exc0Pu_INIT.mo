within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

function ExcIEEEAC1A_Exc0Pu_INIT

  input Real Kc;
  input Real Efd0Pu;

  output Real Exc0Pu;
  
protected
    Real In_a;
    Real In_b;
    Real In_c;
    Real In;
    Real Fex;
    
algorithm
  In_a := Kc/(1+0.577*Kc);
  In_b := Kc*sqrt(0.75/(1+Kc*Kc));
  In_c := Kc*1.732/(1+1.732*Kc);
  
  if In_a <= 0.433 then
    In := In_a;
  else
    if In_c >=0.75 then
      In := In_c;
    else 
      In := In_b;
    end if;
  end if;
  
  if In <= 0 then
    Fex := 0;
  elseif In <= 0.433 then
    Fex := 1 - 0.577 * In;
  elseif In < 0.75 then
    Fex := (0.75 - In ^ 2) ^ 0.5;
  elseif In <= 1 then
    Fex := 1.732 * (1-In);
  else
    Fex := 0;
  end if;
  
  Exc0Pu :=  Efd0Pu / Fex;
  
end ExcIEEEAC1A_Exc0Pu_INIT;
