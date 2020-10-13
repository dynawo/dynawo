within OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel;

model IEEE13Bus_CP
  OpenEMTP.Electrical.Lines.CPmodel.TLM TL632_633(Ti = [0.502659687516342, 0.778867301097029, -0.249833119452532; 0.644850930369252, -0.176951289724402, 0.792006771920747; 0.533578236163045, -0.600564731133732, -0.550352955472635], Zc = {764.184393459587, 306.035536630964, 375.610320375084}, d = 152.4, m = 3, r = {0.624132018960508, 0.367412074618122, 0.365147402870877}, tau = {6.41053351781503e-07, 5.63676955383253e-07, 5.53093403094522e-07}) annotation(
    Placement(visible = true, transformation(origin = {38, 40}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM TL645_646(Ti = [0.709760014102212, 0.707283577128397; -0.703991675137205, 0.705943506643941], Zc = {399.485026197963, 690.511593619760}, d = 91.44, m = 2, r = {0.695512999978358, 0.951363975417606}, tau = {3.36644175540423e-07, 3.94748620479157e-07}) annotation(
    Placement(visible = true, transformation(origin = {-154, 40}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM TL632_671(Ti = [0.505189464539041, 0.783794931439085, -0.252229039493785; 0.564188272358512, -0.597545662954778, -0.555384509344831; 0.651256031484475, -0.169101218408001, 0.792115369033768], Zc = {749.768892193477, 252.869007223048, 324.493021610224}, d = 609.6, m = 3, r = {0.401627787827348, 0.115668097204995, 0.115494616539130}, tau = {2.51909782126786e-06, 2.08448710137279e-06, 2.07421383075992e-06}) annotation(
    Placement(visible = true, transformation(origin = {0, -34}, extent = {{-15, -11}, {15, 11}}, rotation = -90)));
  OpenEMTP.Connectors.Bus B632 annotation(
    Placement(visible = true, transformation(origin = {0, 112}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  OpenEMTP.Connectors.Bus B645(m = 2) annotation(
    Placement(visible = true, transformation(origin = {-84, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Bus B646(m = 2) annotation(
    Placement(visible = true, transformation(origin = {-200, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Bus B633 annotation(
    Placement(visible = true, transformation(origin = {76, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_bc plug_bc annotation(
    Placement(visible = true, transformation(origin = {-16, 40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Bus B634 annotation(
    Placement(visible = true, transformation(origin = {168, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Bus B671(m = 3) annotation(
    Placement(visible = true, transformation(origin = {0, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM TL671_684(Ti = [0.705943506643940, -0.703991675137206; 0.707283577128397, 0.709760014102211], Zc = {690.511593619760, 399.485026197964}, d = 91.44, m = 2, r = {0.951363975417606, 0.695512999978358}, tau = {3.94748620479157e-07, 3.36644175540423e-07}) annotation(
    Placement(visible = true, transformation(origin = {-66, -102}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Connectors.Plug_ac plug_ac annotation(
    Placement(visible = true, transformation(origin = {-22, -102}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Bus B684(m = 2) annotation(
    Placement(visible = true, transformation(origin = {-124, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_a(k = 1, m = 2) annotation(
    Placement(visible = true, transformation(origin = {-160, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p Ph_c(k = 2, m = 2) annotation(
    Placement(visible = true, transformation(origin = {-142, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  OpenEMTP.Electrical.Lines.CPmodel.SP_TLM Cable684_652(Zc = 75.8806476549555, d = 243.84, r = 0.834192898952366, tau = 2.71396421650751e-06) annotation(
    Placement(visible = true, transformation(origin = {-214, -102}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.SP_TLM TL684_611(Zc = 546.045460673406, d = 91.44, r = 0.825928641554923, tau = 3.71926621942778e-07) annotation(
    Placement(visible = true, transformation(origin = {-178, -180}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM TL671_680(Ti = [0.505189464539041, 0.783794931439085, -0.252229039493785; 0.564188272358512, -0.597545662954778, -0.555384509344831; 0.651256031484475, -0.169101218408001, 0.792115369033768], Zc = {749.768892193477, 252.869007223048, 324.493021610224}, d = 304.8, m = 3, r = {0.401627787827348, 0.115668097204995, 0.115494616539130}, tau = {1.25954891063393e-06, 1.04224355068639e-06, 1.03710691537996e-06}) annotation(
    Placement(visible = true, transformation(origin = {0, -186}, extent = {{-15, -11}, {15, 11}}, rotation = -90)));
  OpenEMTP.Connectors.Bus B680(m = 3) annotation(
    Placement(visible = true, transformation(origin = {0, -236}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  OpenEMTP.Connectors.Bus B692(m = 3) annotation(
    Placement(visible = true, transformation(origin = {112, -138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM Cabe692_675(Ti = [0.572560468518626, -0.707106781186547, -0.414487460508261; 0.586393524678774, -1.08480673665415e-15, 0.810026317191903; 0.572560468518626, 0.707106781186548, -0.414487460508261], Zc = {70.7331849751132, 66.7733346795049, 62.5648843218698}, d = 152.4, m = 3, r = {0.876231001021404, 0.318950625722346, 0.286598744556595}, tau = {1.72234634931087e-06, 1.62512482204948e-06, 1.52309247336468e-06}) annotation(
    Placement(visible = true, transformation(origin = {176, -138}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Connectors.Bus B675(m = 3) annotation(
    Placement(visible = true, transformation(origin = {224, -138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.YCosineVoltage AC_Source(Phase = {-0.0434587, -2.12441, 2.05652}, Vm = {1.021, 1.042, 1.0174} * 4.16, f = {60, 60, 60}, m = 3) annotation(
    Placement(visible = true, transformation(origin = {-88, 180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.SP_Bus B652 annotation(
    Placement(visible = true, transformation(origin = {-256, -102}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.SP_Bus B611 annotation(
    Placement(visible = true, transformation(origin = {-212, -180}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Connectors.Bus B650 annotation(
    Placement(visible = true, transformation(origin = {0, 160}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  OpenEMTP.Electrical.Lines.CPmodel.TLM TL632_645(Ti = [0.709760014102212, 0.707283577128397; -0.703991675137205, 0.705943506643941], Zc = {399.485026197963, 690.511593619760}, d = 152.4, m = 2, r = {0.695512999978358, 0.951363975417606}, tau = {5.61073625900705e-07, 6.57914367465262e-07}) annotation(
    Placement(visible = true, transformation(origin = {-50, 40}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel.Load632 load632 annotation(
    Placement(visible = true, transformation(origin = {40, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel.Load645 load645 annotation(
    Placement(visible = true, transformation(origin = {-94, 18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Load646Z load646Z annotation(
    Placement(visible = true, transformation(origin = {-234, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel.Load634 load634 annotation(
    Placement(visible = true, transformation(origin = {180, 24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel.Load671D load671D annotation(
    Placement(visible = true, transformation(origin = {32, -114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel.Load671Y load671Y annotation(
    Placement(visible = true, transformation(origin = {54, -114}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel.Load692D load692D annotation(
    Placement(visible = true, transformation(origin = {100, -156}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Examples.IEEE13Bus.Case1_CPmodel.Load675Y load675Y annotation(
    Placement(visible = true, transformation(origin = {240, -156}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Load652 load652 annotation(
    Placement(visible = true, transformation(origin = {-278, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Load611 load611 annotation(
    Placement(visible = true, transformation(origin = {-234, -194}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  OpenEMTP.Electrical.Switches.Breaker CB annotation(
    Placement(visible = true, transformation(origin = {52, -138}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(TL632_633.Plug_k, B632.positivePlug2) annotation(
    Line(points = {{23, 40.2}, {0, 40.2}, {0, 110}}, color = {0, 0, 255}));
  connect(TL645_646.Plug_k, B646.positivePlug1) annotation(
    Line(points = {{-169, 40.2}, {-184, 40.2}, {-184, 40}, {-198, 40}}, color = {0, 0, 255}));
  connect(TL632_671.Plug_m, B671.positivePlug1) annotation(
    Line(points = {{0, -48.8}, {0, -98}}, color = {0, 0, 255}));
  connect(plug_ac.positivePlugIn, B671.positivePlug2) annotation(
    Line(points = {{-19, -102}, {0, -102}}, color = {0, 0, 255}));
  connect(plug_ac.positivePlugOut, TL671_684.Plug_m) annotation(
    Line(points = {{-25, -102}, {-51, -102}}, color = {0, 0, 255}));
  connect(TL671_684.Plug_k, B684.positivePlug1) annotation(
    Line(points = {{-81, -102}, {-122, -102}}, color = {0, 0, 255}));
  connect(Ph_a.plug_p, B684.positivePlug2) annotation(
    Line(points = {{-158, -102}, {-126, -102}}, color = {0, 0, 255}));
  connect(Ph_c.plug_p, B684.positivePlug2) annotation(
    Line(points = {{-140, -180}, {-126, -180}, {-126, -102}}, color = {0, 0, 255}));
  connect(Ph_a.pin_p, Cable684_652.pin_m) annotation(
    Line(points = {{-162, -102}, {-180, -102}, {-180, -102.2}, {-199.6, -102.2}}, color = {238, 46, 47}));
  connect(Ph_c.pin_p, TL684_611.pin_m) annotation(
    Line(points = {{-144, -180}, {-154, -180}, {-154, -180.2}, {-163.6, -180.2}}, color = {0, 170, 0}));
  connect(TL671_680.Plug_k, B671.positivePlug2) annotation(
    Line(points = {{0, -171}, {0, -102}}, color = {0, 0, 255}));
  connect(TL671_680.Plug_m, B680.positivePlug1) annotation(
    Line(points = {{0, -201}, {0, -234}}, color = {0, 0, 255}));
  connect(Cabe692_675.Plug_k, B692.positivePlug1) annotation(
    Line(points = {{161, -138}, {114, -138}}, color = {0, 0, 255}));
  connect(Cabe692_675.Plug_m, B675.positivePlug2) annotation(
    Line(points = {{191, -138}, {222, -138}}, color = {0, 0, 255}));
  connect(Cable684_652.pin_k, B652.pin1) annotation(
    Line(points = {{-229, -102.2}, {-254, -102.2}, {-254, -102}, {-254, -102}}, color = {238, 46, 47}));
  connect(TL684_611.pin_k, B611.pin1) annotation(
    Line(points = {{-193, -180.2}, {-210, -180.2}, {-210, -180}, {-210, -180}}, color = {0, 140, 72}));
  connect(B633.positivePlug2, TL632_633.Plug_m) annotation(
    Line(points = {{74, 40}, {54, 40}, {54, 40}, {52.8, 40}}, color = {0, 0, 255}));
  connect(AC_Source.Pk, B650.positivePlug1) annotation(
    Line(points = {{-78.4, 180}, {0, 180}, {0, 162}, {0, 162}}, color = {0, 0, 255}));
  connect(B650.positivePlug2, B632.positivePlug1) annotation(
    Line(points = {{0, 158}, {0, 114}}, color = {0, 0, 255}));
  connect(TL632_645.Plug_m, plug_bc.positivePlugOut) annotation(
    Line(points = {{-36, 40}, {-20, 40}, {-20, 40}, {-18, 40}}, color = {0, 0, 255}));
  connect(TL632_645.Plug_k, B645.positivePlug1) annotation(
    Line(points = {{-64, 40}, {-82, 40}, {-82, 40}, {-82, 40}}, color = {0, 0, 255}));
  connect(B645.positivePlug2, TL645_646.Plug_m) annotation(
    Line(points = {{-86, 40}, {-138, 40}, {-138, 40}, {-140, 40}}, color = {0, 0, 255}));
  connect(plug_bc.positivePlugIn, B632.positivePlug2) annotation(
    Line(points = {{-12, 40}, {0, 40}, {0, 110}, {0, 110}}, color = {0, 0, 255}));
  connect(TL632_671.Plug_k, TL632_633.Plug_k) annotation(
    Line(points = {{0, -18}, {0, -18}, {0, 40}, {24, 40}, {24, 40}}, color = {0, 0, 255}));
  connect(load632.positivePlug, B632.positivePlug2) annotation(
    Line(points = {{40, 102}, {40, 110}, {0, 110}}, color = {0, 0, 255}));
  connect(load645.plug_p, B645.positivePlug2) annotation(
    Line(points = {{-94, 28}, {-94, 28}, {-94, 40}, {-86, 40}, {-86, 40}}, color = {0, 0, 255}));
  connect(B646.positivePlug2, load646Z.plug_p) annotation(
    Line(points = {{-202, 40}, {-234, 40}, {-234, 18}, {-234, 18}}, color = {0, 0, 255}));
  connect(load634.plug_p, B634.positivePlug1) annotation(
    Line(points = {{180, 34}, {180, 40}, {170, 40}}, color = {0, 0, 255}));
  connect(load671D.plug_p, B671.positivePlug2) annotation(
    Line(points = {{32, -104}, {32, -104}, {32, -102}, {0, -102}, {0, -102}}, color = {0, 0, 255}));
  connect(load671Y.plug_p, B671.positivePlug2) annotation(
    Line(points = {{54, -104}, {54, -104}, {54, -102}, {0, -102}, {0, -102}}, color = {0, 0, 255}));
  connect(load692D.plug_p, B692.positivePlug2) annotation(
    Line(points = {{100, -146}, {100, -138}, {110, -138}}, color = {0, 0, 255}));
  connect(B675.positivePlug1, load675Y.plug_p) annotation(
    Line(points = {{226, -138}, {240, -138}, {240, -146}}, color = {0, 0, 255}));
  connect(B652.pin, load652.pin_p) annotation(
    Line(points = {{-258, -102}, {-278, -102}, {-278, -110}, {-278, -110}}, color = {0, 0, 255}));
  connect(B611.pin, load611.pin_p) annotation(
    Line(points = {{-214, -180}, {-234, -180}, {-234, -184}, {-234, -184}}, color = {0, 0, 255}));
  connect(CB.m, B692.positivePlug2) annotation(
    Line(points = {{62, -138}, {110, -138}}, color = {0, 0, 255}));
  connect(CB.k, TL671_680.Plug_k) annotation(
    Line(points = {{42, -138}, {0, -138}, {0, -171}}, color = {0, 0, 255}));
  connect(B633.positivePlug1, B634.positivePlug2) annotation(
    Line(points = {{78, 40}, {166, 40}, {166, 40}, {166, 40}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(extent = {{-300, -300}, {300, 300}}, initialScale = 0.1), graphics = {Text(origin = {-78, 309}, extent = {{-14, 7}, {200, -85}}, textString = "IEEE 13 Node Test Feeder")}),
    Icon(coordinateSystem(extent = {{-300, -300}, {300, 300}})),
    experiment(StartTime = 0, StopTime = 0.05, Tolerance = 0.0001, Interval = 1e-07),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian -d=initialization ");
end IEEE13Bus_CP;
