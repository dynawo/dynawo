within Dynawo.UsersGuide;

/*
* Copyright (c) 2015-2020, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package NamingConventions
  extends Icons.Information;

  annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body><p>This section contains the naming and style guidelines for the Dynawo library development. If you want to contribute to the library, please make sure you follow them strictly, to ensure a consistent style throughout the whole library.</p>

<p>When writing a Modelica model, please respect the general <a href=\"modelica://Modelica.UsersGuide.Conventions\">Modelica conventions</a> and follow the recommendations below.</p>

<p>Please always use the English language for the code and comments.</p>

<h2>Electrical conventions</h2>

<p>For currents and powers, the <strong>receptor convention</strong> is normally followed, i.e. the value is positive when entering the device. It is recommended to draw a small scheme indicating the conventions.</p>

<p> The name of the electrical connector should be <strong>terminal</strong> for an injector type model, and <strong>terminal1 </strong>and<strong> terminal2</strong> for a branch type model. </p>

<h2>Package structure conventions</h2>

<p> Each dynamic model should have a .mo file. These models can extend base models. All base models should be gathered in a specific base package. </p>

<p> Each init model should have a .mo file. These models can extend base models that should be gathered in a specific base package. </p>

<p> In package.order, the package containing the base models should be indicated first, followed by each pair of dynamic and initialization models.</p>

<h2>Naming conventions</h2>

<h3>Generalities</h3>

<p>Use package namespaces as much as possible to avoid naming conflicts. Do not duplicate parent namespaces in the children model names.</p>

<p>Please follow the <a href=\"modelica://Modelica.UsersGuide.Conventions.ModelicaCode.Naming\">Modelica naming conventions</a>.</p>

<ul>
<li><strong>Package/Class/Model</strong> : start with upper case letter and use camel-case convention, e.g \"ElectricCurrent\" </li>
<li><strong>Parameters/Constants</strong>: start with an upper case letter</li>
<li><strong>Variables/Connectors/Component</strong> instance : start with lower case letter and use camel-case convention</li>
<li><strong>Functions</strong>: start with lower case letter</li>
</ul>

<p>The names of component instances of a base model should not be used again in the models which extend the base model.</p>

<p>In addition to this, please follow the additional naming conventions below (in that order):</p>

<ul dir=\"auto\">
<li><strong>Min/Max</strong>&nbsp;parameters/variables: end with&nbsp;<code>Min/Max</code></li>
<li><strong>Start</strong> parameters/variables: end with <code>0</code></li>
<li><strong>Per unit</strong> parameters/variables: end with <code>Pu (always indicate \"in pu\" in the comment along with the pu base)</code></li>
</ul><div><font face=\"monospace\">Example: UMax0Pu.</font></div>

<h3>
Exceptions for physical variables</h3>

<p>There are some exceptions for the physical variables. Please refer to the list below:</p>

<ul>
<li><strong>Frequencies</strong> should be named f. A parameter related to a frequency should start with a lower case letter, e.g fACNetwork.</li>
<li><strong>Currents</strong> should be named <code>i</code> (for complex variable),&nbsp;<code>I</code> (for absolute value) or id/iq for dq-axis values</li>
<li><strong>Voltages (phase-to-phase)</strong> should be named <code>u</code> (for complex variable),&nbsp;<code>U</code> (for absolute value) or ud/uq for dq-axis values</li>
<li><strong>Voltages (phase-to-ground)</strong> should be named <code>v</code> (for complex variable),&nbsp;<code>V</code> (for absolute value) or vd/vq for dq-axis values</li>
<li><strong>Apparent power</strong> should be named s (for complex variable) or S (for absolute value)</li>
<li><strong>Active power</strong> should be named P, <strong>reactive power</strong> should be named Q</li>
<li><strong>Impedance</strong> should be named <code>Z</code>, <strong>resistance</strong> should be named <code>R</code>, <strong>reactance</strong> should be named <code>X</code>, <strong>admittance</strong> should be named <code>Y</code>, <strong>conductance</strong> should be named <code>G</code>, <strong>susceptance</strong> should be named <code>B</code></li>
<li><strong>Angles</strong> should be named according to their name in textbooks (ex: theta)</li>
<li><strong>Time</strong> should be named t (T is used for the temperature).
 A parameter related to a time should start with a lower case letter,
e.g tInteger, t0...</li>
</ul>

<h3>Exceptions for initialization models</h3>

<p>Initialization models name should end with <strong>_INIT</strong>. There can be several initialization models for one dynamic model. </p>

<p> The initialization models variables are the parameters of the dynamic models so they should start with an upper case letter.</p>

<p>In an initialization model, the names of component instances should end in \"Init\", and this ending should never be used for instances of dynamic models.</p>

<h3>Types conventions</h3>

<p dir=\"auto\">Preferably use the types defined in the <a href=\"modelica://Dynawo.Types\">Dynawo.Types</a> package and avoid using plain <code>Real</code> variables.</p>

<h2>Model structure conventions</h2>

<h3>Generalities</h3>

<p>Respect the following order while writing or updating a model:</p>

<ul>
<li>Modelica library imports (alphabetical order)</li>
<li>Other libraries imports (alphabetical order)</li>
<li>Internal Dynawo imports (alphabetical order)</li>
<li>extends statements</li>
<li>Public parameters (including extends)</li>
<li>Connectors (group them based on functional aspects), inputs/outputs (in that order)</li>
<li>Blocks&nbsp;(group them based on functional aspects)</li>
<li>Initial parameters (if not protected)</li>
<li>Protected parameters followed by protected final parameters</li>
<li>Protected initial parameters followed by protected initial final parameters</li>
<li>Protected variables</li>
<li>Equations: equations first, followed by when equations and if equations, blocks connections at the end</li>
<li>Annotations: remove minor tool-specific annotations</li>
</ul>

<h3>Public/Protected conventions</h3>

<div><ul>
<li><strong>Public</strong> should be used for external parameters and connectors (don't use the \"public\" keyword if not needed)</li>
<li><strong>Protected</strong> should be used for initial parameters, internal parameters and variables.</li>
</ul><div>NB: initial parameters can be public if the model is used in an OpenModelica test case.&nbsp;</div></div>

<h3>Comments and documentation conventions</h3>

<p>Comments should start with a capital letter.</p>

<ul>
<li>Always comment <strong>all</strong> models, function, parameters and variables, using the Modelica <code>\"comments\"</code>, explaining concisely but clearly what is their meaning/use. Always give the unit and the pu base. These comments are meant for the library users and automatically show up at various places in the graphical user interface (e.g. in the variables browser to inspect simulation results).</li>
<li>Use <code>//</code> comments for equations and implementation description (base transformation, model conventions). These comments are meant for library developers.</li>
</ul><div>In addition to comments, always fill the documentation part of your model (available in the documentation browser) by explaining what are the hypothesis done in the model and for which simulation the model could be used. If it is relevant, also include graphical views helping to understand the model's behavior. &nbsp;</div>

<h3>Model implementation</h3>

<ul>
<li>Use complex numbers (and native associated functions) whenever possible</li>
<li>Use the <i>flow </i>keyword for init complex current declaration (they could be used in initConnect into Dynawo tool)</li>
<li>Use discrete Real for non-continuous variables</li>
<li>Use inner/outer variables for shared general variables</li>
<li>Use input/output keywords for the inputs/outputs seen from the model (at least for control models)</li>
<li>Component state

<ul>
<li><strong>running</strong> describes a state when something is flowing through the device</li>
<li><strong>on</strong> describes a state when the device is turned on (but no flow may be flowing through)</li>
<li><strong>off</strong> describes a state when the device is shut down (no flow is expected)</li>
</ul>
</li>
</ul>

<h3>Graphical view</h3>

<p> Try to use one of the <a href=\"modelica://Modelica.Icons\"> Modelica icons</a> or <a href=\"modelica://Dynawo.AdditionalIcons\"> Dynawo icons</a> when creating a model.</p>

<h3>Preferred view</h3>

<p> Always set a preferred view to your model such as it will be opened by default in this view by Modelica-based environments:</p><p></p><ul>
<li>text view for equation-based models</li>
<li>diagram view for input/output or block models</li>
<li>info view for documentation</li></ul><div><h3>Blank lines and indentation</h3></div><div>Follow these rules regarding blank lines and indentation:</div><div><ul>
<li>One blank line between the \"within\" and the copyright</li>
<li>One blank line between the copyright and the model name</li>
<li><b>No</b> blank line between the model name and the first import</li>
<li>One blank line between the imports and the extends</li>
<li>One blank line between the extends and the parameters</li>
<li>One blank line between the parameters and the connectors/inputs/outputs</li>
<li>One blank line between the connectors/input/outputs and the blocks</li>
<li>One blank line between the blocks and the initial parameters</li>
<li>One blank line between the initial parameters and the protected section</li>
<li><b>No</b> blank line between the \"protected\" word and the first protected element</li>
<li>One blank line between the protected parameters and the protected init parameters</li>
<li>One blank line between the protected init parameters and protected variables</li>
<li>One blank line between the protected variables and the equation section</li>
<li><b>No</b> blank line between the \"equation\" word and the first equation</li>
<li>One blank line between equations and a when equation or an if equation</li>
<li>One blank line before annotations</li>
<li><b>No</b> blank line between annotations and end of model</li></ul><div>Two spaces must be used for indentation.</div></div><p></p></body></html>"));
end NamingConventions;
