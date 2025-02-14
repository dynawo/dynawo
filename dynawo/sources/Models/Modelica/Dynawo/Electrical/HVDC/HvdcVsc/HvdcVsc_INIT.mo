within Dynawo.Electrical.HVDC.HvdcVsc;

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

model HvdcVsc_INIT "Initialisation model for the HVDC VSC model"
  extends AdditionalIcons.Init;
  extends BaseClasses_INIT.BaseHVDC_INIT;

  parameter Types.PerUnit LambdaPu "Lambda coefficient for the QRefUPu calculation in pu (base SNom, UNom)";
  parameter Boolean ModeU1Set "Set mode of control on side 1 : if true, U mode, if false, Q mode";
  parameter Boolean ModeU2Set "Set mode of control on side 2 : if true, U mode, if false, Q mode";
  parameter Types.PerUnit RDcPu "Resistance of one cable of DC line in pu (base UDcNom, SnRef)";
  parameter Types.ApparentPowerModule SNom "Injector nominal apparent power in MVA";

  Types.PerUnit Ip10Pu "Start value of active current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  Types.PerUnit Ip20Pu "Start value of active current at terminal 2 in pu (base SNom, UNom) (DC to AC)";
  Types.PerUnit Iq10Pu "Start value of reactive current at terminal 1 in pu (base SNom, UNom) (DC to AC)";
  Types.PerUnit Iq20Pu "Start value of reactive current at terminal 2 in pu (base SNom, UNom) (DC to AC)";
  Boolean ModeU10 "Initial mode of control on side 1 : if true, U mode, if false, Q mode";
  Boolean ModeU20 "Initial mode of control on side 2 : if true, U mode, if false, Q mode";
  Types.ReactivePowerPuConnector PRef0Pu "Start value of reactive power reference in pu (base SNom) (DC to AC)";
  Types.ReactivePowerPu QRef10Pu "Start value of reactive power reference at terminal 1 in pu (base SNom) (DC to AC)";
  Types.ReactivePowerPu QRef20Pu "Start value of reactive power reference at terminal 2 in pu (base SNom) (DC to AC)";
  Types.VoltageModulePu UDc10Pu "Start value of DC voltage at terminal 1 in pu (base UDcNom)";
  Types.VoltageModulePu UDc20Pu "Start value of DC voltage at terminal 2 in pu (base UDcNom)";
  Types.VoltageModulePu UDcRef0Pu "Start value of DC voltage reference in pu (base UDcNom)";
  Types.VoltageModulePu URef10Pu "Start value of the voltage reference for the side 1 of the HVDC link in pu (base UNom)";
  Types.VoltageModulePu URef20Pu "Start value of the voltage reference for the side 1 of the HVDC link in pu (base UNom)";

equation
  UDcRef0Pu = 1;
  P10Pu = - U10Pu * Ip10Pu * (SNom / SystemBase.SnRef);
  P1Ref0Pu = P10Pu;
  Q10Pu = U10Pu * Iq10Pu * (SNom / SystemBase.SnRef);
  P20Pu = - U20Pu * Ip20Pu * (SNom / SystemBase.SnRef);
  Q20Pu = U20Pu * Iq20Pu * (SNom / SystemBase.SnRef);
  QRef10Pu = - Q10Pu * (SystemBase.SnRef / SNom);
  QRef20Pu = - Q20Pu * (SystemBase.SnRef / SNom);
  PRef0Pu = - P10Pu * (SystemBase.SnRef / SNom);
  URef10Pu = U10Pu - LambdaPu * Q10Pu * (SystemBase.SnRef / SNom);
  URef20Pu = U20Pu - LambdaPu * Q20Pu * (SystemBase.SnRef / SNom);
  ModeU10 = ModeU1Set;
  ModeU20 = ModeU2Set;

  if Ip10Pu < 0 then
    UDc10Pu = 1;
    UDc20Pu = 1 - 2 * RDcPu * Ip20Pu * (SNom / SystemBase.SnRef);
  else
    UDc10Pu = 1 - 2 * RDcPu * Ip10Pu * (SNom / SystemBase.SnRef);
    UDc20Pu = 1;
  end if;

  annotation(preferredView = "text");
end HvdcVsc_INIT;
