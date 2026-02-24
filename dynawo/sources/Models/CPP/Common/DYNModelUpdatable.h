//
// Copyright (c) 2025, RTE
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  DYNModelUpdatable.h
 *
 * @brief Continuous updatable parameter header
 *
 */

#ifndef MODELS_CPP_COMMON_DYNMODELUPDATABLE_H_
#define MODELS_CPP_COMMON_DYNMODELUPDATABLE_H_

#include "DYNModelCPP.h"
#include "DYNModelConstants.h"
#include "DYNSubModelFactory.h"
#include "PARParametersSet.h"

namespace DYN {
class DataInterface;

/**
 * class DYNModelUpdatable
 */
class ModelUpdatable : public ModelCPP {
 public:
  /**
   * @brief constructor
   * @param modelType model's type
   */
  explicit ModelUpdatable(const std::string& modelType);

  /**
   * @copydoc ModelCPP::init()
   */
  void init(const double t0) override;

  /**
   * @copydoc ModelCPP::evalF()
   */
  void evalF(double t, propertyF_t type) override;

  /**
   * @copydoc ModelCPP::evalZ()
   */
  void evalZ(const double t) override;

  /**
   * @copydoc ModelCPP::collectSilentZ()
   */
  void collectSilentZ(BitMask* silentZTable) override;

  /**
   * @copydoc ModelCPP::evalCalculatedVars()
   */
  void evalCalculatedVars() override;

  /**
   * @copydoc ModelCPP::evalJt()
   */
  void evalJt(double t, double cj, int rowOffset, SparseMatrix& jt) override;

  /**
   * @copydoc ModelCPP::evalJtPrim()
   */
  void evalJtPrim(const double t, const double cj, const int rowOffset, SparseMatrix& jtPrim) override;

  /**
   * @copydoc ModelCPP::evalStaticFType()
   */
  void evalStaticFType() override;

  /**
   * @copydoc ModelCPP::evalDynamicFType()
   */
  void evalDynamicFType() override;

  /**
   * @copydoc ModelCPP::getY0()
   */
  void getY0() override;

  /**
   * @copydoc ModelCPP::evalStaticYType()
   */
  void evalStaticYType() override;

  /**
   * @copydoc ModelCPP::evalDynamicYType()
   */
  void evalDynamicYType() override;

  /**
   * @copydoc ModelCPP::getIndexesOfVariablesUsedForCalculatedVarI()
   */
  void getIndexesOfVariablesUsedForCalculatedVarI(unsigned iCalculatedVar, std::vector<int>& indexes) const override;

  /**
   * @copydoc ModelCPP::evalJCalculatedVarI()
   */
  void evalJCalculatedVarI(unsigned iCalculatedVar, std::vector<double>& res) const override;

  /**
   * @copydoc ModelCPP::initializeStaticData()
   */
  void initializeStaticData() override;

  /**
   * @copydoc ModelCPP::initializeFromData()
   */
  void initializeFromData(const boost::shared_ptr<DataInterface>& data) override;

  /**
   * @copydoc ModelCPP::setFequations()
   */
  void setFequations() override;

  /**
   * @copydoc ModelCPP::initParams()
   */
  void initParams() override;

 protected:
  double inputValue_;      ///< updatable value
  bool updated_;           ///< @b true if updated from external input
};

}  // namespace DYN

#endif  // MODELS_CPP_COMMON_DYNMODELUPDATABLE_H_
