within Dynawo.Electrical.Machines.Motors;

/*
* Copyright (c) 2024, RTE (http://www.rte-france.com)
* See AUTHORS.txt
* All rights reserved.
* This Source Code Form is subject to the terms of the Mozilla Public
* License, v. 2.0. If a copy of the MPL was not distributed with this
* file, you can obtain one at http://mozilla.org/MPL/2.0/.
* SPDX-License-Identifier: MPL-2.0
*
* This file is part of Dynawo, a hybrid C++/Modelica open source suite
* of simulation tools for power systems.
*/

model MotorFifthOrder "Two-cage (or one-cage if Lpp = Lp) induction motor model, based on https://www.powerworld.com/WebHelp/Content/TransientModels_HTML/Load%20Characteristic%20MOTORW.htm, must be incorporated in a load model."
  extends BaseClasses.BaseMotor;
  extends AdditionalIcons.Machine;
  import Modelica.Constants;

  parameter Types.PerUnit RsPu "Stator resistance in pu (base SNom, UNom)";
  parameter Types.PerUnit LsPu "Synchronous reactance in pu (base SNom, UNom)";
  // Notation: L (reactance) + P ("'" or "Prim") + Pu (Per unit)
  parameter Types.PerUnit LPPu "Transient reactance in pu (base SNom, UNom)";
  parameter Types.PerUnit LPPPu "Subtransient reactance in pu (base SNom, UNom)";
  parameter Types.Time tP0 "Transient open circuit time constant in s";
  parameter Types.Time tPP0 "Subtransient open circuit time constant in s";
  parameter Real torqueExponent "Exponent of the torque speed dependency";
  parameter Types.Time H "Kinetic constant = kinetic energy / rated power, in s";

  parameter Types.VoltageModulePu Utrip1Pu "Voltage at which the first block of motors trip in pu (base UNom)";
  parameter Types.Time tTrip1Pu "Time lag before tripping of the first block of motors in s";
  parameter Real shareTrip1Pu(min=0, max=1) "Share of motors in the first block of motors";
  parameter Types.VoltageModulePu Ureconnect1Pu "Voltage at which the first block of motors reconnects in pu (base Unom)";
  parameter Types.Time tReconnect1Pu "Time lag before reconnection of the first block of motors in s";
  parameter Types.VoltageModulePu Utrip2Pu "Voltage at which the second block of motors trip in pu (base UNom)";
  parameter Types.Time tTrip2Pu "Time lag before tripping of the second block of motors in s";
  parameter Real shareTrip2Pu(min=0, max=1) "Share of motors in the second block of motors";
  parameter Types.VoltageModulePu Ureconnect2Pu "Voltage at which the second block of motors reconnects in pu (base Unom)";
  parameter Types.Time tReconnect2Pu "Time lag before reconnection of the second block of motors in s";

  Types.AngularVelocityPu omegaRPu(start = omegaR0Pu) "Angular velocity of the motor in pu (base omegaNom)";
  Types.PerUnit EdPPu(start = EdP0Pu) "Voltage behind transient reactance d component in pu (base UNom)";
  Types.PerUnit EqPPu(start = EqP0Pu) "Voltage behind transient reactance q component in pu (base UNom)";
  Types.PerUnit EdPPPu(start = EdPP0Pu) "Voltage behind subtransient reactance d component in pu (base UNom)";
  Types.PerUnit EqPPPu(start = EqPP0Pu) "Voltage behind subtransient reactance q component in pu (base UNom)";
  Types.PerUnit idPu(start = id0Pu) "Current of direct axis in pu (base SNom, UNom)";
  Types.PerUnit iqPu(start = iq0Pu) "Current of quadrature axis in pu (base SNom, UNom)";
  Real s(start = s0) "Slip of the motor";
  Types.PerUnit cePu(start = ce0Pu) "Electrical torque in pu (base SNom, omegaNom)";
  Types.PerUnit clPu(start = ce0Pu) "Load torque in pu (base SNom, omegaNom)";
  Types.ActivePowerPu PRawPu(start = s0Pu.re) "Active power at load terminal without considering diconnections in pu (base SnRef) (receptor convention)";
  Types.ReactivePowerPu QRawPu(start = s0Pu.im) "Reactive power at load terminal without considering diconnections in pu (base SnRef) (receptor convention)";
  Types.VoltageModulePu UPu(start = ComplexMath.'abs'(u0Pu)) "Voltage amplitude at load terminal in pu (base UNom)";
  Types.Time tTripThresholdReached1(start = Constants.inf) "Time when the trip threshold 1 was reached in s";
  Types.Time tTripThresholdReached2(start = Constants.inf) "Time when the trip threshold 2 was reached in s";
  Types.Time tReconnectThresholdReached1(start = Constants.inf) "Time when the reconnect threshold 1 was reached in s";
  Types.Time tReconnectThresholdReached2(start = Constants.inf) "Time when the reconnect threshold 2 was reached in s";
  Boolean connected1(start = true) "True if the first block of motors is connected";
  Boolean connected2(start = true) "True if the second block of motors is connected";

  // Initial values
  parameter Types.PerUnit EdP0Pu "Start value of voltage behind transient reactance d component in pu (base UNom)";
  parameter Types.PerUnit EqP0Pu "Start value of voltage behind transient reactance q component in pu (base UNom)";
  parameter Types.PerUnit EdPP0Pu "Start value of voltage behind subtransient reactance d component in pu (base UNom)";
  parameter Types.PerUnit EqPP0Pu "Start value of voltage behind subtransient reactance q component in pu (base UNom)";
  parameter Types.PerUnit id0Pu "Start value of current of direct axis in pu (base SNom, UNom)";
  parameter Types.PerUnit iq0Pu "Start value of current of quadrature axis in pu (base SNom, UNom)";
  parameter Types.AngularVelocityPu omegaR0Pu "Start value of the angular velocity of the motor in pu (base omegaNom)";
  parameter Types.PerUnit ce0Pu "Start value of the electrical torque in pu (base SNom, omegaNom)";
  parameter Real s0 "Start value of the slip of the motor";

