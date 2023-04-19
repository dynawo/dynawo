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
 * @file API/PAR/test/TestParametersSetCollection.cpp
 * @brief Unit tests for API_PAR
 */

#include <boost/shared_ptr.hpp>

#include "gtest_dynawo.h"

#include "PARParametersSetCollectionFactory.h"
#include "PARParametersSetCollection.h"
#include "PARMacroParSet.h"
#include "PARMacroParameterSet.h"
#include "PARParameterFactory.h"
#include "PARParameter.h"
#include "PARReferenceFactory.h"
#include "PARReference.h"

using boost::shared_ptr;

namespace parameters {

//-----------------------------------------------------
// TEST add a parameters set to a collection and check associated methods
//-----------------------------------------------------

TEST(APIPARTest, CollectionAddParametersSet) {
  // Create a new parameters set collection
  shared_ptr<ParametersSetCollection> collection = ParametersSetCollectionFactory::newCollection();

  // Add a set of parameters to this collection
  shared_ptr<ParametersSet> parametersSet = boost::shared_ptr<ParametersSet>(new ParametersSet("parameters"));
  collection->addParametersSet(parametersSet);

  // Add a set of parameters with same id: it should raise an error
  shared_ptr<ParametersSet> anotherParametersSet = boost::shared_ptr<ParametersSet>(new ParametersSet("parameters"));
  ASSERT_THROW_DYNAWO(collection->addParametersSet(anotherParametersSet), DYN::Error::API, DYN::KeyError_t::ParametersSetAlreadyExists);

  // Check hasParametersSet
  ASSERT_EQ(collection->hasParametersSet("parameters"), true);
  ASSERT_EQ(collection->hasParametersSet("inexistant"), false);

  // Get the added parameters set
  shared_ptr<ParametersSet> parametersSet2 = collection->getParametersSet("parameters");
  ASSERT_EQ(parametersSet, parametersSet2);

  // Try to get a parameters set that hasn't been added: it should raise an error
  ASSERT_THROW_DYNAWO(collection->getParametersSet("Inexistant"), DYN::Error::API, DYN::KeyError_t::ParametersSetNotFound);
}

//-----------------------------------------------------
// TEST collection copy (factory)
//-----------------------------------------------------

TEST(APIPARTest, CollectionFactory) {
  // Create a new parameters set collection with a parameters set
  shared_ptr<ParametersSetCollection> collection1 = ParametersSetCollectionFactory::newCollection();

  // Add a set of parameters to this collection
  shared_ptr<ParametersSet> parametersSet = boost::shared_ptr<ParametersSet>(new ParametersSet("parameters"));
  collection1->addParametersSet(parametersSet);

  // Copy this collection in a new collection
  shared_ptr<ParametersSetCollection> collection2;
  ASSERT_NO_THROW(collection2 = ParametersSetCollectionFactory::copyCollection(collection1));

  // Check that the new collection has the same parameters set than the original
  ASSERT_EQ(collection2->hasParametersSet("parameters"), true);
  ASSERT_EQ(collection2->hasParametersSet("inexistant"), false);
}

//-----------------------------------------------------
// TEST add several parameters set and test iterator
//-----------------------------------------------------

TEST(APIPARTest, CollectionIterator) {
  // Create a new parameters set collection
  shared_ptr<ParametersSetCollection> collection = ParametersSetCollectionFactory::newCollection();

  // Add several sets of parameters to this collection
  shared_ptr<ParametersSet> parametersSet1 = boost::shared_ptr<ParametersSet>(new ParametersSet("parameters1"));
  shared_ptr<ParametersSet> parametersSet2 = boost::shared_ptr<ParametersSet>(new ParametersSet("parameters2"));
  shared_ptr<ParametersSet> parametersSet3 = boost::shared_ptr<ParametersSet>(new ParametersSet("parameters3"));
  collection->addParametersSet(parametersSet1);
  collection->addParametersSet(parametersSet2);
  collection->addParametersSet(parametersSet3);

  // Test const iterator
  int nbParametersSets = 0;
  for (ParametersSetCollection::parametersSet_const_iterator itParamSet = collection->cbeginParametersSet();
      itParamSet != collection->cendParametersSet();
      ++itParamSet) {
    ++nbParametersSets;
    ASSERT_TRUE(itParamSet == itParamSet);
  }
  ASSERT_EQ(nbParametersSets, 3);

  ParametersSetCollection::parametersSet_const_iterator itVariablec(collection->cbeginParametersSet());
  ASSERT_EQ((++itVariablec)->get()->getId(), "parameters2");
  ASSERT_EQ((--itVariablec)->get()->getId(), "parameters1");
  ASSERT_EQ((itVariablec++)->get()->getId(), "parameters1");
  ASSERT_EQ((itVariablec--)->get()->getId(), "parameters2");
}

TEST(APIPARTest, MacroParameterSetTest) {
  shared_ptr<ParametersSetCollection> collection = ParametersSetCollectionFactory::newCollection();
  shared_ptr<MacroParameterSet> macroParameterSet = shared_ptr<MacroParameterSet>(new MacroParameterSet("macroParameterSet"));
  shared_ptr<Reference> reference = ReferenceFactory::newReference("reference", Reference::OriginData::IIDM);
  shared_ptr<Parameter> parameter1 = ParameterFactory::newParameter("parameter1", true);
  shared_ptr<Parameter> parameter2 = ParameterFactory::newParameter("parameter2", true);
  macroParameterSet->addParameter(parameter2);
  macroParameterSet->addReference(reference);
  shared_ptr<ParametersSet> parametersSet1 = boost::shared_ptr<ParametersSet>(new ParametersSet("parameters1"));
  parametersSet1->addParameter(parameter1);
  ASSERT_NO_THROW(collection->addMacroParameterSet(macroParameterSet));
  ASSERT_THROW_DYNAWO(collection->addMacroParameterSet(macroParameterSet), DYN::Error::API, DYN::KeyError_t::MacroParameterSetAlreadyExists);
  shared_ptr<MacroParSet> macroParSet = shared_ptr<MacroParSet>(new MacroParSet("macroParameterSet"));
  ASSERT_NO_THROW(parametersSet1->addMacroParSet(macroParSet));
  collection->addParametersSet(parametersSet1);
  ASSERT_NO_THROW(shared_ptr<ParametersSet> parametersSetGetter = collection->getParametersSet("parameters1"));
  ASSERT_NO_THROW(collection->getParametersFromMacroParameter());
  ParametersSetCollection::macroparameterset_const_iterator itMacroParameterSet = collection->cbeginMacroParameterSet();
  ASSERT_NO_THROW(itMacroParameterSet++);
  ASSERT_NO_THROW(itMacroParameterSet--);
  ASSERT_NO_THROW(++itMacroParameterSet);
  ASSERT_NO_THROW(--itMacroParameterSet);
  ASSERT_TRUE(itMacroParameterSet == itMacroParameterSet);
  ASSERT_NO_THROW(itMacroParameterSet->get()->getId());
  ASSERT_NO_THROW((*itMacroParameterSet)->getId());
}

}  // namespace parameters
