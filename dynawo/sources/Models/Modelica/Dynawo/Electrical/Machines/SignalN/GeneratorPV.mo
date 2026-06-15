within Dynawo.Electrical.Machines.SignalN;
model GeneratorPV "Model for generator PV based on SignalN for the frequency handling"
  extends BaseClasses.BaseGeneratorSignalNFixedReactiveLimits;
  extends BaseClasses.BasePV;
  extends BaseClasses.BaseQStator(QStatorPu(start = QGen0Pu * SystemBase.SnRef / QNomAlt));

  // blocks
  Modelica.Blocks.Sources.BooleanExpression blocking(y = (qStatus == QStatus.AbsorptionMax or qStatus == QStatus.GenerationMax or running == false)) "Expression determining if reactive power limits have been reached or if the generator is disconnected" annotation(
    Placement(transformation(origin = {70, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.BooleanOutput blocker(start =  (qStatus0 == QStatus.AbsorptionMax or qStatus0 == QStatus.GenerationMax or Running0 == false)) "If true, reactive power limits have been reached or the generator is disconnected" annotation(
    Placement(transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {106, 0}, extent = {{-10, -10}, {10, 10}})));

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
  elsewhen QGenPu + QDeadBandPu <= QMinPu and UPu == URefPu then
    qStatus = QStatus.AbsorptionMax;
    limUQDown = true;
    limUQUp = false;
  elsewhen QGenPu - QDeadBandPu >= QMaxPu and UPu == URefPu then
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
      UPu = URefPu;
    end if;
  else
    terminal.i.im = 0;
  end if;

  QStatorPu = QGenPu * SystemBase.SnRef / QNomAlt;

  connect(blocking.y, blocker) annotation(
    Line(points = {{82, 0}, {110, 0}}, color = {255, 0, 255}));

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This generator regulates the voltage UPu unless its reactive power generation hits its limits QMinPu or QMaxPu (in this case, the generator provides QMinPu or QMaxPu and the voltage is no longer regulated).</div></body></html>"));
end GeneratorPV;
