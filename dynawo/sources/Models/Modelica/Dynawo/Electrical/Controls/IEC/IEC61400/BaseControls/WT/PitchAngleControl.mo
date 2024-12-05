within Dynawo.Electrical.Controls.IEC.IEC61400.BaseControls.WT;

model PitchAngleControl
  parameter Real DThetaCmax = 6 "Pitch maximum positive ramp rate of power PI controller, typical value = 6";
  parameter Real DThetaCmin = -3 "Pitch dependent term of aerodynamic power partial derivative with respect to changes in Wind Turbine Rotor speed, typical value = -3";
  parameter Real DThetaMax = 6 "Pitch maximum positive ramp rate, typical value = 6";
  parameter Real DThetaMin = -3 "Pitch maximum negative ramp rate, typical value = -3";
  parameter Real DThetaOmegamax = 6 "Pitch maximum positive ramp rate of speed PI controller, typical value = 6";
  parameter Real DThetaOmegamin = -3 "Pitch maximum negative ramp rate of speed PI controller, typical value = -3";
  parameter Real KIcPu = 1e-9 "Integration gain of power PI controller, typical value = 0";
  parameter Real KIomegaPu = 15 "Integration gain of Speed PI controller, typical value = 15";
  parameter Real KPcPu = 0 "Proportional gain of power PI controller, typical value = 0";
  parameter Real KPomegaPu = 15 "Proportional gain of speed PI controller, typical value = 15";
  parameter Real KPXPu = 0.03 "Cross coupling pitch gain , typical value = 0.03";
  parameter Real ThetaCmax = 35 "Maximum WT pitch angle of power PI controller, typical value = 35";
  parameter Real ThetaCmin = 0 "Minimum WT pitch angle of power PI controller, typical value = 35";
  parameter Real ThetaMax = 35 "Maximum WT pitch angle, typical value = 35";
  parameter Real ThetaMin = 0 "Minimum WT pitch angle, typical value = 0";
  parameter Real ThetaOmegamax = 35 "Maximum WT pitch angle of speed PI controller, typical value = 35";
  parameter Real ThetaOmegamin = 0 "Minimum WT pitch angle of speed PI controller, typical value = 0";
  parameter Real TTheta = 0.25 "WT pitch time constant, typical value = 0.25";
  Modelica.Blocks.Interfaces.RealInput omegaWTRPu annotation(
    Placement(transformation(origin = {-220, 144}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu annotation(
    Placement(transformation(origin = {-220, 112}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, 30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput pOrdPu annotation(
    Placement(transformation(origin = {-220, -72}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -30}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Interfaces.RealInput pWTrefPu annotation(
    Placement(transformation(origin = {-220, -110}, extent = {{-20, -20}, {20, 20}}), iconTransformation(origin = {-120, -80}, extent = {{-20, -20}, {20, 20}})));
  Modelica.Blocks.Math.Add add(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-146, -92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 addOmega(k2 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-102, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainKPX(k = KPXPu)  annotation(
    Placement(visible = true, transformation(origin = {-126, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Math.Gain gainPiOmega(k = KPomegaPu)  annotation(
    Placement(visible = true, transformation(origin = {-16, 90}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainPiPower(k = KPcPu) annotation(
    Placement(transformation(origin = {-24, -130}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput theta annotation(
    Placement(visible = true,transformation(origin = {210, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPiOmega annotation(
    Placement(transformation(origin = {48, 112}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addPiPower annotation(
    Placement(visible = true, transformation(origin = {50, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add12 annotation(
    Placement(transformation(origin = {90, 0}, extent = {{-10, -10}, {10, 10}})));
  WindType3.AbsLimRateLimLimDetectionFirstOrderFreezeCustom absLimRateLimTheta(DyMax = DThetaMax, DyMin = DThetaMin, yMax = ThetaMax, yMin = ThetaMin, tI = TTheta, Y0 = 0)  annotation(
    Placement(transformation(origin = {140, 0}, extent = {{-14, -14}, {14, 14}})));
  Modelica.Blocks.Nonlinear.Limiter thetaOmegaLim(uMax = ThetaOmegamax, uMin = ThetaOmegamin)  annotation(
    Placement(transformation(origin = {69, 77}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter thetaOmegaRateLim(Rising = DThetaOmegamax, Falling = DThetaOmegamin)  annotation(
    Placement(transformation(origin = {69, 49}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.Limiter thetaOmegaLim1(uMax = ThetaCmax, uMin = ThetaCmin) annotation(
    Placement(transformation(origin = {69, -67}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Modelica.Blocks.Nonlinear.SlewRateLimiter thetaOmegaRateLim1(Falling = DThetaCmin, Rising = DThetaCmax) annotation(
    Placement(transformation(origin = {69, -37}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator integratorPiOmega(tI = 1/KIomegaPu, DyMax = DThetaOmegamax, DyMin = DThetaOmegamin, YMax = ThetaOmegamax, YMin = ThetaOmegamin, Y0 = 0)  annotation(
    Placement(transformation(origin = {-16, 130}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.NonElectrical.Blocks.Continuous.AntiWindupIntegrator integratorPiPower(DyMax = DThetaCmax, DyMin = DThetaCmin, Y0 = 0, YMax = ThetaCmax, YMin = ThetaCmin, tI = 1/KIcPu) annotation(
    Placement(transformation(origin = {-26, -70}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k = false)  annotation(
    Placement(visible = true, transformation(origin = {130, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(omegaRefPu, addOmega.u2) annotation(
    Line(points = {{-220, 112}, {-114, 112}}, color = {0, 0, 127}));
  connect(add.y, GainKPX.u) annotation(
    Line(points = {{-135, -92}, {-126, -92}, {-126, 20}}, color = {0, 0, 127}));
  connect(gainPiOmega.u, addOmega.y) annotation(
    Line(points = {{-28, 90}, {-80, 90}, {-80, 112}, {-91, 112}}, color = {0, 0, 127}));
  connect(gainPiPower.u, add.y) annotation(
    Line(points = {{-36, -130}, {-94, -130}, {-94, -92}, {-135, -92}}, color = {0, 0, 127}));
  connect(gainPiOmega.y, addPiOmega.u2) annotation(
    Line(points = {{-4, 90}, {36, 90}, {36, 106}}, color = {0, 0, 127}));
  connect(gainPiPower.y, addPiPower.u2) annotation(
    Line(points = {{-13, -130}, {31, -130}, {31, -118}, {38, -118}}, color = {0, 0, 127}));
  connect(add12.y, absLimRateLimTheta.u) annotation(
    Line(points = {{101, 0}, {123, 0}}, color = {0, 0, 127}));
  connect(thetaOmegaLim.y, thetaOmegaRateLim.u) annotation(
    Line(points = {{69, 69.3}, {69, 57.3}}, color = {0, 0, 127}));
  connect(addPiOmega.y, thetaOmegaLim.u) annotation(
    Line(points = {{60, 112}, {69, 112}, {69, 85}}, color = {0, 0, 127}));
  connect(thetaOmegaRateLim.y, add12.u1) annotation(
    Line(points = {{69, 41}, {70, 41}, {70, 6}, {78, 6}}, color = {0, 0, 127}));
  connect(thetaOmegaLim1.y, thetaOmegaRateLim1.u) annotation(
    Line(points = {{69, -59.3}, {69, -45.3}}, color = {0, 0, 127}));
  connect(addPiPower.y, thetaOmegaLim1.u) annotation(
    Line(points = {{61, -112}, {70, -112}, {70, -76}}, color = {0, 0, 127}));
  connect(thetaOmegaRateLim1.y, add12.u2) annotation(
    Line(points = {{70, -30}, {68, -30}, {68, -6}, {78, -6}}, color = {0, 0, 127}));
  connect(integratorPiOmega.u, addOmega.y) annotation(
    Line(points = {{-28, 130}, {-80, 130}, {-80, 112}, {-91, 112}}, color = {0, 0, 127}));
  connect(integratorPiOmega.y, addPiOmega.u1) annotation(
    Line(points = {{-4, 130}, {26, 130}, {26, 118}, {36, 118}}, color = {0, 0, 127}));
  connect(integratorPiOmega.fMin, absLimRateLimTheta.fMin) annotation(
    Line(points = {{-12, 118}, {-12, 102}, {22, 102}, {22, 26}, {166, 26}, {166, -8}, {156, -8}}, color = {255, 0, 255}));
  connect(integratorPiOmega.fMax, absLimRateLimTheta.fMax) annotation(
    Line(points = {{-8, 118}, {-8, 104}, {24, 104}, {24, 28}, {168, 28}, {168, 8}, {156, 8}}, color = {255, 0, 255}));
  connect(integratorPiPower.u, add.y) annotation(
    Line(points = {{-38, -70}, {-94, -70}, {-94, -92}, {-135, -92}}, color = {0, 0, 127}));
  connect(integratorPiPower.y, addPiPower.u1) annotation(
    Line(points = {{-14, -70}, {24, -70}, {24, -106}, {38, -106}}, color = {0, 0, 127}));
  connect(integratorPiPower.fMin, absLimRateLimTheta.fMin) annotation(
    Line(points = {{-22, -82}, {-22, -90}, {166, -90}, {166, -8}, {156, -8}}, color = {255, 0, 255}));
  connect(integratorPiPower.fMax, absLimRateLimTheta.fMax) annotation(
    Line(points = {{-18, -82}, {-18, -92}, {168, -92}, {168, 8}, {156, 8}}, color = {255, 0, 255}));
  connect(absLimRateLimTheta.y, theta) annotation(
    Line(points = {{156, 0}, {210, 0}}, color = {0, 0, 127}));
  connect(booleanConstant.y, absLimRateLimTheta.freeze) annotation(
    Line(points = {{141, 52}, {140, 52}, {140, 16}}, color = {255, 0, 255}));
  connect(omegaWTRPu, addOmega.u1) annotation(
    Line(points = {{-220, 144}, {-168, 144}, {-168, 120}, {-114, 120}}, color = {0, 0, 127}));
  connect(GainKPX.y, addOmega.u3) annotation(
    Line(points = {{-126, 44}, {-126, 104}, {-114, 104}}, color = {0, 0, 127}));
  connect(pOrdPu, add.u1) annotation(
    Line(points = {{-220, -72}, {-182, -72}, {-182, -86}, {-158, -86}}, color = {0, 0, 127}));
  connect(pWTrefPu, add.u2) annotation(
    Line(points = {{-220, -110}, {-182, -110}, {-182, -98}, {-158, -98}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}})),
    Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end PitchAngleControl;
