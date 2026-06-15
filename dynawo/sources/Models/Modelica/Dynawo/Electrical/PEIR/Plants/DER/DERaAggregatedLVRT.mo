within Dynawo.Electrical.PEIR.Plants.DER;
model DERaAggregatedLVRT "der_a model with aggregate LVRT model"
  extends BaseClasses.BaseDERa;

  // Low voltage ride through
  parameter Types.VoltageModulePu ULVRTArmingPu "Voltage threshold under which the automaton is activated after tLVRTMax in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTIntPu "Voltage threshold under which the automaton is activated after tLVRTMin in pu (base UNom)";
  parameter Types.VoltageModulePu ULVRTMinPu "Voltage threshold under which the automaton is activated instantaneously in pu (base UNom)";
  parameter Types.Time tLVRTMin "Time delay of trip for severe voltage dips in s";
  parameter Types.Time tLVRTInt "Time delay of trip for intermediate voltage dips in s";
  parameter Types.Time tLVRTMax "Time delay of trip for small voltage dips in s";

  // Parameters of the partial tripping curves
  parameter Types.PerUnit LVRTc(min=0, max=1) "Share of units that disconnect at ULVRTMinPu";
  parameter Types.PerUnit LVRTd(min=0, max=1) "Fraction of ULVRTMinPu at which all units are disconnected";
  parameter Types.PerUnit LVRTe(min=0, max=1) "Share of units that disconnect at ULVRTIntPu";
  parameter Types.PerUnit LVRTf(min=0, max=1) "Fraction of ULVRTIntPu at which all units are disconnected";
  parameter Types.PerUnit LVRTg(min=0, max=1) "Share of units that disconnect at ULVRTArmingPu";
  parameter Types.PerUnit LVRTh(min=0, max=1) "Fraction of ULVRTArmingPu at which all units are disconnected";

  Dynawo.Electrical.Controls.PEIR.Protections.DER.LVRTIBGa lvrt(ULVRTArmingPu = ULVRTArmingPu, ULVRTIntPu = ULVRTIntPu, ULVRTMinPu = ULVRTMinPu, tLVRTMin = tLVRTMin, tLVRTInt = tLVRTInt, tLVRTMax = tLVRTMax, c = LVRTc, d = LVRTd, e = LVRTe, f = LVRTf, g = LVRTg, h = LVRTh) annotation(
    Placement(visible = true, transformation(origin = {-410, -140}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

equation
  der(partialTrippingRatio) * 1e-3 = (FRT.connectedShare * lvrt.fLVRT) - partialTrippingRatio;

  when (FRT.connectedShare <= 0.001 or lvrt.switchOffSignal) and not pre(injector.switchOffSignal3) then
    injector.switchOffSignal3 = true;
  end when;

  connect(UFilter.y, lvrt.UMonitoredPu) annotation(
    Line(points = {{-398, -20}, {-360, -20}, {-360, -140}, {-398, -140}}, color = {0, 0, 127}));

  annotation(preferredView = "diagram");
end DERaAggregatedLVRT;
