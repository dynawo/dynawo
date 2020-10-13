within OpenEMTP.Electrical.Exciters_Governor;

model PSS1A "Power system stablizer Type  PSS1A"
  parameter Real T1(unit = "S") = 5 "Lead time constant T1 " annotation(
    Dialog(tab = "Governer"));
  parameter Real T2(unit = "S") = 0.6 "Lag time constant T2  " annotation(
    Dialog(tab = "Governer"));
  parameter Real T3(unit = "S") = 3 "Lead time constant T3   " annotation(
    Dialog(tab = "Governer"));
  parameter Real T4(unit = "S") = 0.5 "Lag time constant T4   " annotation(
    Dialog(tab = "Governer"));
  parameter Real T5(unit = "S") = 10 "Time constant T5 " annotation(
    Dialog(tab = "Governer"));
  parameter Real T6(unit = "S") = Modelica.Constants.eps "Time constant T6" annotation(
    Dialog(tab = "Governer"));
  parameter Real KS(unit = "PU") = 1 "Gain KS" annotation(
    Dialog(tab = "Governer"));
  parameter Real A1(unit = "S") = Modelica.Constants.eps "Filter constant A1 " annotation(
    Dialog(tab = "Governer"));
  parameter Real A2(unit = "S^2") = Modelica.Constants.eps "Filter constant A2 " annotation(
    Dialog(tab = "Governer"));
  parameter Real Vstmax(unit = "PU") = 0.2 "Maximum output VSTMAX " annotation(
    Dialog(tab = "Governer"));
  parameter Real Vstmin(unit = "PU") = -0.2 "Minimum output VSTMIN " annotation(
    Dialog(tab = "Governer"));
  parameter Real VSinit(unit = "PU") = 0 "Initial value " annotation(
    Dialog(tab = "Governer"));

    Modelica.Blocks.Interfaces.RealInput VSI annotation(
     Placement(visible = true, transformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput VST annotation(
    Placement(visible = true, transformation(origin = {144, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = T6, k = KS, y(fixed = false), y_start = VSinit) annotation(
    Placement(visible = true, transformation(origin = {-76, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction(a = {A2, A1, 1}, b = {1}, initType = Modelica.Blocks.Types.Init.NoInit, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-2, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = Vstmax, uMin = Vstmin) annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction1(a = {T2, 1}, b = {T1, 1}, initType = Modelica.Blocks.Types.Init.NoInit, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {34, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction2(a = {T4, 1}, b = {T3, 1}, initType = Modelica.Blocks.Types.Init.NoInit, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {72, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunction3(a = {T6, 1}, b = {T5, 0}, initType = Modelica.Blocks.Types.Init.NoInit, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {-38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(firstOrder.u, VSI) annotation(
    Line(points = {{-88, 0}, {-106, 0}, {-106, 0}, {-120, 0}}, color = {0, 0, 127}));
  connect(VST, limiter.y) annotation(
    Line(points = {{144, 0}, {121, 0}}, color = {0, 0, 127}));
  connect(transferFunction1.u, transferFunction.y) annotation(
    Line(points = {{22, 0}, {10, 0}, {10, 0}, {10, 0}}, color = {0, 0, 127}));
  connect(transferFunction2.u, transferFunction1.y) annotation(
    Line(points = {{60, 0}, {44, 0}, {44, 0}, {46, 0}}, color = {0, 0, 127}));
  connect(limiter.u, transferFunction2.y) annotation(
    Line(points = {{98, 0}, {84, 0}, {84, 0}, {84, 0}}, color = {0, 0, 127}));
  connect(transferFunction3.u, firstOrder.y) annotation(
    Line(points = {{-50, 0}, {-64, 0}, {-64, 0}, {-64, 0}}, color = {0, 0, 127}));
  connect(transferFunction.u, transferFunction3.y) annotation(
    Line(points = {{-14, 0}, {-26, 0}, {-26, 0}, {-26, 0}}, color = {0, 0, 127}));
  annotation(
    Documentation(info = "<html><head></head><body><!--StartFragment--><!--StartFragment--><h2 id=\"mw_ac0e3530-f4a8-4707-9a63-b650ebce6625\" style=\"box-sizing: border-box; font-size: 17px; line-height: 1.35; font-family: Arial, Helvetica, sans-serif; color: rgb(64, 64, 64); margin: 0px 0px 8px; padding: 5px 0px 0px; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: rgb(204, 204, 204); orphans: 2; widows: 2; background-color: rgb(255, 255, 255); transition: none 0s ease 0s !important; -webkit-transition: none 0s ease 0s !important;\">Description</h2><br class=\"Apple-interchange-newline\"><!--EndFragment--><span style=\"color: rgb(64, 64, 64); font-family: Arial, Helvetica, sans-serif; font-size: 13px; orphans: 2; widows: 2; background-color: rgb(255, 255, 255);\">block implements a single-input PSS1A power system stabilizer (PSS) to maintain rotor angle stability in a synchronous machine (SM). Typically, you use a PSS to enhance damping of power system oscillations through excitation control.</span><!--EndFragment--></body></html>"),
    Icon(graphics = {Rectangle(origin = {-94, 86}, lineColor = {0, 0, 255}, extent = {{-6, 14}, {194, -186}}), Text(origin = {-81, 1}, extent = {{-17, 13}, {17, -13}}, textString = "VSI"), Text(origin = {73, 3}, extent = {{-17, 13}, {17, -13}}, textString = "VST"), Text(origin = {4, -58}, extent = {{-38, 36}, {38, -36}}, textString = "PSS1A")}, coordinateSystem(initialScale = 0.1)),
    Diagram(graphics = {Text(origin = {0, 84}, extent = {{-22, 12}, {22, -12}}, textString = "PSS1A (pu)")}, coordinateSystem(initialScale = 0.1)),
    experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-06, Interval = 2.00004e-05));
end PSS1A;
