within Dynawo.Electrical.EMT;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

model IEEE_14bus
  Dynawo.Electrical.EMT.SignalVoltage Gen1;
  Dynawo.Electrical.EMT.SignalVoltage Gen2;
  Dynawo.Electrical.EMT.SignalVoltage Gen3;
  Dynawo.Electrical.EMT.SignalVoltage Gen6;
  Dynawo.Electrical.EMT.SignalVoltage Gen8;
  Dynawo.Electrical.EMT.Ground Grd1;
  Dynawo.Electrical.EMT.Ground Grd2;
  Dynawo.Electrical.EMT.Ground Grd3;
  Dynawo.Electrical.EMT.Ground Grd6;
  Dynawo.Electrical.EMT.Ground Grd8;
  Real sigGen1a, sigGen1b, sigGen1c;
  Real sigGen2a, sigGen2b, sigGen2c;
  Real sigGen3a, sigGen3b, sigGen3c;
  Real sigGen6a, sigGen6b, sigGen6c;
  Real sigGen8a, sigGen8b, sigGen8c;
  Dynawo.Electrical.EMT.Bus Bus1, Bus2, Bus3, Bus4, Bus5, Bus6, Bus7, Bus8, Bus9, Bus10, Bus11, Bus12, Bus13, Bus14;

  Dynawo.Electrical.EMT.RLBranchDisym LineB1B2(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB1B5(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB2B3(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB2B4(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB2B5(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB3B4(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB4B5(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB6B11(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB6B12(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB6B13(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB7B8(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB7B9(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB9B10(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB9B14(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB10B11(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB12B13(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);
  Dynawo.Electrical.EMT.RLBranchDisym LineB13B14(R11=3.749e-3, L11=1.989e-4); //C_PI=4.380e-5/160);

  Dynawo.Electrical.EMT.Ideal TransformerB4B7(V1n = 230000,V2n = 0.969*230000); //(m=0.969);
  Dynawo.Electrical.EMT.Ideal TransformerB4B9(V1n = 230000,V2n = 0.932*230000); //(m=0.932);
  Dynawo.Electrical.EMT.Ideal TransformerB5B6(V1n = 230000,V2n = 0.978*230000); //(m=0.978);
  Dynawo.Electrical.EMT.Ground GrdTransformerB4B7;
  Dynawo.Electrical.EMT.Ground GrdTransformerB4B9;
  Dynawo.Electrical.EMT.Ground GrdTransformerB5B6;

  Dynawo.Electrical.EMT.RVariable Load2;
  Dynawo.Electrical.EMT.RVariable Load3;
  Dynawo.Electrical.EMT.RVariable Load4;
  Dynawo.Electrical.EMT.RVariable Load5;
  Dynawo.Electrical.EMT.RVariable Load6;
  Dynawo.Electrical.EMT.RVariable Load9;
  Dynawo.Electrical.EMT.RVariable Load10;
  Dynawo.Electrical.EMT.RVariable Load11;
  Dynawo.Electrical.EMT.RVariable Load12;
  Dynawo.Electrical.EMT.RVariable Load13;
  Dynawo.Electrical.EMT.RVariable Load14;

  Real rLoad2;
  Real rLoad3;
  Real rLoad4;
  Real rLoad5;
  Real rLoad6;
  Real rLoad9;
  Real rLoad10;
  Real rLoad11;
  Real rLoad12;
  Real rLoad13;
  Real rLoad14;

  //Boolean load_variation(start=false);
  parameter Real tevent = 1;
  parameter Real r0 = 1;
  parameter Real rinf = 0.5;

  equation
  // Bus1
  sigGen1a = 1.060*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time);
  sigGen1b = 1.060*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 2*Modelica.Constants.pi/3);
  sigGen1c = 1.060*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time + 2*Modelica.Constants.pi/3);
  Gen1.v1 = sigGen1a;
  Gen1.v2 = sigGen1b;
  Gen1.v3 = sigGen1c;
  connect(Gen1.n,   Grd1.p);
  connect(Gen1.p,   Bus1.p);

  // Bus2
  sigGen2a = 1.045*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 4.98/180*Modelica.Constants.pi);
  sigGen2b = 1.045*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 4.98/180*Modelica.Constants.pi - 2*Modelica.Constants.pi/3);
  sigGen2c = 1.045*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 4.98/180*Modelica.Constants.pi + 2*Modelica.Constants.pi/3);
  Gen2.v1 = sigGen2a;
  Gen2.v2 = sigGen2b;
  Gen2.v3 = sigGen2c;
  connect(Gen2.n,   Grd2.p);
  connect(Gen2.p,   Bus2.p);

  rLoad2 = 1.0;
  Load2.R = rLoad2;
  connect(Load2.p,  Bus2.p);

  // Bus3
  sigGen3a = 1.010*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 12.72/180*Modelica.Constants.pi);
  sigGen3b = 1.010*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 12.72/180*Modelica.Constants.pi - 2*Modelica.Constants.pi/3);
  sigGen3c = 1.010*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 12.72/180*Modelica.Constants.pi + 2*Modelica.Constants.pi/3);
  Gen3.v1 = sigGen3a;
  Gen3.v2 = sigGen3b;
  Gen3.v3 = sigGen3c;
  connect(Gen3.n,   Grd3.p);
  connect(Gen3.p,   Bus3.p);

  rLoad3 = 1.0;
  Load3.R = rLoad3;
  connect(Load3.p,  Bus3.p);

  // Bus4
  rLoad4 = if time < 1 then 1.0 else 0.5 + 0.5*Modelica.Math.exp(-1000*(time-1));
  //when time >= tevent then
  //  load_variation = true;
  //  reinit(rLoad4, r0);
  //end when;
  //rLoad4 = if load_variation then rinf + (r0-rinf)*Modelica.Math.exp(-1000*(time-tevent)) else r0;
  Load4.R = rLoad4;
  connect(Load4.p,  Bus4.p);

  // Bus5
  rLoad5 = 1.0;
  Load5.R = rLoad5;
  connect(Load5.p,  Bus5.p);

  // Bus6
  sigGen6a = 1.070*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 14.22/180*Modelica.Constants.pi);
  sigGen6b = 1.070*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 14.22/180*Modelica.Constants.pi - 2*Modelica.Constants.pi/3);
  sigGen6c = 1.070*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 14.22/180*Modelica.Constants.pi + 2*Modelica.Constants.pi/3);
  Gen6.v1 = sigGen6a;
  Gen6.v2 = sigGen6b;
  Gen6.v3 = sigGen6c;
  connect(Gen6.n,   Grd6.p);
  connect(Gen6.p,   Bus6.p);

  rLoad6 = 1.0;
  Load6.R = rLoad6;
  connect(Load6.p,  Bus6.p);

  // Bus8
  sigGen8a = 1.090*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 13.36/180*Modelica.Constants.pi);
  sigGen8b = 1.090*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 13.36/180*Modelica.Constants.pi - 2*Modelica.Constants.pi/3);
  sigGen8c = 1.090*Modelica.Math.cos(Dynawo.Electrical.SystemBase.omegaNom*time - 13.36/180*Modelica.Constants.pi + 2*Modelica.Constants.pi/3);
  Gen8.v1 = sigGen8a;
  Gen8.v2 = sigGen8b;
  Gen8.v3 = sigGen8c;
  connect(Gen8.n,   Grd8.p);
  connect(Gen8.p,   Bus8.p);

  // Bus9
  rLoad9 = 1.0;
  Load9.R = rLoad9;
  connect(Load9.p,  Bus9.p);

  // Bus10
  rLoad10 = 1.0;
  Load10.R = rLoad10;
  connect(Load10.p, Bus10.p);

  // Bus11
  rLoad11 = 1.0;
  Load11.R = rLoad11;
  connect(Load11.p, Bus11.p);

  // Bus12
  rLoad12 = 1.0;
  Load12.R = rLoad12;
  connect(Load12.p, Bus12.p);

  // Bus13
  rLoad13 = 1.0;
  Load13.R = rLoad13;
  connect(Load13.p, Bus13.p);

  // Bus14
  rLoad14 = 1.0;
  Load14.R = rLoad14;
  connect(Load14.p, Bus14.p);

  // LineB1B2
  connect(Bus1.p,   LineB1B2.n);
  connect(Bus2.p,   LineB1B2.p);

  // LineB1B5
  connect(Bus1.p,   LineB1B5.n);
  connect(Bus5.p,   LineB1B5.p);

  // LineB2B3
  connect(Bus2.p,   LineB2B3.n);
  connect(Bus3.p,   LineB2B3.p);

  // LineB2B4
  connect(Bus2.p,   LineB2B4.n);
  connect(Bus4.p,   LineB2B4.p);

  // LineB2B5
  connect(Bus2.p,   LineB2B5.n);
  connect(Bus5.p,   LineB2B5.p);

  // LineB3B4
  connect(Bus3.p,   LineB3B4.n);
  connect(Bus4.p,   LineB3B4.p);

  // LineB4B5
  connect(Bus4.p,   LineB4B5.n);
  connect(Bus5.p,   LineB4B5.p);

  // TransformerB4B7
  connect(Bus4.p,   TransformerB4B7.p1);
  connect(Bus7.p,   TransformerB4B7.p2);
  connect(GrdTransformerB4B7.p, TransformerB4B7.n1);
  connect(GrdTransformerB4B7.p, TransformerB4B7.n2);

  // TransformerB4B9
  connect(Bus4.p,   TransformerB4B9.p1);
  connect(Bus9.p,   TransformerB4B9.p2);
  connect(GrdTransformerB4B9.p, TransformerB4B9.n1);
  connect(GrdTransformerB4B9.p, TransformerB4B9.n2);

  // TransformerB5B6
  connect(Bus5.p,   TransformerB5B6.p1);
  connect(Bus6.p,   TransformerB5B6.p2);
  connect(GrdTransformerB5B6.p, TransformerB5B6.n1);
  connect(GrdTransformerB5B6.p, TransformerB5B6.n2);

  // LineB6B11
  connect(Bus6.p,   LineB6B11.n);
  connect(Bus11.p,  LineB6B11.p);

  // LineB6B12
  connect(Bus6.p,   LineB6B12.n);
  connect(Bus12.p,  LineB6B12.p);

  // LineB6B13
  connect(Bus6.p,   LineB6B13.n);
  connect(Bus13.p,  LineB6B13.p);

  // LineB7B8
  connect(Bus7.p,   LineB7B8.n);
  connect(Bus8.p,   LineB7B8.p);

  // LineB7B9
  connect(Bus7.p,   LineB7B9.n);
  connect(Bus9.p,   LineB7B9.p);

  // LineB9B10
  connect(Bus9.p,   LineB9B10.n);
  connect(Bus10.p,  LineB9B10.p);

  // LineB9B14
  connect(Bus9.p,   LineB9B14.n);
  connect(Bus14.p,  LineB9B14.p);

  // LineB10B11
  connect(Bus10.p,  LineB10B11.n);
  connect(Bus11.p,  LineB10B11.p);

  // LineB12B13
  connect(Bus12.p,  LineB12B13.n);
  connect(Bus13.p,  LineB12B13.p);

  // LineB13B14
  connect(Bus13.p,  LineB13B14.n);
  connect(Bus14.p,  LineB13B14.p);


  annotation(preferredView = "text");
end IEEE_14bus;
