within Dynawo.Examples.GridForming;

model Filter_v1


  import Modelica;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;
  parameter Real LFilter=0.1;
  parameter Real RFilter=0.1;
  parameter Real CFilter=0.1;
  
  Modelica.Blocks.Interfaces.RealInput udConvPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-200, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-190, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqConvPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-200, 24}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-190, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-200, -8}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-190, -22}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {-200, -44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-190, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu (start=SystemBase.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-198, -82}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-190, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Interfaces.RealOutput idPccPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {170, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-10, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqPccPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {170, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-10, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvPu (start=0)  annotation(
    Placement(visible = true, transformation(origin = {170, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-10, -54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvPu (start=0) annotation(
    Placement(visible = true, transformation(origin = {168, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-10, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));  equation 

  /* RLC Filter */
    LFilter / SystemBase.omegaNom * der(idConvPu) = udConvPu - RFilter * idConvPu + omegaPu * LFilter * iqConvPu - udFilterPu;
    LFilter / SystemBase.omegaNom * der(iqConvPu) = uqConvPu - RFilter * iqConvPu - omegaPu * LFilter * idConvPu - uqFilterPu;
    CFilter / SystemBase.omegaNom * der(udFilterPu) = idConvPu + omegaPu * CFilter * uqFilterPu - idPccPu;
    CFilter / SystemBase.omegaNom * der(uqFilterPu) = iqConvPu - omegaPu * CFilter * udFilterPu - iqPccPu;
 //   IConvPu = sqrt (idConvPu * idConvPu + iqConvPu * iqConvPu);
  

annotation(
    Icon(coordinateSystem(extent = {{-180, 80}, {-20, -140}}), graphics = {Rectangle(origin = {-100, -30}, extent = {{-80, 110}, {80, -110}}), Text(origin = {-99, -27}, rotation = -90, extent = {{-43, 31}, {43, -31}}, textString = "Filter")}),
    Diagram(coordinateSystem(extent = {{-180, 80}, {160, -100}})));
end Filter_v1;