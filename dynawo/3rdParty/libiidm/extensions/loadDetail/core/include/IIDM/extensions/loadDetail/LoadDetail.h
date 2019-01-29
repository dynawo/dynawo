//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//

/**
 * @file IIDM/extensions/loadDetail/LoadDetail.h
 * @brief Provides LoadDetail interface
 */

#ifndef LIBIIDM_EXTENSIONS_LOADDETAIL_GUARD_LOADDETAIL_H
#define LIBIIDM_EXTENSIONS_LOADDETAIL_GUARD_LOADDETAIL_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace load_detail {

class LoadDetailBuilder;

class LoadDetail : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this LoadDetail
  IIDM_UNIQUE_PTR<LoadDetail> clone() const { return IIDM_UNIQUE_PTR<LoadDetail>(do_clone()); }
  
protected:
  virtual LoadDetail* do_clone() const IIDM_OVERRIDE;

private:
  LoadDetail() {}
  friend class LoadDetailBuilder;

public:
  float fixedActivePower() const { return m_fixedActivePower; }
  
  LoadDetail& fixedActivePower(float fixedActivePower) { m_fixedActivePower = fixedActivePower; return *this; }

  float fixedReactivePower() const { return m_fixedReactivePower; }

  LoadDetail& fixedReactivePower(float fixedReactivePower) { m_fixedReactivePower = fixedReactivePower; return *this; }

  float variableActivePower() const { return m_variableActivePower; }

  LoadDetail& variableActivePower(float variableActivePower) { m_variableActivePower = variableActivePower; return *this; }

  float variableReactivePower() const { return m_variableReactivePower; }

  LoadDetail& variableReactivePower(float variableReactivePower) { m_variableReactivePower = variableReactivePower; return *this; }

private:
  float m_fixedActivePower;
  float m_fixedReactivePower;
  float m_variableActivePower;
  float m_variableReactivePower;
};

} // end of namespace IIDM::extensions::load_detail::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
