within Dynawo.Electrical.Machines;

/*
* Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
*/

package BaseClasses

// Base dynamic model for simplified generator models: PV, PQ, Fictitious
partial model BaseGeneratorSimplified "Base model for simplified generator models"
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  
  extends SwitchOff.SwitchOffGenerator;
  
  public
    Connectors.ACPower terminal (V (re (start = u0Pu.re), im (start = u0Pu.im)), i (re (start = i0Pu.re), im (start = i0Pu.im))) "Connector used to connect the synchronous generator to the grid";

  protected

    parameter Types.AC.VoltageModule U0Pu "Start value of voltage at terminal amplitude in p.u (base UNom)";
    parameter Types.AC.ActivePower PGen0Pu "Start value of active power at terminal in p.u (base SnRef) (generator convention)";
    parameter Types.AC.ReactivePower QGen0Pu "Start value of reactive power at terminal in p.u (base SnRef) (generator convention)";

    parameter Types.AC.Voltage u0Pu  "Start value of complex voltage at terminal in p.u (base UNom)";
    parameter Types.AC.Current i0Pu  "Start value of complex current at terminal in p.u (base UNom, SnRef) (receptor convention)";

    Types.AC.ApparentPower SGenPu (re (start = PGen0Pu), im (start = QGen0Pu)) "Complex apparent power at terminal in p.u (base SnRef) (generator convention)";
    Types.AC.ActivePower PGenPu (start = PGen0Pu) "Active power at terminal in p.u (base SnRef) (generator convention)";
    Types.AC.ReactivePower QGenPu (start = QGen0Pu) "Reactive power at terminal in p.u (base SnRef) (generator convention)";
    Types.AC.VoltageModule UPu (start = U0Pu) "Voltage amplitude at terminal in p.u (base UNom)"; 

equation

  SGenPu = Complex(PGenPu, QGenPu);
  SGenPu = - terminal.V * ComplexMath.conj(terminal.i);
  UPu = ComplexMath.'abs'(terminal.V);

end BaseGeneratorSimplified;

// Base active power / frequency behavior for PV and PQ generator models
partial model BaseGeneratorSimplifiedPFBehavior "Base model for generator active power / frequency modulation"
  import Dynawo.NonElectrical.Logs.Timeline;
  import Dynawo.NonElectrical.Logs.TimelineKeys;

  public 

    type PStatus = enumeration (standard "Active power is modulated by the frequency deviation", 
                                limitPMin "Active power is fixed to its minimum value", 
                                limitPMax "Active power is fixed to its maximum value");

    Connectors.ImPin omegaRefPu "Network angular reference frequency in p.u (base OmegaNom)";

    parameter Types.AC.ActivePower PMinPu "Minimum active power in p.u (base SnRef)"; 
    parameter Types.AC.ActivePower PMaxPu "Maximum active power in p.u (base SnRef)";
    parameter SIunits.PerUnit AlphaPu "Frequency sensitivity in p.u (base SnRef, OmegaNom)";

  protected

    Types.AC.ActivePower PGenRawPu (start = PGen0Pu) "Active power generation without taking limits into account in p.u (base SnRef) (generator convention)";

    PStatus pStatus (start = PStatus.standard) "Status of the power / frequency regulation function";

equation

  when PGenRawPu >= PMaxPu and pre(pStatus) <> PStatus.limitPMax then
    pStatus = PStatus.limitPMax;
    Timeline.logEvent1(TimelineKeys.ActivatePMAX);
  elsewhen PGenRawPu <= PMinPu and pre(pStatus) <> PStatus.limitPMin then
    pStatus = PStatus.limitPMin;
    Timeline.logEvent1(TimelineKeys.ActivatePMIN);
  elsewhen PGenRawPu > PMinPu and pre(pStatus) == PStatus.limitPMin then
    pStatus = PStatus.standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMIN);
  elsewhen PGenRawPu < PMaxPu and pre(pStatus) == PStatus.limitPMax then
    pStatus = PStatus.standard;
    Timeline.logEvent1(TimelineKeys.DeactivatePMAX);
  end when;

  if running.value then
    PGenRawPu = PGen0Pu + AlphaPu * (1 - omegaRefPu.value);
    PGenPu = if pStatus == PStatus.limitPMax then PMaxPu else if pStatus == PStatus.limitPMin then PMinPu else PGenRawPu;
  else
    PGenRawPu = 0;
    PGenPu = 0;
  end if;

end BaseGeneratorSimplifiedPFBehavior;

