within Dynawo.Electrical.Controls.Converters.BaseControls;

model IECWP4AQControl

  import Modelica;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Connectors;
  import Dynawo.Electrical.SystemBase;

  extends Dynawo.Electrical.Controls.Converters.Parameters.Params_QControl;

  /*Nominal Parameters*/
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";

  /*QControl PArameters*/
  parameter Types.PerUnit RWPDrop "Resistive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit XWPDrop "Reactive component of voltage drop impedance in pu (base SNom, UNom)" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit uWPqdip "Voltage threshold for UVRT detection" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit uWPqrise "Voltage threshold for OVRT detection" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xRefMax "Maximum WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xRefMin "Minimum WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xKIWPxMax "Maximum WT reactive power/voltage reference  from integretion" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xKIWPxMin "Minimum WT reactive power/voltage reference from integretion" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xerrmax "Maximum reactive power error (or voltage error if Mwpmode=2) input to PI controller" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit xerrmin "Minimum reactive power error (or voltage error if Mwpmode=2) input to PI controller" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit dxRefMax "Maximum positive ramp rate for WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit dxRefMin "Minimum negative ramp rate for WT reactive power/voltage reference" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Tuqfilt "Time constant for the UQ static mode" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kwpqu "Voltage controller cross coupling gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kpwpx "Reactive power/voltage PI controller proportional gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kiwpx "Reactive power/voltage PI controller integral gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Types.PerUnit Kwpqref "Reactive power reference gain" annotation(
    Dialog(group = "group", tab = "QControlWP"));
  parameter Integer Mwpqmode "Reactive power/voltage control mode (0 reactive power reference, 1 power factor reference, 2 UQ static, 3 voltage control)" annotation(
    Dialog(group = "group", tab = "QControlWP"));

  /*Operational Parameters*/
  /*Parameters for initialization from load flow*/
  parameter Types.VoltageModulePu U0Pu "Start value of voltage amplitude at plant terminal (PCC) in pu (base UNom)";
  parameter Types.ActivePowerPu P0Pu "Start value of active power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.ActivePowerPu Q0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit X0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";
  parameter Types.PerUnit XWT0Pu "Start value of reactive power at PCC in pu (base SnRef) (receptor convention)";

  /*Inputs*/
  Modelica.Blocks.Interfaces.RealInput xWPRefComPu(start = X0Pu) annotation(
    Placement(visible = true, transformation(origin = {-300, 120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-300, 140}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput pWPfiltComPu(start = -P0Pu * SystemBase.SnRef / SNom ) "Filtered WTT active power measurement communicated to WP (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {-300, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-300, 50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput qWPfiltComPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered WTT active power measurement communicated to WP (Sbase)" annotation(
    Placement(visible = true, transformation(origin = {-300, -20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-300, -50}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput uWPfiltComPu(start = U0Pu) "Filtered WTT voltage measurement communicated to WP (Ubase)" annotation(
    Placement(visible = true, transformation(origin = {-300, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-300, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  /*Outputs*/
  Modelica.Blocks.Interfaces.RealOutput xPDRef(start = XWT0Pu) "Reference reactive power/voltage transmitted to WT" annotation(
    Placement(visible = true, transformation(origin = {300, 110}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {300, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Fwpfrt(start = true) annotation(
    Placement(visible = true, transformation(origin = {300, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {300, 60}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  /*Blocks*/
  Modelica.Blocks.Tables.CombiTable1D combiTable1D(table = tableQwpMaxPwpfiltCom)  annotation(
    Placement(visible = true, transformation(origin = {-170, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D1(table = tableQwpMinPwpfiltCom)  annotation(
    Placement(visible = true, transformation(origin = {-170, 138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-186, 88}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(limitsAtInit = true)  annotation(
    Placement(visible = true, transformation(origin = {-70, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-36, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Kwpqref)  annotation(
    Placement(visible = true, transformation(origin = {30, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = Kpwpx) annotation(
    Placement(visible = true, transformation(origin = {70, 140}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = Kiwpx, y_start = XWT0Pu)  annotation(
    Placement(visible = true, transformation(origin = {77,79}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {120, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {152, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain2(k = Kwpqu) annotation(
    Placement(visible = true, transformation(origin = {-120, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = xRefMax, uMin = xRefMin)  annotation(
    Placement(visible = true, transformation(origin = {200, 110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTable1D2(table = tableQwpUerr)  annotation(
    Placement(visible = true, transformation(origin = {-214, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tuqfilt, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {-198, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Or or1 annotation(
    Placement(visible = true, transformation(origin = {120, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater annotation(
    Placement(visible = true, transformation(origin = {-10, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Logical.Greater greater1 annotation(
    Placement(visible = true, transformation(origin = {-10, -150}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const(k = uWPqdip)  annotation(
    Placement(visible = true, transformation(origin = {-70, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const1(k = uWPqrise)  annotation(
    Placement(visible = true, transformation(origin = {-70, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const2(k = 0)  annotation(
    Placement(visible = true, transformation(origin = {-150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter2(limitsAtInit = true, uMax = xKIWPxMax, uMin = xKIWPxMin) annotation(
    Placement(visible = true, transformation(origin = {99, 79}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiter3(limitsAtInit = true, uMax = xerrmax, uMin = xerrmin) annotation(
    Placement(visible = true, transformation(origin = {24, 116}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant(k = Mwpqmode)  annotation(
    Placement(visible = true, transformation(origin = {-270, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.Converters.BaseControls.IECQcontrolVDrop voltageDrop(P0Pu = P0Pu, Q0Pu = Q0Pu, RDrop = RWPDrop, SNom = SNom, U0Pu = U0Pu, XDrop = XWPDrop)  annotation(
    Placement(visible = true, transformation(origin = {-218, -140}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFour switch1 annotation(
    Placement(visible = true, transformation(origin = {-118, 82}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitchFour switch11 annotation(
    Placement(visible = true, transformation(origin = {-4, 116}, extent = {{-12, -12}, {12, 12}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {45, 97}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch annotation(
    Placement(visible = true, transformation(origin = {59, 79}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Add add2(k2 = -100)  annotation(
    Placement(visible = true, transformation(origin = {31, 79}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Modelica.Blocks.Math.Add add3(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {130, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(visible = true, transformation(origin = {-160, 60}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const3(k = -Q0Pu * SystemBase.SnRef / SNom)  annotation(
    Placement(visible = true, transformation(origin = {-220, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-224, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {-120, -80}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.FirstOrderRamp firstOrderRamp(DuMax = dxRefMax, DuMin = dxRefMin, T = 0.001, y_start = XWT0Pu)  annotation(
    Placement(visible = true, transformation(origin = {250, 110}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5(k2 = -1) annotation(
    Placement(visible = true, transformation(origin = {130, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add6 annotation(
    Placement(visible = true, transformation(origin = {90, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant const4(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-213, 37}, extent = {{-5, 5}, {5, -5}}, rotation = 0)));
  Modelica.Blocks.Logical.Switch switch12 annotation(
    Placement(visible = true, transformation(origin = {-184, 32}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
equation
  connect(xWPRefComPu, product.u1) annotation(
    Line(points = {{-300, 120}, {-260, 120}, {-260, 95}, {-200, 95}}, color = {0, 0, 127}));
  connect(variableLimiter.y, feedback.u1) annotation(
    Line(points = {{-59, 112}, {-44, 112}}, color = {0, 0, 127}));
  connect(qWPfiltComPu, feedback.u2) annotation(
    Line(points = {{-300, -20}, {-36, -20}, {-36, 104}}, color = {0, 0, 127}));
  connect(qWPfiltComPu, gain2.u) annotation(
    Line(points = {{-300, -20}, {-120, -20}, {-120, -38}}, color = {0, 0, 127}));
  connect(add1.y, limiter.u) annotation(
    Line(points = {{163, 110}, {188, 110}}, color = {0, 0, 127}));
  connect(or1.y, Fwpfrt) annotation(
    Line(points = {{142, -120}, {300, -120}}, color = {255, 0, 255}));
  connect(integrator.y, limiter2.u) annotation(
    Line(points = {{85, 79}, {91, 79}}, color = {0, 0, 127}));
  connect(limiter2.y, add.u2) annotation(
    Line(points = {{107, 79}, {104, 79}, {104, 104}, {108, 104}}, color = {0, 0, 127}));
  connect(feedback.y, switch11.u0) annotation(
    Line(points = {{-26, 112}, {-22, 112}, {-22, 126}, {-17, 126}}, color = {0, 0, 127}));
  connect(feedback.y, switch11.u1) annotation(
    Line(points = {{-26, 112}, {-22, 112}, {-22, 120}, {-17, 120}}, color = {0, 0, 127}));
  connect(feedback.y, switch11.u2) annotation(
    Line(points = {{-26, 112}, {-17, 112}}, color = {0, 0, 127}));
  connect(gain1.y, add.u1) annotation(
    Line(points = {{82, 140}, {104, 140}, {104, 116}, {108, 116}}, color = {0, 0, 127}));
  connect(variableLimiter.y, gain.u) annotation(
    Line(points = {{-59, 112}, {-52, 112}, {-52, 170}, {18, 170}}, color = {0, 0, 127}));
  connect(switch1.y, variableLimiter.u) annotation(
    Line(points = {{-96, 82}, {-90, 82}, {-90, 112}, {-82, 112}}, color = {0, 0, 127}));
  connect(const2.y, switch1.u3) annotation(
    Line(points = {{-139, 0}, {-140, 0}, {-140, 66}}, color = {0, 0, 127}));
  connect(const.y, greater.u1) annotation(
    Line(points = {{-58, -100}, {-48, -100}, {-48, -110}, {-22, -110}}, color = {0, 0, 127}));
  connect(const1.y, greater1.u2) annotation(
    Line(points = {{-59, -170}, {-48, -170}, {-48, -158}, {-22, -158}}, color = {0, 0, 127}));
  connect(combiTable1D.y[1], variableLimiter.limit1) annotation(
    Line(points = {{-158, 170}, {-90, 170}, {-90, 120}, {-82, 120}}, color = {0, 0, 127}));
  connect(combiTable1D1.y[1], variableLimiter.limit2) annotation(
    Line(points = {{-158, 138}, {-94, 138}, {-94, 104}, {-82, 104}}, color = {0, 0, 127}));
  connect(pWPfiltComPu, combiTable1D.u[1]) annotation(
    Line(points = {{-300, 80}, {-240, 80}, {-240, 170}, {-182, 170}, {-182, 170}}, color = {0, 0, 127}));
  connect(pWPfiltComPu, combiTable1D1.u[1]) annotation(
    Line(points = {{-300, 80}, {-240, 80}, {-240, 138}, {-182, 138}}, color = {0, 0, 127}));
  connect(switch11.y, limiter3.u) annotation(
    Line(points = {{10, 116}, {14, 116}}, color = {0, 0, 127}));
  connect(limiter3.y, gain1.u) annotation(
    Line(points = {{33, 116}, {38, 116}, {38, 140}, {58, 140}}, color = {0, 0, 127}));
  connect(product.y, switch1.u1) annotation(
    Line(points = {{-173, 88}, {-140, 88}}, color = {0, 0, 127}));
  connect(add.y, add1.u2) annotation(
    Line(points = {{132, 110}, {136, 110}, {136, 104}, {140, 104}}, color = {0, 0, 127}));
  connect(gain.y, add1.u1) annotation(
    Line(points = {{42, 170}, {140, 170}, {140, 116}}, color = {0, 0, 127}));
  connect(voltageDrop.uWTCfiltDropPu, greater.u2) annotation(
    Line(points = {{-196, -140}, {-180, -140}, {-180, -120}, {-22, -120}, {-22, -118}}, color = {0, 0, 127}));
  connect(voltageDrop.uWTCfiltDropPu, greater1.u1) annotation(
    Line(points = {{-196, -140}, {-180, -140}, {-180, -150}, {-22, -150}}, color = {0, 0, 127}));
  connect(uWPfiltComPu, voltageDrop.uWTCfiltPu) annotation(
    Line(points = {{-300, -140}, {-280, -140}, {-280, -154}, {-240, -154}}, color = {0, 0, 127}));
  connect(qWPfiltComPu, voltageDrop.qWTCfiltPu) annotation(
    Line(points = {{-300, -20}, {-270, -20}, {-270, -140}, {-240, -140}}, color = {0, 0, 127}));
  connect(pWPfiltComPu, voltageDrop.pWTCfiltPu) annotation(
    Line(points = {{-300, 80}, {-240, 80}, {-240, -126}}, color = {0, 0, 127}));
  connect(greater.y, or1.u1) annotation(
    Line(points = {{2, -110}, {60, -110}, {60, -120}, {96, -120}}, color = {255, 0, 255}));
  connect(greater1.y, or1.u2) annotation(
    Line(points = {{2, -150}, {62, -150}, {62, -136}, {96, -136}}, color = {255, 0, 255}));
  connect(pWPfiltComPu, product.u2) annotation(
    Line(points = {{-300, 80}, {-202, 80}, {-202, 80}, {-200, 80}}, color = {0, 0, 127}));
  connect(integerConstant.y, switch1.M) annotation(
    Line(points = {{-258, 160}, {-118, 160}, {-118, 104}, {-118, 104}}, color = {255, 127, 0}));
  connect(integerConstant.y, switch11.M) annotation(
    Line(points = {{-258, 160}, {-4, 160}, {-4, 130}, {-4, 130}}, color = {255, 127, 0}));
  connect(xWPRefComPu, switch1.u0) annotation(
    Line(points = {{-300, 120}, {-160, 120}, {-160, 98}, {-140, 98}, {-140, 98}}, color = {0, 0, 127}));
  connect(constant1.y, switch.u1) annotation(
    Line(points = {{50.5, 97}, {51, 97}, {51, 85}}, color = {0, 0, 127}));
  connect(or1.y, switch.u2) annotation(
    Line(points = {{142, -120}, {180, -120}, {180, -40}, {46, -40}, {46, 79}, {51, 79}}, color = {255, 0, 255}));
  connect(switch.y, integrator.u) annotation(
    Line(points = {{67, 79}, {69, 79}}, color = {0, 0, 127}));
  connect(limiter3.y, add2.u1) annotation(
    Line(points = {{32, 116}, {38, 116}, {38, 94}, {20, 94}, {20, 82}, {23, 82}, {23, 83}}, color = {0, 0, 127}));
  connect(add1.y, add3.u1) annotation(
    Line(points = {{163, 110}, {174, 110}, {174, 6}, {142, 6}}, color = {0, 0, 127}));
  connect(const3.y, add4.u1) annotation(
    Line(points = {{-209, 60}, {-191.5, 60}, {-191.5, 65}, {-170, 65}}, color = {0, 0, 127}));
  connect(add4.y, switch1.u2) annotation(
    Line(points = {{-151, 60}, {-148, 60}, {-148, 74}, {-140, 74}, {-140, 76}}, color = {0, 0, 127}));
  connect(voltageDrop.uWTCfiltDropPu, feedback1.u2) annotation(
    Line(points = {{-196, -140}, {-180, -140}, {-180, -106}, {-224, -106}, {-224, -88}}, color = {0, 0, 127}));
  connect(feedback1.y, combiTable1D2.u[1]) annotation(
    Line(points = {{-214, -80}, {-214, -58}}, color = {0, 0, 127}));
  connect(xWPRefComPu, feedback1.u1) annotation(
    Line(points = {{-300, 120}, {-260, 120}, {-260, -80}, {-232, -80}}, color = {0, 0, 127}));
  connect(feedback1.y, feedback2.u1) annotation(
    Line(points = {{-214, -80}, {-130, -80}, {-130, -80}, {-128, -80}}, color = {0, 0, 127}));
  connect(gain2.y, feedback2.u2) annotation(
    Line(points = {{-120, -61}, {-120, -72}}, color = {0, 0, 127}));
  connect(feedback2.y, switch11.u3) annotation(
    Line(points = {{-110, -80}, {-22, -80}, {-22, 106}, {-18, 106}, {-18, 106}}, color = {0, 0, 127}));
  connect(add2.y, switch.u3) annotation(
    Line(points = {{39, 79}, {42, 79}, {42, 73}, {51, 73}}, color = {0, 0, 127}));
  connect(limiter.y, add3.u2) annotation(
    Line(points = {{211, 110}, {224, 110}, {224, -6}, {142, -6}}, color = {0, 0, 127}));
  connect(limiter.y, firstOrderRamp.u) annotation(
    Line(points = {{211, 110}, {238, 110}}, color = {0, 0, 127}));
  connect(firstOrderRamp.y, xPDRef) annotation(
    Line(points = {{262, 110}, {286, 110}, {286, 110}, {300, 110}}, color = {0, 0, 127}));
  connect(limiter2.y, add5.u2) annotation(
    Line(points = {{106, 80}, {160, 80}, {160, 34}, {142, 34}}, color = {0, 0, 127}));
  connect(integrator.y, add5.u1) annotation(
    Line(points = {{85, 79}, {88, 79}, {88, 60}, {152, 60}, {152, 46}, {142, 46}}, color = {0, 0, 127}));
  connect(add5.y, add6.u1) annotation(
    Line(points = {{120, 40}, {112, 40}, {112, 36}, {102, 36}}, color = {0, 0, 127}));
  connect(add3.y, add6.u2) annotation(
    Line(points = {{120, 0}, {112, 0}, {112, 24}, {102, 24}}, color = {0, 0, 127}));
  connect(add6.y, add2.u2) annotation(
    Line(points = {{79, 30}, {0, 30}, {0, 74}, {22, 74}}, color = {0, 0, 127}));
  connect(combiTable1D2.y[1], firstOrder.u) annotation(
    Line(points = {{-214, -35}, {-214, -4}, {-210, -4}}, color = {0, 0, 127}));
  connect(or1.y, switch12.u2) annotation(
    Line(points = {{142, -120}, {180, -120}, {180, -40}, {46, -40}, {46, 20}, {-204, 20}, {-204, 32}, {-194, 32}}, color = {255, 0, 255}));
  connect(firstOrder.y, switch12.u3) annotation(
    Line(points = {{-186, -4}, {-180, -4}, {-180, 16}, {-200, 16}, {-200, 26}, {-194, 26}}, color = {0, 0, 127}));
  connect(const4.y, switch12.u1) annotation(
    Line(points = {{-207.5, 37}, {-208, 37}, {-208, 38}, {-194, 38}}, color = {0, 0, 127}));
  connect(switch12.y, add4.u2) annotation(
    Line(points = {{-175, 32}, {-170, 32}, {-170, 55}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-280, -180}, {280, 180}})),
    Icon(coordinateSystem(extent = {{-280, -180}, {280, 180}}, initialScale = 0.1), graphics = {Rectangle(origin = {0, -1}, fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-280, 181}, {280, -179}}), Text(origin = {1, -103}, extent = {{-99, 59}, {99, -59}}, textString = "module"), Text(origin = {-55, 63}, extent = {{-101, 61}, {205, -181}}, textString = "Q Control"), Text(origin = {-13, 119}, extent = {{-71, 33}, {99, -59}}, textString = "WP")}));

end IECWP4AQControl;
