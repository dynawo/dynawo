within Dynawo.Examples.GridForming;

model VI


parameter Real KpRVI=0.6;
parameter Real SigmaXR=10;

  Modelica.Blocks.Interfaces.RealInput idConvPu annotation(
    Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu annotation(
    Placement(visible = true, transformation(origin = {-116, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-111, -43}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPu annotation(
    Placement(visible = true, transformation(origin = {-126, -58}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {0, 100}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealOutput DeltaVVId annotation(
    Placement(visible = true, transformation(origin = {88, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput DeltaVVIq annotation(
    Placement(visible = true, transformation(origin = {88, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Types.PerUnit CurrentModule(start = 0);


Types.PerUnit RVI;
Types.PerUnit XVI;
equation
  
  
  CurrentModule= sqrt(idConvPu*idConvPu + iqConvPu*iqConvPu);

  if CurrentModule>1 then
    RVI=KpRVI*(CurrentModule-1);
    XVI=RVI*SigmaXR;
  else
    RVI=0;
    XVI=0;
  end if;

DeltaVVId = RVI*idConvPu -  XVI*iqConvPu;
DeltaVVIq = RVI*iqConvPu +  XVI*idConvPu;


annotation(
    Icon(coordinateSystem(extent = {{-100, -90}, {100, 90}}), graphics = {Rectangle(extent = {{-100, 90}, {100, -90}}), Text(origin = {4, 2}, rotation = 180, extent = {{-106, 64}, {106, -64}}, textString = "VirtualImp."), Text(origin = {-170, 13}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-40, 13}, {40, -13}}, textString = "idConvPu"), Text(origin = {-166, -33}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-40, 13}, {40, -13}}, textString = "iqConvPu"), Text(origin = {52, 121}, rotation = 180, extent = {{-40, 13}, {40, -13}}, textString = "omegaPu"), Text(origin = {168, 51}, extent = {{-40, 13}, {40, -13}}, textString = "DeltaVVId"), Text(origin = {166, -23}, extent = {{-40, 13}, {40, -13}}, textString = "DeltaVVIq")}));
end VI;