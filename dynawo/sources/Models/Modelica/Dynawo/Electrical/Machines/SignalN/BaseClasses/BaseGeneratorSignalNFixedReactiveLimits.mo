within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseGeneratorSignalNFixedReactiveLimits "Base dynamic model for generators based on SignalN for the frequency handling with fixed reactive limits and that do not participate in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGeneratorSignalN;
  extends BaseClasses.BaseFixedReactiveLimits;

  annotation(preferredView = "text");
end BaseGeneratorSignalNFixedReactiveLimits;
