within Dynawo.Examples.RVS.Components.StaticVarCompensators.Util;

model SVarCVPropInterface
  import Modelica;
  import Dynawo;
  
  extends Dynawo.Examples.RVS.Components.StaticVarCompensators.Util.SVarCPVProp;

  Modelica.Blocks.Interfaces.RealInput BVarPu_in annotation(
    Placement(visible = true, transformation(origin = {-100, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPu_out annotation(
    Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  UPu_out = UPu;
  BVarPu = BVarPu_in;

end SVarCVPropInterface;
