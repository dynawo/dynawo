within OpenEMTP.Electrical.Lines.Interfaces;
model SP_HistoryTerm "History calc. of Single Phase Transmission Line CP Model"
  parameter Real h annotation(HideResult=true);
  parameter Real Zmod "Modified Zc" annotation(HideResult=true);
  parameter Real tau "modal tau" annotation(HideResult=true);

  final parameter Real kv1 = +((1 - h)/2) * ((1 + h)/Zmod) annotation(HideResult=true);
  final parameter Real kv2 = +((1 + h)/2) * ((1 + h)/Zmod) annotation(HideResult=true);
  final parameter Real ki1 = -((1 - h)/2)*h annotation(HideResult=true);
  final parameter Real ki2 = -((1 + h)/2)*h annotation(HideResult=true);

  Real dsV  "sending-end voltage with delay tau" annotation(HideResult=true);
  Real drV  "receiving-end voltage with delay tau" annotation(HideResult=true);
  Real dsIh annotation(HideResult=true);
  Real drIh annotation(HideResult=true);
  Modelica.Blocks.Interfaces.RealInput sV annotation(HideResult=true,
    Placement(visible = true, transformation(origin = {-118, 52}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -71}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput rV annotation(HideResult=true,
    Placement(visible = true, transformation(origin = {120, 48}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sIh annotation(HideResult=true,
    Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput rIh annotation(HideResult=true,
    Placement(visible = true, transformation(origin = {120, -44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  if time < tau then
      dsV  = 0;
      drV  = 0;
      dsIh = 0;
      drIh = 0;
    else
      dsV  = delay(sV,  tau);
      drV  = delay(rV,  tau);
      dsIh = delay(sIh, tau);
      drIh = delay(rIh, tau);
  end if;
  sIh = kv1 * dsV + ki1 * dsIh + kv2 * drV + ki2 * drIh;
  rIh = kv1 * drV + ki1 * drIh + kv2 * dsV + ki2 * dsIh;
annotation (
    Icon(graphics = {Rectangle(lineColor = {0, 0, 255}, extent = {{-100, 100}, {100, -100}}), Text(origin = {-20, 10}, extent = {{-48, 26}, {78, -42}}, textString = "SP_HistoryTerm"), Text(origin = {80, 68}, extent = {{-28, 18}, {12, -8}}, textString = "mIh"), Text(origin = {-72, -78}, extent = {{-18, 22}, {12, -8}}, textString = "kV"), Text(origin = {-86, 80}, extent = {{-12, 8}, {32, -20}}, textString = "kIh"), Text(origin = {76, -76}, extent = {{-22, 18}, {12, -8}}, textString = "mV")}));
end SP_HistoryTerm;
