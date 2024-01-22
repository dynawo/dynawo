within Dynawo.Examples.GridFollowingWithLimiters;

model SingleVSCWithLimiters
  import Dynawo;
  import Modelica;
  Dynawo.Examples.GridFollowingWithLimiters.InitSingleVSCWithLimiters SingleVSC_INIT;
  
  Dynawo.Electrical.Buses.InfiniteBusWithImpedance infiniteBusWithImpedance(
  RPu = SingleVSC_INIT.RInfPu,
  UBus0Pu = SingleVSC_INIT.UBus0Pu,
  UPhaseBus0 = SingleVSC_INIT.UPhaseBus0,
  XPu = SingleVSC_INIT.XInfPu, 
  iTerminal0Pu = -SingleVSC_INIT.iTerminal0Pu,
  uTerminal0Pu = SingleVSC_INIT.uTerminal0Pu)
  annotation(
    Placement(visible = true, transformation(origin = {126, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 270)));
  
  Dynawo.Electrical.Lines.Line line(
  BPu = SingleVSC_INIT.BLinePu,
  GPu = SingleVSC_INIT.GLinePu,
  RPu = SingleVSC_INIT.RLinePu,
  XPu = SingleVSC_INIT.XLinePu)
  annotation(
    Placement(visible = true, transformation(origin = {76, 0}, extent = {{-30, -30}, {30, 30}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.GridFollowingControlWithLimiters GridFollowingControl(
  SNom= SingleVSC_INIT.SNom,
  R= SingleVSC_INIT.R,
  L= SingleVSC_INIT.L,
  Rc= SingleVSC_INIT.Rc,
  Xc= SingleVSC_INIT.Xc,
  ratioTr= SingleVSC_INIT.ratioTr,
  Kpc= SingleVSC_INIT.Kpc,
  Kic= SingleVSC_INIT.Kic,
  Tlpf= SingleVSC_INIT.Tlpf,
  Kpp= SingleVSC_INIT.Kpp,
  Kip= SingleVSC_INIT.Kip,
  Kpv= SingleVSC_INIT.Kpv,
  Kiv= SingleVSC_INIT.Kiv,
  KpPLL= SingleVSC_INIT.KpPLL ,
  KiPLL= SingleVSC_INIT.KiPLL ,
  OmegaMaxPu = SingleVSC_INIT.OmegaMaxPu,
  OmegaMinPu = SingleVSC_INIT.OmegaMinPu,
  uPcc0Pu= SingleVSC_INIT.uPcc0Pu ,
  iPcc0Pu= SingleVSC_INIT.iPcc0Pu ,
  omegaNom= SingleVSC_INIT.omegaNom,
  omegaRef0Pu= SingleVSC_INIT.omegaRef0Pu,
  omegaPLL0Pu= SingleVSC_INIT.omegaPLL0Pu,
  thetaPLL0Pu= SingleVSC_INIT.thetaPLL0Pu,
  PGen0Pu= SingleVSC_INIT.PGen0Pu,
  QGen0Pu= SingleVSC_INIT.QGen0Pu,
  uConv0Pu= SingleVSC_INIT.uConv0Pu,
  UConv0Pu= SingleVSC_INIT.UConv0Pu,
  idConv0Pu= SingleVSC_INIT.idConv0Pu,
  iqConv0Pu= SingleVSC_INIT.iqConv0Pu,
  udPcc0Pu= SingleVSC_INIT.udPcc0Pu,
  uqPcc0Pu= SingleVSC_INIT.uqPcc0Pu,
  idPcc0Pu= SingleVSC_INIT.idPcc0Pu,
  iqPcc0Pu= SingleVSC_INIT.iqPcc0Pu,
  udConvRef0Pu= SingleVSC_INIT.udConvRef0Pu,
  uqConvRef0Pu= SingleVSC_INIT.uqConvRef0Pu,
  Trlim= SingleVSC_INIT.Trlim,
  didt_min= SingleVSC_INIT.didt_min,
  didt_max= SingleVSC_INIT.didt_max,
  InomPu=SingleVSC_INIT.InomPu
  ) annotation(
    Placement(transformation(origin = {-62, 0}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Sources.Step UConvRefPu(height = +0.2, offset = SingleVSC_INIT.UConvRef0Pu, startTime = 5) annotation(
    Placement(visible = true, transformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant omegaRefPu(k = SingleVSC_INIT.omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Step PGenRefPu(height = +0.5, offset = SingleVSC_INIT.PGenRef0Pu, startTime = 0.5) annotation(
    Placement(visible = true, transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorGFL InjectorGFL(SNom = SingleVSC_INIT.SNom, R = SingleVSC_INIT.R, L = SingleVSC_INIT.L, Rc = SingleVSC_INIT.Rc, Xc = SingleVSC_INIT.Xc, ratioTr = SingleVSC_INIT.ratioTr, omegaNom = SingleVSC_INIT.omegaNom, omegaPLL0Pu = SingleVSC_INIT.omegaPLL0Pu, thetaPLL0Pu = SingleVSC_INIT.thetaPLL0Pu, PGen0Pu = SingleVSC_INIT.PGen0Pu, QGen0Pu = SingleVSC_INIT.QGen0Pu, uPcc0Pu = SingleVSC_INIT.uPcc0Pu, iPcc0Pu = SingleVSC_INIT.iPcc0Pu, uConv0Pu = SingleVSC_INIT.uConv0Pu, UConv0Pu = SingleVSC_INIT.UConv0Pu, idPcc0Pu = SingleVSC_INIT.idPcc0Pu, iqPcc0Pu = SingleVSC_INIT.iqPcc0Pu, udPcc0Pu = SingleVSC_INIT.udPcc0Pu, uqPcc0Pu = SingleVSC_INIT.uqPcc0Pu, idConv0Pu = SingleVSC_INIT.idConv0Pu, iqConv0Pu = SingleVSC_INIT.iqConv0Pu, udConvRef0Pu = SingleVSC_INIT.udConvRef0Pu, uqConvRef0Pu = SingleVSC_INIT.uqConvRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-1.55431e-15, -1.55431e-15}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
equation
  line.switchOffSignal1.value = false;
  line.switchOffSignal2.value = false;
  InjectorGFL.switchOffSignal1.value = false;
  InjectorGFL.switchOffSignal2.value = false;
  InjectorGFL.switchOffSignal3.value = false;
  connect(line.terminal2, infiniteBusWithImpedance.terminal) annotation(
    Line(points = {{106, 0}, {126, 0}}, color = {0, 0, 255}));
  connect(UConvRefPu.y, GridFollowingControl.UConvRefPu) annotation(
    Line(points = {{-98, -60}, {-90, -60}, {-90, -14}, {-84, -14}}, color = {0, 0, 127}));
  connect(PGenRefPu.y, GridFollowingControl.PGenRefPu) annotation(
    Line(points = {{-98, 0}, {-84, 0}}, color = {0, 0, 127}));
connect(GridFollowingControl.omegaPLLPu, InjectorGFL.omegaPLLPu) annotation(
    Line(points = {{-40, 16}, {-22, 16}}, color = {0, 0, 127}));
  connect(GridFollowingControl.thetaPLLPu, InjectorGFL.thetaPLLPu) annotation(
    Line(points = {{-40, 6}, {-22, 6}}, color = {0, 0, 127}));
  connect(GridFollowingControl.udConvRefPu, InjectorGFL.udConvRefPu) annotation(
    Line(points = {{-40, -6}, {-22, -6}}, color = {0, 0, 127}));
  connect(GridFollowingControl.uqConvRefPu, InjectorGFL.uqConvRefPu) annotation(
    Line(points = {{-40, -16}, {-22, -16}}, color = {0, 0, 127}));
  connect(InjectorGFL.uPccPu, GridFollowingControl.uPccPu) annotation(
    Line(points = {{-10, 22}, {-10, 40}, {-76, 40}, {-76, 22}}, color = {85, 170, 255}));
  connect(InjectorGFL.PGenPu, GridFollowingControl.PGenPu) annotation(
    Line(points = {{22, 16}, {30, 16}, {30, 32}, {-52, 32}, {-52, 22}}, color = {0, 0, 127}));
  connect(InjectorGFL.UConvPu, GridFollowingControl.UConvPu) annotation(
    Line(points = {{22, -10}, {38, -10}, {38, 38}, {-66, 38}, {-66, 22}}, color = {0, 0, 127}));
  connect(InjectorGFL.udPccPu, GridFollowingControl.udPccPu) annotation(
    Line(points = {{6, -22}, {6, -46}, {-76, -46}, {-76, -22}}, color = {0, 0, 127}));
  connect(InjectorGFL.uqPccPu, GridFollowingControl.uqPccPu) annotation(
    Line(points = {{14, -22}, {14, -50}, {-68, -50}, {-68, -22}}, color = {0, 0, 127}));
  connect(InjectorGFL.idConvPu, GridFollowingControl.idConvPu) annotation(
    Line(points = {{-14, -22}, {-16, -22}, {-16, -36}, {-56, -36}, {-56, -22}}, color = {0, 0, 127}));
  connect(InjectorGFL.iqConvPu, GridFollowingControl.iqConvPu) annotation(
    Line(points = {{-6, -22}, {-6, -42}, {-48, -42}, {-48, -22}}, color = {0, 0, 127}));
  connect(InjectorGFL.terminal, line.terminal1) annotation(
    Line(points = {{22, 0}, {46, 0}}, color = {0, 0, 255}));
  connect(omegaRefPu.y, GridFollowingControl.omegaRefPu) annotation(
    Line(points = {{-98, 56}, {-92, 56}, {-92, 14}, {-84, 14}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end SingleVSCWithLimiters;
