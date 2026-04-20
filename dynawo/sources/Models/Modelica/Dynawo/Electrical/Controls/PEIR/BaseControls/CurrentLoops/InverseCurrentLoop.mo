within Dynawo.Electrical.Controls.PEIR.BaseControls.CurrentLoops;

model InverseCurrentLoop
  parameter Types.PerUnit Kpc "Proportional gain of the current loop";
  parameter Types.PerUnit Kic "Integral gain of the current loop";
  parameter Types.PerUnit RFilter "Filter resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit LFilter "Filter impedance in pu (base UNom, SNom)";
  parameter Types.PerUnit Kfd = 1 "Feedforward gain on the d-axis";
  parameter Types.PerUnit Kfq "Feedforward gain on the q-axis";
  parameter Real Ts "Delay for the backward loop";
  parameter Real XVI "Virtual impedance in pu (base UNom, SNom), directly included into the QSEM control";
  
  Modelica.Blocks.Interfaces.RealInput udConvRefPu(start = UdConv0Pu) "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, 66}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-80, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqConvRefPu(start = UqConv0Pu) "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -64}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-56, 109}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput DeltaUidConvRefPu "d-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {40, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {0, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput DeltaUiqConvRefPu "q-axis modulation voltage reference in pu (base UNom)" annotation(
    Placement(transformation(origin = {40, -112}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {0, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput udFilterPu(start = UdFilter0Pu) "d-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {-109, 90}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {50, -110}, extent = {{10, -10}, {-10, 10}}, rotation = -90)));
  Modelica.Blocks.Interfaces.RealInput uqFilterPu(start = UqFilter0Pu) "q-axis voltage at the converter's capacitor in pu (base UNom)" annotation(
    Placement(transformation(origin = {-110, -86}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {74, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idConvPu(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-70, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput iqConvPu(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {-46, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Modelica.Blocks.Interfaces.RealInput idQSEM(start = IdConv0Pu) "d-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {78, 112}, extent = {{-10, -10}, {10, 10}}, rotation = -90), iconTransformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput iqQSEM(start = IqConv0Pu) "q-axis current in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {72, -110}, extent = {{-10, -10}, {10, 10}}, rotation = 90), iconTransformation(origin = {-110, -20}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealInput omegaPu(start = SystemBase.omegaRef0Pu) "Converter's frequency in pu (base omegaNom)" annotation(
    Placement(transformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {60, 110}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  
  Modelica.Blocks.Interfaces.RealOutput idConvRefPu(start = IdConv0Pu) "d-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Interfaces.RealOutput iqConvRefPu(start = IqConv0Pu) "q-axis current reference in the converter in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Gain feedforwardd(k = Kfd)  annotation(
    Placement(transformation(origin = {-80, 86}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Gain feedforwardq(k = Kfq)  annotation(
    Placement(transformation(origin = {-82, -86}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Add addd(k1 = -1)  annotation(
    Placement(transformation(origin = {-54, 80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addq(k2 = -1)  annotation(
    Placement(transformation(origin = {-54, -80}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addd1 annotation(
    Placement(transformation(origin = {0, 66}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Add addq1(k1 = -1)  annotation(
    Placement(transformation(origin = {0, -62}, extent = {{-10, -10}, {10, 10}})));
  Modelica.Blocks.Math.Product productq annotation(
    Placement(transformation(origin = {-60, 20}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Product productd annotation(
    Placement(transformation(origin = {-60, -14}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Gain gainLfq(k = LFilter)  annotation(
    Placement(transformation(origin = {-40, 20}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Gain gainLfd(k = LFilter)  annotation(
    Placement(transformation(origin = {-40, -14}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Add addd2 annotation(
    Placement(transformation(origin = {84, 60}, extent = {{-6, -6}, {6, 6}})));
  Modelica.Blocks.Math.Add addq2 annotation(
    Placement(transformation(origin = {81, -39}, extent = {{-7, -7}, {7, 7}})));

  parameter Types.PerUnit UdFilter0Pu "Start value of d-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit UqFilter0Pu "Start value of q-axis voltage at the converter's capacitor in pu (base UNom)";
  parameter Types.PerUnit IdConv0Pu "Start value of d-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit IqConv0Pu "Start value of q-axis current in the converter in pu (base UNom, SNom) (generator convention)";
  parameter Types.PerUnit UdConv0Pu "Start value of d-axis modulation voltage in pu (base UNom)";
  parameter Types.PerUnit UqConv0Pu "Start value of q-axis modulation voltage in pu (base UNom)";
  Modelica.Blocks.Math.Gain gaind(k = 1/(Kpc+ Ts*Kic))  annotation(
    Placement(transformation(origin = {62, 56}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gainq(k = 1/(Kpc+ Ts*Kic)) annotation(
    Placement(transformation(origin = {64, -36}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gainqXVI(k = XVI)  annotation(
    Placement(transformation(origin = {-44, 40}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Gain gainqXVI1(k = XVI) annotation(
    Placement(transformation(origin = {-46, -40}, extent = {{-4, -4}, {4, 4}})));
  Modelica.Blocks.Math.Add addqLX annotation(
    Placement(transformation(origin = {-21, 37}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Math.Add adddLX1 annotation(
    Placement(transformation(origin = {-21, -37}, extent = {{-5, -5}, {5, 5}})));
  Modelica.Blocks.Math.Feedback feedbackd annotation(
    Placement(transformation(origin = {36, 62}, extent = {{-10, 10}, {10, -10}})));
  Modelica.Blocks.Math.Feedback feedbackq annotation(
    Placement(transformation(origin = {40, -60}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(udFilterPu, feedforwardd.u) annotation(
    Line(points = {{-109, 90}, {-87, 90}, {-87, 86}}, color = {0, 0, 127}));
  connect(uqFilterPu, feedforwardq.u) annotation(
    Line(points = {{-110, -86}, {-89, -86}}, color = {0, 0, 127}));
  connect(feedforwardd.y, addd.u1) annotation(
    Line(points = {{-73.4, 86}, {-65.4, 86}}, color = {0, 0, 127}));
  connect(udConvRefPu, addd.u2) annotation(
    Line(points = {{-110, 66}, {-72, 66}, {-72, 74}, {-66, 74}}, color = {0, 0, 127}));
  connect(uqConvRefPu, addq.u1) annotation(
    Line(points = {{-110, -64}, {-68, -64}, {-68, -74}, {-66, -74}}, color = {0, 0, 127}));
  connect(feedforwardq.y, addq.u2) annotation(
    Line(points = {{-75, -86}, {-66, -86}}, color = {0, 0, 127}));
  connect(omegaPu, productq.u2) annotation(
    Line(points = {{-110, 0}, {-78, 0}, {-78, 16}, {-67, 16}}, color = {0, 0, 127}));
  connect(iqConvPu, productq.u1) annotation(
    Line(points = {{-110, 40}, {-78, 40}, {-78, 24}, {-67, 24}}, color = {0, 0, 127}));
  connect(omegaPu, productd.u1) annotation(
    Line(points = {{-110, 0}, {-78, 0}, {-78, -10}, {-67, -10}}, color = {0, 0, 127}));
  connect(idConvPu, productd.u2) annotation(
    Line(points = {{-110, -40}, {-78, -40}, {-78, -18}, {-67, -18}}, color = {0, 0, 127}));
  connect(productq.y, gainLfq.u) annotation(
    Line(points = {{-53, 20}, {-47, 20}}, color = {0, 0, 127}));
  connect(productd.y, gainLfd.u) annotation(
    Line(points = {{-54, -14}, {-47, -14}}, color = {0, 0, 127}));
  connect(addd.y, addd1.u1) annotation(
    Line(points = {{-42, 80}, {-14, 80}, {-14, 76}, {-12, 76}, {-12, 72}}, color = {0, 0, 127}));
  connect(addq.y, addq1.u2) annotation(
    Line(points = {{-42, -80}, {-16, -80}, {-16, -68}, {-12, -68}}, color = {0, 0, 127}));
  connect(iqQSEM, addq2.u2) annotation(
    Line(points = {{72, -110}, {72, -43}, {73, -43}}, color = {0, 0, 127}));
  connect(addq2.y, iqConvRefPu) annotation(
    Line(points = {{89, -39}, {110, -39}, {110, -40}}, color = {0, 0, 127}));
  connect(addd2.y, idConvRefPu) annotation(
    Line(points = {{91, 60}, {110, 60}}, color = {0, 0, 127}));
  connect(idQSEM, addd2.u1) annotation(
    Line(points = {{78, 112}, {76, 112}, {76, 64}, {77, 64}}, color = {0, 0, 127}));
  connect(gaind.y, addd2.u2) annotation(
    Line(points = {{66, 56}, {76, 56}}, color = {0, 0, 127}));
  connect(gainq.y, addq2.u1) annotation(
    Line(points = {{68, -36}, {72, -36}, {72, -34}}, color = {0, 0, 127}));
  connect(iqConvPu, gainqXVI.u) annotation(
    Line(points = {{-110, 40}, {-49, 40}}, color = {0, 0, 127}));
  connect(gainqXVI1.u, idConvPu) annotation(
    Line(points = {{-51, -40}, {-110, -40}}, color = {0, 0, 127}));
  connect(gainLfq.y, addqLX.u2) annotation(
    Line(points = {{-33, 20}, {-27, 20}, {-27, 34}}, color = {0, 0, 127}));
  connect(gainqXVI.y, addqLX.u1) annotation(
    Line(points = {{-40, 40}, {-27, 40}}, color = {0, 0, 127}));
  connect(addqLX.y, addd1.u2) annotation(
    Line(points = {{-15.5, 37}, {-12, 37}, {-12, 60}}, color = {0, 0, 127}));
  connect(adddLX1.y, addq1.u1) annotation(
    Line(points = {{-15.5, -37}, {-12, -37}, {-12, -56}}, color = {0, 0, 127}));
  connect(gainqXVI1.y, adddLX1.u2) annotation(
    Line(points = {{-42, -40}, {-26, -40}}, color = {0, 0, 127}));
  connect(gainLfd.y, adddLX1.u1) annotation(
    Line(points = {{-34, -14}, {-26, -14}, {-26, -34}}, color = {0, 0, 127}));
  connect(DeltaUidConvRefPu, feedbackd.u2) annotation(
    Line(points = {{40, 110}, {36, 110}, {36, 70}}, color = {0, 0, 127}));
  connect(addd1.y, feedbackd.u1) annotation(
    Line(points = {{12, 66}, {28, 66}, {28, 62}}, color = {0, 0, 127}));
  connect(feedbackd.y, gaind.u) annotation(
    Line(points = {{46, 62}, {54, 62}, {54, 56}, {58, 56}}, color = {0, 0, 127}));
  connect(addq1.y, feedbackq.u1) annotation(
    Line(points = {{12, -62}, {32, -62}, {32, -60}}, color = {0, 0, 127}));
  connect(feedbackq.y, gainq.u) annotation(
    Line(points = {{50, -60}, {54, -60}, {54, -36}, {60, -36}}, color = {0, 0, 127}));
  connect(DeltaUiqConvRefPu, feedbackq.u2) annotation(
    Line(points = {{40, -112}, {40, -68}}, color = {0, 0, 127}));
  annotation(
    Diagram);end InverseCurrentLoop;