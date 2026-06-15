within Dynawo.Electrical.Machines.SignalN;
model GeneratorPVQNomAltPar_INIT "Initialisation model for generator PV based on SignalN for the frequency handling. In this model, QNomAlt is a parameter."
  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

  parameter Types.ReactivePower QNomAlt "Nominal reactive power of the generator on alternator side in Mvar";
  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";

  Dynawo.Connectors.ReactivePowerPuConnector QStator0Pu "Start value of stator reactive power in pu (base QNomAlt) (generator convention)";
  Dynawo.Connectors.VoltageModulePuConnector URef0PuVar "Start value of the voltage regulation set point in pu (base UNom)";

equation
  if QGenRaw0Pu <= QMinPu and U0Pu >= URef0Pu then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMinPu;
  elseif QGenRaw0Pu >= QMaxPu and U0Pu <= URef0Pu then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMaxPu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  URef0PuVar = URef0Pu;
  QStator0Pu = QGen0Pu * SystemBase.SnRef / QNomAlt;

  annotation(preferredView = "text");
end GeneratorPVQNomAltPar_INIT;
