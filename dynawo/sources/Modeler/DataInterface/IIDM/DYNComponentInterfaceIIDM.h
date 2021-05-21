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
 * @file  DataInterface/IIDM/DYNComponentInterfaceIIDM.h
 *
 * @brief IIDM Component data interface : header file
 *
 */
#ifndef MODELER_DATAINTERFACE_IIDM_DYNCOMPONENTINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNCOMPONENTINTERFACEIIDM_H_

#include "DYNComponentInterface.hpp"

namespace DYN {

class ComponentInterfaceIIDM : virtual public ComponentInterface {
 public:
  /// @brief Default constructor
  ComponentInterfaceIIDM();

  /// @brief Destructor
  virtual ~ComponentInterfaceIIDM();

  /**
   * @copydoc ComponentInterface::hasDynamicModel(bool hasDynamicModel)
   */
  void hasDynamicModel(bool hasDynamicModel);

  /**
   * @copydoc ComponentInterface::setModelDyn(const boost::shared_ptr<SubModel>& model)
   */
  void setModelDyn(const boost::shared_ptr<SubModel>& model);

  /**
   * @copydoc ComponentInterface::hasDynamicModel() const
   */
  bool hasDynamicModel() const;

 protected:
  /**
   * @copydoc ComponentInterface::getModelDyn() const
   */
  boost::shared_ptr<SubModel> getModelDyn() const;

 protected:
  bool hasDynamicModel_;                  ///< @b true is component has a dynamic model (other than c++ one), @b false else
  boost::shared_ptr<SubModel> modelDyn_;  ///< dynamic model of the component
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNCOMPONENTINTERFACEIIDM_H_
