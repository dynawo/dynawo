within Dynawo.Electrical.Buses;
model InfiniteBus "Infinite bus"
  extends AdditionalIcons.Bus;

  Dynawo.Connectors.ACPower terminal annotation(
    Placement(visible = true, transformation(origin = {0, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  parameter Types.PerUnit UPu "Infinite bus constant voltage module";
  parameter Types.Angle UPhase "Infinite bus constant voltage angle";
  parameter Types.VoltageModule UNom = 1.0 "Nominal voltage in kV";

  Types.VoltageModulePu UPuVar "Voltage amplitude at terminal in pu (base UNom)";
  Types.Angle UPhaseVar "Voltage angle at terminal in rad";
  Types.VoltageModule U "Voltage amplitude at terminal in kV";

equation
  terminal.V = UPu * ComplexMath.exp(ComplexMath.j * UPhase);
  UPuVar = UPu;
  UPhaseVar = UPhase;
  U = UPu * UNom;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The InfiniteBus model imposes a complex voltage value: the bus voltage magnitude and angle will remain constant throughout the simulation.</body></html>"));
end InfiniteBus;
