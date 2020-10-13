within OpenEMTP.Examples.IEEE39Bus;

package IEEE39BusCaseSM_CP
  model IEEE39Bus
    OpenEMTP.Connectors.Bus B25 annotation(
      Placement(visible = true, transformation(origin = {-440, 336}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B24 annotation(
      Placement(visible = true, transformation(origin = {492, 160}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B23 annotation(
      Placement(visible = true, transformation(origin = {492, -144}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B22 annotation(
      Placement(visible = true, transformation(origin = {492, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B21 annotation(
      Placement(visible = true, transformation(origin = {360, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B20 annotation(
      Placement(visible = true, transformation(origin = {260, -300}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B02 annotation(
      Placement(visible = true, transformation(origin = {-440, 106}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B01 annotation(
      Placement(visible = true, transformation(origin = {-440, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B39 annotation(
      Placement(visible = true, transformation(origin = {-440, -114}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B09 annotation(
      Placement(visible = true, transformation(origin = {-440, -586}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B26 annotation(
      Placement(visible = true, transformation(origin = {0, 336}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B03 annotation(
      Placement(visible = true, transformation(origin = {-240, -32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B04 annotation(
      Placement(visible = true, transformation(origin = {-240, -114}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B05 annotation(
      Placement(visible = true, transformation(origin = {-240, -192}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B08 annotation(
      Placement(visible = true, transformation(origin = {-170, -510}, extent = {{-14, -14}, {14, 14}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B27 annotation(
      Placement(visible = true, transformation(origin = {0, 230}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B17 annotation(
      Placement(visible = true, transformation(origin = {0, 146}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B18 annotation(
      Placement(visible = true, transformation(origin = {-128, 104}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B06 annotation(
      Placement(visible = true, transformation(origin = {-170, -282}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B07 annotation(
      Placement(visible = true, transformation(origin = {-170, -386}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B28 annotation(
      Placement(visible = true, transformation(origin = {244, 336}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B29 annotation(
      Placement(visible = true, transformation(origin = {424, 334}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B16 annotation(
      Placement(visible = true, transformation(origin = {160, 52}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B14 annotation(
      Placement(visible = true, transformation(origin = {160, -114}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B13 annotation(
      Placement(visible = true, transformation(origin = {160, -388}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B10 annotation(
      Placement(visible = true, transformation(origin = {70, -522}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B11 annotation(
      Placement(visible = true, transformation(origin = {-20, -388}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B15 annotation(
      Placement(visible = true, transformation(origin = {160, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B12 annotation(
      Placement(visible = true, transformation(origin = {69, -280}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_08 powerPlant_08 annotation(
      Placement(visible = true, transformation(extent = {{-450, 354}, {-430, 374}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_10 powerPlant_10 annotation(
      Placement(visible = true, transformation(origin = {-484, 128}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_01 powerPlant_01 annotation(
      Placement(visible = true, transformation(origin = {-526, -146}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_02 powerPlant_02 annotation(
      Placement(visible = true, transformation(extent = {{-110, -314}, {-90, -294}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_09 powerPlant_09 annotation(
      Placement(visible = true, transformation(extent = {{444, 312}, {464, 332}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_03 powerPlant_03 annotation(
      Placement(visible = true, transformation(extent = {{60, -554}, {80, -534}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_04 powerPlant_04 annotation(
      Placement(visible = true, transformation(extent = {{314, -148}, {334, -128}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_05 powerPlant_05 annotation(
      Placement(visible = true, transformation(extent = {{250, -334}, {270, -314}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_06 powerPlant_06 annotation(
      Placement(visible = true, transformation(origin = {492, 14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PowerPlant_07 powerPlant_07 annotation(
      Placement(visible = true, transformation(origin = {492, -162}, extent = {{10, 10}, {-10, -10}}, rotation = 180)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load25 load25 annotation(
      Placement(visible = true, transformation(extent = {{-498, 314}, {-478, 334}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load39 load39 annotation(
      Placement(visible = true, transformation(extent = {{-496, -150}, {-476, -130}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load08 load08 annotation(
      Placement(visible = true, transformation(extent = {{-116, -552}, {-96, -532}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load03 load03 annotation(
      Placement(visible = true, transformation(extent = {{-310, -50}, {-290, -30}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load04 load04 annotation(
      Placement(visible = true, transformation(extent = {{-190, -142}, {-170, -122}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load26 load26 annotation(
      Placement(visible = true, transformation(extent = {{42, 306}, {62, 326}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load27 load27 annotation(
      Placement(visible = true, transformation(extent = {{42, 194}, {62, 214}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load18 load18 annotation(
      Placement(visible = true, transformation(extent = {{-98, 68}, {-78, 88}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load07 load07 annotation(
      Placement(visible = true, transformation(extent = {{-118, -430}, {-98, -410}}, rotation = 0)));
    OpenEMTP.Electrical.Load_Models.PQ_Load load12(P = 7.5 / 3 * {1, 1, 1}, Q = 88 / 3 * {1, 1, 1}, V = 25) annotation(
      Placement(visible = true, transformation(extent = {{52, -248}, {72, -268}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load29 load29 annotation(
      Placement(visible = true, transformation(extent = {{414, 288}, {434, 308}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load28 load28 annotation(
      Placement(visible = true, transformation(extent = {{234, 286}, {254, 306}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load15 load15 annotation(
      Placement(visible = true, transformation(extent = {{190, -64}, {210, -44}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load16 load16 annotation(
      Placement(visible = true, transformation(extent = {{190, 30}, {210, 50}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load20 load20 annotation(
      Placement(visible = true, transformation(extent = {{296, -332}, {316, -312}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load21 load21 annotation(
      Placement(visible = true, transformation(extent = {{350, -78}, {370, -58}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load23 load23 annotation(
      Placement(visible = true, transformation(extent = {{512, -170}, {532, -150}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Load24 load24 annotation(
      Placement(visible = true, transformation(extent = {{444, 140}, {464, 160}}, rotation = 0)));
    OpenEMTP.Electrical.Transformers.YgD01 xfo12_13(S = 200, f = 60, v1 = 347.07, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(visible = true, transformation(origin = {100, -326}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    OpenEMTP.Electrical.Transformers.YgD01 xfo12_11(S = 200, f = 60, v1 = 347.07, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(visible = true, transformation(origin = {40, -326}, extent = {{-10, -10}, {10, 10}}, rotation = 90)));
    OpenEMTP.Electrical.Transformers.YgYgD xfo19_20(S = {1400, 1400, 1400}, f = 60, v = {365.7, 300, 12.5}, R = {0.00222, 0.0058, 0.00584}, X = {0.193, 0.292, 0.1}, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 2500) annotation(
      Placement(visible = true, transformation(origin = {280, -240}, extent = {{-10, 10}, {10, -10}}, rotation = -90)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.C ShuntCap(C = 2.0503e-6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {424, 152}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Connectors.Bus B19 annotation(
      Placement(visible = true, transformation(origin = {280, -116}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Electrical.Switches.IdealSwitch SW(Tclosing(displayUnit = "ms") = 0.1, Topening(displayUnit = "ms") = 0.3) annotation(
      Placement(visible = true, transformation(extent = {{14, -50}, {34, -30}}, rotation = 0)));
    Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {424, 126}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.Earth earth annotation(
      Placement(visible = true, transformation(extent = {{300, -286}, {320, -266}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.BRk Brk annotation(
      Placement(visible = true, transformation(origin = {80, -30}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.BRm Brm annotation(
      Placement(visible = true, transformation(origin = {80, -88}, extent = {{-4, -4}, {4, 4}}, rotation = 0)));
    OpenEMTP.Connectors.Plug_a Plug_a annotation(
      Placement(visible = true, transformation(extent = {{-10, -50}, {10, -30}}, rotation = 0)));
    OpenEMTP.Connectors.Plug_b Plug_b annotation(
      Placement(visible = true, transformation(origin = {52, -40}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Lines.CPmodel.TLM L02_25(Zc = {6.36011E+02, 2.86311E+02, 2.86311E+02}, d = 28200, m = 3, r = {4.25403E-01, 3.86061E-02, 3.86061E-02}, tau = {1.30200E-04, 9.62308E-05, 9.62308E-05}) annotation(
      Placement(visible = true, transformation(origin = {-440, 258}, extent = {{-15, -11}, {15, 11}}, rotation = -90)));
    Electrical.Lines.CPmodel.TLM L01_02(m = 3, Zc = {6.36011E+02, 2.86311E+02, 2.86311E+02}, r = {4.25403E-01, 3.86061E-02, 3.86061E-02}, d = 134800, tau = {6.22374E-04, 4.59997E-04, 4.59997E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-440, 44})));
    Electrical.Lines.CPmodel.TLM L01_39(m = 3, Zc = {4.86802E+02, 2.66721E+02, 2.66721E+02}, r = {2.56453E+00, 2.89056E-02, 2.89056E-02}, d = 109000, tau = {3.99715E-04, 3.66159E-04, 3.66159E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-440, -68})));
    Electrical.Lines.CPmodel.TLM L09_39(m = 3, Zc = {4.14556E+02, 1.49141E+02, 1.49141E+02}, r = {1.03735E-01, 9.82897E-03, 9.82897E-03}, d = 137800, tau = {5.65351E-04, 4.69502E-04, 4.69502E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-440, -282})));
    Electrical.Lines.CPmodel.TLM L25_26(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 102400, tau = {4.01059E-04, 3.45375E-04, 3.45375E-04}) annotation(
      Placement(transformation(extent = {{-259, 309}, {-229, 331}})));
    Electrical.Lines.CPmodel.TLM L02_03(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 49600, tau = {1.94263E-04, 1.67291E-04, 1.67291E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-240, 42})));
    Electrical.Lines.CPmodel.TLM L03_04(m = 3, Zc = {5.98773E+02, 3.84714E+02, 3.84714E+02}, r = {1.46239E-01, 4.77688E-02, 4.77688E-02}, d = 54600, tau = {1.98587E-04, 1.82687E-04, 1.82687E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-240, -68})));
    Electrical.Lines.CPmodel.TLM L04_05(m = 3, Zc = {5.98773E+02, 3.84714E+02, 3.84714E+02}, r = {1.46239E-01, 4.77688E-02, 4.77688E-02}, d = 33000, tau = {1.20025E-04, 1.10415E-04, 1.10415E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-240, -156})));
    Electrical.Lines.CPmodel.TLM L05_08(m = 3, Zc = {5.98773E+02, 3.84714E+02, 3.84714E+02}, r = {1.46239E-01, 4.77688E-02, 4.77688E-02}, d = 32400, tau = {1.17843E-04, 1.08407E-04, 1.08407E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-240, -282})));
    Electrical.Lines.CPmodel.TLM L08_09(m = 3, Zc = {5.98773E+02, 3.84714E+02, 3.84714E+02}, r = {1.46239E-01, 4.77688E-02, 4.77688E-02}, d = 93500, tau = {3.40071E-04, 3.12842E-04, 3.12842E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-170, -544})));
    Electrical.Lines.CPmodel.TLM L05_06(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 8500, tau = {3.32911E-05, 2.86688E-05, 2.86688E-05}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-170, -220})));
    Electrical.Lines.CPmodel.TLM L06_07(m = 3, Zc = {5.98773E+02, 3.84714E+02, 3.84714E+02}, r = {1.46239E-01, 4.77688E-02, 4.77688E-02}, d = 25700, tau = {9.34740E-05, 8.59899E-05, 8.59899E-05}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-170, -328})));
    Electrical.Lines.CPmodel.TLM L07_08(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 15100, tau = {5.91406E-05, 5.09293E-05, 5.09293E-05}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-170, -432})));
    Electrical.Lines.CPmodel.TLM L26_27(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 47200, tau = {1.84863E-04, 1.59196E-04, 1.59196E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {0, 276})));
    Electrical.Lines.CPmodel.TLM L17_27(m = 3, Zc = {5.66972E+02, 2.67784E+02, 2.67784E+02}, r = {3.48370E-01, 1.52196E-02, 1.52196E-02}, d = 59400, tau = {2.53700E-04, 2.00335E-04, 2.00335E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = 90, origin = {0, 186})));
    Electrical.Lines.CPmodel.TLM L17_18(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 26200, tau = {1.02615E-04, 8.83673E-05, 8.83673E-05}) annotation(
      Placement(transformation(extent = {{-69, 109}, {-39, 131}})));
    Electrical.Lines.CPmodel.TLM L16_17(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 27500, tau = {1.07706E-04, 9.27519E-05, 9.27519E-05}) annotation(
      Placement(transformation(extent = {{91, 109}, {61, 131}})));
    Electrical.Lines.CPmodel.TLM L03_18(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 42400, tau = {1.66064E-04, 1.43007E-04, 1.43007E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-128, 42})));
    Electrical.Lines.CPmodel.TLM L04_14(m = 3, Zc = {5.98773E+02, 3.84714E+02, 3.84714E+02}, r = {1.46239E-01, 4.77688E-02, 4.77688E-02}, d = 33600, tau = {1.22207E-04, 1.12423E-04, 1.12423E-04}) annotation(
      Placement(transformation(extent = {{-57, -111}, {-27, -89}})));
    Electrical.Lines.CPmodel.TLM L14_15(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 70900, tau = {2.77687E-04, 2.39131E-04, 2.39131E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = 90, origin = {80, -58})));
    Electrical.Lines.CPmodel.TLM L15_16(Zc = {6.36011E+02, 2.86311E+02, 2.86311E+02}, r = {4.25403E-01, 3.86061E-02, 3.86061E-02}, d = 31900, tau = {1.47283E-04, 1.08857E-04, 1.08857E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = 90, origin = {160, 20})));
    Electrical.Lines.CPmodel.TLM L13_14(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 33200, tau = {1.30031E-04, 1.11977E-04, 1.11977E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = 90, origin = {160, -234})));
    Electrical.Lines.CPmodel.TLM L06_11(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 26900, tau = {1.05356E-04, 9.07283E-05, 9.07283E-05}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-20, -326})));
    Electrical.Lines.CPmodel.TLM L10_11(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 14100, tau = {5.52240E-05, 4.75565E-05, 4.75565E-05}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {-20, -440})));
    Electrical.Lines.CPmodel.TLM L10_13(Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 14100, tau = {5.52240E-05, 4.75565E-05, 4.75565E-05}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {160, -440})));
    Electrical.Lines.CPmodel.TLM L16_19(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 61300, tau = {2.40087E-04, 2.06753E-04, 2.06753E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {280, -36})));
    Electrical.Lines.CPmodel.TLM L16_21(m = 3, Zc = {5.66972E+02, 2.67784E+02, 2.67784E+02}, r = {3.48370E-01, 1.52196E-02, 1.52196E-02}, d = 46700, tau = {1.99457E-04, 1.57502E-04, 1.57502E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {360, 8})));
    Electrical.Lines.CPmodel.TLM L21_22(m = 3, Zc = {5.66972E+02, 2.67784E+02, 2.67784E+02}, r = {3.48370E-01, 1.52196E-02, 1.52196E-02}, d = 47700, tau = {2.03728E-04, 1.60875E-04, 1.60875E-04}) annotation(
      Placement(transformation(extent = {{413, -31}, {443, -9}})));
    Electrical.Lines.CPmodel.TLM L22_23(m = 3, Zc = {5.66972E+02, 2.67784E+02, 2.67784E+02}, r = {3.48370E-01, 1.52196E-02, 1.52196E-02}, d = 33500, tau = {1.43080E-04, 1.12984E-04, 1.12984E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {492, -94})));
    Electrical.Lines.CPmodel.TLM L16_24(m = 3, Zc = {5.98773E+02, 3.84714E+02, 3.84714E+02}, r = {1.46239E-01, 4.77688E-02, 4.77688E-02}, d = 15900, tau = {5.78302E-05, 5.31999E-05, 5.31999E-05}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = 90, origin = {492, 102})));
    Electrical.Lines.CPmodel.TLM L23_24(m = 3, Zc = {5.98773E+02, 3.84714E+02, 3.84714E+02}, r = {1.46239E-01, 4.77688E-02, 4.77688E-02}, d = 89400, tau = {3.25159E-04, 2.99124E-04, 2.99124E-04}) annotation(
      Placement(transformation(extent = {{-15, -11}, {15, 11}}, rotation = -90, origin = {560, 14})));
    Electrical.Lines.CPmodel.TLM L26_28(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 153000, tau = {5.99239E-04, 5.16038E-04, 5.16038E-04}) annotation(
      Placement(transformation(extent = {{101, 349}, {131, 371}})));
    Electrical.Lines.CPmodel.TLM L26_29(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 201800, tau = {7.90369E-04, 6.80631E-04, 6.80631E-04}) annotation(
      Placement(transformation(extent = {{179, 409}, {209, 431}})));
    Electrical.Lines.CPmodel.TLM L_28_29(m = 3, Zc = {5.26474E+02, 2.95494E+02, 2.95494E+02}, r = {1.26832E-01, 3.15113E-02, 3.15113E-02}, d = 48800, tau = {1.91130E-04, 1.64593E-04, 1.64593E-04}) annotation(
      Placement(transformation(extent = {{319, 349}, {349, 371}})));
  equation
    connect(Plug_b.pin_p, SW.pin_n) annotation(
      Line(points = {{50, -39.8}, {34, -39.8}, {34, -40}, {35, -40}}, color = {0, 0, 255}));
    connect(Brm.m, B14.positivePlug2) annotation(
      Line(points = {{80, -92.02}, {80, -100}, {160, -100}, {160, -112}}, color = {0, 0, 255}));
    connect(load26.p, B26.positivePlug1) annotation(
      Line(points = {{52, 325.6}, {52, 334}, {0, 334}}, color = {0, 0, 255}));
    connect(load27.p, B27.positivePlug1) annotation(
      Line(points = {{51.85, 214}, {52, 214}, {52, 228}, {0, 228}}, color = {0, 0, 255}));
    connect(SW.pin_p, Plug_a.pin_p) annotation(
      Line(points = {{13, -40}, {6, -40}, {6, -39.8}, {2, -39.8}}, color = {0, 0, 255}));
    connect(B03.positivePlug2, load03.p) annotation(
      Line(points = {{-240, -30}, {-300, -30}, {-300, -30.45}, {-299.9, -30.45}}, color = {0, 0, 255}));
    connect(Brk.k, B15.positivePlug1) annotation(
      Line(points = {{80.04, -26.06}, {80.04, -20}, {120, -20}, {120, -40}, {160, -40}, {160, -38}}, color = {0, 0, 255}));
    connect(load39.p, B39.positivePlug1) annotation(
      Line(points = {{-485.8, -130.15}, {-439.8, -130.15}, {-439.8, -118}, {-440, -118}, {-440, -116}}, color = {0, 0, 255}));
    connect(load39.p, powerPlant_01.positivePlug2) annotation(
      Line(points = {{-485.8, -130.15}, {-526, -130.15}, {-526, -141.1}}, color = {0, 0, 255}));
    connect(B10.positivePlug1, powerPlant_03.k) annotation(
      Line(points = {{70, -524}, {70, -534.8}}, color = {0, 0, 255}));
    connect(B19.positivePlug1, xfo19_20.k) annotation(
      Line(points = {{280, -118}, {280, -118}, {280, -230}, {280, -230}}, color = {0, 0, 255}));
    connect(B20.positivePlug2, xfo19_20.m) annotation(
      Line(points = {{260, -298}, {260, -250}, {277.2, -250}}, color = {0, 0, 255}));
    connect(xfo19_20.p, earth.plug_p) annotation(
      Line(points = {{284, -250.2}, {310, -250.2}, {310, -266}, {310.05, -266}}, color = {0, 0, 255}));
    connect(B25.positivePlug2, powerPlant_08.k) annotation(
      Line(points = {{-440, 338}, {-440, 354.8}}, color = {0, 0, 255}));
    connect(load25.p, B25.positivePlug1) annotation(
      Line(points = {{-488, 333.6}, {-464, 333.6}, {-464, 334}, {-440, 334}}, color = {0, 0, 255}));
    connect(load18.p, B18.positivePlug1) annotation(
      Line(points = {{-87.9, 87.8}, {-87.9, 102}, {-128, 102}}, color = {0, 0, 255}));
    connect(load16.p, B16.positivePlug2) annotation(
      Line(points = {{200, 49.6}, {200, 49.6}, {200, 56}, {160, 56}, {160, 54}, {160, 54}}, color = {0, 0, 255}));
    connect(xfo12_13.k, B13.positivePlug2) annotation(
      Line(points = {{100, -336}, {100, -336}, {100, -386}, {160, -386}, {160, -386}}, color = {0, 0, 255}));
    connect(xfo12_11.k, B11.positivePlug2) annotation(
      Line(points = {{40, -336}, {40, -336}, {40, -372}, {40, -372}, {40, -386}, {-20, -386}, {-20, -386}}, color = {0, 0, 255}));
    connect(load08.p, B08.positivePlug1) annotation(
      Line(points = {{-106.05, -532}, {-106.05, -512.8}, {-170, -512.8}}, color = {0, 0, 255}));
    connect(ShuntCap.plug_n, G.positivePlug1) annotation(
      Line(points = {{424, 142}, {424, 142}, {424, 136}, {424, 136}}, color = {0, 0, 255}));
    connect(ShuntCap.plug_p, B24.positivePlug2) annotation(
      Line(points = {{424, 161.8}, {424, 170}, {492, 170}, {492, 162}}, color = {0, 0, 255}));
    connect(load24.p, B24.positivePlug2) annotation(
      Line(points = {{454, 159.8}, {454, 170}, {492, 170}, {492, 162}}, color = {0, 0, 255}));
    connect(load23.p, B23.positivePlug1) annotation(
      Line(points = {{521.95, -150.25}, {521.95, -150.25}, {521.95, -146}, {492, -146}, {492, -146}}, color = {0, 0, 255}));
    connect(B23.positivePlug1, powerPlant_07.k) annotation(
      Line(points = {{492, -146}, {492, -146}, {492, -152.619}, {492.1, -152.619}}, color = {0, 0, 255}));
    connect(powerPlant_06.k, B22.positivePlug2) annotation(
      Line(points = {{492, 1.8}, {492, 1.8}, {492, -34}, {492, -34}}, color = {0, 0, 255}));
    connect(B21.positivePlug1, load21.p) annotation(
      Line(points = {{360, -38}, {360, -38}, {360, -58}, {360, -58}}, color = {0, 0, 255}));
    connect(powerPlant_04.k, B19.positivePlug1) annotation(
      Line(points = {{314, -139.6}, {280, -139.6}, {280, -118}, {280, -118}}, color = {0, 0, 255}));
    connect(B20.positivePlug1, load20.p) annotation(
      Line(points = {{260, -302}, {306, -302}, {306, -312.2}}, color = {0, 0, 255}));
    connect(B20.positivePlug1, powerPlant_05.k) annotation(
      Line(points = {{260, -302}, {260, -314.8}}, color = {0, 0, 255}));
    connect(load15.p, B15.positivePlug1) annotation(
      Line(points = {{200, -44.2}, {200, -41}, {160, -41}, {160, -38}}, color = {0, 0, 255}));
    connect(powerPlant_02.k, B06.positivePlug1) annotation(
      Line(points = {{-99.9, -295}, {-99.9, -284}, {-170, -284}}, color = {0, 0, 255}));
    connect(xfo12_13.m, B12.positivePlug1) annotation(
      Line(points = {{100, -316}, {100, -316}, {100, -300}, {70, -300}, {70, -282}, {69, -282}}, color = {0, 0, 255}));
    connect(xfo12_11.m, B12.positivePlug1) annotation(
      Line(points = {{40, -316}, {40, -316}, {40, -300}, {70, -300}, {70, -282}, {69, -282}}, color = {0, 0, 255}));
    connect(B12.positivePlug2, load12.positivePlug) annotation(
      Line(points = {{69, -278}, {69, -274}, {69, -268}, {68.8, -268}}, color = {0, 0, 255}));
    connect(load28.p, B28.positivePlug1) annotation(
      Line(points = {{244, 305.8}, {244, 334}}, color = {0, 0, 255}));
    connect(powerPlant_09.k, B29.positivePlug1) annotation(
      Line(points = {{443.8, 320.2}, {424, 320.2}, {424, 332}, {424, 332}, {424, 332}}, color = {0, 0, 255}));
    connect(load29.p, B29.positivePlug1) annotation(
      Line(points = {{424.05, 307.8}, {424.05, 307.8}, {424.05, 332}, {424, 332}}, color = {0, 0, 255}));
    connect(load07.p, B07.positivePlug1) annotation(
      Line(points = {{-108.1, -410.35}, {-108.1, -388}, {-170, -388}}, color = {0, 0, 255}));
    connect(load04.p, B04.positivePlug1) annotation(
      Line(points = {{-179.9, -122.25}, {-179.9, -122.25}, {-179.9, -116}, {-240, -116}, {-240, -116}}, color = {0, 0, 255}));
    connect(powerPlant_10.k, B02.positivePlug2) annotation(
      Line(points = {{-474, 126.2}, {-456, 126.2}, {-456, 126}, {-440.2, 126}, {-440.2, 108}, {-440, 108}}, color = {0, 0, 255}));
    connect(L02_25.Plug_m, B02.positivePlug2) annotation(
      Line(points = {{-440, 243.2}, {-440, 108}}, color = {0, 0, 255}));
    connect(L02_25.Plug_k, B25.positivePlug1) annotation(
      Line(points = {{-439.8, 273}, {-439.8, 304}, {-440, 304}, {-440, 334}}, color = {0, 0, 255}));
    connect(L01_02.Plug_k, B02.positivePlug1) annotation(
      Line(points = {{-439.8, 59}, {-439.8, 74}, {-440, 74}, {-440, 104}}, color = {0, 0, 255}));
    connect(L01_02.Plug_m, B01.positivePlug2) annotation(
      Line(points = {{-440, 29.2}, {-440, -32}}, color = {0, 0, 255}));
    connect(L01_39.Plug_m, B39.positivePlug2) annotation(
      Line(points = {{-440, -82.8}, {-440, -112}}, color = {0, 0, 255}));
    connect(L01_39.Plug_k, B01.positivePlug1) annotation(
      Line(points = {{-439.8, -53}, {-439.8, -36}, {-440, -36}}, color = {0, 0, 255}));
    connect(L09_39.Plug_k, B39.positivePlug1) annotation(
      Line(points = {{-439.8, -267}, {-440, -234}, {-440, -130.15}, {-439.8, -130.15}, {-439.8, -118}, {-440, -118}, {-440, -116}}, color = {0, 0, 255}));
    connect(L09_39.Plug_m, B09.positivePlug2) annotation(
      Line(points = {{-440, -296.8}, {-440, -584}}, color = {0, 0, 255}));
    connect(L25_26.Plug_k, B25.positivePlug1) annotation(
      Line(points = {{-259, 320.2}, {-364, 320}, {-440, 320}, {-440, 334}}, color = {0, 0, 255}));
    connect(L25_26.Plug_m, B26.positivePlug1) annotation(
      Line(points = {{-229.2, 320}, {0, 320}, {0, 334}, {-3.88578e-16, 334}}, color = {0, 0, 255}));
    connect(L02_03.Plug_m, B03.positivePlug2) annotation(
      Line(points = {{-240, 27.2}, {-240, -30}}, color = {0, 0, 255}));
    connect(L02_03.Plug_k, B02.positivePlug1) annotation(
      Line(points = {{-239.8, 57}, {-239.8, 102}, {-440, 102}, {-440, 104}}, color = {0, 0, 255}));
    connect(L03_04.Plug_m, B04.positivePlug2) annotation(
      Line(points = {{-240, -82.8}, {-240, -112}}, color = {0, 0, 255}));
    connect(L03_04.Plug_k, B03.positivePlug1) annotation(
      Line(points = {{-239.8, -53}, {-239.8, -34}, {-240, -34}}, color = {0, 0, 255}));
    connect(L04_05.Plug_m, B05.positivePlug2) annotation(
      Line(points = {{-240, -170.8}, {-240, -190}}, color = {0, 0, 255}));
    connect(B04.positivePlug1, L04_05.Plug_k) annotation(
      Line(points = {{-240, -116}, {-240, -128}, {-240, -141}, {-239.8, -141}}, color = {0, 0, 255}));
    connect(B05.positivePlug1, L05_08.Plug_k) annotation(
      Line(points = {{-240, -194}, {-240, -230}, {-240, -267}, {-239.8, -267}}, color = {0, 0, 255}));
    connect(L05_08.Plug_m, B08.positivePlug2) annotation(
      Line(points = {{-240, -296.8}, {-240, -507.2}, {-170, -507.2}}, color = {0, 0, 255}));
    connect(L08_09.Plug_k, B08.positivePlug1) annotation(
      Line(points = {{-169.8, -529}, {-169.8, -512.8}, {-170, -512.8}}, color = {0, 0, 255}));
    connect(L08_09.Plug_m, B09.positivePlug2) annotation(
      Line(points = {{-170, -558.8}, {-170, -584}, {-440, -584}}, color = {0, 0, 255}));
    connect(B06.positivePlug2, L05_06.Plug_m) annotation(
      Line(points = {{-170, -280}, {-170, -234.8}}, color = {0, 0, 255}));
    connect(L05_06.Plug_k, B05.positivePlug1) annotation(
      Line(points = {{-169.8, -205}, {-169.8, -194}, {-240, -194}}, color = {0, 0, 255}));
    connect(B07.positivePlug2, L06_07.Plug_m) annotation(
      Line(points = {{-170, -384}, {-170, -342.8}}, color = {0, 0, 255}));
    connect(L06_07.Plug_k, B06.positivePlug1) annotation(
      Line(points = {{-169.8, -313}, {-169.8, -284}, {-170, -284}}, color = {0, 0, 255}));
    connect(L07_08.Plug_m, B08.positivePlug2) annotation(
      Line(points = {{-170, -446.8}, {-170, -507.2}}, color = {0, 0, 255}));
    connect(L07_08.Plug_k, B07.positivePlug1) annotation(
      Line(points = {{-169.8, -417}, {-169.8, -408}, {-170, -408}, {-170, -388}}, color = {0, 0, 255}));
    connect(L26_27.Plug_k, B26.positivePlug1) annotation(
      Line(points = {{0.2, 291}, {0.2, 320}, {0, 320}, {0, 334}, {-3.88578e-16, 334}}, color = {0, 0, 255}));
    connect(L26_27.Plug_m, B27.positivePlug2) annotation(
      Line(points = {{0, 261.2}, {0, 232}}, color = {0, 0, 255}));
    connect(L17_27.Plug_k, B17.positivePlug2) annotation(
      Line(points = {{-0.2, 171}, {-0.2, 166}, {0, 166}, {0, 148}}, color = {0, 0, 255}));
    connect(L17_27.Plug_m, B27.positivePlug1) annotation(
      Line(points = {{0, 200.8}, {0, 228}}, color = {0, 0, 255}));
    connect(L17_18.Plug_k, B18.positivePlug2) annotation(
      Line(points = {{-69, 120.2}, {-128, 120.2}, {-128, 106}}, color = {0, 0, 255}));
    connect(B17.positivePlug1, L16_17.Plug_m) annotation(
      Line(points = {{0, 144}, {0, 120}, {61.2, 120}}, color = {0, 0, 255}));
    connect(L17_18.Plug_m, L16_17.Plug_m) annotation(
      Line(points = {{-39.2, 120}, {61.2, 120}}, color = {0, 0, 255}));
    connect(L16_17.Plug_k, B16.positivePlug2) annotation(
      Line(points = {{91, 120.2}, {160, 120.2}, {160, 54}}, color = {0, 0, 255}));
    connect(L03_18.Plug_k, B18.positivePlug1) annotation(
      Line(points = {{-127.8, 57}, {-127.8, 102}, {-128, 102}}, color = {0, 0, 255}));
    connect(L03_18.Plug_m, B03.positivePlug2) annotation(
      Line(points = {{-128, 27.2}, {-128, -30}, {-240, -30}}, color = {0, 0, 255}));
    connect(L04_14.Plug_k, B04.positivePlug2) annotation(
      Line(points = {{-57, -99.8}, {-240, -99.8}, {-240, -112}}, color = {0, 0, 255}));
    connect(L04_14.Plug_m, B14.positivePlug2) annotation(
      Line(points = {{-27.2, -100}, {160, -100}, {160, -112}}, color = {0, 0, 255}));
    connect(L14_15.Plug_k, Brm.k) annotation(
      Line(points = {{79.8, -73}, {79.8, -84.06}, {80.04, -84.06}}, color = {0, 0, 255}));
    connect(L14_15.Plug_m, Brk.m) annotation(
      Line(points = {{80, -43.2}, {80, -34.02}}, color = {0, 0, 255}));
    connect(Plug_b.plug_p, Brk.m) annotation(
      Line(points = {{54.2, -40}, {80, -40}, {80, -34.02}}, color = {0, 0, 255}));
    connect(Plug_a.plug_p, Brk.m) annotation(
      Line(points = {{-2.2, -40}, {-14, -40}, {-14, -26}, {68, -26}, {68, -40}, {80, -40}, {80, -34.02}}, color = {0, 0, 255}));
    connect(L15_16.Plug_k, B15.positivePlug2) annotation(
      Line(points = {{159.8, 5}, {159.8, -34}, {160, -34}}, color = {0, 0, 255}));
    connect(L15_16.Plug_m, B16.positivePlug1) annotation(
      Line(points = {{160, 34.8}, {160, 50}}, color = {0, 0, 255}));
    connect(L13_14.Plug_k, B13.positivePlug2) annotation(
      Line(points = {{159.8, -249}, {159.8, -264}, {160, -264}, {160, -386}}, color = {0, 0, 255}));
    connect(L13_14.Plug_m, B14.positivePlug1) annotation(
      Line(points = {{160, -219.2}, {160, -116}}, color = {0, 0, 255}));
    connect(L06_11.Plug_m, B11.positivePlug2) annotation(
      Line(points = {{-20, -340.8}, {-20, -386}}, color = {0, 0, 255}));
    connect(L06_11.Plug_k, B06.positivePlug1) annotation(
      Line(points = {{-19.8, -311}, {-19.8, -284}, {-170, -284}}, color = {0, 0, 255}));
    connect(L10_11.Plug_k, B11.positivePlug1) annotation(
      Line(points = {{-19.8, -425}, {-19.8, -390}, {-20, -390}}, color = {0, 0, 255}));
    connect(L10_11.Plug_m, B10.positivePlug2) annotation(
      Line(points = {{-20, -454.8}, {-20, -520}, {70, -520}}, color = {0, 0, 255}));
    connect(L10_13.Plug_m, B10.positivePlug2) annotation(
      Line(points = {{160, -454.8}, {160, -520}, {70, -520}}, color = {0, 0, 255}));
    connect(L10_13.Plug_k, B13.positivePlug1) annotation(
      Line(points = {{160.2, -425}, {160.2, -390}, {160, -390}}, color = {0, 0, 255}));
    connect(B19.positivePlug2, L16_19.Plug_m) annotation(
      Line(points = {{280, -114}, {280, -50.8}}, color = {0, 0, 255}));
    connect(L16_19.Plug_k, B16.positivePlug2) annotation(
      Line(points = {{280.2, -21}, {280.2, 56}, {160, 56}, {160, 54}}, color = {0, 0, 255}));
    connect(L16_21.Plug_m, B21.positivePlug2) annotation(
      Line(points = {{360, -6.8}, {360, -34}}, color = {0, 0, 255}));
    connect(L16_21.Plug_k, B16.positivePlug2) annotation(
      Line(points = {{360.2, 23}, {360, 38}, {360, 56}, {160, 56}, {160, 54}}, color = {0, 0, 255}));
    connect(L21_22.Plug_k, B21.positivePlug2) annotation(
      Line(points = {{413, -19.8}, {402, -20}, {360, -20}, {360, -34}}, color = {0, 0, 255}));
    connect(L21_22.Plug_m, B22.positivePlug2) annotation(
      Line(points = {{442.8, -20}, {492, -20}, {492, -34}}, color = {0, 0, 255}));
    connect(B23.positivePlug2, L22_23.Plug_m) annotation(
      Line(points = {{492, -142}, {492, -108.8}}, color = {0, 0, 255}));
    connect(L22_23.Plug_k, B22.positivePlug1) annotation(
      Line(points = {{492.2, -79}, {492.2, -66}, {492, -66}, {492, -38}}, color = {0, 0, 255}));
    connect(L16_24.Plug_m, B24.positivePlug1) annotation(
      Line(points = {{492, 116.8}, {492, 158}}, color = {0, 0, 255}));
    connect(L16_24.Plug_k, B16.positivePlug2) annotation(
      Line(points = {{491.8, 87}, {491.8, 56}, {160, 56}, {160, 54}}, color = {0, 0, 255}));
    connect(L23_24.Plug_m, B23.positivePlug2) annotation(
      Line(points = {{560, -0.8}, {560, -142}, {492, -142}}, color = {0, 0, 255}));
    connect(L23_24.Plug_k, B24.positivePlug1) annotation(
      Line(points = {{560.2, 29}, {560.2, 158}, {492, 158}}, color = {0, 0, 255}));
    connect(L26_28.Plug_k, B26.positivePlug2) annotation(
      Line(points = {{101, 360.2}, {0, 360.2}, {0, 338}, {3.88578e-16, 338}}, color = {0, 0, 255}));
    connect(L26_28.Plug_m, B28.positivePlug2) annotation(
      Line(points = {{130.8, 360}, {244, 360}, {244, 338}}, color = {0, 0, 255}));
    connect(L26_29.Plug_k, B26.positivePlug2) annotation(
      Line(points = {{179, 420.2}, {179, 420}, {0, 420}, {0, 338}, {3.88578e-16, 338}}, color = {0, 0, 255}));
    connect(L26_29.Plug_m, B29.positivePlug2) annotation(
      Line(points = {{208.8, 420}, {424, 420}, {424, 336}}, color = {0, 0, 255}));
    connect(L_28_29.Plug_k, B28.positivePlug2) annotation(
      Line(points = {{319, 360.2}, {276, 360}, {244, 360}, {244, 338}}, color = {0, 0, 255}));
    connect(L_28_29.Plug_m, B29.positivePlug2) annotation(
      Line(points = {{348.8, 360}, {424, 360}, {424, 336}}, color = {0, 0, 255}));
    annotation(
      experiment(StartTime = 0, StopTime = 0.6, Tolerance = 1e-05, Interval = 2.5e-05),
      Diagram(coordinateSystem(extent = {{-550, -600}, {600, 500}})),
      Icon(coordinateSystem(extent = {{-550, -600}, {600, 500}})),
      __OpenModelica_commandLineOptions = "",
      __OpenModelica_simulationFlags(lv = "LOG_STATS", outputFormat = "mat", s = "dassl", single = "()"),
      Documentation(info = "<html><head></head><body>This file contains CP line Model<div>provided by Alireza MASOOM</div><div>Date 7 july 2020</div></body></html>"));
  end IEEE39Bus;

  model Load03
    OpenEMTP.Electrical.Load_Models.PQ_Load Load03(P = 322 / 3 * {1, 1, 1}, Q = 2.4 / 3 * {1, 1, 1}, V = 25.25, f = 60) annotation(
      Placement(visible = true, transformation(extent = {{-64, -12}, {-44, 8}}, rotation = 0)));
    Electrical.Transformers.YgD01 LoadTransfo03(S = 400, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-30, 20}, {-10, 40}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(visible = true, transformation(extent = {{-8, 93}, {12, 103}}, rotation = 0), iconTransformation(extent = {{-10, 87}, {12, 104}}, rotation = 0)));
  equation
    connect(LoadTransfo03.m, Load03.positivePlug) annotation(
      Line(points = {{-10, 30}, {-47, 30}, {-47, 8}}, color = {0, 0, 255}));
    connect(p, LoadTransfo03.k) annotation(
      Line(points = {{2, 98}, {36, 98}, {36, 30}, {-30, 30}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-54, 36}, lineColor = {238, 46, 47}, extent = {{-6, 4}, {6, -4}}, textString = "V1:1.01/_-44.5")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-134, -114}, {90, -192}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load03;

  model Load04
    OpenEMTP.Electrical.Load_Models.PQ_Load Load04(P = 500 / 3 * {1, 1, 1}, Q = 184 / 3 * {1, 1, 1}, V = 23.75, f = 60) annotation(
      Placement(visible = true, transformation(extent = {{-62, -18}, {-42, 2}}, rotation = 0)));
    Electrical.Transformers.YgD01 LoadTransfo04(S = 700, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-24, 16}, {-4, 36}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(visible = true, transformation(extent = {{90, 21}, {110, 31}}, rotation = 0), iconTransformation(extent = {{-10, 89}, {12, 106}}, rotation = 0)));
  equation
    connect(LoadTransfo04.m, Load04.positivePlug) annotation(
      Line(points = {{-4, 26}, {-45, 26}, {-45, 2}}, color = {0, 0, 255}));
    connect(p, LoadTransfo04.k) annotation(
      Line(points = {{100, 26}, {-24, 26}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-51, 40}, lineColor = {238, 46, 47}, extent = {{-7, 8}, {13, -12}}, textString = "V1:0.95/_-45.2")}),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-72, -48}, {-4, -112}}, textString = "P"), Polygon(lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{6, -48}, {74, -112}}, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, extent = {{-134, -112}, {90, -190}}, textString = "%name")}));
  end Load04;

  model Load07
    OpenEMTP.Electrical.Load_Models.PQ_Load Load07(P = 233.8 / 3 * {1, 1, 1}, Q = 84 / 3 * {1, 1, 1}, V = 23.75, f = 60) annotation(
      Placement(visible = true, transformation(extent = {{-28, -38}, {-8, -18}}, rotation = 0)));
    Electrical.Transformers.YgD01 LoadTransfo07(S = 400, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-58, -12}, {-38, 8}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-8, 95}, {12, 105}}), iconTransformation(extent = {{-10, 89}, {8, 104}})));
  equation
    connect(LoadTransfo07.m, Load07.positivePlug) annotation(
      Line(points = {{-38, -2}, {-11, -2}, {-11, -18}}, color = {0, 0, 255}));
    connect(p, LoadTransfo07.k) annotation(
      Line(points = {{2, 100}, {-80, 100}, {-80, -2}, {-58, -2}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {3, -11}, lineColor = {238, 46, 47}, extent = {{-9, 5}, {9, -5}}, textString = "V1:0.95/_-45.1")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-134, -112}, {90, -190}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load07;

  model Load08
    OpenEMTP.Electrical.Load_Models.PQ_Load Load08(P = 522 / 3 * {1, 1, 1}, Q = 176 / 3 * {1, 1, 1}, V = 23.5, f = 60) annotation(
      Placement(visible = true, transformation(extent = {{24, -36}, {44, -16}}, rotation = 0)));
    Electrical.Transformers.YgD01 LoadTransfo08(S = 650, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-14, -10}, {6, 10}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(visible = true, transformation(extent = {{-45, 84}, {-35, 104}}, rotation = 0), iconTransformation(extent = {{-10, 90}, {9, 110}}, rotation = 0)));
  equation
    connect(LoadTransfo08.m, Load08.positivePlug) annotation(
      Line(points = {{6, 0}, {41, 0}, {41, -16}}, color = {0, 0, 255}));
    connect(p, LoadTransfo08.k) annotation(
      Line(points = {{-40, 94}, {-40, 0.25}, {-14, 0.25}, {-14, 0}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {55, -2}, lineColor = {238, 46, 47}, extent = {{-9, 4}, {9, -4}}, textString = "V1:0.94/_-47.1")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-134, -112}, {90, -190}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load08;

  model Load15
    Electrical.Load_Models.PQ_Load Load15(P = 320 / 3 * {1, 1, 1}, Q = 153 / 3 * {1, 1, 1}, V = 24, f = 60) annotation(
      Placement(transformation(extent = {{-8, -4}, {12, 16}})));
    Electrical.Transformers.YgD01 LoadTransfo15(S = 500, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-40, 24}, {-20, 44}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-10, 88}, {10, 108}}), iconTransformation(extent = {{-10, 88}, {10, 108}})));
  equation
    connect(LoadTransfo15.m, Load15.positivePlug) annotation(
      Line(points = {{-20, 34}, {8.8, 34}, {8.8, 16}}, color = {0, 0, 255}));
    connect(p, LoadTransfo15.k) annotation(
      Line(points = {{0, 98}, {-70, 98}, {-70, 34}, {-40, 34}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-134, -112}, {90, -190}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}),
      Diagram(graphics = {Text(origin = {21, 24}, lineColor = {238, 46, 47}, extent = {{-7, 4}, {7, -4}}, textString = "V1:0.96/_-43.0")}));
  end Load15;

  model Load16
    Electrical.Load_Models.PQ_Load Load16(P = 329 / 3 * {1, 1, 1}, Q = 32.3 / 3 * {1, 1, 1}, V = 25.25, f = 60) annotation(
      Placement(transformation(extent = {{0, 72}, {20, 92}})));
    Electrical.Transformers.YgD01 LoadTransfo16(S = 500, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-32, 100}, {-12, 120}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-10, 186}, {10, 206}}), iconTransformation(extent = {{-10, 186}, {10, 206}})));
  equation
    connect(LoadTransfo16.m, Load16.positivePlug) annotation(
      Line(points = {{-12, 110}, {16.8, 110}, {16.8, 92}}, color = {0, 0, 255}));
    connect(p, LoadTransfo16.k) annotation(
      Line(points = {{0, 196}, {-66, 196}, {-66, 110}, {-32, 110}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(extent = {{-100, 0}, {100, 200}}, initialScale = 0.1), graphics = {Text(origin = {29, 99}, lineColor = {238, 46, 47}, extent = {{-5, 3}, {13, -11}}, textString = "V1:1.01/_-41.3")}),
      Icon(coordinateSystem(extent = {{-100, 0}, {100, 200}}), graphics = {Line(points = {{0, 188}, {0, 120}, {0, 120}}, color = {0, 0, 255}), Line(points = {{-80, 120}, {16, 120}, {80, 120}}, color = {0, 0, 255}), Polygon(points = {{-60, 70}, {-20, 70}, {-40, 50}, {-60, 70}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, 52}, {-4, -12}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, 70}, {58, 70}, {38, 50}, {18, 70}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, 52}, {74, -12}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 120}, {-40, 74}, {-40, 70}, {-42, 70}, {-40, 70}}, color = {0, 0, 255}), Line(points = {{40, 120}, {40, 70}}, color = {0, 0, 255}), Text(extent = {{-134, -12}, {90, -90}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load16;

  model Load18
    OpenEMTP.Electrical.Load_Models.PQ_Load Load18(P = 158 / 3 * {1, 1, 1}, Q = 30 / 3 * {1, 1, 1}, V = 25.25, f = 60) annotation(
      Placement(visible = true, transformation(extent = {{66, -6}, {86, 14}}, rotation = 0)));
    OpenEMTP.Electrical.Transformers.YgD01 LoadTransfo18(S = 400, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(visible = true, transformation(extent = {{32, 36}, {52, 56}}, rotation = 0)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(visible = true, transformation(extent = {{-10, 93}, {10, 103}}, rotation = 0), iconTransformation(extent = {{-8, 90}, {10, 106}}, rotation = 0)));
  equation
    connect(p, LoadTransfo18.k) annotation(
      Line(points = {{0, 98}, {0, 98}, {0, 46}, {32, 46}, {32, 46}}, color = {0, 0, 255}));
    connect(LoadTransfo18.m, Load18.positivePlug) annotation(
      Line(points = {{52, 46}, {83, 46}, {83, 14}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {68, 26}, lineColor = {238, 46, 47}, extent = {{-6, 4}, {6, -4}}, textString = "V1:1.01/_-41.9")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-136, -114}, {88, -192}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load18;

  model Load20
    Electrical.Load_Models.PQ_Load Load20(P = 628 / 3 * {1, 1, 1}, Q = 103 / 3 * {1, 1, 1}, V = 24, f = 60) annotation(
      Placement(transformation(extent = {{-20, -6}, {0, 14}})));
    Electrical.Transformers.YgD01 LoadTransfo20(S = 800, f = 60, v1 = 300, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-52, 26}, {-32, 46}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-10, 88}, {10, 108}}), iconTransformation(extent = {{-10, 88}, {10, 108}})));
  equation
    connect(LoadTransfo20.m, Load20.positivePlug) annotation(
      Line(points = {{-32, 36}, {-3.2, 36}, {-3.2, 14}}, color = {0, 0, 255}));
    connect(p, LoadTransfo20.k) annotation(
      Line(points = {{0, 98}, {-76, 98}, {-76, 36}, {-52, 36}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-134, -112}, {90, -190}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}),
      Diagram(graphics = {Text(origin = {14, 27}, lineColor = {238, 46, 47}, extent = {{-12, 5}, {12, -5}}, textString = "V1:0.96/_-38.3")}));
  end Load20;

  model Load21
    Electrical.Load_Models.PQ_Load Load21(P = 274 / 3 * {1, 1, 1}, Q = 115 / 3 * {1, 1, 1}, V = 25, f = 60) annotation(
      Placement(transformation(extent = {{14, -12}, {34, 8}})));
    Electrical.Transformers.YgD01 LoadTransfo21(S = 800, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-18, 16}, {2, 36}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-10, 90}, {10, 110}}), iconTransformation(extent = {{-10, 90}, {10, 110}})));
  equation
    connect(LoadTransfo21.m, Load21.positivePlug) annotation(
      Line(points = {{2, 26}, {30.8, 26}, {30.8, 8}}, color = {0, 0, 255}));
    connect(p, LoadTransfo21.k) annotation(
      Line(points = {{0, 100}, {-60, 100}, {-60, 26}, {-18, 26}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-134, -112}, {90, -190}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}),
      Diagram(graphics = {Text(origin = {49, 22}, lineColor = {238, 46, 47}, extent = {{-9, 4}, {9, -4}}, textString = "V1:1.00/_-37.0")}));
  end Load21;

  model Load23
    Electrical.Load_Models.PQ_Load Load23(P = 247.5 / 3 * {1, 1, 1}, Q = 84.6 / 3 * {1, 1, 1}, V = 25.25, f = 60) annotation(
      Placement(transformation(extent = {{20, -24}, {40, -4}})));
    Electrical.Transformers.YgD01 LoadTransfo23(S = 400, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-12, 4}, {8, 24}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-3, 95}, {7, 105}}), iconTransformation(extent = {{-8, 90}, {7, 105}})));
  equation
    connect(LoadTransfo23.m, Load23.positivePlug) annotation(
      Line(points = {{8, 14}, {36.8, 14}, {36.8, -4}}, color = {0, 0, 255}));
    connect(p, LoadTransfo23.k) annotation(
      Line(points = {{2, 100}, {-32, 100}, {-32, 14}, {-12, 14}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {51, 6}, lineColor = {238, 46, 47}, extent = {{-9, 4}, {9, -4}}, textString = "V1:1.01/_-34.2")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-136, -112}, {88, -190}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load23;

  model Load24
    Electrical.Transformers.YgD01 LoadTransfo24(S = 400, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-34, 18}, {-14, 38}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-5, 93}, {5, 103}}), iconTransformation(extent = {{-5, 93}, {5, 103}})));
    Electrical.Load_Models.P_Load Load24(P = 308.6 / 3 * {1, 1, 1}, V = 25.5, f = 60) annotation(
      Placement(transformation(extent = {{-8, -2}, {12, 18}})));
  equation
    connect(p, LoadTransfo24.k) annotation(
      Line(points = {{0, 98}, {-42, 98}, {-42, 28}, {-34, 28}}, color = {0, 0, 255}));
    connect(Load24.positivePlug, LoadTransfo24.m) annotation(
      Line(points = {{8.8, 18}, {8, 18}, {8, 28}, {-14, 28}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {20, 25}, lineColor = {238, 46, 47}, extent = {{-8, 5}, {12, -5}}, textString = "V1:1.02/_-41.8")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-134, -114}, {90, -192}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load24;

  model Load25
    Electrical.Load_Models.PQ_Load Load25(P = 224 / 3 * {1, 1, 1}, Q = 47.2 / 3 * {1, 1, 1}, V = 25.75, f = 60) annotation(
      Placement(transformation(extent = {{50, 8}, {70, 28}})));
    Electrical.Transformers.YgD01 LoadTransfo25(S = 400, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{32, 40}, {52, 60}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(visible = true, transformation(extent = {{-12, 40}, {8, 60}}, rotation = 0), iconTransformation(extent = {{-10, 86}, {10, 106}}, rotation = 0)));
  equation
    connect(p, LoadTransfo25.k) annotation(
      Line(points = {{-2, 50}, {32, 50}}, color = {0, 0, 255}));
    connect(LoadTransfo25.m, Load25.positivePlug) annotation(
      Line(points = {{52, 50}, {66.8, 50}, {66.8, 28}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(origin = {-82, -134}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name")}),
      Diagram(graphics = {Text(origin = {80, 34}, lineColor = {238, 46, 47}, extent = {{-8, 4}, {8, -4}}, textString = "V1:1.03/_-38.9")}));
  end Load25;

  model Load26
    Electrical.Load_Models.PQ_Load Load26(P = 139 / 3 * {1, 1, 1}, Q = 17 / 3 * {1, 1, 1}, V = 25.5, f = 60) annotation(
      Placement(transformation(extent = {{38, -30}, {58, -10}})));
    Electrical.Transformers.YgD01 LoadTransfo26(S = 200, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{6, -6}, {26, 14}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(visible = true, transformation(extent = {{-52, -6}, {-32, 14}}, rotation = 0), iconTransformation(extent = {{-10, 86}, {10, 106}}, rotation = 0)));
  equation
    connect(LoadTransfo26.m, Load26.positivePlug) annotation(
      Line(points = {{26, 4}, {54.8, 4}, {54.8, -10}}, color = {0, 0, 255}));
    connect(p, LoadTransfo26.k) annotation(
      Line(points = {{-42, 4}, {6, 4}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-124, -94}, {100, -172}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}),
      Diagram(graphics = {Text(origin = {58, 7}, lineColor = {238, 46, 47}, extent = {{-12, 5}, {12, -5}}, textString = "V1:1.02/_-40.8")}));
  end Load26;

  model Load27
    Electrical.Load_Models.PQ_Load Load27(P = 281 / 3 * {1, 1, 1}, Q = 75.5 / 3 * {1, 1, 1}, V = 24.75, f = 60) annotation(
      Placement(transformation(extent = {{4, -26}, {24, -6}})));
    Electrical.Transformers.YgD01 LoadTransfo27(S = 300, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-8, 22}, {12, 42}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-5, 86}, {5, 106}}), iconTransformation(extent = {{-11, 90}, {8, 110}})));
  equation
    connect(LoadTransfo27.m, Load27.positivePlug) annotation(
      Line(points = {{12, 32}, {20.8, 32}, {20.8, -6}}, color = {0, 0, 255}));
    connect(p, LoadTransfo27.k) annotation(
      Line(points = {{0, 96}, {-20, 96}, {-20, 32}, {-8, 32}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {38, -9}, lineColor = {238, 46, 47}, extent = {{-10, 5}, {10, -5}}, textString = "V1:0.99/_-44.3")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-136, -114}, {88, -192}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load27;

  model Load28
    Electrical.Load_Models.PQ_Load Load28(P = 206 / 3 * {1, 1, 1}, Q = 27.6 / 3 * {1, 1, 1}, V = 25.5, f = 60) annotation(
      Placement(transformation(extent = {{16, -34}, {36, -14}})));
    Electrical.Transformers.YgD01 LoadTransfo28(S = 300, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-16, -10}, {4, 10}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-10, 88}, {10, 108}}), iconTransformation(extent = {{-10, 88}, {10, 108}})));
  equation
    connect(LoadTransfo28.m, Load28.positivePlug) annotation(
      Line(points = {{4, 0}, {32.8, 0}, {32.8, -14}}, color = {0, 0, 255}));
    connect(p, LoadTransfo28.k) annotation(
      Line(points = {{0, 98}, {-28, 98}, {-28, 0}, {-16, 0}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-134, -112}, {90, -190}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}),
      Diagram(graphics = {Text(origin = {47, -5}, lineColor = {238, 46, 47}, extent = {{-9, 5}, {9, -5}}, textString = "V1:1.02/_-37.1")}));
  end Load28;

  model Load29
    Electrical.Load_Models.PQ_Load Load29(P = 283.5 / 3 * {1, 1, 1}, Q = 26.9 / 3 * {1, 1, 1}, V = 25.75, f = 60) annotation(
      Placement(transformation(extent = {{0, -48}, {20, -28}})));
    Electrical.Transformers.YgD01 LoadTransfo29(S = 400, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-32, -24}, {-12, -4}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-5, 86}, {5, 106}}), iconTransformation(extent = {{-9, 88}, {10, 108}})));
  equation
    connect(LoadTransfo29.m, Load29.positivePlug) annotation(
      Line(points = {{-12, -14}, {16.8, -14}, {16.8, -28}}, color = {0, 0, 255}));
    connect(p, LoadTransfo29.k) annotation(
      Line(points = {{0, 96}, {-36, 96}, {-36, -14}, {-32, -14}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {31, -20}, lineColor = {238, 46, 47}, extent = {{-9, 4}, {9, -4}}, textString = "V1:1.03/_-34.4")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-124, -94}, {100, -172}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load29;

  model Load39
    OpenEMTP.Electrical.Load_Models.PQ_Load Load39(P = 1104 / 3 * {1, 1, 1}, Q = 250 / 3 * {1, 1, 1}, V = 25.25, f = 60) annotation(
      Placement(visible = true, transformation(extent = {{-90, -30}, {-70, -10}}, rotation = 0)));
    Electrical.Transformers.YgD01 LoadTransfo39(S = 1500, f = 60, v1 = 345, v2 = 25, R = 0.002, X = 0.100, D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], Rmg = 500) annotation(
      Placement(transformation(extent = {{-56, -8}, {-36, 12}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug p annotation(
      Placement(transformation(rotation = 0, extent = {{-8, 95}, {12, 105}}), iconTransformation(extent = {{-10, 89}, {14, 108}})));
  equation
    connect(LoadTransfo39.m, Load39.positivePlug) annotation(
      Line(points = {{-36, 2}, {-73, 2}, {-73, -10}}, color = {0, 0, 255}));
    connect(p, LoadTransfo39.k) annotation(
      Line(points = {{2, 100}, {22, 100}, {22, 2}, {-56, 2}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(initialScale = 0.1), graphics = {Text(origin = {-75, 7}, lineColor = {255, 0, 0}, extent = {{-7, 5}, {7, -5}}, textString = "V1:1.01/_-45.8")}),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{0, 88}, {0, 20}, {0, 20}}, color = {0, 0, 255}), Line(points = {{-80, 20}, {16, 20}, {80, 20}}, color = {0, 0, 255}), Polygon(points = {{-60, -30}, {-20, -30}, {-40, -50}, {-60, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{-72, -48}, {-4, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "P"), Polygon(points = {{18, -30}, {58, -30}, {38, -50}, {18, -30}}, lineColor = {28, 108, 200}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid), Text(extent = {{6, -48}, {74, -112}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "Q"), Line(points = {{-40, 20}, {-40, -26}, {-40, -30}, {-42, -30}, {-40, -30}}, color = {0, 0, 255}), Line(points = {{40, 20}, {40, -30}}, color = {0, 0, 255}), Text(extent = {{-136, -112}, {88, -190}}, lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, fillPattern = FillPattern.Solid, textString = "%name")}));
  end Load39;

  model PowerPlant_01
    OpenEMTP.Connectors.Bus BusSM annotation(
      Placement(visible = true, transformation(origin = {116, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug positivePlug2 annotation(
      Placement(visible = true, transformation(extent = {{192, -10}, {212, 10}}, rotation = 0), iconTransformation(extent = {{-10, 88}, {10, 108}}, rotation = 0)));
    OpenEMTP.Electrical.Machines.SM_4thOrder SM01(F = 0, H = 5, Ifn = 3300, It_ss = {0, 0}, P = 2, Pn = 10000, Rs = 0, Tpdo = 7, Tpqo = 0.7, Vn = 345, Vt_ss = {1.03, -41.8}, X0 = 0.3, Xd = 2, Xls = 0.3, Xpd = 0.6, Xpq = 0.8, Xq = 1.9, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {140, -66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {140, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Examples.IEEE39Bus.IEEE39BusCaseSM_CP.PST PST_YgD(v1 = 345, v2 = 345) annotation(
      Placement(visible = true, transformation(origin = {162, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {40, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST01(EFSS = 1.0299848931117626, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {24, -12}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-56, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.01, k = 1, y_start = 1.0300000000000002) annotation(
      Placement(visible = true, transformation(origin = {-10, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-20, 10}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  equation
    connect(ST01.EFD, SM01.Vfd) annotation(
      Line(points = {{36, -4}, {68, -4}, {68, -4}, {68, -4}}, color = {0, 0, 127}));
    connect(SM01.Ifd_pu, ST01.IFD) annotation(
      Line(points = {{82.6667, -10.6667}, {82.6667, -10.6667}, {82.6667, -40}, {40, -40}, {40, -40}, {32, -40}, {32, -23.8}, {32, -23.8}}, color = {0, 0, 127}));
    connect(ST01.VS, Vf.y) annotation(
      Line(points = {{12.2, -12}, {0, -12}, {0, 10}, {-11.2, 10}, {-11.2, 10}}, color = {0, 0, 127}));
    connect(Vf.y, ST01.VREF) annotation(
      Line(points = {{-11.2, 10}, {0, 10}, {0, -4}, {11.8, -4}, {11.8, -4}}, color = {0, 0, 127}));
    connect(SM01.Vq_pu, vdqToVt1.Uq) annotation(
      Line(points = {{74.6667, -10.6667}, {76, -10.6667}, {76, -84}, {-86, -84}, {-86, -26}, {-68, -26}, {-68, -26}}, color = {0, 0, 127}));
    connect(SM01.Vd_pu, vdqToVt1.Ud) annotation(
      Line(points = {{70.5333, -10.6667}, {72, -10.6667}, {72, -80}, {-80, -80}, {-80, -14}, {-68, -14}, {-68, -14}}, color = {0, 0, 127}));
    connect(ST01.VT, vdqToVt1.Ut) annotation(
      Line(points = {{12, -19.8}, {-46, -19.8}, {-46, -20}, {-45, -20}}, color = {0, 0, 127}));
    connect(firstOrder.y, ST01.VC) annotation(
      Line(points = {{1, -60}, {22, -60}, {22, -24}, {22.2, -24}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ut, firstOrder.u) annotation(
      Line(points = {{-45, -20}, {-32, -20}, {-32, -60}, {-22, -60}, {-22, -60}}, color = {0, 0, 127}));
    connect(SM01.W_pu, governor_IEEEG11.W) annotation(
      Line(points = {{75.8667, 10.6667}, {75.8667, 10.6667}, {75.8667, 46}, {20, 46}, {20, 34}, {28, 34}, {28, 33.4}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.Pm, SM01.Pm_pu) annotation(
      Line(points = {{51, 29}, {60, 29}, {60, 4}, {68.4, 4}, {68.4, 5.2}}, color = {0, 0, 127}));
    connect(BusSM.positivePlug2, SM01.Pk) annotation(
      Line(points = {{114, 0}, {88, 0}, {88, 0}, {88.1333, 0}}, color = {0, 0, 255}));
    connect(Rd.plug_p, BusSM.positivePlug1) annotation(
      Line(points = {{140, -20.2}, {140, -20.2}, {140, 0}, {118, 0}, {118, 0}}, color = {0, 0, 255}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{140, -40}, {140, -56}}, color = {0, 0, 255}));
    connect(PST_YgD.m, BusSM.positivePlug1) annotation(
      Line(points = {{152, 0.2}, {118, 0.2}, {118, 0}, {118, 0}}, color = {0, 0, 255}));
    connect(PST_YgD.k, positivePlug2) annotation(
      Line(points = {{172, 0.2}, {200, 0.2}, {200, 0}, {202, 0}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Text(origin = {-20, 4}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-136, -120}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 2}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360), Line(points = {{0, 88}, {0, 66}, {0, 64}}, color = {0, 0, 255})}, coordinateSystem(extent = {{-200, -200}, {200, 200}})),
      experiment(StartTime = 0, StopTime = 1, Tolerance = 1e-6, Interval = 0.002),
      Diagram(coordinateSystem(extent = {{-200, -200}, {200, 200}}, initialScale = 0.1), graphics = {Text(origin = {111, 25}, lineColor = {255, 0, 0}, extent = {{-11, 7}, {25, -15}}, textString = "V1:1.03/_-41.8")}),
      __OpenModelica_commandLineOptions = "");
  end PowerPlant_01;

  model PowerPlant_02
    OpenEMTP.Connectors.Bus B31 annotation(
      Placement(visible = true, transformation(origin = {32, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Transformers.YgD01 YgD4(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.25, f = 60, v1 = 369.15, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {78, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(origin = {105, 0}, extent = {{-12, -15}, {12, 15}}, rotation = 0), iconTransformation(origin = {1, 90}, extent = {{-12, -13}, {12, 13}}, rotation = 0)));
    OpenEMTP.Electrical.Load_Models.PQ_Load load31(P = 9.2 / 3 * {1, 1, 1}, Q = 4.6 / 3 * {1, 1, 1}, V = 19.6) annotation(
      Placement(visible = true, transformation(origin = {73, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Machines.SM_4thOrder SM02(F = 0, H = 3.03, Ifn = 2200, It_ss = {0, 0}, P = 2, Pn = 1000, Rs = 0, Tpdo = 6.56, Tpqo = 1.5, Vn = 20, Vt_ss = {0.98, -30}, X0 = 0.35, Xd = 2.95, Xls = 0.35, Xpd = 0.697, Xpq = 1.7, Xq = 2.82, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {-6, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {34, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {34, -38}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-56, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Electrical.Exciters_Governor.ST1 ST01(EFSS = 0.9799856264558515, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-72, -6}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-136, -14}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.01, k = 1, y_start = 0.9800000000000003) annotation(
      Placement(visible = true, transformation(origin = {-104, -48}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-114, 16}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  equation
    connect(ST01.EFD, SM02.Vfd) annotation(
      Line(points = {{-60, 2}, {-36, 2}, {-36, -6}, {-20, -6}, {-20, -6}}, color = {0, 0, 127}));
    connect(SM02.W_pu, governor_IEEEG11.W) annotation(
      Line(points = {{-9.2, 16}, {-8, 16}, {-8, 44}, {-76, 44}, {-76, 34}, {-68, 34}, {-68, 33.4}}, color = {0, 0, 127}));
    connect(SM02.Pm_pu, governor_IEEEG11.Pm) annotation(
      Line(points = {{-20.4, 7.8}, {-34, 7.8}, {-34, 28}, {-45, 28}, {-45, 29}}, color = {0, 0, 127}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{34, -48}, {34, -60}}, color = {0, 0, 255}));
    connect(Rd.plug_p, B31.positivePlug1) annotation(
      Line(points = {{34, -28.2}, {34, 0}}, color = {0, 0, 255}));
    connect(load31.positivePlug, B31.positivePlug1) annotation(
      Line(points = {{79.8, -30}, {79.8, -20}, {60, -20}, {60, 0}, {34, 0}}, color = {0, 0, 255}));
    connect(B31.positivePlug2, SM02.Pk) annotation(
      Line(points = {{30, 0}, {9.2, 0}}, color = {0, 0, 255}));
    connect(YgD4.m, B31.positivePlug1) annotation(
      Line(points = {{68, 0}, {34, 0}}, color = {0, 0, 255}));
    connect(k, YgD4.k) annotation(
      Line(points = {{105, 0}, {88, 0}}, color = {0, 0, 255}));
    connect(firstOrder.y, ST01.VC) annotation(
      Line(points = {{-93, -48}, {-73.8, -48}, {-73.8, -18}}, color = {0, 0, 127}));
    connect(SM02.Ifd_pu, ST01.IFD) annotation(
      Line(points = {{1, -16}, {0, -16}, {0, -48}, {-64, -48}, {-64, -17.8}}, color = {0, 0, 127}));
    connect(ST01.VT, vdqToVt1.Ut) annotation(
      Line(points = {{-84, -13.8}, {-125, -13.8}, {-125, -14}}, color = {0, 0, 127}));
    connect(firstOrder.u, vdqToVt1.Ut) annotation(
      Line(points = {{-116, -48}, {-122, -48}, {-122, -13.8}, {-125, -13.8}, {-125, -14}}, color = {0, 0, 127}));
    connect(SM02.Vd_pu, vdqToVt1.Ud) annotation(
      Line(points = {{-17.2, -16}, {-16, -16}, {-16, -72}, {-160, -72}, {-160, -8}, {-148, -8}}, color = {0, 0, 127}));
    connect(SM02.Vq_pu, vdqToVt1.Uq) annotation(
      Line(points = {{-11, -16}, {-10, -16}, {-10, -80}, {-176, -80}, {-176, -20}, {-148, -20}}, color = {0, 0, 127}));
    connect(Vf.y, ST01.VREF) annotation(
      Line(points = {{-105.2, 16}, {-94, 16}, {-94, 2}, {-84.2, 2}}, color = {0, 0, 127}));
    connect(ST01.VS, ST01.VREF) annotation(
      Line(points = {{-83.8, -6}, {-94, -6}, {-94, 2}, {-84.2, 2}}, color = {0, 0, 127}));
    annotation(
      Diagram(graphics = {Text(origin = {41, 22}, lineColor = {255, 0, 0}, extent = {{-11, 6}, {11, -6}}, textString = "V1:0.98/_-30.0")}),
      Icon(graphics = {Text(origin = {-20, 12}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-72, -108}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 10}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)));
  end PowerPlant_02;

  model PowerPlant_03
    OpenEMTP.Connectors.Bus B32 annotation(
      Placement(visible = true, transformation(origin = {28, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
    OpenEMTP.Electrical.Transformers.YgD01 YgD3(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.20, f = 60, v1 = 369.15, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {64, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(origin = {100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(extent = {{-10, 82}, {10, 102}}, rotation = 0)));
    OpenEMTP.Electrical.Machines.SM_4thOrder SM03(F = 0, H = 3.58, Ifn = 2200, It_ss = {0, 0}, P = 2, Pn = 1000, Rs = 0, Tpdo = 5.7, Tpqo = 1.5, Vn = 20, Vt_ss = {0.98, -28.3}, X0 = 0.304, Xd = 2.495, Xls = 0.304, Xpd = 0.531, Xpq = 0.876, Xq = 2.37, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {-6, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {30, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}, m = 3) annotation(
      Placement(visible = true, transformation(origin = {30, -32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-56, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST01(EFSS = 0.9799856264558515, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-88, -4}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder(T = 0.01, k = 1, y_start = 0.9800000000000003) annotation(
      Placement(visible = true, transformation(origin = {-120, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-152, -12}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-130, 18}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
  equation
    connect(ST01.EFD, SM03.Vfd) annotation(
      Line(points = {{-76, 4}, {-40, 4}, {-40, -6}, {-20, -6}, {-20, -6}}, color = {0, 0, 127}));
    connect(ST01.VS, Vf.y) annotation(
      Line(points = {{-100, -4}, {-114, -4}, {-114, 18}, {-122, 18}, {-122, 18}}, color = {0, 0, 127}));
    connect(Vf.y, ST01.VREF) annotation(
      Line(points = {{-122, 18}, {-114, 18}, {-114, 4}, {-100, 4}, {-100, 4}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ud, SM03.Vd_pu) annotation(
      Line(points = {{-164, -6}, {-188, -6}, {-188, -72}, {-18, -72}, {-18, -16}, {-18, -16}, {-18, -16}}, color = {0, 0, 127}));
    connect(vdqToVt1.Uq, SM03.Vq_pu) annotation(
      Line(points = {{-164, -18}, {-178, -18}, {-178, -66}, {-10, -66}, {-10, -16}, {-10, -16}}, color = {0, 0, 127}));
    connect(firstOrder.u, vdqToVt1.Ut) annotation(
      Line(points = {{-132, -46}, {-136, -46}, {-136, -12}, {-140, -12}, {-140, -12}}, color = {0, 0, 127}));
    connect(firstOrder.y, ST01.VC) annotation(
      Line(points = {{-108, -46}, {-90, -46}, {-90, -16}, {-90, -16}}, color = {0, 0, 127}));
    connect(ST01.IFD, SM03.Ifd_pu) annotation(
      Line(points = {{-80, -16}, {-80, -16}, {-80, -40}, {0, -40}, {0, -16}, {2, -16}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ut, ST01.VT) annotation(
      Line(points = {{-140, -12}, {-100, -12}}, color = {0, 0, 127}));
    connect(SM03.W_pu, governor_IEEEG11.W) annotation(
      Line(points = {{-9.2, 16}, {-10, 16}, {-10, 44}, {-76, 44}, {-76, 34}, {-68, 34}, {-68, 33.4}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.Pm, SM03.Pm_pu) annotation(
      Line(points = {{-45, 29}, {-30, 29}, {-30, 8}, {-20.4, 8}, {-20.4, 7.8}}, color = {0, 0, 127}));
    connect(YgD3.k, k) annotation(
      Line(points = {{74, 0}, {98, 0}, {98, 0}, {100, 0}}, color = {0, 0, 255}));
    connect(YgD3.m, B32.positivePlug1) annotation(
      Line(points = {{54, 0}, {30, 0}}, color = {0, 0, 255}));
    connect(Rd.plug_p, B32.positivePlug1) annotation(
      Line(points = {{30, -22.2}, {30, -2.498e-16}}, color = {0, 0, 255}));
    connect(G.positivePlug1, Rd.plug_n) annotation(
      Line(points = {{30, -60}, {30, -60}, {30, -60}, {30, -60}, {30, -42}, {30, -42}, {30, -42}, {30, -42}}, color = {0, 0, 255}));
    connect(SM03.Pk, B32.positivePlug2) annotation(
      Line(points = {{9.2, 0}, {17.2, 0}, {17.2, 0}, {25.2, 0}, {25.2, 0}, {26, 0}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Text(origin = {-20, 14}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-82, -112}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 12}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
      Diagram(graphics = {Text(origin = {31, 21}, lineColor = {255, 0, 0}, extent = {{-11, 9}, {11, -9}}, textString = "V1:0.98/_-28.3")}));
  end PowerPlant_03;

  model PowerPlant_04
    OpenEMTP.Connectors.Bus B33 annotation(
      Placement(visible = true, transformation(origin = {36, 30}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    OpenEMTP.Electrical.Transformers.YgD01 YgD2(D = 0.3, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.007, Rmg = 500, S = 1000, X = 0.142, f = 60, v1 = 369.15, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {64, 30}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(extent = {{88, 20}, {108, 40}}, rotation = 0), iconTransformation(extent = {{-110, -26}, {-90, -6}}, rotation = 0)));
    OpenEMTP.Electrical.Machines.SM_4thOrder SM04(F = 0, H = 2.86, Ifn = 2200, It_ss = {0, 0}, P = 2, Pn = 1000, Rs = 0, Tpdo = 5.69, Tpqo = 1.5, Vn = 20, Vt_ss = {1, -27.2}, X0 = 0.295, Xd = 2.62, Xls = 0.295, Xpd = 0.436, Xpq = 1.66, Xq = 2.58, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {-14, 30}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {46, -18}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {46, -46}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-52, 58}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-144, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-122, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST04(EFSS = 0.9999853331182158, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-78, 4}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder04(T = 0.01, k = 1, y_start = 0.9999999999999998) annotation(
      Placement(visible = true, transformation(origin = {-112, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(SM04.Vfd, ST04.EFD) annotation(
      Line(points = {{-28, 24}, {-40, 24}, {-40, 12}, {-68, 12}, {-68, 12}, {-66, 12}}, color = {0, 0, 127}));
    connect(ST04.IFD, SM04.Ifd_pu) annotation(
      Line(points = {{-70, -8}, {-68, -8}, {-68, -34}, {-8, -34}, {-8, 14}, {-6, 14}}, color = {0, 0, 127}));
    connect(firstOrder04.y, ST04.VC) annotation(
      Line(points = {{-100, -32}, {-80, -32}, {-80, -8}, {-80, -8}}, color = {0, 0, 127}));
    connect(firstOrder04.u, vdqToVt1.Ut) annotation(
      Line(points = {{-124, -32}, {-130, -32}, {-130, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(ST04.VT, vdqToVt1.Ut) annotation(
      Line(points = {{-90, -4}, {-132, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ud, SM04.Vd_pu) annotation(
      Line(points = {{-156, 2}, {-176, 2}, {-176, -54}, {-26, -54}, {-26, 14}}, color = {0, 0, 127}));
    connect(vdqToVt1.Uq, SM04.Vq_pu) annotation(
      Line(points = {{-156, -10}, {-166, -10}, {-166, -48}, {-18, -48}, {-18, 14}}, color = {0, 0, 127}));
    connect(ST04.VREF, ST04.VS) annotation(
      Line(points = {{-90, 12}, {-104, 12}, {-104, 4}, {-90, 4}, {-90, 4}}, color = {0, 0, 127}));
    connect(Vf.y, ST04.VS) annotation(
      Line(points = {{-114, 38}, {-104, 38}, {-104, 4}, {-90, 4}, {-90, 4}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.Pm, SM04.Pm_pu) annotation(
      Line(points = {{-41, 61}, {-36, 61}, {-36, 38}, {-28.4, 38}, {-28.4, 37.8}}, color = {0, 0, 127}));
    connect(SM04.W_pu, governor_IEEEG11.W) annotation(
      Line(points = {{-17.2, 46}, {-18, 46}, {-18, 76}, {-74, 76}, {-74, 66}, {-64, 66}, {-64, 65.4}}, color = {0, 0, 127}));
    connect(Rd.plug_p, B33.positivePlug2) annotation(
      Line(points = {{46, -8.2}, {46, -8.2}, {46, 30}, {38, 30}, {38, 30}}, color = {0, 0, 255}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{46, -28}, {46, -28}, {46, -36}, {46, -36}}, color = {0, 0, 255}));
    connect(B33.positivePlug1, SM04.Pk) annotation(
      Line(points = {{34, 30}, {2, 30}, {2, 30}, {1.2, 30}}, color = {0, 0, 255}));
    connect(YgD2.k, k) annotation(
      Line(points = {{74, 30}, {98, 30}}, color = {0, 0, 255}));
    connect(YgD2.m, B33.positivePlug2) annotation(
      Line(points = {{54, 30}, {38, 30}, {38, 30}, {38, 30}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(origin = {0, -16}, points = {{-80, 0}, {-80, 0}, {-88, 0}, {-96, 0}}, color = {28, 108, 200}), Text(origin = {-22, 4}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-78, 86}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-20, 2}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}),
      Diagram(graphics = {Text(origin = {38, 59}, lineColor = {255, 0, 0}, extent = {{-14, 7}, {14, -7}}, textString = "V1:1.00/_-27.2")}));
  end PowerPlant_04;

  model PowerPlant_05
    OpenEMTP.Connectors.Bus B34 annotation(
      Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    OpenEMTP.Electrical.Transformers.YgD01 YgD1(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.005, Rmg = 500, S = 600, X = 0.11, f = 60, v1 = 302.7, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {72, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(extent = {{90, -10}, {110, 10}}, rotation = 0), iconTransformation(extent = {{-10, 82}, {10, 102}}, rotation = 0)));
    OpenEMTP.Electrical.Machines.SM_4thOrder SM05(F = 0, H = 4.33, Ifn = 3300, It_ss = {0, 0}, P = 2, Pn = 600, Rs = 0, Tpdo = 5.4, Tpqo = 0.44, Vn = 20, Vt_ss = {1.01, -28.1}, X0 = 0.324, Xd = 4, Xls = 0.324, Xpd = 0.792, Xpq = 1, Xq = 3.7, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {4, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {50, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {50, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-30, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-144, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-122, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST04(EFSS = 1.009985186449398, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-78, 4}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder04(T = 0.01, k = 1, y_start = 1.0100000000000002) annotation(
      Placement(visible = true, transformation(origin = {-112, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(SM05.Vfd, ST04.EFD) annotation(
      Line(points = {{-10, -6}, {-40, -6}, {-40, 10}, {-68, 10}, {-68, 12}, {-66, 12}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ud, SM05.Vd_pu) annotation(
      Line(points = {{-156, 2}, {-184, 2}, {-184, -72}, {-8, -72}, {-8, -16}, {-8, -16}}, color = {0, 0, 127}));
    connect(vdqToVt1.Uq, SM05.Vq_pu) annotation(
      Line(points = {{-156, -10}, {-168, -10}, {-168, -62}, {0, -62}, {0, -16}, {0, -16}}, color = {0, 0, 127}));
    connect(ST04.IFD, SM05.Ifd_pu) annotation(
      Line(points = {{-70, -8}, {-70, -8}, {-70, -40}, {12, -40}, {12, -16}, {12, -16}}, color = {0, 0, 127}));
    connect(firstOrder04.u, vdqToVt1.Ut) annotation(
      Line(points = {{-124, -32}, {-130, -32}, {-130, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(firstOrder04.y, ST04.VC) annotation(
      Line(points = {{-100, -32}, {-80, -32}, {-80, -8}, {-80, -8}}, color = {0, 0, 127}));
    connect(ST04.VS, Vf.y) annotation(
      Line(points = {{-90, 4}, {-104, 4}, {-104, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(Vf.y, ST04.VREF) annotation(
      Line(points = {{-114, 38}, {-104, 38}, {-104, 12}, {-90, 12}, {-90, 12}}, color = {0, 0, 127}));
    connect(ST04.VT, vdqToVt1.Ut) annotation(
      Line(points = {{-90, -4}, {-132, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(SM05.W_pu, governor_IEEEG11.W) annotation(
      Line(points = {{0.8, 16}, {0, 16}, {0, 40}, {-52, 40}, {-52, 34}, {-42, 34}, {-42, 33.4}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.Pm, SM05.Pm_pu) annotation(
      Line(points = {{-19, 29}, {-16, 29}, {-16, 8}, {-10.4, 8}, {-10.4, 7.8}}, color = {0, 0, 127}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{50, -44}, {50, -44}, {50, -58}, {50, -58}}, color = {0, 0, 255}));
    connect(Rd.plug_p, B34.positivePlug2) annotation(
      Line(points = {{50, -24.2}, {50, -24.2}, {50, 0}, {46, 0}, {46, 0}}, color = {0, 0, 255}));
    connect(SM05.Pk, B34.positivePlug1) annotation(
      Line(points = {{19.2, 0}, {42, 0}, {42, 0}, {42, 0}}, color = {0, 0, 255}));
    connect(YgD1.k, k) annotation(
      Line(points = {{82, 0}, {98, 0}, {98, 0}, {100, 0}}, color = {0, 0, 255}));
    connect(YgD1.m, B34.positivePlug2) annotation(
      Line(points = {{62, 0}, {46, 0}, {46, 0}, {46, 0}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Text(origin = {-20, 16}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-78, -108}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 14}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360), Line(origin = {0, 79}, points = {{0, 3}, {0, -3}, {0, -3}})}, coordinateSystem(initialScale = 0.1)),
      Diagram(graphics = {Text(origin = {45, 25}, lineColor = {255, 0, 0}, extent = {{-11, 7}, {11, -7}}, textString = "V1:1.01/_-28.1")}));
  end PowerPlant_05;

  model PowerPlant_06
    OpenEMTP.Connectors.Bus B35 annotation(
      Placement(visible = true, transformation(origin = {46, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Transformers.YgD01 YgD6(D = 0.3, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.143, f = 60, v1 = 353.625, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {74, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(extent = {{90, -10}, {110, 10}}, rotation = 0), iconTransformation(extent = {{-10, -132}, {10, -112}}, rotation = 0)));
    OpenEMTP.Electrical.Machines.SM_4thOrder SM06(F = 0, H = 3.48, Ifn = 2200, It_ss = {0, 0}, P = 2, Pn = 1000, Rs = 0, Tpdo = 7.3, Tpqo = 0.4, Vn = 20, Vt_ss = {1.05, -25.7}, X0 = 0.224, Xd = 2.54, Xls = 0.224, Xpd = 0.5, Xpq = 0.814, Xq = 2.41, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {6, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {60, -36}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {60, -68}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-30, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-144, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-122, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST04(EFSS = 1.0499845997741266, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-78, 4}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder04(T = 0.01, k = 1, y_start = 1.05) annotation(
      Placement(visible = true, transformation(origin = {-112, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(SM06.Vfd, ST04.EFD) annotation(
      Line(points = {{-8, -6}, {-40, -6}, {-40, 10}, {-68, 10}, {-68, 12}, {-66, 12}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ud, SM06.Vd_pu) annotation(
      Line(points = {{-156, 2}, {-168, 2}, {-168, -60}, {-6, -60}, {-6, -16}, {-6, -16}}, color = {0, 0, 127}));
    connect(vdqToVt1.Uq, SM06.Vq_pu) annotation(
      Line(points = {{-156, -10}, {-160, -10}, {-160, -52}, {2, -52}, {2, -16}, {2, -16}}, color = {0, 0, 127}));
    connect(ST04.IFD, SM06.Ifd_pu) annotation(
      Line(points = {{-70, -8}, {-70, -8}, {-70, -40}, {14, -40}, {14, -16}, {14, -16}}, color = {0, 0, 127}));
    connect(firstOrder04.u, vdqToVt1.Ut) annotation(
      Line(points = {{-124, -32}, {-130, -32}, {-130, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(firstOrder04.y, ST04.VC) annotation(
      Line(points = {{-100, -32}, {-80, -32}, {-80, -8}, {-80, -8}}, color = {0, 0, 127}));
    connect(ST04.VS, Vf.y) annotation(
      Line(points = {{-90, 4}, {-102, 4}, {-102, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(ST04.VREF, Vf.y) annotation(
      Line(points = {{-90, 12}, {-102, 12}, {-102, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(ST04.VT, vdqToVt1.Ut) annotation(
      Line(points = {{-90, -4}, {-132, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.W, SM06.W_pu) annotation(
      Line(points = {{-42, 33.4}, {-46, 33.4}, {-46, 42}, {2, 42}, {2, 16}, {2.8, 16}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.Pm, SM06.Pm_pu) annotation(
      Line(points = {{-19, 29}, {-14, 29}, {-14, 8}, {-8.4, 8}, {-8.4, 7.8}}, color = {0, 0, 127}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{60, -46}, {60, -46}, {60, -58}, {60, -58}}, color = {0, 0, 255}));
    connect(B35.positivePlug1, Rd.plug_p) annotation(
      Line(points = {{48, 0}, {60, 0}, {60, -26.2}, {60, -26.2}}, color = {0, 0, 255}));
    connect(SM06.Pk, B35.positivePlug2) annotation(
      Line(points = {{21.2, 0}, {44, 0}, {44, 0}, {44, 0}}, color = {0, 0, 255}));
    connect(B35.positivePlug1, YgD6.m) annotation(
      Line(points = {{48, 0}, {64, 0}}, color = {0, 0, 255}));
    connect(YgD6.k, k) annotation(
      Line(points = {{84, 0}, {100, 0}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Text(origin = {-22, 0}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-78, 82}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-20, -2}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360), Line(points = {{0, -102}, {0, -114}}, color = {0, 0, 255})}),
      Diagram(graphics = {Text(origin = {45, 21}, lineColor = {255, 0, 0}, extent = {{-11, 9}, {11, -9}}, textString = "V1:1.05/_-25.7")}));
  end PowerPlant_06;

  model PowerPlant_07
    OpenEMTP.Connectors.Bus B36 annotation(
      Placement(visible = true, transformation(origin = {44, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 180)));
    OpenEMTP.Electrical.Transformers.YgD01 YgD1(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.005, Rmg = 500, S = 1000, X = 0.27, f = 60, v1 = 345, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {70, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(origin = {101, 0}, extent = {{9, -8}, {-9, 8}}, rotation = 0), iconTransformation(origin = {1, 93.5}, extent = {{-11, -11.5}, {11, 11.5}}, rotation = 0)));
    OpenEMTP.Electrical.Machines.SM_4thOrder SM07(F = 0, H = 2.64, Ifn = 2200, It_ss = {0, 0}, P = 2, Pn = 1000, Rs = 0, Tpdo = 5.66, Tpqo = 1.5, Vn = 20, Vt_ss = {1.06, -23}, X0 = 0.322, Xd = 2.95, Xls = 0.322, Xpd = 0.49, Xpq = 1.86, Xq = 2.92, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {4, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {52, -32}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {52, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-30, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-144, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-122, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST04(EFSS = 1.0599844531053089, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-78, 4}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder04(T = 0.01, k = 1, y_start = 1.0600000000000003) annotation(
      Placement(visible = true, transformation(origin = {-112, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(SM07.Vfd, ST04.EFD) annotation(
      Line(points = {{-10, -6}, {-46, -6}, {-46, 12}, {-66, 12}, {-66, 12}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ud, SM07.Vd_pu) annotation(
      Line(points = {{-156, 2}, {-174, 2}, {-174, -66}, {-8, -66}, {-8, -16}, {-8, -16}}, color = {0, 0, 127}));
    connect(vdqToVt1.Uq, SM07.Vq_pu) annotation(
      Line(points = {{-156, -10}, {-166, -10}, {-166, -60}, {-2, -60}, {-2, -16}, {0, -16}}, color = {0, 0, 127}));
    connect(ST04.IFD, SM07.Ifd_pu) annotation(
      Line(points = {{-70, -8}, {-70, -8}, {-70, -42}, {10, -42}, {10, -16}, {12, -16}}, color = {0, 0, 127}));
    connect(firstOrder04.y, ST04.VC) annotation(
      Line(points = {{-100, -32}, {-80, -32}, {-80, -8}, {-80, -8}}, color = {0, 0, 127}));
    connect(firstOrder04.u, vdqToVt1.Ut) annotation(
      Line(points = {{-124, -32}, {-128, -32}, {-128, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(ST04.VT, vdqToVt1.Ut) annotation(
      Line(points = {{-90, -4}, {-132, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(ST04.VS, Vf.y) annotation(
      Line(points = {{-90, 4}, {-100, 4}, {-100, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(Vf.y, ST04.VREF) annotation(
      Line(points = {{-114, 38}, {-100, 38}, {-100, 12}, {-90, 12}, {-90, 12}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.W, SM07.W_pu) annotation(
      Line(points = {{-42, 33.4}, {-54, 33.4}, {-54, 50}, {0, 50}, {0, 16}, {0.8, 16}}, color = {0, 0, 127}));
    connect(SM07.Pm_pu, governor_IEEEG11.Pm) annotation(
      Line(points = {{-10.4, 7.8}, {-14, 7.8}, {-14, 30}, {-19, 30}, {-19, 29}}, color = {0, 0, 127}));
    connect(Rd.plug_p, B36.positivePlug1) annotation(
      Line(points = {{52, -22.2}, {52, 0}, {46, 0}}, color = {0, 0, 255}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{52, -42}, {52, -42}, {52, -50}, {52, -50}}, color = {0, 0, 255}));
    connect(SM07.Pk, B36.positivePlug2) annotation(
      Line(points = {{19.2, 0}, {42, 0}, {42, 0}, {42, 0}}, color = {0, 0, 255}));
    connect(YgD1.m, B36.positivePlug1) annotation(
      Line(points = {{60, 0}, {46, 0}, {46, 0}, {46, 0}}, color = {0, 0, 255}));
    connect(k, YgD1.k) annotation(
      Line(points = {{101, 0}, {80, 0}, {80, 0}, {80, 0}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -110}, {100, 100}}, initialScale = 0.1), graphics = {Text(origin = {43, 19}, lineColor = {255, 0, 0}, extent = {{-13, 7}, {13, -7}}, textString = "V1:1.06/_-23.0")}),
      Icon(coordinateSystem(extent = {{-100, -110}, {100, 100}}, initialScale = 0.1), graphics = {Ellipse(origin = {-20, -10}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360), Text(origin = {-22, -8}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-140, -134}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Line(points = {{0, 82}, {0, 52}}, color = {0, 0, 255})}));
  end PowerPlant_07;

  model PowerPlant_08
    OpenEMTP.Electrical.Transformers.YgD01 YgD01(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.006, Rmg = 500, S = 1000, X = 0.23, f = 60, v1 = 353.625, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {72, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    OpenEMTP.Connectors.Bus B37 annotation(
      Placement(visible = true, transformation(origin = {50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(extent = {{92, -10}, {112, 10}}, rotation = 0), iconTransformation(extent = {{-10, -102}, {10, -82}}, rotation = 0)));
    OpenEMTP.Electrical.Machines.SM_4thOrder SM08(F = 0, H = 2.43, Ifn = 2200, It_ss = {0, 0}, P = 2, Pn = 1000, Rs = 0, Tpdo = 6.7, Tpqo = 0.41, Vn = 20, Vt_ss = {1.03, -29.1}, X0 = 0.28, Xd = 2.9, Xls = 0.28, Xpd = 0.57, Xpq = 0.911, Xq = 2.8, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {10, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {52, -34}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {52, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-30, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-144, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-122, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST04(EFSS = 1.0299848931117623, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-78, 4}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder04(T = 0.01, k = 1, y_start = 1.0300000000000002) annotation(
      Placement(visible = true, transformation(origin = {-112, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(SM08.Vfd, ST04.EFD) annotation(
      Line(points = {{-4, -6}, {-44, -6}, {-44, 12}, {-66, 12}, {-66, 12}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ud, SM08.Vd_pu) annotation(
      Line(points = {{-156, 2}, {-178, 2}, {-178, -60}, {0, -60}, {0, -16}, {-2, -16}}, color = {0, 0, 127}));
    connect(vdqToVt1.Uq, SM08.Vq_pu) annotation(
      Line(points = {{-156, -10}, {-166, -10}, {-166, -54}, {6, -54}, {6, -16}, {6, -16}}, color = {0, 0, 127}));
    connect(ST04.IFD, SM08.Ifd_pu) annotation(
      Line(points = {{-70, -8}, {-72, -8}, {-72, -42}, {16, -42}, {16, -16}, {18, -16}}, color = {0, 0, 127}));
    connect(firstOrder04.y, ST04.VC) annotation(
      Line(points = {{-100, -32}, {-80, -32}, {-80, -8}, {-80, -8}}, color = {0, 0, 127}));
    connect(firstOrder04.u, vdqToVt1.Ut) annotation(
      Line(points = {{-124, -32}, {-130, -32}, {-130, -4}, {-134, -4}, {-134, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(ST04.VT, vdqToVt1.Ut) annotation(
      Line(points = {{-90, -4}, {-132, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(ST04.VS, Vf.y) annotation(
      Line(points = {{-90, 4}, {-100, 4}, {-100, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(ST04.VREF, Vf.y) annotation(
      Line(points = {{-90, 12}, {-100, 12}, {-100, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.W, SM08.W_pu) annotation(
      Line(points = {{-42, 33.4}, {-54, 33.4}, {-54, 42}, {8, 42}, {8, 16}, {6.8, 16}}, color = {0, 0, 127}));
    connect(SM08.Pm_pu, governor_IEEEG11.Pm) annotation(
      Line(points = {{-4.4, 7.8}, {-12, 7.8}, {-12, 30}, {-19, 30}, {-19, 29}}, color = {0, 0, 127}));
    connect(Rd.plug_p, B37.positivePlug1) annotation(
      Line(points = {{52, -24.2}, {52, 0}}, color = {0, 0, 255}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{52, -44}, {52, -44}, {52, -52}, {52, -52}}, color = {0, 0, 255}));
    connect(SM08.Pk, B37.positivePlug2) annotation(
      Line(points = {{25.2, 0}, {48, 0}, {48, 0}, {48, 0}}, color = {0, 0, 255}));
    connect(YgD01.m, B37.positivePlug1) annotation(
      Line(points = {{62, 0}, {52, 0}}, color = {0, 0, 255}));
    connect(k, YgD01.k) annotation(
      Line(points = {{102, 0}, {82, 0}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Text(origin = {-20, 22}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-80, 96}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 20}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}, coordinateSystem(initialScale = 0.1)),
      Diagram(graphics = {Text(origin = {49, 17}, lineColor = {255, 0, 0}, extent = {{-13, 13}, {13, -13}}, textString = "V1:1.03/_-29.1")}));
  end PowerPlant_08;

  model PowerPlant_09
    OpenEMTP.Connectors.Bus B38 annotation(
      Placement(visible = true, transformation(origin = {40, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 180)));
    OpenEMTP.Electrical.Transformers.YgD01 YgD02(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.008, Rmg = 500, S = 1000, X = 0.156, f = 60, v1 = 353.625, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {68, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(extent = {{90, -10}, {110, 10}}, rotation = 0), iconTransformation(extent = {{-112, -28}, {-92, -8}}, rotation = 0)));
    Electrical.Machines.SM_4thOrder SM09(F = 0, H = 3.45, Ifn = 2200, It_ss = {0, 0}, P = 2, Pn = 1000, Rs = 0, Tpdo = 4.79, Tpqo = 1.96, Vn = 20, Vt_ss = {1.03, -23.5}, X0 = 0.298, Xd = 2.106, Xls = 0.298, Xpd = 0.57, Xpq = 0.587, Xq = 2.05, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {0, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {44, -26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {44, -44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-38, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-144, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-122, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST04(EFSS = 1.0299848931117623, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-78, 4}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder04(T = 0.01, k = 1, y_start = 1.0300000000000005) annotation(
      Placement(visible = true, transformation(origin = {-112, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(SM09.Vfd, ST04.EFD) annotation(
      Line(points = {{-14, -6}, {-52, -6}, {-52, 12}, {-66, 12}, {-66, 12}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ud, SM09.Vd_pu) annotation(
      Line(points = {{-156, 2}, {-174, 2}, {-174, -62}, {-12, -62}, {-12, -16}, {-12, -16}}, color = {0, 0, 127}));
    connect(vdqToVt1.Uq, SM09.Vq_pu) annotation(
      Line(points = {{-156, -10}, {-160, -10}, {-160, -54}, {-6, -54}, {-6, -16}, {-4, -16}}, color = {0, 0, 127}));
    connect(ST04.IFD, SM09.Ifd_pu) annotation(
      Line(points = {{-70, -8}, {-70, -8}, {-70, -40}, {6, -40}, {6, -16}, {8, -16}}, color = {0, 0, 127}));
    connect(firstOrder04.y, ST04.VC) annotation(
      Line(points = {{-100, -32}, {-80, -32}, {-80, -8}, {-80, -8}}, color = {0, 0, 127}));
    connect(firstOrder04.u, vdqToVt1.Ut) annotation(
      Line(points = {{-124, -32}, {-128, -32}, {-128, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(ST04.VT, vdqToVt1.Ut) annotation(
      Line(points = {{-90, -4}, {-132, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(ST04.VS, Vf.y) annotation(
      Line(points = {{-90, 4}, {-100, 4}, {-100, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(ST04.VREF, Vf.y) annotation(
      Line(points = {{-90, 12}, {-100, 12}, {-100, 38}, {-114, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(SM09.W_pu, governor_IEEEG11.W) annotation(
      Line(points = {{-3.2, 16}, {-4, 16}, {-4, 40}, {-56, 40}, {-56, 34}, {-50, 34}, {-50, 33.4}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.Pm, SM09.Pm_pu) annotation(
      Line(points = {{-27, 29}, {-20, 29}, {-20, 8}, {-14.4, 8}, {-14.4, 7.8}}, color = {0, 0, 127}));
    connect(Rd.plug_p, B38.positivePlug2) annotation(
      Line(points = {{44, -16.2}, {44, -16.2}, {44, 0}, {42, 0}, {42, 0}}, color = {0, 0, 255}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{44, -36}, {44, -36}, {44, -34}, {44, -34}}, color = {0, 0, 255}));
    connect(SM09.Pk, B38.positivePlug1) annotation(
      Line(points = {{15.2, 0}, {38, 0}, {38, 0}, {38, 0}}, color = {0, 0, 255}));
    connect(YgD02.m, B38.positivePlug2) annotation(
      Line(points = {{58, 0}, {42, 0}, {42, 0}, {42, 0}}, color = {0, 0, 255}));
    connect(YgD02.k, k) annotation(
      Line(points = {{78, 0}, {98, 0}, {98, 0}, {100, 0}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(origin = {0, -20}, points = {{-80, 0}, {-80, 0}, {-88, 0}, {-96, 0}}, color = {28, 108, 200}), Text(origin = {-22, 2}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-78, 80}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-20, 0}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}),
      Diagram(graphics = {Text(origin = {41, 23}, lineColor = {255, 0, 0}, extent = {{-9, 9}, {9, -9}}, textString = "V1:1.03/_-23.5")}));
  end PowerPlant_09;

  model PowerPlant_10
    OpenEMTP.Electrical.Transformers.YgD01 YgD5(D = 0.5, MD = [0.001, 1; 0.01, 1.075; 0.025, 1.15; 0.05, 1.2; 0.1, 1.23; 0.5, 1.37; 1, 1.55; 2, 1.86], R = 0.003, Rmg = 500, S = 1000, X = 0.18, f = 60, v1 = 353.625, v2 = 20) annotation(
      Placement(visible = true, transformation(origin = {72, 0}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    OpenEMTP.Connectors.Bus B30 annotation(
      Placement(visible = true, transformation(origin = {44, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(visible = true, transformation(extent = {{90, -10}, {110, 10}}, rotation = 0), iconTransformation(extent = {{-110, -28}, {-90, -8}}, rotation = 0)));
    Electrical.Machines.SM_4thOrder SM10(F = 0, H = 4.2, Ifn = 660, It_ss = {0, 0}, P = 2, Pn = 1000, Rs = 0, Tpdo = 10.2, Tpqo = 1e-10, Vn = 20, Vt_ss = {1.04, -34.6}, X0 = 0.125, Xd = 1, Xls = 0.125, Xpd = 0.31, Xpq = 0.08, Xq = 0.69, dw0 = 0, fn = 60) annotation(
      Placement(visible = true, transformation(origin = {14, 0}, extent = {{-15, -15}, {15, 15}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.R Rd(R = 1e6 * {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {48, -30}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    OpenEMTP.Electrical.RLC_Branches.MultiPhase.Ground G annotation(
      Placement(visible = true, transformation(origin = {48, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.Governor_IEEEG1 governor_IEEEG11(K = 20, K1 = 0.2, K2 = 0, K3 = 0.4, K4 = 0, K5 = 0.4, K6 = 0, K7 = 0, K8 = 0, PMAX = 0.9, PMIN = 0, Pref = 0, T1 = 1e-15, T2 = 0, T3 = 0.075, T4 = 0.3, T5 = 10, T6 = 0.6, T7 = 1e-15, U0 = 0.6786, UC = -1) annotation(
      Placement(visible = true, transformation(origin = {-30, 26}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    OpenEMTP.NonElectrical.Blocks.VdqToVt vdqToVt1 annotation(
      Placement(visible = true, transformation(origin = {-144, -4}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
    Modelica.Blocks.Sources.Constant Vf(k = 0) annotation(
      Placement(visible = true, transformation(origin = {-122, 38}, extent = {{-8, -8}, {8, 8}}, rotation = 0)));
    OpenEMTP.Electrical.Exciters_Governor.ST1 ST04(EFSS = 1.0399847464429446, KA = 200, KC = 0, KF = 0, TA = 0.015, TB = 10, TC = 1, TF = 1, VIMAX = 0.1, VIMIN = -0.1, VRMAX = 5, VRMIN = -5) annotation(
      Placement(visible = true, transformation(origin = {-78, 4}, extent = {{-35, -20}, {25, 15}}, rotation = 0)));
    Modelica.Blocks.Continuous.FirstOrder firstOrder04(T = 0.01, k = 1, y_start = 1.0400000000000003) annotation(
      Placement(visible = true, transformation(origin = {-112, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  equation
    connect(SM10.Vfd, ST04.EFD) annotation(
      Line(points = {{0, -6}, {-48, -6}, {-48, 12}, {-66, 12}, {-66, 12}}, color = {0, 0, 127}));
    connect(vdqToVt1.Ud, SM10.Vd_pu) annotation(
      Line(points = {{-156, 2}, {-174, 2}, {-174, -60}, {2, -60}, {2, -16}, {2, -16}}, color = {0, 0, 127}));
    connect(vdqToVt1.Uq, SM10.Vq_pu) annotation(
      Line(points = {{-156, -10}, {-166, -10}, {-166, -52}, {10, -52}, {10, -16}, {10, -16}}, color = {0, 0, 127}));
    connect(ST04.IFD, SM10.Ifd_pu) annotation(
      Line(points = {{-70, -8}, {-70, -8}, {-70, -40}, {20, -40}, {20, -16}, {22, -16}}, color = {0, 0, 127}));
    connect(firstOrder04.y, ST04.VC) annotation(
      Line(points = {{-100, -32}, {-80, -32}, {-80, -8}, {-80, -8}}, color = {0, 0, 127}));
    connect(firstOrder04.u, vdqToVt1.Ut) annotation(
      Line(points = {{-124, -32}, {-130, -32}, {-130, -4}, {-132, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(ST04.VREF, Vf.y) annotation(
      Line(points = {{-90, 12}, {-100, 12}, {-100, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(ST04.VS, Vf.y) annotation(
      Line(points = {{-90, 4}, {-100, 4}, {-100, 38}, {-114, 38}, {-114, 38}}, color = {0, 0, 127}));
    connect(ST04.VT, vdqToVt1.Ut) annotation(
      Line(points = {{-90, -4}, {-134, -4}, {-134, -4}, {-132, -4}}, color = {0, 0, 127}));
    connect(governor_IEEEG11.W, SM10.W_pu) annotation(
      Line(points = {{-42, 33.4}, {-54, 33.4}, {-54, 40}, {10, 40}, {10, 16}, {10.8, 16}}, color = {0, 0, 127}));
    connect(SM10.Pm_pu, governor_IEEEG11.Pm) annotation(
      Line(points = {{-0.4, 7.8}, {-12, 7.8}, {-12, 30}, {-19, 30}, {-19, 29}}, color = {0, 0, 127}));
    connect(Rd.plug_p, B30.positivePlug1) annotation(
      Line(points = {{48, -20.2}, {48, -20.2}, {48, 0}, {46, 0}, {46, 0}}, color = {0, 0, 255}));
    connect(Rd.plug_n, G.positivePlug1) annotation(
      Line(points = {{48, -40}, {48, -40}, {48, -50}, {48, -50}}, color = {0, 0, 255}));
    connect(B30.positivePlug2, SM10.Pk) annotation(
      Line(points = {{42, 0}, {30, 0}, {30, 0}, {29.2, 0}}, color = {0, 0, 255}));
    connect(YgD5.m, B30.positivePlug1) annotation(
      Line(points = {{62, 0}, {46, 0}}, color = {0, 0, 255}));
    connect(k, YgD5.k) annotation(
      Line(points = {{100, 0}, {82, 0}}, color = {0, 0, 255}));
    annotation(
      Icon(graphics = {Line(origin = {2.56881, -18.367}, points = {{-80, 0}, {-80, 0}, {-88, 0}, {-96, 0}}, color = {28, 108, 200}), Text(origin = {-20, 2}, lineColor = {0, 0, 255}, extent = {{-26, 26}, {72, -64}}, textString = "AC"), Text(origin = {-76, 84}, lineColor = {0, 0, 255}, extent = {{-52, 24}, {208, -14}}, textString = "%name"), Ellipse(origin = {-18, 0}, lineColor = {0, 0, 255}, extent = {{-60, 62}, {100, -100}}, endAngle = 360)}),
      Diagram(graphics = {Text(origin = {50, 24}, lineColor = {255, 0, 0}, extent = {{-12, 6}, {12, -6}}, textString = "V1:1.04/_-34.6")}));
  end PowerPlant_10;

  model Earth
    Electrical.RLC_Branches.MultiPhase.Ground G3 annotation(
      Placement(transformation(extent = {{8, -44}, {28, -24}})));
    Electrical.RLC_Branches.MultiPhase.R R(R = 1E6 * {1, 1, 1}) annotation(
      Placement(transformation(extent = {{-6, -26}, {14, -6}})));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug plug_p annotation(
      Placement(transformation(rotation = 0, extent = {{-5, 86}, {5, 106}}), iconTransformation(extent = {{-9, 90}, {10, 110}})));
  equation
    connect(R.plug_n, G3.positivePlug1) annotation(
      Line(points = {{14, -16}, {18, -16}, {18, -24}}, color = {0, 0, 255}));
    connect(plug_p, R.plug_p) annotation(
      Line(points = {{0, 96}, {-28, 96}, {-28, -16}, {-6, -16}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
      Icon(coordinateSystem(extent = {{-100, -100}, {100, 100}}), graphics = {Line(points = {{-60, 50}, {60, 50}}, color = {0, 0, 255}), Line(points = {{-40, 30}, {40, 30}}, color = {0, 0, 255}), Line(points = {{-20, 10}, {20, 10}}, color = {0, 0, 255}), Line(points = {{0, 90}, {0, 50}}, color = {0, 0, 255})}));
  end Earth;

  model PST
    parameter Real v1(unit = "kV RMSLL", start = 315) "Winding 1 voltage";
    parameter Real v2(unit = "kV RMSLL", start = 120) "Winding 2 voltage";
    final parameter Real Ratio = v2 / v1 * sqrt(3);
    OpenEMTP.Electrical.Transformers.IdealUnit IdealUnit_a(g = Ratio) annotation(
      Placement(visible = true, transformation(extent = {{-14, 30}, {6, 50}}, rotation = 0)));
    OpenEMTP.Electrical.Transformers.IdealUnit IdealUnit_b(g = Ratio) annotation(
      Placement(visible = true, transformation(extent = {{-14, -18}, {6, 2}}, rotation = 0)));
    OpenEMTP.Electrical.Transformers.IdealUnit IdealUnit_c(g = Ratio) annotation(
      Placement(visible = true, transformation(extent = {{-12, -62}, {8, -42}}, rotation = 0)));
    OpenEMTP.Connectors.Plug_a Plug_a annotation(
      Placement(visible = true, transformation(extent = {{-70, 38}, {-50, 58}}, rotation = 0)));
    OpenEMTP.Connectors.Plug_b Plug_b annotation(
      Placement(visible = true, transformation(extent = {{-70, -8}, {-50, 12}}, rotation = 0)));
    OpenEMTP.Connectors.Plug_c Plug_c annotation(
      Placement(visible = true, transformation(extent = {{-72, -52}, {-52, -32}}, rotation = 0)));
    OpenEMTP.Electrical.RLC_Branches.Ground G1 annotation(
      Placement(visible = true, transformation(extent = {{-28, -90}, {-8, -70}}, rotation = 0)));
    OpenEMTP.Connectors.Plug_a Plug_A annotation(
      Placement(visible = true, transformation(origin = {56, 50}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    OpenEMTP.Interfaces.MultiPhase.PositivePlug k annotation(
      Placement(visible = true, transformation(extent = {{-110, -8}, {-90, 12}}, rotation = 0), iconTransformation(extent = {{-110, -8}, {-90, 12}}, rotation = 0)));
    OpenEMTP.Interfaces.MultiPhase.PositivePlug m annotation(
      Placement(visible = true, transformation(extent = {{90, -8}, {110, 12}}, rotation = 0), iconTransformation(extent = {{90, -8}, {110, 12}}, rotation = 0)));
    OpenEMTP.Connectors.Plug_b Plug_B annotation(
      Placement(visible = true, transformation(origin = {56, 2}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
    OpenEMTP.Connectors.Plug_c Plug_C annotation(
      Placement(visible = true, transformation(origin = {56, -42}, extent = {{10, -10}, {-10, 10}}, rotation = 0)));
  equation
    connect(Plug_C.pin_p, IdealUnit_c.p2) annotation(
      Line(points = {{54, -41.8}, {8, -41.8}, {8, -41.8}}, color = {0, 140, 72}, thickness = 0.5));
    connect(Plug_B.pin_p, IdealUnit_b.p2) annotation(
      Line(points = {{54, 2.2}, {30, 2.2}, {30, 2.2}, {6, 2.2}, {6, 2.2}}, color = {0, 0, 255}, thickness = 0.5));
    connect(Plug_A.pin_p, IdealUnit_a.p2) annotation(
      Line(points = {{54, 50.2}, {6, 50.2}, {6, 50.2}}, color = {238, 46, 47}, thickness = 0.5));
    connect(Plug_C.plug_p, m) annotation(
      Line(points = {{58.2, -42}, {79.2, -42}, {79.2, -42}, {100.2, -42}, {100.2, 2}, {100.2, 2}}, color = {0, 140, 72}, thickness = 0.5));
    connect(Plug_B.plug_p, m) annotation(
      Line(points = {{58.2, 2}, {100.2, 2}, {100.2, 2}, {100.2, 2}}, color = {0, 0, 255}, thickness = 0.5));
    connect(Plug_A.plug_p, m) annotation(
      Line(points = {{58.2, 50}, {79.2, 50}, {79.2, 50}, {100.2, 50}, {100.2, 26}, {100.2, 26}, {100.2, 2}}, color = {238, 46, 47}, thickness = 0.5));
    connect(G1.p, IdealUnit_b.n1) annotation(
      Line(points = {{-18, -70}, {-18, -16}, {-16, -16}, {-16, -14}, {-14.5, -14}, {-14.5, -18}, {-14.25, -18}, {-14.25, -18}, {-14, -18}}));
    connect(Plug_c.plug_p, k) annotation(
      Line(points = {{-64.2, -42}, {-100, -42}, {-100, 2}}, color = {0, 140, 72}));
    connect(IdealUnit_c.p1, Plug_c.pin_p) annotation(
      Line(points = {{-12, -42}, {-20, -42}, {-20, -41.8}, {-60, -41.8}}, color = {0, 140, 72}));
    connect(IdealUnit_b.p1, Plug_b.pin_p) annotation(
      Line(points = {{-14, 2}, {-20, 2}, {-20, 2.2}, {-39, 2.2}, {-39, 2.2}, {-58, 2.2}}, color = {0, 0, 255}));
    connect(Plug_b.plug_p, k) annotation(
      Line(points = {{-62.2, 2}, {-100, 2}}, color = {0, 0, 255}));
    connect(IdealUnit_a.p1, Plug_a.pin_p) annotation(
      Line(points = {{-14, 50}, {-17, 50}, {-17, 48}, {-20, 48}, {-20, 48.2}, {-39, 48.2}, {-39, 48.2}, {-58, 48.2}}, color = {0, 0, 255}));
    connect(Plug_a.plug_p, k) annotation(
      Line(points = {{-62.2, 48}, {-81.15, 48}, {-81.15, 48}, {-100.1, 48}, {-100.1, 46}, {-100, 46}, {-100, 24}, {-100, 24}, {-100, 2}}, color = {238, 46, 47}));
    connect(IdealUnit_c.n1, IdealUnit_b.n1) annotation(
      Line(points = {{-12, -62}, {-18, -62}, {-18, -18}, {-14, -18}}, color = {0, 0, 255}));
    connect(IdealUnit_b.n2, IdealUnit_c.p2) annotation(
      Line(points = {{6, -18}, {20, -18}, {20, -42}, {8, -42}, {8, -42}}, color = {0, 140, 72}, thickness = 0.5));
    connect(IdealUnit_a.p2, IdealUnit_c.n2) annotation(
      Line(points = {{6, 50}, {23, 50}, {23, 50}, {40, 50}, {40, -62}, {8, -62}, {8, -62}}, color = {238, 46, 47}, thickness = 0.5));
    connect(IdealUnit_a.n1, IdealUnit_b.n1) annotation(
      Line(points = {{-14, 30}, {-14.5, 30}, {-14.5, 30}, {-15, 30}, {-15, 32}, {-16, 32}, {-16, 28}, {-18, 28}, {-18, -16}, {-16, -16}, {-16, -14}, {-15, -14}, {-15, -18}, {-14, -18}}));
    connect(IdealUnit_a.n2, IdealUnit_b.p2) annotation(
      Line(points = {{6, 30}, {13, 30}, {13, 30}, {20, 30}, {20, 2}, {6, 2}, {6, 2}}, color = {0, 0, 255}, thickness = 0.5));
    annotation(
      Documentation(info = "<html><head></head><body><p><br></p>
  </body></html>", revisions = "<html><head></head><body><div><i><br></i></div><ul>

  <li><em> 2019-12-01 &nbsp;&nbsp;</em>
       by Alireza Masoom initially implemented<br>
       </li>
  </ul>
  </body></html>"),
      defaultComponentName = "PST YgD01",
      Icon(graphics = {Text(origin = {-91, -25}, extent = {{-9, 9}, {9, -9}}, textString = "k"), Text(origin = {91, -23}, extent = {{-9, 9}, {9, -9}}, textString = "m"), Ellipse(origin = {42, 9}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Line(origin = {65.86, 0}, points = {{8.1422, 0}, {26.1422, 0}}, color = {0, 0, 255}), Line(points = {{-32, 0}, {-32, 10}}, color = {0, 0, 255}, thickness = 1), Line(points = {{-32, 0}, {-40, -8}}, color = {0, 140, 72}, thickness = 1), Line(points = {{-32, 0}, {-24, -8}}, color = {238, 46, 47}, thickness = 1), Line(origin = {-7.70642, -0.321101}, points = {{28, 8}, {28, -6}}, color = {28, 108, 200}, thickness = 1), Line(origin = {-1.92661, 0.642202}, points = {{22, 8}, {36, 0}}, color = {238, 46, 47}, thickness = 1), Line(origin = {-2.24771, -0.321101}, points = {{24, -6}, {36, 0}}, color = {0, 140, 72}, thickness = 1), Ellipse(origin = {-24, 9}, lineColor = {0, 0, 255}, extent = {{-48, -49}, {32, 35}}, endAngle = 360), Line(origin = {-85, 0}, points = {{13, 0}, {-5, 0}, {-5, 0}}, color = {0, 0, 255}), Text(origin = {-2, 8}, lineColor = {0, 0, 255}, extent = {{-150, 90}, {150, 50}}, textString = "%name"), Text(origin = {-31, -25}, extent = {{-9, 9}, {9, -9}}, textString = "1"), Text(origin = {37, -25}, extent = {{-9, 9}, {9, -9}}, textString = "2")}, coordinateSystem(initialScale = 0.1)),
      uses(Modelica(version = "3.2.3")),
      Diagram(graphics = {Text(origin = {-12, 92}, extent = {{-10, 8}, {42, -10}}, textString = "Phase Shift transformer"), Text(origin = {0, 82}, extent = {{-18, 6}, {18, -6}}, textString = "YgD-30 or YgD01")}, coordinateSystem(initialScale = 0.1)));
  end PST;

  model BRk
    Electrical.Switches.Breaker BRk1(Tclosing(displayUnit = "ms") = {0.45, 0.45, 0.45}, Topening = {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {-10, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Electrical.Switches.Breaker BRk2(Tclosing(displayUnit = "s") = {-1, -1, -1}, Topening(displayUnit = "ms") = {0.2, 0.2, 0.2}) annotation(
      Placement(visible = true, transformation(origin = {-30, -20}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(transformation(rotation = 0, extent = {{-12, 93}, {8, 103}}), iconTransformation(extent = {{-6, 94}, {8, 103}})));
    Modelica.Electrical.MultiPhase.Interfaces.NegativePlug m annotation(
      Placement(transformation(rotation = 0, extent = {{-12, -105}, {8, -95}}), iconTransformation(extent = {{-8, -106}, {8, -95}})));
  equation
    connect(BRk1.k, BRk2.k) annotation(
      Line(points = {{-10, -10}, {-30, -10}}, color = {0, 0, 255}));
    connect(BRk1.m, BRk2.m) annotation(
      Line(points = {{-10, -30}, {-30, -30}}, color = {0, 0, 255}));
    connect(k, BRk2.k) annotation(
      Line(points = {{-2, 98}, {-2, -10}, {-30, -10}}, color = {0, 0, 255}));
    connect(m, BRk2.m) annotation(
      Line(points = {{-2, -100}, {-2, -30}, {-30, -30}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {28, 108, 200}, extent = {{-100, 100}, {100, -100}}), Text(lineColor = {28, 108, 200}, extent = {{-38, 28}, {42, -30}}, textString = "BRk")}));
  end BRk;

  model BRm
    Electrical.Switches.Breaker BRm1(Tclosing(displayUnit = "ms") = {0.45, 0.45, 0.45}, Topening = {1, 1, 1}) annotation(
      Placement(visible = true, transformation(origin = {-10, -26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Electrical.Switches.Breaker BRm2(Tclosing = {-1, -1, -1}, Topening(displayUnit = "ms") = {0.2, 0.2, 0.2}) annotation(
      Placement(visible = true, transformation(origin = {-30, -26}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
    Modelica.Electrical.MultiPhase.Interfaces.PositivePlug k annotation(
      Placement(transformation(rotation = 0, extent = {{-12, 95}, {8, 105}}), iconTransformation(extent = {{-6, 92}, {8, 105}})));
    Modelica.Electrical.MultiPhase.Interfaces.NegativePlug m annotation(
      Placement(transformation(rotation = 0, extent = {{-14, -105}, {6, -95}}), iconTransformation(extent = {{-6, -106}, {6, -95}})));
  equation
    connect(BRm2.k, BRm1.k) annotation(
      Line(points = {{-30, -16}, {-10, -16}}, color = {0, 0, 255}));
    connect(BRm1.m, BRm2.m) annotation(
      Line(points = {{-10, -36}, {-30, -36}}, color = {0, 0, 255}));
    connect(k, BRm1.k) annotation(
      Line(points = {{-2, 100}, {-2, -16}, {-10, -16}}, color = {0, 0, 255}));
    connect(m, BRm2.m) annotation(
      Line(points = {{-4, -100}, {-4, -36}, {-30, -36}}, color = {0, 0, 255}));
    annotation(
      Diagram(coordinateSystem(extent = {{-100, -50}, {100, 50}})),
      Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(lineColor = {28, 108, 200}, extent = {{-100, 100}, {100, -100}}), Text(lineColor = {28, 108, 200}, extent = {{-32, 26}, {38, -32}}, textString = "BRm")}));
  end BRm;
end IEEE39BusCaseSM_CP;
