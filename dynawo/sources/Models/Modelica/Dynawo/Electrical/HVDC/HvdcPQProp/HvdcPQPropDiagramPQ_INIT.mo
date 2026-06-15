within Dynawo.Electrical.HVDC.HvdcPQProp;
model HvdcPQPropDiagramPQ_INIT "Initialisation model of HVDC link with a proportional reactive power control and a PQ diagram"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;
  extends BaseClasses_INIT.BaseQStatus_INIT;
  extends BaseClasses_INIT.BaseDiagramPQ_INIT;

  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";

equation
  P1Ref0Pu = P1RefSetPu;

  if - Q10Pu <= QInj1Min0Pu then
    q1Status0 = QStatus.AbsorptionMax;
  elseif - Q10Pu >= QInj1Max0Pu then
    q1Status0 = QStatus.GenerationMax;
  else
    q1Status0 = QStatus.Standard;
  end if;

  if - Q20Pu <= QInj2Min0Pu then
    q2Status0 = QStatus.AbsorptionMax;
  elseif - Q20Pu >= QInj2Max0Pu then
    q2Status0 = QStatus.GenerationMax;
  else
    q2Status0 = QStatus.Standard;
  end if;

  annotation(preferredView = "text");
end HvdcPQPropDiagramPQ_INIT;
