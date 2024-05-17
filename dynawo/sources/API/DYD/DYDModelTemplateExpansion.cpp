//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
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
 * @file DYDModelTemplateExpansion.cpp
 * @brief Model template expansion description : implementation file
 *
 */

#include "DYDModelTemplateExpansion.h"

#include "DYNMacrosMessage.h"

using std::string;

using boost::shared_ptr;

namespace dynamicdata {

ModelTemplateExpansion::ModelTemplateExpansion(const string& id) : Model(id, Model::MODEL_TEMPLATE_EXPANSION) {}

const std::string&
ModelTemplateExpansion::getTemplateId() const {
  return templateId_;
}

ModelTemplateExpansion&
ModelTemplateExpansion::setTemplateId(const string& templateId) {
  templateId_ = templateId;
  return *this;
}

const string&
ModelTemplateExpansion::getStaticId() const {
  return staticId_;
}

ModelTemplateExpansion&
ModelTemplateExpansion::setStaticId(const string& staticId) {
  staticId_ = staticId;
  return *this;
}

ModelTemplateExpansion&
ModelTemplateExpansion::setParFile(const string& parFile) {
  parFile_ = parFile;
  return *this;
}

ModelTemplateExpansion&
ModelTemplateExpansion::setParId(const string& parId) {
  parId_ = parId;
  return *this;
}

const string&
ModelTemplateExpansion::getParFile() const {
  return parFile_;
}

const string&
ModelTemplateExpansion::getParId() const {
  return parId_;
}

}  // namespace dynamicdata
