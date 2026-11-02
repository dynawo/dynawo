within Dynawo.Electrical.PEIR.Plants.Average.BaseClasses;

model GFLControl "Top-level GFL converter control block. Assembles outer loop, inner current loop, and PLL."

  // Outer loop
  parameter Types.PerUnit DidMax "Max rate of change of idRefPu in pu/s";
  parameter Types.PerUnit DidMin "Min rate of change of idRefPu in pu/s";
  parameter Types.PerUnit IqBoostMaxPu "Max reactive current boost in pu";
  parameter Types.PerUnit IqBoostMinPu "Min reactive current boost in pu";
  parameter Types.CurrentModulePu IMaxPu  "Maximum total current magnitude in pu";
  parameter Types.PerUnit KidOuter "Outer loop intgl gain PI d axis";
  parameter Types.PerUnit KpdOuter "Outer loop Proportional gain PI d axis";
  parameter Types.PerUnit KiqOuter "Outer loop intgl gain PI  q axis";
  parameter Types.PerUnit KpqOuter "Outer loop Proportional gain PI q axis";
  parameter Types.PerUnit Kqv "Reactive boost boost gain  in pu/pu, 0 to disable";
  parameter Boolean PQFlag "Priority flag: true = P priority, false = Q priority";
  parameter Boolean PControlFlag "true: bypass P PI, use idRefPu = PRefPu/ULVPu | false: use PI regulator (default)";
  parameter Boolean QControlFlag "true: bypass Q PI, use i_q_ref = QRefPu/ULVPu | false: use PI regulator (default)";
  parameter Types.VoltageModulePu UBoostHighPu "High voltage limit for reactiv power boost in pu";
  parameter Types.VoltageModulePu UBoostLowPu "Low voltage limit for reactiv power boost in pu";
  parameter Types.Time tBoost "Time constant of first-order filter on iqBoostPu in s to delay the reactive boost response. Set 0 to disable";
  parameter Types.Time tPlant "Time constant of plant-to-outer-loop delay in s";
  parameter Types.Time tSid "Sample time of idRefPu ramp limiter in s";

  // Current loop
  parameter Real Kfd "1: apply v_d feed-forward for faster disturbance rejection | 0: PI only";
  parameter Real Kfq "1: apply v_q feed-forward for faster disturbance rejection | 0: PI only";
  parameter Real KpdCurrent "Current Loop Proportional gain PI d axis";
  parameter Real KidCurrent "Current Loop integral gain PI d axis";
  parameter Real KpqCurrent "Current Loop Proportional gain PI q axis";
  parameter Real KiqCurrent "Current Loop integral gain PI q axis";
  parameter Real Lg "Grid equivaent inductance (pu)";
  parameter Real Rg "Grid equivaent resistance (pu)";

  // PLL parameters
  parameter Real KpPLL "PLL proportional gain";
  parameter Real KiPLL "PLL integral gain";
  parameter Real OmegaMaxPu "Maximum PLL frequency (pu)";
  parameter Real OmegaMinPu "Minimum PLL frequency (pu)";
  parameter Real Theta0 "Initial PLL angle (rad)";
  parameter Real Uq0Pu "Initial q-axis voltage at PCC in control dq frame (pu)";

  Dynawo.Electrical.Controls.PEIR.BaseControls.CurrentLoops.DynCurrentLoop currentLoop(
    Kfd = Kfd,
    Kfq = Kfq,
    Kpc = KpdCurrent,
    Kic = KidCurrent,
    LFilterPu = Lg,
    UdFilter0Pu = vd_0,
    UqFilter0Pu = vq_0,
    IdConv0Pu = IdConv0Pu,
    IqConv0Pu = IqConv0Pu,
    UdConv0Pu = vmd_0,
    UqConv0Pu = vmq_0,
    IdConvRef0Pu = idRef0Pu,
    IqConvRef0Pu = iqRef0Pu,
    Omega0Pu = Omega0Pu)
    annotation(
      Placement(transformation(origin = {20, 20}, extent = {{-20, -20}, {20, 20}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.OuterLoopQControl OuterLoop_GFL(
    PControlFlag = PControlFlag,
    QControlFlag = QControlFlag,
    Kpd = KpdOuter,
    Kid = KidOuter,
    Kpq = KpqOuter,
    Kiq = KiqOuter,
    IMaxPu = IMaxPu,
    PQFlag = PQFlag,
    UBoostHighPu = UBoostHighPu,
    UBoostLowPu = UBoostLowPu,
    Kqv = Kqv,
    IqBoostMaxPu = IqBoostMaxPu,
    IqBoostMinPu = IqBoostMinPu,
    PInj0Pu = PInj0Pu,
    QInj0Pu = QInj0Pu,
    UFilter0Pu = U_LV0,
    Id0Pu = idRef0Pu,
    Iq0Pu = iqRef0Pu,
    DidMax = DidMax,
    DidMin = DidMin,
    tSid = tSid,
    tPlant = tPlant,
    tBoost = tBoost)
    annotation(
    Placement(transformation(origin = {-80, 20}, extent = {{-20, -20}, {20, 20}})));

  Dynawo.Electrical.Controls.PEIR.BaseControls.Average.PLL PLL(
    Ki         = KiPLL,
    Kp         = KpPLL,
    OmegaMaxPu = OmegaMaxPu,
    OmegaMinPu = OmegaMinPu,
    Theta0     = Theta0,
    Omega0Pu = Omega0Pu,
    uqgrid0PU = Uq0Pu)
    annotation(
    Placement(transformation(origin = {-140, 100}, extent = {{-20, -20}, {20, 20}})));

  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(transformation(origin = {120, 20}, extent = {{-20, -20}, {20, 20}})));

  // Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu (start=Omega0Pu) annotation(
    Placement(transformation(origin = {-190, 108}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {72, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput PLVPu (start=PInj0Pu) annotation(
    Placement(transformation(origin = {-190, 40}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-84, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QLVPu (start=QInj0Pu) annotation(
    Placement(transformation(origin = {-190, -20}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-48, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udLVPu (start=vd_0) annotation(
    Placement(transformation(origin = {-20, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90),
    iconTransformation(origin = {46, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput uqLVPu (start=vq_0) annotation(
    Placement(transformation(origin = {0, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90),
    iconTransformation(origin = {72, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu (start=IdConv0Pu) annotation(
    Placement(transformation(origin = {40, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90),
    iconTransformation(origin = {18, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu (start=IqConv0Pu) annotation(
    Placement(transformation(origin = {60, -130}, extent = {{-10, -10}, {10, 10}}, rotation = 90),
    iconTransformation(origin = {-8, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu (start=PInj0Pu) annotation(
    Placement(transformation(origin = {-190, 20}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput QRefPu (start=QInj0Pu) annotation(
    Placement(transformation(origin = {-190, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu annotation(
    Placement(transformation(origin = {-190, 92}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput ULVPu annotation(
    Placement(transformation(origin = {-190, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -80}, extent = {{-10, -10}, {10, 10}})));

  // Output variables
  Modelica.Blocks.Interfaces.RealOutput vm_re (start=vm0.re) annotation(
    Placement(transformation(origin = {190, 32}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput vm_im (start=vm0.im) annotation(
    Placement(transformation(origin = {190, 8}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, 8}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput thetaPLL (start=Theta0) annotation(
    Placement(transformation(origin = {190, 92}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu (start=Omega0Pu) annotation(
    Placement(transformation(origin = {190, 108}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));

  // Initial parameters
  parameter Real Omega0Pu "Initial frequency (pu)";
  parameter Real QInj0Pu "Initial reactive power at converter (pu, generator convention)";
  parameter Real PInj0Pu "Initial active power at converter (pu, generator convention)";
  parameter Real idRef0Pu "Initial d-axis current reference (pu)";
  parameter Real IdConv0Pu "Initial d-axis measured current (pu)";
  parameter Real iqRef0Pu "Initial q-axis current reference (pu)";
  parameter Real IqConv0Pu "Initial q-axis measured current (pu)";
  parameter Real U_LV0 "Initial LV node voltage magnitude (pu)";
  parameter Real vd_0 "Initial d-axis converter voltage (pu)";
  parameter Real vq_0 "Initial q-axis converter voltage (pu)";
  parameter Types.ComplexVoltagePu vm0 "Initial complex voltage at VSC in pu (base UNom)";
  parameter Real vmd_0 "Initial modulation voltage reference (pu)";
  parameter Real vmq_0 "Initial modulation voltage reference (pu)";

equation
  connect(transformDQtoRI.ur, vm_re) annotation(
    Line(points = {{142, 32}, {190, 32}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ui, vm_im) annotation(
    Line(points = {{142, 8}, {190, 8}}, color = {0, 0, 127}));
  connect(PLL.theta, thetaPLL) annotation(
    Line(points = {{-118, 92}, {190, 92}}, color = {0, 0, 127}));
  connect(PLL.omegaPLLPu, omegaPLLPu) annotation(
    Line(points = {{-118, 108}, {190, 108}}, color = {0, 0, 127}));
  connect(omegaRefPu, PLL.omegaRefPu) annotation(
    Line(points = {{-190, 108}, {-162, 108}}, color = {0, 0, 127}));
  connect(uqFilterPu, PLL.uqgridPu) annotation(
    Line(points = {{-190, 92}, {-162, 92}}, color = {0, 0, 127}));
  connect(currentLoop.udConvRefPu, transformDQtoRI.ud) annotation(
    Line(points = {{42, 28}, {60, 28}, {60, 34}, {98, 34}}, color = {0, 0, 127}));
  connect(currentLoop.uqConvRefPu, transformDQtoRI.uq) annotation(
    Line(points = {{42, 12}, {80, 12}, {80, 26}, {98, 26}}, color = {0, 0, 127}));
  connect(currentLoop.omegaPu, PLL.omegaPLLPu) annotation(
    Line(points = {{20, 42}, {20, 108}, {-118, 108}}, color = {0, 0, 127}));
  connect(PLL.theta, transformDQtoRI.phi) annotation(
    Line(points = {{-118, 92}, {68, 92}, {68, 8}, {98, 8}}, color = {0, 0, 127}));
  connect(iqConvPu, currentLoop.iqConvPu) annotation(
    Line(points = {{60, -130}, {60, -40}, {40, -40}, {40, -2}}, color = {0, 0, 127}));
  connect(idConvPu, currentLoop.idConvPu) annotation(
    Line(points = {{40, -130}, {40, -60}, {30, -60}, {30, -2}}, color = {0, 0, 127}));
  connect(uqLVPu, currentLoop.uqFilterPu) annotation(
    Line(points = {{0, -130}, {0, -60}, {10, -60}, {10, -2}}, color = {0, 0, 127}));
  connect(udLVPu, currentLoop.udFilterPu) annotation(
    Line(points = {{-20, -130}, {-20, -40}, {0, -40}, {0, -2}}, color = {0, 0, 127}));
  connect(PLVPu, OuterLoop_GFL.PLVPu) annotation(
    Line(points = {{-190, 40}, {-120, 40}, {-120, 36}, {-102, 36}}, color = {0, 0, 127}));
  connect(PRefPu, OuterLoop_GFL.PRefPu) annotation(
    Line(points = {{-190, 20}, {-120, 20}, {-120, 26}, {-102, 26}}, color = {0, 0, 127}));
  connect(QRefPu, OuterLoop_GFL.QRefPu) annotation(
    Line(points = {{-190, 0}, {-120, 0}, {-120, 14}, {-102, 14}}, color = {0, 0, 127}));
  connect(QLVPu, OuterLoop_GFL.QLVPu) annotation(
    Line(points = {{-190, -20}, {-112, -20}, {-112, 4}, {-102, 4}}, color = {0, 0, 127}));

  connect(OuterLoop_GFL.idRefPu, currentLoop.idConvRefPu) annotation(
    Line(points = {{-58, 28}, {-2, 28}}, color = {0, 0, 127}));
  connect(OuterLoop_GFL.iqRefPu, currentLoop.iqConvRefPu) annotation(
    Line(points = {{-58, 12}, {-2, 12}}, color = {0, 0, 127}));
  connect(ULVPu, OuterLoop_GFL.ULVPu) annotation(
    Line(points = {{-190, 60}, {-90, 60}, {-90, 42}}, color = {0, 0, 127}));
  annotation(
    uses(Dynawo(version = "1.8.0"), Modelica(version = "3.2.3")),
    Documentation(info = "<html>
      <p><b>Author:</b> Gaia Bergamaschi</p>
      <p>Top-level control block for a Grid-Following (GFL) converter.</p>
      <p>Assembles: outer loop (P/Q → id/iq references),
      inner current loop (id/iq → vm_d/vm_q), and PLL (theta, omega).</p>
    </html>"),
    Icon(graphics = {
      Rectangle(extent = {{-100, 100}, {100, -100}}),
      Text(origin = {4, -10}, extent = {{-90, 20}, {90, -20}},
           textString = "GFL Control"),
      Text(origin = {14, -8}, extent = {{-90, 15}, {90, -15}},
           textString = "")},
      coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    Diagram(coordinateSystem(extent = {{-180, -120}, {180, 120}}), graphics = {Text(extent = {{-40, 60}, {-40, 60}}, textString = "text")}));
end GFLControl;
