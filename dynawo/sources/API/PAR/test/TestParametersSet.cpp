//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, a hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

/**
 * @file API/PAR/test/TestParametersSet.cpp
 * @brief Unit tests for API_PAR
 */

#include <vector>
#include <map>

#include "gtest_dynawo.h"

#include "PARParameter.h"
#include "PARParameterFactory.h"
#include "PARReference.h"
#include "PARReferenceFactory.h"
#include "PARParametersSet.h"
#include "PARParametersSetFactory.h"
#include "PARMacroParSet.h"

using std::string;
using std::vector;
using std::map;
using testing::ContainerEq;

namespace parameters {

//-----------------------------------------------------
// TEST create parameters in a parameters set
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetCreate) {
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");
  parametersSet->createParameter("BooleanParameter", true);
  parametersSet->createParameter("IntegerParameter", 2);
  parametersSet->createParameter("DoubleParameter", 5.6);
  parametersSet->createParameter("StringParameter", string("myName"));

  // Test id
  ASSERT_EQ(parametersSet->getId(), "parameters");

  // Test size
  auto nbParameters = parametersSet->getParameters().size();
  ASSERT_EQ(nbParameters, 4);
  ASSERT_NO_THROW(parametersSet->setFilePath("test.par"));
  ASSERT_EQ(parametersSet->getFilePath(), "test.par");
}

//-----------------------------------------------------
// TEST add/get/has parameter
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetAddParameter) {
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");

  // Create and add a parameter
  std::shared_ptr<Parameter> param = ParameterFactory::newParameter("param", 1);
  ASSERT_NO_THROW(parametersSet->addParameter(param));

  // Create and add a parameter with same name: it should throw an error
  std::unique_ptr<Parameter> param2 = ParameterFactory::newParameter("param", 5.7);
  ASSERT_THROW_DYNAWO(parametersSet->addParameter(std::move(param2)), DYN::Error::API, DYN::KeyError_t::ParameterAlreadyInSet);

  // Get the parameter and compare it to the initial one
  ASSERT_EQ(parametersSet->getParameter("param"), param);

  // Try to get a nonexistent parameter: it should raise an error
  ASSERT_THROW_DYNAWO(parametersSet->getParameter("inexistant"), DYN::Error::API, DYN::KeyError_t::ParameterNotFoundInSet);

  // Test hasParameter
  ASSERT_EQ(parametersSet->hasParameter("param"), true);
  ASSERT_EQ(parametersSet->hasParameter("inexistant"), false);
}

//-----------------------------------------------------
// TEST add/get/has reference
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetAddReference) {
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");

  // Create and add a reference
  std::shared_ptr<Reference> ref = ReferenceFactory::newReference("ref", Reference::OriginData::IIDM);
  ASSERT_NO_THROW(parametersSet->addReference(ref));

  // Create and add a reference with same name: it should throw an error
  std::unique_ptr<Reference> ref2 = ReferenceFactory::newReference("ref", Reference::OriginData::IIDM);
  ASSERT_THROW_DYNAWO(parametersSet->addReference(std::move(ref2)), DYN::Error::API, DYN::KeyError_t::ReferenceAlreadySet);

  // Get the reference and compare it to the initial one
  ASSERT_EQ(parametersSet->getReference("ref"), ref);

  // Try to get a nonexistent reference: it should raise an error
  ASSERT_THROW_DYNAWO(parametersSet->getReference("inexistant"), DYN::Error::API, DYN::KeyError_t::ReferenceNotFoundInSet);

  // Test hasReference
  ASSERT_EQ(parametersSet->hasReference("ref"), true);
  ASSERT_EQ(parametersSet->hasReference("inexistant"), false);

  // Test getReferences
  std::shared_ptr<ParametersSet> parametersSet2 = ParametersSetFactory::newParametersSet("parameters2");
  std::unique_ptr<Reference> ref3 = ReferenceFactory::newReference("ref3", Reference::OriginData::IIDM);
  parametersSet2->addReference(std::move(ref3));
  std::unique_ptr<Reference> ref4 = ReferenceFactory::newReference("ref4", Reference::OriginData::PAR);
  parametersSet2->addReference(std::move(ref4));
  std::unique_ptr<Reference> ref5 = ReferenceFactory::newReference("ref5", Reference::OriginData::PAR);
  parametersSet2->addReference(std::move(ref5));

  const std::unordered_map<std::string, std::shared_ptr<Reference> >& references = parametersSet2->getReferences();
  const int nbRefs = 3;
  std::array<std::string, nbRefs> refNamesList = {"ref3", "ref4", "ref5"};
  for (const std::string& refName : refNamesList) {
    ASSERT_TRUE(references.find(refName) != references.end());
  }
  ASSERT_EQ(references.size(), nbRefs);
}

