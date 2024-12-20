within Dynawo.Electrical.Controls.Converters.EpriGFM;

model DQTrafo
  extends Parameters.OmegaFlag;
  //Modelica.Blocks.Sources.Constant OmegaRefPu(k = SystemBase.omegaRef0Pu)
  Modelica.Blocks.Sources.Constant OmegaRefPu(k = 1) annotation(
    Placement(visible = true, transformation(origin = {-130, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Modelica.Blocks.Interfaces.RealOutput uiSourcePu(start = uSource0Pu.im)
  Modelica.Blocks.Interfaces.RealOutput uiSourcePu annotation(
    Placement(visible = true, transformation(origin = {130, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -39}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.PLL.PLL pll(Ki = 700, Kp = 20, OmegaMaxPu = 1.5, OmegaMinPu = 0.5, u0Pu = Complex(1.0, 0)) annotation(
    Placement(visible = true, transformation(origin = {-88, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 // Modelica.Blocks.Interfaces.RealInput udPu(start = Id0Pu)
  Modelica.Blocks.Interfaces.RealInput udPu annotation(
    Placement(visible = true, transformation(origin = {-130, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(visible = true, transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

//Modelica.Blocks.Interfaces.RealOutput urSourcePu(start = uSource0Pu.re)
  Modelica.Blocks.Interfaces.RealOutput urSourcePu annotation(
    Placement(visible = true, transformation(origin = {130, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu(im(start = uInj0Pu.im), re(start = uInj0Pu.re))
  Modelica.ComplexBlocks.Interfaces.ComplexInput uInjPu annotation(
    Placement(visible = true, transformation(origin = {-130, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  //Modelica.Blocks.Interfaces.RealInput uqPu(start = Iq0Pu)
  Modelica.Blocks.Interfaces.RealInput uqPu annotation(
    Placement(visible = true, transformation(origin = {-130, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput theta annotation(
    Placement(visible = true, transformation(origin = {-116, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch6(nu = 4)  annotation(
    Placement(visible = true, transformation(origin = {32, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.IntegerConstant integerConstant6(k = wflag + 1)  annotation(
    Placement(visible = true, transformation(origin = {-24, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(transformDQtoRI.uiPu, uiSourcePu) annotation(
    Line(points = {{101, -6}, {110, -6}, {110, -20}, {130, -20}}, color = {0, 0, 127}));
 connect(uInjPu, pll.uPu) annotation(
    Line(points = {{-130, 4}, {-110, 4}, {-110, -26}, {-99, -26}}, color = {85, 170, 255}));
  connect(transformDQtoRI.urPu, urSourcePu) annotation(
    Line(points = {{101, 6}, {110, 6}, {110, 20}, {130, 20}}, color = {0, 0, 127}));
 connect(OmegaRefPu.y, pll.omegaRefPu) annotation(
    Line(points = {{-119, -40}, {-111, -40}, {-111, -38}, {-99, -38}}, color = {0, 0, 127}));
  connect(udPu, transformDQtoRI.udPu) annotation(
    Line(points = {{-130, 60}, {80, 60}, {80, 8}}, color = {0, 0, 127}));
  connect(uqPu, transformDQtoRI.uqPu) annotation(
    Line(points = {{-130, 30}, {8, 30}, {8, 4}, {80, 4}}, color = {0, 0, 127}));
 connect(pll.phi, multiSwitch6.u[1]) annotation(
    Line(points = {{-77, -31}, {-38, -31}, {-38, -52}, {22, -52}}, color = {0, 0, 127}));
 connect(integerConstant6.y, multiSwitch6.f) annotation(
    Line(points = {{-12, -14}, {32, -14}, {32, -40}}, color = {255, 127, 0}));
 connect(multiSwitch6.y, transformDQtoRI.phi) annotation(
    Line(points = {{43, -52}, {58, -52}, {58, -6}, {80, -6}}, color = {0, 0, 127}));
 connect(theta, multiSwitch6.u[2]) annotation(
    Line(points = {{-116, -80}, {22, -80}, {22, -52}}, color = {0, 0, 127}));
 connect(theta, multiSwitch6.u[3]) annotation(
    Line(points = {{-116, -80}, {22, -80}, {22, -52}}, color = {0, 0, 127}));
 connect(theta, multiSwitch6.u[4]) annotation(
    Line(points = {{-116, -80}, {22, -80}, {22, -52}}, color = {0, 0, 127}));
annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Line(origin = {-1, 0}, points = {{-99, -100}, {101, 100}}), Text(origin = {-41, 51}, extent = {{-33, 25}, {33, -25}}, textString = "dq"), Text(origin = {34, -47}, extent = {{-24, 25}, {24, -25}}, textString = "ri")}));
end DQTrafo;
