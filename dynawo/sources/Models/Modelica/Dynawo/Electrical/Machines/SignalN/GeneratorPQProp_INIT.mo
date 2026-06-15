within Dynawo.Electrical.Machines.SignalN;
model GeneratorPQProp_INIT "Initialisation model for generator PQ based on SignalN for the frequency handling and with a proportional reactive power regulation"
  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

equation
  if QGenRaw0Pu <= QMinPu then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMinPu;
  elseif QGenRaw0Pu >= QMaxPu then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMaxPu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  annotation(preferredView = "text");
end GeneratorPQProp_INIT;