//-----------------------------------------------------
// TEST get the map of all parameters and the vector of the unused parameters
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetGetParameters) {
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");

  // Create parameters
  std::shared_ptr<Parameter> param1 = ParameterFactory::newParameter("param1", 1);
  std::shared_ptr<Parameter> param2 = ParameterFactory::newParameter("param2", 1.2);
  std::shared_ptr<Parameter> param3 = ParameterFactory::newParameter("param3", true);
  std::shared_ptr<Parameter> param4 = ParameterFactory::newParameter("param4", string("myName"));

  // Add parameters to parameters set
  parametersSet->addParameter(param1);
  parametersSet->addParameter(param2);
  parametersSet->addParameter(param3);
  parametersSet->addParameter(param4);

  // Get the map of parameters associated with their names
  map<string, std::shared_ptr<Parameter> > paramMap;
  paramMap["param1"] = param1;
  paramMap["param2"] = param2;
  paramMap["param3"] = param3;
  paramMap["param4"] = param4;
  EXPECT_THAT(paramMap, ContainerEq(parametersSet->getParameters()));

  // Test size
  auto nbParameters = parametersSet->getParameters().size();
  ASSERT_EQ(nbParameters, 4);

  // Get the vector of names
  string namesTab[] = {"param1", "param2", "param3", "param4"};
  vector<string> parametersNames;
  parametersNames.insert(parametersNames.begin(), namesTab, namesTab+4);
  EXPECT_THAT(parametersNames, ContainerEq(parametersSet->getParametersNames()));

  // Test the returned vector of unused parameter
  param2->setUsed(true);
  param3->setUsed(true);
  string unusedTab[] = {"param1", "param4"};
  vector<string> paramsUnused;
  paramsUnused.insert(paramsUnused.begin(), unusedTab, unusedTab+2);
  EXPECT_THAT(paramsUnused, ContainerEq(parametersSet->getParamsUnused()));
}

//-----------------------------------------------------
// TEST get the map of all references and the vector of references names
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetGetReferences) {
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");

  // Create references
  std::unique_ptr<Reference> ref1 = ReferenceFactory::newReference("ref1", Reference::OriginData::IIDM);
  std::unique_ptr<Reference> ref2 = ReferenceFactory::newReference("ref2", Reference::OriginData::IIDM);
  std::shared_ptr<Reference> ref3 = ReferenceFactory::newReference("ref3", Reference::OriginData::IIDM);

  // Add references to parameters set
  parametersSet->addReference(std::move(ref1));
  parametersSet->addReference(std::move(ref2));
  parametersSet->addReference(ref3);

  // Test size
  auto nbReferences = parametersSet->getReferences().size();
  ASSERT_EQ(nbReferences, 3);

  ASSERT_EQ(ref3->getName(), "ref3");

  // Get the vector of names
  string namesTab[] = {"ref1", "ref2", "ref3"};
  vector<string> referencesNames;
  referencesNames.insert(referencesNames.begin(), namesTab, namesTab+3);
  EXPECT_THAT(referencesNames, ContainerEq(parametersSet->getReferencesNames()));
}

//-----------------------------------------------------
// TEST extend a parameters set with another parameters set's content
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetExtend) {
  // Create a first set of parameters
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");
  parametersSet->createParameter("BooleanParameter", true);
  parametersSet->createParameter("IntegerParameter", 2);
  parametersSet->createParameter("DoubleParameter", 5.6);
  parametersSet->createParameter("StringParameter", string("myName"));

  // Create a second set of parameters
  std::shared_ptr<ParametersSet> parametersSet2 = ParametersSetFactory::newParametersSet("parameters2");
  parametersSet->createParameter("BooleanParameter2", true);
  parametersSet->createParameter("IntegerParameter2", 10);
  parametersSet->createParameter("DoubleParameter2", 7.89);
  parametersSet->createParameter("StringParameter2", string("myName2"));

  // Extend the first set with the second set
  parametersSet->extend(parametersSet2);

  // Check size of parameters set
  ASSERT_EQ(parametersSet->getParametersNames().size(), 8);

  // Get the vector of names
  string namesTab[] = {"BooleanParameter", "BooleanParameter2",
                       "DoubleParameter", "DoubleParameter2",
                       "IntegerParameter", "IntegerParameter2",
                       "StringParameter", "StringParameter2"};
  vector<string> parametersNames;
  parametersNames.insert(parametersNames.begin(), namesTab, namesTab+8);
  EXPECT_THAT(parametersNames, ContainerEq(parametersSet->getParametersNames()));
}

