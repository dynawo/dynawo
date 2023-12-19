within Dynawo.Electrical.Controls.Converters;

model GridFollowingControl_INIT "Initialization model for the grid following control"
  import Dynawo.Types;

  extends AdditionalIcons.Init;
  import Modelica;
  import Modelica.Constants;
  import Dynawo;

  /* Initial quantities to calculate from initialisation data*/
  Types.ComplexVoltagePu uPcc0Pu;
  Types.ComplexCurrentPu iPcc0Pu;
  Types.ComplexVoltagePu uConv0Pu;
  Types.ComplexCurrentPu iConv0Pu;
  Types.PerUnit udPcc0Pu;
  Types.PerUnit uqPcc0Pu;
  Types.PerUnit idPcc0Pu;
  Types.PerUnit iqPcc0Pu;
  Types.PerUnit udConv0Pu;
  Types.PerUnit uqConv0Pu;
  Types.PerUnit idConv0Pu;
  Types.PerUnit iqConv0Pu;
  Types.PerUnit udConvRef0Pu;
  Types.PerUnit uqConvRef0Pu;
  Types.PerUnit PGen0Pu;
  Types.PerUnit QGen0Pu;
  Types.PerUnit UConv0Pu;
  Types.PerUnit thetaPLL0Pu;
  Types.PerUnit omegaPLL0Pu;
  Types.PerUnit omegaRef0Pu;

equation

  annotation(preferredView = "text");

end GridFollowingControl_INIT;
