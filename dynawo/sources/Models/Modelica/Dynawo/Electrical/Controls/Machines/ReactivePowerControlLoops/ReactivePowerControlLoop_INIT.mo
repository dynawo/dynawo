within Dynawo.Electrical.Controls.Machines.ReactivePowerControlLoops;
model ReactivePowerControlLoop_INIT "Initialisation model for the Reactive Power Control Loop (RPCL)"
  extends AdditionalIcons.Init;

  Dynawo.Connectors.VoltageModulePuConnector UStatorRef0Pu "Start value of the generator stator voltage reference in pu (base UNom)";
  Dynawo.Connectors.ReactivePowerPuConnector QStator0Pu "Start value of the generator stator reactive power in pu (base QNomAlt) (generator convention)";
  Modelica.Blocks.Interfaces.BooleanInput limUQUp0 "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  Modelica.Blocks.Interfaces.BooleanInput limUQDown0 "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";

  annotation(preferredView = "text");
end ReactivePowerControlLoop_INIT;
