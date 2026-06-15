within Dynawo.Electrical.Machines.SignalN;
model GeneratorPVRemote_INIT "Initialisation model for generator PV based on SignalN for the frequency handling and a remote voltage regulation"
  extends BaseClasses_INIT.BaseGeneratorSignalN_INIT;
  extends AdditionalIcons.Init;

  parameter Types.VoltageModule URef0 "Start value of the voltage regulation set point in kV";
  parameter Types.VoltageModule URegulated0 "Start value of the regulated voltage in kV";

equation
  if QGenRaw0Pu <= QMinPu and URegulated0 >= URef0 then
    qStatus0 = QStatus.AbsorptionMax;
    QGen0Pu = QMinPu;
  elseif QGenRaw0Pu >= QMaxPu and URegulated0 <= URef0 then
    qStatus0 = QStatus.GenerationMax;
    QGen0Pu = QMaxPu;
  else
    qStatus0 = QStatus.Standard;
    QGen0Pu = QGenRaw0Pu;
  end if;

  annotation(preferredView = "text");
end GeneratorPVRemote_INIT;
