within Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters;

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

model ExcIEEEAC1A "As defined in IEEE 1981 Excitation System Models for Power System Stability Studies"
  import Modelica;
  import Modelica.Blocks;
  import Dynawo;

  parameter Types.PerUnit Ka "AVR Gain";
  parameter Types.PerUnit Kf "Rate Feedback Gain";
  parameter Types.PerUnit Kc "Rectifier load factor";
  parameter Types.PerUnit Kd "Exciter Demagnetizing Factor";
  parameter Types.PerUnit Ke "Exciter Field Gain";
  parameter Types.PerUnit Tr "Voltage Input Time Constant";
  parameter Types.PerUnit Tb "AVR Lead-Lag Numerator Time Constant";
  parameter Types.PerUnit Tc "AVR Lead-Lag Denominator Time Constant";
  parameter Types.PerUnit Ta "AVR Time Constant";
  parameter Types.PerUnit Te "Exciter Time Constant";
  parameter Types.PerUnit Tf "Rate Feedback Time Constant";
  parameter Types.PerUnit VrMax "Max. AVR Output";
  parameter Types.PerUnit VrMin "Min. AVR Output";
  parameter Types.PerUnit e1 "Exciter saturation point 1 in pu";
  parameter Types.PerUnit e2 "Exciter saturation point 2 in pu";
  parameter Types.PerUnit s1 "Saturation at e1 in pu";
  parameter Types.PerUnit s2 "Saturation at e2 in pu";

  parameter Types.VoltageModulePu UStator0Pu "Initial value of generator stator voltage";
  parameter Types.VoltageModulePu URef0Pu(fixed=false) "Initial value of voltage reference in pu";
  parameter Types.VoltageModulePu Efd0Pu "Initial value of excitation voltage in pu";
  parameter Types.VoltageModulePu IRotor0Pu "Initial value of generator field current in pu (non-reciprocal)";

  Modelica.Blocks.Interfaces.RealInput UStatorPu(start = UStator0Pu) "Generator stator voltage in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-230, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-230, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UpssPu(start = 0) "PSS voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-230, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-230, -80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UoelPu(start = 0) "OEL voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-230, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, 160}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput UuelPu(start = 0) "UEL voltage correction in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-230, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-84, 160}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput IRotorPu(start = IRotor0Pu) "Generator field current in pu (non-reciprocal)" annotation(
    Placement(visible = true, transformation(origin = {230, -100}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {230, -80}, extent = {{20, -20}, {-20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput EfdPu(start = Efd0Pu) "Excitation voltage in pu" annotation(
    Placement(visible = true, transformation(origin = {220, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {220, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Continuous.FirstOrder UGenPuDelay(T = Tr, k = 1, y_start = UStator0Pu) annotation(
    Placement(visible = true, transformation(origin = {-178, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction AVRLeadLag(a = {Tb, 1}, b = {Tc, 1}, x_start = {Ufe0Pu / Ka}, y_start = Ufe0Pu / Ka) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add dUr(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction RateFeedback(a = {Tf, 1}, b = {Kf, 0}, initType = Modelica.Blocks.Types.Init.InitialState, x_start = {Ufe0Pu}, y_start = Ufe0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain Demagnetization(k = Kd)  annotation(
    Placement(visible = true, transformation(origin = {10, -100}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 UfePu annotation(
    Placement(visible = true, transformation(origin = {-40, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain FieldGain(k = Ke)  annotation(
    Placement(visible = true, transformation(origin = {10, -20}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division In annotation(
    Placement(visible = true, transformation(origin = {162, -44}, extent = {{-10, 10}, {10, -10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain ExciterOutputDrop(k = Kc)  annotation(
    Placement(visible = true, transformation(origin = {168, -84}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Product EfdPuProd annotation(
    Placement(visible = true, transformation(origin = {180, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.SatChar SatChar(e1 = e1, e2 = e2, s1 = s1, s2 = s2)  annotation(
    Placement(visible = true, transformation(origin = {10, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.RectReg rectReg annotation(
    Placement(visible = true, transformation(origin = {162, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Continuous.TransferFunction Exciter(a = {Te, 0}, b = {1}, initType = Modelica.Blocks.Types.Init.InitialState, x_start = {Exc0Pu}, y_start = Exc0Pu) annotation(
    Placement(visible = true, transformation(origin = {80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter ExciterLim(limitsAtInit = true, strict = false, uMax = 999, uMin = 0)  annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 dEfdPu(k3 = -1) annotation(
    Placement(visible = true, transformation(origin = {-90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 dUGenPU(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {-136, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-136, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = 1, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {162, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Max max annotation(
    Placement(visible = true, transformation(origin = {138, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = 1e-6)  annotation(
    Placement(visible = true, transformation(origin = {45, -85}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant URefPuConst(k = URef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-220, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {85, -83}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = -1000) annotation(
    Placement(visible = true, transformation(origin = {103, -83}, extent = {{5, -5}, {-5, 5}}, rotation = 180)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {117, -93}, extent = {{-5, -5}, {5, 5}}, rotation = 0)));
  Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.FirstOrderLimState AVR(T = Ta, initType = Modelica.Blocks.Types.Init.InitialState, k = Ka, yMax = VrMax, yMin = VrMin, y_start = Ufe0Pu)  annotation(
    Placement(visible = true, transformation(origin = {0, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

protected
  parameter Types.VoltageModulePu Ufe0Pu(fixed=false);
  parameter Types.VoltageModulePu Exc0Pu(fixed=false);

initial algorithm
  Exc0Pu := Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.ExcIEEEAC1A_Exc0Pu_INIT(Kc=Kc, Efd0Pu=Efd0Pu);
  Ufe0Pu := (Dynawo.Examples.RVS.Components.GeneratorWithControl.Controls.Exciters.Util.SatChar_func(u = Exc0Pu, e1=e1, e2=e2, s1=s1, s2=s2) + Ke * Exc0Pu + IRotor0Pu * Kd);
  URef0Pu := Ufe0Pu / Ka + UStator0Pu;

equation
  connect(IRotorPu, Demagnetization.u) annotation(
    Line(points = {{230, -100}, {22, -100}}, color = {0, 0, 127}));
  connect(UfePu.y, RateFeedback.u) annotation(
    Line(points = {{-51, -60}, {-68, -60}}, color = {0, 0, 127}));
  connect(IRotorPu, ExciterOutputDrop.u) annotation(
    Line(points = {{230, -100}, {168, -100}, {168, -96}}, color = {0, 0, 127}));
  connect(EfdPuProd.y, EfdPu) annotation(
    Line(points = {{191, 40}, {220, 40}}, color = {0, 0, 127}));
  connect(SatChar.y, UfePu.u2) annotation(
    Line(points = {{-1, -60}, {-28, -60}}, color = {0, 0, 127}));
  connect(rectReg.Fex, EfdPuProd.u2) annotation(
    Line(points = {{162, 23}, {162, 34}, {168, 34}}, color = {0, 0, 127}));
  connect(dUr.y, Exciter.u) annotation(
    Line(points = {{61, 40}, {67, 40}}, color = {0, 0, 127}));
  connect(ExciterLim.u, Exciter.y) annotation(
    Line(points = {{98, 40}, {92, 40}}, color = {0, 0, 127}));
  connect(ExciterLim.y, EfdPuProd.u1) annotation(
    Line(points = {{121, 40}, {131, 40}, {131, 46}, {168, 46}}, color = {0, 0, 127}));
  connect(ExciterLim.y, SatChar.u) annotation(
    Line(points = {{121, 40}, {131, 40}, {131, -60}, {22, -60}}, color = {0, 0, 127}));
  connect(ExciterLim.y, FieldGain.u) annotation(
    Line(points = {{121, 40}, {131, 40}, {131, -20}, {22, -20}}, color = {0, 0, 127}));
  connect(Demagnetization.y, UfePu.u3) annotation(
    Line(points = {{0, -100}, {-20, -100}, {-20, -68}, {-28, -68}}, color = {0, 0, 127}));
  connect(FieldGain.y, UfePu.u1) annotation(
    Line(points = {{0, -20}, {-20, -20}, {-20, -52}, {-28, -52}}, color = {0, 0, 127}));
  connect(dEfdPu.y, AVRLeadLag.u) annotation(
    Line(points = {{-79, 40}, {-62, 40}}, color = {0, 0, 127}));
  connect(UpssPu, dUGenPU.u3) annotation(
    Line(points = {{-230, -40}, {-156, -40}, {-156, -8}, {-148, -8}}, color = {0, 0, 127}));
  connect(dUGenPU.y, dEfdPu.u2) annotation(
    Line(points = {{-125, 0}, {-113, 0}, {-113, 40}, {-102, 40}}, color = {0, 0, 127}));
  connect(UoelPu, add.u1) annotation(
    Line(points = {{-230, 120}, {-188, 120}, {-188, 92}, {-148, 92}}, color = {0, 0, 127}));
  connect(UuelPu, add.u2) annotation(
    Line(points = {{-230, 80}, {-148, 80}}, color = {0, 0, 127}));
  connect(add.y, dEfdPu.u1) annotation(
    Line(points = {{-125, 86}, {-114, 86}, {-114, 48}, {-102, 48}}, color = {0, 0, 127}));
  connect(In.u1, ExciterOutputDrop.y) annotation(
    Line(points = {{168, -56}, {168, -72}}, color = {0, 0, 127}));
  connect(UfePu.y, dUr.u2) annotation(
    Line(points = {{-50, -60}, {-60, -60}, {-60, 8}, {30, 8}, {30, 34}, {38, 34}}, color = {0, 0, 127}));
  connect(RateFeedback.y, dEfdPu.u3) annotation(
    Line(points = {{-90, -60}, {-108, -60}, {-108, 32}, {-102, 32}}, color = {0, 0, 127}));
  connect(In.y, limiter.u) annotation(
    Line(points = {{162, -32}, {162, -28}}, color = {0, 0, 127}));
  connect(limiter.y, rectReg.In) annotation(
    Line(points = {{162, -4}, {162, 0}}, color = {0, 0, 127}));
  connect(max.y, In.u2) annotation(
    Line(points = {{149, -74}, {156, -74}, {156, -56}}, color = {0, 0, 127}));
  connect(ExciterLim.y, max.u1) annotation(
    Line(points = {{122, 40}, {114, 40}, {114, -68}, {126, -68}}, color = {0, 0, 127}));
  connect(product.y, gain.u) annotation(
    Line(points = {{90, -82}, {98, -82}}, color = {0, 0, 127}));
  connect(ExciterLim.y, product.u1) annotation(
    Line(points = {{122, 40}, {114, 40}, {114, -52}, {68, -52}, {68, -80}, {80, -80}}, color = {0, 0, 127}));
  connect(ExciterLim.y, product.u2) annotation(
    Line(points = {{122, 40}, {114, 40}, {114, -52}, {68, -52}, {68, -86}, {80, -86}}, color = {0, 0, 127}));
  connect(const.y, add1.u2) annotation(
    Line(points = {{50.5, -85}, {62, -85}, {62, -96}, {111, -96}}, color = {0, 0, 127}));
  connect(add1.y, max.u2) annotation(
    Line(points = {{122.5, -93}, {122.5, -80}, {126, -80}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{108.5, -83}, {108.5, -90}, {111, -90}}, color = {0, 0, 127}));
  connect(URefPuConst.y, dUGenPU.u1) annotation(
    Line(points = {{-208, 38}, {-154, 38}, {-154, 8}, {-148, 8}}, color = {0, 0, 127}));
  connect(AVR.y, dUr.u1) annotation(
    Line(points = {{11, 40}, {24, 40}, {24, 46}, {38, 46}}, color = {0, 0, 127}));
  connect(AVRLeadLag.y, AVR.u) annotation(
    Line(points = {{-38, 40}, {-12, 40}}, color = {0, 0, 127}));
  connect(UStatorPu, UGenPuDelay.u) annotation(
    Line(points = {{-230, 0}, {-190, 0}}, color = {0, 0, 127}));
  connect(UGenPuDelay.y, dUGenPU.u2) annotation(
    Line(points = {{-166, 0}, {-148, 0}}, color = {0, 0, 127}));

  annotation(
    Diagram(coordinateSystem(extent = {{-210, -140}, {210, 140}})),
    Icon(coordinateSystem(extent = {{-210, -140}, {210, 140}}), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-210, 140}, {210, -140}}), Text(origin = {0, -1}, extent = {{-196, 121}, {196, -121}}, textString = "EXAC1")}));
end ExcIEEEAC1A;
