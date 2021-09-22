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
#include "EXTVARIterators.h"
#include "EXTVARVariable.h"

INIT_XML_DYNAWO;

namespace externalVariables {

//-----------------------------------------------------
// TEST build external continuous variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalContinuousVariable) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "continuous_variable_1";
  boost::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::CONTINUOUS);

  ASSERT_NO_THROW(collection->addVariable(variable));
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::CONTINUOUS);

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

  ASSERT_EQ(variable->hasOptional(), false);
  ASSERT_THROW_DYNAWO(variable->setOptional(true), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeOnlyForArray);
  ASSERT_THROW_DYNAWO(variable->getOptional(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);


  for (variable_iterator itVariable = collection->endVariable(); itVariable == collection->beginVariable(); --itVariable) {
    ASSERT_EQ((*itVariable)->getId(), variable->getId());
    ASSERT_EQ((*itVariable)->getType(), variable->getType());
    ASSERT_EQ((*itVariable)->hasDefaultValue(), variable->hasDefaultValue());
    ASSERT_EQ((*itVariable)->getDefaultValue(), variable->getDefaultValue());
  }

  for (variable_iterator itVariable = collection->endVariable(); itVariable == collection->beginVariable(); itVariable--) {
    ASSERT_EQ((*itVariable)->getId(), variable->getId());
    ASSERT_EQ((*itVariable)->getType(), variable->getType());
    ASSERT_EQ((*itVariable)->hasDefaultValue(), variable->hasDefaultValue());
    ASSERT_EQ((*itVariable)->getDefaultValue(), variable->getDefaultValue());
  }

  for (variable_iterator itVariable = collection->endVariable(); itVariable == collection->beginVariable(); ++itVariable) {
    ASSERT_EQ((*itVariable)->getId(), variable->getId());
    ASSERT_EQ((*itVariable)->getType(), variable->getType());
    ASSERT_EQ((*itVariable)->hasDefaultValue(), variable->hasDefaultValue());
    ASSERT_EQ((*itVariable)->getDefaultValue(), variable->getDefaultValue());
  }

  for (variable_iterator itVariable = collection->beginVariable(); itVariable != collection->endVariable(); ++itVariable) {
    boost::shared_ptr<Variable> currentVar = *itVariable;
    ASSERT_EQ((*itVariable)->getId(), variable->getId());
    ASSERT_EQ((*itVariable)->getType(), variable->getType());
    ASSERT_EQ((*itVariable)->hasDefaultValue(), variable->hasDefaultValue());
    ASSERT_EQ((*itVariable)->getDefaultValue(), variable->getDefaultValue());
  }
}

//-----------------------------------------------------
// TEST build external discrete variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalDiscreteVariable) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "discrete_variable_1";
  boost::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::DISCRETE);

  collection->addVariable(variable);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::DISCRETE);

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
  ASSERT_THROW_DYNAWO(variable->setOptional(true), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeOnlyForArray);
  ASSERT_THROW_DYNAWO(variable->getOptional(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
}

//-----------------------------------------------------
// TEST build external discrete variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalBooleanVariable) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "boolean_variable_1";
  boost::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::BOOLEAN);

  collection->addVariable(variable);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::BOOLEAN);

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
  ASSERT_THROW_DYNAWO(variable->setOptional(true), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeOnlyForArray);
  ASSERT_THROW_DYNAWO(variable->getOptional(), DYN::Error::API, DYN::KeyError_t::ExternalVariableAttributeNotDefined);
}

//-----------------------------------------------------
// TEST build external continuous array variable
//-----------------------------------------------------

