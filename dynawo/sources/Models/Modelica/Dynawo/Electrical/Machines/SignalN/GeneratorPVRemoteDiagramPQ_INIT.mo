within Dynawo.Electrical.Machines.SignalN;
model GeneratorPVRemoteDiagramPQ_INIT "Initialisation model for generator PV with a PQ diagram, based on SignalN for the frequency handling and a remote voltage regulation"
  extends BaseClasses_INIT.BaseGeneratorSignalNPQDiagram_INIT;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModulePu URef0 "Start value of the voltage regulation set point in pu (base UNom)";
  parameter Types.VoltageModulePu URegulated0 "Start value of the voltage regulated in pu (base UNom)";

equation
  if QGenRaw0Pu <= QMin0Pu and URegulated0 >= URef0 then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMin0Pu;
  elseif QGenRaw0Pu >= QMax0Pu and URegulated0 <= URef0 then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMax0Pu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  annotation(preferredView = "text");
end GeneratorPVRemoteDiagramPQ_INIT;
