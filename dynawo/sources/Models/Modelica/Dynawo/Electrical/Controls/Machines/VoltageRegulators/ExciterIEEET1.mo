within Dynawo.Electrical.Controls.Machines.VoltageRegulators;

model ExciterIEEET1

  import Modelica;

  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  parameter Types.VoltageModulePu VRmax "Maximum stator reference voltage in p.u (base UNom)";
  parameter Types.VoltageModulePu VRmin "Minimum stator reference voltage in p.u (base UNom)";
  parameter Types.Time Tr "Measurement time constant";
  parameter Types.Time Ka "Regulator gain";
  parameter Types.Time Ta "Regulator time constant";
  parameter Types.Time Ke "Exciter constant related to self-excited field";
  parameter Types.Time Te "Exciter time constant";
  parameter Types.Time Kf "Feedback gain";
  parameter Types.Time Tf "Feedback time constant";
  parameter Real E1  "Exciter alternator output voltages back of commutating reactance at which saturation is defined";
  parameter Real E2  "Exciter alternator output voltages back of commutating reactance at which saturation is defined";
  parameter Real SE1 "Exciter saturation function value at the corresponding exciter voltage, E1, back of commutating reactance";
  parameter Real SE2 "Exciter saturation function value at the corresponding exciter voltage, E2, back of commutating reactance";

  block Saturation "Excitation saturation model"

    import Modelica.Blocks.Interfaces;
    import Modelica.Blocks.Icons.Block;
    import Modelica.Constants;

    extends Block;

    public

      parameter Real E1  "Exciter alternator output voltages back of commutating reactance at which saturation is defined";
      parameter Real E2  "Exciter alternator output voltages back of commutating reactance at which saturation is defined";
      parameter Real SE1 "Exciter saturation function value at the corresponding exciter voltage, E1, back of commutating reactance";
      parameter Real SE2 "Exciter saturation function value at the corresponding exciter voltage, E2, back of commutating reactance";

      Interfaces.RealInput u "Input signal connector" annotation (Placement(
          transformation(extent={{-140,-20},{-100,20}})));
      Interfaces.RealOutput y "Output signal connector" annotation (Placement(
          transformation(extent={{100,-10},{120,10}})));

    protected

      parameter Real K = if (SE2 > 0) then SE1/SE2
                          else 0;
      parameter Real A = (E1*E2)^0.5 * (E1^0.5 - (E2*K)^0.5) / (E2^0.5 - (E1*K)^0.5);
      parameter Real B = SE2 * (E2^0.5 - (E1*K)^0.5)^2 / (E1-E2)^2;

    equation

       y = if (u <= A) then 0
           else B * (u-A)^2 / u;


    annotation(preferredView = "text",
    Icon(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}), graphics={

      Line(points={{-80,-56},{-60,-56},{-60,-22},{38,-22},{38,-56},{66,-56}},
                color={0,0,192}),
      Line(points={{-80,32},{18,32},{18,66},{38,66},{38,32},{66,32}},
                color={0,192,0}),

      Line(points={{0,-90},{0,68}}, color={192,192,192}),
      Polygon(
        points={{0,90},{-8,68},{8,68},{0,90}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-90,0},{68,0}}, color={192,192,192}),
      Polygon(
        points={{90,0},{68,-8},{68,8},{90,0}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-80,-70},{-50,-70},{50,70},{80,70}}),
      Text(
        extent={{-150,-150},{150,-110}},
        lineColor={0,0,0},
        textString="uMax=%uMax"),
      Text(
        extent={{-150,150},{150,110}},
        textString="%name",
        lineColor={0,0,255}),
      Line(
        visible=strict,
        points={{50,70},{80,70}},
        color={255,0,0}),
      Line(
        visible=strict,
        points={{-80,-70},{-50,-70}},
        color={255,0,0})}),
      Diagram(coordinateSystem(
      preserveAspectRatio=true,
      extent={{-100,-100},{100,100}}), graphics={
      Line(points={{0,-60},{0,50}}, color={192,192,192}),
      Polygon(
        points={{0,60},{-5,50},{5,50},{0,60}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-60,0},{50,0}}, color={192,192,192}),
      Polygon(
        points={{60,0},{50,-5},{50,5},{60,0}},
        lineColor={192,192,192},
        fillColor={192,192,192},
        fillPattern=FillPattern.Solid),
      Line(points={{-50,-40},{-30,-40},{30,40},{50,40}}),
      Text(
        extent={{46,-6},{68,-18}},
        lineColor={128,128,128},
        textString="u"),
      Text(
        extent={{-30,70},{-5,50}},
        lineColor={128,128,128},
        textString="y"),
      Text(
        extent={{58,-54},{28,-42}},
        lineColor={128,128,128},
        textString="%delayTimes s"),
      Text(
        extent={{-58,-54},{-28,-42}},
        lineColor={128,128,128},
        textString="uMin"),
      Text(
        extent={{26,40},{66,56}},
        lineColor={128,128,128},
        textString="uMax")}));
  end Saturation;

  // Inputs
  Modelica.Blocks.Interfaces.RealInput UsPu annotation(
    Placement(visible = true, transformation(origin = {-156, -66}, extent = {{-20, -20}, {20, 20}}, rotation = 90), iconTransformation(origin = {-56, -40}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput UsRefPu(start = UsRef0Pu) annotation(
    Placement(visible = true, transformation(origin = {-206, 20}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-108, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0)));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput EfdPu annotation(
    Placement(visible = true, transformation(origin = {178, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {108, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.Feedback feedback annotation(
    Placement(visible = true, transformation(origin = {-156, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain(k = Ka) annotation(
    Placement(visible = true, transformation(origin = {-76, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = Tr, y_start = Us0Pu)  annotation(
    Placement(visible = true, transformation(origin = {-156, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Nonlinear.Limiter limiter(limitsAtInit = true, uMax = VRmax, uMin = VRmin)  annotation(
    Placement(visible = true, transformation(origin = {4, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = Ta, y_start = Ka * (UsRef0Pu - Us0Pu)) annotation(
    Placement(visible = true, transformation(origin = {-36, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedback1 annotation(
    Placement(visible = true, transformation(origin = {-120, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = Te / Ke, y_start = Efd0Pu)  annotation(
    Placement(visible = true, transformation(origin = {120, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gain1(k = 1 / Ke) annotation(
    Placement(visible = true, transformation(origin = {82, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative Stabilizer(T = Tf, k = Kf, x_start = Efd0Pu, y_start = 0)  annotation(
    Placement(visible = true, transformation(origin = {0, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Feedback feedbackSaturation annotation(
    Placement(visible = true, transformation(origin = {44, 20}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  ExciterIEEET1.Saturation saturation(E1 = E1, E2 = E2, SE1 = SE1, SE2 = SE2) annotation(
    Placement(visible = true, transformation(origin = {96, 60}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));

protected

  parameter Types.VoltageModulePu UsRef0Pu "Initial control voltage";
  parameter Types.VoltageModulePu Us0Pu "Initial stator voltage";
  parameter Types.VoltageModulePu Efd0Pu "Initial Efd";
equation
  connect(gain.y, firstOrder1.u) annotation(
    Line(points = {{-65, 20}, {-49, 20}}, color = {0, 0, 127}));
  connect(firstOrder1.y, limiter.u) annotation(
    Line(points = {{-25, 20}, {-9, 20}}, color = {0, 0, 127}));
  connect(UsRefPu, feedback.u1) annotation(
    Line(points = {{-206, 20}, {-164, 20}}, color = {0, 0, 127}));
  connect(UsPu, firstOrder.u) annotation(
    Line(points = {{-156, -66}, {-156, -30}}, color = {0, 0, 127}));
  connect(firstOrder.y, feedback.u2) annotation(
    Line(points = {{-156, -7}, {-156, 11}}, color = {0, 0, 127}));
  connect(feedback.y, feedback1.u1) annotation(
    Line(points = {{-147, 20}, {-129, 20}}, color = {0, 0, 127}));
  connect(gain1.y, firstOrder2.u) annotation(
    Line(points = {{93, 20}, {107, 20}}, color = {0, 0, 127}));
  connect(firstOrder2.y, EfdPu) annotation(
    Line(points = {{131, 20}, {177, 20}}, color = {0, 0, 127}));
  connect(feedback1.y, gain.u) annotation(
    Line(points = {{-110, 20}, {-88, 20}}, color = {0, 0, 127}));
  connect(firstOrder2.y, Stabilizer.u) annotation(
    Line(points = {{132, 20}, {140, 20}, {140, -40}, {12, -40}}, color = {0, 0, 127}));
  connect(Stabilizer.y, feedback1.u2) annotation(
    Line(points = {{-10, -40}, {-120, -40}, {-120, 12}}, color = {0, 0, 127}));
  connect(feedbackSaturation.y, gain1.u) annotation(
    Line(points = {{53, 20}, {69, 20}}, color = {0, 0, 127}));
  connect(limiter.y, feedbackSaturation.u1) annotation(
    Line(points = {{15, 20}, {35, 20}}, color = {0, 0, 127}));
  connect(saturation.y, feedbackSaturation.u2) annotation(
    Line(points = {{85, 60}, {44, 60}, {44, 28}}, color = {0, 0, 127}));
  connect(firstOrder2.y, saturation.u) annotation(
    Line(points = {{132, 20}, {140, 20}, {140, 60}, {108, 60}}, color = {0, 0, 127}));
  annotation(
    uses(Modelica(version = "3.2.3"), Dynawo(version = "1.0.1")));
end ExciterIEEET1;
