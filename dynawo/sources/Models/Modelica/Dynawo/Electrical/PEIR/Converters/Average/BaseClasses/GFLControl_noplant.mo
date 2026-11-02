within Dynawo.Electrical.PEIR.Converters.Average.BaseClasses;

model GFLControl_noplant


// =============================================================================
// Author : Gaia Bergamaschi
//
// Top-level GFL converter control block.
// Assembles outer loop, inner current loop, and PLL.
// =============================================================================

  parameter Types.ComplexVoltagePu vm0
    "Initial complex voltage at VSC in pu (base UNom)";
  parameter Real Omega0Pu "Initial frequency (pu)";
  parameter Real QInj0Pu "Initial reactive power at converter (pu, generator convention)";
  parameter Real PInj0Pu "Initial active power at converter (pu, generator convention)";
  parameter Real idRef0Pu     "Initial d-axis current reference (pu)";
  parameter Real IdConv0Pu    "Initial d-axis measured current (pu)";
  parameter Real iqRef0Pu     "Initial q-axis current reference (pu)";
  parameter Real IqConv0Pu    "Initial q-axis measured current (pu)";
    // Outer loop — PI output slew-rate limits
  parameter Real DyMaxd  "Max rate of change of d-axis PI output (pu/s)";
  parameter Real DyMaxq  "Max rate of change of q-axis PI output (pu/s)";

  // Outer loop — ramp limiter on idRefPu
  parameter Real DidMax "Max rate of change of idRefPu (pu/s)";
  parameter Real DidMin "Min rate of change of idRefPu (pu/s)";
  parameter Real tSid    "Sample time of idRefPu ramp limiter (s)";

  // Delay between plant controller ed outer loop
 parameter Real tBoost
    "Time constant of first-order filter on iqBoostPu (s). Set 0 to disable";

    parameter Real Kfd "1: apply v_d feed-forward for faster disturbance rejection | 0: PI only";
    parameter Real Kfq "1: apply v_q feed-forward for faster disturbance rejection | 0: PI only";


  // ────────────────────────────────────────────────────────────
  // Design parameters
  // ────────────────────────────────────────────────────────────

  // Current loop
  parameter Real KpdCurrent "Current Loop Proportional gain PI d axis";
  parameter Real KidCurrent "Current Loop integral gain PI d axis";
  parameter Real KpqCurrent "Current Loop Proportional gain PI q axis";
  parameter Real KiqCurrent "Current Loop integral gain PI q axis";
  parameter Real Lg "Grid equivaent inductance (pu)";
  parameter Real Rg "Grid equivaent resistance (pu)";


  parameter Real vd_0         "Initial d-axis converter voltage (pu)";
  parameter Real vq_0         "Initial q-axis converter voltage (pu)";


  parameter Real vmd_0        "Initial modulation voltage reference (pu)";
  parameter Real vmq_0        "Initial modulation voltage reference (pu)";



  // Outer loop — PI gains
  parameter Real KpdOuter "Outer loop Proportional gain PI d axis";
  parameter Real KidOuter "Outer loop intgl gain PI d axis";
  parameter Real KpqOuter "Outer loop Proportional gain PI q axis";
  parameter Real KiqOuter "Outer loop intgl gain PI  q axis";
  parameter Real IMaxPu "Maximum current (pu)";
  parameter Real U_LV0  "Initial LV node voltage magnitude (pu)";


  // Outer loop — current limiter
  parameter Boolean PQFlag      "Q(false) or P(true) priority";
  parameter Real UBoostHighPu "HIgh voltage limit for reactiv power boost (pu)";
  parameter Real UBoostLowPu "Low voltage limit for reactiv power boost (pu)";
  parameter Real Kqv            "Iq boost gain (pu/pu), 0 to disable";
  parameter Real IqBoostMaxPu     "Max Iq boost (pu)";
  parameter Real IqBoostMinPu     "Min Iq boost (pu)";
  parameter Boolean PControlFlag "true: bypass P PI, use idRefPu = PRefPu/UMeasPu | false: use PI regulator (default)";
  parameter Boolean QControlFlag "true: bypass Q PI, use i_q_ref = U_ref/UMeasPu | false: use PI regulator (default)";


  // ───────────────── PLL parameters ─────────────────────────────
  parameter Real KpPLL
    "PLL proportional gain";
  parameter Real KiPLL
    "PLL integral gain";

  parameter Real OmegaMaxPu
    "Maximum PLL frequency (pu)";
  parameter Real OmegaMinPu
    "Minimum PLL frequency (pu)";

  parameter Real Theta0
    "Initial PLL angle (rad)";

  parameter Real Uq0Pu
    "Initial q-axis voltage at PCC in control dq frame (pu)";
  // ────────────────────────────────────────────────────────────
  // Sub-blocks
  // ────────────────────────────────────────────────────────────

 Electrical.Controls.PEIR.BaseControls.Average.CurrentLoop CurrentLoop_GFL(
    k_p_d             = KpdCurrent,
    k_i_d             = KidCurrent,
    k_p_q             = KpqCurrent,
    k_i_q             = KiqCurrent,
    Lg               = Lg,
 idRef0Pu = idRef0Pu, id_meas_0 = IdConv0Pu, iqRef0Pu = iqRef0Pu, iq_meas_0 = IqConv0Pu, vd_0 = vd_0, vq_0 = vq_0, Omega0Pu = Omega0Pu, vmd_0 = vmd_0, vmq_0 = vmq_0,  Kfd = Kfd, Kfq = Kfq) annotation(
    Placement(transformation(origin = {68, 56}, extent = {{-20, -20}, {20, 20}})));

  Electrical.Controls.PEIR.BaseControls.Average.OuterLoop_no_plant OuterLoop_GFL(
    Kpd           = KpdOuter,
    Kid           = KidOuter,
    Kpq           = KpqOuter,
    Kiq           = KiqOuter,
    IMaxPu            = IMaxPu,
    y_start_outer_d = idRef0Pu,
    y_start_outer_q = iqRef0Pu,
    PQFlag          = PQFlag,
    UBoostHighPu    = UBoostHighPu,
    UBoostLowPu    = UBoostLowPu,
    Kqv             = Kqv,
    IqBoostMaxPu      = IqBoostMaxPu,
    IqBoostMinPu      = IqBoostMinPu,

     PInj0Pu = PInj0Pu, QInj0Pu = QInj0Pu, UFilter0Pu = U_LV0, idRef0Pu = idRef0Pu, iqRef0Pu = iqRef0Pu, DyMaxd = DyMaxd, DyMaxq = DyMaxq, DidMax = DidMax, DidMin = DidMin, tSid = tSid, tBoost = tBoost, PControlFlag = PControlFlag, QControlFlag = QControlFlag) annotation(
    Placement(transformation(origin = {-200, 56}, extent = {{-36, -36}, {36, 36}})));

 Dynawo.Electrical.Controls.PEIR.BaseControls.Average.PLL PLL(
    Ki         = KiPLL,
    Kp         = KpPLL,
    OmegaMaxPu = OmegaMaxPu,
    OmegaMinPu = OmegaMinPu,
    Theta0     = Theta0, Omega0Pu = Omega0Pu, uqgrid0PU = Uq0Pu) annotation(
    Placement(transformation(origin = {15, -69}, extent = {{-23, -23}, {23, 23}})));

  Dynawo.Electrical.Controls.WECC.Utilities.TransformDQtoRI transformDQtoRI annotation(
    Placement(transformation(origin = {162, 42}, extent = {{-18, -18}, {18, 18}})));

