within Dynawo.Examples.Nordic.Components.GeneratorWithControl;

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

  type genFramePreset = enumeration(g01, g02, g03, g04, g05, g06, g07, g08, g09, g10, g11, g12, g13, g14, g15, g16, g17, g18, g19, g20) "Generator names";
  type vrParams = enumeration(IrLimPu, OelMode, tOelMin, KTgr, tLeadTgr, tLagTgr, EfdMaxPu, KPss, tDerOmega, tLeadPss, tLagPss) "Voltage regulator parameters";
  type govParams = enumeration(KSigma, Kp, Ki, PNom) "Governor parameters";
  type genParams = enumeration(SNom, PNom, RaPu, XlPu, XdPu, XqPu, XpdPu, XpqPu, XppdPu, XppqPu, Tpd0, Tpq0, Tppd0, Tppq0, H, nd, nq, md, mq) "Generator parameters";

  // Parameter tables
  // SNom, PNom, RaPu, XlPu, XdPu, XqPu, XpdPu, XpqPu, XppdPu, XppqPu, Tpd0, Tpq0, Tppd0, Tppq0, H, nd, nq, md, mq
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
  { 300.0,  285.0,  0.002, 0.15, 1.55, 1.00, 0.30, 0.8, 0.20, 0.20, 7.0, 1.0, 0.05, 0.10, 2.0, 6.0257, 6.0257, 0.1, 0.1}, // g13, Synch. cond.
  { 700.0,  630.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g14, Thermal
  {1200.0, 1080.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g15, Thermal
  { 700.0,  630.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g16, Thermal
  { 600.0,  540.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g17, Thermal
  {1200.0, 1080.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1}, // g18, Thermal
  { 500.0,  475.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}, // g19, Hydro
  {4500.0, 4275.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}  // g20, Hydro
  } "Matrix of generator parameters";

  // KSigma, Kp, Ki, PNom
  final constant Real[genFramePreset, govParams] govParamValues = {
  {0.04, 2, 0.4,  760.0}, // g01 Hydro power plant, with speed governor
  {0.04, 2, 0.4,  570.0}, // g02 Hydro
  {0.04, 2, 0.4,  665.0}, // g03 Hydro
  {0.04, 2, 0.4,  570.0}, // g04 Hydro
  {0.04, 2, 0.4,  237.5}, // g05 Hydro
  {0.00, 0, 0.0,  360.0}, // g06 Thermal power plant, constant mechanical power, no governor
  {0.00, 0, 0.0,  180.0}, // g07 Thermal
  {0.04, 2, 0.4,  807.5}, // g08 Hydro
  {0.04, 2, 0.4,  950.0}, // g09 Hydro
  {0.04, 2, 0.4,  760.0}, // g10 Hydro
  {0.04, 2, 0.4,  285.0}, // g11 Hydro
  {0.04, 2, 0.4,  332.5}, // g12 Hydro
  {0.00, 0, 0.0,  285.0}, // g13 Synchronous condenser, no governor
  {0.00, 0, 0.0,  630.0}, // g14 Thermal
  {0.00, 0, 0.0, 1080.0}, // g15 Thermal
  {0.00, 0, 0.0,  630.0}, // g16 Thermal
  {0.00, 0, 0.0,  540.0}, // g17 Thermal
  {0.00, 0, 0.0, 1080.0}, // g18 Thermal
  {0.08, 2, 0.4,  475.0}, // g19 Hydro
  {0.08, 2, 0.4, 4275.0}  // g20 Hydro
  } "Matrix of governor parameters";

  // IrLimPu, OelMode, tOelMin, KTgr, tLeadTgr, tLagTgr, EfdMaxPu, KPss, tDerOmega, tLeadPss, tLagPss
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

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The GeneratorParameters record keeps parameters for generators and their controllers in a parameter matrix. Values were taken from the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.<div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the generator frame whose name is the preset.</div><div>To add a preset, append a vector to the matrices and add an entry in the generator enumeration.</div></body></html>"));
end GeneratorParameters;
