within OpenEMTP.Electrical.Sources;
model mPhaseCosineVoltage "Multiphase cosine voltage source"
 extends OpenEMTP.Interfaces.MultiPhase.OnePort;
 parameter Real Vm[m]( each unit="kV RMSLL")= {230,230,230} "Ampltitude of voltage" annotation(HideResult=true);
 parameter SI.Frequency f[m]=fill(60, m) "Frequency" annotation(HideResult=true);
 parameter SI.Angle Phase[m]=-
      Modelica.Electrical.MultiPhase.Functions.symmetricOrientation(m)  "phase angle" annotation(HideResult=true);
 parameter SI.Time StartTime[m]={0,0,0} "start time, if t < t_start, the source is shorted" annotation(HideResult=true);
 parameter SI.Time StopTime[m]= {1,1,1} "stop time, if t > t_stop, the source is shorted"
                                                                                         annotation(HideResult=true);
equation
 for p in 1: m loop
   if time < StartTime[p] or time > StopTime[p] then v[p]=0; else
  v[p]=Vm[p]*1000*sqrt(2/3)*cos(2*C.pi*f[p]*time+Phase[p]);
   end if;
 end for;
  annotation (    Documentation(info = "<html><head></head><body><p><br></p>
</body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2019-12-29 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),defaultComponentName = "AC",
    Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics={Line(
          points={{-71,70},{-68.4,69.8},{-63.5,67},{-58.6,61},{-53.6,52},{-48,
              38.6},{-40.98,18.6},{-26.21,-26.9},{-19.9,-44},{-14.2,-56.2},{-9.3,
              -64},{-4.4,-68.6},{0.5,-70},{5.5,-67.9},{10.4,-62.5},{15.3,-54.1},
              {20.9,-41.3},{28,-21.7},{35,0}},
          color={192,192,192},
          smooth=Smooth.Bezier), Line(points={{35,0},{44.8,29.9},{51.2,46.5},
              {56.8,58.1},{61.7,65.2},{66.7,69.2},{71.6,69.8}}, color={192,
              192,192}), Ellipse(origin = {23, 24}, lineColor = {0, 0, 255}, extent = {{-83, -80}, {39, 38}}, endAngle = 360),  Line(origin = {79.6204, -0.948905}, points = {{16, 0}, {-16, 0}, {-170, 0}}, color = {0, 0, 255}), Text(origin = {-77, 31}, lineColor = {0, 0, 255}, extent = {{-23, 21}, {23, -21}}, textString = "+"), Text(origin = {-21, 102}, lineColor = {0, 0, 255}, extent = {{-55, 26}, {87, -44}}, textString = "%name")}),
    Diagram(coordinateSystem(preserveAspectRatio = false), graphics={Line(points={{-80,-90},{-80,84}}, color={
          192,192,192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 100}, {-86, 84}, {-74, 84}, {-80, 100}}), Line(points = {{-99, -40}, {100, -40}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{100, -40}, {84, -34}, {84, -46}, {100, -40}}), Line(points = {{-41, 78}, {-38, 78}, {-35.42, 74.6}, {-31.201, 67.7}, {-26.98, 57.4}, {-22.16, 42.1}, {-16.1, 19.2}, {-3.5, -32.8}, {2, -52.2}, {6.8, -66.2}, {11, -75.1}, {15.2, -80.4}, {19.5, -82}, {23.7, -79.6}, {27.9, -73.5}, {32.1, -63.9}, {36.9, -49.2}, {43, -26.8}, {49, -2}, {49, -2}, {57.4, 32.2}, {62.9, 51.1}, {67.7, 64.4}, {71.9, 72.6}, {76.1, 77.1}, {80, 78}}, thickness = 0.5), Line(points = {{-41, -2}, {-80, -2}}, thickness = 0.5), Line(points = {{-41, -2}, {-41, -40}}, color = {192, 192, 192}, pattern = LinePattern.Dash), Text(lineColor = {160, 160, 164}, extent = {{-60, -43}, {-14, -61}}, textString = "startTime"), Text(lineColor = {160, 160, 164}, extent = {{76, -52}, {100, -72}}, textString = "time"), Line(points = {{-8, 78}, {45, 78}}, color = {192, 192, 192}, pattern = LinePattern.Dash), Line(points = {{-41, -2}, {52, -2}}, color = {192, 192, 192}, pattern = LinePattern.Dash), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{33, 78}, {30, 65}, {37, 65}, {33, 78}}), Text(lineColor = {160, 160, 164}, extent = {{37, 57}, {83, 39}}, textString = "V"), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{33, -2}, {30, 11}, {36, 11}, {33, -2}, {33, -2}}), Line(points = {{33, 78}, {33, -2}}, color = {192, 192, 192}), Text(lineColor = {160, 160, 164}, extent = {{-69, 109}, {-4, 83}}, textString = "v = p.v - n.v"), Line(origin = {0.510949, 0},points = {{-41, 78}, {-41, -2}}, thickness = 0.5), Line(origin = {120.365, 2.33577}, points = {{-41, 78}, {-41, -2}}, thickness = 0.5), Line(origin = {160.565, 2.36258}, points = {{-69, -2}, {-80, -2}}, thickness = 0.5)}),
    Documentation(revisions="<html>
<ul>
<li>Initially implemented by Christian Kral on 2013-05-14</li>
</ul>
</html>", info="<html>
<p>This voltage source uses the corresponding signal source of the Modelica.Blocks.Sources package. Care for the meaning of the parameters in the Blocks package. Furthermore, an offset parameter is introduced, which is added to the value calculated by the blocks source. The startTime parameter allows to shift the blocks source behavior on the time axis.</p>
</html>"),
 __OpenModelica_commandLineOptions = "");
end mPhaseCosineVoltage;
