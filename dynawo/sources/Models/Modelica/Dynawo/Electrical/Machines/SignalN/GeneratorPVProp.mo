within Dynawo.Electrical.Machines.SignalN;
model GeneratorPVProp "Model for generator PV based on SignalN for the frequency handling and with a proportional voltage regulation"
  extends BaseClasses.BaseGeneratorSignalNFixedReactiveLimits;
  extends BaseClasses.BasePVProp;

equation
  when QGenPu + QDeadBandPu <= QMinPu and UPu - UDeadBandPu > URefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu - QDeadBandPu >= QMaxPu and UPu + UDeadBandPu < URefPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  // If the two following branches are not here we fail to adjust QGenPu if QMaxPu was modified but we were in Standard Mode.
  elsewhen QGenPu + QDeadBandPu <= QMinPu and UPu - UDeadBandPu == URefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu - QDeadBandPu >= QMaxPu and UPu + UDeadBandPu == URefPu then
    qStatus = QStatus.GenerationMax;
    limUQDown = false;
    limUQUp = true;
  elsewhen (QGenPu - QDeadBandPu > QMinPu or UPu + UDeadBandPu < URefPu) and (QGenPu + QDeadBandPu < QMaxPu or UPu - UDeadBandPu > URefPu) then
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
      QGenPu = - QRef0Pu + KVoltage * (URefPu - UPu);
    end if;
  else
    terminal.i.im = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator regulates the voltage UPu with a proportional regulation unless its reactive power generation hits its limits QMinPu or QMaxPu (in this case, the generator provides QMinPu or QMaxPu and the voltage is no longer regulated).</div></body></html>"));
end GeneratorPVProp;