equation
  assert(shareTrip1Pu + shareTrip2Pu <= 1, "Total share of motors that trip should be lower or equal to 1");
  if (running.value) then
    der(EqPPu) * tP0 = -EqPPu + idPu * (LsPu - LPPu) - EdPPu * SystemBase.omegaNom * omegaRefPu.value * s * tP0;
    der(EdPPu) * tP0 = -EdPPu - iqPu * (LsPu - LPPu) + EqPPu * SystemBase.omegaNom * omegaRefPu.value * s * tP0;
    der(EqPPPu) = der(EqPPu) + 1/tPP0 * (EqPPu - EqPPPu + (LPPu - LPPPu) * idPu) + SystemBase.omegaNom * omegaRefPu.value * s * (EdPPu - EdPPPu);
    der(EdPPPu) = der(EdPPu) + 1/tPP0 * (EdPPu - EdPPPu - (LPPu - LPPPu) * iqPu) - SystemBase.omegaNom * omegaRefPu.value * s * (EqPPu - EqPPPu);

    V = Complex(EdPPPu, EqPPPu) + Complex(RsPu, LPPPu) * Complex(idPu, iqPu);
    Complex(PRawPu, QRawPu) = V * Complex(idPu, -iqPu) * (SNom / SystemBase.SnRef);

    if connected1 and connected2 then
      Complex(PPu, QPu) = Complex(PRawPu, QRawPu);
    elseif connected1 and not connected2 then
      Complex(PPu, QPu) = Complex(PRawPu, QRawPu) * (1-shareTrip2Pu);
    elseif not connected1 and connected2 then
      Complex(PPu, QPu) = Complex(PRawPu, QRawPu) * (1-shareTrip1Pu);
    else
      Complex(PPu, QPu) = Complex(PRawPu, QRawPu) * (1-shareTrip1Pu-shareTrip2Pu);
    end if;

    s = (omegaRefPu.value - omegaRPu) / omegaRefPu.value;
    cePu = EdPPPu * idPu + EqPPPu * iqPu;
    clPu = ce0Pu * (omegaRPu / omegaR0Pu)^torqueExponent;
    2 * H * der(omegaRPu) = cePu - clPu;
  else
    der(EqPPu) = 0;
    der(EdPPu) = 0;
    der(EqPPPu) = 0;
    der(EdPPPu) = 0;
    idPu = 0;
    iqPu = 0;
    SPu = Complex(0);
    PRawPu = 0;
    QRawPu = 0;
    s = 0;
    cePu = 0;
    clPu = 0;
    der(omegaRPu) = 0;
  end if;

  if ((V.re == 0) and (V.im == 0)) then
    UPu = 0.;
  else
    UPu = ComplexMath.'abs'(V);
  end if;

  // Trip block 1
  when UPu <= Utrip1Pu and pre(connected1) and running.value then
    tTripThresholdReached1 = time;
  elsewhen UPu > Utrip1Pu and pre(tTripThresholdReached1) <> Constants.inf and pre(connected1) and running.value then
    tTripThresholdReached1 = Constants.inf;
  end when;
  when UPu >= Ureconnect1Pu and not(pre(connected1)) and running.value then
    tReconnectThresholdReached1 = time;
  elsewhen UPu < Ureconnect1Pu and pre(tReconnectThresholdReached1) <> Constants.inf and not(pre(connected1)) and running.value then
    tReconnectThresholdReached1 = Constants.inf;
  end when;
  when time - tTripThresholdReached1 >= tTrip1Pu and running.value then
    connected1 = false;
  elsewhen time - tReconnectThresholdReached1 >= tReconnect1Pu and running.value then
    connected1 = true;
  end when;

  // Trip block 2
  when UPu <= Utrip2Pu and pre(connected2) and running.value then
    tTripThresholdReached2 = time;
  elsewhen UPu > Utrip2Pu and pre(tTripThresholdReached1) <> Constants.inf and pre(connected2) and running.value then
    tTripThresholdReached2 = Constants.inf;
  end when;
  when UPu >= Ureconnect2Pu and not(pre(connected2)) and running.value then
    tReconnectThresholdReached2 = time;
  elsewhen UPu < Ureconnect2Pu and pre(tReconnectThresholdReached2) <> Constants.inf and not(pre(connected2)) and running.value then
    tReconnectThresholdReached2 = Constants.inf;
  end when;
  when time - tTripThresholdReached2 >= tTrip2Pu and running.value then
    connected2 = false;
  elsewhen time - tReconnectThresholdReached2 >= tReconnect2Pu and running.value then
    connected2 = true;
  end when;

  annotation(preferredView = "text");
end MotorFifthOrder;
