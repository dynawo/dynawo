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
 * @file API/CSTR/test/Test.cpp
 * @brief Unit tests for API_CSTR
 *
 */

#include "gtest_dynawo.h"

#include "CSTRConstraintsCollectionFactory.h"
#include "CSTRConstraintsCollection.h"
#include "CSTRConstraint.h"
#include "CSTRXmlExporter.h"
#include "CSTRTxtExporter.h"


namespace constraints {

//-----------------------------------------------------
// TEST for Constraints collection
//-----------------------------------------------------

TEST(APICSTRTest, CollectionAddConstraints) {
  boost::shared_ptr<ConstraintsCollection> collection;
  collection = ConstraintsCollectionFactory::newInstance("test");

  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_BEGIN);  // add first constraint
  collection->addConstraint("model", "constraint 2", 0, CONSTRAINT_BEGIN);  // add second constraint with different description

  int nbConstraint = 0;
  for (ConstraintsCollection::const_iterator itConstraint = collection->cbegin();
          itConstraint != collection->cend();
          ++itConstraint)
    ++nbConstraint;

  ASSERT_EQ(nbConstraint, 2);  // the two constraints have been added

  // export
  XmlExporter XmlExporter;
  ASSERT_NO_THROW(XmlExporter.exportToFile(collection, "constraint.xml"));
  TxtExporter TxtExporter;
  ASSERT_NO_THROW(TxtExporter.exportToFile(collection, "constraint.txt"));
}

TEST(APICSTRTest, CollectionEraseConstraint) {
  boost::shared_ptr<ConstraintsCollection> collection;
  collection = ConstraintsCollectionFactory::newInstance("test");

  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_BEGIN);  // add first constraint
  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_END);    // add second constraint with same description and type CONSTRAINT_END

  int nbConstraint = 0;
  for (ConstraintsCollection::const_iterator itConstraint = collection->cbegin();
          itConstraint != collection->cend();
          ++itConstraint)
    ++nbConstraint;

  ASSERT_EQ(nbConstraint, 0);  // the constraint has been erased
}

}  // namespace constraints
