within Dynawo.Examples.GridForming;



model CurrentFilterLoop
import Modelica.Constants.pi;
 
  parameter Real Lf "RLC filter inductor in pu";
  parameter Real Gffc "sensitivity to the voltage variation at the RLC filter capacitance";
  parameter Real Fsw "Switching frequency of the VSC in Hertz";
  parameter Real Rf "RLC filter resistance in pu";
  parameter Real EpsilonCurrent "damping of the close current loop";
  parameter Real Wn "fundamental angular frequency in rad"; 
  parameter Real Kpc "proportional gain in pu";
  parameter Real Kic "integral gain in rad/s";
  parameter Real Wnc "angular frequency cut off of the current control loop in rad/s";
  

  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start=idConvRef0Pu) "d-axis currrent reference for the inverter bridge output in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, 150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start=idConv0Pu) "d-axis voltage after the RLC filter in pu (base UNom, SNom)"  annotation(
    Placement(visible = true, transformation(origin = {-164, 40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-161, 107}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start=iqConvRef0Pu) "q-axis currrent reference for the inverter bridge output in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-168, -164}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start=omega0Pu) "angular frequency reference of the VSC system in pu (base omegaNom)"  annotation(
    Placement(visible = true, transformation(origin = {-164, -8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start=udFilter0Pu) "d-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-170, -122}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start=uqFilter0Pu) "q-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -314}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, -146}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start=iqConv0Pu) "Start value of the q-axis currrent at the inverter bridge output  in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-174, -206}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-160, -82}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-60, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kpc) annotation(
    Placement(visible = true, transformation(origin = {11, 111}, extent = {{-13, -13}, {13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {72, 74}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Gffc) annotation(
    Placement(visible = true, transformation(origin = {18, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kic, y_start = idConvRef0Pu - idConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {12, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Lf) annotation(
    Placement(visible = true, transformation(origin = {18, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-50, -27}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {176, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-60, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = Lf) annotation(
    Placement(visible = true, transformation(origin = {18, -242}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = Kic, y_start = iqConvRef0Pu - iqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {18, -206}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain4(k = Kpc) annotation(
    Placement(visible = true, transformation(origin = {18, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-60, -277}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2 annotation(
    Placement(visible = true, transformation(origin = {72, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain5(k = Gffc) annotation(
    Placement(visible = true, transformation(origin = {18, -292}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {118, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start=udConvRef0Pu) "d-axis voltage reference at the inverter bridge output in pu (base UNom, SNom) " annotation(
    Placement(visible = true, transformation(origin = {230, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {160, 118}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start=uqConvRef0Pu) "q-axis voltage reference at the inverter bridge output in pu (base UNom, SNom) " annotation(
    Placement(visible = true, transformation(origin = {230, -172}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {160, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {172, -176}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {122, -174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit idConvRef0Pu "Start value of the d-axis currrent reference for the inverter bridge output in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iqConvRef0Pu "Start value of the q-axis currrent reference for the inverter bridge output in pu (base UNom, SNom) (generator convention)";    
  parameter Types.PerUnit omega0Pu=SystemBase.omegaRef0Pu "Start value of the angular frequency reference of the VSC system in pu (base omegaNom)";
  parameter Types.PerUnit udFilter0Pu  "Start value of the d-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit uqFilter0Pu  "Start value of the q-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit iqConv0Pu "Start value of the q-axis currrent at the inverter bridge output  in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit idConv0Pu "Start value of the d-axis currrent at the inverter bridge output  in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit udConvRef0Pu "Start value of the d-axis voltage reference at the inverter bridge output in pu (base UNom, SNom) ";
  parameter Types.PerUnit uqConvRef0Pu "Start value of the q-axis voltage reference at the inverter bridge output in pu (base UNom, SNom) ";  


equation


  
  connect(product.y, gain1.u) annotation(
    Line(points = {{-39, -27}, {-19, -27}, {-19, 1}, {5, 1}}, color = {0, 0, 127}));
 connect(gain.y, add.u1) annotation(
    Line(points = {{25, 111}, {44, 111}, {44, 80}, {59, 80}}, color = {0, 0, 127}));
 connect(feedback.y, gain.u) annotation(
    Line(points = {{-51, 80}, {-23, 80}, {-23, 111}, {-5, 111}}, color = {0, 0, 127}));
 connect(feedback.y, integrator.u) annotation(
    Line(points = {{-51, 80}, {-35, 80}, {-35, 36}, {0, 36}}, color = {0, 0, 127}));
  connect(gain2.y, add1.u2) annotation(
    Line(points = {{29, -48}, {147, -48}, {147, 62}, {163, 62}}, color = {0, 0, 127}));
  connect(idConvRefPu, feedback.u1) annotation(
    Line(points = {{-120, 80}, {-68, 80}}, color = {0, 0, 127}));
 connect(idConvPu, feedback.u2) annotation(
    Line(points = {{-164, 40}, {-60, 40}, {-60, 72}}, color = {0, 0, 127}));
 connect(omegaPu, product.u1) annotation(
    Line(points = {{-164, -8}, {-96, -8}, {-96, -21}, {-62, -21}}, color = {28, 113, 216}, pattern = LinePattern.Dot, thickness = 0.75));
    connect(gain1.y, add3.u2) annotation(
    Line(points = {{30, 2}, {98, 2}, {98, 66}, {106, 66}}, color = {0, 0, 127}));
  connect(add.y, add3.u1) annotation(
    Line(points = {{84, 74}, {96, 74}, {96, 78}, {106, 78}}, color = {0, 0, 127}));
  connect(add3.y, add1.u1) annotation(
    Line(points = {{130, 72}, {147, 72}, {147, 74}, {164, 74}}, color = {0, 0, 127}));
  connect(add1.y, udConvRefPu) annotation(
    Line(points = {{188, 68}, {230, 68}}, color = {0, 0, 127}));
  connect(feedback2.y, gain4.u) annotation(
    Line(points = {{-51, -164}, {6, -164}}, color = {0, 0, 127}));
  connect(gain4.y, add2.u1) annotation(
    Line(points = {{29, -164}, {60, -164}}, color = {0, 0, 127}));
  connect(integrator1.y, add2.u2) annotation(
    Line(points = {{29, -206}, {44, -206}, {44, -176}, {60, -176}}, color = {0, 0, 127}));
  connect(add2.y, add5.u1) annotation(
    Line(points = {{83, -170}, {98, -170}, {98, -168}, {110, -168}}, color = {0, 0, 127}));
  connect(add5.y, add4.u1) annotation(
    Line(points = {{133, -174}, {144, -174}, {144, -170}, {160, -170}}, color = {0, 0, 127}));
  connect(add4.y, uqConvRefPu) annotation(
    Line(points = {{183, -176}, {192, -176}, {192, -172}, {230, -172}}, color = {0, 0, 127}));
  connect(integrator1.u, feedback2.y) annotation(
    Line(points = {{6, -206}, {-46, -206}, {-46, -164}, {-51, -164}}, color = {0, 0, 127}));
  connect(iqConvRefPu, feedback2.u1) annotation(
    Line(points = {{-168, -164}, {-68, -164}}, color = {0, 0, 127}));
 connect(iqConvPu, feedback2.u2) annotation(
    Line(points = {{-174, -206}, {-60, -206}, {-60, -172}}, color = {0, 0, 127}));
 connect(omegaPu, product1.u1) annotation(
    Line(points = {{-164, -8}, {-82, -8}, {-82, -272}, {-72, -272}, {-72, -271}}, color = {145, 65, 172}, pattern = LinePattern.Dash, thickness = 0.75));
  connect(product1.y, gain3.u) annotation(
    Line(points = {{-48, -276}, {-20, -276}, {-20, -242}, {6, -242}}, color = {0, 0, 127}));
  connect(gain3.y, add5.u2) annotation(
    Line(points = {{30, -242}, {98, -242}, {98, -180}, {110, -180}}, color = {0, 0, 127}));
  connect(gain5.y, add4.u2) annotation(
    Line(points = {{30, -292}, {146, -292}, {146, -182}, {160, -182}}, color = {0, 0, 127}));
 connect(udFilterPu, gain2.u) annotation(
    Line(points = {{-170, -122}, {-28, -122}, {-28, -48}, {6, -48}}, color = {0, 0, 127}));
 connect(product.u2, iqConvPu) annotation(
    Line(points = {{-62, -32}, {-118, -32}, {-118, -206}, {-174, -206}}, color = {224, 27, 36}, pattern = LinePattern.Dot, thickness = 0.75));
 connect(uqFilterPu, gain5.u) annotation(
    Line(points = {{-160, -314}, {-22, -314}, {-22, -292}, {6, -292}}, color = {0, 0, 127}));
 connect(idConvPu, product1.u2) annotation(
    Line(points = {{-164, 40}, {-130, 40}, {-130, -282}, {-72, -282}}, color = {46, 194, 126}, thickness = 0.75));
 connect(integrator.y, add.u2) annotation(
    Line(points = {{24, 36}, {36, 36}, {36, 68}, {60, 68}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, 140}, {240, -340}})),
    Icon(coordinateSystem(extent = {{-150, -180}, {150, 180}}), graphics = {Text(origin = {-1, -1}, extent = {{-147, 177}, {147, -177}}, textString = "CurrentIconvControl"), Text(origin = {-236, 166}, lineColor = {38, 162, 105}, extent = {{-66, 36}, {66, -36}}, textString = "idConvRefPu"), Text(origin = {-228, 120}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-56, 24}, {56, -24}}, textString = "idConvPu"), Text(origin = {-227, 56}, lineColor = {245, 194, 17}, lineThickness = 0.75, extent = {{-55, 28}, {55, -28}}, textString = "udFilterPu"), Text(origin = {-237, -12}, lineColor = {38, 162, 105}, extent = {{-67, 24}, {67, -24}}, textString = "iqConvRefPu"), Text(origin = {-230, -63}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-58, 19}, {58, -19}}, textString = "iqConvPu"), Text(origin = {-228, -123}, lineColor = {245, 194, 17}, lineThickness = 0.75, extent = {{-58, 29}, {58, -29}}, textString = "uqFilterPu"), Text(origin = {68, 199}, extent = {{-50, 25}, {50, -25}}, textString = "omegaPu"), Text(origin = {225, 131}, lineColor = {192, 28, 40}, extent = {{-55, 31}, {55, -31}}, textString = "udConvRefPu"), Text(origin = {228, -37}, lineColor = {192, 28, 40}, extent = {{-52, 29}, {52, -29}}, textString = "uqConvRefPu"), Rectangle(extent = {{-150, 180}, {150, -180}})}));
end CurrentFilterLoop;