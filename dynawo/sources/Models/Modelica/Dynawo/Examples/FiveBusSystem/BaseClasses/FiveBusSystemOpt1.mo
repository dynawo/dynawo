within Dynawo.Examples.FiveBusSystem.BaseClasses;

model FiveBusSystemOpt1
  extends Dynawo.Examples.FiveBusSystem.BaseClasses.FiveBusSystemBase(gen.P0Pu = P0Gen1Pu, gen.Q0Pu = Q0Gen1Pu, gen.U0Pu = U0Gen1Pu, gen.UPhase0 = UPhase0Gen1, grid.UPu.start = 1.02);
  // Operating point 1
  parameter Types.ActivePowerPu P0Gen1Pu = -4.5;
  parameter Types.ReactivePowerPu Q0Gen1Pu = -0.68;
  parameter Types.VoltageModulePu U0Gen1Pu = 1;
  parameter Types.Angle UPhase0Gen1 = 0.2844;
  parameter Types.ActivePowerPu P0Load1Pu = 1.5;
  parameter Types.ReactivePowerPu Q0Load1Pu = 0.3;
  parameter Types.VoltageModulePu U0Load1Pu = 1.038;
  parameter Types.Angle UPhase0Load1 = 0.0314;
  parameter Types.ActivePowerPu P10TapTfo1Pu = 1.52;
  parameter Types.ReactivePowerPu Q10TapTfo1Pu = 0.5;
  parameter Types.VoltageModulePu U10TapTfo1Pu = 1.0154;
  parameter Types.Angle U1Phase0TapTfo1 = 0.1204;
  parameter Types.VoltageModulePu UGrid1Pu = 1.02;
  parameter Types.Angle UPhaseGrid1 = 0;
  // Load initialization model
  Dynawo.Electrical.Loads.LoadAlphaBetaTwoMotorSimplified_INIT load_INIT(ActiveMotorShare = ActiveMotorShare, RsPu = RsPu, RrPu = RrPu, XsPu = XsPu, XrPu = XrPu, XmPu = XmPu, P0Pu = P0Load1Pu, Q0Pu = Q0Load1Pu, U0Pu = U0Load1Pu, UPhase0 = UPhase0Load1);
  // Tap changer transformer initialization model
  //Dynawo.Electrical.Transformers.TransformerVariableTapPQ_INIT tfo_INIT(R = 0, X = 0.15 * 100, G = 0, B = 0, P10Pu = P10TapTfo1Pu, Q10Pu = Q10TapTfo1Pu, U10Pu = U10TapTfo1Pu, U1Phase0 = U1Phase0TapTfo1, NbTap = 33, SNom = 250, Uc20Pu = 1.0038, rTfoMaxPu = 1.2, rTfoMinPu = 0.88);
  Dynawo.Electrical.Transformers.TransformerVariableTapPQ_INIT tfo_INIT(R = 0, X = 0.15 * 100, G = 0, B = 0, P10Pu = 1.52, Q10Pu = 0.5, U10Pu = 1.0154, U1Phase0 = 0.1204, NbTap = 33, SNom = 250, Uc20Pu = 1.0038, rTfoMaxPu = 1.2, rTfoMinPu = 0.88);

