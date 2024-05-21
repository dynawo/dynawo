within Dynawo.Electrical.Controls.Converters.InnerControls;

model VoltageFilterControl
import Modelica.Constants.pi;
  parameter Real Cf "filter shunt capacitance in pu";
  parameter Real Kpv "proportional gain in pu";
  parameter Real Kiv "integral gain in rad/sec";
  parameter Real Gffv "sensitivity to the grid current (current mesured at the PCC point)";
  parameter Real Wn "fundamental angular frequency in radians";
  
  parameter Types.PerUnit udFilterRef0Pu "Start value of the d-axis voltage reference after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit uqFilterRef0Pu "Start value of the q-axis voltage reference after the RLC filter in pu (base UNom, SNom)"; 
  parameter Types.PerUnit udFilter0Pu "Start value of the d-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit uqFilter0Pu "Start value of the q-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit idPcc0Pu "start value of the d-axis current entering the grid in pu (base UNom, SNom)";
  parameter Types.PerUnit iqPcc0Pu "start value of the q-axis current entering the grid in pu (base UNom, SNom)";
  parameter Types.PerUnit idConvRef0Pu "Start value of the d-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iqConvRef0Pu "Start value of the q-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)";  
  
  Modelica.Blocks.Interfaces.RealInput uqFilterRefPu(start=uqFilterRef0Pu) "q-axis voltage reference after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -100}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-109, 105}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterRefPu(start=udFilterRef0Pu) "d-axis voltage reference after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 94}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 144}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start=udFilter0Pu) "d-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start=uqFilter0Pu) "q-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -150}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idPccPu(start=idPcc0Pu) "d-axis current entering the grid in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPccPu(start=iqPcc0Pu) "q-axis current entering the grid in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-240, -234}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start=idConvRef0Pu) "d-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {150, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start=iqConvRef0Pu) "q-axis current reference injected by the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {152, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-148, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpv)  annotation(
    Placement(visible = true, transformation(origin = {-70, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kiv, y_start = udFilterRef0Pu - udFilter0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-70, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-16, 88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu annotation(
    Placement(visible = true, transformation(origin = {-240, 12}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {10, 190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gain1(k = Cf) annotation(
    Placement(visible = true, transformation(origin = {-70, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {88, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Gffv) annotation(
    Placement(visible = true, transformation(origin = {-64, -40}, extent = {{-16, -16}, {16, 16}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-148, -17}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-154, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Kpv) annotation(
    Placement(visible = true, transformation(origin = {-76, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = Kiv, y_start = uqFilterRef0Pu - uqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-76, -134}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {-22, -106}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = Cf) annotation(
    Placement(visible = true, transformation(origin = {-76, -178}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-154, -211}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain5(k = Gffv) annotation(
    Placement(visible = true, transformation(origin = {-71, -239}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(visible = true, transformation(origin = {82, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {28, 82}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {22, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(udFilterRefPu, feedback.u1) annotation(
    Line(points = {{-240, 94}, {-156, 94}}, color = {0, 0, 127}));
  connect(feedback.y, gain.u) annotation(
    Line(points = {{-138, 94}, {-82, 94}}, color = {0, 0, 127}));
  connect(udFilterPu, feedback.u2) annotation(
    Line(points = {{-240, 60}, {-148, 60}, {-148, 86}}, color = {0, 0, 127}));
  connect(gain.y, add.u1) annotation(
    Line(points = {{-58, 94}, {-28, 94}}, color = {0, 0, 127}));
  connect(feedback.y, integrator.u) annotation(
    Line(points = {{-138, 94}, {-122, 94}, {-122, 60}, {-82, 60}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{-58, 60}, {-42, 60}, {-42, 82}, {-28, 82}}, color = {0, 0, 127}));
  connect(add1.y, idConvRefPu) annotation(
    Line(points = {{100, 82}, {150, 82}}, color = {0, 0, 127}));
  connect(idPccPu, gain2.u) annotation(
    Line(points = {{-240, -34}, {-161, -34}, {-161, -40}, {-83, -40}}, color = {0, 0, 127}));
  connect(gain2.y, add1.u2) annotation(
    Line(points = {{-46, -40}, {60, -40}, {60, 76}, {76, 76}}, color = {0, 0, 127}));
  connect(uqFilterPu, product.u2) annotation(
    Line(points = {{-240, -150}, {-196, -150}, {-196, -22}, {-160, -22}, {-160, -23}}, color = {192, 28, 40}, pattern = LinePattern.DashDot, thickness = 0.75));
  connect(omegaPu, product.u1) annotation(
    Line(points = {{-240, 12}, {-196, 12}, {-196, -10}, {-160, -10}}, color = {28, 113, 216}, pattern = LinePattern.DashDot, thickness = 0.75));
  connect(product.y, gain1.u) annotation(
    Line(points = {{-136, -16}, {-106, -16}, {-106, 16}, {-82, 16}}, color = {0, 0, 127}));
  connect(uqFilterRefPu, feedback2.u1) annotation(
    Line(points = {{-240, -100}, {-162, -100}}, color = {0, 0, 127}));
  connect(feedback2.y, gain3.u) annotation(
    Line(points = {{-144, -100}, {-88, -100}}, color = {0, 0, 127}));
  connect(uqFilterPu, feedback2.u2) annotation(
    Line(points = {{-240, -150}, {-154, -150}, {-154, -108}}, color = {0, 0, 127}));
  connect(gain3.y, add2.u1) annotation(
    Line(points = {{-64, -100}, {-34, -100}}, color = {0, 0, 127}));
  connect(integrator1.u, feedback2.y) annotation(
    Line(points = {{-88, -134}, {-144, -134}, {-144, -100}}, color = {0, 0, 127}));
  connect(product1.u1, omegaPu) annotation(
    Line(points = {{-166, -204}, {-212, -204}, {-212, 12}, {-240, 12}}, color = {129, 61, 156}, pattern = LinePattern.DashDot, thickness = 0.75));
  connect(product1.u2, udFilterPu) annotation(
    Line(points = {{-166, -216}, {-202, -216}, {-202, 60}, {-240, 60}}, color = {46, 194, 126}, thickness = 0.75));
  connect(product1.y, gain4.u) annotation(
    Line(points = {{-142, -210}, {-116, -210}, {-116, -178}, {-88, -178}}, color = {0, 0, 127}));
  connect(integrator1.y, add2.u2) annotation(
    Line(points = {{-64, -134}, {-50, -134}, {-50, -112}, {-34, -112}}, color = {0, 0, 127}));
  connect(gain5.y, add3.u2) annotation(
    Line(points = {{-54.5, -239}, {48, -239}, {48, -118}, {70, -118}}, color = {0, 0, 127}));
  connect(add3.y, iqConvRefPu) annotation(
    Line(points = {{94, -112}, {124, -112}, {124, -66}, {152, -66}}, color = {0, 0, 127}));
  connect(iqPccPu, gain5.u) annotation(
    Line(points = {{-240, -234}, {-164, -234}, {-164, -239}, {-89, -239}}, color = {0, 0, 127}));
  connect(add.y, add4.u1) annotation(
    Line(points = {{-4, 88}, {16, 88}}, color = {0, 0, 127}));
  connect(add4.y, add1.u1) annotation(
    Line(points = {{40, 82}, {50, 82}, {50, 88}, {76, 88}}, color = {0, 0, 127}));
  connect(gain1.y, add4.u2) annotation(
    Line(points = {{-58, 16}, {0, 16}, {0, 76}, {16, 76}}, color = {0, 0, 127}));
  connect(add2.y, add5.u1) annotation(
    Line(points = {{-10, -106}, {10, -106}}, color = {0, 0, 127}));
  connect(add5.y, add3.u1) annotation(
    Line(points = {{34, -112}, {44, -112}, {44, -106}, {70, -106}}, color = {0, 0, 127}));
  connect(gain4.y, add5.u2) annotation(
    Line(points = {{-64, -178}, {-8, -178}, {-8, -118}, {10, -118}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-260, 120}, {160, -260}})),
    Icon(graphics = {Text(origin = {-183, 170}, lineColor = {97, 53, 131}, extent = {{-65, 22}, {65, -22}}, textString = "udFilterRefPu"), Text(origin = {-183, 128}, lineColor = {97, 53, 131}, extent = {{-65, 22}, {65, -22}}, textString = "uqFilterRefPu"), Text(origin = {-187, 58}, lineColor = {245, 194, 17}, lineThickness = 0.75, extent = {{-65, 22}, {65, -22}}, textString = "udFilterPu"), Text(origin = {-183, 8}, lineColor = {245, 194, 17}, lineThickness = 0.75, extent = {{-65, 22}, {65, -22}}, textString = "uqFilterPu"), Text(origin = {-172, -78}, lineColor = {28, 113, 216}, extent = {{-52, 20}, {52, -20}}, textString = "idPccPu"), Text(origin = {-176, -118}, lineColor = {28, 113, 216}, extent = {{-52, 14}, {52, -14}}, textString = "iqPccPu"), Rectangle(extent = {{-100, 180}, {100, -180}}), Text(origin = {77, 220}, extent = {{-61, 16}, {61, -16}}, textString = "omegaPu"), Text(origin = {183, 66}, lineColor = {38, 162, 105}, extent = {{-65, 22}, {65, -22}}, textString = "idConvRefPu"), Text(origin = {181, -6}, lineColor = {38, 162, 105}, extent = {{-65, 22}, {65, -22}}, textString = "iqConvRefPu"), Text(origin = {0, 1}, extent = {{-98, 179}, {98, -179}}, textString = "VoltageFilterControl")}, coordinateSystem(extent = {{-100, -180}, {100, 180}})));
end VoltageFilterControl;