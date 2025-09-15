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
#include "DYNEnumUtils.h"


namespace constraints {

//-----------------------------------------------------
// TEST for Constraints collection
//-----------------------------------------------------

TEST(APICSTRTest, CollectionAddConstraints) {
  std::shared_ptr<ConstraintsCollection> collection;
  collection = ConstraintsCollectionFactory::newInstance("test");

  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_BEGIN);  // add first constraint
  collection->addConstraint("model", "constraint 2", 0, CONSTRAINT_BEGIN);  // add second constraint with different description
  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_END);    // add end constraint (everything should be kept)

  auto nbConstraint = collection->getConstraintsById().size();
  ASSERT_EQ(nbConstraint, 3);  // the three constraints have been added

  // export
  XmlExporter XmlExporter;
  ASSERT_NO_THROW(XmlExporter.exportToFile(collection, "constraint.xml"));
  TxtExporter TxtExporter;
  ASSERT_NO_THROW(TxtExporter.exportToFile(collection, "constraint.txt"));
}

TEST(APICSTRTest, CollectionAddConstraintsWithDetails) {
  std::shared_ptr<ConstraintsCollection> collection;
  collection = ConstraintsCollectionFactory::newInstance("test");

  int side = 1;
  double acceptableDuration = 60;
  collection->addConstraint("model", "constraint U", 0, CONSTRAINT_BEGIN, "Bus",
    ConstraintData(ConstraintData::USupUmax, 132.0, 133.0));
  collection->addConstraint("model", "constraint I", 0, CONSTRAINT_BEGIN, "Line",
    ConstraintData(ConstraintData::OverloadUp, 1000, 1001, side, acceptableDuration));
  collection->addConstraint("model", "constraint I", 0, CONSTRAINT_BEGIN, "Line",
    ConstraintData(ConstraintData::PATL, 1100, 1111, side));

  auto nbConstraint = collection->getConstraintsById().size();
  ASSERT_EQ(nbConstraint, 2);  // the two constraints have been added

  // export
  XmlExporter XmlExporter;
  ASSERT_NO_THROW(XmlExporter.exportToFile(collection, "constraint.xml"));
  TxtExporter TxtExporter;
  ASSERT_NO_THROW(TxtExporter.exportToFile(collection, "constraint.txt"));
}

TEST(APICSTRTest, CollectionFilterConstraintKeepFirst) {
  std::unique_ptr<ConstraintsCollection> collection;
  collection = ConstraintsCollectionFactory::newInstance("test");

  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 133.0));    // add first constraint
  collection->addConstraint("model", "constraint 1", 2, CONSTRAINT_END, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 128.0));      // add second constraint with same description and type CONSTRAINT_END
  collection->addConstraint("model", "constraint 2", 4, CONSTRAINT_END, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 133.0));      // add END constraint (should not happen but who knows...)
  collection->addConstraint("model", "constraint 3", 7, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 133.0));    // add first constraint 3
  collection->addConstraint("model", "constraint 1", 8, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 134.0));    // add BEGIN constraint 1
  collection->addConstraint("model", "constraint 1", 9, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 135.0));    // add BEGIN constraint 1
  collection->addConstraint("model", "constraint 1", 10, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 136.0));    // add BEGIN constraint 1
  collection->addConstraint("model", "constraint 3", 8, CONSTRAINT_END, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 128.0));      // add END constraint 3

  auto nbConstraint = collection->getConstraintsById().size();

  ASSERT_EQ(nbConstraint, 8);

  collection->filter(DYN::CONSTRAINTS_KEEP_FIRST);

  nbConstraint = 0;
  nbConstraint = collection->getConstraintsById().size();

  ASSERT_EQ(nbConstraint, 1);  // the constraints have been removed
  auto constraints =  collection->getConstraintsById();
  auto it = constraints.find("8_model_0_constraint 1");
  ASSERT_TRUE(it != constraints.end());
  ASSERT_EQ(it->second->getData().get().value, 134);
}

TEST(APICSTRTest, CollectionFilterConstraintDynaflowMode) {
  std::unique_ptr<ConstraintsCollection> collection;
  collection = ConstraintsCollectionFactory::newInstance("test");

  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 133.0));    // add first constraint
  collection->addConstraint("model", "constraint 1", 2, CONSTRAINT_END, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 128.0));      // add second constraint with same description and type CONSTRAINT_END
  collection->addConstraint("model", "constraint 2", 4, CONSTRAINT_END, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 133.0));      // add END constraint (should not happen but who knows...)
  collection->addConstraint("model", "constraint 3", 7, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 133.0));    // add first constraint 3
  collection->addConstraint("model", "constraint 1", 8, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 134.0));    // add BEGIN constraint 1
  collection->addConstraint("model", "constraint 1", 9, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 135.0));    // add BEGIN constraint 1
  collection->addConstraint("model", "constraint 1", 10, CONSTRAINT_BEGIN, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 136.0));    // add BEGIN constraint 1
  collection->addConstraint("model", "constraint 3", 8, CONSTRAINT_END, "Line",
      ConstraintData(ConstraintData::OverloadUp, 132.0, 128.0));      // add END constraint 3

  auto nbConstraint = collection->getConstraintsById().size();

  ASSERT_EQ(nbConstraint, 8);

  collection->filter(DYN::CONSTRAINTS_DYNAFLOW);

  nbConstraint = 0;
  nbConstraint = collection->getConstraintsById().size();

  ASSERT_EQ(nbConstraint, 3);  // closed constraints are kept

  auto constraints =  collection->getConstraintsById();
  auto it = constraints.find("2_model_0_constraint 1");
  ASSERT_TRUE(it != constraints.end());
  ASSERT_EQ(it->second->getData().get().value, 128);
  ASSERT_EQ(it->second->getData().get().valueMax.get(), 133);

  it = constraints.find("10_model_0_constraint 1");
  ASSERT_TRUE(it != constraints.end());
  ASSERT_EQ(it->second->getData().get().value, 136);
  ASSERT_EQ(it->second->getData().get().valueMax.get(), 136);

  it = constraints.find("8_model_0_constraint 3");
  ASSERT_TRUE(it != constraints.end());
  ASSERT_EQ(it->second->getData().get().value, 128);
  ASSERT_EQ(it->second->getData().get().valueMax.get(), 133);
}

TEST(APICSTRTest, CollectionClearConstraints) {
  std::shared_ptr<ConstraintsCollection> collection;
  collection = ConstraintsCollectionFactory::newInstance("test");

  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_BEGIN);  // add first constraint
  collection->addConstraint("model", "constraint 2", 0, CONSTRAINT_BEGIN);  // add second constraint with different description
  collection->addConstraint("model", "constraint 1", 0, CONSTRAINT_END);    // add end constraint (everything should be kept)

  ASSERT_EQ(collection->getConstraintsById().size(), 3);  // the three constraints have been added
  ASSERT_EQ(collection->getConstraintsByModel().size(), 1);  // the "model" constraints list
  collection->clear();
  ASSERT_EQ(collection->getConstraintsById().size(), 0);  // the three constraints have been removed
  ASSERT_EQ(collection->getConstraintsByModel().size(), 0);  // the "model constraints have been removed"
}

}  // namespace constraints
