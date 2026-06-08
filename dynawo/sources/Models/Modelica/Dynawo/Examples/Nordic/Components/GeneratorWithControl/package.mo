within Dynawo.Examples.Nordic.Components;
package GeneratorWithControl "Models of generators with control for the Nordic 32 test system"
  extends Icons.Package;

  annotation(
    Documentation(info = "<html><head></head><body>This package contains the regulated generator models used in the Nordic 32 test system. They are implemented as a generator frame model, where the generator and its controllers are already connected, parameterized and initialized.<div>The frame model only requires initial load flow values and the generator preset.</div><div><div><br></div></div></body></html>"));
end GeneratorWithControl;
