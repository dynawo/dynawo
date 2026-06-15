within Dynawo.Electrical.Machines.SignalN;
model GeneratorPQProp "Model for generator PQ based on SignalN for the frequency handling and with a proportional reactive power regulation"
  extends BaseClasses.BaseGeneratorSignalNFixedReactiveLimits;
  extends BaseClasses.BasePQProp(QGenRawPu(start = QGen0Pu));

equation
  when QGenRawPu <= QMinPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenRawPu >= QMaxPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  elsewhen QGenRawPu - QDeadBandPu > QMinPu and QGenRawPu + QDeadBandPu < QMaxPu then
    qStatus = QStatus.Standard;
    limUQDown = false;
    limUQUp = false;
  end when;

  if running then
    if qStatus == QStatus.GenerationMax then
      QGenPu = QMaxPu;
    elseif qStatus == QStatus.AbsorptionMax then
      QGenPu = QMinPu;
    else
      QGenPu = min(max(QGenRawPu, QMinPu), QMaxPu);
    end if;
  else
    terminal.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This PQ generator adapts it Q to regulate the voltage of a distant bus along with other generators depending on a participation factor QPercent. To do so, it receives a set point NQ to adapt its Q. This NQ is common to all the generators participating in this regulation.</div></body></html>"));
end GeneratorPQProp;
