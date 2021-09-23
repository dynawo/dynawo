//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
//

/**
 * @file IIDM/extensions/generatorOperatorActivePowerRange/GeneratorOperatorActivePowerRange.h
 * @brief Provides GeneratorOperatorActivePowerRange interface
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATOROPERATORACTIVEPOWERRANGE_GUARD_GENERATOROPERATORACTIVEPOWERRANGE_H
#define LIBIIDM_EXTENSIONS_GENERATOROPERATORACTIVEPOWERRANGE_GUARD_GENERATOROPERATORACTIVEPOWERRANGE_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace generator_operator_activepower_range {

class GeneratorOperatorActivePowerRangeBuilder;

class GeneratorOperatorActivePowerRange : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this GeneratorOperatorActivePowerRange
  IIDM_UNIQUE_PTR<GeneratorOperatorActivePowerRange> clone() const { return IIDM_UNIQUE_PTR<GeneratorOperatorActivePowerRange>(do_clone()); }

protected:
  virtual GeneratorOperatorActivePowerRange* do_clone() const IIDM_OVERRIDE;

private:
  GeneratorOperatorActivePowerRange(double activePowerLimitation);

  friend class GeneratorOperatorActivePowerRangeBuilder;

public:
  GeneratorOperatorActivePowerRange& activePowerLimitation(double activePowerLimitation) {
    m_activePowerLimitation = checkActivePowerLimitation(activePowerLimitation);
    return *this;
  }

  double activePowerLimitation() const {
      return m_activePowerLimitation;
  }

private:
  double checkActivePowerLimitation(double activePowerLimitation) const;

  double m_activePowerLimitation;
};

} // end of namespace IIDM::extensions::generator_operator_activepower_range::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
