//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file  PowSyblIIDM/DYNComponentInterfaceIIDM.h
 *
 * @brief IIDM Component data interface : header file
 *
 */
#ifndef MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCOMPONENTINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCOMPONENTINTERFACEIIDM_H_

#include "DYNComponentInterface.hpp"
#include "DYNSafeUnorderedMapThread.hpp"

#include <mutex>
#include <thread>
#include <unordered_map>

namespace DYN {
/**
 * @brief IIDM implementation of component interface
 */
class ComponentInterfaceIIDM : virtual public ComponentInterface {
 public:
  /// @brief Destructor
  virtual ~ComponentInterfaceIIDM();

  /**
   * @copydoc ComponentInterface::hasDynamicModel(bool hasDynamicModel)
   */
  void hasDynamicModel(bool hasDynamicModel) final;

  /**
   * @copydoc ComponentInterface::setModelDyn(const boost::shared_ptr<SubModel>& model)
   */
  void setModelDyn(const boost::shared_ptr<SubModel>& model) final;

  /**
   * @copydoc ComponentInterface::hasDynamicModel() const
   */
  bool hasDynamicModel() const final;

 protected:
  /**
   * @brief Structure defining a dynamic model
   */
  struct DynamicModelDef {
    /// @brief default Constructor
    DynamicModelDef() = default;

    /**
     * @brief Constructor
     *
     * @param hasDynamicModel determine if the component has a dynamic model
     * @param modelDyn the dynamic model to use
     */
    explicit DynamicModelDef(bool hasDynamicModel, const boost::shared_ptr<SubModel>& modelDyn) : hasDynamicModel_(hasDynamicModel), modelDyn_(modelDyn) {}
    bool hasDynamicModel_ = false;          ///< @b true is component has a dynamic model (other than c++ one), @b false else
    boost::shared_ptr<SubModel> modelDyn_;  ///< dynamic model of the component
  };

  /**
   * @copydoc ComponentInterface::getModelDyn() const
   */
  boost::shared_ptr<SubModel> getModelDyn() const final;

 protected:
  SafeUnorderedMapThread<DynamicModelDef> dynamicDef_;  ///< table of dynamic models, at most one by thread
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_POWSYBLIIDM_DYNCOMPONENTINTERFACEIIDM_H_
