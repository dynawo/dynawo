within Dynawo;

package UsersGuide "User's Guide"
  extends Icons.Information;

annotation(preferredView = "info",
    Documentation(info = "<html><head></head><body>
<p>The Dynawo library is a Modelica library for analysis of power system stability. The models are written using the phasor approximation and the current and voltage are considered balanced.
</p>
The library is organized as follows:
<div><ul>
<li>Electrical models are available in the <a href=\"modelica://Dynawo.Electrical\">electrical package </a> and are organized by component types. </li>
<li>Specific connectors enabling to interface models together are defined in the <a href=\"modelica://Dynawo.Connectors\">connectors package</a></li>
<li> Basic common blocks not available in the Modelica Standard Library and log messages are implemented into the <a href=\"modelica://Dynawo.NonElectrical\"> NonElectrical </a> package.</li>
<li> Specific <a href=\"modelica://Dynawo.Types\"> types</a> and <a href=\"modelica://Dynawo.AdditionalIcons\"> icons </a> are provided into particular packages.</li>
</ul><div>As of today, initialization into Dynawo is carried out by specific initialization models, denoted by _INIT suffix. If you want to use the Dynawo library into a full Modelica tool (OpenModelica for example), you need to provide to the Modelica models consistent parameters that you have previously calculated.</div>
</div></body></html>"));

end UsersGuide;
