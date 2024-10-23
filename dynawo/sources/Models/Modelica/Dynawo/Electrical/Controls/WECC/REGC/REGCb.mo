within Dynawo.Electrical.Controls.WECC.REGC;

model REGCb
  extends Dynawo.Electrical.Controls.WECC.Parameters.ParamsREGC;
  parameter Boolean Lvplsw(start = false) "Low voltage power logic switch: 1-enabled/0-disabled" annotation(
    Dialog(tab = "Generator Control"));
  parameter Types.PerUnit zerox(start = 0.0) "LVPL zero crossing in pu" annotation(
    Dialog(tab = "Generator Control"));
  parameter Types.PerUnit brkpt(start = 1.0) "LVPL breakpoint in pu" annotation(
    Dialog(tab = "Generator Control"));
  parameter Types.PerUnit lvpl1(start = 1.0) "LVPL gain breakpoint in pu" annotation(
    Dialog(tab = "Generator Control"));
  // Input variables
  Modelica.Blocks.Interfaces.RealInput iqCmdPu(start = Iq0Pu) "iqCmdPu setpoint from electrical control in pu (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput Qgen0(start = UInj0Pu) "Reactive power setpoint in pu (base Iverter)" annotation(
    Placement(visible = true, transformation(origin = {-190, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, 109}, extent = {{10, 10}, {-10, -10}}, rotation = 90)));
  // Output variables
  Modelica.Blocks.Interfaces.RealOutput iqRefPu(start = -Iq0Pu) "iqRefPu setpoint to injector in pu (generator convention) (base SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {160, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold annotation(
    Placement(visible = true, transformation(origin = {-160, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = -1) annotation(
    Placement(visible = true, transformation(origin = {50, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant3(k = -9999) annotation(
    Placement(visible = true, transformation(origin = {-80, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant4(k = 9999) annotation(
    Placement(visible = true, transformation(origin = {-80, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze2(T = tG, UseRateLim = true, Y0 = Iq0Pu) annotation(
    Placement(visible = true, transformation(origin = {10, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant5(k = IqrMaxPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant6(k = IqrMinPu) annotation(
    Placement(visible = true, transformation(origin = {-80, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(visible = true, transformation(origin = {-40, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(visible = true, transformation(origin = {-40, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Not not1 annotation(
    Placement(visible = true, transformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  // Initial parameters
  parameter Dynawo.Types.VoltageModulePu UInj0Pu "Start value of voltage amplitude at injector terminal in pu (base UNom)";
  parameter Dynawo.Types.CurrentModulePu Id0Pu "Start value of d-component current at injector terminal in pu (generator convention) (base SNom, UNom)";
  parameter Dynawo.Types.CurrentModulePu Iq0Pu "Start value of q-component current at injector terminal in pu (generator convention) (base SNom, UNom)";
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {-40, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant UNomFix(k = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-80, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idCmdPu(start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {-190, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {11, -50}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.RateLimFirstOrderFreeze rateLimFirstOrderFreeze1(T = tG, UseRateLim = true, Y0 = Id0Pu * UInj0Pu, k = 1) annotation(
    Placement(visible = true, transformation(origin = {80, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanConstant RateFlag0(k = RateFlag) annotation(
    Placement(visible = true, transformation(origin = {-100, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(uMax = 999, uMin = 0.01) annotation(
    Placement(visible = true, transformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tFilterGC, k = 1, y(start = UInj0Pu), y_start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-150, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idRefPu(start = Id0Pu) annotation(
    Placement(visible = true, transformation(origin = {160, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Division division annotation(
    Placement(visible = true, transformation(origin = {120, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant RrpwrNeg0(k = -RrpwrPu) annotation(
    Placement(visible = true, transformation(origin = {41, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UPu(start = UInj0Pu) annotation(
    Placement(visible = true, transformation(origin = {-190, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-60, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
equation
  connect(switch3.y, rateLimFirstOrderFreeze2.dyMin) annotation(
    Line(points = {{-29, 20}, {-20, 20}, {-20, 54}, {-2, 54}}, color = {0, 0, 127}));
  connect(constant6.y, switch3.u1) annotation(
    Line(points = {{-69, 40}, {-60.5, 40}, {-60.5, 28}, {-52, 28}, {-52, 28}}, color = {0, 0, 127}));
  connect(constant5.y, switch4.u1) annotation(
    Line(points = {{-69, 120}, {-59.5, 120}, {-59.5, 108}, {-52, 108}}, color = {0, 0, 127}));
  connect(constant4.y, switch4.u3) annotation(
    Line(points = {{-69, 80}, {-60, 80}, {-60, 92}, {-52, 92}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze2.y, gain1.u) annotation(
    Line(points = {{21, 60}, {38, 60}}, color = {0, 0, 127}));
  connect(constant3.y, switch3.u3) annotation(
    Line(points = {{-69, 0}, {-60, 0}, {-60, 12}, {-52, 12}}, color = {0, 0, 127}));
  connect(switch4.y, rateLimFirstOrderFreeze2.dyMax) annotation(
    Line(points = {{-29, 100}, {-20, 100}, {-20, 67}, {-2, 67}}, color = {0, 0, 127}));
  connect(greaterThreshold.y, switch4.u2) annotation(
    Line(points = {{-149, 100}, {-52, 100}}, color = {255, 0, 255}));
  connect(not1.y, switch3.u2) annotation(
    Line(points = {{-99, 20}, {-52, 20}}, color = {255, 0, 255}));
  connect(greaterThreshold.y, not1.u) annotation(
    Line(points = {{-149, 100}, {-149, 99.9688}, {-140, 99.9688}, {-140, 19.75}, {-121, 19.75}, {-121, 19.5}, {-122, 19.5}, {-122, 20}}, color = {255, 0, 255}));
  connect(iqCmdPu, rateLimFirstOrderFreeze2.u) annotation(
    Line(points = {{-190, 60}, {-2, 60}}, color = {0, 0, 127}));
  connect(Qgen0, greaterThreshold.u) annotation(
    Line(points = {{-190, 100}, {-172, 100}}, color = {0, 0, 127}));
  connect(gain1.y, iqRefPu) annotation(
    Line(points = {{61, 60}, {160, 60}}, color = {0, 0, 127}));
  connect(rateLimFirstOrderFreeze1.y, division.u1) annotation(
    Line(points = {{91, -50}, {99.5, -50}, {99.5, -84}, {108, -84}}, color = {0, 0, 127}));
  connect(RateFlag0.y, switch.u2) annotation(
    Line(points = {{-89, -120}, {-52, -120}}, color = {255, 0, 255}));
  connect(RrpwrNeg0.y, rateLimFirstOrderFreeze1.dyMin) annotation(
    Line(points = {{52, -70}, {63.5, -70}, {63.5, -56}, {68, -56}}, color = {0, 0, 127}));
  connect(switch.y, division.u2) annotation(
    Line(points = {{-29, -120}, {29.5, -120}, {29.5, -96}, {108, -96}}, color = {0, 0, 127}));
  connect(division.y, idRefPu) annotation(
    Line(points = {{131, -90}, {160, -90}}, color = {0, 0, 127}));
  connect(limiter.y, switch.u1) annotation(
    Line(points = {{-99, -90}, {-59.5, -90}, {-59.5, -112}, {-52, -112}}, color = {0, 0, 127}));
  connect(firstOrder.y, limiter.u) annotation(
    Line(points = {{-139, -90}, {-122, -90}}, color = {0, 0, 127}));
  connect(UNomFix.y, switch.u3) annotation(
    Line(points = {{-69, -150}, {-60.5, -150}, {-60.5, -128}, {-52, -128}}, color = {0, 0, 127}));
  connect(switch.y, product.u1) annotation(
    Line(points = {{-29, -120}, {-20, -120}, {-20, -56}, {-2, -56}, {-2, -56.5}, {-1, -56.5}, {-1, -56}}, color = {0, 0, 127}));
  connect(product.y, rateLimFirstOrderFreeze1.u) annotation(
    Line(points = {{22, -50}, {68, -50}}, color = {0, 0, 127}));
  connect(idCmdPu, product.u2) annotation(
    Line(points = {{-190, -30}, {-20, -30}, {-20, -44}, {-1, -44}}, color = {0, 0, 127}));
  connect(UPu, firstOrder.u) annotation(
    Line(points = {{-190, -90}, {-162, -90}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-180, -180}, {150, 150}}, initialScale = 0.2, grid = {1, 1})),
    Icon(coordinateSystem(extent = {{-180, -180}, {150, 150}}, initialScale = 0.2, grid = {1, 1})));
end REGCb;
