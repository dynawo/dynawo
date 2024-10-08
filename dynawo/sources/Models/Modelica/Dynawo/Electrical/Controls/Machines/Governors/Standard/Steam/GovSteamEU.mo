within Dynawo.Electrical.Controls.Machines.Governors.Standard.Steam;

model GovSteamEU "Governor type GovSteamEU"
  /*
  * Copyright (c) 2024, RTE (http://www.rte-france.com) and UPC/Citcea (https://www.citcea.upc.edu/)
  * See AUTHORS.txt
  * All rights reserved.
  * This Source Code Form is subject to the terms of the Mozilla Public
  * License, v. 2.0. If a copy of the MPL was not distributed with this
  * file, you can obtain one at 
  * SPDX-License-Identifier: 
  *
  * This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
  */
  // public parameters

  parameter Types.PerUnit CHcPu = -3.3 "Control valves rate closing limit in pu/s (base PNomTurb), typical value = -3.3" annotation( Dialog(tab = "Valves"));
  parameter Types.PerUnit CHoPu = 0.17 "Control valves rate opening limit in pu/s (base PNomTurb), typical value = 0.17" annotation( Dialog(tab = "Valves"));
  parameter Types.PerUnit CIcPu = -2.2 "Intercept valves rate closing limit in pu/s (base PNomTurb), typical value = -2.2" annotation( Dialog(tab = "Valves"));
  parameter Types.PerUnit CIoPu = 0.123 "Intercept valves rate opening limit in pu/s (base PNomTurb), typical value = 0.123" annotation( Dialog(tab = "Valves"));
  parameter Types.PerUnit DeltafDbPu = 0 "Deadband of the frequency corrector in pu (base fNom), typical value = 0" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.AngularVelocity DeltaOmegaDbPu = 0.0004 "Deadband of the speed governor in pu (base OmegaNom), typical value = 0.0004" annotation( Dialog(tab = "Islanded control"));
  parameter Types.PerUnit HHpMaxPu = 1 "Maximum control valve position in pu (base PNomTurb), typical value = 1" annotation( Dialog(tab = "Valves"));
  parameter Types.PerUnit KE = 0.65 "Governor controller proportional gain, typical value = 0.65" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.PerUnit KFCor = 20 "Frequency corrector gain, typical value = 20" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.PerUnit KHp = 0.277 "Turbine output gain for HP part, typical value = 0.277" annotation( Dialog(tab = "Turbine / boiler"));
  parameter Types.PerUnit KLp = 0.723 "Turbine output gain for LP part, typical value = 0.723" annotation( Dialog(tab = "Turbine / boiler"));
  parameter Types.PerUnit KOmegaCor = 20 "Speed governor gain, typical value = 20" annotation( Dialog(tab = "Islanded control"));
  parameter Types.AngularVelocity OmegaFMaxPu = 0.05 "Upper limit for frequency correction in pu (base OmegaNom), typical value = 0.05" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.AngularVelocity OmegaFMinPu = -0.05 "Lower limit for frequency correction in pu (base OmegaNom), typical value = -0.05" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.AngularVelocity OmegaMax1Pu = 1.025 "Emergency speed control lower limit in pu (base OmegaNom), typical value = 1.025" annotation( Dialog(tab = "Emergency control"));
  parameter Types.AngularVelocity OmegaMax2Pu = 1.05 "Emergency speed control upper limit in pu (base OmegaNom), typical value = 1.05" annotation( Dialog(tab = "Emergency control"));
  parameter Types.AngularVelocity OmegaOmegaMaxPu = 0.1 "Upper limit for the speed governor frequency correction in pu (base OmegaNom), typical value = 0.1" annotation( Dialog(tab = "Islanded control"));
  parameter Types.AngularVelocity OmegaOmegaMinPu = -1 "Lower limit for the speed governor frequency correction in pu (base OmegaNom), typical value = -1" annotation( Dialog(tab = "Islanded control"));
  parameter Types.ActivePowerPu PBaseMw "Base power of the machine in [MW, MVA], typical value = PNomTurb" annotation( Dialog(tab = "General"));
  parameter Types.ActivePowerPu PGenBaseMw = SystemBase.SnRef "Base power for measured electrical power in [MW, MVA], typical value = SystemBase.SnRef" annotation( Dialog(tab = "General"));
  parameter Types.ActivePowerPu PMaxPu = 1 "Maximal active power of the turbine in pu (base PNomTurb), typical value = 1" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.PerUnit PRhMaxPu = 1.4 "Maximum low pressure limit in pu (base PNomTurb), typical value = 1.4" annotation( Dialog(tab = "Turbine / boiler"));
  parameter Types.PerUnit SimxPu = 0.425 "Intercept valves transfer limit in pu (base PNomTurb), typical value = 0.425" annotation( Dialog(tab = "Emergency control"));
  parameter Types.Time tB = 100 "Boiler time constant in s, typical value = 100" annotation( Dialog(tab = "Turbine / boiler"));
  parameter Types.Time tCv = 0.1 "Control valves servo time constant in s, typical value = 0.1" annotation( Dialog(tab = "Valves"));
  parameter Types.Time tDp = 1e-9 "Power controller derivative time constant in s, typical value = 1e-9" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.Time tEht = 0.1 "Electro hydraulic transducer time constant in s, typical value = 0.1" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.Time tFt = 1e-9 "Frequency transducer time constant in s, typical value = 1e-9" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.Time tHpt = 0.31 "High pressure turbine time constant in s, typical value = 0.31" annotation( Dialog(tab = "Turbine / boiler"));
  parameter Types.Time tIPc = 2 "Power controller integral time constant in s, typical value = 2" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.Time tIv = 0.15 "Intercept valves servo time constant in s, typical value = 0.15" annotation( Dialog(tab = "Valves"));
  parameter Types.Time tLpt = 0.45 "Low pressure turbine time constant in s, typical value = 0.45" annotation( Dialog(tab = "Turbine / boiler"));
  parameter Types.Time tOmega = 0.02 "Speed transducer time constant in s, typical value = 0.02" annotation( Dialog(tab = "Islanded control"));
  parameter Types.Time tFp = 1e-9 "Power controller time constant in s, typical value = 1e-9" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.Time tPt = 0.07 "Power transducer time constant in s, typical value = 0.07" annotation( Dialog(tab = "Grid connected control"));
  parameter Types.Time tRh = 8 "Reheater time constant in s, typical value = 8" annotation( Dialog(tab = "Turbine / boiler"));

  // inputs, outputs
  Modelica.Blocks.Interfaces.RealInput fPu(start = SystemBase.omega0Pu) "Measured frequency of the grid in pu (base omegaRef0Pu/(2*pi))" annotation(Placement(visible = true, transformation(origin = {-155, 39}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -3}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput fRefPu(start = SystemBase.omegaRef0Pu) "Reference frequency in pu (base omegaRef0Pu/(2*pi))" annotation(Placement(visible = true, transformation(origin = {-155, 65}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, 17}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaPu(start = SystemBase.omega0Pu) "Measured angular velocity of the machine in pu (base omegaRef0Pu)" annotation(Placement(visible = true, transformation(origin = {-155, -63}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -69}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput OmegaRefPu(start = SystemBase.omegaRef0Pu) "Reference angular velocity of the machine in pu (base omegaRef0Pu)" annotation(Placement(visible = true, transformation(origin = {-155, -27}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-109, -49}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PGenPu(start = PGen0Pu) "Measured active electrical power generated by the machine in pu (base SystemBase.SnRef) (generator convention)" annotation(Placement(visible = true, transformation(origin = {-154, 98}, extent = {{-14, -14}, {14, 14}}, rotation = 0), iconTransformation(origin = {-109, 83}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput PmPu(start = Pm0Pu) "Mechanical power output in pu (base PNomTurb) (generator convention)" annotation(Placement(visible = true, transformation(origin = {530, -158}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {119, 1}, extent = {{-19, -19}, {19, 19}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput PRefPu(start = PRef0Pu) "Power reference value in pu (base PNomTurb) (generator convention)" annotation(Placement(visible = true, transformation(origin = {-156, 6}, extent = {{-16, -16}, {16, 16}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // blocks
  Modelica.Blocks.Math.Add addCtrlOp(k1 = +1, k2 = +1) annotation(Placement(visible = true, transformation(origin = {342, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addCv(k1 = -1, k2 = +1) annotation(Placement(visible = true, transformation(origin = {6, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addfRef(k1 = +1, k2 = -1) annotation(Placement(visible = true, transformation(origin = {-26, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add3 AddGovController(k1 = +1, k2 = +1, k3 = +1) annotation(Placement(visible = true, transformation(origin = {264, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addLpKHpPu annotation(Placement(visible = true, transformation(origin = {476, -158}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addOmegaOmegaRef(k1 = +1, k2 = -1) annotation(Placement(visible = true, transformation(origin = {120, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPe(k1 = -1, k2 = +1) annotation(Placement(visible = true, transformation(origin = {156, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPRef(k1 = +1, k2 = +1) annotation(Placement(visible = true, transformation(origin = {116, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPt1Boiler(k1 = -1, k2 = +1) annotation(Placement(visible = true, transformation(origin = {62, -158}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPt1Iv(k1 = -1, k2 = +1) annotation(Placement(visible = true, transformation(origin = {8, -294}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add addPt1Rh(k1 = -1, k2 = +1) annotation(Placement(visible = true, transformation(origin = {272, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTableEmergency(table = [0, 1; OmegaMax1Pu, 1; OmegaMax2Pu, 0; OmegaMax2Pu + 0.01, 0], tableOnFile = false) annotation(Placement(visible = true, transformation(origin = {240, -88}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Tables.CombiTable1D combiTableSimx(table = [0, 0; SimxPu, 1; 999999, 1]) annotation(Placement(visible = true, transformation(origin = {-56, -260}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Nonlinear.DeadZone deadZoneFrequency(uMax = DeltafDbPu)  annotation(Placement(visible = true, transformation(origin = {10, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.DeadZone deadZoneOmega(uMax = DeltaOmegaDbPu)  annotation(Placement(visible = true, transformation(origin = {168, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertEht(T = tEht, initType = Modelica.Blocks.Types.Init.InitialState, y_start = initPcPu)  annotation(Placement(visible = true, transformation(origin = {304, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertfT(T = tFt, initType = Modelica.Blocks.Types.Init.InitialState, y_start = SystemBase.omega0Pu)  annotation(Placement(visible = true, transformation(origin = {-64, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertHpt(T = tHpt, initType = Modelica.Blocks.Types.Init.InitialState, k = 1, y_start = Pm0Pu)  annotation(Placement(visible = true, transformation(origin = {214, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertLpt(T = tLpt, initType = Modelica.Blocks.Types.Init.InitialOutput, k = KLp, y_start = Pm0Pu *KLp) annotation(Placement(visible = true, transformation(origin = {428, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertOmega(T = tOmega, initType = Modelica.Blocks.Types.Init.InitialState, y_start = SystemBase.omega0Pu)  annotation(Placement(visible = true, transformation(origin = {46, -62}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrdertPT(T = tPt, initType = Modelica.Blocks.Types.Init.SteadyState, y_start = Pm0Pu)  annotation(Placement(visible = true, transformation(origin = {88, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainCv(k = 1/tCv)  annotation(Placement(visible = true, transformation(origin = {46, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainChangeBase(k = PGenBaseMw / PBaseMw)  annotation(Placement(visible = true, transformation(origin = {-6, 98}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainFCor(k = KFCor)  annotation(Placement(visible = true, transformation(origin = {46, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainIv(k = 1/tIv)  annotation(Placement(visible = true, transformation(origin = {46, -294}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKEPu(k = KE) annotation(Placement(visible = true, transformation(origin = {204, 78}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Gain gainKHpPu(k = KHp) annotation(Placement(visible = true, transformation(origin = {444, -130}, extent = {{-10, -10}, {10, 10}}, rotation = -90)));
  Modelica.Blocks.Math.Gain gainKOmegaCorPu(k = KOmegaCor) annotation(Placement(visible = true, transformation(origin = {214, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Integrator integratortB(initType = Modelica.Blocks.Types.Init.InitialState,k = 1/tB, y_start = initBPu) annotation(Placement(visible = true, transformation(origin = {108, -158}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegratorCv(initType = Modelica.Blocks.Types.Init.InitialState, k = 1, limitsAtInit = true,outMax = HHpMaxPu, outMin = 0, y_start = Pm0Pu/initBPu)  annotation(Placement(visible = true, transformation(origin = {124, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegratorIv(initType = Modelica.Blocks.Types.Init.InitialState, k = 1,outMax = 1, outMin = 0, y_start = 1)  annotation(Placement(visible = true, transformation(origin = {124, -294}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegratorPID(initType = Modelica.Blocks.Types.Init.InitialState,k = 1/tIPc,outMax = PMaxPu, outMin = 0, y_start = initPcPu)  annotation(  Placement(visible = true, transformation(origin = {206, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.LimIntegrator limIntegratortRh(initType = Modelica.Blocks.Types.Init.InitialState,k = 1/tRh, outMax = PRhMaxPu, outMin = 0, y_start = if tRh > 0.0 then Pm0Pu else 0.0) annotation(Placement(visible = true, transformation(origin = {330, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterCv(uMax = CHoPu, uMin = CHcPu) annotation(Placement(visible = true, transformation(origin = {86, -226}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterDeltaF(uMax = OmegaFMaxPu, uMin = OmegaFMinPu)  annotation(Placement(visible = true, transformation(origin = {78, 44}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterDeltaOmega(uMax = OmegaOmegaMaxPu, uMin = OmegaOmegaMinPu) annotation(Placement(visible = true, transformation(origin = {254, -32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterIv(uMax = CIoPu, uMin = CIcPu) annotation(Placement(visible = true, transformation(origin = {86, -294}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterP(uMax = PMaxPu, uMin = 0) annotation(Placement(visible = true, transformation(origin = {384, 38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Nonlinear.Limiter limiterP2(uMax = PMaxPu, uMin = 0) annotation(Placement(visible = true, transformation(origin = {460, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minEmergencyBoiler annotation(Placement(visible = true, transformation(origin = {14, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Min minEmergencyCv annotation(Placement(visible = true, transformation(origin = {424, 32}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product productCv annotation(Placement(visible = true, transformation(origin = {170, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Product productIv annotation(Placement(visible = true, transformation(origin = {388, -164}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.TransferFunction transferFunctDPctPc(a = {tFp, 1}, b = {tDp, 0}, initType = Modelica.Blocks.Types.Init.InitialState, y_start = 0) annotation(Placement(visible = true, transformation(origin = {206, 10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  // initial parameters
  parameter Types.ActivePowerPu PGen0Pu = Pm0Pu*PBaseMw/PGenBaseMw "Initial value of generated active electrical power in pu (base SystemBase.SnRef) (generator convention)";
  parameter Types.ActivePowerPu Pm0Pu "Initial value of mechanical power in pu (base PNomTurb) (generator convention)";
  final parameter Types.ActivePowerPu PRef0Pu = Pm0Pu;
  
protected
      // initialization helpers
      final parameter Types.PerUnit initBPu = 1 "Initialization helper for BPu";
      final parameter Types.PerUnit initPcPu = Pm0Pu - min(max(KOmegaCor * (SystemBase.omegaRef0Pu - SystemBase.omega0Pu), OmegaOmegaMinPu), OmegaOmegaMaxPu) "Initialization helper for PcPu";
equation
  connect(addfRef.y, deadZoneFrequency.u) annotation(Line(points = {{-15, 44}, {-2, 44}}, color = {0, 0, 127}));
  connect(addPRef.y, addPe.u2) annotation(Line(points = {{127, 38}, {144, 38}}, color = {0, 0, 127}));
  connect(gainKEPu.y, AddGovController.u1) annotation(Line(points = {{216, 78}, {232, 78}, {232, 52}, {252, 52}}, color = {0, 0, 127}));
  connect(addOmegaOmegaRef.y, deadZoneOmega.u) annotation(Line(points = {{131, -32}, {156, -32}}, color = {0, 0, 127}));
  connect(deadZoneOmega.y, gainKOmegaCorPu.u) annotation(Line(points = {{179, -32}, {202, -32}}, color = {0, 0, 127}));
  connect(gainKOmegaCorPu.y, limiterDeltaOmega.u) annotation(Line(points = {{225, -32}, {242, -32}}, color = {0, 0, 127}));
  connect(limiterDeltaOmega.y, addCtrlOp.u2) annotation(Line(points = {{265, -32}, {320, -32}, {320, 32}, {330, 32}}, color = {0, 0, 127}));
  connect(addCtrlOp.y, limiterP.u) annotation(Line(points = {{354, 38}, {372, 38}}, color = {0, 0, 127}));
  connect(limiterP.y, minEmergencyCv.u1) annotation(Line(points = {{395, 38}, {412, 38}}, color = {0, 0, 127}));
  connect(addLpKHpPu.y, PmPu) annotation(Line(points = {{487, -158}, {530, -158}}, color = {0, 0, 127}));
  connect(addPRef.y, minEmergencyBoiler.u1) annotation(Line(points = {{127, 38}, {136, 38}, {136, -8}, {-10, -8}, {-10, -158}, {2, -158}}, color = {0, 0, 127}));
  connect(minEmergencyBoiler.y, addPt1Boiler.u2) annotation(Line(points = {{25, -164}, {50, -164}}, color = {0, 0, 127}));
  connect(combiTableSimx.y[1], addPt1Iv.u2) annotation(Line(points = {{-56, -271}, {-56, -300}, {-4, -300}}, color = {0, 0, 127}));
  connect(gainKHpPu.y, addLpKHpPu.u1) annotation(Line(points = {{444, -140}, {444, -152}, {464, -152}}, color = {0, 0, 127}));
  connect(addPt1Boiler.y, integratortB.u) annotation(Line(points = {{73, -158}, {96, -158}}, color = {0, 0, 127}));
  connect(integratortB.y, productCv.u1) annotation(Line(points = {{119, -158}, {158, -158}}, color = {0, 0, 127}));
  connect(addPt1Rh.y, limIntegratortRh.u) annotation(Line(points = {{283, -164}, {318, -164}}, color = {0, 0, 127}));
  connect(limIntegratortRh.y, productIv.u1) annotation(Line(points = {{341, -164}, {360, -164}, {360, -158}, {376, -158}}, color = {0, 0, 127}));
  connect(firstOrdertHpt.y, addPt1Rh.u2) annotation(Line(points = {{226, -164}, {244, -164}, {244, -170}, {260, -170}}, color = {0, 0, 127}));
  connect(firstOrdertHpt.y, gainKHpPu.u) annotation(Line(points = {{226, -164}, {234, -164}, {234, -112}, {444, -112}, {444, -118}}, color = {0, 0, 127}));
  connect(limiterCv.y, limIntegratorCv.u) annotation(Line(points = {{98, -226}, {112, -226}}, color = {0, 0, 127}));
  connect(limIntegratorCv.y, productCv.u2) annotation(Line(points = {{135, -226}, {148, -226}, {148, -170}, {158, -170}}, color = {0, 0, 127}));
  connect(limiterIv.y, limIntegratorIv.u) annotation(Line(points = {{98, -294}, {112, -294}}, color = {0, 0, 127}));
  connect(limIntegratorIv.y, productIv.u2) annotation(Line(points = {{136, -294}, {362, -294}, {362, -170}, {376, -170}}, color = {0, 0, 127}));
  connect(deadZoneFrequency.y, gainFCor.u) annotation(Line(points = {{22, 44}, {34, 44}}, color = {0, 0, 127}));
  connect(gainFCor.y, limiterDeltaF.u) annotation(Line(points = {{58, 44}, {66, 44}}, color = {0, 0, 127}));
  connect(limiterDeltaF.y, addPRef.u1) annotation(Line(points = {{89, 44}, {104, 44}}, color = {0, 0, 127}));
  connect(firstOrdertfT.y, addfRef.u2) annotation(Line(points = {{-53, 38}, {-38, 38}}, color = {0, 0, 127}));
  connect(firstOrdertPT.y, addPe.u1) annotation(Line(points = {{99, 98}, {134, 98}, {134, 50}, {144, 50}}, color = {0, 0, 127}));
  connect(AddGovController.y, firstOrdertEht.u) annotation(Line(points = {{276, 44}, {292, 44}}, color = {0, 0, 127}));
  connect(firstOrdertEht.y, addCtrlOp.u1) annotation(Line(points = {{316, 44}, {330, 44}}, color = {0, 0, 127}));
  connect(fPu, firstOrdertfT.u) annotation(Line(points = {{-155, 39}, {-115, 39}, {-115, 38}, {-76, 38}}, color = {0, 0, 127}));
  connect(firstOrdertOmega.y, combiTableEmergency.u[1]) annotation(Line(points = {{57, -62}, {80, -62}, {80, -88}, {228, -88}}, color = {0, 0, 127}));
  connect(OmegaPu, firstOrdertOmega.u) annotation(Line(points = {{-155, -63}, {-61, -63}, {-61, -62}, {34, -62}}, color = {0, 0, 127}));
  connect(firstOrdertOmega.y, addOmegaOmegaRef.u2) annotation(Line(points = {{58, -62}, {80, -62}, {80, -38}, {108, -38}}, color = {0, 0, 127}));
  connect(limIntegratorPID.y, AddGovController.u2) annotation(Line(points = {{218, 44}, {252, 44}}, color = {0, 0, 127}));
  connect(productCv.y, addPt1Boiler.u1) annotation(Line(points = {{182, -164}, {192, -164}, {192, -128}, {42, -128}, {42, -152}, {50, -152}}, color = {0, 0, 127}));
  connect(limIntegratorCv.y, addCv.u1) annotation(Line(points = {{135, -226}, {142, -226}, {142, -200}, {-20, -200}, {-20, -220}, {-6, -220}}, color = {0, 0, 127}));
  connect(limIntegratorIv.y, addPt1Iv.u1) annotation(Line(points = {{136, -294}, {148, -294}, {148, -270}, {-18, -270}, {-18, -288}, {-4, -288}}, color = {0, 0, 127}));
  connect(transferFunctDPctPc.y, AddGovController.u3) annotation(Line(points = {{218, 10}, {236, 10}, {236, 36}, {252, 36}}, color = {0, 0, 127}));
  connect(addPe.y, gainKEPu.u) annotation(Line(points = {{168, 44}, {180, 44}, {180, 78}, {192, 78}}, color = {0, 0, 127}));
  connect(addPe.y, limIntegratorPID.u) annotation(Line(points = {{168, 44}, {194, 44}}, color = {0, 0, 127}));
  connect(addPe.y, transferFunctDPctPc.u) annotation(Line(points = {{168, 44}, {180, 44}, {180, 10}, {194, 10}}, color = {0, 0, 127}));
  connect(PRefPu, addPRef.u2) annotation(Line(points = {{-156, 6}, {94, 6}, {94, 32}, {104, 32}}, color = {0, 0, 127}));
  connect(productIv.y, addPt1Rh.u1) annotation(Line(points = {{400, -164}, {406, -164}, {406, -124}, {250, -124}, {250, -158}, {260, -158}}, color = {0, 0, 127}));
  connect(productIv.y, firstOrdertLpt.u) annotation(Line(points = {{400, -164}, {416, -164}}, color = {0, 0, 127}));
  connect(firstOrdertLpt.y, addLpKHpPu.u2) annotation(Line(points = {{440, -164}, {464, -164}}, color = {0, 0, 127}));
  connect(gainCv.y, limiterCv.u) annotation(Line(points = {{58, -226}, {74, -226}}, color = {0, 0, 127}));
  connect(addCv.y, gainCv.u) annotation(Line(points = {{18, -226}, {34, -226}}, color = {0, 0, 127}));
  connect(addPt1Iv.y, gainIv.u) annotation(Line(points = {{20, -294}, {34, -294}}, color = {0, 0, 127}));
  connect(gainIv.y, limiterIv.u) annotation(Line(points = {{58, -294}, {74, -294}}, color = {0, 0, 127}));
  connect(minEmergencyCv.y, limiterP2.u) annotation(Line(points = {{436, 32}, {448, 32}}, color = {0, 0, 127}));
  connect(productCv.y, firstOrdertHpt.u) annotation(Line(points = {{182, -164}, {202, -164}}, color = {0, 0, 127}));
  connect(combiTableEmergency.y[1], minEmergencyCv.u2) annotation(Line(points = {{252, -88}, {406, -88}, {406, 26}, {412, 26}}, color = {0, 0, 127}));
  connect(combiTableEmergency.y[1], minEmergencyBoiler.u2) annotation(Line(points = {{252, -88}, {268, -88}, {268, -104}, {-24, -104}, {-24, -170}, {2, -170}}, color = {0, 0, 127}));
  connect(limiterP2.y, combiTableSimx.u[1]) annotation(Line(points = {{472, 32}, {486, 32}, {486, -108}, {-56, -108}, {-56, -248}}, color = {0, 0, 127}));
  connect(limiterP2.y, addCv.u2) annotation(Line(points = {{472, 32}, {486, 32}, {486, -108}, {-56, -108}, {-56, -232}, {-6, -232}}, color = {0, 0, 127}));
  connect(PGenPu, gainChangeBase.u) annotation(Line(points = {{-154, 98}, {-18, 98}}, color = {0, 0, 127}));
  connect(gainChangeBase.y, firstOrdertPT.u) annotation(Line(points = {{6, 98}, {76, 98}}, color = {0, 0, 127}));
  connect(OmegaRefPu, addOmegaOmegaRef.u1) annotation(Line(points = {{-155, -27}, {108, -27}, {108, -26}}, color = {0, 0, 127}));
  connect(fRefPu, addfRef.u1) annotation(Line(points = {{-154, 66}, {-44, 66}, {-44, 50}, {-38, 50}}, color = {0, 0, 127}));
  annotation(Diagram(coordinateSystem(extent = {{-140, 120}, {520, -340}}), graphics = {Text(extent = {{350, -236}, {350, -236}}, textString = "text"), Text(origin = {324, -119}, extent = {{-38, -1}, {38, 1}}, textString = "Reheater"), Text(origin = {70, -265}, extent = {{-40, 3}, {40, -3}}, textString = "Intercept Valves"), Text(origin = {64, -195}, extent = {{-40, 3}, {40, -3}}, textString = "Control Valves"), Text(origin = {106, -125}, extent = {{-40, 3}, {40, -3}}, textString = "Boiler"), Text(origin = {216, -185}, extent = {{-40, 3}, {40, -3}}, textString = "HP Part"), Text(origin = {428, -185}, extent = {{-40, 3}, {40, -3}}, textString = "LP Part"), Text(origin = {-6468, 1560}, extent = {{196, 104}, {34, -14}}, textString = "text"), Text(origin = {206, 100}, extent = {{-20, 10}, {20, -10}}, textString = "PID Power Controller"), Text(origin = {10, 65}, extent = {{-16, 5}, {16, -5}}, textString = "Frequency Correction"), Rectangle(origin = {206, 45}, lineColor = {0, 85, 255}, lineThickness = 0.75, extent = {{-34, 49}, {34, -49}}), Text(origin = {136, 41}, extent = {{-4, 3}, {4, -3}}, textString = "PSet"), Text(origin = {304, 65}, extent = {{-16, 5}, {16, -5}}, textString = "Electro Hydraulic Transducer")}),
    Documentation,
    Icon(graphics = {Rectangle(extent = {{-100, 100}, {100, -100}}), Text(origin = {7, 15}, extent = {{1, 3}, {-1, -3}}, textString = "GOVSTEAMEU", textStyle = {TextStyle.Bold}), Text(origin = {5, 4}, extent = {{-81, 18}, {81, -18}}, textString = "GovSteamEU")}, coordinateSystem(extent = {{-100, -100}, {100, 100}})));


end GovSteamEU;