record GeneratorSynchronousParameters "Synchronous machine record: Common parameters to the init and the dynamic models"

  public

    type ExcitationPuType = enumeration(NominalStatorVoltageNoLoad "1 p.u. gives nominal air-gap stator voltage at no load",
                                        Kundur "Base voltage as per Kundur, Power System Stability and Control");

    // Start values given as inputs of the initialization process
    parameter Types.AC.VoltageModule U0Pu "Start value of voltage amplitude in p.u (base UNom)";
    parameter Types.AC.ActivePower P0Pu "Start value of active power at terminal in p.u (base SnRef) (receptor convention)";
    parameter Types.AC.ReactivePower Q0Pu "Start value of reactive power at terminal in p.u (base SnRef) (receptor convention)";
    parameter SIunits.Angle UPhase0 "Start value of voltage angle in rad";

    // General parameters of the synchronous machine
    parameter Types.AC.VoltageModule UNom "Nominal voltage in kV";
    parameter Types.AC.ApparentPowerModule SNom "Nominal apparent power in MVA";
    parameter Types.AC.ActivePower PNom "Nominal active (turbine) power in MW";
    parameter ExcitationPuType ExcitationPu "Choice of excitation base voltage";
    parameter SIunits.Time H "Kinetic constant = kinetic energy / rated power";
    parameter SIunits.PerUnit DPu "Damping coefficient of the swing equation in p.u.";

    // Transformer input parameters 
    parameter Types.AC.ApparentPowerModule SnTfo "Nominal apparent power of the generator transformer in MVA";
    parameter Types.AC.VoltageModule UNomHV "Nominal voltage on the network side of the transformer in kV";
    parameter Types.AC.VoltageModule UNomLV "Nominal voltage on the generator side of the transformer in kV";
    parameter Types.AC.VoltageModule UBaseHV "Base voltage on the network side of the transformer in kV";
    parameter Types.AC.VoltageModule UBaseLV "Base voltage on the generator side of the transformer in kV";
    parameter SIunits.PerUnit RTfPu "Resistance of the generator transformer in p.u (base UBaseHV, SnTfo)";
    parameter SIunits.PerUnit XTfPu "Reactance of the generator transformer in p.u (base UBaseHV, SnTfo)";

  protected

    // Transformer internal parameters
    final parameter SIunits.PerUnit RTfoPu = RTfPu * (UNomHV / UBaseHV) ^ 2 * (SNom / SnTfo) "Resistance of the generator transformer in p.u (base SNom, UNom)";
    final parameter SIunits.PerUnit XTfoPu = XTfPu * (UNomHV / UBaseHV) ^ 2 * (SNom / SnTfo) "Reactance of the generator transformer in p.u (base SNom, UNom)";
    final parameter SIunits.PerUnit rTfoPu = if (RTfPu > 0.0) or (XTfPu > 0.0) then (UNomHV / UBaseHV) / (UNomLV / UBaseLV) 
                                                  else 1.0 "Ratio of the generator transformer in p.u (base UBaseHV, UBaseLV)";

end GeneratorSynchronousParameters;


