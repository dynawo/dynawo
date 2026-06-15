within Dynawo.Electrical.HVDC.HvdcPQProp;
model HvdcPQPropDanglingDiagramPQ_INIT "Initialisation model of HVDC link with a proportional reactive power control and a PQ diagram and with terminal 1 only"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;
  extends BaseClasses_INIT.BaseQStatusDangling_INIT;
  extends BaseClasses_INIT.BaseDiagramPQDangling_INIT;

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

  annotation(preferredView = "text");
end HvdcPQPropDanglingDiagramPQ_INIT;
