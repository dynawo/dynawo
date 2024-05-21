within Dynawo.Examples.GridForming;

model Transformer_v1
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  parameter Real LTransformer=0.1;
  parameter Real RTransformer=0.1;
  Modelica.Blocks.Interfaces.RealInput iqPccPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-126, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput idPccPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-128, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udFilterPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {126, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqFilterPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {126, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqPccPu  (start=0) annotation(
    Placement(visible = true, transformation(origin = {-128, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udPccPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-134, 70}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-110, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu (start=SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-128, -94}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  
   /* RL Transformer */
    LTransformer / SystemBase.omegaNom * der(idPccPu) = udFilterPu - RTransformer * idPccPu + omegaPu * LTransformer * iqPccPu - udPccPu;
    LTransformer / SystemBase.omegaNom * der(iqPccPu) = uqFilterPu - RTransformer * iqPccPu - omegaPu * LTransformer * idPccPu - uqPccPu;
    
annotation(
    Diagram(coordinateSystem(extent = {{-120, 80}, {120, -120}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {-4, 7}, extent = {{-70, 25}, {70, -25}}, textString = "Transformer")}));
end Transformer_v1;