partial model BaseGeneratorSynchronous "Synchronous machine - Base dynamic model"
  import Dynawo.Connectors;
  import Dynawo.Electrical.Controls.Basics.SwitchOff;
  import Dynawo.Electrical.SystemBase;

  extends GeneratorSynchronousParameters;
  extends SwitchOff.SwitchOffGenerator;

  public

    Connectors.ACPower terminal(V(re (start = u0Pu.re), im (start = u0Pu.im)), i(re (start = i0Pu.re), im (start = i0Pu.im))) "Connector used to connect the synchronous generator to the grid";

    // Input variables
    Connectors.ImPin omegaRefPu(value(start = SystemBase.omegaRef0Pu)) "Reference frequency in p.u";
    Connectors.ImPin PmPu(value(start = Pm0Pu)) "Mechanical power in p.u (base PNom)";
    Connectors.ImPin efdPu(value(start = Efd0Pu)) "Input voltage of exciter winding in p.u (user-selected base voltage)";

    // Output variables
    Connectors.ImPin omegaPu(value(start = SystemBase.omega0Pu)) "Angular frequency in p.u.";

  protected

    // Internal parameters of the synchronous machine in p.u (base UNom, SNom)
    // These parameters are calculated at the initialization stage from the inputs parameters (internal or external)
    // These are the parameters used in the dynamic equations of the synchronous machine
    // Notation: Ra (resistance) + P ("'" or "Prim") + Pu (Per-unit)
    parameter SIunits.PerUnit RaPPu "Armature resistance in p.u.";
    parameter SIunits.PerUnit LdPPu "Direct axis stator leakage in p.u.";
    parameter SIunits.PerUnit MdPPu "Direct axis mutual inductance in p.u.";
    parameter SIunits.PerUnit LDPPu "Direct axis damper leakage in p.u.";
    parameter SIunits.PerUnit RDPPu "Direct axis damper resistance in p.u.";
    parameter SIunits.PerUnit MrcPPu "Canay's mutual inductance in p.u.";
    parameter SIunits.PerUnit LfPPu "Excitation winding leakage in p.u.";
    parameter SIunits.PerUnit RfPPu "Excitation winding resistance in p.u.";
    parameter SIunits.PerUnit LqPPu "Quadrature axis stator leakage in p.u.";
    parameter SIunits.PerUnit MqPPu "Quadrature axis mutual inductance in p.u.";
    parameter SIunits.PerUnit LQ1PPu "Quadrature axis 1st damper leakage in p.u.";
    parameter SIunits.PerUnit RQ1PPu "Quadrature axis 1st damper resistance in p.u.";
    parameter SIunits.PerUnit LQ2PPu "Quadrature axis 2nd damper leakage in p.u.";
    parameter SIunits.PerUnit RQ2PPu "Quadrature axis 2nd damper resistance in p.u.";

    // p.u factor for excitation voltage
    final parameter SIunits.PerUnit Kuf = if ExcitationPu == ExcitationPuType.Kundur then 1 else RfPPu / MdPPu "Scaling factor for excitation p.u. voltage";

    // Start values calculated by the initialization model
    parameter Types.AC.ApparentPower s0Pu "Start value of complex apparent power at terminal in p.u (base SnRef)";
    parameter Types.AC.Voltage u0Pu "Start value of complex voltage at terminal in p.u (base UNom)";
    parameter Types.AC.Current i0Pu "Start value of complex current at terminal in p.u (base UNom, SnRef)";

    parameter SIunits.Angle Theta0 "Start value of rotor angle: angle between machine rotor frame and port phasor frame";
    parameter SIunits.PerUnit Ud0Pu "Start value of voltage of direct axis in p.u";
    parameter SIunits.PerUnit Uq0Pu "Start value of voltage of quadrature axis in p.u";
    parameter SIunits.PerUnit Id0Pu "Start value of current of direct axis in p.u";
    parameter SIunits.PerUnit Iq0Pu "Start value of current of quadrature axis in p.u";

    parameter SIunits.PerUnit If0Pu "Start value of flux of excitation winding in p.u";
    parameter SIunits.PerUnit Uf0Pu "Start value of exciter voltage in p.u. (Kundur base)";
    parameter SIunits.PerUnit Efd0Pu "Start value of input exciter voltage in p.u. (user-selcted base)";

    parameter SIunits.PerUnit Lambdad0Pu "Start value of flux of direct axis in p.u";
    parameter SIunits.PerUnit Lambdaq0Pu "Start value of flux of quadrature axis in p.u";
    parameter SIunits.PerUnit LambdaD0Pu "Start value of flux of direct axis damper";
    parameter SIunits.PerUnit Lambdaf0Pu "Start value of flux of excitation winding";
    parameter SIunits.PerUnit LambdaQ10Pu "Start value of flux of quadrature axis 1st damper";
    parameter SIunits.PerUnit LambdaQ20Pu "Start value of flux of quadrature axis 2nd damper";
    
    parameter SIunits.PerUnit Ce0Pu "Start value of electrical torque in p.u (base SNom/OmegaNom)";
    parameter SIunits.PerUnit Cm0Pu "Start value of mechanical torque in p.u (base PNom/OmegaNom)";
    parameter SIunits.PerUnit Pm0Pu "Start value of mechanical power in p.u (base PNom/OmegaNom)";

    // d-q axis p.u. variables (base UNom, SNom)
    SIunits.PerUnit udPu(start = Ud0Pu) "Voltage of direct axis in p.u";
    SIunits.PerUnit uqPu(start = Uq0Pu) "Voltage of quadrature axis in p.u";
    SIunits.PerUnit idPu(start = Id0Pu) "Current of direct axis in p.u";
    SIunits.PerUnit iqPu(start = Iq0Pu) "Current of quadrature axis in p.u";
    
    SIunits.PerUnit iDPu(start = 0) "Current of direct axis damper in p.u";
    SIunits.PerUnit iQ1Pu(start = 0) "Current of quadrature axis 1st damper in p.u";
    SIunits.PerUnit iQ2Pu(start = 0) "Current of quadrature axis 2nd damper in p.u";
    SIunits.PerUnit ifPu(start = If0Pu) "Current of excitation winding in p.u";
    SIunits.PerUnit ufPu(start = Uf0Pu) "Voltage of exciter winding in p.u (base voltage as per Kundur)";
    
    SIunits.PerUnit lambdadPu(start = Lambdad0Pu) "Flux of direct axis in p.u";
    SIunits.PerUnit lambdaqPu(start = Lambdaq0Pu) "Flux of quadrature axis in p.u";
    SIunits.PerUnit lambdaDPu(start = LambdaD0Pu) "Flux of direct axis damper in p.u";
    SIunits.PerUnit lambdafPu(start = Lambdaf0Pu) "Flux of excitation winding in p.u";
    SIunits.PerUnit lambdaQ1Pu(start = LambdaQ10Pu) "Flux of quadrature axis 1st damper in p.u";
    SIunits.PerUnit lambdaQ2Pu(start = LambdaQ20Pu) "Flux of quadrature axis 2nd damper in p.u";
    
    // Other variables
    SIunits.Angle theta(start = Theta0) "Rotor angle: angle between machine rotor frame and port phasor frame";  
    SIunits.PerUnit cmPu(start = Cm0Pu) "Mechanical torque in p.u (base PNom/OmegaNom)";
    SIunits.PerUnit cePu(start = Ce0Pu) "Electrical torque in p.u (base SNom/OmegaNom)";
    SIunits.PerUnit PePu(start = Ce0Pu*SystemBase.omega0Pu) "Electrical active power in p.u (base SNom)";

