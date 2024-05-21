within Dynawo.Examples.GridForming;

model Converter_v1

  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  parameter Real Tfilter = 1"Temps for the input DC source filter";
  parameter Real m = 2 "Modulating of the dc source";
  Modelica.Blocks.Interfaces.RealInput udConvRefPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-100, 62}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-100, -18}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {106, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput uqConvPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {102, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation


   der(udConvPu)*Tfilter+udConvPu=m*udConvRefPu;
   der(uqConvPu)*Tfilter+uqConvPu=m*uqConvRefPu;



annotation(
    uses(Modelica(version = "3.2.3")),
    Diagram(coordinateSystem(extent = {{-120, 80}, {120, -40}})));
end Converter_v1;