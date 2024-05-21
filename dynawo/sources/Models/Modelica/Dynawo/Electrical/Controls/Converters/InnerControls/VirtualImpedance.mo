within Dynawo.Electrical.Controls.Converters.InnerControls;

model VirtualImpedance
  parameter Real KpRVI = 0.6 "Proportional gain of the virtual impedance";
  parameter Real SigmaXR = 10 "X/R ratio of the virtual impedance";
  parameter Real RVI0 "Start value of virtual resistance in pu (base UNom, SNom)";
  parameter Real XVI0 "Start value of virtual reactance in pu (base UNom, SNom)";
  
  
  parameter Types.PerUnit idConv0Pu "start-value of the d'axis current injected by the converter in pu (base UNom, SNom)";
  parameter Types.PerUnit iqConv0Pu "start-value of the q'axis current injected by the converter in pu (base UNom, SNom)";
  parameter Types.PerUnit DeltaVVId0 "start-value of the d'axis delta voltage virtual impedance (base UNom, SNom)";
  parameter Types.PerUnit DeltaVVIq0 "start-value of the q'axis delta voltage virtual impedance (base UNom, SNom)";
  
  Modelica.Blocks.Interfaces.RealInput idConvPu(start=idConv0Pu) "d-axis current injected by the converter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-108, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-112, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start=iqConv0Pu) "q-axis current injected by the converter in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {-116, 10}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-111, -43}, extent = {{-11, -11}, {11, 11}}, rotation = 0)));
   Modelica.Blocks.Interfaces.RealOutput DeltaVVId(start=DeltaVVId0) "d-axis delta voltage virtual impedance (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {88, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput DeltaVVIq(start=DeltaVVIq0) "q-axis delta voltage virtual impedance (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {88, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Types.PerUnit CurrentModule;
  Types.PerUnit RVI(start=RVI0) "virtual resistance in pu (base UNom, SNom)";
  Types.PerUnit XVI(start=XVI0) "virtual reactance in pu (base UNom, SNom)"; 
equation
  CurrentModule = sqrt(idConvPu * idConvPu + iqConvPu * iqConvPu);
  //"We compare the CurrentModule to the NominalCurrent"
  //The thershold virtual impedance is triggered only when I>Inom
  
  if CurrentModule > 1 then 
    RVI = KpRVI * (CurrentModule - 1);
    XVI = RVI * SigmaXR;
  else
    RVI = 0;
    XVI = 0;
  end if;
  DeltaVVId = RVI * idConvPu - XVI * iqConvPu;
  DeltaVVIq = RVI * iqConvPu + XVI * idConvPu;
  annotation(
    Icon(coordinateSystem(extent = {{-100, -90}, {100, 90}}), graphics = {Rectangle(extent = {{-100, 90}, {100, -90}}), Text(origin = {4, 2}, rotation = 180, extent = {{-106, 64}, {106, -64}}, textString = "VirtualImp."), Text(origin = {-170, 13}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-40, 13}, {40, -13}}, textString = "idConvPu"), Text(origin = {-166, -33}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-40, 13}, {40, -13}}, textString = "iqConvPu"), Text(origin = {166, 63}, extent = {{-40, 13}, {40, -13}}, textString = "DeltaVVId"), Text(origin = {166, -15}, extent = {{-40, 13}, {40, -13}}, textString = "DeltaVVIq")}));
end VirtualImpedance;