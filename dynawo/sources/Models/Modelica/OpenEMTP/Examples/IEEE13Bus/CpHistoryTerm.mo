within OpenEMTP.Examples.IEEE13Bus;
model CpHistoryTerm
  parameter Integer m "Number of phases";
  parameter Real h[m] "Whatever";
  parameter Real Zmod[m] "Modified Zc";
  parameter Real tau[m] "modal tau";
  parameter Real Ti[m, m] "Ti";
  Real sVm[m];
  Real rVm[m];
  Real sIhm[m];
  Real rIhm[m];
  Real dsVm[m];
  Real drVm[m];
  Real dsIhm[m];
  Real drIhm[m];
  Real kv1[m] = +((1 .- h)/2).*((1 .+ h)./Zmod);
  Real kv2[m] = +((1 .+ h)/2).*((1 .+ h)./Zmod);
  Real ki1[m] = -((1 .- h)/2).*h;
  Real ki2[m] = -((1 .+ h)/2).*h;
  Real Tit[m, m] = transpose(Ti) "Ti transposed";

  Modelica.Blocks.Interfaces.RealInput sV[m] annotation(
    Placement(visible = true, transformation(origin = {-80, 44}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-70, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput rV[m] annotation(
    Placement(visible = true, transformation(origin = {76, 40}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {70, -10}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput sIh[m] annotation(
    Placement(visible = true, transformation(origin = {-74, -6}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-70, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput rIh[m] annotation(
    Placement(visible = true, transformation(origin = {94, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = { 70, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
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

  annotation(
    Icon(graphics = {Rectangle(origin = {-10, 11}, extent = {{-60, 69}, {78, -51}}), Text(origin = {-48, -12}, extent = {{-12, 8}, {12, -8}}, textString = "sV"), Text(origin = {48, -12}, extent = {{-12, 8}, {12, -8}}, textString = "rV"), Text(origin = {-48, 48}, extent = {{-12, 8}, {12, -8}}, textString = "sIh"), Text(origin = {48,48}, extent = {{-12, 8}, {12, -8}}, textString = "rIh")}, coordinateSystem(initialScale = 0.1)),
    uses(Modelica(version = "3.2.2")));
end CpHistoryTerm;
