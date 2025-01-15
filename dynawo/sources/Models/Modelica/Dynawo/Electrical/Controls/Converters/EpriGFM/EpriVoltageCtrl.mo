within Dynawo.Electrical.Controls.Converters.EpriGFM;

model EpriVoltageCtrl
  extends Parameters.VoltageCtrl;
  extends Parameters.InitialVoltageCtrl;
  
  Modelica.Blocks.Interfaces.RealInput deltaOmega(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-260, 145}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vd(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-260, 15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRef(start = UdFilter0Pu) "d-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-260, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput VRef(start = UqFilter0Pu) "q-axis voltage reference at the converter's capacitor in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-260, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput p(start = IdPcc0Pu) "d-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110,40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput QAux(start = IqPcc0Pu) "q-axis current in the grid in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-260, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-50,-110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));

  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {260, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {260, -78}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Gain gainPiP(k = Kpp) annotation(
    Placement(visible = true, transformation(origin = {10, 170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackP annotation(
    Placement(visible = true, transformation(origin = {-134, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackV annotation(
    Placement(visible = true, transformation(origin = {-175, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiQ(k = Kpv) annotation(
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiP annotation(
    Placement(visible = true, transformation(origin = {50, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiQ annotation(
    Placement(visible = true, transformation(origin = {15, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  
  Modelica.Blocks.Math.Gain gainDroop(k = 1 / wDroop) annotation(
    Placement(visible = true, transformation(origin = {-122, 145}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackDroop annotation(
    Placement(visible = true, transformation(origin = {-98, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPAux annotation(
    Placement(visible = true, transformation(origin = {-55, 186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PAux(start = UdFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-260, 200}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput QRef annotation(
    Placement(visible = true, transformation(origin = {-260.5, -45.5}, extent = {{-10.5, -10.5}, {10.5, 10.5}}, rotation = 0), iconTransformation(origin = {-110, 70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput q annotation(
    Placement(visible = true, transformation(origin = {-260, -70}, extent = {{-11, -11}, {11, 11}}, rotation = 0), iconTransformation(origin = {-110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackQ annotation(
    Placement(visible = true, transformation(origin = {-180, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainQDroop(k = QDroop) annotation(
    Placement(visible = true, transformation(origin = {-140, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addQAux annotation(
    Placement(visible = true, transformation(origin = {-135, -5}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addQu annotation(
    Placement(visible = true, transformation(origin = {-82, -11}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainInvertSign(k = -1) annotation(
    Placement(visible = true, transformation(origin = {55, -15}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerConstant integerConstant1(k = wflag) annotation(
    Placement(visible = true, transformation(origin = {89, 31}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchQ(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {159, -77}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiV annotation(
    Placement(visible = true, transformation(origin = {50, 83}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiV(k = Kpp) annotation(
    Placement(visible = true, transformation(origin = {10, 77}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add5 annotation(
    Placement(visible = true, transformation(origin = {20, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain7(k = Kpv) annotation(
    Placement(visible = true, transformation(origin = {-20, -155}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput vQConvPu(start = UqFilter0Pu) annotation(
    Placement(visible = true, transformation(origin = {-265, -145}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin={-110,-10}, extent = {{-10,-10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback4 annotation(
    Placement(visible = true, transformation(origin = {-85, -170}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainInvertSign2(k = 1) annotation(
    Placement(visible = true, transformation(origin = {54, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant constant1(k = 0) annotation(
    Placement(visible = true, transformation(origin = {-225, -170}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterD(limitsAtInit = true, uMax = 1.2, uMin = -1.2)  annotation(
    Placement(visible = true, transformation(origin = {148, 85}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterQ(limitsAtInit = true, uMax = 1.2, uMin = -1.2)  annotation(
    Placement(visible = true, transformation(origin = {194, -77}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitchD(nu = 4) annotation(
    Placement(visible = true, transformation(origin = {104, 83}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Sqrt sqrt1 annotation(
    Placement(visible = true, transformation(origin = {-129, -225}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {-167, -225}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product annotation(
    Placement(visible = true, transformation(origin = {-216, -249}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product product1 annotation(
    Placement(visible = true, transformation(origin = {-217, -210}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.LvrtFrz lvrtFrz(VDipPu = VDipPu)  annotation(
    Placement(visible = true, transformation(origin = {-65, -225}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiVq(K = Kiv, UseFreeze = true, Y0 = 0, y(start = 0)) annotation(
    Placement(visible = true, transformation(origin = {-22, -186}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiQ(K = Kiv, UseFreeze = true, y(start = 0)) annotation(
    Placement(visible = true, transformation(origin = {-23, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiV(K = Kip, UseFreeze = true, Y0 = 0.5, y(start = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {11, 109}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.Continuous.IntegratorSetFreeze integratorSetFreezePiP(K = Kip, UseFreeze = true, Y0 = 0.5, y(start = 0.5)) annotation(
    Placement(visible = true, transformation(origin = {10, 199}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.EpriGFM.CurrentLimiter currentLimiter(IMaxPu = IMaxPu, PQflag = PQflag, idConvRefLimPu(start = 0.5), idConvRefPu(start = 0.5), iqConvRefLimPu(start = 0), iqConvRefPu(start = 0))  annotation(
    Placement(visible = true, transformation(origin = {190, 9}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {234, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.MultiSwitch multiSwitch1(nu = 2) annotation(
    Placement(visible = true, transformation(origin = {235, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.IntegerStep integerStep(offset = 1, startTime = 200)  annotation(
    Placement(visible = true, transformation(origin = {159, 43}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.BooleanOutput Frz annotation(
    Placement(visible = true, transformation(origin = {259, -225}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {74, -110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
equation
  connect(feedbackP.u1, PRef) annotation(
    Line(points = {{-142, 180}, {-260, 180}}, color = {0, 0, 127}));
  connect(feedbackV.u1, VRef) annotation(
    Line(points = {{-183, 0}, {-260, 0}}, color = {0, 0, 127}));
  connect(feedbackV.u2, vd) annotation(
    Line(points = {{-175, 8}, {-175, 16}, {-260, 16}}, color = {0, 0, 127}));
  connect(addPiP.u2, gainPiP.y) annotation(
    Line(points = {{38, 180}, {29.5, 180}, {29.5, 170}, {21, 170}}, color = {0, 0, 127}));
  connect(addPiQ.u1, gainPiQ.y) annotation(
    Line(points = {{3, -9}, {-4, -9}, {-4, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(deltaOmega, gainDroop.u) annotation(
    Line(points = {{-260, 145}, {-134, 145}}, color = {0, 0, 127}));
  connect(p, feedbackP.u2) annotation(
    Line(points = {{-260, 160}, {-134, 160}, {-134, 172}}, color = {0, 0, 127}));
  connect(feedbackDroop.u1, feedbackP.y) annotation(
    Line(points = {{-106, 180}, {-125, 180}}, color = {0, 0, 127}));
  connect(gainDroop.y, feedbackDroop.u2) annotation(
    Line(points = {{-111, 145}, {-98, 145}, {-98, 172}}, color = {0, 0, 127}));
  connect(feedbackDroop.y, addPAux.u2) annotation(
    Line(points = {{-89, 180}, {-67, 180}}, color = {0, 0, 127}));
  connect(feedbackQ.y, gainQDroop.u) annotation(
    Line(points = {{-171, -60}, {-152, -60}}, color = {0, 0, 127}));
  connect(feedbackV.y, addQAux.u1) annotation(
    Line(points = {{-166, 0}, {-146, 0}}, color = {0, 0, 127}));
  connect(addQu.y, gainPiQ.u) annotation(
    Line(points = {{-71, -11}, {-40.5, -11}, {-40.5, 6}, {-31, 6}}, color = {0, 0, 127}));
  connect(q, feedbackQ.u2) annotation(
    Line(points = {{-260, -70}, {-192.5, -70}, {-192.5, -68}, {-180, -68}}, color = {0, 0, 127}));
  connect(QRef, feedbackQ.u1) annotation(
    Line(points = {{-260.5, -45.5}, {-206.5, -45.5}, {-206.5, -60}, {-188, -60}}, color = {0, 0, 127}));
  connect(addPiQ.y, gainInvertSign.u) annotation(
    Line(points = {{26, -15}, {43, -15}}, color = {0, 0, 127}));
  connect(addPiV.u2, gainPiV.y) annotation(
    Line(points = {{38, 77}, {21, 77}}, color = {0, 0, 127}));
  connect(add5.y, gainInvertSign2.u) annotation(
    Line(points = {{31, -170}, {42, -170}}, color = {0, 0, 127}));
  connect(add5.u1, gain7.y) annotation(
    Line(points = {{8, -164}, {-0.5, -164}, {-0.5, -155}, {-9, -155}}, color = {0, 0, 127}));
  connect(constant1.y, feedback4.u1) annotation(
    Line(points = {{-214, -170}, {-93, -170}}, color = {0, 0, 127}));
  connect(feedback4.u2, vQConvPu) annotation(
    Line(points = {{-85, -162}, {-85, -147}, {-264, -147}}, color = {0, 0, 127}));
  connect(multiSwitchQ.y, limiterQ.u) annotation(
    Line(points = {{170, -77}, {184, -77}, {184, -78}}, color = {0, 0, 127}));
  connect(addQAux.y, addQu.u1) annotation(
    Line(points = {{-124, -5}, {-94, -5}}, color = {0, 0, 127}));
  connect(gainQDroop.y, addQu.u2) annotation(
    Line(points = {{-129, -60}, {-100, -60}, {-100, -17}, {-94, -17}}, color = {0, 0, 127}));
  connect(QAux, addQAux.u2) annotation(
    Line(points = {{-260, -15}, {-175, -15}, {-175, -11}, {-147, -11}}, color = {0, 0, 127}));
  connect(addPiP.y, multiSwitchD.u[1]) annotation(
    Line(points = {{61, 186}, {73, 186}, {73, 91}, {87, 91}, {87, 83}, {94, 83}}, color = {0, 0, 127}));
  connect(multiSwitchD.y, limiterD.u) annotation(
    Line(points = {{115, 83}, {126.5, 83}, {126.5, 85}, {136, 85}}, color = {0, 0, 127}));
  connect(PAux, addPAux.u1) annotation(
    Line(points = {{-260, 200}, {-99, 200}, {-99, 192}, {-67, 192}}, color = {0, 0, 127}));
  connect(addPAux.y, gainPiP.u) annotation(
    Line(points = {{-44, 186}, {-24, 186}, {-24, 170}, {-2, 170}}, color = {0, 0, 127}));
  connect(feedbackV.y, gainPiV.u) annotation(
    Line(points = {{-166, 0}, {-157, 0}, {-157, 76}, {-21, 76}, {-21, 77}, {-2, 77}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[2]) annotation(
    Line(points = {{61, 83}, {94, 83}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[3]) annotation(
    Line(points = {{61, 83}, {94, 83}}, color = {0, 0, 127}));
  connect(addPiV.y, multiSwitchD.u[4]) annotation(
    Line(points = {{61, 83}, {94, 83}}, color = {0, 0, 127}));
  connect(gainInvertSign.y, multiSwitchQ.u[1]) annotation(
    Line(points = {{66, -15}, {111, -15}, {111, -77}, {149, -77}}, color = {0, 0, 127}));
  connect(gainInvertSign2.y, multiSwitchQ.u[2]) annotation(
    Line(points = {{65, -170}, {119, -170}, {119, -77}, {149, -77}}, color = {0, 0, 127}));
  connect(gainInvertSign2.y, multiSwitchQ.u[3]) annotation(
    Line(points = {{65, -170}, {119, -170}, {119, -77}, {149, -77}}, color = {0, 0, 127}));
  connect(gainInvertSign2.y, multiSwitchQ.u[4]) annotation(
    Line(points = {{65, -170}, {119, -170}, {119, -77}, {149, -77}}, color = {0, 0, 127}));
  connect(integerConstant1.y, multiSwitchD.f) annotation(
    Line(points = {{100, 31}, {119, 31}, {119, 109}, {104, 109}, {104, 95}}, color = {255, 127, 0}));
  connect(integerConstant1.y, multiSwitchQ.f) annotation(
    Line(points = {{100, 31}, {119, 31}, {119, -45}, {159, -45}, {159, -65}}, color = {255, 127, 0}));
  connect(add.y, sqrt1.u) annotation(
    Line(points = {{-156, -225}, {-141, -225}}, color = {0, 0, 127}));
  connect(product.y, add.u2) annotation(
    Line(points = {{-205, -249}, {-190, -249}, {-190, -231}, {-179, -231}}, color = {0, 0, 127}));
  connect(product1.y, add.u1) annotation(
    Line(points = {{-206, -210}, {-179, -210}, {-179, -219}}, color = {0, 0, 127}));
  connect(product1.u1, vQConvPu) annotation(
    Line(points = {{-229, -204}, {-265, -204}, {-265, -145}}, color = {0, 0, 127}));
  connect(product1.u2, vQConvPu) annotation(
    Line(points = {{-229, -216}, {-265, -216}, {-265, -145}}, color = {0, 0, 127}));
  connect(product.u1, vd) annotation(
    Line(points = {{-228, -243}, {-285, -243}, {-285, 15}, {-260, 15}}, color = {0, 0, 127}));
  connect(product.u2, vd) annotation(
    Line(points = {{-228, -255}, {-285, -255}, {-285, 15}, {-260, 15}}, color = {0, 0, 127}));
  connect(feedback4.y, gain7.u) annotation(
    Line(points = {{-76, -170}, {-54, -170}, {-54, -155}, {-32, -155}}, color = {0, 0, 127}));
  connect(sqrt1.y, lvrtFrz.VPu) annotation(
    Line(points = {{-118, -225}, {-76, -225}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiVq.u, feedback4.y) annotation(
    Line(points = {{-34, -186}, {-76, -186}, {-76, -170}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiVq.y, add5.u2) annotation(
    Line(points = {{-11, -186}, {1, -186}, {1, -176}, {8, -176}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiQ.y, addPiQ.u2) annotation(
    Line(points = {{-12, -32}, {-4, -32}, {-4, -21}, {3, -21}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiQ.u, addQu.y) annotation(
    Line(points = {{-35, -32}, {-52, -32}, {-52, -11}, {-71, -11}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiV.y, addPiV.u1) annotation(
    Line(points = {{22, 109}, {31, 109}, {31, 89}, {38, 89}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiV.u, feedbackV.y) annotation(
    Line(points = {{-1, 109}, {-157, 109}, {-157, 0}, {-166, 0}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiP.y, addPiP.u1) annotation(
    Line(points = {{21, 199}, {29, 199}, {29, 192}, {38, 192}}, color = {0, 0, 127}));
  connect(integratorSetFreezePiP.u, addPAux.y) annotation(
    Line(points = {{-2, 199}, {-25, 199}, {-25, 186}, {-44, 186}}, color = {0, 0, 127}));
  connect(currentLimiter.idConvRefPu, multiSwitchD.y) annotation(
    Line(points = {{179, 13}, {115, 13}, {115, 83}}, color = {0, 0, 127}));
  connect(currentLimiter.iqConvRefPu, multiSwitchQ.y) annotation(
    Line(points = {{179, 5}, {170, 5}, {170, -77}}, color = {0, 0, 127}));
  connect(integerStep.y, multiSwitch.f) annotation(
    Line(points = {{170, 43}, {201.5, 43}, {201.5, 42}, {234, 42}}, color = {255, 127, 0}));
  connect(multiSwitch1.f, integerStep.y) annotation(
    Line(points = {{235, 6}, {211, 6}, {211, 43}, {170, 43}}, color = {255, 127, 0}));
  connect(iqConvRefPu, multiSwitch1.y) annotation(
    Line(points = {{260, -78}, {246, -78}, {246, -6}}, color = {0, 0, 127}));
  connect(idConvRefPu, multiSwitch.y) annotation(
    Line(points = {{260, 60}, {245, 60}, {245, 30}}, color = {0, 0, 127}));
  connect(limiterQ.y, multiSwitch1.u[1]) annotation(
    Line(points = {{205, -77}, {225, -77}, {225, -6}}, color = {0, 0, 127}));
  connect(limiterD.y, multiSwitch.u[1]) annotation(
    Line(points = {{159, 85}, {224, 85}, {224, 30}}, color = {0, 0, 127}));
  connect(currentLimiter.iqConvRefLimPu, multiSwitch1.u[2]) annotation(
    Line(points = {{201, 13}, {225, 13}, {225, -6}}, color = {0, 0, 127}));
  connect(currentLimiter.idConvRefLimPu, multiSwitch.u[2]) annotation(
    Line(points = {{201, 5}, {224, 5}, {224, 30}}, color = {0, 0, 127}));
  connect(lvrtFrz.Frz, integratorSetFreezePiVq.freeze) annotation(
    Line(points = {{-54, -220}, {-28, -220}, {-28, -198}}, color = {255, 0, 255}));
  connect(integratorSetFreezePiQ.freeze, lvrtFrz.Frz) annotation(
    Line(points = {{-29, -44}, {-35, -44}, {-35, -104}, {-38, -104}, {-38, -220}, {-54, -220}}, color = {255, 0, 255}));
  connect(Frz, lvrtFrz.Frz) annotation(
    Line(points = {{259, -225}, {-22, -225}, {-22, -220}, {-54, -220}}, color = {255, 0, 255}));
  connect(lvrtFrz.Frz, integratorSetFreezePiV.freeze) annotation(
    Line(points = {{-54, -220}, {-49, -220}, {-49, 97}, {5, 97}}, color = {255, 0, 255}));
  connect(integratorSetFreezePiP.freeze, lvrtFrz.Frz) annotation(
    Line(points = {{4, 187}, {-49, 187}, {-49, -220}, {-54, -220}}, color = {255, 0, 255}));
  annotation(
    Icon(coordinateSystem(grid = {1, 1}), graphics = {Rectangle(extent = {{-100, 99}, {100, -99}}), Text(origin = {-2, 4}, extent = {{-87, 70}, {87, -70}}, textString = "EPRI
voltage
control")}),
    preferredView = "diagram",
    Diagram(coordinateSystem(grid = {1, 1}, extent = {{-250, -250}, {250, 250}})));
end EpriVoltageCtrl;
