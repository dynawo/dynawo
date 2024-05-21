within Dynawo.Electrical.Controls.Converters.InnerControls;

model CurrentSaturation

  parameter Types.CurrentModulePu Imax   "Current max thershold to limit a current's module";
  parameter Types.CurrentModulePu Imin   "Current min thershold to limit a current's module";
  parameter Types.CurrentModulePu idConvRef0Pu "start value of id to be saturated";
  parameter Types.CurrentModulePu iqConvRef0Pu "start value of iq to be saturated";
  parameter Types.CurrentModulePu idConvSatRef0Pu "start value of the satured-value of id";
  parameter Types.CurrentModulePu iqConvSatRef0Pu "start value of the satured-value of iq";  
  parameter Types.CurrentModulePu CurrentModule0 "start value of the Module of the current in dq representation idConvPu,iqConvPu";  
  parameter Types.CurrentModulePu CurrentAngle0 "start value of the Phase Angle of the current in dq representation idConvPu,iqConvPu";  
  
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start=idConvRef0Pu) "value of id to be saturated" annotation(
    Placement(visible = true, transformation(origin = {-88, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start=iqConvRef0Pu) "value of iq to be saturated" annotation(
    Placement(visible = true, transformation(origin = {-78, 70}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvSatRefPu(start=idConvSatRef0Pu) "value of the satured-value of id" annotation(
    Placement(visible = true, transformation(origin = {108, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvSatRefPu(start=iqConvSatRef0Pu) "value of the satured-value of iq" annotation(
    Placement(visible = true, transformation(origin = {118, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

 Types.PerUnit CurrentModule(start=CurrentModule0) "Module of the current in dq representation idConvPu,iqConvPu "; 
 Types.PerUnit CurrentAngle(start=CurrentAngle0) "Phase Angle of the current in dq representation idConvPu,iqConvPu "; 
 
 Types.PerUnit idConvRefFilterPu "Value of the Current idConvRefPu after a first order filter ";
 Types.PerUnit iqConvRefFilterPu "Value of the Current iqConvRefPu after a first order filter ";
 
equation

   der(idConvRefFilterPu)*0.0001+idConvRefFilterPu=idConvRefPu;
   der(iqConvRefFilterPu)*0.0001+iqConvRefFilterPu=iqConvRefPu;
  
  
 CurrentModule= sqrt(idConvRefFilterPu*idConvRefFilterPu + iqConvRefFilterPu*iqConvRefFilterPu);
 CurrentAngle=atan2(iqConvRefFilterPu,idConvRefFilterPu);
 
  if CurrentModule>Imax then
    idConvSatRefPu = Imax*cos(CurrentAngle);
    iqConvSatRefPu = Imax*sin(CurrentAngle);
  else
    if CurrentModule<Imin then
      idConvSatRefPu = Imin*cos(CurrentAngle);
      iqConvSatRefPu = Imin*sin(CurrentAngle);
    else
      idConvSatRefPu=idConvRefFilterPu;
      iqConvSatRefPu=iqConvRefFilterPu;
    end if;
  
  end if;


annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {-167, 42}, extent = {{-41, 25}, {41, -25}}, textString = "idConvRefPu"), Text(origin = {-168, 2}, extent = {{-42, 16}, {42, -16}}, textString = "iqConvRefPu"), Text(origin = {174, 54}, lineColor = {46, 194, 126}, extent = {{-56, 50}, {56, -50}}, textString = "idConvSatRefPu"), Text(origin = {175, -9}, lineColor = {46, 194, 126}, extent = {{-55, 49}, {55, -49}}, textString = "iqConvsatRefPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 2}, extent = {{-98, 84}, {98, -84}}, textString = "CurrentSaturation")}));
end CurrentSaturation;