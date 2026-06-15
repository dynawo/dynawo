within Dynawo.AdditionalIcons;
model Shunt

  annotation(
    Icon(graphics = {Text(origin = {-1, -120}, lineColor = {0, 0, 255}, extent = {{-81, 10}, {81, -10}}, textString = "%name"), Rectangle(origin = {0, -42}, fillPattern = FillPattern.Solid, extent = {{-40, 2}, {40, -2}}), Rectangle(origin = {-20, -62}, fillPattern = FillPattern.Solid, extent = {{-20, 2}, {60, -2}}), Line(origin = {0, -21}, points = {{0, 21}, {0, -21}}), Line(origin = {0, -100}, points = {{-40, 0}, {40, 0}}), Line(origin = {0, -81}, points = {{0, -19}, {0, 19}})}, coordinateSystem(initialScale = 0.1)));
end Shunt;
