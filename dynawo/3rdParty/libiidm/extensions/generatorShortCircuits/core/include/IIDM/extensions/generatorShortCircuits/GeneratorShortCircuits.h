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
 * @file IIDM/extensions/generatorShortCircuits/GeneratorShortCircuits.h
 * @brief Provides GeneratorShortCircuits interface
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATORSHORTCIRCUITS_GUARD_GENERATORSHORTCIRCUITS_H
#define LIBIIDM_EXTENSIONS_GENERATORSHORTCIRCUITS_GUARD_GENERATORSHORTCIRCUITS_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

namespace IIDM {
namespace extensions {
namespace generatorshortcircuits {

class GeneratorShortCircuitsBuilder;

class GeneratorShortCircuits : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  IIDM_UNIQUE_PTR<GeneratorShortCircuits> clone() const { return IIDM_UNIQUE_PTR<GeneratorShortCircuits>(do_clone()); }
  
protected:
  virtual GeneratorShortCircuits* do_clone() const IIDM_OVERRIDE;

private:
  GeneratorShortCircuits() {}
  friend class GeneratorShortCircuitsBuilder;

public:
  double transientReactance() const { return m_transientReactance; }

  double stepUpTransformerReactance() const { return m_stepUpTransformerReactance; }

  GeneratorShortCircuits& transientReactance(double value) { m_transientReactance = value; return *this; }

  GeneratorShortCircuits& stepUpTransformerReactance(double value) { m_stepUpTransformerReactance = value; return *this; }
  
private:
  double m_stepUpTransformerReactance;
  double m_transientReactance;
};

} // end of namespace IIDM::extensions::generatorshortcircuits::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
