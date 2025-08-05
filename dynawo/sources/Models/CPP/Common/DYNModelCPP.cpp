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
 * @file  DYNModelCPPImpl.cpp
 *
 * @brief
 *
 */
#include <sstream>

#include <boost/archive/binary_iarchive.hpp>
#include <boost/archive/binary_oarchive.hpp>
#include <boost/serialization/vector.hpp>

#include "DYNModelCPP.h"
#include "DYNTrace.h"
#include "DYNMacrosMessage.h"
#include "DYNVariableNative.h"

using std::string;
using std::stringstream;
using std::map;
using std::vector;

namespace DYN {

ModelCPP::ModelCPP() :
isStartingFromDump_(false) {
}

ModelCPP::ModelCPP(const std::string& modelType) :
isStartingFromDump_(false),
modelType_(modelType) {
}

void
ModelCPP::initLinearize(const double /*t0*/) {
  // no initialization needed
}

void
ModelCPP::dumpParameters(map< string, string >& /*mapParameters*/) {
  // no parameters to dump for C++ models, they all come from the dyd file
}

void
ModelCPP::loadParameters(const string& /*parameters*/) {
  // no parameters to read from dump for C++ models, they all come from the dyd file
}

void
ModelCPP::dumpVariables(map< string, string >& mapVariables) {
  stringstream values;
  boost::archive::binary_oarchive os(values);
  const string cSum = getCheckSum();

  const vector<double> y(yLocal_, yLocal_ + sizeY());
  const vector<double> yp(ypLocal_, ypLocal_ + sizeY());
  const vector<double> z(zLocal_, zLocal_ + sizeZ());
  const vector<double> g(gLocal_, gLocal_ + sizeG());

  os << cSum;
  os << y;
  os << yp;
  os << z;
  os << g;

  dumpInternalVariables(os);

  mapVariables[ variablesFileName() ] = values.str();
}

void
ModelCPP::dumpInternalVariables(boost::archive::binary_oarchive&) const {
  // no internal variables
}

void
ModelCPP::loadVariables(const string& variables) {
  stringstream values(variables);
  boost::archive::binary_iarchive is(values);

  const string cSum = getCheckSum();
  string cSumRead;
  vector<double> yValues;
  vector<double> ypValues;
  vector<double> zValues;
  vector<double> gValues;
  is >> cSumRead;
  is >> yValues;
  is >> ypValues;
  is >> zValues;
  is >> gValues;

  if (cSumRead != cSum) {
    Trace::warn() << DYNLog(WrongCheckSum, variablesFileName().c_str()) << Trace::endline;
    return;
  }

  if (yValues.size() != sizeY() || ypValues.size() != sizeY()) {
    Trace::warn() << DYNLog(WrongParameterNum, variablesFileName().c_str()) << Trace::endline;
    return;
  }

  if (zValues.size() != sizeZ()) {
    Trace::warn() << DYNLog(WrongParameterNum, variablesFileName().c_str()) << Trace::endline;
    return;
  }

  if (gValues.size() != sizeG()) {
    Trace::warn() << DYNLog(WrongParameterNum, variablesFileName().c_str()) << Trace::endline;
    return;
  }

  try {
    loadInternalVariables(is);
  } catch (std::exception&) {
    // If loadInternalVariables fails, the internal variables of some the models may still be loaded, and will be reset
    // with getY0 during model initialization.
    Trace::warn() << DYNLog(WrongParameterNum, variablesFileName().c_str()) << Trace::endline;
    return;
  }

  // loading values
  std::copy(yValues.begin(), yValues.end(), yLocal_);
  std::copy(ypValues.begin(), ypValues.end(), ypLocal_);
  std::copy(zValues.begin(), zValues.end(), zLocal_);
  std::copy(gValues.begin(), gValues.end(), gLocal_);

  // notify we used dumped values
  isStartingFromDump_ = true;
}

void
ModelCPP::loadInternalVariables(boost::archive::binary_iarchive& /*streamVariables*/) {
  // no internal variables
}

void
ModelCPP::checkParametersCoherence() const {
  // not needed
}

void
ModelCPP::defineVariablesInit(std::vector<boost::shared_ptr<Variable> >& /*variables*/) {
  // no init variable
}

void
ModelCPP::defineParametersInit(std::vector<ParameterModeler>& /*parameters*/) {
  // not init parameter
}

void
ModelCPP::defineNamesImpl(std::vector<boost::shared_ptr<Variable> >& variables, std::vector<std::string>& zNames,
                     std::vector<std::string>& xNames, std::vector<std::string>& calculatedVarNames) {
  zNames.clear();
  xNames.clear();
  calculatedVarNames.clear();

  for (unsigned int i = 0; i < variables.size(); ++i) {
    auto& currentVariable = variables[i];
    const typeVar_t type = currentVariable->getType();
    const string name = currentVariable->getName();
    const bool isState = currentVariable->isState();
    int index = -1;

    if (currentVariable->isAlias())  // no alias in names vector
      continue;

    const auto nativeVariable = boost::dynamic_pointer_cast<VariableNative>(currentVariable);
    if (!isState) {
      index = static_cast<int>(calculatedVarNames.size());
      calculatedVarNames.push_back(name);
      nativeVariable->setIndex(index);
    } else {
      switch (type) {
        case CONTINUOUS:
        case FLOW: {
          index = static_cast<int>(xNames.size());
          xNames.push_back(name);
          break;
        }
        case DISCRETE:
        case BOOLEAN:
        case INTEGER: {
          index = static_cast<int>(zNames.size());
          zNames.push_back(name);
          break;
        }
        case UNDEFINED_TYPE:
        {
          throw DYNError(Error::MODELER, ModelFuncError, "Unsupported variable type");
        }
      }
      nativeVariable->setIndex(index);
    }
  }
}

}  // namespace DYN
