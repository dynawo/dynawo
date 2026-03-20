within Dynawo.Examples;

package ConnectionSimulations
  extends Icons.Package;











  annotation(
    Documentation(info = "<html><head></head><body>The purpose of this package is to enable users to easily run simulations required to users connecting to the RTE grid. Those simulations are described in the french grid code.<div><br></div><div><b>Package</b><br>|<br>|-- <b>BaseUnitModel</b><br>| &nbsp; &nbsp;Production plant model<br>| &nbsp; &nbsp; &nbsp;-&gt; modify: yes (detailed explanation in the model)<br>| &nbsp; &nbsp; &nbsp;-&gt; simulate: no<br>|<br>|-- <b>BaseParameters<br></b>| &nbsp; &nbsp;Global parameters (SNom, parameters used across all simulation, etc..)<br>| &nbsp; &nbsp; &nbsp;-&gt; modify: yes&nbsp;(detailed explanation in the model)<br>| &nbsp; &nbsp; &nbsp;-&gt; simulate: no<br>|<br>|-- <b>BaseSheetSimulations</b><br>| &nbsp; &nbsp; Grid topology definitions<br>| &nbsp; &nbsp; &nbsp;-&gt; modify: no<br>| &nbsp; &nbsp; &nbsp;-&gt; simulate: no<br>|<br>|-- <b>SheetSimulations</b><br>| &nbsp; &nbsp; Test cases (grid + plant)<br>| &nbsp; &nbsp; &nbsp;-&gt; modify: no<br>| &nbsp; &nbsp; &nbsp;-&gt; simulate: yes<br>|<br>|-- <b>RunSimulations</b><br>&nbsp; &nbsp; &nbsp; Main model (all test cases ran at the same time)<br>&nbsp; &nbsp; &nbsp; &nbsp;-&gt; modify: no<br>&nbsp; &nbsp; &nbsp; &nbsp;-&gt; simulate: yes</div><div><div><br></div><div><br></div></div></body></html>"));
end ConnectionSimulations;
