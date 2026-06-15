within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseGeneratorSignalNSFRDiagramPQ "Base dynamic model for generators based on SignalN for the frequency handling with a PQ diagram and that participate in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGeneratorSignalNSFR;
  extends BaseClasses.BaseDiagramPQ;

equation
  PGenPu = tableQMin.u[1];
  PGenPu = tableQMax.u[1];

  annotation(preferredView = "text");
end BaseGeneratorSignalNSFRDiagramPQ;
