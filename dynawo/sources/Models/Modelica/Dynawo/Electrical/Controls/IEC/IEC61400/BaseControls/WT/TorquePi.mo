within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model TorquePi "Sub module for torque control inside active power control module for type 3 wind turbines (IEC N°61400-27-1:2020)"

  extends Dynawo.Electrical.Wind.IEC.Parameters.PControlWT3;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialPGrid;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialIGs;
  extends Dynawo.Electrical.Wind.IEC.Parameters.XEqv_;
  extends Dynawo.Electrical.Wind.IEC.Parameters.InitialUGrid;
  
  // inputs
  Modelica.Blocks.Interfaces.RealInput omegaErrPu(start = 0) "Speed error in pu (base omegaRef)" annotation(
    Placement(visible = true, transformation(origin = {-410, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-426, 60}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput tauEMaxPu(start = 1) "Maximum electrical torque in pu (base SNom/omegaRef)" annotation(
    Placement(visible = true, transformation(origin = {-410, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-426, 150}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uTcHookPu(start = 0) "Optional voltage input (TC = turbine control) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-410, -212}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-426, -200}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWtcPu(start = U0Pu) "Measured (=filtered) current for Wind Turbine Control (WTC) in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-410, -168}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-426, -100}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));
  
  // outputs
  Modelica.Blocks.Interfaces.RealOutput tauOutPu(start=integratorKIpKPp.Y0) "Output torque of torque PI controller in pu (base SNom/omegaRef)" annotation(
    Placement(visible = true, transformation(origin = {220, 136}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {236, -24}, extent = {{-25, -25}, {25, 25}}, rotation = 0)));

  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {130, 176}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Math.Add addKIpKPp(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-76, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addTauOut annotation(
    Placement(visible = true, transformation(origin = {104, 136}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addUTcHook annotation(
    Placement(visible = true, transformation(origin = {-340, -218}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.And andResetKIpKPp(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-130, -120}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = - 0.001) annotation(
    Placement(visible = true, transformation(origin = {105, 169}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constDTauMax(k = DTauMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-189, 83}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constDTauUvrtMax(k = DTauUvrtMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-310, -138}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constInf(k = Modelica.Constants.inf) annotation(
    Placement(visible = true, transformation(origin = {-313, -117}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constInfNeg(k = -1 * Modelica.Constants.inf) annotation(
    Placement(visible = true, transformation(origin = {-247, -193}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant constMPUvrt(k = MPUvrt) annotation(
    Placement(visible = true, transformation(origin = {-205, -143}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constOne(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-373, -229}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constTauEMin(k = TauEMinPu - 0.001) annotation(
    Placement(visible = true, transformation(origin = {143, 117}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constUDvsPu(k = UDvsPu) annotation(
    Placement(visible = true, transformation(origin = {-361, 13}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constUpDipPu(k = UpDipPu) annotation(
    Placement(visible = true, transformation(origin = {-361, 59}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constZero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-197, 129}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.DelayFlag delayFlag(FI0 = false, FO0 = 0, tD = tDvs, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-350, -56}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze freeze(T = tS, UseFreeze = true, UseRateLim = false, y(start = TauEMinPu)) annotation(
    Placement(visible = true, transformation(origin = {-108, -210}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKPp(k = KPp) annotation(
    Placement(visible = true, transformation(origin = {56, 142}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainTauUscale(k = TauUscalePu) annotation(
    Placement(visible = true, transformation(origin = {-346, -168}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterEqual greaterEqual annotation(
    Placement(visible = true, transformation(origin = {-66, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.IntegerToReal integerToReal annotation(
    Placement(visible = true, transformation(origin = {-320, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.IntegratorVariableLimitsContinuousSetFreeze integratorDTauMax(LimitMax0 = TauEMax0Pu, LimitMin0 = TauEMinPu,UseFreeze = false, UseReset = true, UseSet = true, Y0 = TauEMax0Pu) annotation(
    Placement(visible = true, transformation(origin = {-152, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.IntegratorVariableLimitsContinuousSetFreeze integratorKIpKPp(K = if KPp > 1e-6 then KIp / KPp else 1 / Modelica.Constants.eps, LimitMax0 = TauEMax0Pu, LimitMin0 = TauEMinPu, UseFreeze = true, UseReset = true, UseSet = true, Y0 = Torque0Type3bPu) annotation(
    Placement(visible = true, transformation(origin = {0, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less lessUDvs annotation(
    Placement(visible = true, transformation(origin = {-338, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Less lessUPdip annotation(
    Placement(visible = true, transformation(origin = {-338, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.VarLimLimDetection limitTauOut annotation(
    Placement(visible = true, transformation(origin = {166, 136}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minDTauMaxTauOut annotation(
    Placement(visible = true, transformation(origin = {62, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.MinMax minResetvalue(nu = 3) annotation(
    Placement(visible = true, transformation(origin = {-286, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or orKIpKPp(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-63, 3}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.MathBoolean.Or orLimDetect(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {181, 115}, extent = {{-5, -5}, {5, 5}}, rotation = -90)));
  Modelica.Blocks.MathBoolean.Or OrReset(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {-243, -15}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze ratelimResetvalue(T = tS * 1e-3, UseRateLim = true, Y0 = ratelimResetvalue0Type3b) annotation(
    Placement(visible = true, transformation(origin = {-226, -176}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-262, -130}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchKIpKPp annotation(
    Placement(visible = true, transformation(origin = {-44, -60}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switchOmegaErr annotation(
    Placement(visible = true, transformation(origin = {-164, 142}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression TauEMin1(y = constTauEMin.y) annotation(
    Placement(visible = true, transformation(origin = {-180, 62}, extent = {{-6, -10}, {6, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression TauEMin2(y = constTauEMin.y) annotation(
    Placement(visible = true, transformation(origin = {-33, -88}, extent = {{-7, -10}, {7, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.RealExpression zero2(y = constZero.y) annotation(
    Placement(visible = true, transformation(origin = {-72, -72}, extent = {{-6, -10}, {6, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterZero(threshold = 0.1)  annotation(
    Placement(visible = true, transformation(origin = {-288, -56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(gainKPp.y, addTauOut.u1) annotation(
    Line(points = {{67, 142}, {92, 142}}, color = {0, 0, 127}));
  connect(minDTauMaxTauOut.y, addTauOut.u2) annotation(
    Line(points = {{73, 78}, {84, 78}, {84, 130}, {92, 130}}, color = {0, 0, 127}));
  connect(addTauOut.y, limitTauOut.u) annotation(
    Line(points = {{115, 136}, {154, 136}}, color = {0, 0, 127}));
  connect(limitTauOut.y, tauOutPu) annotation(
    Line(points = {{177, 136}, {220, 136}}, color = {0, 0, 127}));
  connect(limitTauOut.fMax, orLimDetect.u[1]) annotation(
    Line(points = {{177, 142}, {180, 142}, {180, 120}}, color = {255, 0, 255}));
  connect(limitTauOut.fMin, orLimDetect.u[2]) annotation(
    Line(points = {{177, 130}, {180, 130}, {180, 120}}, color = {255, 0, 255}));
  connect(constInfNeg.y, ratelimResetvalue.dyMin) annotation(
    Line(points = {{-241.5, -193}, {-238, -193}, {-238, -182}}, color = {0, 0, 127}));
  connect(constMPUvrt.y, andResetKIpKPp.u[1]) annotation(
    Line(points = {{-197.3, -143}, {-150.9, -143}, {-150.9, -120}, {-136.6, -120}}, color = {255, 0, 255}));
  connect(OrReset.y, andResetKIpKPp.u[2]) annotation(
    Line(points = {{-235, -15}, {-215.95, -15}, {-215.95, -120}, {-136, -120}}, color = {255, 0, 255}));
  connect(lessUPdip.y, OrReset.u[1]) annotation(
    Line(points = {{-327, 78}, {-285, 78}, {-285, -15}, {-250, -15}}, color = {255, 0, 255}));
  connect(lessUPdip.y, orKIpKPp.u[1]) annotation(
    Line(points = {{-327, 78}, {-285, 78}, {-285, 3}, {-70, 3}}, color = {255, 0, 255}));
  connect(constZero.y, switchOmegaErr.u1) annotation(
    Line(points = {{-189.3, 129}, {-175.3, 129}, {-175.3, 133}}, color = {0, 0, 127}));
  connect(omegaErrPu, switchOmegaErr.u3) annotation(
    Line(points = {{-410, 150}, {-176, 150}}, color = {0, 0, 127}));
  connect(switchOmegaErr.y, gainKPp.u) annotation(
    Line(points = {{-153, 142}, {43, 142}}, color = {0, 0, 127}));
  connect(OrReset.y, switchOmegaErr.u2) annotation(
    Line(points = {{-235, -15}, {-216.95, -15}, {-216.95, 141}, {-176.95, 141}}, color = {255, 0, 255}));
  connect(orKIpKPp.y, switchKIpKPp.u2) annotation(
    Line(points = {{-55, 3}, {-44.95, 3}, {-44.95, -60}, {-56, -60}}, color = {255, 0, 255}));
  connect(addKIpKPp.y, switchKIpKPp.u3) annotation(
    Line(points = {{-65, -52}, {-56, -52}}, color = {0, 0, 127}));
  connect(zero2.y, switchKIpKPp.u1) annotation(
    Line(points = {{-65.4, -72}, {-61.5, -72}, {-61.5, -68}, {-56.4, -68}}, color = {0, 0, 127}));
  connect(constTauEMin.y, limitTauOut.yMin) annotation(
    Line(points = {{150.7, 117}, {153.7, 117}, {153.7, 128}}, color = {0, 0, 127}));
  connect(minResetvalue.yMin, ratelimResetvalue.u) annotation(
    Line(points = {{-275, -186}, {-265, -186}, {-265, -176}, {-238, -176}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(constUpDipPu.y, lessUPdip.u2) annotation(
    Line(points = {{-353.3, 59}, {-350.3, 59}, {-350.3, 70}}, color = {0, 0, 127}));
  connect(constUDvsPu.y, lessUDvs.u2) annotation(
    Line(points = {{-353.3, 13}, {-350.3, 13}, {-350.3, 24}}, color = {0, 0, 127}));
  connect(uWtcPu, lessUPdip.u1) annotation(
    Line(points = {{-410, -168}, {-382, -168}, {-382, 78}, {-350, 78}}, color = {0, 0, 127}));
  connect(uWtcPu, lessUDvs.u1) annotation(
    Line(points = {{-410, -168}, {-382, -168}, {-382, 32}, {-350, 32}}, color = {0, 0, 127}));
  connect(lessUDvs.y, delayFlag.fI) annotation(
    Line(points = {{-327, 32}, {-313, 32}, {-313, -20}, {-373, -20}, {-373, -56}, {-364, -56}}, color = {255, 0, 255}));
  connect(delayFlag.fO, integerToReal.u) annotation(
    Line(points = {{-336.8, -56}, {-331.8, -56}}, color = {255, 127, 0}));
  connect(OrReset.y, switch.u2) annotation(
    Line(points = {{-235, -15}, {-216.95, -15}, {-216.95, -73}, {-264.95, -73}, {-264.95, -130}, {-274, -130}}, color = {255, 0, 255}));
  connect(constInf.y, switch.u3) annotation(
    Line(points = {{-307.5, -117}, {-291, -117}, {-291, -122}, {-274, -122}}, color = {0, 0, 127}));
  connect(constDTauUvrtMax.y, switch.u1) annotation(
    Line(points = {{-301.2, -138}, {-274.2, -138}}, color = {0, 0, 127}));
  connect(switch.y, ratelimResetvalue.dyMax) annotation(
    Line(points = {{-251, -130}, {-247, -130}, {-247, -169}, {-238, -169}}, color = {0, 0, 127}));
  connect(uWtcPu, gainTauUscale.u) annotation(
    Line(points = {{-410, -168}, {-358, -168}}, color = {0, 0, 127}));
  connect(constOne.y, addUTcHook.u2) annotation(
    Line(points = {{-365.3, -229}, {-360.6, -229}, {-360.6, -224}, {-352.3, -224}}, color = {0, 0, 127}));
  connect(uTcHookPu, addUTcHook.u1) annotation(
    Line(points = {{-410, -212}, {-352, -212}}, color = {0, 0, 127}));
  connect(addKIpKPp.u1, limitTauOut.y) annotation(
    Line(points = {{-88, -46}, {-102, -46}, {-102, -112}, {200, -112}, {200, 136}, {178, 136}}, color = {0, 0, 127}));
  connect(constDTauMax.y, integratorDTauMax.u) annotation(
    Line(points = {{-182, 84}, {-164, 84}}, color = {0, 0, 127}));
  connect(orLimDetect.y, integratorKIpKPp.freeze) annotation(
    Line(points = {{182, 110}, {182, -90}, {-6, -90}, {-6, -72}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(switchKIpKPp.y, integratorKIpKPp.u) annotation(
    Line(points = {{-32, -60}, {-12, -60}}, color = {0, 0, 127}));
  connect(greaterEqual.y, orKIpKPp.u[2]) annotation(
    Line(points = {{-55, 42}, {-50, 42}, {-50, 24}, {-94, 24}, {-94, 4}, {-70, 4}}, color = {255, 0, 255}));
  connect(andResetKIpKPp.y, freeze.freeze) annotation(
    Line(points = {{-123.1, -120}, {-102.1, -120}, {-102.1, -222}}, color = {255, 0, 255}, pattern = LinePattern.Dash));
  connect(tauEMaxPu, integratorDTauMax.limitMax) annotation(
    Line(points = {{-410, 180}, {-136, 180}, {-136, 108}, {-174, 108}, {-174, 92}, {-164, 92}}, color = {0, 0, 127}));
  connect(TauEMin1.y, integratorDTauMax.limitMin) annotation(
    Line(points = {{-174, 62}, {-170, 62}, {-170, 76}, {-164, 76}}, color = {0, 0, 127}));
  connect(integratorDTauMax.y, minDTauMaxTauOut.u1) annotation(
    Line(points = {{-140, 84}, {50, 84}}, color = {0, 0, 127}));
  connect(integratorKIpKPp.y, minDTauMaxTauOut.u2) annotation(
    Line(points = {{11, -60}, {16, -60}, {16, 72}, {50, 72}}, color = {0, 0, 127}));
  connect(TauEMin2.y, integratorKIpKPp.limitMin) annotation(
    Line(points = {{-25, -88}, {-22, -88}, {-22, -68}, {-12, -68}}, color = {0, 0, 127}));
  connect(integratorKIpKPp.y, addKIpKPp.u2) annotation(
    Line(points = {{11, -60}, {16, -60}, {16, -102}, {-94, -102}, {-94, -58}, {-88, -58}}, color = {0, 0, 127}));
  connect(integratorKIpKPp.y, freeze.u) annotation(
    Line(points = {{11, -60}, {16, -60}, {16, -210}, {-96, -210}}, color = {0, 0, 127}));
  connect(gainTauUscale.y, minResetvalue.u[1]) annotation(
    Line(points = {{-334, -168}, {-312, -168}, {-312, -180}, {-296, -180}}, color = {0, 0, 127}));
  connect(addUTcHook.y, minResetvalue.u[2]) annotation(
    Line(points = {{-328, -218}, {-314, -218}, {-314, -180}, {-296, -180}}, color = {0, 0, 127}));
  connect(freeze.y, minResetvalue.u[3]) annotation(
    Line(points = {{-118, -210}, {-304, -210}, {-304, -180}, {-296, -180}}, color = {0, 0, 127}));
  connect(integratorKIpKPp.limitMax, tauEMaxPu) annotation(
    Line(points = {{-12, -52}, {-30, -52}, {-30, 180}, {-410, 180}}, color = {0, 0, 127}));
  connect(greaterEqual.u1, integratorKIpKPp.y) annotation(
    Line(points = {{-78, 42}, {-88, 42}, {-88, 72}, {16, 72}, {16, -60}, {11, -60}}, color = {0, 0, 127}));
  connect(OrReset.y, integratorDTauMax.reset) annotation(
    Line(points = {{-234, -14}, {-146, -14}, {-146, 72}}, color = {255, 0, 255}));
  connect(andResetKIpKPp.y, integratorKIpKPp.reset) annotation(
    Line(points = {{-124, -120}, {6, -120}, {6, -72}}, color = {255, 0, 255}));
  connect(ratelimResetvalue.y, integratorKIpKPp.set) annotation(
    Line(points = {{-214, -176}, {12, -176}, {12, -34}, {6, -34}, {6, -48}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(ratelimResetvalue.y, integratorDTauMax.set) annotation(
    Line(points = {{-214, -176}, {-140, -176}, {-140, 102}, {-146, 102}, {-146, 96}}, color = {0, 0, 127}, pattern = LinePattern.Dot));
  connect(integratorDTauMax.y, greaterEqual.u2) annotation(
    Line(points = {{-140, 84}, {-106, 84}, {-106, 34}, {-78, 34}}, color = {0, 0, 127}));
  connect(add.u1, tauEMaxPu) annotation(
    Line(points = {{123, 180}, {-410, 180}}, color = {0, 0, 127}));
  connect(add.y, limitTauOut.yMax) annotation(
    Line(points = {{137, 176}, {142, 176}, {142, 144}, {154, 144}}, color = {0, 0, 127}));
  connect(constant1.y, add.u2) annotation(
    Line(points = {{113, 169}, {122, 169}, {122, 172}}, color = {0, 0, 127}));
  connect(integerToReal.y, greaterZero.u) annotation(
    Line(points = {{-308, -56}, {-300, -56}}, color = {0, 0, 127}));
  connect(greaterZero.y, OrReset.u[2]) annotation(
    Line(points = {{-277, -56}, {-262, -56}, {-262, -14}, {-250, -14}}, color = {255, 0, 255}));
  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-400, -250}, {210, 200}})),
    Icon(coordinateSystem(extent = {{-400, -250}, {210, 200}}), graphics = {Rectangle(origin = {-95, -26}, extent = {{-304, 225}, {304, -225}}), Text(origin = {-76, -14}, extent = {{-146, 46}, {146, -46}}, textString = "torque PI")}),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002));
end TorquePi;
