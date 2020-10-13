within OpenEMTP.Electrical.Sources;

model SurgeCurrent
 extends OpenEMTP.Interfaces.OnePort;
 parameter Real Im (unit="kA")=2.95"maximum current of the source";
 parameter Real alpha (unit="1/S")=-5000 "Alpha coefficient";
 parameter Real beta  (unit="1/S")=-46500 "Beta coefficient";
 parameter Modelica.SIunits.Time Tstart=0  ;
 parameter Modelica.SIunits.Time Tstop =10 ;
equation
if (time>=Tstart and time<=Tstop) then
 i=-Im*1e3*(exp(alpha*(time-Tstart))-exp(beta*(time-Tstart)));
else
 i=0;
end if;
  annotation (
    defaultComponentName = "Isurge", Icon(coordinateSystem(initialScale = 0.1), graphics={Line(points = {{-90, 0}, {90, 0}}, color = {0, 0, 255}), Line(points = {{-70, 30}, {-70, 10}}, color = {0, 0, 255}), Line(points = {{60, 20}, {80, 20}}, color = {0, 0, 255}), Ellipse(origin = {-2, 0}, lineColor = {0, 0, 255}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-50, 50}, {50, -50}}, endAngle = 360), Line(points = {{-80, 20}, {-60, 20}}, color = {0, 0, 255}), Line(origin = {0.379747, 0}, points = {{-76, -59}, {-73.2, -44.3}, {-70.3, -31.1}, {-66.8, -16.6}, {-63.3, -4}, {-59.7, 6.92}, {-55.5, 18.18}, {-51.3, 27.7}, {-46.3, 37}, {-40.6, 45.5}, {-34.3, 53.1}, {-27.2, 59.6}, {-18.7, 65.3}, {-8.1, 70.2}, {-6, 71}, {-3.88, 58.5}, {-1.05, 43.7}, {1.78, 30.8}, {4.606, 19.45}, {8.14, 7.3}, {11.68, -3}, {15.9, -13.2}, {20.2, -21.6}, {25.1, -29.5}, {30.8, -36.4}, {37.1, -42.3}, {44.9, -47.5}, {54.8, -51.8}, {64, -54.4}}, color = {192, 192, 192}), Text(origin = {-21, 102}, lineColor = {0, 0, 255}, extent = {{-55, 26}, {87, -44}}, textString = "%name"), Line(origin = {-1, 0}, points = {{43, 0}, {-43, 0}, {-43, 0}}, color = {0, 0, 255}), Polygon(origin = {-38, -1}, rotation = 90, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{0, 9}, {14, -9}, {-14, -9}, {0, 9}, {0, 9}})}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics={Line(points={{-100,-70},{100,-70}}, color={
          192,192,192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{100, -70}, {84, -64}, {84, -76}, {100, -70}}), Line(points = {{-40, -30}, {-37.2, -15.3}, {-34.3, -2.1}, {-30.8, 12.4}, {-27.3, 25}, {-23.7, 35.92}, {-19.5, 47.18}, {-15.3, 56.7}, {-10.3, 66}, {-4.6, 74.5}, {1.7, 82.1}, {8.8, 88.6}, {17.3, 94.3}, {27.9, 99.2}, {30, 100}, {32.12, 87.5}, {34.95, 72.7}, {37.78, 59.8}, {40.606, 48.45}, {44.14, 36.3}, {47.68, 26}, {51.9, 15.8}, {56.2, 7.4}, {61.1, -0.5}, {66.8, -7.4}, {73.1, -13.3}, {80.9, -18.5}, {90.8, -22.8}, {100, -25.4}}, thickness = 0.5), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-80, 90}, {-88, 68}, {-72, 68}, {-80, 90}}), Line(points = {{-80, 68}, {-80, -80}}, color = {192, 192, 192}), Text(lineColor = {160, 160, 164}, extent = {{-70, 91}, {-29, 71}}, textString = "outPort"), Text(lineColor = {160, 160, 164}, extent = {{-78, -43}, {-46, -56}}, textString = "offset"), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-40, -70}, {-42, -60}, {-38, -60}, {-40, -70}, {-40, -70}}), Line(points = {{-40, -30}, {-40, -60}}, color = {192, 192, 192}), Polygon(lineColor = {192, 192, 192}, fillColor = {192, 192, 192}, fillPattern = FillPattern.Solid, points = {{-40, -30}, {-42, -40}, {-38, -40}, {-40, -30}}), Line(points = {{-39, -30}, {-80, -30}}, thickness = 0.5), Text(lineColor = {160, 160, 164}, extent = {{-59, -71}, {-13, -89}}, textString = "startTime"), Text(lineColor = {160, 160, 164}, extent = {{78, -76}, {102, -96}}, textString = "time"), Line(points = {{-40, -30}, {-37.2, -15.3}, {-34.3, -2.1}, {-30.8, 12.4}, {-27.3, 25}, {-23.7, 35.92}, {-19.5, 47.18}, {-15.3, 56.7}, {-10.3, 66}, {-4.6, 74.5}, {1.7, 82.1}, {8.8, 88.6}, {17.3, 94.3}, {27.9, 99.2}, {30, 100}, {32.12, 87.5}, {34.95, 72.7}, {37.78, 59.8}, {40.606, 48.45}, {44.14, 36.3}, {47.68, 26}, {51.9, 15.8}, {56.2, 7.4}, {61.1, -0.5}, {66.8, -7.4}, {73.1, -13.3}, {80.9, -18.5}, {90.8, -22.8}, {100, -25.4}}, thickness = 0.5), Line(points = {{-40, -30}, {-80, -30}}, thickness = 0.5), Line(points = {{30, 100}, {30, -34}}, color = {192, 192, 192}, pattern = LinePattern.Dash)}),
    Documentation(revisions= "<html><head></head><body><ul style=\"font-size: 12px;\"><li><em>2020-09-22 &nbsp;&nbsp;</em>&nbsp;by Alireza Masoom initially implemented</li></ul></body></html>", info= "<html><head></head><body><p>The current source equation is given by:</p><p>&nbsp;V(t)=Vm*{exp(alpha*time)-exp(beta*time)}</p>
</body></html>"));


end SurgeCurrent;
