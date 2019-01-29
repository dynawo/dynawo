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
 * @file IIDM/extensions/generatorEntsoeCategory/GeneratorEntsoeCategory.h
 * @brief Provides GeneratorEntsoeCategory interface
 */

#ifndef LIBIIDM_EXTENSIONS_GENERATORENTSOECATEGORY_GUARD_GENERATORENTSOECATEGORY_H
#define LIBIIDM_EXTENSIONS_GENERATORENTSOECATEGORY_GUARD_GENERATORENTSOECATEGORY_H

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

#include <boost/lexical_cast.hpp>

namespace IIDM {
namespace extensions {
namespace generator_entsoe_category {

class GeneratorEntsoeCategoryBuilder;

class GeneratorEntsoeCategory : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  /// clones this GeneratorEntsoeCategory
  IIDM_UNIQUE_PTR<GeneratorEntsoeCategory> clone() const { return IIDM_UNIQUE_PTR<GeneratorEntsoeCategory>(do_clone()); }
  
protected:
  virtual GeneratorEntsoeCategory* do_clone() const IIDM_OVERRIDE;

private:
  GeneratorEntsoeCategory() {}
  friend class GeneratorEntsoeCategoryBuilder;

public:
  unsigned int code() const { return m_code; }
  
  GeneratorEntsoeCategory& code(unsigned int code) {
    if (code < 1 || code > 42) {
      throw std::runtime_error("Bad generator ENTSO-E code " + boost::lexical_cast<std::string>(code));
    }
    m_code = code;
    return *this;
  }

private:
  unsigned int m_code;
};

} // end of namespace IIDM::extensions::generator_entsoe_category::
} // end of namespace IIDM::extensions::
} // end of namespace IIDM::

#endif
