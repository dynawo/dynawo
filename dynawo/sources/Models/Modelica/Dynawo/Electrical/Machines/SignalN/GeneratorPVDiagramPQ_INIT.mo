within Dynawo.Electrical.Machines.SignalN;
model GeneratorPVDiagramPQ_INIT "Initialisation model for generator PV based on SignalN for the frequency handling and with a diagram for handling the reactive power limits. In this model, QNomAlt is calculated using QMax0."
  extends BaseClasses_INIT.BaseGeneratorSignalNPQDiagram_INIT;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu URef0Pu "Start value of the voltage regulation set point in pu (base UNom)";

  Types.ReactivePower QNomAlt "Nominal reactive power of the generator on alternator side in Mvar";

equation
  if QGenRaw0Pu <= QMin0Pu and U0Pu >= URef0Pu then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMin0Pu;
  elseif QGenRaw0Pu >= QMax0Pu and U0Pu <= URef0Pu then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMax0Pu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  QNomAlt = QMax0;

  annotation(preferredView = "text");
end GeneratorPVDiagramPQ_INIT;
