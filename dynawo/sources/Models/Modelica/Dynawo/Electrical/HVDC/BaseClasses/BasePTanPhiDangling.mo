within Dynawo.Electrical.HVDC.BaseClasses;
partial model BasePTanPhiDangling "Base dynamic model for P/tan(Phi) control at terminal 1"

  input Real tanPhi1Ref(start = TanPhi1Ref0) "tan(Phi) regulation set point at terminal 1";

  parameter Real TanPhi1Ref0 "Start value of tan(Phi) regulation set point at terminal 1";

protected
  Types.ReactivePowerPu QInj1RawPu "Raw reactive power at terminal 1 in pu (base SnRef) (generator convention)";

  annotation(preferredView = "text");
end BasePTanPhiDangling;
