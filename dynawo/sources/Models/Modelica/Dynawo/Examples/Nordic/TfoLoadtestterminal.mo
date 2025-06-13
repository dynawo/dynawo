within Dynawo.Examples.Nordic;

model TfoLoadtestterminal
  tfotest Tfotest(SNom = 600, R = 1, X = 1, G = 0, B = 0, rTfoPu = 1, u10Pu(re(fixed = false), im(fixed = false)), i10Pu(re(fixed = false), im(fixed = false)), u20Pu(re(fixed = false), im(fixed = false)), i20Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  loadtest Loadtest(u0Pu(re(fixed = false), im(fixed = false)), i0Pu(re(fixed = false), im(fixed = false)), s0Pu(re(fixed = false), im(fixed = false))) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  loadinittestterminal Loadinittest annotation(
    Placement(transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}})));
  tfoinittestterminal Tfoinittest(SNom = 600, R = 1, X = 1, G = 0, B = 0, P10Pu = -3, Q10Pu = -0.838, U10Pu = 1.00276, U1Phase0 = -0.136144, rTfoPu = 1) annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}})));
  Electrical.Buses.InfiniteBus infiniteBus(UPu = 1.00276, UPhase = -0.136144) annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

initial algorithm
  Loadtest.i0Pu.re := Loadinittest.terminal.i.re;
  Loadtest.i0Pu.im := Loadinittest.terminal.i.im;
  Loadtest.u0Pu.re := Loadinittest.terminal.V.re;
  Loadtest.u0Pu.im := Loadinittest.terminal.V.im;
  Loadtest.s0Pu.re := Loadinittest.s0Pu.re;
  Loadtest.s0Pu.im := Loadinittest.s0Pu.im;
  Tfotest.i10Pu.re := Tfoinittest.i10Pu.re;
  Tfotest.i10Pu.im := Tfoinittest.i10Pu.im;
  Tfotest.u10Pu.re := Tfoinittest.u10Pu.re;
  Tfotest.u10Pu.im := Tfoinittest.u10Pu.im;
  Tfotest.i20Pu.re := Tfoinittest.terminal2.i.re;
  Tfotest.i20Pu.im := Tfoinittest.terminal2.i.im;
  Tfotest.u20Pu.re := Tfoinittest.terminal2.V.re;
  Tfotest.u20Pu.im := Tfoinittest.terminal2.V.im;

equation
  Loadtest.PPu = 3;
  Loadtest.QPu = 0.838;
  connect(Tfoinittest.terminal2, Loadinittest.terminal);
  connect(Tfotest.terminal2, Loadtest.terminal) annotation(
    Line(points = {{-40, 0}, {30, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, Tfotest.terminal1) annotation(
    Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}));

end TfoLoadtestterminal;
