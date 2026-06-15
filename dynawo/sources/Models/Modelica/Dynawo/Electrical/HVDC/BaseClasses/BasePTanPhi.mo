within Dynawo.Electrical.HVDC.BaseClasses;
partial model BasePTanPhi "Base dynamic model for P/tan(Phi) control"
  extends BaseClasses.BasePTanPhiDangling;

  input Real tanPhi2Ref(start = TanPhi2Ref0) "tan(Phi) regulation set point at terminal 2";

  parameter Real TanPhi2Ref0 "Start value of tan(Phi) regulation set point at terminal 2";

protected
  Types.ReactivePowerPu QInj2RawPu "Raw reactive power at terminal 2 in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end BasePTanPhi;
