within Dynawo.Electrical.Controls.Machines;
package VoltageRegulators "Voltage regulators"
  extends Icons.Package;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body>This package contains different voltage regulators models and is organized into two subpackages:<div><ul><li><a href=\"modelica://Dynawo.Electrical.Controls.Machines.VoltageRegulators.Simplified\">\"Simplified\"</a> for simplified/equivalent voltage regulator models used for large-scale voltage stability studies for example.</li><li><a href=\"modelica://Dynawo.Electrical.Controls.Machines.VoltageRegulators.Standard\">\"Standard\"</a> for standard voltage regulator models (inherited from IEEE norms for example), that can for instance be used for transient stability studies.&nbsp;</li></ul></div></body></html>"));
end VoltageRegulators;
