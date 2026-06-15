within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseGeneratorSignalN "Base dynamic model for generators based on SignalN for the frequency handling and that do not participate in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGenerator;

equation
  if running then
    PGenRawPu = - PRefPu + Alpha * N;
  else
    PGenRawPu = 0;
  end if;

  annotation(preferredView = "text");
end BaseGeneratorSignalN;
