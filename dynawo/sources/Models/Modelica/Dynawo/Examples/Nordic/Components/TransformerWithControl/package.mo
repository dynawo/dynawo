within Dynawo.Examples.Nordic.Components;
package TransformerWithControl "Controlled transformer frame of the Nordic 32 test system"
  extends Icons.Package;

  annotation(
    Documentation(info = "<html><head></head><body>This package contains the regulated transformer models used in the Nordic 32 test system. They are implemented as a transformer frame model, where the transformer and its LTC is already connected, parameterized and initialized.<div>The frame model only requires initial load flow values and the transformer preset.</div></body></html>"));
end TransformerWithControl;
