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
 * @file IIDM/extensions/generatorStartup/GeneratorStartup.h
 * @brief Provides GeneratorStartup interface
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATORSTARTUP_GUARD_GENERATORSTARTUP_H
#define LIBIIDM_EXTENSIONS_GENERATORSTARTUP_GUARD_GENERATORSTARTUP_H

#include <boost/optional.hpp>

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace generator_startup {

class GeneratorStartupBuilder;

class GeneratorStartup : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this GeneratorStartup
  IIDM_UNIQUE_PTR<GeneratorStartup> clone() const { return IIDM_UNIQUE_PTR<GeneratorStartup>(do_clone()); }

protected:
  virtual GeneratorStartup* do_clone() const IIDM_OVERRIDE;

private:
  GeneratorStartup() {}
  friend class GeneratorStartupBuilder;

public:
  boost::optional<float> const& predefinedActivePowerSetpoint() const { return m_predefinedActivePowerSetpoint; }
  GeneratorStartup& predefinedActivePowerSetpoint(boost::optional<float> const& predefinedActivePowerSetpoint)
  { m_predefinedActivePowerSetpoint = predefinedActivePowerSetpoint; return *this; }

  boost::optional<float> const& marginalCost() const { return m_marginalCost; }
  GeneratorStartup& marginalCost(boost::optional<float> const& marginalCost)
  { m_marginalCost = marginalCost; return *this; }

  boost::optional<float> const& plannedOutageRate() const { return m_plannedOutageRate; }
  GeneratorStartup& plannedOutageRate(boost::optional<float> const& plannedOutageRate)
  { m_plannedOutageRate = plannedOutageRate; return *this; }

  boost::optional<float> const& forcedOutageRate() const { return m_forcedOutageRate; }
  GeneratorStartup& forcedOutageRate(boost::optional<float> const& forcedOutageRate)
  { m_forcedOutageRate = forcedOutageRate; return *this; }

private:
  boost::optional<float> m_marginalCost;
  boost::optional<float> m_predefinedActivePowerSetpoint;
  boost::optional<float> m_plannedOutageRate;
  boost::optional<float> m_forcedOutageRate;
};

} // end of namespace IIDM::extensions::generator_startup::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