equation

  if running.value then

    // Park's transformations
    terminal.V.re =  sin(theta)*udPu + cos(theta)*uqPu;
    terminal.V.im = -cos(theta)*udPu + sin(theta)*uqPu;
    terminal.i.re * SystemBase.SnRef / SNom =  sin(theta)*idPu + cos(theta)*iqPu;
    terminal.i.im * SystemBase.SnRef / SNom = -cos(theta)*idPu + sin(theta)*iqPu;

    // Flux linkages
    lambdadPu = (MdPPu + (LdPPu + XTfoPu)) *idPu +          MdPPu          * ifPu +         MdPPu           *iDPu;
    lambdafPu =           MdPPu            *idPu + (MdPPu + LfPPu + MrcPPu)* ifPu +    (MdPPu + MrcPPu)     *iDPu;
    lambdaDPu =           MdPPu            *idPu +     (MdPPu + MrcPPu)    * ifPu + (MdPPu + LDPPu + MrcPPu)*iDPu;
    lambdaqPu = (MqPPu + (LqPPu + XTfoPu)) *iqPu +          MqPPu          *iQ1Pu +          MqPPu          *iQ2Pu;
    lambdaQ1Pu =          MqPPu            *iqPu +     (MqPPu + LQ1PPu )   *iQ1Pu +          MqPPu          *iQ2Pu;
    lambdaQ2Pu =          MqPPu            *iqPu +          MqPPu          *iQ1Pu +     (MqPPu + LQ2PPu)    *iQ2Pu;

    // Equivalent circuit equations in Park's coordinates
    udPu = (RaPPu + RTfoPu) * idPu - omegaPu.value * lambdaqPu;
    uqPu = (RaPPu + RTfoPu) * iqPu + omegaPu.value * lambdadPu;
    ufPu =  RfPPu *ifPu  + der(lambdafPu)/SystemBase.omegaNom;
    0    =  RDPPu *iDPu  + der(lambdaDPu)/SystemBase.omegaNom;
    0    =  RQ1PPu*iQ1Pu + der(lambdaQ1Pu)/SystemBase.omegaNom;
    0    =  RQ2PPu*iQ2Pu + der(lambdaQ2Pu)/SystemBase.omegaNom;

    // Mechanical equations
    der(theta) = (omegaPu.value - omegaRefPu.value) * SystemBase.omegaNom;
    2*H*der(omegaPu.value) = (cmPu*PNom/SNom - cePu) - DPu*(omegaPu.value - omegaRefPu.value);
    cePu = lambdaqPu*idPu - lambdadPu*iqPu;
    PePu = cePu*omegaPu.value;
    PmPu.value = cmPu*omegaPu.value;

  // Excitation voltage p.u. conversion
    ufPu = efdPu.value * (Kuf * rTfoPu);

  else
    udPu = 0;
    uqPu = 0;
    terminal.i = Complex(0);
    idPu = 0;
    iqPu = 0;
    ifPu = 0;
    iDPu = 0;
    iQ1Pu = 0;
    iQ2Pu = 0;
    lambdadPu = 0;
    lambdaqPu = 0;
    der(lambdafPu) = 0;
    der(lambdaDPu) = 0;
    der(lambdaQ1Pu) = 0;
    der(lambdaQ2Pu) = 0;
    der(theta) = 0;
    der(omegaPu.value) = 0;
    cePu = 0;
    PePu = 0;
    cmPu = 0;
    ufPu = 0;
  end if;

end BaseGeneratorSynchronous;

end BaseClasses;
