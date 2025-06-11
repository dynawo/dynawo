within Dynawo.Electrical.Controls.WECC.REEC;

model REECd
  extends Dynawo.Electrical.Controls.WECC.REEC.BaseClasses.BaseREECD(UFilteredPu3(y = firstOrder2.y), firstOrder(k = 1, T = tRv, y_start = UInj0Pu));
  //REECd Parameters
  parameter Types.PerUnit VDLIp11 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp12 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp21 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp22 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp31 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp32 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp41 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIp42 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq11 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq12 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq21 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq22 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq31 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq32 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq41 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIq42 annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIpPoints[:, :] = [VDLIp11, VDLIp12; VDLIp21, VDLIp22; VDLIp31, VDLIp32; VDLIp41, VDLIp42] "Pair of points for voltage-dependent active current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.PerUnit VDLIqPoints[:, :] = [VDLIq11, VDLIq12; VDLIq21, VDLIq22; VDLIq31, VDLIq32; VDLIq41, VDLIq42] "Pair of points for voltage-dependent reactive current limitation piecewise linear curve [u1,y1; u2,y2;...]" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Boolean PFlag "Power reference flag: const. Pref (0) or consider generator speed (1)" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.VoltageModulePu VRef1Pu "User-defined reference/bias on the inner-loop voltage control in pu (base UNom) (typical: 0 pu)" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Real Kc "Reactive droop gain" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Boolean VCompFlag "Type of compensation = 1 - current compensation or 0 reactive droop" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Real tR1 "Filter time constant" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Real Ke "Scaling on the Ipmin: 0 < ke ≤ 1, set to 0 for generator and non-zero for a storage device" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Real XcPu "Current compensation reactance" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Real RcPu "Current compensation resistance" annotation(
    Dialog(tab = "Electrical Control"));
  parameter Types.ComplexPerUnit u0Pu "Start value of complex voltage at regulated bus in pu (base UNom)";
  parameter Types.ComplexPerUnit i0Pu "Start value of complex current at regulated bus in pu (generator convention) (base SNom, UNom)";
  
  // Input Variables
  Modelica.Blocks.Interfaces.RealInput PAuxPu(start = 0) annotation(
    Placement(transformation(origin = {-268, -170}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-30, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput omegaGPu(start = SystemBase.omegaRef0Pu) annotation(
    Placement(transformation(origin = {-270, -101}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-51, -110}, extent = {{10, 10}, {-10, -10}}, rotation = -90)));
  Modelica.Blocks.Sources.RealExpression realExpression(y = QInjPu) annotation(
    Placement(transformation(origin = {-182, -260}, extent = {{-10, -10}, {10, 10}})));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = i0Pu.re), im(start = i0Pu.im)) "Complex current at regulated bus in pu (generator convention) (base SnRef, UNom)" annotation(
    Placement(transformation(origin = {-270, -202}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {70, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at regulated bus in pu (base UNom)" annotation(
    Placement(transformation(origin = {-270, -228}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-69, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  
  Modelica.Blocks.Sources.RealExpression UFilteredPu5(y = UFilteredPu) annotation(
    Placement(transformation(origin = {213, 0}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression IqMax(y = currentLimitsCalculationD.iqMaxPu) annotation(
    Placement(transformation(origin = {130, 130}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.RealExpression IqMin(y = currentLimitsCalculationD.iqMinPu) annotation(
    Placement(transformation(origin = {132, 96}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanExpression FRTOn2(y = frtOn) annotation(
    Placement(transformation(origin = {59, -105}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Sources.Constant VRefConst1(k = VRef1Pu) annotation(
    Placement(transformation(origin = {-83, 96}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant PFlagConst(k = PFlag) annotation(
    Placement(transformation(origin = {-119, -65}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant VCompFlagConst(k = VCompFlag)  annotation(
    Placement(transformation(origin = {-100, -220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch3 annotation(
    Placement(transformation(origin = {-6, -220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Logical.Switch switch4 annotation(
    Placement(transformation(origin = {-40, -66}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Math.Add add2(k2 = Kc) annotation(
    Placement(transformation(origin = {-80, -256}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add3 annotation(
    Placement(transformation(origin = {140, -158}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add add4 annotation(
    Placement(transformation(origin = {-18, 74}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product product4 annotation(
    Placement(transformation(origin = {-166, -94}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds IpmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIpPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(transformation(origin = {307, 36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Tables.CombiTable1Ds IqmaxFromUPu(extrapolation = Modelica.Blocks.Types.Extrapolation.HoldLastPoint, smoothness = Modelica.Blocks.Types.Smoothness.LinearSegments, table = VDLIqPoints, tableOnFile = false, verboseExtrapolation = false, verboseRead = false) annotation(
    Placement(transformation(origin = {309, -36}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tR1, k = 1, y_start = if VCompFlag == true then UInj0Pu else UInj0Pu + Kc*QInj0Pu) annotation(
    Placement(transformation(origin = {46, -220}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Nonlinear.Limiter limiter1(homotopyType = Modelica.Blocks.Types.LimiterHomotopy.NoHomotopy, uMax = Iqh1Pu, uMin = Iql1Pu) annotation(
    Placement(transformation(origin = {264, 220}, extent = {{-10, -10}, {10, 10}})));
  BaseControls.LineDropCompensation lineDropCompensation(RcPu = RcPu, XcPu = XcPu) annotation(
    Placement(transformation(origin = {-185, -215}, extent = {{-21, -21}, {21, 21}})));
  BaseControls.CurrentLimitsCalculationD currentLimitsCalculationD(IMaxPu = IMaxPu, PQFlag = PQFlag, Ke = Ke) annotation(
    Placement(transformation(origin = {383, 5}, extent = {{-27, -27}, {27, 27}})));
  
  equation
  connect(uPu, lineDropCompensation.u2Pu) annotation(
    Line(points = {{-271, -227}, {-271, -228}, {-208, -228}}, color = {85, 170, 255}));
  connect(lineDropCompensation.U2Pu, add2.u1) annotation(
    Line(points = {{-161.9, -227.6}, {-113.9, -227.6}, {-113.9, -250}, {-92, -250}}, color = {0, 0, 127}));
  connect(realExpression.y, add2.u2) annotation(
    Line(points = {{-171, -260}, {-140.5, -260}, {-140.5, -262}, {-92, -262}}, color = {0, 0, 127}));
  connect(switch3.y, firstOrder2.u) annotation(
    Line(points = {{5, -220}, {34, -220}}, color = {0, 0, 127}));
  connect(lineDropCompensation.U1Pu, switch3.u1) annotation(
    Line(points = {{-162, -202}, {-18, -202}, {-18, -212}}, color = {0, 0, 127}));
  connect(add2.y, switch3.u3) annotation(
    Line(points = {{-69, -256}, {-69, -228}, {-18, -228}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, product4.u1) annotation(
    Line(points = {{-218, -40}, {-218, -42}, {-178, -42}, {-178, -88}}, color = {0, 0, 127}));
  connect(product4.y, switch4.u1) annotation(
    Line(points = {{-155, -94}, {-66.5, -94}, {-66.5, -74}, {-52, -74}}, color = {0, 0, 127}));
  connect(slewRateLimiter.y, switch4.u3) annotation(
    Line(points = {{-218, -40}, {-218, -42}, {-52, -42}, {-52, -58}}, color = {0, 0, 127}));
  connect(switch4.y, rateLimFirstOrderFreeze.u) annotation(
    Line(points = {{-29, -66}, {14.5, -66}, {14.5, -70}, {54, -70}}, color = {0, 0, 127}));
  connect(gain.y, limiter1.u) annotation(
    Line(points = {{216, 220}, {252, 220}}, color = {0, 0, 127}));
  connect(limiter1.y, add1.u1) annotation(
    Line(points = {{276, 220}, {318, 220}, {318, 116}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IpmaxFromUPu.u) annotation(
    Line(points = {{224, 0}, {263, 0}, {263, 36}, {295, 36}}, color = {0, 0, 127}));
  connect(UFilteredPu5.y, IqmaxFromUPu.u) annotation(
    Line(points = {{224, 0}, {259, 0}, {259, -36}, {297, -36}}, color = {0, 0, 127}));
  connect(iPu, lineDropCompensation.iPu) annotation(
    Line(points = {{-270, -202}, {-208, -202}}, color = {85, 170, 255}));
  connect(omegaGPu, product4.u2) annotation(
    Line(points = {{-270, -100}, {-178, -100}}, color = {0, 0, 127}));
  connect(IqMax.y, varLimPIDFreeze.yMax) annotation(
    Line(points = {{142, 130}, {168, 130}, {168, 118}}, color = {0, 0, 127}));
  connect(IqMin.y, varLimPIDFreeze.yMin) annotation(
    Line(points = {{143, 96}, {168, 96}, {168, 106}}, color = {0, 0, 127}));
  connect(PFlagConst.y, switch4.u2) annotation(
    Line(points = {{-108, -65}, {-78, -65}, {-78, -66}, {-52, -66}}, color = {255, 0, 255}));
  connect(switch1.y, add4.u2) annotation(
    Line(points = {{-108, 150}, {-100, 150}, {-100, 68}, {-30, 68}}, color = {0, 0, 127}));
  connect(VRefConst1.y, add4.u1) annotation(
    Line(points = {{-72, 96}, {-30, 96}, {-30, 80}}, color = {0, 0, 127}));
  connect(add4.y, switch.u3) annotation(
    Line(points = {{-6, 74}, {16, 74}, {16, 104}}, color = {0, 0, 127}));
  connect(PAuxPu, add3.u2) annotation(
    Line(points = {{-268, -170}, {-80, -170}, {-80, -164}, {128, -164}}, color = {0, 0, 127}));
  connect(add3.y, division1.u1) annotation(
    Line(points = {{151, -158}, {148, -158}, {148, -114}, {170, -114}}, color = {0, 0, 127}));
  connect(division1.y, variableLimiter1.u) annotation(
    Line(points = {{192, -120}, {500, -120}}, color = {0, 0, 127}));
  connect(limiter3.y, add3.u1) annotation(
    Line(points = {{142, -70}, {128, -70}, {128, -152}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationD.iqMinPu, variableLimiter.limit2) annotation(
    Line(points = {{412, -14}, {474, -14}, {474, 102}, {498, 102}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationD.iqMaxPu, variableLimiter.limit1) annotation(
    Line(points = {{412, -4}, {468, -4}, {468, 118}, {498, 118}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationD.ipMinPu, variableLimiter1.limit2) annotation(
    Line(points = {{412, 14}, {444, 14}, {444, -128}, {500, -128}}, color = {0, 0, 127}));
  connect(currentLimitsCalculationD.ipMaxPu, variableLimiter1.limit1) annotation(
    Line(points = {{412, 24}, {460, 24}, {460, -112}, {500, -112}}, color = {0, 0, 127}));
  connect(IpmaxFromUPu.y[1], currentLimitsCalculationD.ipVdlPu) annotation(
    Line(points = {{318, 36}, {338, 36}, {338, 16}, {354, 16}}, color = {0, 0, 127}));
  connect(IqmaxFromUPu.y[1], currentLimitsCalculationD.iqVdlPu) annotation(
    Line(points = {{320, -36}, {328, -36}, {328, -4}, {354, -4}}, color = {0, 0, 127}));
  connect(variableLimiter.y, currentLimitsCalculationD.iqCmdPu) annotation(
    Line(points = {{522, 110}, {526, 110}, {526, 48}, {336, 48}, {336, -14}, {354, -14}}, color = {0, 0, 127}));
  connect(variableLimiter1.y, currentLimitsCalculationD.ipCmdPu) annotation(
    Line(points = {{522, -120}, {530, -120}, {530, -36}, {340, -36}, {340, 26}, {354, 26}}, color = {0, 0, 127}));
  connect(VCompFlagConst.y, switch3.u2) annotation(
    Line(points = {{-89, -220}, {-18, -220}}, color = {255, 0, 255}));
  annotation(
    Diagram,
    Icon(graphics = {Text(origin = {-37, 130.5}, extent = {{-16, 7}, {24, -10}}, textString = "PAuxPu"), Text(origin = {65, 132.5}, extent = {{-16, 7}, {24, -10}}, textString = "iInjPu"), Text(origin = {-81, 130.5}, extent = {{-16, 7}, {24, -10}}, textString = "uInjPu"), Ellipse(origin = {-67, -126}, extent = {{-9, 0}, {9, 0}}), Text(origin = {-30.3275, -106.118}, extent = {{-14.6724, 6.11766}, {22.3276, -9.88234}}, textString = "omegaG"), Text(origin = {-19, 11}, extent = {{-45, 23}, {84, -40}}, textString = "REEC D")}));
end REECd;
