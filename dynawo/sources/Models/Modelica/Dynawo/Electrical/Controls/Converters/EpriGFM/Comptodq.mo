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
    Placement(visible = true, transformation(origin = {-112, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-120, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput thetaGFM annotation(
    Placement(visible = true, transformation(origin = {-130, -92}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 4)  annotation(
    Placement(visible = true, transformation(origin = {-12, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.IntegerConstant integerConstant(k = wflag)  annotation(
    Placement(visible = true, transformation(origin = {-50, -74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-154, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.ComplexBlocks.ComplexMath.Product product annotation(
    Placement(visible = true, transformation(origin = {-110, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.BooleanInput Frz annotation(
    Placement(visible = true, transformation(origin = {-204, 6}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-56, -120}, extent = {{-20, -20}, {20, 20}}, rotation = -90)));
 Modelica.ComplexBlocks.ComplexMath.PolarToComplex polarToComplex annotation(
    Placement(visible = true, transformation(origin = {-126, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant zero(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-162, -42}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant one(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-190, -20}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant constant2(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-190, 38}, extent = {{-6, -6}, {6, 6}}, rotation = 0)));
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
    Line(points = {{-112, 48}, {14, 48}}, color = {85, 170, 255}));
  connect(pll.phi, multiSwitch.u[1]) annotation(
    Line(points = {{-28, 4}, {-26, 4}, {-26, -88}, {-22, -88}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[2]) annotation(
    Line(points = {{-130, -92}, {-22, -92}, {-22, -88}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[3]) annotation(
    Line(points = {{-130, -92}, {-64, -92}, {-64, -88}, {-22, -88}}, color = {0, 0, 127}));
  connect(thetaGFM, multiSwitch.u[4]) annotation(
    Line(points = {{-130, -92}, {-64, -92}, {-64, -88}, {-22, -88}}, color = {0, 0, 127}));
  connect(multiSwitch.y, transformRItoDQ1.phi) annotation(
    Line(points = {{-1, -88}, {8, -88}, {8, -4}, {16, -4}}, color = {0, 0, 127}));
  connect(transformRItoDQ.phi, multiSwitch.y) annotation(
    Line(points = {{14, 36}, {8, 36}, {8, -88}, {-1, -88}}, color = {0, 0, 127}));
  connect(integerConstant.y, multiSwitch.f) annotation(
    Line(points = {{-39, -74}, {-26, -74}, {-26, -76}, {-13, -76}}, color = {255, 127, 0}));
  connect(product.y, pll.uPu) annotation(
    Line(points = {{-98, 14}, {-58, 14}, {-58, 8}, {-50, 8}}, color = {85, 170, 255}));
  connect(uINjPu, product.u1) annotation(
    Line(points = {{-112, 48}, {-146, 48}, {-146, 20}, {-122, 20}}, color = {85, 170, 255}));
  connect(switch1.u2, Frz) annotation(
    Line(points = {{-166, 6}, {-204, 6}}, color = {255, 0, 255}));
 connect(zero.y, polarToComplex.phi) annotation(
    Line(points = {{-155, -42}, {-155, -41}, {-138, -41}, {-138, -40}}, color = {0, 0, 127}));
 connect(constant2.y, switch1.u1) annotation(
    Line(points = {{-184, 38}, {-176, 38}, {-176, 14}, {-166, 14}}, color = {0, 0, 127}));
 connect(one.y, switch1.u3) annotation(
    Line(points = {{-184, -20}, {-180, -20}, {-180, -2}, {-166, -2}}, color = {0, 0, 127}));
 connect(polarToComplex.len, switch1.y) annotation(
    Line(points = {{-138, -28}, {-138, -11}, {-142, -11}, {-142, 6}}, color = {0, 0, 127}));
 connect(polarToComplex.y, product.u2) annotation(
    Line(points = {{-114, -34}, {-106, -34}, {-106, 4}, {-122, 4}, {-122, 8}}, color = {85, 170, 255}));
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, 3}, extent = {{-83, 65}, {83, -65}}, textString = "computation
to
dq")}));
end Comptodq;
