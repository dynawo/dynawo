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
 * @file API/EXTVAR/test/Test.cpp
 * @brief Unit tests for API_EXTVAR
 *
 */

#include "gtest_dynawo.h"

#include "EXTVARXmlImporter.h"
#include "EXTVARXmlExporter.h"
#include "EXTVARVariablesCollectionFactory.h"
#include "EXTVARVariableFactory.h"
#include "EXTVARVariable.h"
#include "EXTVARVariablesCollection.h"

#include <memory>

INIT_XML_DYNAWO;

namespace externalVariables {

//-----------------------------------------------------
// TEST build external continuous variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalContinuousVariable) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "continuous_variable_1";
  std::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::Type::CONTINUOUS);

  ASSERT_NO_THROW(collection->addVariable(variable));
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::Type::CONTINUOUS);

  ASSERT_THROW_DYNAWO(variable->getDefaultValue(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  ASSERT_EQ(variable->hasDefaultValue(), false);

  const std::string defaultValue = "5.31";
  variable->setDefaultValue(defaultValue);
  ASSERT_EQ(variable->hasDefaultValue(), true);
  ASSERT_NO_THROW(variable->getDefaultValue());
  ASSERT_EQ(variable->getDefaultValue(), defaultValue);

  ASSERT_EQ(variable->hasSize(), false);
  ASSERT_THROW_DYNAWO(variable->setSize(3), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeOnlyForArray);
  ASSERT_THROW_DYNAWO(variable->getSize(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);

  ASSERT_FALSE(variable->hasOptional());
  ASSERT_NO_THROW(variable->setOptional(true));
  ASSERT_TRUE(variable->getOptional());


  for (const auto& variablePair : collection->getVariables()) {
    const auto& currentVar = variablePair.second;
    ASSERT_EQ(currentVar->getId(), variable->getId());
    ASSERT_EQ(currentVar->getType(), variable->getType());
    ASSERT_EQ(currentVar->hasDefaultValue(), variable->hasDefaultValue());
    ASSERT_EQ(currentVar->getDefaultValue(), variable->getDefaultValue());
  }
}

//-----------------------------------------------------
// TEST build external discrete variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalDiscreteVariable) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "discrete_variable_1";
  std::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::Type::DISCRETE);

  collection->addVariable(variable);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::Type::DISCRETE);

  ASSERT_THROW_DYNAWO(variable->getDefaultValue(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  ASSERT_EQ(variable->hasDefaultValue(), false);

  const std::string defaultValue = "1";
  variable->setDefaultValue(defaultValue);
  ASSERT_EQ(variable->hasDefaultValue(), true);
  ASSERT_NO_THROW(variable->getDefaultValue());
  ASSERT_EQ(variable->getDefaultValue(), defaultValue);

  ASSERT_EQ(variable->hasSize(), false);
  ASSERT_THROW_DYNAWO(variable->setSize(3), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeOnlyForArray);
  ASSERT_THROW_DYNAWO(variable->getSize(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);

  ASSERT_EQ(variable->hasOptional(), false);
  ASSERT_THROW_DYNAWO(variable->setOptional(true), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeOnlyForArrayAndContinuous);
  ASSERT_THROW_DYNAWO(variable->getOptional(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
}

//-----------------------------------------------------
// TEST build external discrete variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalBooleanVariable) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "boolean_variable_1";
  std::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::Type::BOOLEAN);

  collection->addVariable(variable);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::Type::BOOLEAN);

  ASSERT_THROW_DYNAWO(variable->getDefaultValue(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  ASSERT_EQ(variable->hasDefaultValue(), false);

  const std::string defaultValue = "true";
  variable->setDefaultValue(defaultValue);
  ASSERT_EQ(variable->hasDefaultValue(), true);
  ASSERT_NO_THROW(variable->getDefaultValue());
  ASSERT_EQ(variable->getDefaultValue(), defaultValue);

  ASSERT_EQ(variable->hasSize(), false);
  ASSERT_THROW_DYNAWO(variable->setSize(3), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeOnlyForArray);
  ASSERT_THROW_DYNAWO(variable->getSize(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);

  ASSERT_EQ(variable->hasOptional(), false);
  ASSERT_THROW_DYNAWO(variable->setOptional(true), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeOnlyForArrayAndContinuous);
  ASSERT_THROW_DYNAWO(variable->getOptional(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
}

//-----------------------------------------------------
// TEST build external continuous array variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalContinuousArrayVariable) {
  std::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "continuous_array";
  std::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::Type::CONTINUOUS_ARRAY);

  collection->addVariable(variable);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::Type::CONTINUOUS_ARRAY);
  ASSERT_THROW_DYNAWO(variable->getDefaultValue(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  ASSERT_EQ(variable->hasDefaultValue(), false);

  const std::string defaultValue = "5.31";
  variable->setDefaultValue(defaultValue);
  ASSERT_EQ(variable->hasDefaultValue(), true);
  ASSERT_NO_THROW(variable->getDefaultValue());
  ASSERT_EQ(variable->getDefaultValue(), defaultValue);

  ASSERT_EQ(variable->hasOptional(), false);
  ASSERT_THROW_DYNAWO(variable->getOptional(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  variable->setOptional(true);
  ASSERT_EQ(variable->getOptional(), true);

  ASSERT_EQ(variable->hasSize(), false);
  ASSERT_THROW_DYNAWO(variable->getSize(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  variable->setSize(3);
  ASSERT_EQ(variable->getSize(), 3);
}

//-----------------------------------------------------
// TEST build external discrete array variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalDiscreteArrayVariable) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "discrete_array";
  std::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::Type::DISCRETE_ARRAY);

  collection->addVariable(variable);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::Type::DISCRETE_ARRAY);
  ASSERT_THROW_DYNAWO(variable->getDefaultValue(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  ASSERT_EQ(variable->hasDefaultValue(), false);

  const std::string defaultValue = "5.31";
  variable->setDefaultValue(defaultValue);
  ASSERT_EQ(variable->hasDefaultValue(), true);
  ASSERT_NO_THROW(variable->getDefaultValue());
  ASSERT_EQ(variable->getDefaultValue(), defaultValue);

  ASSERT_EQ(variable->hasOptional(), false);
  ASSERT_THROW_DYNAWO(variable->getOptional(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  variable->setOptional(true);
  ASSERT_EQ(variable->getOptional(), true);

  ASSERT_EQ(variable->hasSize(), false);
  ASSERT_THROW_DYNAWO(variable->getSize(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
  variable->setSize(3);
  ASSERT_EQ(variable->getSize(), 3);
}

//-----------------------------------------------------
// TEST build continuous and external discrete variables with the same name
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalDuplicateVariable) {
  const std::unique_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "discrete_variable_1";
  std::unique_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::Type::DISCRETE);

  ASSERT_NO_THROW(collection->addVariable(std::move(variable)));

  const std::string varId2 = "continuous_variable_1";
  std::shared_ptr<Variable> variable2;
  variable2 = VariableFactory::newVariable(varId, Variable::Type::CONTINUOUS);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable2), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized
  variable2->setId(varId2);

  ASSERT_EQ(variable2->getId(), varId2);
  ASSERT_NO_THROW(collection->addVariable(variable2));

  ASSERT_NO_THROW(VariablesCollectionFactory::copyCollection(collection));
}


//-----------------------------------------------------
// TEST build continuous and external discrete variables with the same name, then export and import the generated file
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalVariableExportImport) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  // discrete variable
  const std::string varId1 = "discrete_variable_1";
  std::shared_ptr<Variable> variable1;
  const std::string defaultVal = "1";
  variable1 = VariableFactory::newVariable(varId1, Variable::Type::DISCRETE);
  variable1->setDefaultValue(defaultVal);
  ASSERT_NO_THROW(variable1->getDefaultValue());
  collection->addVariable(variable1);

  // continuous variable
  const std::string varId2 = "continuous_variable_1";
  std::unique_ptr<Variable> variable2;
  variable2 = VariableFactory::newVariable(varId2, Variable::Type::CONTINUOUS);
  ASSERT_NO_THROW(collection->addVariable(std::move(variable2)));

  // continous array
  const std::string varId3 = "continuous_array_variable";
  std::shared_ptr<Variable> variable3;
  variable3 = VariableFactory::newVariable(varId3, Variable::Type::CONTINUOUS_ARRAY);
  variable3->setDefaultValue("0.");
  variable3->setOptional(true);
  variable3->setSize(3);
  ASSERT_NO_THROW(collection->addVariable(variable3));

  // discrete array
  const std::string varId4 = "discrete_array_variable";
  std::shared_ptr<Variable> variable4;
  variable4 = VariableFactory::newVariable(varId4, Variable::Type::DISCRETE_ARRAY);
  variable4->setDefaultValue("0.");
  variable4->setSize(10);
  ASSERT_NO_THROW(collection->addVariable(variable4));

  // boolean variable
  const std::string varId5 = "boolean_variable_1";
  std::shared_ptr<Variable> variable5;
  const std::string defaultValBool = "true";
  variable5 = VariableFactory::newVariable(varId5, Variable::Type::BOOLEAN);
  variable5->setDefaultValue(defaultValBool);
  ASSERT_NO_THROW(variable5->getDefaultValue());
  collection->addVariable(variable5);

  // export
  const std::string fileName = "ExternalVariables.extvar";
  XmlExporter exporter;
  ASSERT_NO_THROW(exporter.exportToFile(*collection, fileName));

  // import
  XmlImporter importer;
  std::shared_ptr<VariablesCollection> collection1;
  ASSERT_NO_THROW(collection1 = importer.importFromFile(fileName));

  for (const auto& variablePair : collection->getVariables()) {
    const std::shared_ptr<Variable>& variable = variablePair.second;
    if (variable->getType() == Variable::Type::CONTINUOUS) {
      ASSERT_EQ(variable->getId(), varId2);
      ASSERT_EQ(variable->hasDefaultValue(), false);
    } else if (variable->getType() == Variable::Type::DISCRETE) {
      ASSERT_EQ(variable->getId(), varId1);
      ASSERT_EQ(variable->hasDefaultValue(), true);
      ASSERT_EQ(variable->getDefaultValue(), defaultVal);
    } else if (variable->getType() == Variable::Type::BOOLEAN) {
      ASSERT_EQ(variable->getId(), varId5);
      ASSERT_EQ(variable->hasDefaultValue(), true);
      ASSERT_EQ(variable->getDefaultValue(), defaultValBool);
    } else if (variable->getType() == Variable::Type::CONTINUOUS_ARRAY) {
      ASSERT_EQ(variable->getId(), varId3);
      ASSERT_EQ(variable->hasDefaultValue(), true);
      ASSERT_EQ(variable->getDefaultValue(), "0.");
      ASSERT_EQ(variable->hasOptional(), true);
      ASSERT_EQ(variable->getOptional(), true);
      ASSERT_EQ(variable->hasSize(), true);
      ASSERT_EQ(variable->getSize(), 3);
    } else if (variable->getType() == Variable::Type::DISCRETE_ARRAY) {
      ASSERT_EQ(variable->getId(), varId4);
      ASSERT_EQ(variable->hasDefaultValue(), true);
      ASSERT_EQ(variable->getDefaultValue(), "0.");
      ASSERT_EQ(variable->hasOptional(), false);
      ASSERT_EQ(variable->hasSize(), true);
      ASSERT_EQ(variable->getSize(), 10);
    }
  }
}

}  // namespace externalVariables
