within Dynawo.Examples.RVSTestSystem;

model StaticNetwork
  Dynawo.Electrical.Buses.Bus Atlee121 annotation(
    Placement(visible = true, transformation(origin = {-40, 86}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Aubrey122 annotation(
    Placement(visible = true, transformation(origin = {80, 86}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Arthur115 annotation(
    Placement(visible = true, transformation(origin = {-88, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Buses.Bus Astor118 annotation(
    Placement(visible = true, transformation(origin = {-10, 68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Arnold114 annotation(
    Placement(visible = true, transformation(origin = {-24, 22}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Austen123 annotation(
    Placement(visible = true, transformation(origin = {94, 54}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Attar119 annotation(
    Placement(visible = true, transformation(origin = {8, 36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Attila120 annotation(
    Placement(visible = true, transformation(origin = {50,36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Arne113 annotation(
    Placement(visible = true, transformation(origin = {96, 10}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Archer112 annotation(
    Placement(visible = true, transformation(origin = {38, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Anna111 annotation(
    Placement(visible = true, transformation(origin = {-34, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Avery124 annotation(
    Placement(visible = true, transformation(origin = {-80, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Adler103 annotation(
    Placement(visible = true, transformation(origin = {-80, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.Bus Abel101 annotation(
    Placement(visible = true, transformation(origin = {-80, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.Bus Ali109 annotation(
    Placement(visible = true, transformation(origin = {-32, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Buses.Bus Alber106 annotation(
    Placement(visible = true, transformation(origin = {-14, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Buses.Bus Allen110 annotation(
    Placement(visible = true, transformation(origin = {44, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Alger108 annotation(
    Placement(visible = true, transformation(origin = {86, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Alder107 annotation(
    Placement(visible = true, transformation(origin = {96, -64}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Aiken105 annotation(
    Placement(visible = true, transformation(origin = {26, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Adams102 annotation(
    Placement(visible = true, transformation(origin = {4, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line A1(BPu = 0.461, GPu = 0, RPu = 0.003, XPu = 0.014)  annotation(
    Placement(visible = true, transformation(origin = {-34, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A2(BPu = 0.057, GPu = 0,  RPu = 0.055, XPu = 0.211)  annotation(
    Placement(visible = true, transformation(origin = {-80, -68}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line A3(BPu = 0.023, GPu = 0,  RPu = 0.022, XPu = 0.085)  annotation(
    Placement(visible = true, transformation(origin = {-2, -98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A4(BPu = 0.034, GPu = 0,  RPu = 0.033, XPu = 0.127)  annotation(
    Placement(visible = true, transformation(origin = {-3, -79}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Buses.Bus Agricola104 annotation(
    Placement(visible = true, transformation(origin = {-22, -72}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Dynawo.Electrical.Lines.Line A5(BPu = 0.052, GPu = 0,  RPu = 0.05, XPu = 0.192)  annotation(
    Placement(visible = true, transformation(origin = {1, -59}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line A8(BPu = 0.028, GPu = 0,  RPu = 0.027, XPu = 0.104)  annotation(
    Placement(visible = true, transformation(origin = {-17, -59}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line A10(BPu = 2.459, GPu = 0,  RPu = 0.014, XPu = 0.061)  annotation(
    Placement(visible = true, transformation(origin = {12, -28}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line A6(BPu = 0.032, GPu = 0,  RPu = 0.031, XPu = 0.119)  annotation(
    Placement(visible = true, transformation(origin = {-56, -52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A9(BPu = 0.024, GPu = 0,  RPu = 0.023, XPu = 0.088)  annotation(
    Placement(visible = true, transformation(origin = {44, -50}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Electrical.Lines.Line A11(BPu = 0.017, GPu = 0,  RPu = 0.016, XPu = 0.061)  annotation(
    Placement(visible = true, transformation(origin = {72, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A12_1(BPu = 0.045, GPu = 0,  RPu = 0.043, XPu = 0.165)  annotation(
    Placement(visible = true, transformation(origin = {14, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A13_2(BPu = 0.045, GPu = 0,  RPu = 0.043, XPu = 0.165)  annotation(
    Placement(visible = true, transformation(origin = {76, -18}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Buses.Bus Asser116 annotation(
    Placement(visible = true, transformation(origin = {-44, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
  Dynawo.Electrical.Buses.Bus Aston117 annotation(
    Placement(visible = true, transformation(origin = {32, 52}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line A18(BPu = 0.100, GPu = 0,  RPu = 0.006, XPu = 0.048)  annotation(
    Placement(visible = true, transformation(origin = {24, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A19(BPu = 0.088, GPu = 0,  RPu = 0.005, XPu = 0.042)  annotation(
    Placement(visible = true, transformation(origin = {-51, 15}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Electrical.Lines.Line A20(BPu = 0.100, GPu = 0,  RPu = 0.006, XPu = 0.048)  annotation(
    Placement(visible = true, transformation(origin = {70, 4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A21(BPu = 0.203, GPu = 0,  RPu = 0.012, XPu = 0.097)  annotation(
    Placement(visible = true, transformation(origin = {74, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line A22(BPu = 0.182, GPu = 0,  RPu = 0.011, XPu = 0.087)  annotation(
    Placement(visible = true, transformation(origin = {90, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line A23(BPu = 0.082, GPu = 0,  RPu = 0.005, XPu = 0.059)  annotation(
    Placement(visible = true, transformation(origin = {-34, 36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line A24(BPu = 0.036, GPu = 0, RPu = 0.002, XPu = 0.017)  annotation(
    Placement(visible = true, transformation(origin = {-62, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A25_1(BPu = 0.103, GPu = 0, RPu = 0.006, XPu = 0.049)  annotation(
    Placement(visible = true, transformation(origin = {-58, 72}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A25_2(BPu = 0.103, GPu = 0, RPu = 0.006, XPu = 0.049)  annotation(
    Placement(visible = true, transformation(origin = {-58, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A26(BPu = 0.109, GPu = 0,  RPu = 0.007, XPu = 0.052)  annotation(
    Placement(visible = true, transformation(origin = {-88, 26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Dynawo.Electrical.Lines.Line A27(BPu = 0.055, GPu = 0, RPu = 0.003, XPu = 0.026)  annotation(
    Placement(visible = true, transformation(origin = {-8, 52}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A28(BPu = 0.049, GPu = 0, RPu = 0.003, XPu = 0.023)  annotation(
    Placement(visible = true, transformation(origin = {-10, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line A29(BPu = 0.03, GPu = 0, RPu = 0.002, XPu = 0.014)  annotation(
    Placement(visible = true, transformation(origin = {12, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line A30(BPu = 0.221, GPu = 0, RPu = 0.014, XPu = 0.105)  annotation(
    Placement(visible = true, transformation(origin = {46, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A31_1(BPu = 0.055, GPu = 0, RPu = 0.003, XPu = 0.026)  annotation(
    Placement(visible = true, transformation(origin = {-24, 86}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A31_2(BPu = 0.055, GPu = 0, RPu = 0.003, XPu = 0.026)  annotation(
    Placement(visible = true, transformation(origin = {-24, 76}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A32_1(BPu = 0.083, GPu = 0, RPu = 0.005, XPu = 0.040)  annotation(
    Placement(visible = true, transformation(origin = {28, 36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A32_2(BPu = 0.083, GPu = 0, RPu = 0.005, XPu = 0.040)  annotation(
    Placement(visible = true, transformation(origin = {28, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Lines.Line A34(BPu = 0.142, GPu = 0, RPu = 0.009, XPu = 0.068)  annotation(
    Placement(visible = true, transformation(origin = {14, 92}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A33_1(BPu = 0.046, GPu = 0, RPu = 0.003, XPu = 0.022)  annotation(
    Placement(visible = true, transformation(origin = {68, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line A33_2(BPu = 0.046, GPu = 0, RPu = 0.003, XPu = 0.022)  annotation(
    Placement(visible = true, transformation(origin = {68, 54}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio A7(BPu = 0, GPu = 0,  RPu = 0.002, XPu = 0.084, rTfoPu = 1.015)  annotation(
    Placement(visible = true, transformation(origin = {-80, -18}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio A14(BPu = 0, GPu = 0,  RPu = 0.02, XPu = 0.084, rTfoPu = 1.03)  annotation(
    Placement(visible = true, transformation(origin = {-41, -23}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio A15(BPu = 0, GPu = 0,  RPu = 0.002, XPu = 0.084, rTfoPu = 1.03)  annotation(
    Placement(visible = true, transformation(origin = {14, -18}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio A16(BPu = 0, GPu = 0,  RPu = 0.002, XPu = 0.084, rTfoPu = 1.015)  annotation(
    Placement(visible = true, transformation(origin = {-10, -10}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  Dynawo.Electrical.Transformers.TransformerFixedRatio A17(BPu = 0, GPu = 0,  RPu = 0.002, XPu = 0.084, rTfoPu = 1.015)  annotation(
    Placement(visible = true, transformation(origin = {44, -12}, extent = {{-8, -8}, {8, 8}}, rotation = -90)));
equation
  connect(A1.terminal2, Adams102.terminal) annotation(
    Line(points = {{-24, -88}, {4, -88}}, color = {0, 0, 255}));
  connect(A1.terminal1, Abel101.terminal) annotation(
    Line(points = {{-44, -88}, {-80, -88}}, color = {0, 0, 255}));
  connect(A2.terminal1, Adler103.terminal) annotation(
    Line(points = {{-80, -58}, {-80, -52}}, color = {0, 0, 255}));
  connect(A2.terminal2, Abel101.terminal) annotation(
    Line(points = {{-80, -78}, {-80, -88}}, color = {0, 0, 255}));
  connect(A3.terminal1, Aiken105.terminal) annotation(
    Line(points = {{-12, -98}, {26, -98}, {26, -68}}, color = {0, 0, 255}));
  connect(A3.terminal2, Abel101.terminal) annotation(
    Line(points = {{8, -98}, {-81, -98}, {-81, -88}, {-80, -88}}, color = {0, 0, 255}));
  connect(A4.terminal1, Agricola104.terminal) annotation(
    Line(points = {{-3, -72}, {-22, -72}}, color = {0, 0, 255}));
  connect(A4.terminal2, Adams102.terminal) annotation(
    Line(points = {{-3, -86}, {4, -86}, {4, -88}}, color = {0, 0, 255}));
  connect(A5.terminal2, Adams102.terminal) annotation(
    Line(points = {{1, -66}, {4, -66}, {4, -88}}, color = {0, 0, 255}));
  connect(Alber106.terminal, A5.terminal1) annotation(
    Line(points = {{-14, -32}, {0, -32}, {0, -52}, {1, -52}}, color = {0, 0, 255}));
  connect(A8.terminal2, Agricola104.terminal) annotation(
    Line(points = {{-17, -66}, {-23.5, -66}, {-23.5, -72}, {-22, -72}}, color = {0, 0, 255}));
  connect(Ali109.terminal, A8.terminal1) annotation(
    Line(points = {{-32, -52}, {-17, -52}}, color = {0, 0, 255}));
  connect(A10.terminal2, Allen110.terminal) annotation(
    Line(points = {{22, -28}, {44, -28}}, color = {0, 0, 255}));
  connect(Alber106.terminal, A10.terminal1) annotation(
    Line(points = {{-14, -32}, {-14, -28}, {2, -28}}, color = {0, 0, 255}));
  connect(A6.terminal2, Ali109.terminal) annotation(
    Line(points = {{-46, -52}, {-32, -52}, {-32, -52}, {-32, -52}}, color = {0, 0, 255}));
  connect(A6.terminal1, Adler103.terminal) annotation(
    Line(points = {{-66, -52}, {-80, -52}, {-80, -52}, {-80, -52}}, color = {0, 0, 255}));
  connect(Aiken105.terminal, A9.terminal2) annotation(
    Line(points = {{26, -68}, {44, -68}, {44, -60}}, color = {0, 0, 255}));
  connect(A9.terminal1, Allen110.terminal) annotation(
    Line(points = {{44, -40}, {44, -28}}, color = {0, 0, 255}));
  connect(A11.terminal2, Alder107.terminal) annotation(
    Line(points = {{82, -64}, {96, -64}}, color = {0, 0, 255}));
  connect(A11.terminal1, Alger108.terminal) annotation(
    Line(points = {{62, -64}, {62, -42}, {86, -42}, {86, -36}}, color = {0, 0, 255}));
  connect(A12_1.terminal1, Ali109.terminal) annotation(
    Line(points = {{4, -36}, {4, -44}, {-32, -44}, {-32, -52}}, color = {0, 0, 255}));
  connect(A12_1.terminal2, Alger108.terminal) annotation(
    Line(points = {{24, -36}, {86, -36}}, color = {0, 0, 255}));
  connect(A13_2.terminal2, Alger108.terminal) annotation(
    Line(points = {{86, -18}, {86, -36}}, color = {0, 0, 255}));
  connect(A13_2.terminal1, Allen110.terminal) annotation(
    Line(points = {{66, -18}, {48, -18}, {48, -28}, {44, -28}}, color = {0, 0, 255}));
  connect(A18.terminal1, Anna111.terminal) annotation(
    Line(points = {{14, -6}, {-33, -6}, {-33, 2}, {-34, 2}}, color = {0, 0, 255}));
  connect(A19.terminal1, Arnold114.terminal) annotation(
    Line(points = {{-51, 22}, {-24, 22}}, color = {0, 0, 255}));
  connect(A20.terminal2, Arne113.terminal) annotation(
    Line(points = {{80, 4}, {96, 4}, {96, 10}}, color = {0, 0, 255}));
  connect(A20.terminal1, Archer112.terminal) annotation(
    Line(points = {{60, 4}, {38, 4}}, color = {0, 0, 255}));
  connect(A21.terminal1, Austen123.terminal) annotation(
    Line(points = {{74, 36}, {74, 54}, {94, 54}}, color = {0, 0, 255}));
  connect(Archer112.terminal, A21.terminal2) annotation(
    Line(points = {{38, 4}, {38, 16}, {74, 16}}, color = {0, 0, 255}));
  connect(A22.terminal1, Austen123.terminal) annotation(
    Line(points = {{90, 36}, {90, 44}, {94, 44}, {94, 54}}, color = {0, 0, 255}));
  connect(Arne113.terminal, A22.terminal2) annotation(
    Line(points = {{96, 10}, {96, 12}, {90, 12}, {90, 16}}, color = {0, 0, 255}));
  connect(A23.terminal2, Arnold114.terminal) annotation(
    Line(points = {{-34, 26}, {-24, 26}, {-24, 22}}, color = {0, 0, 255}));
  connect(A23.terminal1, Asser116.terminal) annotation(
    Line(points = {{-34, 46}, {-44, 46}, {-44, 52}}, color = {0, 0, 255}));
  connect(A24.terminal2, Asser116.terminal) annotation(
    Line(points = {{-52, 52}, {-44, 52}}, color = {0, 0, 255}));
  connect(A24.terminal1, Arthur115.terminal) annotation(
    Line(points = {{-72, 52}, {-80, 52}, {-80, 72}, {-88, 72}}, color = {0, 0, 255}));
  connect(A25_1.terminal1, Arthur115.terminal) annotation(
    Line(points = {{-68, 72}, {-88, 72}}, color = {0, 0, 255}));
  connect(A25_1.terminal2, Atlee121.terminal) annotation(
    Line(points = {{-48, 72}, {-40, 72}, {-40, 86}}, color = {0, 0, 255}));
  connect(A25_2.terminal1, Arthur115.terminal) annotation(
    Line(points = {{-68, 86}, {-88, 86}, {-88, 72}}, color = {0, 0, 255}));
  connect(A25_2.terminal2, Atlee121.terminal) annotation(
    Line(points = {{-48, 86}, {-40, 86}}, color = {0, 0, 255}));
  connect(A26.terminal1, Arthur115.terminal) annotation(
    Line(points = {{-88, 36}, {-88, 72}}, color = {0, 0, 255}));
  connect(A26.terminal2, Avery124.terminal) annotation(
    Line(points = {{-88, 16}, {-88, 2}, {-80, 2}}, color = {0, 0, 255}));
  connect(A27.terminal2, Aston117.terminal) annotation(
    Line(points = {{2, 52}, {32, 52}}, color = {0, 0, 255}));
  connect(A27.terminal1, Asser116.terminal) annotation(
    Line(points = {{-18, 52}, {-44, 52}}, color = {0, 0, 255}));
  connect(A28.terminal2, Attar119.terminal) annotation(
    Line(points = {{0, 36}, {8, 36}}, color = {0, 0, 255}));
  connect(A28.terminal1, Asser116.terminal) annotation(
    Line(points = {{-20, 36}, {-26, 36}, {-26, 50}, {-44, 50}, {-44, 52}}, color = {0, 0, 255}));
  connect(A29.terminal2, Aston117.terminal) annotation(
    Line(points = {{22, 60}, {32, 60}, {32, 52}, {32, 52}, {32, 52}}, color = {0, 0, 255}));
  connect(A29.terminal1, Astor118.terminal) annotation(
    Line(points = {{2, 60}, {-10, 60}, {-10, 68}, {-10, 68}, {-10, 68}}, color = {0, 0, 255}));
  connect(A30.terminal1, Aston117.terminal) annotation(
    Line(points = {{36, 78}, {32, 78}, {32, 52}, {32, 52}}, color = {0, 0, 255}));
  connect(A30.terminal2, Aubrey122.terminal) annotation(
    Line(points = {{56, 78}, {80, 78}, {80, 86}}, color = {0, 0, 255}));
  connect(A31_1.terminal2, Astor118.terminal) annotation(
    Line(points = {{-14, 86}, {-10, 86}, {-10, 68}, {-10, 68}}, color = {0, 0, 255}));
  connect(A31_1.terminal1, Atlee121.terminal) annotation(
    Line(points = {{-34, 86}, {-40, 86}}, color = {0, 0, 255}));
  connect(A31_2.terminal1, Atlee121.terminal) annotation(
    Line(points = {{-34, 76}, {-40, 76}, {-40, 86}}, color = {0, 0, 255}));
  connect(A31_2.terminal2, Astor118.terminal) annotation(
    Line(points = {{-14, 76}, {-10, 76}, {-10, 68}, {-10, 68}}, color = {0, 0, 255}));
  connect(Attar119.terminal, A32_1.terminal2) annotation(
    Line(points = {{8, 36}, {20, 36}, {20, 36}, {38, 36}, {38, 36}}, color = {0, 0, 255}));
  connect(A32_1.terminal2, Attila120.terminal) annotation(
    Line(points = {{38, 36}, {50, 36}, {50, 36}, {50, 36}}, color = {0, 0, 255}));
  connect(A32_2.terminal2, Attila120.terminal) annotation(
    Line(points = {{38, 26}, {50, 26}, {50, 36}, {50, 36}}, color = {0, 0, 255}));
  connect(A32_2.terminal1, Attar119.terminal) annotation(
    Line(points = {{18, 26}, {8, 26}, {8, 36}, {8, 36}}, color = {0, 0, 255}));
  connect(A34.terminal2, Aubrey122.terminal) annotation(
    Line(points = {{24, 92}, {80, 92}, {80, 86}}, color = {0, 0, 255}));
  connect(A34.terminal1, Atlee121.terminal) annotation(
    Line(points = {{4, 92}, {-40, 92}, {-40, 86}, {-40, 86}}, color = {0, 0, 255}));
  connect(A33_2.terminal2, Austen123.terminal) annotation(
    Line(points = {{78, 54}, {94, 54}}, color = {0, 0, 255}));
  connect(A33_2.terminal1, Attila120.terminal) annotation(
    Line(points = {{58, 54}, {50, 54}, {50, 36}, {50, 36}}, color = {0, 0, 255}));
  connect(A33_1.terminal2, Austen123.terminal) annotation(
    Line(points = {{78, 66}, {94, 66}, {94, 54}}, color = {0, 0, 255}));
  connect(A33_1.terminal1, Attila120.terminal) annotation(
    Line(points = {{58, 66}, {50, 66}, {50, 36}, {50, 36}, {50, 36}}, color = {0, 0, 255}));
  connect(A7.terminal1, Avery124.terminal) annotation(
    Line(points = {{-80, -10}, {-80, 2}}, color = {0, 0, 255}));
  connect(A7.terminal2, Adler103.terminal) annotation(
    Line(points = {{-80, -26}, {-80, -26}, {-80, -52}, {-80, -52}}, color = {0, 0, 255}));
  connect(A14.terminal1, Anna111.terminal) annotation(
    Line(points = {{-41, -16}, {-40, -16}, {-40, 2}, {-34, 2}}, color = {0, 0, 255}));
  connect(A14.terminal2, Ali109.terminal) annotation(
    Line(points = {{-41, -30}, {-40, -30}, {-40, -52}, {-32, -52}}, color = {0, 0, 255}));
  connect(A15.terminal1, Archer112.terminal) annotation(
    Line(points = {{6, -18}, {38, -18}, {38, 4}}, color = {0, 0, 255}));
  connect(A15.terminal2, Ali109.terminal) annotation(
    Line(points = {{22, -18}, {-34, -18}, {-34, -52}, {-32, -52}}, color = {0, 0, 255}));
  connect(A16.terminal2, Allen110.terminal) annotation(
    Line(points = {{-18, -10}, {28, -10}, {28, -22}, {34, -22}, {34, -28}, {44, -28}}, color = {0, 0, 255}));
  connect(A16.terminal1, Anna111.terminal) annotation(
    Line(points = {{-2, -10}, {-38, -10}, {-38, 2}, {-34, 2}}, color = {0, 0, 255}));
  connect(Anna111.terminal, A19.terminal2) annotation(
    Line(points = {{-34, 2}, {-50, 2}, {-50, 8}, {-50, 8}}, color = {0, 0, 255}));
  connect(A17.terminal1, Archer112.terminal) annotation(
    Line(points = {{44, -4}, {44, 4}, {38, 4}}, color = {0, 0, 255}));
  connect(A17.terminal2, Allen110.terminal) annotation(
    Line(points = {{44, -20}, {44, -20}, {44, -28}, {44, -28}}, color = {0, 0, 255}));
  connect(A18.terminal2, Arne113.terminal) annotation(
    Line(points = {{34, -6}, {96, -6}, {96, 10}, {96, 10}}, color = {0, 0, 255}));

  // Switch-off signals inhibition
  A1.switchOffSignal1.value = false;
  A1.switchOffSignal2.value = false;
  A2.switchOffSignal1.value = false;
  A2.switchOffSignal2.value = false;
  A3.switchOffSignal1.value = false;
  A3.switchOffSignal2.value = false;
  A4.switchOffSignal1.value = false;
  A4.switchOffSignal2.value = false;
  A5.switchOffSignal1.value = false;
  A5.switchOffSignal2.value = false;
  A6.switchOffSignal1.value = false;
  A6.switchOffSignal2.value = false;
  A7.switchOffSignal1.value = false;
  A7.switchOffSignal2.value = false;
  A8.switchOffSignal1.value = false;
  A8.switchOffSignal2.value = false;
  A9.switchOffSignal1.value = false;
  A9.switchOffSignal2.value = false;
  A10.switchOffSignal1.value = false;
  A10.switchOffSignal2.value = false;
  A11.switchOffSignal1.value = false;
  A11.switchOffSignal2.value = false;
  A12_1.switchOffSignal1.value = false;
  A12_1.switchOffSignal2.value = false;
  A13_2.switchOffSignal1.value = false;
  A13_2.switchOffSignal2.value = false;
  A14.switchOffSignal1.value = false;
  A14.switchOffSignal2.value = false;
  A15.switchOffSignal1.value = false;
  A15.switchOffSignal2.value = false;
  A16.switchOffSignal1.value = false;
  A16.switchOffSignal2.value = false;
  A17.switchOffSignal1.value = false;
  A17.switchOffSignal2.value = false;
  A18.switchOffSignal1.value = false;
  A18.switchOffSignal2.value = false;
  A19.switchOffSignal1.value = false;
  A19.switchOffSignal2.value = false;
  A20.switchOffSignal1.value = false;
  A20.switchOffSignal2.value = false;
  A21.switchOffSignal1.value = false;
  A21.switchOffSignal2.value = false;
  A22.switchOffSignal1.value = false;
  A22.switchOffSignal2.value = false;
  A23.switchOffSignal1.value = false;
  A23.switchOffSignal2.value = false;
  A24.switchOffSignal1.value = false;
  A24.switchOffSignal2.value = false;
  A25_1.switchOffSignal1.value = false;
  A25_1.switchOffSignal2.value = false;
  A25_2.switchOffSignal1.value = false;
  A25_2.switchOffSignal2.value = false;
  A26.switchOffSignal1.value = false;
  A26.switchOffSignal2.value = false;
  A27.switchOffSignal1.value = false;
  A27.switchOffSignal2.value = false;
  A28.switchOffSignal1.value = false;
  A28.switchOffSignal2.value = false;
  A29.switchOffSignal1.value = false;
  A29.switchOffSignal2.value = false;
  A30.switchOffSignal1.value = false;
  A30.switchOffSignal2.value = false;
  A31_1.switchOffSignal1.value = false;
  A31_1.switchOffSignal2.value = false;
  A31_2.switchOffSignal1.value = false;
  A31_2.switchOffSignal2.value = false;
  A32_1.switchOffSignal1.value = false;
  A32_1.switchOffSignal2.value = false;
  A32_2.switchOffSignal1.value = false;
  A32_2.switchOffSignal2.value = false;
  A33_1.switchOffSignal1.value = false;
  A33_1.switchOffSignal2.value = false;
  A33_2.switchOffSignal1.value = false;
  A33_2.switchOffSignal2.value = false;
  A34.switchOffSignal1.value = false;
  A34.switchOffSignal2.value = false;
protected
  annotation(
    Diagram);
end StaticNetwork;
