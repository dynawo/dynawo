within Dynawo.Electrical.Controls.Converters.OuterControls.Synchronization;

model DroopControl
  parameter Types.PerUnit WLP "cutoff angular frequency of the first order filter to mesure P (in rad/s), equal to Wn/10";
  parameter Types.PerUnit Mp "active power droop control coefficient, 0.01Wn< Mp <0.1Wn";
  parameter Types.Angle theta0 "start-value of the phase shift between the grid rotation frame and the converter rotating frame ";
  parameter Types.PerUnit WPLL  "Cut off angular frequency of a first order filter at the output of the PLL";
  parameter Boolean Wref_FromPLL "TRUE if the reference for omegaSetSelected is coming from PLL otherwise is a fixe value";
  parameter Types.PerUnit omegaSetPu  "Fixe angular frequency as a reference  in pu (base omegaNom)";
  parameter Types.PerUnit omegaSetSelected0Pu "start-value of the Fixe angular frequency selected  in pu (base omegaNom)";
  
  Modelica.Blocks.Math.Feedback feedback2 annotation(
    Placement(visible = true, transformation(origin = {70, 94}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 1 / WLP, k = 1, y_start = Mp*(PRef0Pu-PMesure0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-20, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-80, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integrator(k = SystemBase.omegaNom, y_start = omega0Pu - omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {100, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add1 annotation(
    Placement(visible = true, transformation(origin = {20, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Mp) annotation(
    Placement(visible = true, transformation(origin = {-50, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PMesurePu(start = PMesure0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -8}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Blocks.Interfaces.RealOutput omegaPu(start = omega0Pu) annotation(
    Placement(visible = true, transformation(origin = {130, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -57}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = theta0) annotation(
    Placement(visible = true, transformation(origin = {130, 94}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 50}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = omegaRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-130, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput omegaPLLPu(start = omegaPLL0Pu) annotation(
    Placement(visible = true, transformation(origin = {-160, 16}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-4, -110}, extent = {{10, -10}, {-10, 10}}, rotation = 270)));
  parameter Types.PerUnit PRef0Pu "start value of the reference active power (SRef, UNom)";
  parameter Types.PerUnit PMesure0Pu "start value of the active power mesured, base (SRef, UNom) ";
  parameter Types.PerUnit omega0Pu "start value of converter's frequency in pu (base omegaNom) ";
  parameter Types.PerUnit omegaRef0Pu "start value of frequency system reference in pu (base omegaNom)";
  parameter Types.PerUnit omegaPLL0Pu "start value of PLL Frequency  in pu (base omegaNom)";
  Dynawo.Electrical.Controls.Converters.OuterControls.Synchronization.OmegaSelection omegaSelection(WPLL = WPLL, Wref_FromPLL = Wref_FromPLL, omegaPLL0Pu=omegaPLL0Pu, omegaSetPu = omegaSetPu, omegaSetSelected0Pu = omegaSetSelected0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-83, 11}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
equation
  connect(feedback1.u1, PRefPu) annotation(
    Line(points = {{-88, 100}, {-130, 100}}, color = {0, 0, 127}));
  connect(add1.y, omegaPu) annotation(
    Line(points = {{31, 94}, {40, 94}, {40, 40}, {130, 40}}, color = {0, 0, 127}));
  connect(add1.y, feedback2.u1) annotation(
    Line(points = {{31, 94}, {62, 94}}, color = {0, 0, 127}));
  connect(PMesurePu, feedback1.u2) annotation(
    Line(points = {{-130, 52}, {-80, 52}, {-80, 92}}, color = {0, 0, 127}));
  connect(integrator.u, feedback2.y) annotation(
    Line(points = {{88, 94}, {79, 94}}, color = {0, 0, 127}));
  connect(firstOrder.y, add1.u1) annotation(
    Line(points = {{-9, 100}, {8, 100}}, color = {0, 0, 127}));
  connect(integrator.y, theta) annotation(
    Line(points = {{111, 94}, {130, 94}}, color = {0, 0, 127}));
  connect(omegaRefPu, feedback2.u2) annotation(
    Line(points = {{-130, 120}, {70, 120}, {70, 102}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-71, 100}, {-62, 100}}, color = {0, 0, 127}));
  connect(gain.y, firstOrder.u) annotation(
    Line(points = {{-39, 100}, {-32, 100}}, color = {0, 0, 127}));
  connect(omegaSelection.omegaSetSelectedPu, add1.u2) annotation(
    Line(points = {{-62, 10}, {-40, 10}, {-40, 48}, {-2, 48}, {-2, 88}, {8, 88}}, color = {0, 0, 127}));
  connect(omegaPLLPu, omegaSelection.omegaPLLPu) annotation(
    Line(points = {{-160, 16}, {-104, 16}, {-104, 22}}, color = {0, 0, 127}));
protected
  annotation(
    Diagram(coordinateSystem(extent = {{-140, 140}, {140, -60}})),
    Icon(graphics = {Text(origin = {159, 62}, extent = {{-37, 24}, {37, -24}}, textString = "Theta"), Text(origin = {169, -40}, extent = {{-43, 24}, {43, -24}}, textString = "OmegaPu"), Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {1, -1}, extent = {{-99, 99}, {99, -99}}, textString = "DroopControl"), Text(origin = {-173, 5}, extent = {{-51, 23}, {51, -23}}, textString = "PMesure"), Text(origin = {-160, 78}, extent = {{-38, 14}, {38, -14}}, textString = "PRefPu"), Text(origin = {-178, -52}, extent = {{-60, 16}, {60, -16}}, textString = "omegaRefPu"), Text(origin = {-67, -131}, extent = {{-51, 23}, {51, -23}}, textString = "omegaRefPLLPu")}));
end DroopControl;