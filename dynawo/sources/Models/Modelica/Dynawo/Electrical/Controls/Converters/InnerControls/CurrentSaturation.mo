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
  parameter Real W_CurrentLimit "Bandwidth of the current limitation";
  Modelica.Blocks.Interfaces.RealInput idConvRefPu(start=idConvRef0Pu) "value of id to be saturated" annotation(
    Placement(visible = true, transformation(origin = {-88, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqConvRefPu(start=iqConvRef0Pu) "value of iq to be saturated" annotation(
    Placement(visible = true, transformation(origin = {-122, 16}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput idConvSatRefPu(start=idConvSatRef0Pu) "value of the satured-value of id" annotation(
    Placement(visible = true, transformation(origin = {108, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvSatRefPu(start=iqConvSatRef0Pu) "value of the satured-value of iq" annotation(
    Placement(visible = true, transformation(origin = {118, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

 Types.PerUnit IConvRefFilterModulePu(start=CurrentModule0) "Module of the current in dq representation idConvRefPu,iqConvRefPu ";
 Types.PerUnit IConvRefFilterAnglePu(start=CurrentAngle0) "Phase Angle of the current in dq representation idConvRefPu,iqConvRefPu ";
 Types.PerUnit CurrentModulePcc(start=CurrentModule0) "Module of the current in dq representation idPccPu,iqPccPu ";
 Real BlocCurrentSaturation_Enable ;

 Types.PerUnit idConvRefFilterPu "Value of the Current idConvRefPu after a first order filter ";
 Types.PerUnit iqConvRefFilterPu "Value of the Current iqConvRefPu after a first order filter ";
 Types.PerUnit iConvSatRefModulePu "Value of the Current saturated given as reference to the voltage control in Pu";
 Modelica.Blocks.Interfaces.RealInput idPcc(start = idConvRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-120, -34}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-34, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
 Modelica.Blocks.Interfaces.RealInput iqPcc(start = idConvRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -24}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {56, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
equation

//Il faut ajouter un filtre sinon la sortie est n'importe quoi

  der(idConvRefFilterPu)*1/W_CurrentLimit+idConvRefFilterPu=idConvRefPu;
  der(iqConvRefFilterPu)*1/W_CurrentLimit+iqConvRefFilterPu=iqConvRefPu;


 IConvRefFilterModulePu= sqrt(idConvRefFilterPu*idConvRefFilterPu + iqConvRefFilterPu*iqConvRefFilterPu);
 IConvRefFilterAnglePu=atan2(iqConvRefFilterPu,idConvRefFilterPu);


 CurrentModulePcc= sqrt(idPcc*idPcc + iqPcc*iqPcc);

 //CurrentModulePcc= sqrt((der(idPcc)*1/W_CurrentLimit+idPcc)^2+ (der(iqPcc)*1/W_CurrentLimit+iqPcc)^2);

 //Activation of the bloc current saturation is donne by reading IPcc Module and the current of reference to be sent to the current controller bloc it is done this way to act faster
  if IConvRefFilterModulePu>Imax or CurrentModulePcc>Imax then
      BlocCurrentSaturation_Enable=1;
      idConvSatRefPu = Imax*cos(IConvRefFilterAnglePu);
      iqConvSatRefPu = Imax*sin(IConvRefFilterAnglePu);
  else
      BlocCurrentSaturation_Enable=0;
    if CurrentModulePcc<Imin then
      idConvSatRefPu = Imin*cos(IConvRefFilterAnglePu);
      iqConvSatRefPu = Imin*sin(IConvRefFilterAnglePu);
    else
      idConvSatRefPu=idConvRefFilterPu;
      iqConvSatRefPu=iqConvRefFilterPu;
    end if;

  end if;

  iConvSatRefModulePu= sqrt(idConvSatRefPu^2+iqConvSatRefPu^2);

annotation(
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Text(origin = {-167, 42}, extent = {{-41, 25}, {41, -25}}, textString = "idConvRefPu"), Text(origin = {-168, 2}, extent = {{-42, 16}, {42, -16}}, textString = "iqConvRefPu"), Text(origin = {174, 54}, lineColor = {46, 194, 126}, extent = {{-56, 50}, {56, -50}}, textString = "idConvSatRefPu"), Text(origin = {175, -9}, lineColor = {46, 194, 126}, extent = {{-55, 49}, {55, -49}}, textString = "iqConvsatRefPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {2, 2}, extent = {{-98, 84}, {98, -84}}, textString = "CurrentSaturation"), Text(origin = {-28, -132}, extent = {{-42, 16}, {42, -16}}, textString = "idPcc"), Text(origin = {78, -132}, extent = {{-42, 16}, {42, -16}}, textString = "iqPcc")}));



end CurrentSaturation;