//-----------------------------------------------------
// TEST create aliases
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetAliases) {
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("aliases");

  // Create a parameter and create an alias of it
  ASSERT_NO_THROW(parametersSet->createParameter("paramInt", 3));
  ASSERT_NO_THROW(parametersSet->createAlias("paramIntAlias", "paramInt"));

  // Try to create an alias from a parameter that doesn't exists: it should raide an error
  ASSERT_THROW_DYNAWO(parametersSet->createAlias("paramIntAlias2", "inexistant"), DYN::Error::API, DYN::KeyError_t::ParameterAliasFailed);

  // Try to create an alias with already used name
  ASSERT_NO_THROW(parametersSet->createParameter("paramDouble", 7.5));
  ASSERT_THROW_DYNAWO(parametersSet->createAlias("paramIntAlias", "paramDouble"), DYN::Error::API, DYN::KeyError_t::ParameterAliasFailed);

  // Get the vector of names
  string namesTab[] = {"paramDouble", "paramInt", "paramIntAlias"};
  vector<string> parametersNames;
  parametersNames.insert(parametersNames.begin(), namesTab, namesTab+3);
  EXPECT_THAT(parametersNames, ContainerEq(parametersSet->getParametersNames()));

  // Check values and names
  ASSERT_EQ(parametersSet->getParameter("paramInt")->getInt(), 3);
  ASSERT_EQ(parametersSet->getParameter("paramDouble")->getDouble(), 7.5);
  ASSERT_EQ(parametersSet->getParameter("paramIntAlias")->getInt(), 3);
  ASSERT_EQ(parametersSet->getParameter("paramInt")->getName(), "paramInt");
  ASSERT_EQ(parametersSet->getParameter("paramDouble")->getName(), "paramDouble");
  ASSERT_EQ(parametersSet->getParameter("paramIntAlias")->getName(), "paramInt");  // the name of the alias parameter is the name of
                                                                                   // the parameter used to create the alias
}

//-----------------------------------------------------
// TEST create parameters in a table (one line)
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetCreateTableOneLine) {
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");

  // Create a parameters table (one line) with all possible types (bool, int, double, string)
  ASSERT_NO_THROW(parametersSet->createParameter("paramTable", string("red"), "1", "1"));  // give names paramTable_1_ and paramTable_1_1_
  ASSERT_NO_THROW(parametersSet->createParameter("paramTable", 10.5, "1", "2"));           // give names paramTable_2_ and paramTable_1_2_
  ASSERT_NO_THROW(parametersSet->createParameter("paramTable", true, "1", "3"));           // give names paramTable_3_ and paramTable_1_3_
  ASSERT_NO_THROW(parametersSet->createParameter("paramTable", 6, "1", "4"));              // give names paramTable_4_ and paramTable_1_4_

  // Get the vector of names
  string namesTab[] = {"paramTable_1_", "paramTable_1_1_", "paramTable_1_2_", "paramTable_1_3_", "paramTable_1_4_",
                       "paramTable_2_", "paramTable_3_", "paramTable_4_"};
  vector<string> parametersNames;
  parametersNames.insert(parametersNames.begin(), namesTab, namesTab+8);
  EXPECT_THAT(parametersNames, ContainerEq(parametersSet->getParametersNames()));
}

//-----------------------------------------------------
// TEST create parameters in a table (one matrix)
//-----------------------------------------------------

TEST(APIPARTest, ParametersSetCreateTableMatrix) {
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");

  // Create a parameters table (matrix 2x2) with all possible types (bool, int, double, string)
  ASSERT_NO_THROW(parametersSet->createParameter("paramTable", string("red"), "1", "1"));   // give names paramTable_1_1_ and paramTable_1_
  ASSERT_NO_THROW(parametersSet->createParameter("paramTable", 10.5, "1", "2"));            // give names paramTable_1_2_ and paramTable_2_
  ASSERT_NO_THROW(parametersSet->createParameter("paramTable", true, "2", "1"));            // give names paramTable_2_1_
  ASSERT_NO_THROW(parametersSet->createParameter("paramTable", 6, "2", "2"));               // give names paramTable_2_2_

  // Get the vector of names
  string namesTab[] = {"paramTable_1_", "paramTable_1_1_", "paramTable_1_2_",
                       "paramTable_2_", "paramTable_2_1_", "paramTable_2_2_"};
  vector<string> parametersNames;
  parametersNames.insert(parametersNames.begin(), namesTab, namesTab+6);
  EXPECT_THAT(parametersNames, ContainerEq(parametersSet->getParametersNames()));

  // Try to add new parameters at the same place (row and column): it should raise an error
  ASSERT_THROW_DYNAWO(parametersSet->createParameter("paramTable", string("blue"), "1", "1"), DYN::Error::API, DYN::KeyError_t::ParameterAlreadyInSet);
  ASSERT_THROW_DYNAWO(parametersSet->createParameter("paramTable", 5.98, "1", "2"), DYN::Error::API, DYN::KeyError_t::ParameterAlreadyInSet);
  ASSERT_THROW_DYNAWO(parametersSet->createParameter("paramTable", false, "2", "1"), DYN::Error::API, DYN::KeyError_t::ParameterAlreadyInSet);
  ASSERT_THROW_DYNAWO(parametersSet->createParameter("paramTable", 8, "2", "2"), DYN::Error::API, DYN::KeyError_t::ParameterAlreadyInSet);
}

//-----------------------------------------------------
// TEST macroparset iterator
//-----------------------------------------------------

TEST(APIPARTest, MacroParSetIterator) {
  std::shared_ptr<MacroParSet> macroParSet = std::make_shared<MacroParSet>("macroParSet");
  std::shared_ptr<ParametersSet> parametersSet = ParametersSetFactory::newParametersSet("parameters");
  ASSERT_NO_THROW(parametersSet->addMacroParSet(macroParSet));
  ASSERT_THROW_DYNAWO(parametersSet->addMacroParSet(macroParSet), DYN::Error::API, DYN::KeyError_t::MacroParSetAlreadyExists);
}

}  // namespace parameters
