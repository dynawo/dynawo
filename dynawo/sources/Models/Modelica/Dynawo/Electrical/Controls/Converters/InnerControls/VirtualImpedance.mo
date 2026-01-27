within Dynawo.Electrical.Controls.Converters.InnerControls;

model VirtualImpedance

  parameter Real Imax_XVI  "Proportional gain of the virtual impedance";
  parameter Real SigmaXR "X/R ratio of the virtual impedance";
  parameter Real RVI0 "Start value of virtual resistance in pu (base UNom, SNom)";
  parameter Real XVI0 "Start value of virtual reactance in pu (base UNom, SNom)";
  parameter Real XVInduct "Virtual Impedance added in line between the Filter and the Transformer";
  parameter Real Ith_XVI "Thershold current that activates the block XVI";
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
  Real BlocCurrentXVIThershold_Enable "1 if Virtual Impedance Bloc  is enable";
  //Variables to calculate KpRVI
  Real Lvi0;
  Real Rvi0;
  Real a;
  Real b;
  Real V0;
  Real c;
  Real KpRVI;

equation
  CurrentModule = sqrt(idConvPu * idConvPu + iqConvPu * iqConvPu);
  //"We compare the CurrentModule to the NominalCurrent"
  //The thershold virtual impedance is triggered only when I>Inom



  Lvi0=6/100;
  Rvi0=Lvi0/10;
  a=(Imax_XVI-Ith_XVI)^2*(1+SigmaXR^2);
  b=2*(Imax_XVI-Ith_XVI)*(Rvi0+SigmaXR*Lvi0);
  V0=1;
  c=Rvi0^2+Lvi0^2-(V0/Imax_XVI)^2;
  KpRVI=(-b+sqrt(b^2-4*a*c))/(2*(a));

  //Hysteresis of 0.0002 added
 if   (CurrentModule >= (Ith_XVI + 0.002)) then // if CurrentModule > Imax_XVI then
    BlocCurrentXVIThershold_Enable=1;
    RVI = KpRVI * (CurrentModule - Ith_XVI);
    XVI = RVI * SigmaXR;
  elseif ((Ith_XVI - 0.002) >= CurrentModule) then
    BlocCurrentXVIThershold_Enable=0;
    RVI = 0;//Hopping that not linearization problems will be found /0
    XVI = 0;
  else
    BlocCurrentXVIThershold_Enable=2;
    RVI = RVI;
    XVI = XVI;
  end if;
    //Here we add directly the X virtual inductance (XVInductj) to the (RVI + XVIj)
    DeltaVVId = RVI * idConvPu - (XVI +XVInduct)* iqConvPu;
    DeltaVVIq = RVI * iqConvPu + (XVI+XVInduct) * idConvPu;

  annotation(
    Icon(coordinateSystem(extent = {{-100, -90}, {100, 90}}), graphics = {Rectangle(extent = {{-100, 90}, {100, -90}}), Text(origin = {4, 2}, rotation = 180, extent = {{-106, 64}, {106, -64}}, textString = "VirtualImp."), Text(origin = {-170, 13}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-40, 13}, {40, -13}}, textString = "idConvPu"), Text(origin = {-166, -33}, lineColor = {134, 94, 60}, lineThickness = 0.75, extent = {{-40, 13}, {40, -13}}, textString = "iqConvPu"), Text(origin = {166, 63}, extent = {{-40, 13}, {40, -13}}, textString = "DeltaVVId"), Text(origin = {166, -15}, extent = {{-40, 13}, {40, -13}}, textString = "DeltaVVIq")}),
    Documentation(info = "<html><head></head><body>Calculation of KPI is detailed in : Virtual Impedance Current Limiting for Inverters in &nbsp;Microgrids with Synchronous Generators , paper&nbsp;</body></html>"));


end VirtualImpedance;
