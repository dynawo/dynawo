within Dynawo.Examples.Nordic.Data;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

record GeneratorParameters "Parameter sets for the generators of the Nordic 32 test system"
  import Dynawo;

  extends Dynawo.Examples.Nordic.Data.BaseClasses.OperatingPoints;

  //Generator parameters
  type genFramePreset = enumeration(g01, g02, g03, g04, g05, g06, g07, g08, g09, g10, g11, g12, g13, g14, g15, g16, g17, g18, g19, g20) "Generator names";
  type genInitParams = enumeration(P0Pu, Q0Pu, U0Pu, UPhase0) "Generator initial parameters";
  type genParams = enumeration(SNom, PNom, RaPu, XlPu, XdPu, XqPu, XpdPu, XpqPu, XppdPu, XppqPu, Tpd0, Tpq0, Tppd0, Tppq0, H, nd, nq, md, mq) "Generator parameters";

  //Regulation parameters
  type govParams = enumeration(KSigma, Kp, Ki) "Governor parameters";
  type vrParams = enumeration(IfLimPu, OelMode, tOelMin, KTgr, tLeadTgr, tLagTgr, EfdMaxPu, KPss, tDerOmega, tLeadPss, tLagPss) "Voltage regulator parameters";

  //Parameter tables
  //SNom, PNom, RaPu, XlPu, XdPu, XqPu, XpdPu, XpqPu, XppdPu, XppqPu, Tpd0, Tpq0, Tppd0, Tppq0, H, nd, nq, md, mq
  final constant Real[genFramePreset, genParams] genParamValues = {
  { 800.0,  760.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g01, Hydro
  { 600.0,  570.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g02, Hydro
  { 700.0,  665.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g03, Hydro
  { 600.0,  570.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g04, Hydro
  { 250.0,  237.5,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g05, Hydro
  { 400.0,  360.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g06, Thermal
  { 200.0,  180.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g07, Thermal
  { 850.0,  807.5,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g08, Hydro
  {1000.0,  950.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g09, Hydro
  { 800.0,  760.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g10, Hydro
  { 300.0,  285.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g11, Hydro
  { 350.0,  332.5,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g12, Hydro
  { 300.0,  285.0,  0.002, 0.15, 1.55, 1.00, 0.30, 0.8, 0.20, 0.20, 7.0, 1.0, 0.05, 0.10, 2.0, 6.0257, 6.0257, 0.1, 0.1}, // g13, Synch. Cond.
  { 700.0,  630.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g14, Thermal
  {1200.0, 1080.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g15, Thermal
  { 700.0,  630.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g16, Thermal
  { 600.0,  540.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g17, Thermal
  {1200.0, 1080.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g18, Thermal
  { 500.0,  475.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g19, Hydro
  {4500.0, 4275.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}  // g20, Hydro
  } "Matrix of generator parameters";

  //P0Pu, Q0Pu, U0Pu, UPhase0
  final constant Real[operatingPoints, genFramePreset, genInitParams] genInitValues = {{
  { -6.000, -0.583, 1.0684,  0.0451198}, // g01, Hydro
  { -3.000, -0.172, 1.0565,  0.0892985}, // g02, Hydro
  { -5.500, -0.209, 1.0595,  0.1793230}, // g03, Hydro
  { -4.000, -0.304, 1.0339,  0.1401024}, // g04, Hydro
  { -2.000, -0.601, 1.0294, -0.2157000}, // g05, Hydro
  { -3.600, -1.386, 1.0084, -1.0370640}, // g06, Thermal
  { -1.800, -0.604, 1.0141, -1.2034620}, // g07, Thermal
  { -7.500, -2.326, 1.0498, -0.2934664}, // g08, Hydro
  { -6.685, -2.013, 0.9988, -0.0284203}, // g09, Hydro
  { -6.000, -2.557, 1.0157,  0.0172395}, // g10, Hydro
  { -2.500, -0.607, 1.0211, -0.5068575}, // g11, Hydro
  { -3.100, -0.983, 1.0200, -0.5564212}, // g12, Hydro
  {  0.000, -0.501, 1.0170, -0.9476349}, // g13, Synch. Cond.
  { -6.300, -2.959, 1.0454, -0.8709245}, // g14, Thermal
  {-10.800, -3.779, 1.0455, -0.9109196}, // g15, Thermal
  { -6.000, -2.226, 1.0531, -1.1187980}, // g16, Thermal
  { -5.300, -0.487, 1.0092, -0.8177645}, // g17, Thermal
  {-10.600, -2.934, 1.0307, -0.7561356}, // g18, Thermal
  { -3.000, -1.212, 1.0300,  0.0004821}, // g19, Hydro
  {-21.374, -3.774, 1.0185,  0.0000000}  // g20, Hydro
  },{
  { -6.000, -0.583, 1.0684,  0.3357625}, // g01, Hydro
  { -3.000, -0.172, 1.0565,  0.3834501}, // g02, Hydro
  { -5.500, -0.209, 1.0595,  0.4717598}, // g03, Hydro
  { -4.000, -0.304, 1.0339,  0.5156572}, // g04, Hydro
  { -2.000, -0.601, 1.0294,  0.1717575}, // g05, Hydro
  { -3.600, -1.386, 1.0084, -0.3736484}, // g06, Thermal
  { -1.800, -0.604, 1.0141, -0.5398200}, // g07, Thermal
  { -7.500, -2.326, 1.0498,  0.2040711}, // g08, Hydro
  { -6.685, -2.013, 0.9988,  0.2687417}, // g09, Hydro
  { -6.000, -2.557, 1.0157,  0.3079371}, // g10, Hydro
  { -2.500, -0.607, 1.0211, -0.0237067}, // g11, Hydro
  { -3.100, -0.983, 1.0200, -0.0490099}, // g12, Hydro
  {  0.000, -0.501, 1.0170, -0.3598998}, // g13, Synch. Cond.
  { -6.300, -2.959, 1.0454, -0.2658439}, // g14, Thermal
  {-10.800, -3.779, 1.0455, -0.2806538}, // g15, Thermal
  { -6.000, -0.599, 1.0531, -0.3231256}, // g16, Thermal
  { -5.300, -0.487, 1.0092, -0.1855093}, // g17, Thermal
  {-10.600, -2.934, 1.0307, -0.1235155}, // g18, Thermal
  { -3.000, -1.212, 1.0300,  0.1293930}, // g19, Hydro
  {-15.374, -3.774, 1.0185,  0.0000000}  // g20, Hydro
  }} "Matrix of generator initial parameters";

  //KSigma, Kp, Ki
  final constant Real[genFramePreset, govParams] govParamValues = {
  {0.04,2,0.4}, // g01 Hydro power plant, with speed governor.
  {0.04,2,0.4}, // g02 Hydro
  {0.04,2,0.4}, // g03 Hydro
  {0.04,2,0.4}, // g04 Hydro
  {0.04,2,0.4}, // g05 Hydro
  {0.00,0,0.0}, // g06 Thermal power plant, constant mechanical Power, no governor.
  {0.00,0,0.0}, // g07 Thermal
  {0.04,2,0.4}, // g08 Hydro
  {0.04,2,0.4}, // g09 Hydro
  {0.04,2,0.4}, // g10 Hydro
  {0.04,2,0.4}, // g11 Hydro
  {0.04,2,0.4}, // g12 Hydro
  {0.00,0,0.0}, // g13 Synchronous Condenser, no governor.
  {0.00,0,0.0}, // g14 Thermal
  {0.00,0,0.0}, // g15 Thermal
  {0.00,0,0.0}, // g16 Thermal
  {0.00,0,0.0}, // g17 Thermal
  {0.00,0,0.0}, // g18 Thermal
  {0.08,2,0.4}, // g19 Hydro
  {0.08,2,0.4}  // g20 Hydro
  } "Matrix of governor parameters";

  //IfLimPu, OelMode, tOelMin, KTgr, tLeadTgr, tLagTgr, EfdMaxPu, KPss, tDerOmega, tLeadPss, tLagPss
  final constant Real[genFramePreset, vrParams] vrParamValues = {
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g01
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g02
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g03
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0, 150.0, 15.0, 0.20, 0.010}, // g04
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g05
  {3.0618, 1, -20.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012}, // g06
  {3.0618, 1, -20.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012}, // g07
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g08
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g09
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g10
  {1.8991, 1, -20.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g11
  {1.8991, 1, -20.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010}, // g12
  {2.9579, 0, -17.0,  50.0,  4.0, 20.0, 4.0,   0.0,  1.0, 1.00, 1.000}, // g13
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012}, // g14
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012}, // g15
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012}, // g16
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0, 150.0, 15.0, 0.22, 0.012}, // g17
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0, 150.0, 15.0, 0.22, 0.012}, // g18
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,   0.0,  1.0, 1.00, 1.000}, // g19
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,   0.0,  1.0, 1.00, 1.000}  // g20
  } "Matrix of voltage regulator parameters";

  annotation(
    preferredView = "text",
    Documentation(info = "<html><head></head><body>The GeneratorParameters record keeps parameters for generators and their controllers in a parameter matrix. Values were taken from the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.<div><br><div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the generator frame whose name is the preset.</div><div><br></div><div>To add a preset, append a vector to the matrices and add an entry in the generator enumeration.</div></div></body></html>"));
end GeneratorParameters;
