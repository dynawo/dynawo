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
  AbsLimRateLimFeedthroughFreeze.mo
  AbsLimRateLimFeedthroughFreezeLimDetection.mo
  AbsLimRateLimFirstOrderAntiWindup.mo
  AbsLimRateLimFirstOrderFreeze.mo
  AbsLimRateLimFirstOrderFreezeLimDetection.mo
  AntiWindupIntegrator.mo
  DecreaseDetection.mo
  DiscreteIntegrator.mo
  DiscreteIntegrator.extvar
  IncreaseDetection.mo
  IntegratorWithReset.mo
  IntegratorSetFreeze.mo
  IntegratorVariableLimits.mo
  LeadMOrderLag.mo
  LimitedPI.mo
  LimPIDFreeze.mo
  PI.mo
  PIAntiWindup.mo
  PIAntiWindupVariableLimits.mo
  PIFreeze.mo
  Power.mo
  RampTrackingFilter.mo
  RateLimFirstOrderFreeze.mo
  SecondOrder.mo
  SqrtNoEvent.mo
  TransferFunction.mo
  TransferFunctionBypass.mo
  VarLimPIDFreeze.mo
  Washout.mo
  WeightedDifference.mo
  WeightedDifference.extvar
  )

#
# Modelica models install
#
foreach(MODEL_FILE ${MODEL_FILES})
  install_model_file(${MODEL_FILE})
endforeach(MODEL_FILE)
