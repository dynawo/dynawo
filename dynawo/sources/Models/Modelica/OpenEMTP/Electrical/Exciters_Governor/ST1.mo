within OpenEMTP.Electrical.Exciters_Governor;

model ST1
 parameter Real TB= 10 "Time Constant"
     annotation (Dialog(tab="Data"));
 parameter Real TC= 1  "Time Constant"
     annotation (Dialog(tab="Data"));
 parameter Real KF= 0  "Gain"
     annotation (Dialog(tab="Data"));
 parameter Real TF= 1  "Time Constant"
     annotation (Dialog(tab="Data"));
 parameter Real KA= 200  "Gain"
     annotation (Dialog(tab="Exciter"));
 parameter Real TA= 0.015  "Time Constant"
     annotation (Dialog(tab="Exciter"));
 parameter Real KC= 0  "Recifier loading factor"
     annotation (Dialog(tab="Exciter"));
 parameter Real VIMAX= 0.1  "Maximum regulator input"
     annotation (Dialog(tab="Exciter"));
 parameter Real VIMIN= -0.1  "Minimum regulator input"
     annotation (Dialog(tab="Exciter"));
 parameter Real VRMAX= 5  "Maximum regulator output"
     annotation (Dialog(tab="Exciter"));
 parameter Real VRMIN= -5  "Minimum regulator output"
     annotation (Dialog(tab="Exciter"));
 parameter Real EFSS= 1  "Steady state field voltage "
     annotation (Dialog(tab="Initial Concitions"));

 final parameter Real Vin_ic=EFSS*1/KA;

 Modelica.Blocks.Interfaces.RealInput IFD annotation(
    Placement(visible = true, transformation(origin = {-260, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {80, -118}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
 Modelica.Blocks.Interfaces.RealInput VREF annotation(
    Placement(visible = true, transformation(origin = {-260, 92}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-122, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput VT annotation(
    Placement(visible = true, transformation(origin = {-260, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -78}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput VC annotation(
    Placement(visible = true, transformation(origin = {-260, -88}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-18, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 90)));
 Modelica.Blocks.Interfaces.RealInput VS annotation(
    Placement(visible = true, transformation(origin = {-260, -132}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-118, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain(k = 1 / KA)  annotation(
    Placement(visible = true, transformation(origin = {-186, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-124, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-156, 84}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold = 0)  annotation(
    Placement(visible = true, transformation(origin = {-208, 132}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Add3 add3(k1 = +1, k2 = -1, k3 = +1)  annotation(
    Placement(visible = true, transformation(origin = {-90, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Add add1(k1 = +1, k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-34, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = VIMAX, uMin = VIMIN) annotation(
    Placement(visible = true, transformation(origin = {14, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 OpenEMTP.NonElectrical.Blocks.LeadLagCompensator leadLagCompensator(K = 1, T1 = TC, T2 = TB, y_start = Vin_ic) annotation(
    Placement(visible = true, transformation(origin = {76, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant const(k = EFSS)  annotation(
    Placement(visible = true, transformation(origin = {-286, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder(T = TA, k = KA, y_start = EFSS)  annotation(
    Placement(visible = true, transformation(origin = {134, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(limitsAtInit = true) annotation(
    Placement(visible = true, transformation(origin = {200, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain Efd_min(k = VRMIN) annotation(
    Placement(visible = true, transformation(origin = {-106, -188}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {-12, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain4(k = KC) annotation(
    Placement(visible = true, transformation(origin = {-54, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain VRmax(k = VRMAX) annotation(
    Placement(visible = true, transformation(origin = {-56, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput EFD annotation(
    Placement(visible = true, transformation(origin = {250, -94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.Derivative derivative(T = TF, initType = Modelica.Blocks.Types.Init.InitialState, k = KF, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {16, -144}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput VF annotation(
    Placement(visible = true, transformation(origin = {250, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 OpenEMTP.NonElectrical.Blocks.Hold_t0 hold_t0 annotation(
    Placement(visible = true, transformation(origin = {-212, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
 connect(variableLimiter.y, EFD) annotation(
    Line(points = {{212, -94}, {250, -94}}, color = {0, 0, 127}));
 connect(VF, derivative.y) annotation(
    Line(points = {{250, -180}, {-20, -180}, {-20, -144}, {6, -144}}, color = {0, 0, 127}));
 connect(add.u2, gain.y) annotation(
    Line(points = {{-136, 32}, {-175, 32}}, color = {0, 0, 127}));
 connect(switch1.y, add.u1) annotation(
    Line(points = {{-145, 84}, {-140, 84}, {-140, 44}, {-136, 44}}, color = {0, 0, 127}));
 connect(switch1.u1, VREF) annotation(
    Line(points = {{-168, 92}, {-260, 92}}, color = {0, 0, 127}));
 connect(greaterThreshold.u, VREF) annotation(
    Line(points = {{-220, 132}, {-242, 132}, {-242, 92}, {-260, 92}}, color = {0, 0, 127}));
 connect(switch1.u2, greaterThreshold.y) annotation(
    Line(points = {{-168, 84}, {-180, 84}, {-180, 132}, {-197, 132}}, color = {255, 0, 255}));
 connect(add3.u2, VC) annotation(
    Line(points = {{-102, -88}, {-260, -88}}, color = {85, 0, 0}, thickness = 1));
 connect(add.y, add3.u1) annotation(
    Line(points = {{-113, 38}, {-108, 38}, {-108, -80}, {-102, -80}}, color = {0, 0, 127}));
 connect(VS, add3.u3) annotation(
    Line(points = {{-260, -132}, {-108, -132}, {-108, -96}, {-102, -96}}, color = {0, 255, 0}, thickness = 1));
 connect(add1.u1, add3.y) annotation(
    Line(points = {{-46, -88}, {-79, -88}}, color = {0, 0, 127}));
 connect(limiter.u, add1.y) annotation(
    Line(points = {{2, -94}, {-23, -94}}, color = {0, 0, 127}));
 connect(leadLagCompensator.u, limiter.y) annotation(
    Line(points = {{64, -94}, {25, -94}}, color = {0, 0, 127}));
 connect(gain.u, const.y) annotation(
    Line(points = {{-198, 32}, {-275, 32}}, color = {0, 0, 127}));
 connect(leadLagCompensator.y, firstOrder.u) annotation(
    Line(points = {{87, -94}, {122, -94}}, color = {0, 0, 127}));
 connect(firstOrder.y, variableLimiter.u) annotation(
    Line(points = {{145, -94}, {188, -94}}, color = {0, 0, 127}));
 connect(VT, Efd_min.u) annotation(
    Line(points = {{-260, -40}, {-142, -40}, {-142, -188}, {-118, -188}}, color = {0, 0, 127}, thickness = 1));
 connect(Efd_min.y, variableLimiter.limit2) annotation(
    Line(points = {{-94, -188}, {180, -188}, {180, -102}, {188, -102}, {188, -102}}, color = {0, 0, 127}));
 connect(VRmax.u, VT) annotation(
    Line(points = {{-68, 16}, {-142, 16}, {-142, -40}, {-260, -40}, {-260, -40}}, color = {0, 0, 127}, thickness = 1));
 connect(gain4.u, IFD) annotation(
    Line(points = {{-66, -26}, {-178, -26}, {-178, -8}, {-260, -8}, {-260, -6}}, color = {0, 0, 127}));
 connect(feedback3.u1, VRmax.y) annotation(
    Line(points = {{-20, 16}, {-44, 16}, {-44, 16}, {-44, 16}}, color = {0, 0, 127}));
 connect(gain4.y, feedback3.u2) annotation(
    Line(points = {{-42, -26}, {-12, -26}, {-12, 6}, {-12, 6}, {-12, 8}}, color = {0, 0, 127}));
 connect(feedback3.y, variableLimiter.limit1) annotation(
    Line(points = {{-2, 16}, {176, 16}, {176, -84}, {188, -84}, {188, -86}}, color = {0, 0, 127}));
 connect(add1.u2, derivative.y) annotation(
    Line(points = {{-46, -100}, {-60, -100}, {-60, -144}, {6, -144}, {6, -144}}, color = {0, 0, 127}));
 connect(derivative.u, firstOrder.y) annotation(
    Line(points = {{28, -144}, {160, -144}, {160, -94}, {146, -94}, {146, -94}}, color = {0, 0, 127}));
 connect(hold_t0.y, switch1.u3) annotation(
    Line(points = {{-201, 76}, {-168, 76}}, color = {0, 0, 127}));
 connect(hold_t0.u, VC) annotation(
    Line(points = {{-224, 76}, {-234, 76}, {-234, -88}, {-260, -88}, {-260, -88}}, color = {85, 0, 0}, thickness = 1));

annotation(
    Diagram(graphics = {Text(origin = {-158, 45}, lineColor = {255, 0, 255}, extent = {{-12, 5}, {12, -5}}, textString = "Vin_ic"), Text(origin = {-160, 109}, lineColor = {255, 0, 255}, extent = {{-12, 9}, {32, -9}}, textString = "VREF_Selection"), Text(origin = {-96, -4}, lineColor = {255, 0, 255}, extent = {{-10, 4}, {10, -4}}, textString = "Vref"), Text(origin = {-182, -79}, lineColor = {255, 0, 255}, extent = {{-20, 3}, {52, -3}}, textString = "Filtered terminal voltage"), Text(origin = {-62, -73}, lineColor = {255, 0, 255}, extent = {{-6, 5}, {6, -5}}, textString = "Vin"), Text(origin = {-11, -86}, lineColor = {255, 0, 255}, extent = {{-7, 2}, {7, -2}}, textString = "Ve"), Text(origin = {40, -86}, lineColor = {255, 0, 255}, extent = {{-16, 4}, {16, -4}}, textString = "Ve_lim"), Text(origin = {-246, 41}, lineColor = {255, 0, 255}, extent = {{-12, 5}, {12, -5}}, textString = "EFSS"), Text(origin = {110, -86}, lineColor = {255, 0, 255}, extent = {{-16, 4}, {16, -4}}, textString = "Vef"), Text(origin = {168, -87}, lineColor = {255, 0, 255}, extent = {{-8, 1}, {8, -1}}, textString = "Vr"), Text(origin = {196, -135}, lineColor = {255, 0, 255}, extent = {{-14, 5}, {28, -7}}, textString = "Efd_min"), Text(origin = {-34, -137}, lineColor = {255, 0, 255}, extent = {{-6, 5}, {6, -5}}, textString = "Vf"), Text(origin = {-20, 132}, extent = {{-60, 16}, {60, -16}}, textString = "Exciter ST1 (pu)
IEEE Standard 421.5, 1982.")}, coordinateSystem(extent = {{-310, -200}, {260, 150}})),
    Icon(graphics = {Text(origin = {-77, 78}, extent = {{-19, 12}, {19, -12}}, textString = "VREF"), Text(origin = {77, -82}, extent = {{-19, 12}, {19, -12}}, textString = "IFD"), Text(origin = {-71, -76}, extent = {{-19, 12}, {19, -12}}, textString = "VT"), Text(origin = {-15, -80}, extent = {{-19, 12}, {19, -12}}, textString = "VC"), Text(origin = {-83, 2}, extent = {{-19, 12}, {19, -12}}, textString = "VS"), Text(origin = {73, -18}, extent = {{-19, 12}, {19, -12}}, textString = "VF"), Text(origin = {-77, 78}, extent = {{-19, 12}, {19, -12}}, textString = "VREF"), Text(origin = {73, 76}, extent = {{-19, 12}, {19, -12}}, textString = "EFD"), Rectangle(origin = {1, 0}, lineColor = {0, 0, 255}, extent = {{-101, 100}, {99, -100}})}, coordinateSystem(extent = {{-310, -200}, {260, 150}})),
    __OpenModelica_commandLineOptions = "");
end ST1;
