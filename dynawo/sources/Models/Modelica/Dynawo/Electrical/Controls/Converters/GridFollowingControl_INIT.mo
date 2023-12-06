within Dynawo.Electrical.Controls.Converters;

model GridFollowingControl_INIT "Initialization model for the grid following control"
  import Dynawo.Types;

  extends AdditionalIcons.Init;
  import Modelica;
  import Modelica.Constants;
  import Dynawo;
  
  Types.ComplexVoltagePu uPcc0Pu;
  Types.ComplexCurrentPu iPcc0Pu;
  Types.AngularVelocity omegaRef0;
  Types.PerUnit omegaPLL0Pu;
  Types.Angle thetaPLL0Pu;
  Types.PerUnit PGen0Pu;
  Types.PerUnit QGen0Pu;
  Types.ComplexVoltagePu uConv0Pu;
  Types.PerUnit UConv0Pu;
  Types.PerUnit idPcc0Pu;
  Types.PerUnit iqPcc0Pu;
  Types.PerUnit idConv0Pu;
  Types.PerUnit iqConv0Pu;
  Types.PerUnit udPcc0Pu;
  Types.PerUnit uqPcc0Pu;
  Types.PerUnit udConvRef0Pu;
  Types.PerUnit uqConvRef0Pu;

equation
  
  annotation(preferredView = "text");

end GridFollowingControl_INIT;
