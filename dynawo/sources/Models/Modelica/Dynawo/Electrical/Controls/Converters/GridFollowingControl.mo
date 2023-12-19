within Dynawo.Electrical.Controls.Converters;

model GridFollowingControl
  import Modelica;
  import Dynawo;
  //Model parameters
  parameter Types.ApparentPowerModule SNom "Converter nominal apparent power";
  parameter Types.AngularVelocity omegaNom;
  parameter Types.PerUnit R "Transformer resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit L "Transformer inductance in pu (base UNom, SNom)";
  parameter Types.PerUnit Rc "resistance value from converter terminal to PCC in pu (base UNom, SNom)";
  parameter Types.PerUnit Xc "reactance value from converter terminal to PCC in pu (base UNom, SNom)";
  parameter Types.PerUnit ratioTr "Transformer ratio in p.u (base ...)";
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.Time Tlpf "Time constant of low pass filter";
  parameter Types.PerUnit Kpp "Proportional gain of the active power loop";
  parameter Types.PerUnit Kip "Integral gain of the active power loop";
  parameter Types.PerUnit Kpv "Proportional gain of the reactive power loop";
  parameter Types.PerUnit Kiv "Integral gain of the reactive power loop";
  parameter Types.PerUnit KpPLL;
  parameter Types.PerUnit KiPLL;
  parameter Types.PerUnit OmegaMaxPu;
  parameter Types.PerUnit OmegaMinPu;
  
  //Initial values
  parameter Types.ComplexVoltagePu uPcc0Pu;
  parameter Types.ComplexCurrentPu iPcc0Pu;
  parameter Types.ComplexVoltagePu uConv0Pu;
  parameter Types.ComplexVoltagePu iConv0Pu;
  parameter Types.PerUnit udPcc0Pu;
  parameter Types.PerUnit uqPcc0Pu;
  parameter Types.PerUnit idPcc0Pu;
  parameter Types.PerUnit iqPcc0Pu;
  parameter Types.PerUnit udConv0Pu;
  parameter Types.PerUnit uqConv0Pu;
  parameter Types.PerUnit idConv0Pu;
  parameter Types.PerUnit iqConv0Pu;
  parameter Types.PerUnit udConvRef0Pu;
  parameter Types.PerUnit uqConvRef0Pu;
  parameter Types.PerUnit PGen0Pu;
  parameter Types.PerUnit QGen0Pu;
  parameter Types.PerUnit UConv0Pu;
  parameter Types.Angle thetaPLL0Pu;
  parameter Types.PerUnit omegaPLL0Pu;
  parameter Types.PerUnit omegaRef0Pu;
  
  Dynawo.Electrical.Controls.Converters.BaseControls.ReactivePowerLoop reactivePowerLoop(Kiv = Kiv, Kpv = Kpv, Tlpf = Tlpf, UConv0Pu = UConv0Pu, UConvRef0Pu = UConv0Pu, iqConv0Pu = iqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, -12}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.ActivePowerLoop activePowerLoop(Kip = Kip, Kpp = Kpp, PGen0Pu = PGen0Pu, PGenRef0Pu = PGen0Pu, Tlpf = Tlpf, idConv0Pu = idConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-60, 42}, extent = {{-26, -26}, {26, 26}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.BaseControls.CurrentLoopGFL currentLoopGFL(Kic = Kic, Kpc = Kpc, L = L, R = R, idConv0Pu = idConv0Pu, iqConv0Pu = iqConv0Pu, omegaPLL0Pu = omegaPLL0Pu, ratioTr = ratioTr, udConvRef0Pu = udConvRef0Pu, udPcc0Pu = udPcc0Pu, uqConvRef0Pu = uqConvRef0Pu, uqPcc0Pu = uqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {49, 15}, extent = {{-27, -27}, {27, 27}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PGenRefPu(start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 55}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = omegaRef0Pu) annotation(
    Placement(transformation(origin = {-130, 100}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput UConvRefPu(start = UConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput udConvRefPu(start = udConvRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 42}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -31}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput thetaPLLPu(start = thetaPLL0Pu) annotation(
    Placement(transformation(origin = {130, 107}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 31}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu(start = omegaPLL0Pu) annotation(
    Placement(transformation(origin = {130, 121}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput uqConvRefPu(start = uqConvRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPccPu(re(start = uPcc0Pu.re), im(start = uPcc0Pu.im)) annotation(
    Placement(transformation(origin = {-127, 123}, extent = {{-7, -7}, {7, 7}}), iconTransformation(origin = {-70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 29}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {50, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput udPccPu(start = udPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -50}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput UConvPu(start = UConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 9}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-20, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqPccPu(start = uqPcc0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-30, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = idConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {30, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = iqConv0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {69, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  PLL.PLL pll(u0Pu = uPcc0Pu, Ki = KiPLL, Kp = KpPLL, OmegaMaxPu = OmegaMaxPu, OmegaMinPu = OmegaMinPu) annotation(
    Placement(transformation(origin = {-38.5, 111.5}, extent = {{-18.5, -18.5}, {18.5, 18.5}})));
equation
  connect(reactivePowerLoop.iqRefPu, currentLoopGFL.iqConvRefPu) annotation(
    Line(points = {{-31.4, -12}, {18.6, -12}}, color = {0, 0, 127}));
  connect(activePowerLoop.idRefPu, currentLoopGFL.idConvRefPu) annotation(
    Line(points = {{-31.4, 42}, {18.6, 42}}, color = {0, 0, 127}));
  connect(PGenRefPu, activePowerLoop.PGenRefPu) annotation(
    Line(points = {{-130, 55}, {-89, 55}}, color = {0, 0, 127}));
  connect(UConvRefPu, reactivePowerLoop.UConvRefPu) annotation(
    Line(points = {{-130, -4}, {-89, -4}}, color = {0, 0, 127}));
  connect(currentLoopGFL.udConvRefPu, udConvRefPu) annotation(
    Line(points = {{78.7, 42}, {129.7, 42}}, color = {0, 0, 127}));
  connect(currentLoopGFL.uqConvRefPu, uqConvRefPu) annotation(
    Line(points = {{78.7, -12}, {129.7, -12}}, color = {0, 0, 127}));
  connect(PGenPu, activePowerLoop.PGenPu) annotation(
    Line(points = {{-130, 29}, {-89, 29}}, color = {0, 0, 127}));
  connect(UConvPu, reactivePowerLoop.UConvPu) annotation(
    Line(points = {{-130, 9}, {-89, 9}}, color = {0, 0, 127}));
  connect(udPccPu, currentLoopGFL.udPccPu) annotation(
    Line(points = {{-130, -50}, {41, -50}, {41, -15}}, color = {0, 0, 127}));
  connect(uqPccPu, currentLoopGFL.uqPccPu) annotation(
    Line(points = {{-130, -70}, {31, -70}, {31, -15}, {30, -15}}, color = {0, 0, 127}));
  connect(idConvPu, currentLoopGFL.idConvPu) annotation(
    Line(points = {{-130, -90}, {68, -90}, {68, -15}}, color = {0, 0, 127}));
  connect(iqConvPu, currentLoopGFL.iqConvPu) annotation(
    Line(points = {{-130, -110}, {57, -110}, {57, -15}}, color = {0, 0, 127}));
  connect(uPccPu, pll.uPu) annotation(
    Line(points = {{-127, 123}, {-59, 123}}, color = {85, 170, 255}));
  connect(pll.omegaPLLPu, omegaPLLPu) annotation(
    Line(points = {{-18, 121}, {130, 121}}, color = {0, 0, 127}));
  connect(pll.phi, thetaPLLPu) annotation(
    Line(points = {{-18, 113}, {-18, 107}, {130, 107}}, color = {0, 0, 127}));
  connect(pll.omegaPLLPu, currentLoopGFL.omegaPLLPu) annotation(
    Line(points = {{-18, 121}, {-4, 121}, {-4, 15}, {19, 15}}, color = {0, 0, 127}));
  connect(omegaRefPu, pll.omegaRefPu) annotation(
    Line(points = {{-130, 100}, {-59, 100}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-120, -150}, {120, 150}})),
    preferredView = "diagram",
    Icon(coordinateSystem(grid = {1, 1})));
end GridFollowingControl;
