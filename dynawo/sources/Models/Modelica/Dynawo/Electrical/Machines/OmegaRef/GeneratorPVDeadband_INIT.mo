within Dynawo.Electrical.Machines.OmegaRef;

model GeneratorPVDeadband_INIT "Initialisation model for generator PV with deadband"
  extends Dynawo.Electrical.Machines.BaseClasses_INIT.BaseGeneratorParameters_INIT;
  extends AdditionalIcons.Init;

  parameter Types.PerUnit LambdaPuSNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SNom)";
  parameter Types.ApparentPowerModule SNom "Apparent nominal power in MVA";
  parameter Types.VoltageModulePu UDeadbandLowPu = 0.98 "Lower deadband threshold for voltage regulation (pu, base UNom)";
  parameter Types.VoltageModulePu UDeadbandHighPu = 1.02 "Upper deadband threshold for voltage regulation (pu, base UNom)";

  final parameter Types.PerUnit LambdaPu = LambdaPuSNom * SystemBase.SnRef / SNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SnRef)";

  Dynawo.Connectors.VoltageModulePuConnector URef0Pu "Initial voltage regulation set point in pu (base UNom)";

equation
  URef0Pu = U0Pu + LambdaPu * QGen0Pu;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>Initialisation model for GeneratorPVDeadband, with deadband on voltage regulation.</body></html>"));
end GeneratorPVDeadband_INIT;
