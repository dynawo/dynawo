within Dynawo.Electrical.Controls.WECC.BaseControls;

/*
* Copyright (c) 2023, RTE (http://www.rte-france.com)
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

model VoltageSource "Injector URI ready to be connected to the grid"

/*                uSourcePu                                uInjPu                      uPu
     --------         |                                       |                         |
    | Source |--------+---->>--------RSourcePu+jXSourcePu-----+------RPu+jXPu-----<<----+---- terminal
     --------           iSourcePu                                                 iPu
*/

  //Nominal parameter
  parameter Types.ApparentPowerModule SNom "Nominal apparent power in MVA";

  //Source parameters
  parameter Types.Time tE "Emulated delay in converter controls in s (cannot be zero, typical: 0.02..0.05)";
  parameter Types.PerUnit RSourcePu "Source resistance in pu (base UNom, SNom)";
  parameter Types.PerUnit XSourcePu "Source reactance in pu (base UNom, SNom)";

  //Interface
  Dynawo.Connectors.ACPower terminal(V(re(start = uInj0Pu.re), im(start = uInj0Pu.im)), i(re(start = i0Pu.re), im(start = i0Pu.im))) "Injector connector" annotation(
    Placement(visible = true, transformation(origin = {110, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Input variables
  Modelica.Blocks.Interfaces.RealInput idPu(start = Id0Pu) "d-axis current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, -60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealInput iqPu(start = Iq0Pu) "q-axis current at injector in pu (base SNom, UNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {-110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {-110, 60}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Output variables
  Modelica.Blocks.Interfaces.RealOutput PInjPu(start = PInj0Pu) "Active power at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput QInjPu(start = QInj0Pu) "Reactive power at injector in pu (base SNom) (generator convention)" annotation(
    Placement(visible = true, transformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, 40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Interfaces.RealOutput UInjPu(start = UInj0Pu) "Voltage module at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.ComplexBlocks.Interfaces.ComplexOutput uInjPu(im(start = uInj0Pu.im), re(start = uInj0Pu.re)) "Complex voltage at injector in pu (base UNom)" annotation(
    Placement(visible = true, transformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0), iconTransformation(origin = {110, -80}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Dynawo.Electrical.Controls.WECC.Utilities.Measurements measurements(SNom = SNom) annotation(
    Placement(visible = true, transformation(origin = {70, 0}, extent = {{-10, 10}, {10, -10}}, rotation = 0)));
  Dynawo.Electrical.Lines.Line line(BPu = 0, GPu = 0, RPu = RSourcePu, XPu = XSourcePu) annotation(
    Placement(visible = true, transformation(origin = {30, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Controls.WECC.BaseControls.VSourceRef vSourceRef(Id0Pu = Id0Pu, Iq0Pu = Iq0Pu, RSourcePu = RSourcePu, UdInj0Pu = UdInj0Pu, UqInj0Pu = UqInj0Pu, XSourcePu = XSourcePu, tE = tE, uInj0Pu = uInj0Pu, uSource0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {-50, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Dynawo.Electrical.Sources.InjectorURI injectorURI(i0Pu = i0Pu, u0Pu = uSource0Pu) annotation(
    Placement(visible = true, transformation(origin = {-10, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  //Initial parameters
  parameter Types.ComplexCurrentPu i0Pu "Start value of complex current at terminal in pu (base SnRef, UNom) (receptor convention)";
  parameter Types.PerUnit Id0Pu "Start value of d-axis current at injector in pu (base SNom, UNom) (generator convention)";
  parameter Types.PerUnit Iq0Pu "Start value of q-axis current at injector in pu (base SNom, UNom) (generator convention)";
  parameter Types.ActivePowerPu PInj0Pu "Start value of active power at injector in pu (base SNom) (generator convention)";
  parameter Types.ReactivePowerPu QInj0Pu "Start value of reactive power at injector in pu (base SNom) (generator convention)";
  parameter Types.PerUnit UdInj0Pu "Start value of d-axis voltage at injector in pu (base UNom)";
  parameter Types.VoltageModulePu UInj0Pu "Start value of voltage magnitude at injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uInj0Pu "Start value of complex voltage at injector in pu (base UNom)";
  parameter Types.PerUnit UqInj0Pu "Start value of q-axis voltage at injector in pu (base UNom)";
  parameter Types.ComplexVoltagePu uSource0Pu "Start value of complex voltage at source in pu (base UNom)";

equation
  line.switchOffSignal1 = injectorURI.switchOffSignal1;
  line.switchOffSignal2 = injectorURI.switchOffSignal2;

  connect(vSourceRef.uReSourcePu, injectorURI.urPu) annotation(
    Line(points = {{-38, 6}, {-20, 6}}, color = {0, 0, 127}));
  connect(vSourceRef.uImSourcePu, injectorURI.uiPu) annotation(
    Line(points = {{-38, -6}, {-20, -6}}, color = {0, 0, 127}));
  connect(injectorURI.terminal, line.terminal1) annotation(
    Line(points = {{2, 0}, {20, 0}}, color = {0, 0, 255}));
  connect(line.terminal2, measurements.terminal1) annotation(
    Line(points = {{40, 0}, {60, 0}}, color = {0, 0, 255}));
  connect(measurements.terminal2, terminal) annotation(
    Line(points = {{80, 0}, {110, 0}}, color = {0, 0, 255}));
  connect(measurements.PPuSnRef, PInjPu) annotation(
    Line(points = {{64, 12}, {64, 80}, {110, 80}}, color = {0, 0, 127}));
  connect(measurements.QPuSnRef, QInjPu) annotation(
    Line(points = {{68, 12}, {68, 40}, {110, 40}}, color = {0, 0, 127}));
  connect(measurements.UPu, UInjPu) annotation(
    Line(points = {{60, -10}, {60, -40}, {110, -40}}, color = {0, 0, 127}));
  connect(measurements.uPu, uInjPu) annotation(
    Line(points = {{72, -10}, {72, -80}, {110, -80}}, color = {85, 170, 255}));
  connect(measurements.uPu, vSourceRef.uInjPu) annotation(
    Line(points = {{72, -10}, {72, -80}, {-50, -80}, {-50, -10}}, color = {85, 170, 255}));
  connect(iqPu, vSourceRef.iqPu) annotation(
    Line(points = {{-110, 40}, {-80, 40}, {-80, 6}, {-60, 6}}, color = {0, 0, 127}));
  connect(idPu, vSourceRef.idPu) annotation(
    Line(points = {{-110, -40}, {-80, -40}, {-80, -6}, {-60, -6}}, color = {0, 0, 127}));

  annotation(
    preferredView = "diagram",
    Icon(coordinateSystem(initialScale = 0.1), graphics = {Rectangle(fillColor = {255, 255, 255}, fillPattern = FillPattern.Solid, extent = {{-100, 100}, {100, -100}}), Text(origin = {-33, 34}, extent = {{-59, 22}, {129, -88}}, textString = "Injector"), Text(origin = {154, 4}, extent = {{-32, 12}, {4, -4}}, textString = "terminal"), Text(origin = {146, -98}, extent = {{-32, 12}, {4, -4}}, textString = "uInjPu"), Text(origin = {144, -30}, extent = {{-32, 12}, {4, -4}}, textString = "UInjPu"), Text(origin = {150, 92}, extent = {{-32, 12}, {24, -8}}, textString = "PInjPu"), Text(origin = {150, 30}, extent = {{-32, 12}, {24, -20}}, textString = "QInjPu"), Text(origin = {-131.5, -74}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "idPu"), Text(origin = {-131.5, 79}, extent = {{-10.5, 7}, {15.5, -10}}, textString = "iqPu")}));
end VoltageSource;
