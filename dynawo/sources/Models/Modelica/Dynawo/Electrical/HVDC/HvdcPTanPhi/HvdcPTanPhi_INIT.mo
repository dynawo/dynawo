within Dynawo.Electrical.HVDC.HvdcPTanPhi;
model HvdcPTanPhi_INIT "Initialisation model of P/tan(Phi) HVDC link"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;

  parameter Real CosPhi1Ref0 "Start value of cos(Phi) regulation set point at terminal 1";
  parameter Real CosPhi2Ref0 "Start value of cos(Phi) regulation set point at terminal 2";
  parameter Types.ActivePowerPu P1RefSetPu "Start value of active power reference at terminal 1 in pu (base SnRef) (receptor convention)";

  Real TanPhi1Ref0 "Start value of tan(Phi) regulation set point at terminal 1";
  Real TanPhi2Ref0 "Start value of tan(Phi) regulation set point at terminal 2";

equation
  P1Ref0Pu = P1RefSetPu;
  TanPhi1Ref0 = if sign(P10Pu) == sign(Q10Pu) then abs(tan(acos(CosPhi1Ref0))) else - abs(tan(acos(CosPhi1Ref0)));
  TanPhi2Ref0 = if sign(P20Pu) == sign(Q20Pu) then abs(tan(acos(CosPhi2Ref0))) else - abs(tan(acos(CosPhi2Ref0)));

  annotation(preferredView = "text");
end HvdcPTanPhi_INIT;
