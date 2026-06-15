within Dynawo.Electrical.Machines.SignalN;
model GeneratorPQPropDiagramPQSFR_INIT "Initialisation model for generator PQ with a PQ diagram, based on SignalN for the frequency handling, with a proportional reactive power regulation and that participates in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses_INIT.BaseGeneratorSignalNPQDiagram_INIT;
  extends AdditionalIcons.Init;

equation
  if QGenRaw0Pu <= QMin0Pu then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMin0Pu;
  elseif QGenRaw0Pu >= QMax0Pu then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMax0Pu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  annotation(preferredView = "text");
end GeneratorPQPropDiagramPQSFR_INIT;
