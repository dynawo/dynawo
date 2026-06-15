within Dynawo.Electrical.Controls.HVDC;
model PowerTransferHVDCEmulation "Power transfer model for HVDC with AC emulation"
  extends Dynawo.Electrical.Controls.HVDC.PowerTransferHVDC;

  output Types.PerUnit KACEmulation1(start = KACEmulation10) "Inverse of the emulated AC reactance for HVDC link 1";
  output Types.PerUnit KACEmulation2(start = KACEmulation20) "Inverse of the emulated AC reactance for HVDC link 2";

  parameter Types.PerUnit KACEmulation10 "Start value of inverse of the emulated AC reactance for HVDC link 1";
  parameter Types.PerUnit KACEmulation20 "Start value of inverse of the emulated AC reactance for HVDC link 2";

equation
  if running1 and running2 then
    KACEmulation1 = KACEmulation10;
    KACEmulation2 = KACEmulation20;
  elseif not
            (running1) and running2 then
    KACEmulation1 = 0;
    KACEmulation2 = KACEmulation20 + KACEmulation10;
  elseif running1 and not
                         (running2) then
    KACEmulation1 = KACEmulation10 + KACEmulation20;
    KACEmulation2 = 0;
  else
    KACEmulation1 = 0;
    KACEmulation2 = 0;
  end if;

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body> This model adapts the KACEmulation and PRefSetPu of each of the two HVDC links in parallel depending on the running state of each of the links. If one link is disconnected, this allows the other one to compensate for the power loss. </div></body></html>"));
end PowerTransferHVDCEmulation;
