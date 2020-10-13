within OpenEMTP.Electrical.Lines.Interfaces;
model HistoryTerm "calculation of history terms for CP model"
  parameter Integer m(min = 1)=3 "Number of phases" annotation(HideResult=true);
  parameter Real h[m] annotation(HideResult=true);
  parameter Real Zmod[m] "Modified Zc" annotation(HideResult=true);
  parameter Real tau[m] "modal tau" annotation(HideResult=true);
  parameter Real Ti[m, m] "Ti" annotation(HideResult=true);
  final parameter Real kv1[m] = +((1 .- h)/2).*((1 .+ h)./Zmod) annotation(HideResult=true);
  final parameter Real kv2[m] = +((1 .+ h)/2).*((1 .+ h)./Zmod) annotation(HideResult=true);
  final parameter Real ki1[m] = -((1 .- h)/2).*h annotation(HideResult=true);
  final parameter Real ki2[m] = -((1 .+ h)/2).*h annotation(HideResult=true);
  final parameter Real Tit[m, m] = transpose(Ti) "Ti transposed" annotation(HideResult=true);
  Real sVm[m] annotation(HideResult=true);
  Real rVm[m] annotation(HideResult=true);
  Real sIhm[m] annotation(HideResult=true);
  Real rIhm[m] annotation(HideResult=true);
  Real dsVm[m] annotation(HideResult=true);
  Real drVm[m] annotation(HideResult=true);
  Real dsIhm[m] annotation(HideResult=true);
  Real drIhm[m] annotation(HideResult=true);
  Modelica.Blocks.Interfaces.RealInput sV[m] annotation (
    Placement(visible = true, transformation(origin = {-118, 52}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -71}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput rV[m] annotation (
    Placement(visible = true, transformation(origin = {120, 48}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sIh[m] annotation (
    Placement(visible = true, transformation(origin = {-100, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput rIh[m] annotation (
    Placement(visible = true, transformation(origin = {120, -44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {110, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation

  sVm = Tit * sV;
  rVm = Tit * rV;
  sIh = Ti  * sIhm;
  rIh = Ti  * rIhm;

  for i in 1:m loop
    if time < tau[i] then
      dsVm[i]  = 0;
      drVm[i]  = 0;
      dsIhm[i] = 0;
      drIhm[i] = 0;
    else
      dsVm[i]  = delay(sVm[i],  tau[i]);
      drVm[i]  = delay(rVm[i],  tau[i]);
      dsIhm[i] = delay(sIhm[i], tau[i]);
      drIhm[i] = delay(rIhm[i], tau[i]);
    end if;

  end for;

  sIhm = kv1 .* dsVm + ki1 .* dsIhm + kv2 .* drVm + ki2 .* drIhm;
  rIhm = kv1 .* drVm + ki1 .* drIhm + kv2 .* dsVm + ki2 .* dsIhm;

  annotation (
    Icon(graphics = {Rectangle(origin = {-10, 11}, extent = {{-90, 89}, {110, -111}}), Text(origin = {-72,-78}, extent = {{-18, 22}, {12, -8}}, textString = "kV"), Text(origin = {76, -76}, extent = {{-22, 18}, {12, -8}}, textString = "mV"), Text(origin = {-86, 80}, extent = {{-12, 8}, {32, -20}}, textString = "kIh"), Text(origin = {80, 68}, extent = {{-28, 18}, {12, -8}}, textString = "mIh"), Text(origin = {-20, 10}, extent = {{-48, 26}, {78, -42}}, textString = "HistoryTerm")}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.3")));
end HistoryTerm;
