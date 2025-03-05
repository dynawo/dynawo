# Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
# See AUTHORS.txt
# All rights reserved.
# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, you can obtain one at http://mozilla.org/MPL/2.0/.
# SPDX-License-Identifier: MPL-2.0
#
# This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.

add_subdirectory(BaseClasses B)

set(MODEL_FILES
  package.mo
  package.order
  BacklashHysteresis.mo
  DeadBand.mo
  DeadZone.mo
  DelayFlag.mo
  FirstOrderVariableLimitsAntiWindup.mo
  FixedBooleanDelay.mo
  FlipFlopR.mo
  FlipFlopS.mo
  IntegratorOrFirstOrder.mo
  IntegratorVariableLimitsContinuousSetFreeze.mo
  LimitedDivision.mo
  LimitedFirstOrder.mo
  LimitedIntegrator.mo
  LimitedIntegratorFreeze.mo
  LimitedLeadLag.mo
  LimiterAtCurrentValueWithLag.mo
  LimiterAtCurrentValueWithLag_INIT.mo
  LimiterWithLag.mo
  LimiterWithLag_INIT.mo
  LimRateLimFirstOrder.mo
  MaxThresholdSwitch.mo
  MinThresholdSwitch.mo
  MultiSwitch.mo
  PIAntiWindUpTable.mo
  PIAntiWindUpTable.extvar
  PulseFixedDuration.mo
  PulseMinimumDuration.mo
  RampLimiter.mo
  StandAloneRampRateLimiter.mo
  ConditionalForward.mo
  ConditionalForward.extvar
  SwitchInteger.mo
  VariableDelayFlag.mo
  VariableLimiter.mo
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
