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

function SatChar_func "Saturation characteristic in function form for initialization."
  
  input Real e1 "Exciter saturation point 1 in pu";
  input Real e2 "Exciter saturation point 2 in pu";
  input Real s1 "Saturation at e1 in pu";
  input Real s2 "Saturation at e2 in pu";
  
  input Real u;
  output Real y;

protected
  Real Asq = (e_l - e_h*sq) / (1 - sq);
  Real Bsq = if e_h - Asq > 0 then e_h * s_h / (e_h - Asq) ^ 2 else 0;

  Real e_h = max(max(e1, e2), 0);
  Real e_l = max(min(e1, e2), 0);
  Real s_h = max(max(s1, s2), 0);
  Real s_l = max(min(s1, s2), 0);
  Real sq = if ((e_h > 0) and (s_h > 0)) then sqrt(e_l*s_l/(e_h*s_h)) else 0;

algorithm
  if u  > Asq then 
    y := Bsq * (u - Asq) ^ 2;
  else
    y := 0.0;
  end if;

end SatChar_func;
