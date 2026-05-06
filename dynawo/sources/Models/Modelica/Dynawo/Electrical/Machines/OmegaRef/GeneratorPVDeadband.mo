within Dynawo.Electrical.Machines.OmegaRef;

model GeneratorPVDeadband "Generator with deadband on voltage regulation"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  extends BaseClasses.BaseGeneratorSimplifiedPFBehavior;
  extends AdditionalIcons.Machine;

  type QStatus = enumeration(Standard "Reactive power is fixed to its initial value",
                             AbsorptionMax "Reactive power is fixed to its absorption limit",
                             GenerationMax "Reactive power is fixed to its generation limit");

  Dynawo.Connectors.ImPin deltaURefPu(value(start = 0)) "Additional voltage reference in pu (base UNom)";
  Dynawo.Connectors.ImPin URefPu(value(start = URef0Pu)) "Voltage regulation set point in pu (base UNom)";

  parameter Types.PerUnit LambdaPuSNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SNom)";
  parameter Types.ReactivePower QMax "Maximum reactive power in Mvar";
  parameter Types.ReactivePower QMin "Minimum reactive power in Mvar";
  parameter Types.ApparentPowerModule SNom "Apparent nominal power in MVA";
  parameter Types.VoltageModulePu UDeadbandLowPu = 0.98 "Lower deadband threshold for voltage regulation (pu, base UNom)";
  parameter Types.VoltageModulePu UDeadbandHighPu = 1.02 "Upper deadband threshold for voltage regulation (pu, base UNom)";

  final parameter Types.PerUnit LambdaPu = LambdaPuSNom * SystemBase.SnRef / SNom "Reactive power sensitivity of the voltage regulation in pu (base UNom, SnRef)";
  final parameter Types.ReactivePowerPu QMaxPu = QMax / SystemBase.SnRef "Maximum reactive power in pu (base SnRef)";
  final parameter Types.ReactivePowerPu QMinPu = QMin / SystemBase.SnRef "Minimum reactive power in pu (base SnRef)";
  final parameter Types.Time T = 1 "Time constant used to filter the reactive power reference, in s";

  Types.ReactivePowerPu QGenRefPu(start = QGen0Pu) "Reactive power set point in pu (base SnRef)";
  parameter Types.VoltageModulePu URef0Pu "Initial voltage regulation set point in pu (base UNom)";

protected
  QStatus qStatus(start = QStatus.Standard) "Voltage regulation status: standard, absorptionMax or generationMax";

equation
  when QGenRefPu >= QMaxPu and pre(qStatus) <> QStatus.AbsorptionMax then
    qStatus = QStatus.AbsorptionMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMaxQ);
  elsewhen QGenRefPu <= QMinPu and pre(qStatus) <> QStatus.GenerationMax then
    qStatus = QStatus.GenerationMax;
    Timeline.logEvent1(TimelineKeys.GeneratorPVMinQ);
  elsewhen (QGenRefPu < QMaxPu and pre(qStatus) == QStatus.AbsorptionMax) or (QGenRefPu > QMinPu and pre(qStatus) == QStatus.GenerationMax) then
    qStatus = QStatus.Standard;
    Timeline.logEvent1(TimelineKeys.GeneratorPVBackRegulation);
  end when;

  if running.value then
    if (UPu >= UDeadbandLowPu and UPu <= UDeadbandHighPu) then
      der(QGenRefPu) = 0; // No regulation inside deadband
    else
      URefPu.value + deltaURefPu.value = UPu + LambdaPu * (QGenRefPu + T * der(QGenRefPu));
    end if;
    QGenPu = if qStatus == QStatus.AbsorptionMax then QMaxPu else if qStatus == QStatus.GenerationMax then QMinPu else QGenRefPu;
  else
    QGenRefPu = 0;
    terminal.i.im = 0;
  end if;

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The active power output is modulated according to frequency (in order to model frequency containment reserves).<div>The reactive power output is modulated in order to keep U + lambda * Q as close as possible to the target value, with a deadband on voltage regulation. When a reactive power limit is reached, the generator produces a constant reactive power equal to the limit reached.</div></body></html>"));
end GeneratorPVDeadband;
