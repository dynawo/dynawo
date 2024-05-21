within Dynawo.Electrical.Controls.Converters.OuterControls.Synchronization;

model OmegaSelection

  parameter Types.PerUnit WPLL = 1000 "Cut off angular frequency of a first order filter at the output of the PLL";
  parameter Boolean Wref_FromPLL=false "TRUE if the reference for omegaSetSelected is coming from PLL otherwise is a fixe value";
  parameter Types.PerUnit omegaSetPu =1 "Fixe angular frequency as a reference  in pu (base omegaNom)";
  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = omegaPLL0Pu) "PLL angular frequency" annotation(
    Placement(visible = true, transformation(origin = {-130, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 58}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Logical.Switch switch1 annotation(
    Placement(visible = true, transformation(origin = {-20, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = WPLL, k = 1, y_start = omegaPLL0Pu) annotation(
    Placement(visible = true, transformation(origin = {-72, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.BooleanExpression booleanExpression(y = Wref_FromPLL) annotation(
    Placement(visible = true, transformation(origin = {-108, -10}, extent = {{-18, -10}, {18, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaSetSelectedPu(start = omegaSetSelected0Pu) "Angular frequency selected" annotation(
    Placement(visible = true, transformation(origin = {130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{100, -16}, {120, 4}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = omegaSetPu) annotation(
    Placement(visible = true, transformation(origin = {-104, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit omegaSetSelected0Pu  "start value of the angular frequency selected";
  parameter Types.PerUnit omegaPLL0Pu = SystemBase.omegaRef0Pu "start value of the angular frequency of the PLL"; 

    
equation
  connect(omegaPLLPu, firstOrder1.u) annotation(
    Line(points = {{-130, 28}, {-84, 28}}, color = {0, 0, 127}));
  connect(firstOrder1.y, switch1.u1) annotation(
    Line(points = {{-60, 28}, {-48, 28}, {-48, 18}, {-32, 18}}, color = {0, 0, 127}));
  connect(booleanExpression.y, switch1.u2) annotation(
    Line(points = {{-88, -10}, {-78, -10}, {-78, 10}, {-32, 10}}, color = {255, 0, 255}));
  connect(const.y, switch1.u3) annotation(
    Line(points = {{-92, -40}, {-54, -40}, {-54, 2}, {-32, 2}}, color = {0, 0, 127}));
  connect(switch1.y, omegaSetSelectedPu) annotation(
    Line(points = {{-8, 10}, {62, 10}, {62, 40}, {130, 40}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 140}, {140, -60}})),
    Icon(graphics = {Text(origin = {159, 10}, extent = {{-37, 24}, {37, -24}}, textString = "OmegaSelected"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, -1}, extent = {{-99, 99}, {99, -99}}, textString = "OmegaSelection"), Text(origin = {-175, 67}, extent = {{-51, 23}, {51, -23}}, textString = "omegaPLLPu")}));
end OmegaSelection;