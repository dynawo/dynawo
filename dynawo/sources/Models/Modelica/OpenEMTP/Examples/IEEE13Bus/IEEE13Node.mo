within OpenEMTP.Examples.IEEE13Bus;

model IEEE13Node
  multiPhaseCP L632T645(Rn = [542.451989624261, 145.865361318121; 145.865361318121, 548.853162207097],Ti = [0.709760014102212, 0.707283577128397; -0.703991675137205, 0.705943506643941], Zmod = {399.511525243263, 690.547840587223}, h = {0.999867342774239, 0.999895019677615}, m = 2, tau = {5.61073625900705e-07, 6.57914367465262e-07}) annotation(
    Placement(visible = true, transformation(origin = {-29, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  multiPhaseCP L645T646(Rn = [542.439495909326, 145.863405173944; 145.863405173944, 548.840529896013],Ti = [0.709760014102212, 0.707283577128397; -0.703991675137205, 0.705943506643941], Zmod = {399.500925625143, 690.533341800238}, h = {0.999920403552735, 0.999937010484037}, m = 2, tau = {3.36644175540423e-07, 3.94748620479157e-07}) annotation(
    Placement(visible = true, transformation(origin = {-97, 109}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  multiPhaseCP L632T671(Rn = [439.494555348606, 189.417652583489, 151.738234127060; 189.417652583489, 451.486500149972, 131.386875537053; 151.738234127060, 131.386875537053, 446.976772699649],Ti = [0.505189464539041, 0.783794931439085, -0.252229039493785; 0.564188272358512, -0.597545662954778, -0.555384509344831; 0.651256031484475, -0.169101218408001, 0.792115369033768], Zmod = {749.830100268342, 252.886635041062, 324.510622989785}, h = {0.999836741483589, 0.999860587191481, 0.999891520472283}, m = 3, tau = {2.51909782126786e-06, 2.08448710137279e-06, 2.07421383075992e-06}) annotation(
    Placement(visible = true, transformation(origin = {16, 52}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  multiPhaseCP L671T684(Rn = [548.840529896013, 145.863405173945; 145.863405173945, 542.439495909327],Ti = [0.705943506643940, -0.703991675137206; 0.707283577128397, 0.709760014102211], Zmod = {690.533341800238, 399.500925625143}, h = {0.999937010484037, 0.999920403552735}, m = 2, tau = {3.94748620479157e-07, 3.36644175540423e-07}) annotation(
    Placement(visible = true, transformation(origin = {-24, 12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  multiPhaseCP L684T652(Rn = [75.9315000540756],Ti = [1], Zmod = {75.9315000540756}, h = {0.998660571723622}, m = 1, tau = {2.71396421650751e-06}) annotation(
    Placement(visible = true, transformation(origin = {-51, -13}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  multiPhaseCP L684T611(Rn = [546.064341402152],Ti = [1], Zmod = {546.064341402152}, h = {0.999930847970415}, m = 1, tau = {3.71926621942778e-07}) annotation(
    Placement(visible = true, transformation(origin = {-73, 21}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  multiPhaseCP L692T675(Rn = [67.3932774272413, 2.75207691649893, 0.607790728896340; 2.75207691649891, 65.3922588083593, 2.75207691649900; 0.607790728896347, 2.75207691649900, 67.3932774272412],Ti = [0.572560468518626, -0.707106781186547, -0.414487460508261; 0.586393524678774, -1.08480673665415e-15, 0.810026317191903; 0.572560468518626, 0.707106781186548, -0.414487460508261], Zmod = {70.7665693762521, 66.7854866983449, 62.5758037340374}, h = {0.999056492311746, 0.999636088035267, 0.999651002096145}, m = 3, tau = {1.72234634931087e-06, 1.62512482204948e-06, 1.52309247336468e-06}) annotation(
    Placement(visible = true, transformation(origin = {71, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  multiPhaseCP L671T680(Rn = [439.478002087692, 189.410012418832, 151.730888271991; 189.410012418832, 451.470154267098, 131.379639450971; 151.730888271991, 131.379639450971, 446.961046784504],Ti = [0.505189464539041, 0.783794931439085, -0.252229039493785; 0.564188272358512, -0.597545662954778, -0.555384509344831; 0.651256031484475, -0.169101218408001, 0.792115369033768], Zmod = {749.799496230909, 252.877821132055, 324.501822300005}, h = {0.999918367409991, 0.999930291166164, 0.999945758765126}, m = 3, tau = {1.25954891063393e-06, 1.04224355068639e-06, 1.03710691537996e-06}) annotation(
    Placement(visible = true, transformation(origin = {-20, -125}, extent = {{-10, -10}, {10, 10}}, rotation = 270)));
  Modelica.Electrical.Analog.Basic.Resistor R646(R = 56.5993) annotation(
    Placement(visible = true, transformation(origin = {-139, 109}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor L646(L = 0.0862, i(start = 0)) annotation(
    Placement(visible = true, transformation(origin = {-164, 98}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Capacitor C611(C(displayUnit = "uF") = 4.5984e-5) annotation(
    Placement(visible = true, transformation(origin = {-118, -7}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor R611(R = 27.0597) annotation(
    Placement(visible = true, transformation(origin = {-141, 21}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Inductor L611(L = 0.0338) annotation(
    Placement(visible = true, transformation(origin = {-165, -7}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground2 annotation(
    Placement(visible = true, transformation(origin = {-118, -37}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor Ra652(R = 31.0501) annotation(
    Placement(visible = true, transformation(origin = {-51, -64}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor La652(L = 0.0553) annotation(
    Placement(visible = true, transformation(origin = {-50, -97}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground3 annotation(
    Placement(visible = true, transformation(origin = {-51, -123}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor Rc634(R = 0.4062) annotation(
    Placement(visible = true, transformation(origin = {179, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor Lc634(L = 0.8081) annotation(
    Placement(visible = true, transformation(origin = {177, 21}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground5 annotation(
    Placement(visible = true, transformation(origin = {178, -6}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor Lb634(L = 0.8508) annotation(
    Placement(visible = true, transformation(origin = {201, 21}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  PlugToPlug_bc plugToPlug_bc1 annotation(
    Placement(visible = true, transformation(origin = {-5, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  PlugToPlug_ac plugToPlug_ac1 annotation(
    Placement(visible = true, transformation(origin = {-7, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p1(k = 1, m = 2) annotation(
    Placement(visible = true, transformation(origin = {-118, 109}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p2(k = 2, m = 2) annotation(
    Placement(visible = true, transformation(origin = {-117, 89}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p3(k = 1, m = 1) annotation(
    Placement(visible = true, transformation(origin = {-105, 21}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p4(k = 1, m = 1) annotation(
    Placement(visible = true, transformation(origin = {-51, -38}, extent = {{10, -10}, {-10, 10}}, rotation = 90)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p5(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {161, 68}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p6(k = 2, m = 3) annotation(
    Placement(visible = true, transformation(origin = {157, 80}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Resistor Ra634(R = 0.3219) annotation(
    Placement(visible = true, transformation(origin = {231, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor La634(L = 0.5871) annotation(
    Placement(visible = true, transformation(origin = {230, 21}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p7(k = 1, m = 3) annotation(
    Placement(visible = true, transformation(origin = {161, 100}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Resistor R645(R = 23.4974) annotation(
    Placement(visible = true, transformation(origin = {-100, 59}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor L645(L = 0.0458, i(start = 0)) annotation(
    Placement(visible = true, transformation(origin = {-131, 59}, extent = {{-10, 10}, {10, -10}}, rotation = 180)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p8(k = 1, m = 2) annotation(
    Placement(visible = true, transformation(origin = {-81, 59}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground4 annotation(
    Placement(visible = true, transformation(origin = {-159, 48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor Rb634(R = 0.4277) annotation(
    Placement(visible = true, transformation(origin = {201, 46}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor Lc671D(L = 0.0503) annotation(
    Placement(visible = true, transformation(origin = {43, -31}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor Rc671D(R = 33.2151) annotation(
    Placement(visible = true, transformation(origin = {44, -3}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor Rc671Y(R = 70.5081) annotation(
    Placement(visible = true, transformation(origin = {61, -3}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor Lc671Y(L = 0.1087) annotation(
    Placement(visible = true, transformation(origin = {61, -31}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Ground ground6 annotation(
    Placement(visible = true, transformation(origin = {100, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p B671c(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {46, 16}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Resistor Rb671Y(R = 145.2651) annotation(
    Placement(visible = true, transformation(origin = {100, -3}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor Rb671D(R = 35.4759) annotation(
    Placement(visible = true, transformation(origin = {82, -2}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor Lb671D(L = 0.0538) annotation(
    Placement(visible = true, transformation(origin = {82, -31}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p B671b(k = 2, m = 3) annotation(
    Placement(visible = true, transformation(origin = {46, 31}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Resistor Ra671Y(R = 491.2436) annotation(
    Placement(visible = true, transformation(origin = {141, -3}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor La671Y(L = 0.7665) annotation(
    Placement(visible = true, transformation(origin = {141, -31}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor La671D(L = 0.0517) annotation(
    Placement(visible = true, transformation(origin = {123, -31}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor Ra671D(R = 34.1077) annotation(
    Placement(visible = true, transformation(origin = {124, -3}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor Lb671Y(L = 0.2219) annotation(
    Placement(visible = true, transformation(origin = {100, -31}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p B671a(k = 1, m = 3) annotation(
    Placement(visible = true, transformation(origin = {46, 51}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Capacitor Ca675(C(displayUnit = "uF") = 9.197e-5) annotation(
    Placement(visible = true, transformation(origin = {126, -118}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor Ra675(R = 9.9158) annotation(
    Placement(visible = true, transformation(origin = {103, -118}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor La675(L = 0.0103) annotation(
    Placement(visible = true, transformation(origin = {103, -146}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Capacitor Cb675(C(displayUnit = "uF") = 9.197e-5) annotation(
    Placement(visible = true, transformation(origin = {167, -118}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor Lb675(L = 0.1241) annotation(
    Placement(visible = true, transformation(origin = {144, -146}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor Rb675(R = 53.0187) annotation(
    Placement(visible = true, transformation(origin = {144, -118}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Capacitor Cc675(C(displayUnit = "uF") = 9.197e-5) annotation(
    Placement(visible = true, transformation(origin = {209, -118}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Resistor Rc675(R = 12.3484) annotation(
    Placement(visible = true, transformation(origin = {188, -118}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor Lc675(L = 0.0239) annotation(
    Placement(visible = true, transformation(origin = {188, -146}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p12(k = 1, m = 3) annotation(
    Placement(visible = true, transformation(origin = {106, -96}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p13(k = 2, m = 3) annotation(
    Placement(visible = true, transformation(origin = {146, -93}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p14(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {146, -66}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Ground ground7 annotation(
    Placement(visible = true, transformation(origin = {144, -174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R692(R = 56.3370) annotation(
    Placement(visible = true, transformation(origin = {10, -137}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.Analog.Basic.Inductor L692(L = 0.1327) annotation(
    Placement(visible = true, transformation(origin = {10, -165}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p15(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {21, -111}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Ground ground8 annotation(
    Placement(visible = true, transformation(origin = {10, -192}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor La632(L = 0.8201) annotation(
    Placement(visible = true, transformation(origin = {140, 167}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor Ra632(R = 525.5902) annotation(
    Placement(visible = true, transformation(origin = {109, 167}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor Rb632(R = 142.5436) annotation(
    Placement(visible = true, transformation(origin = {107, 147}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor Lb632(L = 0.2177) annotation(
    Placement(visible = true, transformation(origin = {140, 146}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground9 annotation(
    Placement(visible = true, transformation(origin = {182, 136}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Inductor Lc632(L = 0.1176) annotation(
    Placement(visible = true, transformation(origin = {140, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor Rc632(R = 76.2968) annotation(
    Placement(visible = true, transformation(origin = {107, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p17(k = 3, m = 3) annotation(
    Placement(visible = true, transformation(origin = {70, 125}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p18(k = 2, m = 3) annotation(
    Placement(visible = true, transformation(origin = {64, 147}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.MultiPhase.Basic.PlugToPin_p plugToPin_p19(k = 1, m = 3) annotation(
    Placement(visible = true, transformation(origin = {68, 167}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
  Modelica.Electrical.Analog.Basic.Ground ground10 annotation(
    Placement(visible = true, transformation(origin = {-164, -36}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  PlugToPlug_c plugToPlug_c1 annotation(
    Placement(visible = true, transformation(origin = {-44, 21}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  PlugToPlug_a plugToPlug_a1 annotation(
    Placement(visible = true, transformation(origin = {-44, 12}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  OpenEMTP.Examples.IEEE13Bus.MultiphaseBreaker multiphaseBreaker1(Topening = {1, 1, 1}, Tclosing = {0, 0, 0}) annotation(
    Placement(visible = true, transformation(origin = {-70, 174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  MultiphaseBreaker multiphaseBreaker2(Tclosing = {-1, -1, -1}, Topening = {0.15, 0.15, 0.15}) annotation(
    Placement(visible = true, transformation(origin = {44, -96}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  IdealBreaker idealBreaker1(Tclosing = 0.05, Topening = 0.2) annotation(
    Placement(visible = true, transformation(origin = {72, -138}, extent = {{15, -15}, {-15, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Ground ground11 annotation(
    Placement(visible = true, transformation(origin = {47, -214}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Electrical.Analog.Basic.Resistor R_fault(R = 1) annotation(
    Placement(visible = true, transformation(origin = {47, -156}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  IEEE13Bus.multiPhaseCP L632T633(Rn = [500.899978602455, 150.206053315871, 195.525386792645; 150.206053315870, 487.419169178533, 126.741349824221; 195.525386792645, 126.741349824221, 511.004208230992],Ti = [0.502659687516342, 0.778867301097029, -0.249833119452532; 0.644850930369252, -0.176951289724402, 0.792006771920747; 0.533578236163045, -0.600564731133732, -0.550352955472635], Zmod = {764.208172889510, 306.049535031007, 375.624232491133}, h = {0.999937767140510, 0.999908521997646, 0.999925925353872}, m = 3, tau = {6.41053351781503e-07, 5.63676955383253e-07, 5.53093403094522e-07}) annotation(
    Placement(visible = true, transformation(origin = {62, 80}, extent = {{-15, -11}, {15, 11}}, rotation = 0)));
  IEEE13Bus.MultiphaseBreaker BR2(Tclosing = {0.25, 0.25, 0.25}, Topening = {1, 1, 1})  annotation(
    Placement(visible = true, transformation(origin = {45, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  YgYg ygYg annotation(
    Placement(visible = true, transformation(extent = {{101, 70}, {121, 90}}, rotation = 0)));
  OpenEMTP.Electrical.Sources.YCosineVoltage ac(Phase = {-0.043458698374659, -2.124414765527499, 2.056521457624899}, Vm = {1.021, 1.042, 1.0174} * 4.16)  annotation(
    Placement(visible = true, transformation(origin = {-136, 174}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(plugToPin_p15.plug_p, multiphaseBreaker2.negativePlug1) annotation(
    Line(points = {{23, -111}, {53, -111}, {53, -95.8}, {53.2, -95.8}}, color = {0, 0, 255}));
  connect(idealBreaker1.pin_n, R_fault.p) annotation(
    Line(points = {{58.6, -138}, {47, -138}, {47, -146}}, color = {0, 0, 255}));
  connect(idealBreaker1.pin_p, plugToPin_p12.pin_p) annotation(
    Line(points = {{85.6, -138}, {108, -138}, {108, -96}}, color = {0, 0, 255}));
  connect(multiphaseBreaker2.positivePlug1, L632T671.rP) annotation(
    Line(points = {{34.2, -96}, {16, -96}, {16, 46.1333}}, color = {0, 0, 255}));
  connect(L671T680.sP, multiphaseBreaker2.positivePlug1) annotation(
    Line(points = {{-20, -118.867}, {-20, -118.867}, {-20, -96}, {34.2, -96}}, color = {0, 0, 255}));
  connect(multiphaseBreaker2.negativePlug1, L692T675.sP) annotation(
    Line(points = {{53.2, -95.8}, {61, -95.8}, {61, -96}, {64.8667, -96}}, color = {0, 0, 255}));
  connect(plugToPin_p12.plug_p, L692T675.rP) annotation(
    Line(points = {{104, -96}, {76.8667, -96}}, color = {0, 0, 255}));
  connect(multiphaseBreaker1.negativePlug1, L632T671.sP) annotation(
    Line(points = {{-61, 174}, {16, 174}, {16, 58.1333}}, color = {0, 0, 255}));
  connect(multiphaseBreaker1.negativePlug1, plugToPin_p18.plug_p) annotation(
    Line(points = {{-61, 174}, {16.2, 174}, {16.2, 147}, {62, 147}}, color = {0, 0, 255}));
  connect(plugToPin_p3.pin_p, C611.p) annotation(
    Line(points = {{-107, 21}, {-118, 21}, {-118, 3}}, color = {0, 0, 255}));
  connect(C611.n, ground2.p) annotation(
    Line(points = {{-118, -17}, {-118, -27}}, color = {0, 0, 255}));
  connect(R611.n, L611.p) annotation(
    Line(points = {{-151, 21}, {-165, 21}, {-165, 3}}, color = {0, 0, 255}));
  connect(L611.n, ground10.p) annotation(
    Line(points = {{-165, -17}, {-165, -22}, {-165, -26}, {-164, -26}}, color = {0, 0, 255}));
  connect(L645T646.sP, L632T645.rP) annotation(
    Line(points = {{-90.8667, 109}, {-60, 109}, {-60, 80}, {-34.8667, 80}, {-34.8667, 80}}, color = {0, 0, 255}));
  connect(plugToPin_p8.plug_p, L632T645.rP) annotation(
    Line(points = {{-79, 59}, {-60, 59}, {-60, 80}, {-34.8667, 80}, {-34.8667, 80}}, color = {0, 0, 255}));
  connect(L645.n, ground4.p) annotation(
    Line(points = {{-141, 59}, {-159, 59}, {-159, 58}, {-159, 58}}, color = {0, 0, 255}));
  connect(L645.p, R645.n) annotation(
    Line(points = {{-121, 59}, {-111, 59}, {-111, 59}, {-110, 59}}, color = {0, 0, 255}));
  connect(R645.p, plugToPin_p8.pin_p) annotation(
    Line(points = {{-90, 59}, {-84, 59}, {-84, 59}, {-83, 59}}, color = {0, 0, 255}));
  connect(plugToPin_p2.plug_p, L645T646.rP) annotation(
    Line(points = {{-115, 89}, {-106, 89}, {-106, 109}, {-102.867, 109}}, color = {0, 0, 255}));
  connect(L645T646.rP, plugToPin_p1.plug_p) annotation(
    Line(points = {{-102.867, 109}, {-116, 109}}, color = {0, 0, 255}));
  connect(plugToPin_p1.pin_p, R646.p) annotation(
    Line(points = {{-120, 109}, {-129, 109}}, color = {0, 0, 255}));
  connect(R646.n, L646.p) annotation(
    Line(points = {{-149, 109}, {-163, 109}, {-163, 108}, {-164, 108}}, color = {0, 0, 255}));
  connect(L646.n, plugToPin_p2.pin_p) annotation(
    Line(points = {{-164, 88}, {-119, 88}, {-119, 89}, {-119, 89}}, color = {0, 0, 255}));
  connect(plugToPlug_bc1.positivePlugIn, L632T671.sP) annotation(
    Line(points = {{-2, 80}, {16, 80}, {16, 58.1333}, {16, 58.1333}}, color = {0, 0, 255}));
  connect(plugToPin_p6.pin_p, Rb634.p) annotation(
    Line(points = {{159, 80}, {201, 80}, {201, 56}}, color = {0, 0, 255}));
  connect(plugToPin_p7.plug_p, plugToPin_p6.plug_p) annotation(
    Line(points = {{159, 100}, {155, 100}, {155, 80}}, color = {0, 0, 255}));
  connect(plugToPin_p5.plug_p, plugToPin_p6.plug_p) annotation(
    Line(points = {{159, 68}, {154, 68}, {154, 80}, {155, 80}}, color = {0, 0, 255}));
  connect(plugToPin_p5.pin_p, Rc634.p) annotation(
    Line(points = {{163, 68}, {179, 68}, {179, 56}}, color = {0, 0, 255}));
  connect(plugToPlug_bc1.positivePlugOut, L632T645.sP) annotation(
    Line(points = {{-8, 80}, {-22.8667, 80}}, color = {0, 0, 255}));
  connect(Lb634.n, Lc634.n) annotation(
    Line(points = {{201, 11}, {177, 11}, {177, 11}, {177, 11}, {177, 11}, {177, 11}}, color = {0, 0, 255}));
  connect(Lb634.n, La634.n) annotation(
    Line(points = {{201, 11}, {230, 11}}, color = {0, 0, 255}));
  connect(Rb634.n, Lb634.p) annotation(
    Line(points = {{201, 36}, {201, 36}, {201, 31}, {201, 31}}, color = {0, 0, 255}));
  connect(Ra634.n, La634.p) annotation(
    Line(points = {{231, 36}, {231, 33.5}, {230, 33.5}, {230, 31}}, color = {0, 0, 255}));
  connect(plugToPin_p7.pin_p, Ra634.p) annotation(
    Line(points = {{163, 100}, {231, 100}, {231, 56}}, color = {0, 0, 255}));
  connect(Cc675.n, Lc675.n) annotation(
    Line(points = {{209, -128}, {210, -128}, {210, -164}, {188, -164}, {188, -156}}, color = {0, 0, 255}));
  connect(Rc675.p, Cc675.p) annotation(
    Line(points = {{188, -108}, {209, -108}, {209, -108}, {209, -108}}, color = {0, 0, 255}));
  connect(plugToPin_p14.pin_p, Cc675.p) annotation(
    Line(points = {{148, -66}, {209, -66}, {209, -108}}, color = {0, 0, 255}));
  connect(Rc675.n, Lc675.p) annotation(
    Line(points = {{188, -128}, {188, -128}, {188, -136}, {188, -136}}, color = {0, 0, 255}));
  connect(Lc675.n, ground7.p) annotation(
    Line(points = {{188, -156}, {188, -164}, {144, -164}}, color = {0, 0, 255}));
  connect(B671c.plug_p, L632T671.rP) annotation(
    Line(points = {{44, 16}, {16, 16}, {16, 46.1333}}, color = {0, 0, 255}));
  connect(plugToPlug_ac1.positivePlugIn, L632T671.rP) annotation(
    Line(points = {{-4, 12}, {16, 12}, {16, 46.1333}, {16, 46.1333}}, color = {0, 0, 255}));
  connect(L671T684.rP, plugToPlug_ac1.positivePlugOut) annotation(
    Line(points = {{-18.1333, 12}, {-10.1335, 12}, {-10.1335, 12}, {-10, 12}}, color = {0, 0, 255}));
  connect(L671T684.sP, plugToPlug_a1.positivePlugIn) annotation(
    Line(points = {{-30.1333, 12}, {-40.1333, 12}, {-40.1333, 12}, {-41, 12}}, color = {0, 0, 255}));
  connect(plugToPin_p4.plug_p, L684T652.rP) annotation(
    Line(points = {{-51, -36}, {-51, -36}, {-51, -18.8667}, {-51, -18.8667}}, color = {0, 0, 255}));
  connect(plugToPlug_a1.positivePlugOut, L684T652.sP) annotation(
    Line(points = {{-47, 12}, {-51, 12}, {-51, -6.86667}}, color = {0, 0, 255}));
  connect(plugToPin_p4.pin_p, Ra652.p) annotation(
    Line(points = {{-51, -40}, {-51, -40}, {-51, -54}, {-51, -54}}, color = {0, 0, 255}));
  connect(Ra652.n, La652.p) annotation(
    Line(points = {{-51, -74}, {-51, -80.5}, {-50, -80.5}, {-50, -87}}, color = {0, 0, 255}));
  connect(La652.n, ground3.p) annotation(
    Line(points = {{-50, -107}, {-50, -110}, {-51, -110}, {-51, -113}}, color = {0, 0, 255}));
  connect(Rc634.n, Lc634.p) annotation(
    Line(points = {{179, 36}, {179, 33.5}, {177, 33.5}, {177, 31}}, color = {0, 0, 255}));
  connect(Lc634.n, ground5.p) annotation(
    Line(points = {{177, 11}, {177, 13}, {178, 13}, {178, 4}}, color = {0, 0, 255}));
  connect(Lc671D.n, Lc671Y.n) annotation(
    Line(points = {{43, -41}, {61, -41}, {61, -41}, {61, -41}}, color = {0, 0, 255}));
  connect(Rc671D.n, Lc671D.p) annotation(
    Line(points = {{44, -13}, {44, -17}, {43, -17}, {43, -21}}, color = {0, 0, 255}));
  connect(Rc671D.p, Rc671Y.p) annotation(
    Line(points = {{44, 7}, {61, 7}}, color = {0, 0, 255}));
  connect(Rc671Y.n, Lc671Y.p) annotation(
    Line(points = {{61, -13}, {61, -21}}, color = {0, 0, 255}));
  connect(B671c.pin_p, Rc671Y.p) annotation(
    Line(points = {{48, 16}, {61, 16}, {61, 7}}, color = {0, 0, 255}));
  connect(ground6.p, Lc671Y.n) annotation(
    Line(points = {{100, -50}, {61, -50}, {61, -41}}, color = {0, 0, 255}));
  connect(Lb671Y.n, ground6.p) annotation(
    Line(points = {{100, -41}, {100, -41}, {100, -50}, {100, -50}}, color = {0, 0, 255}));
  connect(La671D.n, ground6.p) annotation(
    Line(points = {{123, -41}, {122, -41}, {122, -50}, {100, -50}, {100, -50}}, color = {0, 0, 255}));
  connect(B671b.plug_p, B671c.plug_p) annotation(
    Line(points = {{44, 31}, {39, 31}, {39, 16}, {44, 16}}, color = {0, 0, 255}));
  connect(Rb671D.p, Rb671Y.p) annotation(
    Line(points = {{82, 8}, {100, 8}, {100, 7}}, color = {0, 0, 255}));
  connect(B671b.pin_p, Rb671Y.p) annotation(
    Line(points = {{48, 31}, {100, 31}, {100, 7}}, color = {0, 0, 255}));
  connect(Rb671Y.n, Lb671Y.p) annotation(
    Line(points = {{100, -13}, {100, -13}, {100, -21}, {100, -21}}, color = {0, 0, 255}));
  connect(Rb671D.n, Lb671D.p) annotation(
    Line(points = {{82, -12}, {82, -21}}, color = {0, 0, 255}));
  connect(Lb671Y.n, Lb671D.n) annotation(
    Line(points = {{100, -41}, {82, -41}, {82, -41}, {82, -41}}, color = {0, 0, 255}));
  connect(B671a.pin_p, Ra671Y.p) annotation(
    Line(points = {{48, 51}, {141, 51}, {141, 7}}, color = {0, 0, 255}));
  connect(Ra671Y.n, La671Y.p) annotation(
    Line(points = {{141, -13}, {141, -13}, {141, -21}, {141, -21}}, color = {0, 0, 255}));
  connect(Ra671D.p, Ra671Y.p) annotation(
    Line(points = {{124, 7}, {141, 7}}, color = {0, 0, 255}));
  connect(La671D.n, La671Y.n) annotation(
    Line(points = {{123, -41}, {141, -41}, {141, -41}, {141, -41}}, color = {0, 0, 255}));
  connect(Ra671D.n, La671D.p) annotation(
    Line(points = {{124, -13}, {124, -17}, {123, -17}, {123, -21}}, color = {0, 0, 255}));
  connect(plugToPin_p12.pin_p, Ca675.p) annotation(
    Line(points = {{108, -96}, {126, -96}, {126, -108}}, color = {0, 0, 255}));
  connect(Ca675.n, La675.n) annotation(
    Line(points = {{126, -128}, {126, -157}, {103, -157}, {103, -156}}, color = {0, 0, 255}));
  connect(Ra675.p, Ca675.p) annotation(
    Line(points = {{103, -108}, {126, -108}}, color = {0, 0, 255}));
  connect(Ra675.n, La675.p) annotation(
    Line(points = {{103, -128}, {103, -128}, {103, -136}, {103, -136}}, color = {0, 0, 255}));
  connect(La675.n, ground7.p) annotation(
    Line(points = {{103, -156}, {103, -156}, {103, -164}, {144, -164}, {144, -164}}, color = {0, 0, 255}));
  connect(Cb675.n, Lb675.n) annotation(
    Line(points = {{167, -128}, {166, -128}, {166, -156}, {144, -156}}, color = {0, 0, 255}));
  connect(plugToPin_p13.pin_p, Cb675.p) annotation(
    Line(points = {{148, -93}, {166, -93}, {166, -108}, {167, -108}}, color = {0, 0, 255}));
  connect(Rb675.p, Cb675.p) annotation(
    Line(points = {{144, -108}, {167, -108}}, color = {0, 0, 255}));
  connect(Rb675.n, Lb675.p) annotation(
    Line(points = {{144, -128}, {144, -128}, {144, -136}, {144, -136}}, color = {0, 0, 255}));
  connect(Lb675.n, ground7.p) annotation(
    Line(points = {{144, -156}, {144, -156}, {144, -164}, {144, -164}}, color = {0, 0, 255}));
  connect(plugToPin_p13.plug_p, plugToPin_p12.plug_p) annotation(
    Line(points = {{144, -93}, {103, -93}, {103, -96}, {104, -96}, {104, -96}}, color = {0, 0, 255}));
  connect(plugToPin_p14.plug_p, plugToPin_p13.plug_p) annotation(
    Line(points = {{144, -66}, {144, -93}}, color = {0, 0, 255}));
  connect(R692.n, L692.p) annotation(
    Line(points = {{10, -147}, {10, -147}, {10, -156}, {10, -155}}, color = {0, 0, 255}));
  connect(plugToPin_p15.pin_p, R692.p) annotation(
    Line(points = {{19, -111}, {10, -111}, {10, -127}}, color = {0, 0, 255}));
  connect(L692.n, ground8.p) annotation(
    Line(points = {{10, -175}, {10, -182}}, color = {0, 0, 255}));
  connect(La632.n, Lb632.n) annotation(
    Line(points = {{150, 167}, {160, 167}, {160, 146}, {150, 146}, {150, 146}}, color = {0, 0, 255}));
  connect(Ra632.n, La632.p) annotation(
    Line(points = {{119, 167}, {130, 167}}, color = {0, 0, 255}));
  connect(plugToPin_p19.pin_p, Ra632.p) annotation(
    Line(points = {{70, 167}, {99, 167}}, color = {0, 0, 255}));
  connect(Rb632.n, Lb632.p) annotation(
    Line(points = {{117, 147}, {130, 147}, {130, 146}, {130, 146}}, color = {0, 0, 255}));
  connect(plugToPin_p18.pin_p, Rb632.p) annotation(
    Line(points = {{66, 147}, {97, 147}, {97, 147}, {97, 147}}, color = {0, 0, 255}));
  connect(Lc632.n, Lb632.n) annotation(
    Line(points = {{150, 126}, {160, 126}, {160, 146}, {150, 146}, {150, 146}}, color = {0, 0, 255}));
  connect(ground9.p, Lb632.n) annotation(
    Line(points = {{182, 146}, {150, 146}, {150, 146}}, color = {0, 0, 255}));
  connect(Rc632.n, Lc632.p) annotation(
    Line(points = {{117, 126}, {130, 126}}, color = {0, 0, 255}));
  connect(plugToPin_p17.pin_p, Rc632.p) annotation(
    Line(points = {{72, 125}, {97, 125}, {97, 126}, {97, 126}}, color = {0, 0, 255}));
  connect(plugToPin_p17.plug_p, plugToPin_p18.plug_p) annotation(
    Line(points = {{68, 125}, {62, 125}, {62, 147}, {62, 147}}, color = {0, 0, 255}));
  connect(plugToPin_p19.plug_p, plugToPin_p18.plug_p) annotation(
    Line(points = {{66, 167}, {62, 167}, {62, 147}, {62, 147}}, color = {0, 0, 255}));
  connect(L684T611.rP, plugToPlug_c1.positivePlugOut) annotation(
    Line(points = {{-67.1333, 21}, {-47.1333, 21}, {-47.1333, 21}, {-47, 21}}, color = {0, 0, 255}));
  connect(plugToPlug_c1.positivePlugIn, plugToPlug_a1.positivePlugIn) annotation(
    Line(points = {{-41, 21}, {-36, 21}, {-36, 12}, {-41, 12}, {-41, 12}}, color = {0, 0, 255}));
  connect(L684T611.sP, plugToPin_p3.plug_p) annotation(
    Line(points = {{-79.1333, 21}, {-103.133, 21}, {-103.133, 21}, {-103, 21}}, color = {0, 0, 255}));
  connect(R611.p, plugToPin_p3.pin_p) annotation(
    Line(points = {{-131, 21}, {-107, 21}, {-107, 21}, {-107, 21}}, color = {0, 0, 255}));
  connect(B671a.plug_p, L632T671.rP) annotation(
    Line(points = {{44, 51}, {39, 51}, {39, 16}, {16, 16}, {16, 46.1333}}, color = {0, 0, 255}));
  connect(R_fault.n, ground11.p) annotation(
    Line(points = {{47, -166}, {48, -166}, {48, -204}, {47, -204}}, color = {0, 0, 255}));
  connect(L632T633.sP, plugToPlug_bc1.positivePlugIn) annotation(
    Line(points = {{53, 80}, {-1, 80}, {-1, 80}, {-2, 80}}, color = {0, 0, 255}));
  connect(BR2.positivePlug1, multiphaseBreaker2.positivePlug1) annotation(
    Line(points = {{35, -80}, {28, -80}, {28, -96}, {34, -96}, {34, -96}}, color = {0, 0, 255}));
  connect(BR2.negativePlug1, multiphaseBreaker2.negativePlug1) annotation(
    Line(points = {{54, -80}, {60, -80}, {60, -96}, {53, -96}, {53, -96}}, color = {0, 0, 255}));
  connect(ygYg.Pk, L632T633.rP) annotation(
    Line(points = {{104, 80}, {71, 80}, {71, 80}, {71, 80}}, color = {0, 0, 255}));
  connect(ygYg.Pm, plugToPin_p6.plug_p) annotation(
    Line(points = {{119, 80}, {155, 80}, {155, 80}}, color = {0, 0, 255}));
  connect(multiphaseBreaker1.positivePlug1, ac.Pk) annotation(
    Line(points = {{-81, 174}, {-126, 174}}, color = {0, 0, 255}));
  annotation(
    Diagram(coordinateSystem(initialScale = 0, grid = {1, 1}, extent = {{-240, -220}, {260, 200}})),
    Icon(coordinateSystem(initialScale = 0, grid = {1, 1}, extent = {{-240, -220}, {260, 200}})),
    version = "",
    uses(Modelica(version = "3.2.2")),
    __OpenModelica_commandLineOptions = "--matchingAlgorithm=PFPlusExt --indexReductionMethod=dynamicStateSelection -d=initialization,NLSanalyticJacobian",
    __OpenModelica_simulationFlags(lv = "LOG_STATS", s = "ida", cpu = "()", initialStepSize = "2e-07", maxIntegrationOrder = "2", maxStepSize = "2e-07", noEquidistantTimeGrid = "()", noEventEmit = "()"),
    experiment(StopTime = 0.3, Interval = 2e-07, Tolerance = 0.0001, StartTime = 0));
end IEEE13Node;
