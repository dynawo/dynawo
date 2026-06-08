within Dynawo.Examples.Nordic.Components.TransformerWithControl;
package BaseClasses "Base transformer models"
  extends Icons.Package;

  annotation(
    Documentation(info = "<html><head></head><body>This package contains the initialized transformer with variable tap models. These models use the initialization models of dynawo to calculate transformer parameters.<div>The calculated parameters are then assigned in an initial algorithm section.</div></body></html>"));
end BaseClasses;
