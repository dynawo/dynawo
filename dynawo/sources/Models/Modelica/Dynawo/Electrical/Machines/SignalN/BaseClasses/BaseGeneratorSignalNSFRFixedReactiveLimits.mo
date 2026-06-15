within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseGeneratorSignalNSFRFixedReactiveLimits "Base dynamic model for generators based on SignalN for the frequency handling with fixed reactive limits and that participate in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGeneratorSignalNSFR;
  extends BaseClasses.BaseFixedReactiveLimits;

  annotation(preferredView = "text");
end BaseGeneratorSignalNSFRFixedReactiveLimits;
