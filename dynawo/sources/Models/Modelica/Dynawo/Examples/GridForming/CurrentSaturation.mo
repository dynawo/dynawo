within Dynawo.Examples.GridForming;

model CurrentSaturation

  parameter Types.CurrentModulePu Imax   "Current max thershold to limit a current's module";
  parameter Types.CurrentModulePu Imin  "Current min thershold to limit a current's module";
  
  
  Modelica.Blocks.Interfaces.RealInput idConvFiltre annotation(
    Placement(visible = true, transformation(origin = {-88, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvFiltre annotation(
    Placement(visible = true, transformation(origin = {-78, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvRefPu annotation(
    Placement(visible = true, transformation(origin = {108, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu annotation(
    Placement(visible = true, transformation(origin = {118, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

 Types.PerUnit CurrentModule(start = 0);
 Types.PerUnit CurrentAngle(start = 0);
 
 Real idConvPu;
 Real iqConvPu;
 
equation

   der(idConvPu)*0.0001+idConvPu=idConvFiltre;
  der(iqConvPu)*0.0001+iqConvPu=iqConvFiltre;
  
  
 CurrentModule= sqrt(idConvPu*idConvPu + iqConvPu*iqConvPu);
 CurrentAngle=atan2(iqConvPu,idConvPu);
 
  if CurrentModule>Imax then
  idConvRefPu = Imax*cos(CurrentAngle);
  iqConvRefPu = Imax*sin(CurrentAngle);
  else
    if CurrentModule<Imin then
  idConvRefPu = Imin*cos(CurrentAngle);
  iqConvRefPu = Imin*sin(CurrentAngle);
    else
    idConvRefPu=idConvPu;
    iqConvRefPu=iqConvPu;
    end if;
  
  end if;


annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {-167, 42}, extent = {{-41, 25}, {41, -25}}, textString = "idConvPu"), Text(origin = {-168, 2}, extent = {{-42, 16}, {42, -16}}, textString = "iqConvPu"), Text(origin = {174, 54}, lineColor = {46, 194, 126}, extent = {{-56, 50}, {56, -50}}, textString = "idConvRefPu"), Text(origin = {175, -9}, lineColor = {46, 194, 126}, extent = {{-55, 49}, {55, -49}}, textString = "idConvRefPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 2}, extent = {{-98, 84}, {98, -84}}, textString = "CurrentSaturation")}));
end CurrentSaturation;