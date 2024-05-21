within Dynawo.Electrical.Controls.Converters.BaseControls;

model RLConnection
  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  parameter Types.PerUnit LTransformer "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit RTransformer "Transformer resistance in pu (base UNom, SNom)";
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = udFilter0Pu) "d-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-126, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = uqFilter0Pu) "q-axis voltage after the RLC filter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-128, -12}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idPccPu(start = idPcc0Pu) "d-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {126, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu(start = iqPcc0Pu) "q-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {126, 6}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = uqPcc0Pu) "q-axis voltage at the grid connection point in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-128, 30}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = udPcc0Pu) "d-axis voltage at the grid connection point in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-134, 70}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-110, 148}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = omega0Pu) "angular reference frequency for the VSC system(omega) " annotation(
    Placement(visible = true, transformation(origin = {-128, -94}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 190}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  parameter Types.PerUnit udFilter0Pu "Start value of the d-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit uqFilter0Pu "Start value of the q-axis voltage after the RLC filter in pu (base UNom, SNom)";
  parameter Types.PerUnit idPcc0Pu "Start value of the d-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit iqPcc0Pu "Start value of the q-axis current at the grid connection point in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit uqPcc0Pu "Start value of the q-axis voltage at the grid connection point in pu (base UNom, SNom)";
  parameter Types.PerUnit udPcc0Pu "Start value of the d-axis voltage at the grid connection point in pu (base UNom, SNom)";
  parameter Types.PerUnit omega0Pu "Start value of the angular reference frequency for the VSC system(omega) ";
equation

  
/* RL Transformer */
  LTransformer / SystemBase.omegaNom * der(idPccPu) = udFilterPu - RTransformer * idPccPu + omegaPu * LTransformer * iqPccPu - udPccPu;
  LTransformer / SystemBase.omegaNom * der(iqPccPu) = uqFilterPu - RTransformer * iqPccPu - omegaPu * LTransformer * idPccPu - uqPccPu;
  annotation(
    Diagram(coordinateSystem(extent = {{-120, 80}, {120, -120}})),
    Icon(graphics = {Rectangle(extent = {{-100, 180}, {100, -180}}), Text(origin = {-9, 5}, rotation = 180, extent = {{-104, 98}, {90, -98}}, textString = "RLConnection"), Text(origin = {73, 217}, extent = {{-61, 21}, {61, -21}}, textString = "omegaPu"), Text(origin = {-159, 160}, lineColor = {230, 97, 0}, lineThickness = 0.75, extent = {{-35, 18}, {35, -18}}, textString = "udPccPu"), Text(origin = {-161, 124}, lineColor = {230, 97, 0}, lineThickness = 0.75, extent = {{-35, 18}, {35, -18}}, textString = "uqPccPu"), Text(origin = {-175, -81}, lineColor = {245, 194, 17}, lineThickness = 0.75, extent = {{-51, 25}, {51, -25}}, textString = "udFilterPu"), Text(origin = {-173, -124}, lineColor = {245, 194, 17}, lineThickness = 0.75, extent = {{-51, 24}, {51, -24}}, textString = "uqFilterPu"), Text(origin = {159, 58}, lineColor = {28, 113, 216}, extent = {{-35, 18}, {35, -18}}, textString = "idPccPu"), Text(origin = {157, -4}, lineColor = {28, 113, 216}, extent = {{-35, 18}, {35, -18}}, textString = "iqPccPu")}, coordinateSystem(extent = {{-100, -180}, {100, 180}})));
end RLConnection;