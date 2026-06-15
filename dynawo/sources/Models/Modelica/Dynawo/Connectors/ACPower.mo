within Dynawo.Connectors;
connector ACPower "Connector for AC power (described using complex V and i variables)"
  Types.ComplexVoltagePu V "Complex AC voltage";
  flow Types.ComplexCurrentPu i "Complex AC current (positive when entering the device)";

  annotation(preferredView = "text", Icon(graphics = {Rectangle(lineColor = {0, 0, 255}, fillColor = {85, 170, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 98}, {100, -102}})}, coordinateSystem(initialScale = 0.1)));
end ACPower;