// ── External inputs ──────────────────────────────────────────
  Modelica.Blocks.Interfaces.RealInput omegaRefPu (start=Omega0Pu) annotation(
    Placement(transformation(origin = {-270, -60}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {72, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

  Modelica.Blocks.Interfaces.RealInput PMeasPu (start=PInj0Pu) annotation(
    Placement(transformation(origin = {-270, 84}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-84, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput V_d_meas (start=vd_0) annotation(
    Placement(transformation(origin = {81, 131}, extent = {{-9, -9}, {9, 9}}, rotation = -90),
    iconTransformation(origin = {46, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput V_q_meas (start=vq_0) annotation(
    Placement(transformation(origin = {59, 129}, extent = {{-9, -9}, {9, 9}}, rotation = -90),
    iconTransformation(origin = {72, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput i_d_meas (start=IdConv0Pu) annotation(
    Placement(transformation(origin = {14, 72}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {18, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealInput i_q_meas (start=IqConv0Pu) annotation(
    Placement(transformation(origin = {12, 30}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {-8, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput PRefPu (start=PInj0Pu) annotation(
    Placement(transformation(origin = {-271, 65}, extent = {{-11, -11}, {11, 11}}), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput U_ref (start=QInj0Pu) annotation(
    Placement(transformation(origin = {-270, 46}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, 10}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput V_q_grid annotation(
    Placement(transformation(origin = {-270, -78}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-110, -50}, extent = {{-10, -10}, {10, 10}})));
  // ── External outputs ─────────────────────────────────────────

  Modelica.Blocks.Interfaces.RealOutput vm_re (start=vm0.re) annotation(
    Placement(transformation(origin = {206, 50}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput vm_im (start=vm0.im) annotation(
    Placement(transformation(origin = {208, 30}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, 8}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput thetaPLL (start=Theta0) annotation(
    Placement(transformation(origin = {72, -78}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}})));

  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu (start=Omega0Pu) annotation(
    Placement(transformation(origin = {74, -60}, extent = {{-10, -10}, {10, 10}}),
    iconTransformation(origin = {110, -30}, extent = {{-10, -10}, {10, 10}})));

// Voltage magnitude for outer loop
  Modelica.Blocks.Sources.RealExpression UMeasPu(
    y = sqrt(V_d_meas^2 + V_q_meas^2)) annotation(
    Placement(transformation(origin = {-270, 102}, extent = {{-10, -10}, {10, 10}})));

 //for graphical clarity at upper level model
  Modelica.Blocks.Interfaces.RealOutput omegaPLLPu_2 annotation(
    Placement(transformation(origin = {110, -60}, extent = {{-6, -6}, {6, 6}}), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
equation
// ── PLL ──────────────────────────────────────────────────────
// ── Transform DQ→RI ──────────────────────────────────────────
// ── Current loop ─────────────────────────────────────────────
// ── Outer loop → current loop ─────────────────────────────────
// ── Outer loop inputs ────────────────────────────────────────
// ── Plant controller → outer loop ────────────────────────────
// ── Plant controller inputs ───────────────────────────────────
// omegaRef to plant controller (external reference,)
// omegaPLL to plant controller (measured frequency for droop)
  connect(transformDQtoRI.ur, vm_re) annotation(
    Line(points = {{182, 53}, {200, 53}, {200, 50}, {206, 50}}, color = {0, 0, 127}));
  connect(transformDQtoRI.ui, vm_im) annotation(
    Line(points = {{182, 31}, {200, 31}, {200, 30}, {208, 30}}, color = {0, 0, 127}));
  connect(PLL.theta, thetaPLL) annotation(
    Line(points = {{40, -78}, {72, -78}}, color = {0, 0, 127}));
  connect(transformDQtoRI.phi, PLL.theta) annotation(
    Line(points = {{142, 31}, {133.5, 31}, {133.5, -97}, {40, -97}, {40, -78}}, color = {0, 0, 127}));
  connect(PLL.omegaPLLPu, omegaPLLPu) annotation(
    Line(points = {{40, -60}, {74, -60}}, color = {0, 0, 127}));
  connect(CurrentLoop_GFL.vm_d, transformDQtoRI.ud) annotation(
    Line(points = {{90, 62}, {142, 62}, {142, 55}}, color = {0, 0, 127}));
  connect(CurrentLoop_GFL.vm_q, transformDQtoRI.uq) annotation(
    Line(points = {{90, 46}, {142, 46}, {142, 47}}, color = {0, 0, 127}));
  connect(CurrentLoop_GFL.v_q, V_q_meas) annotation(
    Line(points = {{60, 78}, {60, 80}, {59, 80}, {59, 129}}, color = {0, 0, 127}));
  connect(CurrentLoop_GFL.omega_pll, PLL.omegaPLLPu) annotation(
    Line(points = {{72, 34}, {72, -46.25}, {40, -46.25}, {40, -60}}, color = {0, 0, 127}));
  connect(i_q_meas, CurrentLoop_GFL.i_q_meas) annotation(
    Line(points = {{12, 30}, {12, 28}, {46, 28}, {46, 44}}, color = {0, 0, 127}));
  connect(i_d_meas, CurrentLoop_GFL.i_d_meas) annotation(
    Line(points = {{14, 72}, {14, 70}, {46, 70}}, color = {0, 0, 127}));
  connect(OuterLoop_GFL.idRefPu, CurrentLoop_GFL.idRefPu) annotation(
    Line(points = {{-159.5, 67}, {-159.5, 62}, {46, 62}, {46, 63}}, color = {0, 0, 127}));
  connect(OuterLoop_GFL.i_q_ref, CurrentLoop_GFL.i_q_ref) annotation(
    Line(points = {{-159.5, 52}, {46, 52}}, color = {0, 0, 127}));
  connect(OuterLoop_GFL.UMeasPu, UMeasPu.y) annotation(
    Line(points = {{-217, 95}, {-217, 100.5}, {-259, 100.5}, {-259, 102}}, color = {0, 0, 127}));
  connect(omegaRefPu, PLL.omegaRefPu) annotation(
    Line(points = {{-270, -60}, {-10, -60}}, color = {0, 0, 127}));
  connect(OuterLoop_GFL.U_ref, U_ref) annotation(
    Line(points = {{-238, 46}, {-270, 46}}, color = {0, 0, 127}));
  connect(PRefPu, OuterLoop_GFL.PRefPu) annotation(
    Line(points = {{-270, 66}, {-238, 66}}, color = {0, 0, 127}));
  connect(PMeasPu, OuterLoop_GFL.PMeasPu) annotation(
    Line(points = {{-270, 84}, {-238, 84}}, color = {0, 0, 127}));
  connect(V_q_grid, PLL.uqgridPu) annotation(
    Line(points = {{-270, -78}, {-10, -78}}, color = {0, 0, 127}));
  connect(CurrentLoop_GFL.v_d, V_d_meas) annotation(
    Line(points = {{80, 78}, {80, 128}, {81, 128}, {81, 131}}, color = {0, 0, 127}));
  connect(omegaPLLPu_2, PLL.omegaPLLPu) annotation(
    Line(points = {{110, -60}, {40, -60}}, color = {0, 0, 127}));
 connect(U_ref, OuterLoop_GFL.U_ref) annotation(
    Line(points = {{-270, 46}, {-238, 46}}, color = {0, 0, 127}));
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
    Diagram(coordinateSystem(extent = {{-260, -120}, {240, 120}}), graphics = {Text(extent = {{-40, 60}, {-40, 60}}, textString = "text")}));




end GFLControl_noplant;
