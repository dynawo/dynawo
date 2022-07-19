within Dynawo.Electrical.Controls.IEC.BaseControls;

/*
* Copyright (c) 2022, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source suite of simulation tools for power systems.
*/

model Measurements "Measurement module for wind turbine controls (IEC N°61400-27-1)"
  import Modelica;
  import Modelica.ComplexMath;
  import Dynawo;
  import Dynawo.Types;
  import Dynawo.Electrical.SystemBase;

  //Nominal parameters
  parameter Types.ApparentPowerModule SNom "Nominal converter apparent power in MVA";
  parameter Types.Time tS "Integration time step in s";

  //Measurement parameters
  parameter Types.AngularVelocityPu DfMaxPu "Maximum frequency ramp rate in pu/s (base omegaNom)" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tfFilt "Filter time constant for frequency measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tIFilt "Filter time constant for current measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tPFilt "Filter time constant for active power measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tQFilt "Filter time constant for reactive power measurement in s" annotation(
    Dialog(tab = "Measurement"));
  parameter Types.Time tUFilt "Filter time constant for voltage measurement in s" annotation(
    Dialog(tab = "Measurement"));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput omegaRefPu(start = SystemBase.omegaRef0Pu) "Grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, -120}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput uPu(re(start = u0Pu.re), im(start = u0Pu.im)) "Complex voltage at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {-160, 0}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexInput iPu(re(start = -i0Pu.re * SystemBase.SnRef / SNom), im(start = -i0Pu.im * SystemBase.SnRef / SNom)) "Complex current at grid terminal in pu (base UNom, SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-160, 80}, extent = {{-20, -20}, {20, 20}}, rotation = 0), iconTransformation(origin = {-110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PFiltPu(start = -P0Pu * SystemBase.SnRef / SNom) "Filtered active power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {150, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QFiltPu(start = -Q0Pu * SystemBase.SnRef / SNom) "Filtered reactive power at grid terminal in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {150, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput IFiltPu(start = ComplexMath.'abs'(i0Pu) * SystemBase.SnRef / SNom) "Filtered current module at grid terminal in pu (base UNom, SNom)" annotation(
    Placement(visible = true, transformation(origin = {150, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {150, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UFiltPu(start = U0Pu) "Filtered voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {150, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -20}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput theta(start = UPhase0) "Phase shift between the converter and the grid rotating frames in rad" annotation(
    Placement(visible = true, transformation(origin = {150, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput omegaFiltPu(start = SystemBase.omegaRef0Pu) "Filtered grid angular frequency in pu (base omegaNom)" annotation(
    Placement(visible = true, transformation(origin = {150, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Other variables
  Types.ActivePowerPu PGenPu(start = -P0Pu) "Active power generated by the converter at grid terminal in pu (base UNom, SnRef) (generator convention)";
  Types.ReactivePowerPu QGenPu(start = -Q0Pu) "Reactive power generated by the converter at grid terminal in pu (base UNom, SnRef) (generator convention)";
  Types.ActivePowerPu PGenNomPu(start = -P0Pu * (SystemBase.SnRef / SNom)) "Active power generated by the converter at grid terminal in pu (base UNom, SNom) (generator convention)";
  Types.ReactivePowerPu QGenNomPu(start = -Q0Pu * (SystemBase.SnRef / SNom)) "Reactive power generated by the converter at grid terminal in pu (base UNom, SNom) (generator convention) ";
  Types.CurrentModulePu IWtPu(start = ComplexMath.'abs'(i0Pu) * SystemBase.SnRef / SNom) "Current module at grid terminal in pu (base UNom, SNom)";
  Types.VoltageModulePu UWtPu(start = U0Pu) "Voltage amplitude at grid terminal in pu (base UNom)";

  Modelica.Blocks.Continuous.FirstOrder firstOrder(T = tPFilt, y_start = -P0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {90, 120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder1(T = tQFilt, y_start = -Q0Pu * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {90, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder2(T = tIFilt, y_start = ComplexMath.'abs'(i0Pu) * SystemBase.SnRef / SNom) annotation(
    Placement(visible = true, transformation(origin = {90, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder3(T = tUFilt, y_start = U0Pu) annotation(
    Placement(visible = true, transformation(origin = {90, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Add add annotation(
    Placement(visible = true, transformation(origin = {90, -120}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.FirstOrder firstOrder4(T = tfFilt, y_start = 0) annotation(
    Placement(visible = true, transformation(origin = {30, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.NonElectrical.Blocks.NonLinear.StandAloneRampRateLimiter standAloneRampRateLimiter(DuMax = DfMaxPu, Y0 = 0, tS = tS) annotation(
    Placement(visible = true, transformation(origin = {-10, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.Product product(useConjugateInput2 = true) annotation(
    Placement(visible = true, transformation(origin = {-70, 100}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToReal complexToReal annotation(
    Placement(visible = true, transformation(origin = {-10, 100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar annotation(
    Placement(visible = true, transformation(origin = {-10, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.ComplexMath.ComplexToPolar complexToPolar1 annotation(
    Placement(visible = true, transformation(origin = {-70, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Continuous.Derivative derivative(T = tfFilt / 20, k = 1 / SystemBase.omegaNom, x_start = UPhase0) annotation(
    Placement(visible = true, transformation(origin = {-50, -100}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexVoltagePu u0Pu "Initial complex voltage at grid terminal in pu (base UNom)" annotation(
    Dialog(group="Initialization"));
  parameter Types.ComplexCurrentPu i0Pu "Initial complex current at grid terminal in pu (base UNom, SnRef) (receptor convention)" annotation(
    Dialog(group="Initialization"));
  parameter Types.VoltageModulePu U0Pu "Initial voltage amplitude at grid terminal in pu (base UNom)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.Angle UPhase0 "Initial voltage angle at grid terminal in rad" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ActivePowerPu P0Pu "Initial active power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));
  parameter Types.ReactivePowerPu Q0Pu "Initial reactive power at grid terminal in pu (base SnRef) (receptor convention)" annotation(
    Dialog(tab = "Operating point"));

equation
  UWtPu = ComplexMath.'abs'(uPu);
  IWtPu = ComplexMath.'abs'(iPu);
  PGenNomPu = ComplexMath.real(uPu * ComplexMath.conj(iPu));
  QGenNomPu = ComplexMath.imag(uPu * ComplexMath.conj(iPu));
  PGenPu = PGenNomPu * SNom / SystemBase.SnRef;
  QGenPu = QGenNomPu * SNom / SystemBase.SnRef;

  connect(iPu, product.u2) annotation(
    Line(points = {{-160, 80}, {-120, 80}, {-120, 106}, {-82, 106}}, color = {85, 170, 255}));
  connect(uPu, product.u1) annotation(
    Line(points = {{-160, 0}, {-100, 0}, {-100, 94}, {-82, 94}}, color = {85, 170, 255}));
  connect(product.y, complexToReal.u) annotation(
    Line(points = {{-58, 100}, {-22, 100}}, color = {85, 170, 255}));
  connect(complexToReal.re, firstOrder.u) annotation(
    Line(points = {{2, 106}, {40, 106}, {40, 120}, {78, 120}}, color = {0, 0, 127}));
  connect(complexToReal.im, firstOrder1.u) annotation(
    Line(points = {{2, 94}, {40, 94}, {40, 80}, {78, 80}}, color = {0, 0, 127}));
  connect(firstOrder.y, PFiltPu) annotation(
    Line(points = {{102, 120}, {150, 120}}, color = {0, 0, 127}));
  connect(firstOrder1.y, QFiltPu) annotation(
    Line(points = {{102, 80}, {150, 80}}, color = {0, 0, 127}));
  connect(iPu, complexToPolar.u) annotation(
    Line(points = {{-160, 80}, {-120, 80}, {-120, 40}, {-22, 40}}, color = {85, 170, 255}));
  connect(uPu, complexToPolar1.u) annotation(
    Line(points = {{-160, 0}, {-82, 0}}, color = {85, 170, 255}));
  connect(complexToPolar1.len, UPu) annotation(
    Line(points = {{-58, 6}, {40, 6}, {40, 0}, {150, 0}}, color = {0, 0, 127}));
  connect(complexToPolar1.len, firstOrder3.u) annotation(
    Line(points = {{-58, 6}, {40, 6}, {40, -40}, {78, -40}}, color = {0, 0, 127}));
  connect(firstOrder3.y, UFiltPu) annotation(
    Line(points = {{102, -40}, {150, -40}}, color = {0, 0, 127}));
  connect(complexToPolar1.phi, theta) annotation(
    Line(points = {{-58, -6}, {20, -6}, {20, -80}, {150, -80}}, color = {0, 0, 127}));
  connect(omegaRefPu, add.u2) annotation(
    Line(points = {{-160, -120}, {-120, -120}, {-120, -126}, {78, -126}}, color = {0, 0, 127}));
  connect(add.y, omegaFiltPu) annotation(
    Line(points = {{102, -120}, {150, -120}}, color = {0, 0, 127}));
  connect(standAloneRampRateLimiter.y, firstOrder4.u) annotation(
    Line(points = {{1, -100}, {18, -100}}, color = {0, 0, 127}));
  connect(firstOrder4.y, add.u1) annotation(
    Line(points = {{42, -100}, {60, -100}, {60, -114}, {78, -114}}, color = {0, 0, 127}));
  connect(complexToPolar.len, firstOrder2.u) annotation(
    Line(points = {{2, 46}, {40, 46}, {40, 40}, {78, 40}}, color = {0, 0, 127}));
  connect(firstOrder2.y, IFiltPu) annotation(
    Line(points = {{102, 40}, {150, 40}}, color = {0, 0, 127}));
  connect(derivative.y, standAloneRampRateLimiter.u) annotation(
    Line(points = {{-38, -100}, {-22, -100}}, color = {0, 0, 127}));
  connect(complexToPolar1.phi, derivative.u) annotation(
    Line(points = {{-58, -6}, {-40, -6}, {-40, -60}, {-80, -60}, {-80, -100}, {-62, -100}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Diagram(coordinateSystem(extent = {{-140, -140}, {140, 140}})),
    Icon(graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, -100}, {100, 100}}), Text(origin = {16, -23}, extent = {{-108, -24}, {76, 10}}, textString = "Module"), Text(origin = {8, 35}, extent = {{-100, -30}, {88, 20}}, textString = "Measurement")}));
end Measurements;
