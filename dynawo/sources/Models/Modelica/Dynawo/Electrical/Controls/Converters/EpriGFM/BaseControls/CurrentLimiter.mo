within Dynawo.Electrical.Controls.Converters.EpriGFM.BaseControls;

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

model CurrentLimiter "Current limitation logic in EPRI Grid Forming model"
  extends Parameters.CurrentLimiter;
  extends Parameters.InitialIdqConv;
  
  parameter Real Ipmax_pPu = IMaxPu "Maximum active current in pu (base UNom, SNom)";
  parameter Real Iqmax_qPu = IMaxPu "Maximum reactive current in pu (base UNom, SNom)";
  
  Real Iqmax_pPu "Calculated reactive current in pu (base UNom, Snom)";
  Real Ipmax_qPu "Calculated active current in pu (base UNom, Snom)";
  
  // inputs
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start = IdConv0Pu) "Unlimited d-axis current in pu  (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start = IqConv0Pu) "Unlimited q-axis current in pu  (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // outputs
  Modelica.Blocks.Interfaces.RealOutput idConvRefLimPu(start = IdConv0Pu) "Limited d-axis current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 41}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefLimPu(start = IqConv0Pu) "Limited q-axis current in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

equation
  if not PQflag then
  //    ----- P Priority -----
    Iqmax_pPu = noEvent(if IMaxPu ^ 2 > idConvRefPu ^ 2 then sqrt(IMaxPu ^ 2 - idConvRefPu ^ 2) else 0);
    Ipmax_qPu = 0;
    if idConvRefPu > Ipmax_pPu then
      idConvRefLimPu = Ipmax_pPu;
    elseif idConvRefPu < (-Ipmax_pPu) then
      idConvRefLimPu = -Ipmax_pPu;
    else
      idConvRefLimPu = idConvRefPu;
    end if;
    if iqConvRefPu > Iqmax_pPu then
      iqConvRefLimPu = Iqmax_pPu;
    elseif iqConvRefPu < (-Iqmax_pPu) then
      iqConvRefLimPu = -Iqmax_pPu;
    else
      iqConvRefLimPu = iqConvRefPu;
    end if;
  else
  //    ----- Q Priority -----
    Ipmax_qPu = noEvent(if IMaxPu ^ 2 > iqConvRefPu ^ 2 then sqrt(IMaxPu ^ 2 - iqConvRefPu ^ 2) else 0);
    Iqmax_pPu = 0;
    if iqConvRefPu > Iqmax_qPu then
      iqConvRefLimPu = Iqmax_qPu;
    elseif iqConvRefPu < (-Iqmax_qPu) then
      iqConvRefLimPu = -Iqmax_qPu;
    else
      iqConvRefLimPu = iqConvRefPu;
    end if;
    if idConvRefPu > Ipmax_qPu then
      idConvRefLimPu = Ipmax_qPu;
    elseif idConvRefPu < (-Ipmax_qPu) then
      idConvRefLimPu = -Ipmax_qPu;
    else
      idConvRefLimPu = idConvRefPu;
    end if;
  end if;
  
end CurrentLimiter;
