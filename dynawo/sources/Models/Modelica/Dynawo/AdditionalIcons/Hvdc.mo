within Dynawo.AdditionalIcons;
model Hvdc

  annotation(
    Icon(graphics = {Rectangle(origin = {1, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-61, 21}, {-21, -19}}), Line(origin = {-80, 0}, points = {{-20, 0}, {20, 0}}), Line(origin = {80, 0}, points = {{-20, 0}, {20, 0}}), Text(origin = {0, 30}, lineColor = {0, 0, 255}, extent = {{-80, 10}, {80, -10}}, textString = "%name"), Rectangle(origin = {40, 0}, extent = {{-20, 20}, {20, -20}}), Line(origin = {0, 10}, points = {{-20, 0}, {20, 0}, {20, 0}}), Line(origin = {0, -10}, points = {{-20, 0}, {20, 0}}), Line(origin = {40, 0}, points = {{-20, -20}, {20, 20}}), Line(origin = {-40, 0}, points = {{-20, -20}, {20, 20}})}, coordinateSystem(initialScale = 0.1)));
end Hvdc;