initial algorithm
  load.ir0Pu[1].re := load_INIT.ir0Pu[1].re;
  load.ir0Pu[2].re := load_INIT.ir0Pu[2].re;
  load.ir0Pu[1].im := load_INIT.ir0Pu[1].im;
  load.ir0Pu[2].im := load_INIT.ir0Pu[2].im;
  load.is0Pu[1].re := load_INIT.is0Pu[1].re;
  load.is0Pu[2].re := load_INIT.is0Pu[2].re;
  load.is0Pu[1].im := load_INIT.is0Pu[1].im;
  load.is0Pu[2].im := load_INIT.is0Pu[2].im;
  load.im0Pu[1].re := load_INIT.im0Pu[1].re;
  load.im0Pu[2].re := load_INIT.im0Pu[2].re;
  load.im0Pu[1].im := load_INIT.im0Pu[1].im;
  load.im0Pu[2].im := load_INIT.im0Pu[2].im;
  load.s0 := load_INIT.s0;
  load.ce0Pu := load_INIT.ce0Pu;
  load.QLoad0Pu := load_INIT.QLoad0Pu;
  load.PLoad0Pu := load_INIT.PLoad0Pu;
  load.omegaR0Pu := load_INIT.omegaR0Pu;
  load.motori0Pu[1].re := load_INIT.motori0Pu[1].re;
  load.motori0Pu[1].im := load_INIT.motori0Pu[1].im;
  load.motori0Pu[2].re := load_INIT.motori0Pu[2].re;
  load.motori0Pu[2].im := load_INIT.motori0Pu[2].im;
  load.motors0Pu[1].re := load_INIT.motors0Pu[1].re;
  load.motors0Pu[1].im := load_INIT.motors0Pu[1].im;
  load.motors0Pu[2].re := load_INIT.motors0Pu[2].re;
  load.motors0Pu[2].im := load_INIT.motors0Pu[2].im;
  load.i0Pu.re := load_INIT.i0Pu.re;
  load.i0Pu.im := load_INIT.i0Pu.im;
  load.u0Pu.re := load_INIT.u0Pu.re;
  load.u0Pu.im := load_INIT.u0Pu.im;
  load.s0Pu.re := load_INIT.s0Pu.re;
  load.s0Pu.im := load_INIT.s0Pu.im;
  tfo.i10Pu.re := tfo_INIT.i10Pu.re;
  tfo.i10Pu.im := tfo_INIT.i10Pu.im;
  tfo.i20Pu.re := tfo_INIT.i20Pu.re;
  tfo.i20Pu.im := tfo_INIT.i20Pu.im;
  tfo.u10Pu.re := tfo_INIT.u10Pu.re;
  tfo.u10Pu.im := tfo_INIT.u10Pu.im;
  tfo.u20Pu.re := tfo_INIT.u20Pu.re;
  tfo.u20Pu.im := tfo_INIT.u20Pu.im;
  tfo.P10Pu := tfo_INIT.P10Pu;
  tfo.P10Pu := tfo_INIT.Q10Pu;
  tfo.U10Pu := tfo_INIT.U10Pu;
  tfo.U20Pu := tfo_INIT.U20Pu;
//tfo.rTfo0Pu := tfo_INIT.rTfo0Pu;

equation

grid.UPu = 1.02;
// Lines
  line1_3.switchOffSignal1.value = false;
  line1_3.switchOffSignal2.value = false;
  line1_3b.switchOffSignal1.value = false;
  line1_3b.switchOffSignal2.value = false;
  line3_4.switchOffSignal1.value = false;
  line3_4.switchOffSignal2.value = false;
  line3_4b.switchOffSignal1.value = false;
  line3_4b.switchOffSignal2.value = false;
// Tap Changer Automaton
  tap_changer.switchOffSignal1.value = false;
  tap_changer.switchOffSignal2.value = false;
// Tap Changer Transformer
  tfo.switchOffSignal1.value = false;
  tfo.switchOffSignal2.value = false;
  tap_changer.locked = if time < 1e-6 then true else false;
// Load
  load.switchOffSignal1.value = false;
  load.switchOffSignal2.value = false;
  load.PRefPu = 1.5;
  load.QRefPu = 0.3;
  load.deltaP = 0;
  load.deltaQ = 0;
  load.omegaRefPu = Omega0Pu.setPoint;
// Generator and regulations
  gen.switchOffSignal1.value = false;
  gen.switchOffSignal2.value = false;
  gen.switchOffSignal3.value = false;
  gen.omegaRefPu = Omega0Pu.setPoint;
// Generator Transformer
  generatorTransformer.switchOffSignal1.value = false;
  generatorTransformer.switchOffSignal2.value = false;
end FiveBusSystemOpt1;
