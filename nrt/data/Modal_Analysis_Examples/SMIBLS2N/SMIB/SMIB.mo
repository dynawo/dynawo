model SMIB
  Smib SMIB1() ;
  Dynawo.Electrical.Controls.Basics.Step URef1() ;
equation
  connect(SMIB1.UsRefPu,URef1.step.value) ;
end SMIB;
