within OpenEMTP.Examples.IEEE13Bus;
model PlugToPlug_a
  parameter Integer m(final min = 1) = 2 "Number of phases in input";
  parameter Integer k(final min = 1) = 1 "Number of phases in output";
  parameter Integer n[k] = {1} "Selecte the index phases";
  // Real C[m,k];
  Modelica.Electrical.MultiPhase.Interfaces.PositivePlug positivePlugIn(m = m) annotation(
    Placement(visible = true, transformation(origin = {-62, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Interfaces.NegativePlug positivePlugOut(m = k) annotation(
    Placement(visible = true, transformation(origin = {16, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  for q in 1:k loop
    positivePlugOut.pin[q].v = positivePlugIn.pin[n[q]].v;
  end for;
  positivePlugIn.pin[1].i = -positivePlugOut.pin[1].i;
  positivePlugIn.pin[2].i = 0;

//  for q in 1:m loop
//    for j in 1:k loop
//      if q == n[j] then
//        positivePlugIn.pin[q].i = -positivePlugOut.pin[n[j]].i;
//      else
//        positivePlugIn.pin[q].i = 0;
//      end if;
//    end
//  end for;
//for q in 1:m loop
//  for j in 1:k loop
//    if q==n[j] then
//      C[q,j]=1;
//       else
//        C[q,j]=0;
//         end if;
//  end for;
// if  sum(C[q,:])==0 then        positivePlugIn.pin[q].i =0 ;
// end if;
//   end for;
//positivePlugIn.pin[2].i =0;
  annotation(
    uses(Modelica(version = "3.2.2")),
    Icon(graphics = {Rectangle(origin = {-18, 14}, extent = {{-12, 2}, {48, -32}}), Text(origin = {32, -26}, extent = {{-12, 6}, {12, -6}}, textString = "out[k]"), Text(origin = {-32, -24}, extent = {{-10, 6}, {10, -6}}, textString = "in[m]")}, coordinateSystem(initialScale = 0.1)));
end PlugToPlug_a;