TEST(APIEXTVARTest, ExternalContinuousArrayVariable) {
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "continuous_array";
  boost::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::CONTINUOUS_ARRAY);

  collection->addVariable(variable);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::CONTINUOUS_ARRAY);
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
  boost::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::DISCRETE_ARRAY);

  collection->addVariable(variable);
  ASSERT_THROW_DYNAWO(collection->addVariable(variable), DYN::Error::API,
                      DYN::KeyError_t::ExternalVariableIDNotUnique);  /// variable with same name is not authorized

  ASSERT_EQ(variable->getId(), varId);
  ASSERT_EQ(variable->getType(), Variable::DISCRETE_ARRAY);
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
  boost::shared_ptr<VariablesCollection> collection = VariablesCollectionFactory::newCollection();

  // create object
  const std::string varId = "discrete_variable_1";
  boost::shared_ptr<Variable> variable;
  variable = VariableFactory::newVariable(varId, Variable::DISCRETE);

  ASSERT_NO_THROW(collection->addVariable(variable));

  const std::string varId2 = "continuous_variable_1";
  boost::shared_ptr<Variable> variable2;
  variable2 = VariableFactory::newVariable(varId, Variable::CONTINUOUS);
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
  const std::string varId = "discrete_variable_1";
  boost::shared_ptr<Variable> variable;
  const std::string defaultVal = "1";
  variable = VariableFactory::newVariable(varId, Variable::DISCRETE);
  variable->setDefaultValue(defaultVal);
  ASSERT_NO_THROW(variable->getDefaultValue());
  collection->addVariable(variable);

  // continuous variable
  const std::string varId2 = "continuous_variable_1";
  boost::shared_ptr<Variable> variable2;
  variable2 = VariableFactory::newVariable(varId2, Variable::CONTINUOUS);
  ASSERT_NO_THROW(collection->addVariable(variable2));

  // continous array
  const std::string varId3 = "continuous_array_variable";
  boost::shared_ptr<Variable> variable3;
  variable3 = VariableFactory::newVariable(varId3, Variable::CONTINUOUS_ARRAY);
  variable3->setDefaultValue("0.");
  variable3->setOptional(true);
  variable3->setSize(3);
  ASSERT_NO_THROW(collection->addVariable(variable3));

  // discrete array
  const std::string varId4 = "discrete_array_variable";
  boost::shared_ptr<Variable> variable4;
  variable4 = VariableFactory::newVariable(varId4, Variable::DISCRETE_ARRAY);
  variable4->setDefaultValue("0.");
  variable4->setSize(10);
  ASSERT_NO_THROW(collection->addVariable(variable4));

  // boolean variable
  const std::string varId5 = "boolean_variable_1";
  boost::shared_ptr<Variable> variable5;
  const std::string defaultValBool = "true";
  variable5 = VariableFactory::newVariable(varId5, Variable::BOOLEAN);
  variable5->setDefaultValue(defaultValBool);
  ASSERT_NO_THROW(variable5->getDefaultValue());
  collection->addVariable(variable5);

  // export
  const std::string fileName = "ExternalVariables.extvar";
  XmlExporter exporter;
  ASSERT_NO_THROW(exporter.exportToFile(*collection, fileName));

  // import
  XmlImporter importer;
  boost::shared_ptr<VariablesCollection> collection1;
  ASSERT_NO_THROW(collection1 = importer.importFromFile(fileName));

  for (variable_iterator itVariable = collection1->beginVariable(); itVariable != collection1->endVariable(); ++itVariable) {
    const boost::shared_ptr<Variable> variable = *itVariable;
    if (variable->getType() == Variable::CONTINUOUS) {
      ASSERT_EQ(variable->getId(), varId2);
      ASSERT_EQ(variable->hasDefaultValue(), false);
    } else if (variable->getType() == Variable::DISCRETE) {
      ASSERT_EQ(variable->getId(), varId);
      ASSERT_EQ(variable->hasDefaultValue(), true);
      ASSERT_EQ(variable->getDefaultValue(), defaultVal);
    } else if (variable->getType() == Variable::BOOLEAN) {
      ASSERT_EQ(variable->getId(), varId5);
      ASSERT_EQ(variable->hasDefaultValue(), true);
      ASSERT_EQ(variable->getDefaultValue(), defaultValBool);
    } else if (variable->getType() == Variable::CONTINUOUS_ARRAY) {
      ASSERT_EQ(variable->getId(), varId3);
      ASSERT_EQ(variable->hasDefaultValue(), true);
      ASSERT_EQ(variable->getDefaultValue(), "0.");
      ASSERT_EQ(variable->hasOptional(), true);
      ASSERT_EQ(variable->getOptional(), true);
      ASSERT_EQ(variable->hasSize(), true);
      ASSERT_EQ(variable->getSize(), 3);
    } else if (variable->getType() == Variable::DISCRETE_ARRAY) {
      ASSERT_EQ(variable->getId(), varId4);
      ASSERT_EQ(variable->hasDefaultValue(), true);
      ASSERT_EQ(variable->getDefaultValue(), "0.");
      ASSERT_EQ(variable->hasOptional(), false);
      ASSERT_EQ(variable->hasSize(), true);
      ASSERT_EQ(variable->getSize(), 10);
    }
  }

  for (variable_iterator itVariable = collection->beginVariable(); itVariable != collection->endVariable(); ++itVariable) {
    const boost::shared_ptr<Variable> variableLocal = *itVariable;
    ASSERT_EQ(variableLocal->getId(), variable5->getId());
    break;
  }

  for (variable_iterator itVariable = collection->endVariable(); itVariable == collection->beginVariable(); --itVariable) {
    const boost::shared_ptr<Variable> variableLocal = *itVariable;
    ASSERT_EQ(variableLocal->getId(), variable->getId());
    break;
  }

  for (variable_iterator itVariable = collection->endVariable(); itVariable == collection->beginVariable(); itVariable--) {
    const boost::shared_ptr<Variable> variableLocal = *itVariable;
    ASSERT_EQ(variableLocal->getId(), variable->getId());
    break;
  }

  variable_iterator itVariable(collection->beginVariable());
  ASSERT_EQ((++itVariable)->get()->getId(), variable3->getId());
  ASSERT_EQ((--itVariable)->get()->getId(), variable5->getId());
  ASSERT_EQ((itVariable++)->get()->getId(), variable5->getId());
  ASSERT_EQ((itVariable--)->get()->getId(), variable3->getId());
}

}  // namespace externalVariables
