within Dynawo.Electrical.Controls.Converters.EpriGFM;

model Comptodq
  extends Parameters.OmegaFlag;
  extends Parameters.Pll;
  extends Parameters.InitialTerminalU;
  
  
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(visible = true, transformation(origin = {24, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
   Modelica.ComplexBlocks.Interfaces.ComplexInput iINjPu annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 18}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 //Modelica.ComplexBlocks.Interfaces.ComplexInput iINjPu(im(start = uInj0Pu.im), re(start = uInj0Pu.re)) annotation(
  // Placement(visible = true, transformation(origin = {-110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = Ki, Kp = Kp, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu, omegaPLLPu(start = 1), omegaRefPu(start = 1), phi(start = 0), u0Pu(im = 0, re = 1) = u0Pu) annotation(
    Placement(visible = true, transformation(origin = {-40, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ1 annotation(
    Placement(visible = true, transformation(origin = {26, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput ud annotation(
    Placement(visible = true, transformation(origin = {110, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uq annotation(
    Placement(visible = true, transformation(origin = {110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iq annotation(
    Placement(visible = true, transformation(origin = {110, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput id annotation(
    Placement(visible = true, transformation(origin = {110, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omega annotation(
    Placement(visible = true, transformation(origin = {110, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uINjPu annotation(
    Placement(visible = true, transformation(origin = {-110, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput thetaGFM annotation(
    Placement(visible = true, transformation(origin = {-128, -48}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4)  annotation(
    Placement(visible = true, transformation(origin = {-10, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.IntegerConstant integerConstant(k = wflag)  annotation(
    Placement(visible = true, transformation(origin = {-48, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-66, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput FrzReal annotation(
    Placement(visible = true, transformation(origin = {-120, 56}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-40, 120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
equation
 connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-69, -4}, {-51, -4}}, color = {0, 0, 127}));
 connect(transformRItoDQ.udPu, ud) annotation(
    Line(points = {{35, 48}, {109, 48}}, color = {0, 0, 127}));
 connect(transformRItoDQ.uqPu, uq) annotation(
    Line(points = {{35, 36}, {109, 36}}, color = {0, 0, 127}));
 connect(transformRItoDQ1.uqPu, iq) annotation(
    Line(points = {{37, -4}, {109, -4}}, color = {0, 0, 127}));
 connect(transformRItoDQ1.udPu, id) annotation(
    Line(points = {{37, 8}, {73, 8}, {73, 10}, {109, 10}}, color = {0, 0, 127}));
 connect(omega, pll.omegaPLLPu) annotation(
    Line(points = {{110, -28}, {-20, -28}, {-20, 8}, {-28, 8}}, color = {0, 0, 127}));
 connect(transformRItoDQ1.uPu, iINjPu) annotation(
    Line(points = {{15, 8}, {-23, 8}, {-23, 80}, {-110, 80}}, color = {85, 170, 255}));
 connect(uINjPu, transformRItoDQ.uPu) annotation(
    Line(points = {{-110, 30}, {-68, 30}, {-68, 48}, {14, 48}}, color = {85, 170, 255}));
 connect(pll.phi, multiSwitch.u[1]) annotation(
    Line(points = {{-28, 4}, {-26, 4}, {-26, -44}, {-20, -44}}, color = {0, 0, 127}));
 connect(thetaGFM, multiSwitch.u[2]) annotation(
    Line(points = {{-128, -48}, {-20, -48}, {-20, -44}}, color = {0, 0, 127}));
 connect(thetaGFM, multiSwitch.u[3]) annotation(
    Line(points = {{-128, -48}, {-62, -48}, {-62, -44}, {-20, -44}}, color = {0, 0, 127}));
 connect(thetaGFM, multiSwitch.u[4]) annotation(
    Line(points = {{-128, -48}, {-62, -48}, {-62, -44}, {-20, -44}}, color = {0, 0, 127}));
 connect(multiSwitch.y, transformRItoDQ1.phi) annotation(
    Line(points = {{2, -44}, {8, -44}, {8, -4}, {16, -4}}, color = {0, 0, 127}));
 connect(transformRItoDQ.phi, multiSwitch.y) annotation(
    Line(points = {{14, 36}, {8, 36}, {8, -44}, {2, -44}}, color = {0, 0, 127}));
 connect(integerConstant.y, multiSwitch.f) annotation(
    Line(points = {{-36, -30}, {-23, -30}, {-23, -32}, {-10, -32}}, color = {255, 127, 0}));
 connect(uINjPu, product.u1) annotation(
    Line(points = {{-110, 30}, {-87, 30}, {-87, 24}, {-78, 24}}, color = {85, 170, 255}));
 connect(product.y, pll.uPu) annotation(
    Line(points = {{-54, 18}, {-50, 18}, {-50, 8}}, color = {0, 0, 127}));
 connect(FrzReal, product.u2) annotation(
    Line(points = {{-120, 56}, {-90, 56}, {-90, 12}, {-78, 12}}, color = {0, 0, 127}));

annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, 3}, extent = {{-83, 65}, {83, -65}}, textString = "computation
to
dq")}));
end Comptodq;
