within OpenEMTP.Electrical.Exciters_Governor;
model Exciter_ST1
  // VA0=Efd0+KLR*(Ifd-ILR)
  parameter Real Tr= 20e-3 "Low-pass filter time constant Tr(s)"
     annotation (Dialog(tab="Controller"));
  parameter Real REG[2]={210,0.001} "Regulator gain and time constant { Ka() , Ta(s) }"
     annotation (Dialog(tab="Controller"));
  parameter Real EXC[2]={1,0} " Exciter  [ Ke()  Te(s) ]"
     annotation (Dialog(tab="Controller"));
  parameter Real VI[2]= {-999, +999} "Voltage regulator input limits {VImin(pu), VImax(pu)}"
     annotation (Dialog(tab="Controller"));
  parameter Real VA[2]= {-999, +999}
     "Voltage regulator internal limits [VAmin(pu) VAmax(pu)]"
     annotation (Dialog(tab="Controller"));
  parameter Real VR[2]= {-6.0, 6.43} "Voltage regulator output limits {VRmin(pu), VRmax(pu)}"
     annotation (Dialog(tab="Controller"));
  parameter Real DFG[2]={0.001, 1}
     "Damping filter gain and time constant [Kf Tf(s)]"
     annotation (Dialog(tab="Controller"));
  parameter Real TGR[4]={0,0,0,0}
     "Transient gain reduction lead and lag time constants {Tb(s) ,Tc(s), Tb1(s), Tc1(s)}"
     annotation (Dialog(tab="Controller"));

  parameter Real KLR=1   "Exciter output current limiter gain KLR(pu)"
     annotation (Dialog(tab="Exciter and rectifier"));
  parameter Real ILR=2 "Exciter output current limit reference ILR(pu)"
     annotation (Dialog(tab="Exciter and rectifier"));
  parameter Real Kc=0.038 "Rectifier loading factor Kc(pu)"
     annotation (Dialog(tab="Exciter and rectifier"));

  parameter Real IV[2]={1,1}  "Initial values of terminal voltage and field voltage {Vt0(pu), Efd0(pu)}"
     annotation (Dialog(tab="Initial Values"));
  parameter Real IFD0=1
     annotation (Dialog(tab="Initial Values"));
  final parameter Real VA0 = IV[2] + KLR * (IFD0 -ILR)
      annotation(HideResult=true);

 Modelica.Blocks.Sources.Constant constant1(k = VA0 / REG[1])  annotation(
    Placement(visible = true, transformation(origin = {-168, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tr, initType = Modelica.Blocks.Types.Init.InitialOutput, k = 1, y_start = IV[1]) annotation(
    Placement(visible = true, transformation(origin = {-130, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 OpenEMTP.NonElectrical.Blocks.Sum sum(k = {1, 1, -1, 1, -1})  annotation(
    Placement(visible = true, transformation(origin = {-92, 0}, extent = {{-10, -15}, {10, 15}}, rotation = 0)));
 Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = VI[2], uMin = VI[1]) annotation(
    Placement(visible = true, transformation(origin = {-38, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 OpenEMTP.NonElectrical.Blocks.LeadLagCompensator leadLagCompensator1(K = 1, T1 = TGR[4], T2 = TGR[3], x_start = VA0 / REG[1], y_start = VA0 / REG[1]) annotation(
    Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 OpenEMTP.NonElectrical.Blocks.LeadLagCompensator leadLagCompensator(K = 1, T1 = TGR[2], T2 = TGR[1], y_start = VA0 / REG[1]) annotation(
    Placement(visible = true, transformation(origin = {0, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain2(k = KLR) annotation(
    Placement(visible = true, transformation(origin = {230, -88}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 Modelica.Blocks.Nonlinear.Limiter limiter1(limitsAtInit = true, uMax = Modelica.Constants.inf, uMin = 0) annotation(
    Placement(visible = true, transformation(origin = {166, -88}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {118, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {316, -88}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 Modelica.Blocks.Sources.Constant const1(k = ILR) annotation(
    Placement(visible = true, transformation(origin = {372, -128}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Feedback feedback3 annotation(
    Placement(visible = true, transformation(origin = {354, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Nonlinear.VariableLimiter variableLimiter(limitsAtInit = true) annotation(
    Placement(visible = true, transformation(origin = {198, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain VRmax(k = VR[2]) annotation(
    Placement(visible = true, transformation(origin = {310, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain gain4(k = Kc) annotation(
    Placement(visible = true, transformation(origin = {312, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Math.Gain VRmin(k = VR[1]) annotation(
    Placement(visible = true, transformation(origin = {314, -26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Continuous.Derivative derivative(T = DFG[2], initType = Modelica.Blocks.Types.Init.InitialState, k = DFG[1], x_start = IV[2], y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {6, -60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
 NonElectrical.Blocks.Lag lag(Ka = REG[1], Ta = REG[2], VL = VA, Vint = VA0)  annotation(
    Placement(visible = true, transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput Vref annotation(
    Placement(visible = true, transformation(origin = {-176, 84}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput Vt annotation(
    Placement(visible = true, transformation(origin = {-174, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput Vstab annotation(
    Placement(visible = true, transformation(origin = {-176, -60}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-120, -38}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput Ifd annotation(
    Placement(visible = true, transformation(origin = {410, -88}, extent = {{20, -20}, {-20, 20}}, rotation = 0), iconTransformation(origin = {-120, -92}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput Efd annotation(
    Placement(visible = true, transformation(origin = {234, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealOutput VF annotation(
    Placement(visible = true, transformation(origin = {232, -162}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  equation
 connect(sum.u3, firstOrder.y) annotation(
    Line(points = {{-98, 0}, {-119, 0}}, color = {0, 0, 127}));
 connect(limiter.u, sum.y) annotation(
    Line(points = {{-50, 0}, {-87, 0}}, color = {0, 0, 127}));
  connect(limiter.y, leadLagCompensator.u) annotation(
    Line(points = {{-27, 0}, {-12, 0}}, color = {0, 0, 127}));
  connect(leadLagCompensator1.u, leadLagCompensator.y) annotation(
    Line(points = {{28, 0}, {12, 0}}, color = {0, 0, 127}));
  connect(feedback2.y, gain2.u) annotation(
    Line(points = {{307, -88}, {242, -88}}, color = {0, 0, 127}));
  connect(const1.y, feedback2.u2) annotation(
    Line(points = {{361, -128}, {316, -128}, {316, -96}}, color = {0, 0, 127}));
  connect(limiter1.y, feedback1.u2) annotation(
    Line(points = {{155, -88}, {118, -88}, {118, -8}}, color = {0, 0, 127}));
  connect(gain2.y, limiter1.u) annotation(
    Line(points = {{219, -88}, {178, -88}}, color = {0, 0, 127}));
  connect(feedback3.u2, gain4.y) annotation(
    Line(points = {{354, 50}, {354, 16}, {323, 16}}, color = {0, 0, 127}));
  connect(feedback3.y, variableLimiter.limit1) annotation(
    Line(points = {{363, 58}, {360, 58}, {360, 76}, {156, 76}, {156, 8}, {186, 8}}, color = {0, 0, 127}));
  connect(VRmax.y, feedback3.u1) annotation(
    Line(points = {{321, 58}, {346, 58}}, color = {0, 0, 127}));
  connect(VRmin.u, VRmax.u) annotation(
    Line(points = {{302, -26}, {246, -26}, {246, 58}, {298, 58}}, color = {0, 0, 127}));
  connect(VRmin.y, variableLimiter.limit2) annotation(
    Line(points = {{325, -26}, {338, -26}, {338, -58}, {158, -58}, {158, -8}, {186, -8}}, color = {0, 0, 127}));
  connect(variableLimiter.u, feedback1.y) annotation(
    Line(points = {{186, 0}, {128, 0}}, color = {0, 0, 127}));
  connect(VRmax.u, firstOrder.y) annotation(
    Line(points = {{298, 58}, {-119, 58}, {-119, 0}}, color = {0, 0, 127}));
  connect(derivative.u, feedback1.y) annotation(
    Line(points = {{18, -60}, {140, -60}, {140, 0}, {128, 0}}, color = {0, 0, 127}));
 connect(derivative.y, sum.u5) annotation(
    Line(points = {{-5, -60}, {-98, -60}, {-98, -10}}, color = {0, 0, 127}));
  connect(lag.u, leadLagCompensator1.y) annotation(
    Line(points = {{62, 0}, {52, 0}, {52, 0}, {52, 0}}, color = {0, 0, 127}));
  connect(lag.y, feedback1.u1) annotation(
    Line(points = {{86, 0}, {108, 0}, {108, 0}, {110, 0}}, color = {0, 0, 127}));
 connect(Vref, sum.u1) annotation(
    Line(points = {{-176, 84}, {-88, 84}, {-88, 10}, {-98, 10}}, color = {0, 0, 127}));
 connect(constant1.y, sum.u2) annotation(
    Line(points = {{-156, 48}, {-94, 48}, {-94, 5}, {-98, 5}}, color = {0, 0, 127}));
  connect(firstOrder.u, Vt) annotation(
    Line(points = {{-142, 0}, {-158, 0}, {-158, 0}, {-174, 0}}, color = {0, 0, 127}));
 connect(Vstab, sum.u4) annotation(
    Line(points = {{-176, -60}, {-94, -60}, {-94, -5}, {-98, -5}}, color = {0, 0, 127}));
  connect(Ifd, feedback2.u1) annotation(
    Line(points = {{410, -88}, {324, -88}}, color = {0, 0, 127}));
  connect(gain4.u, Ifd) annotation(
    Line(points = {{300, 16}, {280, 16}, {280, -68}, {382, -68}, {382, -88}, {410, -88}, {410, -88}}, color = {0, 0, 127}));
  connect(Efd, variableLimiter.y) annotation(
    Line(points = {{234, 0}, {210, 0}, {210, 0}, {210, 0}}, color = {0, 0, 127}));
 connect(VF, derivative.y) annotation(
    Line(points = {{232, -162}, {-20, -162}, {-20, -60}, {-4, -60}, {-4, -60}}, color = {0, 0, 127}));
  annotation(Documentation(info= "<html><head></head><body><div style=\"mso-element:para-border-div;border:none;border-bottom:solid #CBCBCB 1.0pt;
mso-border-bottom-alt:solid #CBCBCB .75pt;padding:0in 0in 2.0pt 0in;background:
white\">

<h1 style=\"margin-top:0in;margin-right:0in;margin-bottom:12.0pt;margin-left:
0in;background:white;border:none;mso-border-bottom-alt:solid #CBCBCB .75pt;
padding:0in;mso-padding-alt:0in 0in 2.0pt 0in\"><span class=\"refname\"><span style=\"font-size: 12pt; font-family: Arial, sans-serif; color: rgb(196, 84, 0);\">ST1A Excitation System</span></span><span style=\"font-size: 12pt; font-family: Arial, sans-serif; color: rgb(196, 84, 0);\"><o:p></o:p></span></h1>

</div><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The excitation
system where the supply of power to the controlled bridge rectifier is provided
by the generator terminals through a transformer to lower the voltage to an
appropriate level. The voltage regulator gain and excitation system time
constants are represented by Ka and Ta, respectively.</span><o:p></o:p></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">This block is an
adaptation of the ST1A excitation system of the IEEE</span><sup style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important;
orphans: auto;text-align:start;widows: 1;-webkit-text-stroke-width: 0px;
word-spacing:0px\"><span lang=\"EN-CA\" style=\"font-size:7.5pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">®</span></sup><span class=\"apple-converted-space\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\"><span style=\"orphans: auto;text-align:start;widows: 1;-webkit-text-stroke-width: 0px;
float:none;word-spacing:0px\">&nbsp;</span></span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040;background:white\">421 standard, copyright IEEE 2005, all rights
reserved.</span><o:p></o:p></span></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\"><o:p>&nbsp;</o:p></span></p><div style=\"mso-element:para-border-div;border:none;border-bottom:solid #CCCCCC 1.0pt;
mso-border-bottom-alt:solid #CCCCCC .75pt;padding:0in 0in 0in 0in;background:
white\">

<h2 style=\"margin-top:0in;margin-right:0in;margin-bottom:6.0pt;margin-left:
0in;background:white;border:none;mso-border-bottom-alt:solid #CCCCCC .75pt;
padding:0in;mso-padding-alt:0in 0in 0in 0in\"><span lang=\"EN-CA\" style=\"font-family:
&quot;Arial&quot;,sans-serif;color:#404040\">Parameters<o:p></o:p></span></h2>

</div><h3 style=\"margin-top:0in;margin-right:0in;margin-bottom:3.75pt;margin-left:
0in;background:white;box-sizing: border-box;font-stretch: normal;-webkit-font-feature-settings: &quot;kern&quot; 1;
transition: none !important;-webkit-transition: none !important\" id=\"btkvk46-5\"><span lang=\"EN-CA\" style=\"font-size:11.5pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#C45400\">Controllers Tab<o:p></o:p></span></h3><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54119\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Low-pass filter time constant</span></span></strong><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"><o:p></o:p></span></b></p><p class=\"MsoNormal\" style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The
time constant Tr of the first-order system representing the stator terminal
voltage transducer. Default is</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;
line-height:107%;color:black;mso-color-alt:windowtext;background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;color:black;mso-color-alt:
windowtext;background:white\">20e-3</span><span lang=\"EN-CA\" style=\"font-size:
10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040;
background:white\">.<o:p></o:p></span></p><p style=\"margin-top:0in;margin-right:0in;margin-bottom:7.5pt;margin-left:0in;
background:white\"><strong><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\">Voltage regulator gain and time constant</span></strong><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;color:#404040\"><o:p></o:p></span></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The gain Ka and
time constant Ta of the first-order system representing the main regulator.
Default is</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
color:black;mso-color-alt:windowtext;background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;color:black;mso-color-alt:
windowtext;background:white\">[210 0.001]</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040;background:white\">.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54139\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Voltage regulator input limits</span></span></strong><strong><span lang=\"EN-CA\" style=\"font-family:&quot;Calibri&quot;,sans-serif;mso-ascii-theme-font:minor-latin;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:Arial;mso-bidi-theme-font:
minor-bidi;font-weight:normal\"><o:p></o:p></span></strong></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The voltage
regulator input limits VImin and VImax, in p.u. Default is</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;color:black;mso-color-alt:
windowtext;background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:
&quot;Arial&quot;,sans-serif;color:black;mso-color-alt:windowtext;background:white\">[-999
+999]</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54149\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Voltage regulator internal limits</span></span></strong><strong><span lang=\"EN-CA\" style=\"font-family:&quot;Calibri&quot;,sans-serif;mso-ascii-theme-font:minor-latin;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:Arial;mso-bidi-theme-font:
minor-bidi;font-weight:normal\"><o:p></o:p></span></strong></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The voltage
regulator internal limits VAmin and VAmax, in p.u. Default is</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;color:black;mso-color-alt:
windowtext;background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:
&quot;Arial&quot;,sans-serif;color:black;mso-color-alt:windowtext;background:white\">[-999
999]</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54159\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Voltage regulator output limits</span></span></strong><strong><span lang=\"EN-CA\" style=\"font-family:&quot;Calibri&quot;,sans-serif;mso-ascii-theme-font:minor-latin;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:Arial;mso-bidi-theme-font:
minor-bidi;font-weight:normal\"><o:p></o:p></span></strong></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The voltage
regulator output limits VRmin and VRmax, in p.u. Default is</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;color:black;mso-color-alt:
windowtext;background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:
&quot;Arial&quot;,sans-serif;color:black;mso-color-alt:windowtext;background:white\">[-6.0
6.43]</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54169\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Damping filter gain and time constant</span></span></strong><strong><span lang=\"EN-CA\" style=\"font-family:&quot;Calibri&quot;,sans-serif;mso-ascii-theme-font:minor-latin;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:Arial;mso-bidi-theme-font:
minor-bidi;font-weight:normal\"><o:p></o:p></span></strong></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The gain Kf and
time constant Tf of the first-order system representing the derivative
feedback. Default is</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:
107%;color:black;mso-color-alt:windowtext;background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;color:black;mso-color-alt:
windowtext;background:white\">[0.001 1]</span><span lang=\"EN-CA\" style=\"font-size:
10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040;
background:white\">.<o:p></o:p></span></p><p class=\"MsoNormal\"><b><span lang=\"EN-CA\" style=\"color:black;mso-color-alt:windowtext;
background:white\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54179\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Transient gain reduction lead and lag time
constants</span></span></b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\"><o:p></o:p></span></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The time
constants Tb, Tc, Tb1, and Tc1 of the second-order system representing the
lead-lag compensator. Default is</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;
line-height:107%;color:black;mso-color-alt:windowtext;background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;color:black;mso-color-alt:
windowtext;background:white\">[0 0 0 0]</span><span lang=\"EN-CA\" style=\"font-size:
10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040;
background:white\">.<o:p></o:p></span></p><h3 style=\"margin-top:0in;margin-right:0in;margin-bottom:3.75pt;margin-left:
0in;background:white;box-sizing: border-box;font-stretch: normal;-webkit-font-feature-settings: &quot;kern&quot; 1;
transition: none !important;-webkit-transition: none !important\" id=\"btkvk46-6\"><span lang=\"EN-CA\" style=\"font-size:11.5pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#C45400\">Exciter and Rectifier Tab<o:p></o:p></span></h3><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54193\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Exciter output current limiter gain KLR</span></span></strong><strong><span lang=\"EN-CA\" style=\"font-family:&quot;Calibri&quot;,sans-serif;mso-ascii-theme-font:minor-latin;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:Arial;mso-bidi-theme-font:
minor-bidi;font-weight:normal\"><o:p></o:p></span></strong></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The exciter
output current limiter gain. Default is</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;color:black;mso-color-alt:windowtext;
background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;
color:black;mso-color-alt:windowtext;background:white\">1</span><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040;background:white\">.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54203\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Exciter output current limit reference ILR</span></span></strong><strong><span lang=\"EN-CA\" style=\"font-family:&quot;Calibri&quot;,sans-serif;mso-ascii-theme-font:minor-latin;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:Arial;mso-bidi-theme-font:
minor-bidi;font-weight:normal\"><o:p></o:p></span></strong></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040\">The <span style=\"background:white\">exciter</span>
output current limit reference. Default is</span><span class=\"apple-converted-space\"><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;
color:#404040\">&nbsp;</span></span><code style=\"box-sizing: border-box;
font-size:inherit;color:inherit;border-radius: 0px;transition: none !important;
-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;
line-height:107%;font-family:Consolas;mso-fareast-font-family:Calibri;
mso-fareast-theme-font:minor-latin;color:#404040\">2</span></code><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\">.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54213\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Rectifier loading factor Kc</span></span></strong><strong><span lang=\"EN-CA\" style=\"font-family:&quot;Calibri&quot;,sans-serif;mso-ascii-theme-font:minor-latin;
mso-hansi-theme-font:minor-latin;mso-bidi-font-family:Arial;mso-bidi-theme-font:
minor-bidi;font-weight:normal\"><o:p></o:p></span></strong></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The rectifier
loading factor proportional to commutating reactance. Default is&nbsp;0.038.<o:p></o:p></span></p><h3 style=\"margin-top:0in;margin-right:0in;margin-bottom:3.75pt;margin-left:
0in;background:white\"><span lang=\"EN-CA\" style=\"font-size:11.5pt;line-height:
107%;font-family:&quot;Arial&quot;,sans-serif;color:#C45400\">Initial Values Tab<o:p></o:p></span></h3><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"></span><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54227\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Initial values of terminal voltage and
field voltage</span></span></strong><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040\"><o:p></o:p></span></b></p><p class=\"MsoNormal\" style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">The
initial values of terminal voltage Vt0 and field voltage Efd0, both in p.u.
Initial terminal voltage is normally set to 1 pu. The Vt0 and Efd0 values can
be determined using the Powergui Load Flow tool. Default is</span><span lang=\"EN-CA\" style=\"color:black;mso-color-alt:windowtext;background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;color:black;mso-color-alt:
windowtext;background:white\">[1 1]</span><span lang=\"EN-CA\" style=\"font-size:
10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040;
background:white\">.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><strong><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\">Initial values of field current Ifd0</span></strong><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"><o:p></o:p></span></b></p><p class=\"MsoNormal\" style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\"><span lang=\"EN-CA\" style=\"font-size:10.0pt;
line-height:107%;font-family:&quot;Arial&quot;,sans-serif;color:#404040;background:white\">Default
is</span><span lang=\"EN-CA\" style=\"color:black;mso-color-alt:windowtext;
background:white\">&nbsp;</span><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;
color:black;mso-color-alt:windowtext;background:white\">0</span><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;background:white\"><o:p></o:p></span></p><p class=\"MsoNormal\"><span lang=\"EN-CA\" style=\"font-family:&quot;Arial&quot;,sans-serif;
background:white\"><o:p>&nbsp;</o:p></span></p><div style=\"mso-element:para-border-div;border:none;border-bottom:solid #CCCCCC 1.0pt;
mso-border-bottom-alt:solid #CCCCCC .75pt;padding:0in 0in 0in 0in;background:
white\">

<h2 style=\"margin-top:0in;margin-right:0in;margin-bottom:6.0pt;margin-left:
0in;background:white;border:none;mso-border-bottom-alt:solid #CCCCCC .75pt;
padding:0in;mso-padding-alt:0in 0in 0in 0in\"><span lang=\"EN-CA\" style=\"font-family:
&quot;Arial&quot;,sans-serif;color:#404040\">Ports<o:p></o:p></span></h2>

</div><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><span class=\"term\"></span><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040\"><span style=\"box-sizing: border-box;
transition: none !important;-webkit-transition: none !important;display:inline-block;
float:left\" id=\"d119e54254\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Vref</span></span></span></b><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"><o:p></o:p></span></b></p><p style=\"margin-top:0in;margin-right:0in;margin-bottom:7.5pt;margin-left:0in;
background:white;box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;color:#404040\">The
reference value of the stator terminal voltage, in p.u.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><span class=\"term\"></span><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040\"><span style=\"box-sizing: border-box;
transition: none !important;-webkit-transition: none !important;display:inline-block;
float:left\" id=\"d119e54260\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Vt</span></span></span></b><span lang=\"EN-CA\"><o:p></o:p></span></p><p style=\"margin-top:0in;margin-right:0in;margin-bottom:7.5pt;margin-left:0in;
background:white\"><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\">The measured value in p.u. of the stator terminal voltage of the
controlled<span class=\"apple-converted-space\">&nbsp;</span><span class=\"block\"><span style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\">Synchronous
Machine</span></span><span class=\"apple-converted-space\">&nbsp;</span>block.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><span class=\"term\"></span><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040\"><span style=\"box-sizing: border-box;
transition: none !important;-webkit-transition: none !important;display:inline-block;
float:left\" id=\"d119e54269\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Ifd</span></span></span></b><span lang=\"EN-CA\"><o:p></o:p></span></p><p style=\"margin-top:0in;margin-right:0in;margin-bottom:7.5pt;margin-left:0in;
background:white\"><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\">The measured value in p.u. of the stator field current of the
controlled<span class=\"apple-converted-space\">&nbsp;</span><span class=\"block\"><span style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\">Synchronous
Machine</span></span><span class=\"apple-converted-space\">&nbsp;</span>block.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-top:0in;margin-right:0in;margin-bottom:3.75pt;
margin-left:-2.25pt;background:white\"><span class=\"term\"></span><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important;display:inline-block;float:left\" id=\"d119e54278\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Vstab</span></span></span></b><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"><o:p></o:p></span></b></p><p style=\"margin-top:0in;margin-right:0in;margin-bottom:7.5pt;margin-left:0in;
background:white;box-sizing: border-box;transition: none !important;-webkit-transition: none !important\"><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;color:#404040\">Connect
this input to a power system stabilizer to provide additional stabilization of
power system oscillations. When you do not use this option, connect to a
Simulink</span><sup style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\"><span style=\"font-size:7.5pt;font-family:
&quot;Arial&quot;,sans-serif;color:#404040\">®</span></sup><span class=\"apple-converted-space\"><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\">&nbsp;</span></span><span style=\"font-size:10.0pt;font-family:
&quot;Arial&quot;,sans-serif;color:#404040\">ground block. The input is in p.u.<o:p></o:p></span></p><p class=\"MsoNormal\" style=\"margin-bottom:3.75pt;background:white\"><span class=\"term\"></span><b><span lang=\"EN-CA\" style=\"font-size:10.0pt;line-height:107%;
font-family:&quot;Arial&quot;,sans-serif;color:#404040\"><span style=\"box-sizing: border-box;
transition: none !important;-webkit-transition: none !important;display:inline-block;
float:left\" id=\"d119e54287\"><span style=\"box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\">Efd</span></span></span></b><span lang=\"EN-CA\"><o:p></o:p></span></p><p style=\"margin-top:0in;margin-right:0in;margin-bottom:7.5pt;margin-left:0in;
background:white\"><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\">The field voltage to apply to the<span class=\"apple-converted-space\">&nbsp;</span></span><code style=\"box-sizing: border-box;
font-size:inherit;color:inherit;border-radius: 0px;transition: none !important;
-webkit-transition: none !important\"><span style=\"font-size:10.0pt;font-family:
Consolas;color:#404040\">Vf</span></code><span class=\"apple-converted-space\"><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;color:#404040\">&nbsp;</span></span><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;color:#404040\">input of
the controlled<span class=\"apple-converted-space\">&nbsp;</span><span class=\"block\"><span style=\"box-sizing: border-box;transition: none !important;-webkit-transition: none !important\">Synchronous
Machine</span></span><span class=\"apple-converted-space\">&nbsp;</span>block. The
output is in p.u<o:p></o:p></span></p><p style=\"margin-top:0in;margin-right:0in;margin-bottom:7.5pt;margin-left:0in;
background:white\"><span style=\"font-size:10.0pt;font-family:&quot;Arial&quot;,sans-serif;
color:#404040\"><o:p>&nbsp;</o:p></span></p><div style=\"mso-element:para-border-div;border:none;border-bottom:solid #CCCCCC 1.0pt;
mso-border-bottom-alt:solid #CCCCCC .75pt;padding:0in 0in 0in 0in;background:
white\">

<h2 style=\"margin-top:0in;margin-right:0in;margin-bottom:6.0pt;margin-left:
0in;background:white;border:none;mso-border-bottom-alt:solid #CCCCCC .75pt;
padding:0in;mso-padding-alt:0in 0in 0in 0in\"><span lang=\"EN-CA\" style=\"font-family:
&quot;Arial&quot;,sans-serif;color:#404040\">References<o:p></o:p></span></h2>

</div><p>




<!--[if gte mso 9]><xml>
 <o:OfficeDocumentSettings>
  <o:AllowPNG/>
 </o:OfficeDocumentSettings>
</xml><![endif]-->


<!--[if gte mso 9]><xml>
 <w:WordDocument>
  <w:View>Normal</w:View>
  <w:Zoom>0</w:Zoom>
  <w:TrackMoves/>
  <w:TrackFormatting/>
  <w:PunctuationKerning/>
  <w:ValidateAgainstSchemas/>
  <w:SaveIfXMLInvalid>false</w:SaveIfXMLInvalid>
  <w:IgnoreMixedContent>false</w:IgnoreMixedContent>
  <w:AlwaysShowPlaceholderText>false</w:AlwaysShowPlaceholderText>
  <w:DoNotPromoteQF/>
  <w:LidThemeOther>EN-CA</w:LidThemeOther>
  <w:LidThemeAsian>X-NONE</w:LidThemeAsian>
  <w:LidThemeComplexScript>AR-SA</w:LidThemeComplexScript>
  <w:Compatibility>
   <w:BreakWrappedTables/>
   <w:SnapToGridInCell/>
   <w:WrapTextWithPunct/>
   <w:UseAsianBreakRules/>
   <w:DontGrowAutofit/>
   <w:SplitPgBreakAndParaMark/>
   <w:EnableOpenTypeKerning/>
   <w:DontFlipMirrorIndents/>
   <w:OverrideTableStyleHps/>
  </w:Compatibility>
  <m:mathPr>
   <m:mathFont m:val=\"Cambria Math\"/>
   <m:brkBin m:val=\"before\"/>
   <m:brkBinSub m:val=\"&#45;-\"/>
   <m:smallFrac m:val=\"off\"/>
   <m:dispDef/>
   <m:lMargin m:val=\"0\"/>
   <m:rMargin m:val=\"0\"/>
   <m:defJc m:val=\"centerGroup\"/>
   <m:wrapIndent m:val=\"1440\"/>
   <m:intLim m:val=\"subSup\"/>
   <m:naryLim m:val=\"undOvr\"/>
  </m:mathPr></w:WordDocument>
</xml><![endif]--><!--[if gte mso 9]><xml>
 <w:LatentStyles DefLockedState=\"false\" DefUnhideWhenUsed=\"false\"
  DefSemiHidden=\"false\" DefQFormat=\"false\" DefPriority=\"99\"
  LatentStyleCount=\"376\">
  <w:LsdException Locked=\"false\" Priority=\"0\" QFormat=\"true\" Name=\"Normal\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" QFormat=\"true\" Name=\"heading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"9\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"heading 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index 9\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 7\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 8\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"toc 9\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"header\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footer\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"index heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"35\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"caption\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of figures\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"envelope return\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"footnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"line number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"page number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote reference\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"endnote text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"table of authorities\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"macro\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"toa heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Bullet 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Number 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"10\" QFormat=\"true\" Name=\"Title\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Closing\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Signature\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Default Paragraph Font\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"List Continue 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Message Header\"/>
  <w:LsdException Locked=\"false\" Priority=\"11\" QFormat=\"true\" Name=\"Subtitle\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Salutation\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Date\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text First Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Note Heading\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Body Text Indent 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Block Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"FollowedHyperlink\"/>
  <w:LsdException Locked=\"false\" Priority=\"22\" QFormat=\"true\" Name=\"Strong\"/>
  <w:LsdException Locked=\"false\" Priority=\"20\" QFormat=\"true\" Name=\"Emphasis\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Document Map\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Plain Text\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"E-mail Signature\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Top of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Bottom of Form\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal (Web)\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Acronym\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Address\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Cite\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Code\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Definition\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Keyboard\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Preformatted\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Sample\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Typewriter\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"HTML Variable\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Normal Table\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"annotation subject\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"No List\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Outline List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Simple 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Classic 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Colorful 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Columns 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Grid 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 4\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 5\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 7\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table List 8\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table 3D effects 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Contemporary\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Elegant\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Professional\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Subtle 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 2\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Web 3\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Balloon Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" Name=\"Table Grid\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Table Theme\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Placeholder Text\"/>
  <w:LsdException Locked=\"false\" Priority=\"1\" QFormat=\"true\" Name=\"No Spacing\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" Name=\"Revision\"/>
  <w:LsdException Locked=\"false\" Priority=\"34\" QFormat=\"true\"
   Name=\"List Paragraph\"/>
  <w:LsdException Locked=\"false\" Priority=\"29\" QFormat=\"true\" Name=\"Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"30\" QFormat=\"true\"
   Name=\"Intense Quote\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"60\" Name=\"Light Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"61\" Name=\"Light List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"62\" Name=\"Light Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"63\" Name=\"Medium Shading 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"64\" Name=\"Medium Shading 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"65\" Name=\"Medium List 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"66\" Name=\"Medium List 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"67\" Name=\"Medium Grid 1 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"68\" Name=\"Medium Grid 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"69\" Name=\"Medium Grid 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"70\" Name=\"Dark List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"71\" Name=\"Colorful Shading Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"72\" Name=\"Colorful List Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"73\" Name=\"Colorful Grid Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"19\" QFormat=\"true\"
   Name=\"Subtle Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"21\" QFormat=\"true\"
   Name=\"Intense Emphasis\"/>
  <w:LsdException Locked=\"false\" Priority=\"31\" QFormat=\"true\"
   Name=\"Subtle Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"32\" QFormat=\"true\"
   Name=\"Intense Reference\"/>
  <w:LsdException Locked=\"false\" Priority=\"33\" QFormat=\"true\" Name=\"Book Title\"/>
  <w:LsdException Locked=\"false\" Priority=\"37\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" Name=\"Bibliography\"/>
  <w:LsdException Locked=\"false\" Priority=\"39\" SemiHidden=\"true\"
   UnhideWhenUsed=\"true\" QFormat=\"true\" Name=\"TOC Heading\"/>
  <w:LsdException Locked=\"false\" Priority=\"41\" Name=\"Plain Table 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"42\" Name=\"Plain Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"43\" Name=\"Plain Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"44\" Name=\"Plain Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"45\" Name=\"Plain Table 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"40\" Name=\"Grid Table Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"Grid Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"Grid Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"Grid Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"Grid Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"Grid Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"Grid Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"Grid Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"Grid Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"Grid Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"Grid Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\" Name=\"List Table 1 Light\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\" Name=\"List Table 6 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\" Name=\"List Table 7 Colorful\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 1\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 2\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 3\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 4\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 5\"/>
  <w:LsdException Locked=\"false\" Priority=\"46\"
   Name=\"List Table 1 Light Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"47\" Name=\"List Table 2 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"48\" Name=\"List Table 3 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"49\" Name=\"List Table 4 Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"50\" Name=\"List Table 5 Dark Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"51\"
   Name=\"List Table 6 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" Priority=\"52\"
   Name=\"List Table 7 Colorful Accent 6\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Mention\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Smart Hyperlink\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Hashtag\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Unresolved Mention\"/>
  <w:LsdException Locked=\"false\" SemiHidden=\"true\" UnhideWhenUsed=\"true\"
   Name=\"Smart Link\"/>
 </w:LatentStyles>
</xml><![endif]-->

<!--[if gte mso 10]>
<style>
 /* Style Definitions */
 table.MsoNormalTable
   {mso-style-name:\"Table Normal\";
   mso-tstyle-rowband-size:0;
   mso-tstyle-colband-size:0;
   mso-style-noshow:yes;
   mso-style-priority:99;
   mso-style-parent:\"\";
   mso-padding-alt:0in 5.4pt 0in 5.4pt;
   mso-para-margin-top:0in;
   mso-para-margin-right:0in;
   mso-para-margin-bottom:8.0pt;
   mso-para-margin-left:0in;
   line-height:107%;
   mso-pagination:widow-orphan;
   font-size:11.0pt;
   font-family:\"Calibri\",sans-serif;
   mso-ascii-font-family:Calibri;
   mso-ascii-theme-font:minor-latin;
   mso-hansi-font-family:Calibri;
   mso-hansi-theme-font:minor-latin;
   mso-bidi-font-family:Arial;
   mso-bidi-theme-font:minor-bidi;
   mso-ansi-language:EN-CA;}
</style>
<![endif]-->



<!--StartFragment-->































































































<!--EndFragment--></p><p style=\"margin-top:0in;margin-right:0in;margin-bottom:7.5pt;margin-left:0in;
line-height:13.5pt;background:white;box-sizing: border-box;transition: none !important;
-webkit-transition: none !important\"><span style=\"font-size:10.0pt;font-family:
&quot;Arial&quot;,sans-serif;color:#404040\">[1] “IEEE Recommended Practice for Excitation
System Models for Power System Stability Studies.” IEEE Standard, Vol. 421, No.
5, 2005 (Revision of IEEE 521.5-1992).<o:p></o:p></span></p>
</body></html>", revisions= "<html><head></head><body><div><i><br></i></div><ul>

<li><em> 2020-02-04 &nbsp;&nbsp;</em>
     by Alireza Masoom initially implemented<br>
     </li>
</ul>
</body></html>"),
    Icon( coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-80, 81}, extent = {{-18, 11}, {18, -11}}, textString = "Vref"), Text(origin = {-82, 23}, extent = {{-18, 11}, {18, -11}}, textString = "Vt"), Text(origin = {-80, -35}, extent = {{-18, 11}, {18, -11}}, textString = "Vstab"), Text(origin = {-82, -89}, extent = {{-18, 11}, {18, -11}}, textString = "Ifd"), Text(origin = {74, 69}, extent = {{-18, 11}, {18, -11}}, textString = "Efd"), Rectangle(origin = {0, 1}, lineColor = {0, 0, 255}, extent = {{-100, 99}, {100, -101}}), Text(origin = {-12, 8}, extent = {{-36, 42}, {54, -50}}, textString = "ST1A"), Text(origin = {70, -69}, extent = {{-18, 11}, {18, -11}}, textString = "VF")}),
    Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {147, -94}, extent = {{-11, -14}, {1, -6}}, textString = "V8"), Text(origin = {173, -110}, extent = {{-61, 0}, {7, -8}}, textString = "KLR*(Ifd-ILR)"), Text(origin = {273, 54}, extent = {{-11, -14}, {1, -6}}, textString = "Vt"), Text(origin = {189, 95}, extent = {{35, -13}, {-11, 3}}, textString = "Efd_max"), Text(origin = {191, -41}, extent = {{35, -13}, {-11, 3}}, textString = "Efd_min"), Text(origin = {-44, -63}, extent = {{16, -7}, {-4, 1}}, textString = "Vf")}));
end Exciter_ST1;
