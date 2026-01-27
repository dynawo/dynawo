within Dynawo.Electrical.Controls.Converters.OuterControls.Synchronization;

model VirtualSynchroMachineFeedForward


  //Parameters

  parameter Types.PerUnit DampingPowerFactor "DampingPower constant";
  parameter Types.PerUnit DampingAngleFactor "DampingAngle constant";
  parameter Types.Time H "Inertie constant in sec ";
  parameter Types.PerUnit omega0Pu "start value of converter's frequency in pu (base omegaNom) ";
  parameter Types.PerUnit omegaRef0Pu "start value of frequency system reference in pu (base omegaNom)";
  parameter Types.PerUnit PRef0Pu "start value of the reference active power (base SNom, UNom)";
  parameter Types.PerUnit PMesure0Pu "start value of the active power mesured (base SNom, UNom) ";
  parameter Types.Time TimeHighPassFilter "Time order in sec of the high order pass filter";
  parameter Types.Angle theta0 "start-value of the phase shift between the grid rotation frame and the converter rotating frame ";


  //Input Variables
  Modelica.Blocks.Interfaces.RealInput PMesurePu(start = PMesure0Pu) "Active power measured (SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, -74}, {-100, -54}}, rotation = 0)));
 Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Active power reference (SNom, UNom)" annotation(
    Placement(visible = true, transformation(origin = {-110, 22}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, -22}, {-100, -2}}, rotation = 0)));

  //Output Variables
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start=omega0Pu) "Frequency of the converter in pu (base OmegaNom)" annotation(
    Placement(visible = true, transformation(origin = {256, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
      Modelica.Blocks.Interfaces.RealOutput theta(start=theta0) "Phase shift between the grid rotation grid and the converter rotation frame" annotation(
    Placement(visible = true, transformation(origin = {372, -34}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));


  Modelica.Blocks.Continuous.Integrator integrator(y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {52, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / (2 * H))  annotation(
    Placement(visible = true, transformation(origin = {-4, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainDampingPower(k = DampingPowerFactor)  annotation(
    Placement(visible = true, transformation(origin = {-77, -43}, extent = {{13, -13}, {-13, 13}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k2 = +1, k3 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-51, 11}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = +1, k2 = +1)  annotation(
    Placement(visible = true, transformation(origin = {120, 28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = SystemBase.omegaNom, y_start = omega0Pu - omegaRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {258, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {160, 58}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, 42}, {-100, 62}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {20, -22}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T =  TimeHighPassFilter, k = 1, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {76, -24}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain3(k = -1) annotation(
    Placement(visible = true, transformation(origin = {-16, -22}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.Constant Wset(k = 1)  annotation(
    Placement(visible = true, transformation(origin = {26, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1(k1 = +1, k2 = +1) annotation(
    Placement(visible = true, transformation(origin = {324, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain GainDampingAngle(k = DampingAngleFactor) annotation(
    Placement(visible = true, transformation(origin = {159, -37}, extent = {{13, -13}, {-13, 13}}, rotation = 180)));
equation
  connect(PRefPu, add3.u2) annotation(
    Line(points = {{-110, 22}, {-84, 22}, {-84, 11}, {-62, 11}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-41, 11}, {-27.5, 11}, {-27.5, 18}, {-16, 18}}, color = {0, 0, 127}));
  connect(gain.y, integrator.u) annotation(
    Line(points = {{7, 18}, {22.5, 18}, {22.5, 12}, {40, 12}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{64, 12}, {95, 12}, {95, 22}, {108, 22}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{-110, 80}, {160, 80}, {160, 66}}, color = {0, 0, 127}));
  connect(PMesurePu, add3.u1) annotation(
    Line(points = {{-110, 40}, {-78, 40}, {-78, 18}, {-62, 18}}, color = {0, 0, 127}));
  connect(feedback.u1, firstOrder.y) annotation(
    Line(points = {{28, -22}, {62, -22}, {62, -24}, {65, -24}}, color = {0, 0, 127}));
  connect(feedback.y, gain3.u) annotation(
    Line(points = {{11, -22}, {-4, -22}}, color = {0, 0, 127}));
  connect(firstOrder.u, integrator.y) annotation(
    Line(points = {{88, -24}, {100, -24}, {100, 12}, {64, 12}}, color = {0, 0, 127}));
  connect(integrator.y, firstOrder.u) annotation(
    Line(points = {{64, 12}, {96, 12}, {96, -24}, {88, -24}}, color = {0, 0, 127}));
  connect(feedback.u2, firstOrder.u) annotation(
    Line(points = {{20, -30}, {20, -60}, {88, -60}, {88, -24}}, color = {0, 0, 127}));
  connect(add.y, feedback2.u1) annotation(
    Line(points = {{132, 28}, {132, 58}, {152, 58}}, color = {0, 0, 127}));
  connect(GainDampingAngle.y, add1.u2) annotation(
    Line(points = {{173, -37}, {243.5, -37}, {243.5, -38}, {312, -38}}, color = {0, 0, 127}));
  connect(integrator.y, GainDampingAngle.u) annotation(
    Line(points = {{64, 12}, {108, 12}, {108, -37}, {143, -37}}, color = {0, 0, 127}));
  connect(add.y, omegaPu) annotation(
    Line(points = {{132, 28}, {156, 28}, {156, 34}, {220, 34}, {220, 12}, {256, 12}}, color = {0, 0, 127}));
  connect(integrator1.u, feedback2.y) annotation(
    Line(points = {{246, 56}, {170, 56}, {170, 58}}, color = {0, 0, 127}));
  connect(integrator1.y, add1.u1) annotation(
    Line(points = {{270, 56}, {280, 56}, {280, -26}, {312, -26}}, color = {0, 0, 127}));
  connect(add1.y, theta) annotation(
    Line(points = {{336, -32}, {372, -32}, {372, -34}}, color = {0, 0, 127}));
  connect(Wset.y, add.u1) annotation(
    Line(points = {{38, 60}, {90, 60}, {90, 34}, {108, 34}}, color = {0, 0, 127}));
  connect(GainDampingPower.u, gain3.y) annotation(
    Line(points = {{-62, -42}, {-48, -42}, {-48, -22}, {-26, -22}}, color = {0, 0, 127}));
  connect(add3.u3, GainDampingPower.y) annotation(
    Line(points = {{-62, 4}, {-80, 4}, {-80, -18}, {-106, -18}, {-106, -42}, {-92, -42}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-120, 100}, {300, -80}}), graphics = {Text(origin = {60, -67}, extent = {{-24, 13}, {24, -13}}, textString = "Ts/(1+Ts)"), Rectangle(origin = {33, -43}, extent = {{-63, 35}, {63, -35}}), Text(origin = {43, 34}, extent = {{-29, 4}, {29, -4}}, textString = "Integrator _start=0")}),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {4, -1}, extent = {{-88, 79}, {88, -79}}, textString = "VSMFeedForward"), Text(origin = {-169, -62}, extent = {{-37, 14}, {37, -14}}, textString = "Pmesured"), Text(origin = {-171, -15}, extent = {{-45, 20}, {45, -15}}, textString = "Preference"), Text(origin = {157, 58}, extent = {{-37, 14}, {37, -14}}, textString = "ThetaVSC"), Text(origin = {163, -24}, extent = {{-37, 14}, {37, -14}}, textString = "OmegaVSC"), Text(origin = {-179, 57}, extent = {{-51, 19}, {51, -19}}, textString = "omegaRefPu")}),
 Documentation(info = "<html><head></head><body>This VSM control structure was taken from SEFAD model in \"Design- and Simulation-based Comparison of Grid-Forming Converter Control Concepts\" paper.<div>A high pass filter was added to better control active power in case of high rocof.&nbsp;</div><div>In the paper different control strutcre for VSM are presented, the droop and the swing Equation (SE) have the same profil. However both provide FCR because of the term kd(w-wref). Here the equation for VSM: Ta*w=p*-p-kd(w-wref), if we do not want FCR provision then wref should be equalt to wpll, as it is done in MIGRATE controls. But if we want to get ride of PLLs then we have to use the control Swing Equation with Frequency Angle Droop (SEFAD) or Swing Equation with Differential Feedback (SEDF). In both case FCR is not present. Valentin(T2EP) proposed a model SEDF+SEDF</div><div><br></div></body></html>"));


end VirtualSynchroMachineFeedForward;
