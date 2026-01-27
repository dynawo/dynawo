within Dynawo.Electrical.Controls.Converters.OuterControls.Synchronization;

model VirtualSynchroMachine

  parameter Real H "inertie ";
  parameter Real K_VSM "constant ";
  parameter Types.PerUnit WPLL  "Cut off angular frequency of a first order filter at the output of the PLL";

  parameter Types.Angle theta0 "start-value of the phase shift between the grid rotation frame and the converter rotating frame ";
  parameter Boolean Wref_FromPLL "TRUE if the reference for omegaSetSelected is coming from PLL otherwise is a fixe value";
  parameter Types.PerUnit omegaSetSelected0Pu "start-value of the Fixe angular frequency selected  in pu (base omegaNom)";

  parameter Types.PerUnit PRef0Pu "start value of the reference active power (SRef, UNom)";
  parameter Types.PerUnit PMesure0Pu "start value of the active power mesured, base (SRef, UNom) ";
  parameter Types.PerUnit omega0Pu "start value of converter's frequency in pu (base omegaNom) ";
  parameter Types.PerUnit omegaRef0Pu "start value of frequency system reference in pu (base omegaNom)";
  parameter Types.PerUnit omegaPLL0Pu "start value of PLL Frequency  in pu (base omegaNom)";


  Modelica.Blocks.Interfaces.RealInput PMesurePu(start = PMesure0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, 0}, {-100, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = omegaPLL0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, -64}, {-100, -44}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start=theta0) annotation(
    Placement(visible = true, transformation(origin = {244, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start=omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {256, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-110, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, 42}, {-100, 62}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(y_start = omega0Pu)  annotation(
    Placement(visible = true, transformation(origin = {52, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = 1 / (2 * H))  annotation(
    Placement(visible = true, transformation(origin = {-4, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = K_VSM)  annotation(
    Placement(visible = true, transformation(origin = {-4, -16}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 add3(k1 = -1, k2 = +1, k3 = -1)  annotation(
    Placement(visible = true, transformation(origin = {-51, 11}, extent = {{-9, -9}, {9, 9}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(k1 = -1, k2 = +1)  annotation(
    Placement(visible = true, transformation(origin = {106, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator1(k = SystemBase.omegaNom, y_start = omega0Pu - omegaRef0Pu)  annotation(
    Placement(visible = true, transformation(origin = {204, 56}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.Converters.OuterControls.Synchronization.OmegaSelection omegaSelection(WPLL = WPLL,Wref_FromPLL = Wref_FromPLL, omegaPLL0Pu = omegaPLL0Pu,  omegaSetSelected0Pu = omegaSetSelected0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-32, 52}, extent = {{-14, -14}, {14, 14}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {160, 58}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = 1) annotation(
    Placement(visible = true, transformation(origin = {-110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-120, 74}, {-100, 94}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = 0.0001)  annotation(
    Placement(visible = true, transformation(origin = {174, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Der der1 annotation(
    Placement(visible = true, transformation(origin = {282, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(PRefPu, add3.u2) annotation(
    Line(points = {{-110, -2}, {-84, -2}, {-84, 11}, {-62, 11}}, color = {0, 0, 127}));
  connect(gain1.y, add3.u3) annotation(
    Line(points = {{-15, -16}, {-70, -16}, {-70, 4}, {-62, 4}}, color = {0, 0, 127}));
  connect(add3.y, gain.u) annotation(
    Line(points = {{-41, 11}, {-27.5, 11}, {-27.5, 18}, {-16, 18}}, color = {0, 0, 127}));
  connect(gain.y, integrator.u) annotation(
    Line(points = {{7, 18}, {22.5, 18}, {22.5, 12}, {40, 12}}, color = {0, 0, 127}));
  connect(integrator.y, add.u2) annotation(
    Line(points = {{64, 12}, {94, 12}, {94, 8}}, color = {0, 0, 127}));
  connect(add.y, gain1.u) annotation(
    Line(points = {{118, 14}, {124, 14}, {124, -16}, {8, -16}}, color = {0, 0, 127}));
  connect(integrator1.y, theta) annotation(
    Line(points = {{215, 56}, {243, 56}}, color = {0, 0, 127}));
  connect(omegaPLLPu, omegaSelection.omegaPLLPu) annotation(
    Line(points = {{-110, 60}, {-47, 60}}, color = {0, 0, 127}));
  connect(omegaSelection.omegaSetSelectedPu, add.u1) annotation(
    Line(points = {{-17, 51}, {52, 51}, {52, 36}, {84, 36}, {84, 20}, {94, 20}}, color = {0, 0, 127}));
  connect(feedback2.y, integrator1.u) annotation(
    Line(points = {{170, 58}, {192, 58}, {192, 56}}, color = {0, 0, 127}));
  connect(integrator.y, omegaPu) annotation(
    Line(points = {{64, 12}, {72, 12}, {72, 48}, {144, 48}, {144, 12}, {256, 12}}, color = {0, 0, 127}));
  connect(feedback2.u1, integrator.y) annotation(
    Line(points = {{152, 58}, {64, 58}, {64, 12}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{-110, 80}, {160, 80}, {160, 66}}, color = {0, 0, 127}));
  connect(PMesurePu, add3.u1) annotation(
    Line(points = {{-110, 26}, {-78, 26}, {-78, 18}, {-62, 18}}, color = {0, 0, 127}));
  connect(derivative.u, omegaPu) annotation(
    Line(points = {{162, -10}, {156, -10}, {156, 12}, {256, 12}}, color = {0, 0, 127}));
  connect(der1.u, omegaPu) annotation(
    Line(points = {{270, 44}, {234, 44}, {234, 12}, {256, 12}}, color = {0, 0, 127}));
  annotation(
    Diagram(coordinateSystem(extent = {{-120, 100}, {280, -40}})),
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {0, -8}, extent = {{-50, 40}, {50, -40}}, textString = "VSM"), Text(origin = {-173, -43}, extent = {{-47, 19}, {47, -19}}, textString = "omegaRefPLLPu"), Text(origin = {-169, 20}, extent = {{-37, 14}, {37, -14}}, textString = "Pmesured"), Text(origin = {-173, 59}, extent = {{-45, 20}, {45, -15}}, textString = "Preference"), Text(origin = {157, 58}, extent = {{-37, 14}, {37, -14}}, textString = "ThetaVSC"), Text(origin = {163, -24}, extent = {{-37, 14}, {37, -14}}, textString = "OmegaVSC"), Text(origin = {-173, 103}, extent = {{-51, 19}, {51, -19}}, textString = "omegaRefPu")}));
end VirtualSynchroMachine;
