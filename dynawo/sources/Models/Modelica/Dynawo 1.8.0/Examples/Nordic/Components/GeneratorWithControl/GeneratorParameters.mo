within Dynawo.Examples.Nordic.Components.GeneratorWithControl;
record GeneratorParameters "Parameter sets for the generators of the Nordic 32 test system"

  type genFramePreset = enumeration(g01, g02, g03, g04, g05, g06, g07, g08, g09, g10, g11, g12, g13, g14, g15, g16, g17, g18, g19, g20) "Generator names";
  type vrParams = enumeration(IrLimPu, OelMode, tOelMin, KTgr, tLeadTgr, tLagTgr, EfdMaxPu, KPss, tDerOmega, tLeadPss, tLagPss) "Voltage regulator parameters";
  type govParams = enumeration(KSigma, Kp, Ki, PNom) "Governor parameters";
  type genParams = enumeration(SNom, PNom, RaPu, XlPu, XdPu, XqPu, XpdPu, XpqPu, XppdPu, XppqPu, Tpd0, Tpq0, Tppd0, Tppq0, H, nd, nq, md, mq) "Generator parameters";

  // Parameter tables
  // SNom, PNom, RaPu, XlPu, XdPu, XqPu, XpdPu, XpqPu, XppdPu, XppqPu, Tpd0, Tpq0, Tppd0, Tppq0, H, nd, nq, md, mq
  final constant Real[genFramePreset, genParams] genParamValues = {
  { 800.0,  760.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 600.0,  570.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 700.0,  665.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 600.0,  570.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 250.0,  237.5,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 400.0,  360.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1},
  { 200.0,  180.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1},
  { 850.0,  807.5,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  {1000.0,  950.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 800.0,  760.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 300.0,  285.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 350.0,  332.5,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  { 300.0,  285.0,  0.002, 0.15, 1.55, 1.00, 0.30, 0.8, 0.20, 0.20, 7.0, 1.0, 0.05, 0.10, 2.0, 6.0257, 6.0257, 0.1, 0.1},
  { 700.0,  630.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1},
  {1200.0, 1080.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1},
  { 700.0,  630.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1},
  { 600.0,  540.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1},
  {1200.0, 1080.0, 0.0015, 0.15, 2.20, 2.00, 0.30, 0.4, 0.20, 0.20, 7.0, 1.5, 0.05, 0.05, 6.0, 6.0257, 6.0257, 0.1, 0.1},
  { 500.0,  475.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1},
  {4500.0, 4275.0,  0.002, 0.15, 1.10, 0.70, 0.25, 1.0, 0.20, 0.20, 5.0, 1.0, 0.05, 0.10, 3.0, 6.0257, 6.0257, 0.1, 0.1}}
    "Matrix of generator parameters";                                                                                     // g01, Hydro
                                                                                                                          // g02, Hydro
                                                                                                                          // g03, Hydro
                                                                                                                          // g04, Hydro
                                                                                                                          // g05, Hydro
                                                                                                                          // g06, Thermal
                                                                                                                          // g07, Thermal
                                                                                                                          // g08, Hydro
                                                                                                                          // g09, Hydro
                                                                                                                          // g10, Hydro
                                                                                                                          // g11, Hydro
                                                                                                                          // g12, Hydro
                                                                                                                          // g13, Synch. cond.
                                                                                                                          // g14, Thermal
                                                                                                                          // g15, Thermal
                                                                                                                          // g16, Thermal
                                                                                                                          // g17, Thermal
                                                                                                                          // g18, Thermal
                                                                                                                          // g19, Hydro
                                                                                                                          // g20, Hydro

  // KSigma, Kp, Ki, PNom
  final constant Real[genFramePreset, govParams] govParamValues = {
  {0.04, 2, 0.4,  760.0},
  {0.04, 2, 0.4,  570.0},
  {0.04, 2, 0.4,  665.0},
  {0.04, 2, 0.4,  570.0},
  {0.04, 2, 0.4,  237.5},
  {0.00, 0, 0.0,  360.0},
  {0.00, 0, 0.0,  180.0},
  {0.04, 2, 0.4,  807.5},
  {0.04, 2, 0.4,  950.0},
  {0.04, 2, 0.4,  760.0},
  {0.04, 2, 0.4,  285.0},
  {0.04, 2, 0.4,  332.5},
  {0.00, 0, 0.0,  285.0},
  {0.00, 0, 0.0,  630.0},
  {0.00, 0, 0.0, 1080.0},
  {0.00, 0, 0.0,  630.0},
  {0.00, 0, 0.0,  540.0},
  {0.00, 0, 0.0, 1080.0},
  {0.08, 2, 0.4,  475.0},
  {0.08, 2, 0.4, 4275.0}}
    "Matrix of governor parameters";
                          // g01 Hydro power plant, with speed governor
                          // g02 Hydro
                          // g03 Hydro
                          // g04 Hydro
                          // g05 Hydro
                          // g06 Thermal power plant, constant mechanical power, no governor
                          // g07 Thermal
                          // g08 Hydro
                          // g09 Hydro
                          // g10 Hydro
                          // g11 Hydro
                          // g12 Hydro
                          // g13 Synchronous condenser, no governor
                          // g14 Thermal
                          // g15 Thermal
                          // g16 Thermal
                          // g17 Thermal
                          // g18 Thermal
                          // g19 Hydro
                          // g20 Hydro

  // IrLimPu, OelMode, tOelMin, KTgr, tLeadTgr, tLagTgr, EfdMaxPu, KPss, tDerOmega, tLeadPss, tLagPss
  final constant Real[genFramePreset, vrParams] vrParamValues = {
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0, 150.0, 15.0, 0.20, 0.010},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {3.0618, 1, -20.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012},
  {3.0618, 1, -20.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {1.8991, 1, -20.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {1.8991, 1, -20.0,  70.0, 10.0, 20.0, 4.0,  75.0, 15.0, 0.20, 0.010},
  {2.9579, 0, -17.0,  50.0,  4.0, 20.0, 4.0,   0.0,  1.0, 1.00, 1.000},
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012},
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012},
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0,  75.0, 15.0, 0.22, 0.012},
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0, 150.0, 15.0, 0.22, 0.012},
  {3.0618, 0, -18.0, 120.0,  5.0, 12.5, 5.0, 150.0, 15.0, 0.22, 0.012},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,   0.0,  1.0, 1.00, 1.000},
  {1.8991, 0, -11.0,  70.0, 10.0, 20.0, 4.0,   0.0,  1.0, 1.00, 1.000}}
    "Matrix of voltage regulator parameters";                           // g01
                                                                        // g02
                                                                        // g03
                                                                        // g04
                                                                        // g05
                                                                        // g06
                                                                        // g07
                                                                        // g08
                                                                        // g09
                                                                        // g10
                                                                        // g11
                                                                        // g12
                                                                        // g13
                                                                        // g14
                                                                        // g15
                                                                        // g16
                                                                        // g17
                                                                        // g18
                                                                        // g19
                                                                        // g20

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>The GeneratorParameters record keeps parameters for generators and their controllers in a parameter matrix. Values were taken from the IEEE Technical Report \"Test Systems for Voltage Stability Analysis and Security Assessment\" from August, 2015.<div>The matrices are designed to be used with a preset system, where the parameters are automatically assigned to the generator frame whose name is the preset.</div><div>To add a preset, append a vector to the matrices and add an entry in the generator enumeration.</div></body></html>"));
end GeneratorParameters;
