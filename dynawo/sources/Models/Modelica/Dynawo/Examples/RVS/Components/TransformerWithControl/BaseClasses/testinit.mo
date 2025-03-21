within Dynawo.Examples.RVS.Components.TransformerWithControl.BaseClasses;

model testinit
  Dynawo.Electrical.Loads.LoadConnect_INIT loadConnect_INIT annotation(
    Placement(visible = true, transformation(origin = {36, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Electrical.Transformers.TransformerVariableTapPQ_INIT transformerVariableTapPQ_INIT annotation(
    Placement(visible = true, transformation(origin = {-56, -16}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
connect(loadConnect_INIT.i0Pu, transformerVariableTapPQ_INIT.i20Pu);
connect(loadConnect_INIT.u0Pu, transformerVariableTapPQ_INIT.u20Pu);

end testinit;
