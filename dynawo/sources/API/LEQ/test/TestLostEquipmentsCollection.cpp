//
// Copyright (c) 2015-2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source suite
// of simulation tools for power systems.
//

/**
 * @file API/LEQ/test/TestLostEquipmentsCollection.cpp
 * @brief Unit tests for API_LEQ
 *
 */

#include "gtest_dynawo.h"

#include "LEQLostEquipmentsCollectionFactory.h"
#include "LEQLostEquipmentsCollection.h"
#include "LEQXmlExporter.h"

namespace lostEquipments {

//-----------------------------------------------------
// TEST for LostEquipmentsCollection
//-----------------------------------------------------

TEST(APILEQTest, LostEquipmentsCollection) {
  boost::shared_ptr<LostEquipmentsCollection> lostEquipments = LostEquipmentsCollectionFactory::newInstance();

  lostEquipments->addLostEquipment("ID1", "type1");
  lostEquipments->addLostEquipment("ID2", "type2");

  int nbLostEquipments = 0;
  for (LostEquipmentsCollection::LostEquipmentsCollectionConstIterator it1 = lostEquipments->cbegin();
       it1 != lostEquipments->cend();
       ++it1) {
    if (nbLostEquipments == 0) {
      ASSERT_EQ((*it1)->getId(), "ID1");
    } else if (nbLostEquipments == 1) {
      ASSERT_EQ((*it1)->getId(), "ID2");
    }
    ++nbLostEquipments;
  }
  ASSERT_EQ(nbLostEquipments, 2);

  LostEquipmentsCollection::LostEquipmentsCollectionConstIterator it2(lostEquipments->cbegin());
  ASSERT_EQ((++it2)->get()->getId(), "ID2");
  ASSERT_EQ((--it2)->get()->getId(), "ID1");
  ASSERT_EQ((it2++)->get()->getId(), "ID1");
  ASSERT_EQ((it2--)->get()->getId(), "ID2");

  // export
  XmlExporter XmlExporter;
  ASSERT_NO_THROW(XmlExporter.exportToFile(lostEquipments, "lostEquipments.xml"));
}

}  // namespace lostEquipments
