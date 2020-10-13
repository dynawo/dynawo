within OpenEMTP.UserGuide;

package Icons
  extends UserGuide.Icons.IconsPackage;

  partial package Information
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Ellipse(lineColor = {75, 138, 73}, fillColor = {75, 138, 73}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-100.0, -100.0}, {100.0, 100.0}}), Polygon(origin = {-4.167, -15.0}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-15.833, 20.0}, {-15.833, 30.0}, {14.167, 40.0}, {24.167, 20.0}, {4.167, -30.0}, {14.167, -30.0}, {24.167, -30.0}, {24.167, -40.0}, {-5.833, -50.0}, {-15.833, -30.0}, {4.167, 20.0}, {-5.833, 20.0}}, smooth = Smooth.Bezier), Ellipse(origin = {7.5, 56.5}, fillColor = {255, 255, 255}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12.5, -12.5}, {12.5, 12.5}})}),
      Documentation(info = "<html>
  <p>This icon indicates classes containing only documentation, intended for general description of, e.g., concepts and features of a package.</p>
  </html>"));
  end Information;

  partial class Contact
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Rectangle(extent = {{-100, 70}, {100, -72}}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid), Polygon(points = {{-100, -72}, {100, -72}, {0, 20}, {-100, -72}}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid), Polygon(points = {{22, 0}, {100, 70}, {100, -72}, {22, 0}}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid), Polygon(points = {{-100, 70}, {100, 70}, {0, -20}, {-100, 70}}, fillColor = {241, 241, 241}, fillPattern = FillPattern.Solid)}),
      Documentation(info = "<html>
  <p>This icon shall be used for the contact information of the library developers.</p>
  </html>"));
  end Contact;

  partial class ReleaseNotes
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(points = {{-80, -100}, {-80, 100}, {0, 100}, {0, 20}, {80, 20}, {80, -100}, {-80, -100}}, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid), Polygon(points = {{0, 100}, {80, 20}, {0, 20}, {0, 100}}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid), Line(points = {{2, -12}, {50, -12}}), Ellipse(extent = {{-56, 2}, {-28, -26}}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid), Line(points = {{2, -60}, {50, -60}}), Ellipse(extent = {{-56, -46}, {-28, -74}}, fillColor = {215, 215, 215}, fillPattern = FillPattern.Solid)}),
      Documentation(info = "<html>
  <p>This icon indicates release notes and the revision history of a library.</p>
  </html>"));
  end ReleaseNotes;

  partial class References
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(points = {{-100, -80}, {-100, 60}, {-80, 54}, {-80, 80}, {-40, 58}, {-40, 100}, {-10, 60}, {90, 60}, {100, 40}, {100, -100}, {-20, -100}, {-100, -80}}, lineColor = {0, 0, 255}, pattern = LinePattern.None, fillColor = {245, 245, 245}, fillPattern = FillPattern.Solid), Polygon(points = {{-20, -100}, {-10, -80}, {90, -80}, {100, -100}, {-20, -100}}), Line(points = {{90, -80}, {90, 60}, {100, 40}, {100, -100}}), Line(points = {{90, 60}, {-10, 60}, {-10, -80}}), Line(points = {{-10, 60}, {-40, 100}, {-40, -40}, {-10, -80}, {-10, 60}}), Line(points = {{-20, -88}, {-80, -60}, {-80, 80}, {-40, 58}}), Line(points = {{-20, -100}, {-100, -80}, {-100, 60}, {-80, 54}}), Line(points = {{10, 30}, {72, 30}}), Line(points = {{10, -10}, {70, -10}}), Line(points = {{10, -50}, {70, -50}})}),
      Documentation(info = "<html>
  <p>This icon indicates a documentation class containing references to external documentation and literature.</p>
  </html>"));
  end References;

  partial class Library
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}, grid = {2, 2}), graphics = {Rectangle(extent = {{-100, -100}, {80, 50}}, lineColor = {0, 0, 255}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid), Polygon(points = {{-100, 50}, {-80, 70}, {100, 70}, {80, 50}, {-100, 50}}, lineColor = {0, 0, 255}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid), Polygon(points = {{100, 70}, {100, -80}, {80, -100}, {80, 50}, {100, 70}}, lineColor = {0, 0, 255}, fillColor = {235, 235, 235}, fillPattern = FillPattern.Solid), Text(extent = {{-120, 125}, {120, 70}}, lineColor = {255, 0, 0}, textString = "%name"), Text(extent = {{-80, 40}, {70, -80}}, lineColor = {95, 95, 95}, fillColor = {255, 255, 170}, fillPattern = FillPattern.Solid, textString = "Library")}),
      Documentation(info = ""));
  end Library;

  partial function Function "Icon for functions"
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Text(lineColor = {0, 0, 255}, extent = {{-150, 105}, {150, 145}}, textString = "%name"), Ellipse(lineColor = {108, 88, 49}, fillColor = {255, 215, 136}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(lineColor = {108, 88, 49}, extent = {{-90.0, -90.0}, {90.0, 90.0}}, textString = "f")}),
      Documentation(info = "<html>
  <p>This icon indicates Modelica functions.</p>
  </html>"));
  end Function;

  partial package InterfacesPackage
    extends Modelica.Icons.Package;
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(origin = {20.0, 0.0}, lineColor = {64, 64, 64}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, points = {{-10.0, 70.0}, {10.0, 70.0}, {40.0, 20.0}, {80.0, 20.0}, {80.0, -20.0}, {40.0, -20.0}, {10.0, -70.0}, {-10.0, -70.0}}), Polygon(fillColor = {102, 102, 102}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-100.0, 20.0}, {-60.0, 20.0}, {-30.0, 70.0}, {-10.0, 70.0}, {-10.0, -70.0}, {-30.0, -70.0}, {-60.0, -20.0}, {-100.0, -20.0}})}),
      Documentation(info = "<html>
  <p>This icon indicates packages containing interfaces.</p>
  </html>"));
  end InterfacesPackage;

  partial package Package
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(lineColor = {200, 200, 200}, fillColor = {85, 170, 255}, fillPattern = FillPattern.HorizontalCylinder, extent = {{-100, -100}, {100, 100}}, radius = 25), Rectangle(lineColor = {128, 128, 128}, extent = {{-100, -100}, {100, 100}}, radius = 25)}),
      Documentation(info = "<html>
  <p>Standard package icon.</p>
  </html>"));
  end Package;

  partial package IconsPackage
    extends UserGuide.Icons.Package;
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, extent = {{-100, -100}, {100, 100}}), graphics = {Polygon(origin = {-8.167, -17}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, points = {{-15.833, 20.0}, {-15.833, 30.0}, {14.167, 40.0}, {24.167, 20.0}, {4.167, -30.0}, {14.167, -30.0}, {24.167, -30.0}, {24.167, -40.0}, {-5.833, -50.0}, {-15.833, -30.0}, {4.167, 20.0}, {-5.833, 20.0}}, smooth = Smooth.Bezier), Ellipse(origin = {-0.5, 56.5}, fillColor = {128, 128, 128}, pattern = LinePattern.None, fillPattern = FillPattern.Solid, extent = {{-12.5, -12.5}, {12.5, 12.5}})}));
  end IconsPackage;

  partial class SubLibrary
    annotation(
      Icon(coordinateSystem(preserveAspectRatio = false, initialScale = 0.1), graphics = {Rectangle(lineColor = {95, 95, 95}, fillColor = {253, 255, 202}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {80, 50}}), Polygon(lineColor = {95, 95, 95}, fillColor = {253, 255, 202}, fillPattern = FillPattern.Solid, points = {{-100, 50}, {-80, 70}, {100, 70}, {80, 50}, {-100, 50}}), Polygon(lineColor = {95, 95, 95}, fillColor = {253, 255, 202}, fillPattern = FillPattern.Solid, points = {{100, 70}, {100, -80}, {80, -100}, {80, 50}, {100, 70}}), Text(lineColor = {95, 95, 95}, fillColor = {255, 255, 170}, fillPattern = FillPattern.Solid, extent = {{-80, 40}, {70, -80}}, textString = "MultiPhase")}),
      Documentation(info = ""));
  end SubLibrary;

  partial package Load
    annotation(
      Icon(graphics = {Rectangle(origin = {2, 17}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-4, -79}, {0, 69}}), Polygon(origin = {-1, -80}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-27, 20}, {27, 20}, {1, -20}, {1, -20}, {-27, 20}})}, coordinateSystem(initialScale = 0.1)));
  end Load;
end Icons;
