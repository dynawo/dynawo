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
 * @file  CSTRTxtExporter.cpp
 *
 * @brief Dynawo constraints txt exporter : implementation file
 *
 */
#include <fstream>
#include <sstream>

#include "DYNMacrosMessage.h"

#include "CSTRTxtExporter.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"

using std::fstream;
using std::ostream;
using std::string;

using boost::shared_ptr;

namespace constraints {

void
TxtExporter::exportToFile(const boost::shared_ptr<ConstraintsCollection>& constraints, const string& filePath) const {
  fstream file;
  file.open(filePath.c_str(), fstream::out);
  if (!file.is_open()) {
    throw DYNError(DYN::Error::API, FileGenerationFailed, filePath.c_str());
  }
  exportToStream(constraints, file);
  file.close();
}

void
TxtExporter::exportToStream(const boost::shared_ptr<ConstraintsCollection>& constraints, ostream& stream) const {
  const std::string TXTEXPORTER_SEPARATOR = " | ";  ///< separator in txt file
  for (ConstraintsCollection::const_iterator itConstraint = constraints->cbegin();
          itConstraint != constraints->cend();
          ++itConstraint) {
    stream << (*itConstraint)->getModelName()
            << TXTEXPORTER_SEPARATOR
            << (*itConstraint)->getTime()
            << TXTEXPORTER_SEPARATOR
            << (*itConstraint)->getDescription();
    if ((*itConstraint)->hasModelType())
      stream << (*itConstraint)->getModelType()
             << TXTEXPORTER_SEPARATOR;
    stream << "\n";
  }
}

}  // namespace constraints
