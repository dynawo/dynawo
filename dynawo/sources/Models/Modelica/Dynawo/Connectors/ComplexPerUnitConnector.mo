within Dynawo.Connectors;
record ComplexPerUnitConnector = Complex(redeclare Types.PerUnit re "Real part of complex per unit quantity",
                                         redeclare Types.PerUnit im "Imaginary part of complex per unit quantity") "Complex per unit";
