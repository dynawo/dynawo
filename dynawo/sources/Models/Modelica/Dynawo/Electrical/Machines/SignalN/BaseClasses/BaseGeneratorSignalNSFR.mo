within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseGeneratorSignalNSFR "Base dynamic model for generators based on SignalN for the frequency handling and that participate in the Secondary Frequency Regulation (SFR)"
  extends BaseClasses.BaseGenerator;

  parameter Types.PerUnit KSFR "Coefficient of participation in the secondary frequency regulation";

  final parameter Real AlphaSFR = PNom * KSFR "Participation of the considered generator in the secondary frequency regulation";

  input Types.PerUnit NSFR "Signal to change the active power reference setpoint of the generators participating in the secondary frequency regulation in pu (base SnRef)";

equation
  if running then
    PGenRawPu = - PRefPu + Alpha * N + AlphaSFR * NSFR;
  else
    PGenRawPu = 0;
  end if;

  annotation(preferredView = "text");
end BaseGeneratorSignalNSFR;
