within Dynawo.Examples.Nordic;
package Grid "Grid models of the Nordic 32 test system"
  extends Icons.Package;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body>The Grid package contains grid models of the Nordic 32 test system. It implements a modular approach, where components like loads, buses and lines are separated from another. The final Nordic 32 test system grid model is constructed by extending base models.</body></html>"));
end Grid;
