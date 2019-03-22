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
 * @file IIDM/extensions/busbarSectionPosition/BusbarSectionPosition.h
 * @brief Provides BusbarSectionPosition interface
 */

#ifndef LIBIIDM_EXTENSIONS_BUSBARSECTIONPOSITION_GUARD_BUSBARSECTIONPOSITION_H
#define LIBIIDM_EXTENSIONS_BUSBARSECTIONPOSITION_GUARD_BUSBARSECTIONPOSITION_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace busbarsection_position {

class BusbarSectionPositionBuilder;

class BusbarSectionPosition : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this BusbarSectionPosition
  IIDM_UNIQUE_PTR<BusbarSectionPosition> clone() const { return IIDM_UNIQUE_PTR<BusbarSectionPosition>(do_clone()); }

protected:
  virtual BusbarSectionPosition* do_clone() const IIDM_OVERRIDE;

private:
  BusbarSectionPosition() {}
  friend class BusbarSectionPositionBuilder;

public:
  /**
   * @brief defines the busbar index
   * @return the value of the busbar index
   */
  unsigned int busbarIndex() const { return m_busbarIndex; }

  /**
   * @brief defines the busbar index
   * @param index the new value
   * @return this BusbarSectionPosition
   */
  BusbarSectionPosition& busbarIndex(unsigned int index) { m_busbarIndex = index; return *this; }

  /**
   * @brief gets the section index
   * @return the value of the section index
   */
  unsigned int sectionIndex() const { return m_sectionIndex; }

  /**
   * @brief defines the section index
   * @param index the new value
   * @return this BusbarSectionPosition
   */
  BusbarSectionPosition& sectionIndex(unsigned int index) { m_sectionIndex = index; return *this; }


private:
  unsigned int m_busbarIndex;
  unsigned int m_sectionIndex;
};

} // end of namespace IIDM::extensions::busbarsection_position::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
