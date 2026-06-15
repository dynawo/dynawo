within Dynawo.Electrical.HVDC.HvdcVsc.BaseControls.Parameters;
record ParamsDcLine "Parameters of DC line"
  parameter Types.PerUnit CDcPu "DC line capacitance in pu (base UDcNom, SnRef)";
  parameter Types.PerUnit RDcPu "Resistance of one cable of DC line in pu (base UDcNom, SnRef)";

  annotation(preferredView = "text",
    Documentation(info = "<html><head></head><body>
<pre><span>Equivalent circuit and conventions:</span></pre>
<pre><br></pre>
<pre><span>             IDc1Pu                   IDc2Pu</span></pre>
<pre>     UDc1Pu ----&lt;----------2*RDcPu-------&gt;----UDc2Pu</span></pre>
<pre>     P1Pu               |           |         P2Pu</span></pre>
<pre>                      CDcPu       CDcPu</span></pre>
<pre>                        |           |</span></pre>
<pre><span>                       ---         ---</span></pre></body></html>"));
end ParamsDcLine;
