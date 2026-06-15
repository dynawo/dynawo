within Dynawo.Electrical.Machines.SignalN.BaseClasses;
partial model BaseGenerator "Base dynamic model for generators based on SignalN for the frequency handling"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends AdditionalIcons.Machine;
  extends Machines.BaseClasses.BaseGeneratorSimplified;

  parameter Types.PerUnit KGover "Mechanical power sensitivity to frequency";
  parameter Types.ActivePowerPu PMaxPu "Maximum active power in pu (base SnRef)";
  parameter Types.ActivePowerPu PMinPu "Minimum active power in pu (base SnRef)";
  parameter Types.ActivePower PNom "Nominal power in MW";

  final parameter Real Alpha = PNom * KGover "Participation of the considered generator in the primary frequency regulation";

  type PStatus = enumeration(Standard, LimitPMin, LimitPMax);
  type QStatus = enumeration(Standard, AbsorptionMax, GenerationMax);

  input Types.PerUnit N "Signal to change the active power reference setpoint of the generators participating in the primary frequency regulation in pu (base SnRef)";
  input Types.ActivePowerPu PRefPu(start = PRef0Pu) "Active power set point in pu (base Snref) (receptor convention)";

  Modelica.Blocks.Interfaces.BooleanOutput limUQDown(start = limUQDown0) "Whether the minimum reactive power limits are reached or not (from generator voltage regulator)";
  Modelica.Blocks.Interfaces.BooleanOutput limUQUp(start = limUQUp0) "Whether the maximum reactive power limits are reached or not (from generator voltage regulator)";

  parameter Boolean limUQDown0 "Whether the minimum reactive power limits are reached or not (from generator voltage regulator), start value";
  parameter Boolean limUQUp0 "Whether the maximum reactive power limits are reached or not (from generator voltage regulator), start value";
  parameter Types.ActivePowerPu PRef0Pu "Start value of the active power set point in pu (base SnRef) (receptor convention)";
  parameter QStatus qStatus0 "Start voltage regulation status: Standard, AbsorptionMax, GenerationMax";

protected
  Types.ActivePowerPu PGenRawPu(start = PGen0Pu) "Active power generation without taking limits into account in pu (base SnRef) (generator convention)";
  PStatus pStatus(start = PStatus.Standard) "Active power / frequency regulation status: Standard, LimitPMin, LimitPMax";
  QStatus qStatus(start = qStatus0) "Voltage regulation status: Standard, AbsorptionMax, GenerationMax";

equation
  when PGenRawPu >= PMaxPu and pre(pStatus) <> PStatus.LimitPMax then
    pStatus = PStatus.LimitPMax;
    Timeline.logEvent1(TimelineKeys.ActivatePMAX);
  elsewhen PGenRawPu <= PMinPu and pre(pStatus) <> PStatus.LimitPMin then
    pStatus = PStatus.LimitPMin;
    Timeline.logEvent1(TimelineKeys.ActivatePMIN);
  elsewhen PGenRawPu > PMinPu and pre(pStatus) == PStatus.LimitPMin then
    pStatus = PStatus.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMIN);
  elsewhen PGenRawPu < PMaxPu and pre(pStatus) == PStatus.LimitPMax then
    pStatus = PStatus.Standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMAX);
  end when;

  when qStatus == QStatus.AbsorptionMax and pre(qStatus) <> QStatus.AbsorptionMax then
    Timeline.logEvent1(TimelineKeys.GeneratorMinQ);
  elsewhen qStatus == QStatus.GenerationMax and pre(qStatus) <> QStatus.GenerationMax then
    Timeline.logEvent1(TimelineKeys.GeneratorMaxQ);
  elsewhen qStatus == QStatus.Standard and pre(qStatus) <> QStatus.Standard then
    Timeline.logEvent1(TimelineKeys.GeneratorBackRegulation);
  end when;

  if running then
    PGenPu = if PGenRawPu >= PMaxPu then PMaxPu elseif PGenRawPu <= PMinPu then PMinPu else PGenRawPu;
  else
    terminal.i.re = 0;
  end if;

  annotation(preferredView = "text");
end BaseGenerator;
