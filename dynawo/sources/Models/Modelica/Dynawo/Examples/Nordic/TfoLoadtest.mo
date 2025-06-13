within Dynawo.Examples.Nordic;

model TfoLoadtest
  tfotest Tfotest(SNom = 600, R = 1, X = 1, G = 0, B = 0, rTfoPu = 1, u10Pu(re(fixed=false),im(fixed=false)), i10Pu(re(fixed=false),im(fixed=false)), u20Pu(re(fixed=false),im(fixed=false)), i20Pu(re(fixed=false),im(fixed=false)))  annotation(
    Placement(transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}})));
  loadtest Loadtest(u0Pu(re(fixed=false),im(fixed=false)), i0Pu(re(fixed=false),im(fixed=false)), s0Pu(re(fixed=false),im(fixed=false))) annotation(
    Placement(transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}})));
  loadinittest Loadinittest annotation(
    Placement(transformation(origin = {30, 50}, extent = {{-10, -10}, {10, 10}})));
  tfoinittest Tfoinittest(SNom = 600, R = 1, X = 1, G = 0, B = 0, P10Pu = -3, Q10Pu = -0.838, U10Pu = 1.00276, U1Phase0 = -0.136144, rTfoPu = 1)  annotation(
    Placement(transformation(origin = {-50, 50}, extent = {{-10, -10}, {10, 10}})));
  Dynawo.Electrical.Buses.InfiniteBus infiniteBus(UPu = 1.00276, UPhase = -0.136144)  annotation(
    Placement(transformation(origin = {-100, 0}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));

initial algorithm
Loadtest.i0Pu.re := Loadinittest.i0Pu.re;
Loadtest.i0Pu.im := Loadinittest.i0Pu.im;
Loadtest.u0Pu.re := Loadinittest.u0Pu.re;
Loadtest.u0Pu.im := Loadinittest.u0Pu.im;
Loadtest.s0Pu.re := Loadinittest.s0Pu.re;
Loadtest.s0Pu.im := Loadinittest.s0Pu.im;
Tfotest.i10Pu.re := Tfoinittest.i10Pu.re;
Tfotest.i10Pu.im := Tfoinittest.i10Pu.im;
Tfotest.u10Pu.re := Tfoinittest.u10Pu.re;
Tfotest.u10Pu.im := Tfoinittest.u10Pu.im;
Tfotest.i20Pu.re := Tfoinittest.i20Pu.re;
Tfotest.i20Pu.im := Tfoinittest.i20Pu.im;
Tfotest.u20Pu.re := Tfoinittest.u20Pu.re;
Tfotest.u20Pu.im := Tfoinittest.u20Pu.im;

equation
  Loadtest.PPu = 3;
  Loadtest.QPu = 0.838;
  connect(Tfoinittest.i20Pu, Loadinittest.i0Pu);
  connect(Tfoinittest.u20Pu, Loadinittest.u0Pu);
  connect(Tfotest.terminal2, Loadtest.terminal) annotation(
    Line(points = {{-40, 0}, {30, 0}}, color = {0, 0, 255}));
  connect(infiniteBus.terminal, Tfotest.terminal1) annotation(
    Line(points = {{-100, 0}, {-60, 0}}, color = {0, 0, 255}));

end TfoLoadtest;
