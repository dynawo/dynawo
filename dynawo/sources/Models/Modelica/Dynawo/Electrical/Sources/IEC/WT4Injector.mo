within Dynawo.Electrical.Sources.IEC;

model WT4Injector
extends BaseConverters.WTInjector;
  BaseConverters.GenSystem4 genSystem(DipMaxPu = DipMaxPu, DiqMaxPu = DiqMaxPu, DiqMinPu = DiqMinPu, IGsIm0Pu = IGsIm0Pu, IGsRe0Pu = IGsRe0Pu, IpMax0Pu = IpMax0Pu, IqMax0Pu = IqMax0Pu, IqMin0Pu = IqMin0Pu, Kipaw = Kipaw, Kiqaw = Kiqaw, P0Pu = P0Pu, PAg0Pu = PAg0Pu, Q0Pu = Q0Pu, SNom = SNom, U0Pu = U0Pu, UGsIm0Pu = UGsIm0Pu, UGsRe0Pu = UGsRe0Pu, UPhase0 = UPhase0, tG = tG) annotation(
    Placement(visible = true, transformation(origin = {-40, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));  
    
equation
  genSystem.running = running.value;
  
  connect(theta, genSystem.theta) annotation(
    Line(points = {{-40, 110}, {-40, 22}}, color = {0, 0, 127}));
  connect(fOCB, genSystem.fOCB) annotation(
    Line(points = {{40, 110}, {40, 80}, {-32, 80}, {-32, 22}}, color = {255, 0, 255}));
  connect(ipMaxPu, genSystem.ipMaxPu) annotation(
    Line(points = {{-110, 40}, {-66, 40}, {-66, 16}, {-62, 16}}, color = {0, 0, 127}));
  connect(ipCmdPu, genSystem.ipCmdPu) annotation(
    Line(points = {{-110, 20}, {-80, 20}, {-80, 8}, {-62, 8}}, color = {0, 0, 127}));
  connect(iqMaxPu, genSystem.iqMaxPu) annotation(
    Line(points = {{-110, 0}, {-62, 0}}, color = {0, 0, 127}));
  connect(iqCmdPu, genSystem.iqCmdPu) annotation(
    Line(points = {{-110, -20}, {-80, -20}, {-80, -8}, {-62, -8}}, color = {0, 0, 127}));
  connect(iqMinPu, genSystem.iqMinPu) annotation(
    Line(points = {{-110, -40}, {-66, -40}, {-66, -16}, {-62, -16}}, color = {0, 0, 127}));
  connect(genSystem.terminal, elecSystem.terminal1) annotation(
    Line(points = {{-18, 0}, {18, 0}}, color = {0, 0, 255}));
  connect(genSystem.PAgPu, PAgPu) annotation(
    Line(points = {{-18, -16}, {-12, -16}, {-12, -60}, {-80, -60}, {-80, -110}}, color = {0, 0, 127})); end WT4Injector;
