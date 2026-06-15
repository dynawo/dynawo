within Dynawo.Electrical.HVDC.HvdcPV;
model HvdcPVDanglingDiagramPQ_INIT "Initialisation model of PV HVDC link with a PQ diagram and with terminal 1 only"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;
  extends BaseClasses_INIT.BaseQStatusDangling_INIT;
  extends BaseClasses_INIT.BaseDiagramPQDangling_INIT;
  extends BaseClasses_INIT.BasePV_INIT;

  final parameter Types.ReactivePowerPu QInj10Pu=-Q10Pu "Start value of reactive power at terminal 1 in pu (base SnRef) (generator convention)";

equation
  P1Ref0Pu = P1RefSetPu;
  QInj10PuQNom = QInj10Pu * SystemBase.SnRef / Q1Nom;

  if - Q10Pu <= QInj1Min0Pu then
    q1Status0 = QStatus.AbsorptionMax;
  elseif - Q10Pu >= QInj1Max0Pu then
    q1Status0 = QStatus.GenerationMax;
  else
    q1Status0 = QStatus.Standard;
  end if;

  if UseLambda1 then
    U10Pu + Lambda1Pu * QInj10Pu = U1Ref0Pu;
  else
    U1Ref0Pu = U10Pu;
  end if;

  annotation(preferredView = "text");
end HvdcPVDanglingDiagramPQ_INIT;
