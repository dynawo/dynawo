encapsulated package Dynawo "Dynawo models library"
  // generic import commands
  import Complex "Complex numbers foundation class";
  import Modelica;
  import Modelica.ComplexMath "Complex numbers operators (+, - , *, exp, abs...)";
  import Modelica.Icons;
  import Dynawo;
  import Dynawo.AdditionalIcons;
  import Dynawo.Electrical.SystemBase;
  import Dynawo.Types "Standard Dynawo variable types";

  extends Icons.Package;

  annotation(
    version = "1.7.1",
    Documentation(info = "<html><head></head><body>
<p>Copyright (c) 2015-2024, RTE (<a href=\"http://www.rte-france.com/\">http://www.rte-france.com</a>)</p>

All rights reserved.<br>
This Source Code Form is subject to the terms of the Mozilla Public
License, v. 2.0. If a copy of the MPL was not distributed with this
file, you can obtain one at http://mozilla.org/MPL/2.0/.<br>
SPDX-License-Identifier: MPL-2.0<p></p>

----------------------------------------------------------------------------------------------------------------------
<p>The Dynawo library is a Modelica library developed for the analysis of power transmission systems stability. The models provided into the library enables to run both short-term or transient stability studies and long-term or voltage statibility studies. </p>

<p>The main goal of the library is to provide an open-source, transparent and flexible set of power system models to enhance collaboration and cooperation in the power system community. In addition with the C++ models and the efficient solvers provided open-source into Dynawo, it makes it possible to run large-scale simulations with acceptable simulation time in an open and transparent way. </p>

<p> To achieve this goal, the library has been developed and designed to take advantage of the declarative modelling approach of Modelica, while remaining easy to read, understand and improve for non Modelica experts. &nbsp;Physical components are thus described using an equation-based approach, leading to models similar to the descriptions found into textbooks or theory manuals, while control systems are modelled using block diagrams as this is the most natural approach for power system experts.</p>

<p>The library is currently developed and maintained by RTE with support and help from different European research centers or universities.</p>

<p>If you want to have more detail on the library, please have a look to the <a href=\"modelica://Dynawo.UsersGuide\"> User's Guide. </a> </p>

<p>If you want to learn more about the Dynawo projet in general, please visit <a href=\"http://www.dynawo.org\"> our website</a> or send us an <a href=\"mailto:rte-dynawo@rte-france.com\">e-mail.</a></p></body></html>"),
    uses(Modelica(version = "3.2.3")),
    preferredView = "info");
end Dynawo;
