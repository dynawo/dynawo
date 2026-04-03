within Dynawo.Electrical.PEIR.Plants.Average;

model MeasurementBlock

  Modelica.Blocks.Interfaces.RealInput V_pcc_re annotation(
    Placement(transformation(origin = {-48, 90}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-68, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput V_pcc_im annotation(
    Placement(transformation(origin = {-48, 74}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-94, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput I_pcc_re annotation(
    Placement(transformation(origin = {-34, 50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-20, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput I_pcc_im annotation(
    Placement(transformation(origin = {-34, 32}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-44, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ annotation(
    Placement(transformation(origin = {-22, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput theta_pll annotation(
    Placement(transformation(origin = {-90, 54}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ1 annotation(
    Placement(transformation(origin = {-10, 30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput U_pcc_pu_abs annotation(
    Placement(transformation(origin = {0, -90}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput U_pcc_q annotation(
    Placement(transformation(origin = {84, 68}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput I_conv_d annotation(
    Placement(transformation(origin = {12, -50}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput I_conv_q annotation(
    Placement(transformation(origin = {12, -76}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 22}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput V_d_conv annotation(
    Placement(transformation(origin = {12, 2}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput V_q_conv annotation(
    Placement(transformation(origin = {12, -16}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -58}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput P_plant annotation(
    Placement(transformation(origin = {112, 44}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-10, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput Q_plant annotation(
    Placement(transformation(origin = {106, 8}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {16, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealOutput P_conv annotation(
    Placement(transformation(origin = {96, -52}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput Q_conv annotation(
    Placement(transformation(origin = {94, -76}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput u_filter_re annotation(
    Placement(transformation(origin = {-45, 15}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {32, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput u_filter_im annotation(
    Placement(transformation(origin = {-47, -5}, extent = {{-9, -9}, {9, 9}}), iconTransformation(origin = {6, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ2 annotation(
    Placement(transformation(origin = {-20, -4}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput I_conv_re annotation(
    Placement(transformation(origin = {-57, -41}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {90, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput I_conv_im annotation(
    Placement(transformation(origin = {-57, -57}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Controls.WECC.Utilities.TransformRItoDQ transformRItoDQ3 annotation(
    Placement(transformation(origin = {-24, -60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression abs_valye(y = sqrt(V_pcc_re^2 + V_pcc_im^2))  annotation(
    Placement(transformation(origin = {-82, -94}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze(k = k_filter, T = T_filter, Y0 = U0_pcc)  annotation(
    Placement(transformation(origin = {-38, -88}, extent = {{-10, -10}, {10, 10}})));
  parameter Real k_filter;
  parameter Real T_filter;
  parameter Real U0_pcc;
  parameter Real P0_pcc;
  parameter Real Q0_pcc;
  parameter Real P0_conv;
  parameter Real Q0_conv;
  Modelica.Blocks.Sources.RealExpression P_plant_expre(y = transformRItoDQ.ud*transformRItoDQ1.ud + transformRItoDQ.uq*transformRItoDQ1.uq)  annotation(
    Placement(transformation(origin = {30, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Q_plant_expre(y = transformRItoDQ.uq*transformRItoDQ1.ud - transformRItoDQ.ud*transformRItoDQ1.uq)  annotation(
    Placement(transformation(origin = {36, 12}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(k = k_filter, T = T_filter, Y0 = P0_pcc)  annotation(
    Placement(transformation(origin = {68, 44}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze2(k = k_filter, T = T_filter, Y0 = Q0_pcc)  annotation(
    Placement(transformation(origin = {72, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression P_conv_expre(y = transformRItoDQ2.ud*transformRItoDQ3.ud + transformRItoDQ2.uq*transformRItoDQ3.uq)  annotation(
    Placement(transformation(origin = {38, -30}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression Q_conv_expr(y = transformRItoDQ2.uq*transformRItoDQ3.ud - transformRItoDQ2.ud*transformRItoDQ3.uq)  annotation(
    Placement(transformation(origin = {30, -88}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze3(k = k_filter, T = T_filter, Y0 = P0_conv)  annotation(
    Placement(transformation(origin = {64, -40}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze4(k = k_filter, T = T_filter, Y0 = Q0_conv)  annotation(
    Placement(transformation(origin = {62, -84}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(transformRItoDQ.phi, theta_pll) annotation(
    Line(points = {{-33, 68}, {-78.5, 68}, {-78.5, 54}, {-90, 54}}, color = {0, 0, 127}));
  connect(theta_pll, transformRItoDQ1.phi) annotation(
    Line(points = {{-90, 54}, {-47.5, 54}, {-47.5, 24}, {-21, 24}}, color = {0, 0, 127}));
  connect(transformRItoDQ2.phi, theta_pll) annotation(
    Line(points = {{-31, -10}, {-78, -10}, {-78, 54}, {-90, 54}}, color = {0, 0, 127}));
  connect(transformRItoDQ3.phi, theta_pll) annotation(
    Line(points = {{-34, -66}, {-78, -66}, {-78, 54}, {-90, 54}}, color = {0, 0, 127}));
  V_pcc_re=transformRItoDQ.u.re;
  V_pcc_im= transformRItoDQ.u.im;
  I_pcc_re=transformRItoDQ1.u.re;
  I_pcc_im=transformRItoDQ1.u.im;
  u_filter_re=transformRItoDQ2.u.re;
  u_filter_im=transformRItoDQ2.u.im;
  I_conv_re = transformRItoDQ3.u.re;
  I_conv_im = transformRItoDQ3.u.im;
  connect(I_conv_d, transformRItoDQ3.ud) annotation(
    Line(points = {{12, -50}, {-1, -50}, {-1, -54}, {-12, -54}}, color = {0, 0, 127}));
  connect(I_conv_q, transformRItoDQ3.uq) annotation(
    Line(points = {{12, -76}, {-1, -76}, {-1, -66}, {-12, -66}}, color = {0, 0, 127}));
  connect(transformRItoDQ2.ud, V_d_conv) annotation(
    Line(points = {{-8, 2}, {12, 2}}, color = {0, 0, 127}));
  connect(V_q_conv, transformRItoDQ2.uq) annotation(
    Line(points = {{12, -16}, {-8, -16}, {-8, -10}}, color = {0, 0, 127}));
  connect(U_pcc_q, transformRItoDQ.uq) annotation(
    Line(points = {{84, 68}, {-10, 68}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze.y, U_pcc_pu_abs) annotation(
    Line(points = {{-27, -88}, {-16.5, -88}, {-16.5, -90}, {0, -90}}, color = {0, 0, 127}));
  connect(abs_valye.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-71, -94}, {-62, -94}, {-62, -88}, {-50, -88}}, color = {0, 0, 127}));
  connect(P_plant_expre.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{42, 36}, {49, 36}, {49, 44}, {56, 44}}, color = {0, 0, 127}));
  connect(P_plant, rateLimFirstOrderFreeze1.y) annotation(
    Line(points = {{112, 44}, {79, 44}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze2.u, Q_plant_expre.y) annotation(
    Line(points = {{60, 8}, {48, 8}, {48, 12}}, color = {0, 0, 127}));
  connect(Q_plant, rateLimFirstOrderFreeze2.y) annotation(
    Line(points = {{106, 8}, {84, 8}}, color = {0, 0, 127}));
 connect(P_conv_expre.y, rateLimFirstOrderFreeze3.u) annotation(
    Line(points = {{50, -30}, {52, -30}, {52, -40}}, color = {0, 0, 127}));
 connect(P_conv, rateLimFirstOrderFreeze3.y) annotation(
    Line(points = {{96, -52}, {76, -52}, {76, -40}}, color = {0, 0, 127}));
 connect(Q_conv, rateLimFirstOrderFreeze4.y) annotation(
    Line(points = {{94, -76}, {73, -76}, {73, -84}}, color = {0, 0, 127}));
 connect(Q_conv_expr.y, rateLimFirstOrderFreeze4.u) annotation(
    Line(points = {{42, -88}, {50, -88}, {50, -84}}, color = {0, 0, 127}));
  annotation( Icon(graphics = {
        Rectangle(
          extent = {{-100, 100}, {100, -100}},
          lineColor = {0, 0, 0},
          fillColor = {255, 255, 255},
          fillPattern = FillPattern.Solid),
        Text(
          origin = {0, 0},
          extent = {{-90, 20}, {90, -20}},
          textString = "measurement filters")
      },coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.8.0")));

end MeasurementBlock;