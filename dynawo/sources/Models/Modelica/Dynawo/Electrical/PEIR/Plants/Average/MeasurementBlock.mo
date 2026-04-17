within Dynawo.Electrical.PEIR.Plants.Average;

model MeasurementBlock


  parameter Real UrPcc0Pu;
  parameter Real UiPcc0Pu;
  parameter Real IrPcc0Pu;
  parameter Real IiPcc0Pu;
  parameter Real Theta0;
  parameter Real U0_pcc;
  parameter Real k_filter;
  parameter Real T_filter;
  parameter Real P0_pcc ;
  parameter Real Q0_pcc ;
  parameter Real P0_LV;
  parameter Real Q0_LV;
  parameter Real U_pcc_q_0;
  parameter Real I_conv_d_0;
  parameter Real I_conv_q_0;
  parameter Real V_LV_d_0;
  parameter Real V_LV_q_0;
  parameter Real u_LV_re_0;
  parameter Real u_LV_im_0;
  parameter Real I_conv_re_0;
  parameter Real I_conv_im_0;
  Modelica.Blocks.Interfaces.RealInput V_pcc_re(start = UrPcc0Pu) annotation(
    Placement(transformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-68, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput V_pcc_im(start = UiPcc0Pu) annotation(
    Placement(transformation(origin = {-110, 74}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-94, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput I_pcc_re(start = IrPcc0Pu) annotation(
    Placement(transformation(origin = {-110, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput I_pcc_im(start = IiPcc0Pu) annotation(
    Placement(transformation(origin = {-110, 12}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-44, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(transformation(origin = {-22, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput theta_pll(start = Theta0) annotation(
    Placement(transformation(origin = {-112, 52}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ1 annotation(
    Placement(transformation(origin = {-10, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput U_pcc_pu_abs(start = U0_pcc) annotation(
    Placement(transformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {44, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput U_pcc_q(start = U_pcc_q_0) annotation(
    Placement(transformation(origin = {110, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {82, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput I_conv_d(start = I_conv_d_0) annotation(
    Placement(transformation(origin = {110, -54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput I_conv_q(start = I_conv_q_0) annotation(
    Placement(transformation(origin = {110, -68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput V_LV_d(start = V_LV_d_0) annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput V_LV_q(start = V_LV_q_0) annotation(
    Placement(transformation(origin = {110, -14}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput P_plant(start = P0_pcc) annotation(
    Placement(transformation(origin = {109, 83}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {-10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput Q_plant(start = Q0_pcc) annotation(
    Placement(transformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {16, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput P_LV(start = P0_LV) annotation(
    Placement(transformation(origin = {110, -34}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_LV(start = Q0_LV) annotation(
    Placement(transformation(origin = {110, -84}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput u_LV_re(start = u_LV_re_0) annotation(
    Placement(transformation(origin = {-109, -9}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {32, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput u_LV_im(start = u_LV_im_0) annotation(
    Placement(transformation(origin = {-109, -31}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {6, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ2 annotation(
    Placement(transformation(origin = {-19, -7}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Interfaces.RealInput I_conv_re(start = I_conv_re_0) annotation(
    Placement(transformation(origin = {-111, -57}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput I_conv_im(start = I_conv_im_0) annotation(
    Placement(transformation(origin = {-111, -81}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ3 annotation(
    Placement(transformation(origin = {-23, -61}, extent = {{-11, -11}, {11, 11}})));
  Modelica.Blocks.Sources.RealExpression abs_value(y = sqrt(V_pcc_re^2 + V_pcc_im^2)) annotation(
    Placement(transformation(origin = {30, 20}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(k = k_filter, T = T_filter, Y0 = U0_pcc) annotation(
    Placement(transformation(origin = {70, 20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression P_plant_expre(y = transformRItoDQ.ud*transformRItoDQ1.ud + transformRItoDQ.uq*transformRItoDQ1.uq) annotation(
    Placement(transformation(origin = {30, 82}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Q_plant_expre(y = transformRItoDQ.uq*transformRItoDQ1.ud - transformRItoDQ.ud*transformRItoDQ1.uq) annotation(
    Placement(transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(k = k_filter, T = T_filter, Y0 = P0_pcc) annotation(
    Placement(transformation(origin = {70, 82}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze2(k = k_filter, T = T_filter, Y0 = Q0_pcc) annotation(
    Placement(transformation(origin = {70, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression P_LV_expre(y = transformRItoDQ2.ud*transformRItoDQ1.ud + transformRItoDQ2.uq*transformRItoDQ1.uq) annotation(
    Placement(transformation(origin = {40, -34}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Q_LV_expr(y = transformRItoDQ2.uq*transformRItoDQ1.ud - transformRItoDQ2.ud*transformRItoDQ1.uq) annotation(
    Placement(transformation(origin = {30, -84}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze3(k = k_filter, T = T_filter, Y0 = P0_LV) annotation(
    Placement(transformation(origin = {70, -34}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze4(k = k_filter, T = T_filter, Y0 = Q0_LV) annotation(
    Placement(transformation(origin = {70, -84}, extent = {{-10, -10}, {10, 10}})));

Modelica.Blocks.Sources.RealExpression P_from_RI(
  y = V_pcc_re*I_pcc_re + V_pcc_im*I_pcc_im);
equation
  connect(transformRItoDQ.phi, theta_pll) annotation(
    Line(points = {{-33, 68}, {-88.5, 68}, {-88.5, 52}, {-112, 52}}, color = {0, 0, 127}));
  connect(transformRItoDQ2.phi, theta_pll) annotation(
    Line(points = {{-31, -14}, {-88, -14}, {-88, 52}, {-112, 52}}, color = {0, 0, 127}));
  connect(transformRItoDQ3.phi, theta_pll) annotation(
    Line(points = {{-35, -68}, {-88, -68}, {-88, 52}, {-112, 52}}, color = {0, 0, 127}));
  V_pcc_re = transformRItoDQ.u.re;
  V_pcc_im = transformRItoDQ.u.im;
  I_pcc_re = transformRItoDQ1.u.re;
  I_pcc_im = transformRItoDQ1.u.im;
  u_LV_re = transformRItoDQ2.u.re;
  u_LV_im = transformRItoDQ2.u.im;
  I_conv_re = transformRItoDQ3.u.re;
  I_conv_im = transformRItoDQ3.u.im;
  connect(transformRItoDQ2.ud, V_LV_d) annotation(
    Line(points = {{-7, 0}, {110, 0}}, color = {0, 0, 127}));
  connect(V_LV_q, transformRItoDQ2.uq) annotation(
    Line(points = {{110, -14}, {-7, -14}}, color = {0, 0, 127}));
  connect(U_pcc_q, transformRItoDQ.uq) annotation(
    Line(points = {{110, 68}, {-10, 68}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, U_pcc_pu_abs) annotation(
    Line(points = {{81, 20}, {110, 20}}, color = {0, 0, 127}));
  connect(abs_value.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{41, 20}, {58, 20}}, color = {0, 0, 127}));
  connect(P_plant_expre.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{41, 82}, {58, 82}}, color = {0, 0, 127}));
  connect(P_plant, rateLimFirstOrderFreeze1.y) annotation(
    Line(points = {{109, 83}, {104.75, 83}, {104.75, 81}, {100.5, 81}, {100.5, 82}, {81, 82}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze2.u, Q_plant_expre.y) annotation(
    Line(points = {{58, 50}, {41, 50}}, color = {0, 0, 127}));
  connect(Q_plant, rateLimFirstOrderFreeze2.y) annotation(
    Line(points = {{110, 50}, {81, 50}}, color = {0, 0, 127}));
  connect(P_LV_expre.y, rateLimFirstOrderFreeze3.u) annotation(
    Line(points = {{51, -34}, {58, -34}}, color = {0, 0, 127}));
  connect(P_LV, rateLimFirstOrderFreeze3.y) annotation(
    Line(points = {{110, -34}, {81, -34}}, color = {0, 0, 127}));
  connect(Q_LV_expr.y, rateLimFirstOrderFreeze4.u) annotation(
    Line(points = {{41, -84}, {58, -84}}, color = {0, 0, 127}));
  connect(I_conv_d, transformRItoDQ3.ud) annotation(
    Line(points = {{110, -54}, {-11, -54}}, color = {0, 0, 127}));
  connect(transformRItoDQ3.uq, I_conv_q) annotation(
    Line(points = {{-11, -68}, {110, -68}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze4.y, Q_LV) annotation(
    Line(points = {{81, -84}, {110, -84}}, color = {0, 0, 127}));
  connect(transformRItoDQ1.phi, theta_pll) annotation(
    Line(points = {{-20, 24}, {-88, 24}, {-88, 52}, {-112, 52}}, color = {0, 0, 127}));
  annotation(
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}, lineColor = {0, 0, 0}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid), Text(origin = {0, 0}, extent = {{-90, 20}, {90, -20}}, textString = "measurement filters")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")),
    Diagram);
end MeasurementBlock;