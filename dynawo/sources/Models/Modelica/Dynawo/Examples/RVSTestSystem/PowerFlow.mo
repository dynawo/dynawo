within Dynawo.Examples.RVSTestSystem;

model PowerFlow
  extends StaticNetwork;
  Dynawo.Electrical.Machines.SignalN.GeneratorPV AttleeGen(PGen0Pu = 1) annotation(
    Placement(visible = true, transformation(origin = {-63, 99}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV ArthurGen annotation(
    Placement(visible = true, transformation(origin = {-107, 77}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV AstorGen annotation(
    Placement(visible = true, transformation(origin = {7, 75}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV AsserGen  annotation(
    Placement(visible = true, transformation(origin = {-65, 37}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV AustenGen annotation(
    Placement(visible = true, transformation(origin = {123, 53}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ AstorLoad annotation(
    Placement(visible = true, transformation(origin = {-23, 65}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ AsserLoad annotation(
    Placement(visible = true, transformation(origin = {-63, 61}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ AttilaLoad annotation(
    Placement(visible = true, transformation(origin = {57, 35}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ AttarLoad annotation(
    Placement(visible = true, transformation(origin = {-1, 29}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ ArnoldLoad annotation(
    Placement(visible = true, transformation(origin = {-11, 15}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ ArthurLoad annotation(
    Placement(visible = true, transformation(origin = {-103, 65}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV ArneGen annotation(
    Placement(visible = true, transformation(origin = {117, 17}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ ArneLoad annotation(
    Placement(visible = true, transformation(origin = {113, 3}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV AlderGen annotation(
    Placement(visible = true, transformation(origin = {119, -59}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV AbelGen(PGen0Pu = 1.7106, QGen0Pu = 0.424, U0Pu = 1.034, u0Pu = Complex(0.9782, -0.3349), KGover = 0, PMaxPu = 10, PMinPu = -10, PNom = 172, QMaxPu = 10, QMinPu = -10)  annotation(
    Placement(visible = true, transformation(origin = {-87, -105}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV AdamsGen annotation(
    Placement(visible = true, transformation(origin = {17, -77}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Machines.SignalN.GeneratorPV AubreyGen annotation(
    Placement(visible = true, transformation(origin = {97, 89}, extent = {{-7, -7}, {7, 7}}, rotation = 0)));
  Dynawo.Electrical.Loads.LoadPQ AbelLoad annotation(
    Placement(visible = true, transformation(origin = {-109, -91}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ AdlerLoad annotation(
    Placement(visible = true, transformation(origin = {-109, -61}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ AliLoad annotation(
    Placement(visible = true, transformation(origin = {-47, -63}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ AgricolaLoad annotation(
    Placement(visible = true, transformation(origin = {-39, -79}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
  Dynawo.Electrical.Loads.LoadPQ AikenLoad annotation(
    Placement(visible = true, transformation(origin = {39, -81}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ AdamsLoad annotation(
    Placement(visible = true, transformation(origin = {15, -91}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ AllenLoad annotation(
    Placement(visible = true, transformation(origin = {57, -31}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ AlgerLoad annotation(
    Placement(visible = true, transformation(origin = {111, -27}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ AlderLoad annotation(
    Placement(visible = true, transformation(origin = {115, -69}, extent = {{-7, -7}, {7, 7}}, rotation = 90)));
  Dynawo.Electrical.Loads.LoadPQ AlberLoad annotation(
    Placement(visible = true, transformation(origin = {-23, -31}, extent = {{-7, -7}, {7, 7}}, rotation = -90)));
equation
  connect(Atlee121.terminal, AttleeGen.terminal) annotation(
    Line(points = {{-40, 86}, {-42, 86}, {-42, 100}, {-64, 100}, {-64, 100}, {-62, 100}, {-62, 100}}, color = {0, 0, 255}));
  connect(ArthurGen.terminal, Arthur115.terminal) annotation(
    Line(points = {{-107, 77}, {-88, 77}, {-88, 72}}, color = {0, 0, 255}));
  connect(Astor118.terminal, AstorGen.terminal) annotation(
    Line(points = {{-10, 68}, {6, 68}, {6, 76}, {6, 76}}, color = {0, 0, 255}));
  connect(AsserGen.terminal, Asser116.terminal) annotation(
    Line(points = {{-64, 38}, {-44, 38}, {-44, 52}, {-44, 52}}, color = {0, 0, 255}));
  connect(Austen123.terminal, AustenGen.terminal) annotation(
    Line(points = {{94, 54}, {124, 54}, {124, 54}, {124, 54}}, color = {0, 0, 255}));
  connect(AstorLoad.terminal, Astor118.terminal) annotation(
    Line(points = {{-23, 65}, {-8, 65}, {-8, 68}, {-10, 68}}, color = {0, 0, 255}));
  connect(AsserLoad.terminal, Asser116.terminal) annotation(
    Line(points = {{-62, 62}, {-44, 62}, {-44, 52}, {-44, 52}}, color = {0, 0, 255}));
  connect(Attila120.terminal, AttilaLoad.terminal) annotation(
    Line(points = {{50, 36}, {56, 36}, {56, 36}, {58, 36}}, color = {0, 0, 255}));
  connect(AttarLoad.terminal, Attar119.terminal) annotation(
    Line(points = {{0, 30}, {8, 30}, {8, 36}, {8, 36}}, color = {0, 0, 255}));
  connect(ArnoldLoad.terminal, Arnold114.terminal) annotation(
    Line(points = {{-10, 14}, {-24, 14}, {-24, 22}, {-24, 22}}, color = {0, 0, 255}));
  connect(ArthurLoad.terminal, Arthur115.terminal) annotation(
    Line(points = {{-102, 66}, {-88, 66}, {-88, 72}, {-88, 72}}, color = {0, 0, 255}));
  connect(ArneGen.terminal, Arne113.terminal) annotation(
    Line(points = {{117, 17}, {96, 17}, {96, 10}}, color = {0, 0, 255}));
  connect(ArneLoad.terminal, Arne113.terminal) annotation(
    Line(points = {{113, 3}, {96, 3}, {96, 10}}, color = {0, 0, 255}));
  connect(AlderGen.terminal, Alder107.terminal) annotation(
    Line(points = {{119, -59}, {96, -59}, {96, -64}}, color = {0, 0, 255}));
  connect(AbelGen.terminal, Abel101.terminal) annotation(
    Line(points = {{-87, -105}, {-87, -88}, {-80, -88}}, color = {0, 0, 255}));
  connect(AdamsGen.terminal, Adams102.terminal) annotation(
    Line(points = {{17, -77}, {10, -77}, {10, -88}, {4, -88}}, color = {0, 0, 255}));
  connect(AubreyGen.terminal, Aubrey122.terminal) annotation(
    Line(points = {{98, 90}, {80, 90}, {80, 86}, {80, 86}, {80, 86}}, color = {0, 0, 255}));
  connect(AbelLoad.terminal, Abel101.terminal) annotation(
    Line(points = {{-109, -91}, {-90, -91}, {-90, -88}, {-80, -88}}, color = {0, 0, 255}));
  connect(AdlerLoad.terminal, Adler103.terminal) annotation(
    Line(points = {{-108, -60}, {-88, -60}, {-88, -52}, {-80, -52}, {-80, -52}}, color = {0, 0, 255}));
  connect(AliLoad.terminal, Ali109.terminal) annotation(
    Line(points = {{-47, -63}, {-38, -63}, {-38, -52}, {-32, -52}}, color = {0, 0, 255}));
  connect(AgricolaLoad.terminal, Agricola104.terminal) annotation(
    Line(points = {{-38, -78}, {-22, -78}, {-22, -72}, {-22, -72}}, color = {0, 0, 255}));
  connect(AikenLoad.terminal, Aiken105.terminal) annotation(
    Line(points = {{40, -80}, {30, -80}, {30, -68}, {26, -68}, {26, -68}}, color = {0, 0, 255}));
  connect(AdamsLoad.terminal, Adams102.terminal) annotation(
    Line(points = {{16, -90}, {12, -90}, {12, -88}, {4, -88}, {4, -88}}, color = {0, 0, 255}));
  connect(AllenLoad.terminal, Allen110.terminal) annotation(
    Line(points = {{58, -30}, {48, -30}, {48, -28}, {44, -28}, {44, -28}}, color = {0, 0, 255}));
  connect(AlgerLoad.terminal, Alger108.terminal) annotation(
    Line(points = {{111, -27}, {86, -27}, {86, -36}}, color = {0, 0, 255}));
  connect(AlderLoad.terminal, Alder107.terminal) annotation(
    Line(points = {{115, -69}, {96, -69}, {96, -64}}, color = {0, 0, 255}));
  connect(AlberLoad.terminal, Alber106.terminal) annotation(
    Line(points = {{-23, -31}, {-18, -31}, {-18, -32}, {-14, -32}}, color = {0, 0, 255}));

  // Switch off signals inhibitions for generators
  AttleeGen.switchOffSignal1.value = false;
  AttleeGen.switchOffSignal2.value = false;
  AttleeGen.switchOffSignal3.value = false;
  ArthurGen.switchOffSignal1.value = false;
  ArthurGen.switchOffSignal2.value = false;
  ArthurGen.switchOffSignal3.value = false;
  AstorGen.switchOffSignal1.value = false;
  AstorGen.switchOffSignal2.value = false;
  AstorGen.switchOffSignal3.value = false;
  AsserGen.switchOffSignal1.value = false;
  AsserGen.switchOffSignal2.value = false;
  AsserGen.switchOffSignal3.value = false;
  AustenGen.switchOffSignal1.value = false;
  AustenGen.switchOffSignal2.value = false;
  AustenGen.switchOffSignal3.value = false;
  ArneGen.switchOffSignal1.value = false;
  ArneGen.switchOffSignal2.value = false;
  ArneGen.switchOffSignal3.value = false;
  AlderGen.switchOffSignal1.value = false;
  AlderGen.switchOffSignal2.value = false;
  AlderGen.switchOffSignal3.value = false;
  AbelGen.switchOffSignal1.value = false;
  AbelGen.switchOffSignal2.value = false;
  AbelGen.switchOffSignal3.value = false;
  AdamsGen.switchOffSignal1.value = false;
  AdamsGen.switchOffSignal2.value = false;
  AdamsGen.switchOffSignal3.value = false;
  AubreyGen.switchOffSignal1.value = false;
  AubreyGen.switchOffSignal2.value = false;
  AubreyGen.switchOffSignal3.value = false;

  // Switch off signals inhibitions for loads
  AstorLoad.switchOffSignal1.value = false;
  AstorLoad.switchOffSignal2.value = false;
  AsserLoad.switchOffSignal1.value = false;
  AsserLoad.switchOffSignal2.value = false;
  AttilaLoad.switchOffSignal1.value = false;
  AttilaLoad.switchOffSignal2.value = false;
  AttarLoad.switchOffSignal1.value = false;
  AttarLoad.switchOffSignal2.value = false;
  ArnoldLoad.switchOffSignal1.value = false;
  ArnoldLoad.switchOffSignal2.value = false;
  ArthurLoad.switchOffSignal1.value = false;
  ArthurLoad.switchOffSignal2.value = false;
  ArneLoad.switchOffSignal1.value = false;
  ArneLoad.switchOffSignal2.value = false;
  AbelLoad.switchOffSignal1.value = false;
  AbelLoad.switchOffSignal2.value = false;
  AdlerLoad.switchOffSignal1.value = false;
  AdlerLoad.switchOffSignal2.value = false;
  AliLoad.switchOffSignal1.value = false;
  AliLoad.switchOffSignal2.value = false;
  AgricolaLoad.switchOffSignal1.value = false;
  AgricolaLoad.switchOffSignal2.value = false;
  AikenLoad.switchOffSignal1.value = false;
  AikenLoad.switchOffSignal2.value = false;
  AdamsLoad.switchOffSignal1.value = false;
  AdamsLoad.switchOffSignal2.value = false;
  AllenLoad.switchOffSignal1.value = false;
  AllenLoad.switchOffSignal2.value = false;
  AlgerLoad.switchOffSignal1.value = false;
  AlgerLoad.switchOffSignal2.value = false;
  AlderLoad.switchOffSignal1.value = false;
  AlderLoad.switchOffSignal2.value = false;
  AlberLoad.switchOffSignal1.value = false;
  AlberLoad.switchOffSignal2.value = false;

  // alpha, alphaSum and N default values for generators
  AttleeGen.N.value = 0;
  AttleeGen.alpha.value = 0;
  AttleeGen.alphaSum.value = 0;
  ArthurGen.N.value = 0;
  ArthurGen.alpha.value = 0;
  ArthurGen.alphaSum.value = 0;
  AstorGen.N.value = 0;
  AstorGen.alpha.value = 0;
  AstorGen.alphaSum.value = 0;
  AsserGen.N.value = 0;
  AsserGen.alpha.value = 0;
  AsserGen.alphaSum.value = 0;
  AustenGen.N.value = 0;
  AustenGen.alpha.value = 0;
  AustenGen.alphaSum.value = 0;
  ArneGen.N.value = 0;
  ArneGen.alpha.value = 0;
  ArneGen.alphaSum.value = 0;
  AlderGen.N.value = 0;
  AlderGen.alpha.value = 0;
  AlderGen.alphaSum.value = 0;
  AbelGen.N.value = 0;
  AbelGen.alpha.value = 0;
  AbelGen.alphaSum.value = 0;
  AdamsGen.N.value = 0;
  AdamsGen.alpha.value = 0;
  AdamsGen.alphaSum.value = 0;
  AubreyGen.N.value = 0;
  AubreyGen.alpha.value = 0;
  AubreyGen.alphaSum.value = 0;

  // PRef and QRef for loads
  der(AstorLoad.PRefPu.value) = 0;
  der(AstorLoad.QRefPu.value) = 0;
  der(AsserLoad.PRefPu.value) = 0;
  der(AsserLoad.QRefPu.value) = 0;
  der(AttilaLoad.PRefPu.value) = 0;
  der(AttilaLoad.QRefPu.value) = 0;
  der(AttarLoad.PRefPu.value) = 0;
  der(AttarLoad.QRefPu.value) = 0;
  der(ArnoldLoad.PRefPu.value) = 0;
  der(ArnoldLoad.QRefPu.value) = 0;
  der(ArthurLoad.PRefPu.value) = 0;
  der(ArthurLoad.QRefPu.value) = 0;
  der(ArneLoad.PRefPu.value) = 0;
  der(ArneLoad.QRefPu.value) = 0;
  der(AbelLoad.PRefPu.value) = 0;
  der(AbelLoad.QRefPu.value) = 0;
  der(AdlerLoad.PRefPu.value) = 0;
  der(AdlerLoad.QRefPu.value) = 0;
  der(AliLoad.PRefPu.value) = 0;
  der(AliLoad.QRefPu.value) = 0;
  der(AgricolaLoad.PRefPu.value) = 0;
  der(AgricolaLoad.QRefPu.value) = 0;
  der(AikenLoad.PRefPu.value) = 0;
  der(AikenLoad.QRefPu.value) = 0;
  der(AdamsLoad.PRefPu.value) = 0;
  der(AdamsLoad.QRefPu.value) = 0;
  der(AllenLoad.PRefPu.value) = 0;
  der(AllenLoad.QRefPu.value) = 0;
  der(AlgerLoad.PRefPu.value) = 0;
  der(AlgerLoad.QRefPu.value) = 0;
  der(AlderLoad.PRefPu.value) = 0;
  der(AlderLoad.QRefPu.value) = 0;
  der(AlberLoad.PRefPu.value) = 0;
  der(AlberLoad.QRefPu.value) = 0;
protected
end PowerFlow;
