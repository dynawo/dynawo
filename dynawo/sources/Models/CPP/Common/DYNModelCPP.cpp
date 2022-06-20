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

using std::string;
using std::stringstream;
using std::map;
using std::vector;

namespace DYN {

ModelCPP::ModelCPP() {
}

ModelCPP::ModelCPP(std::string modelType) :
modelType_(modelType),
isStartingFromDump_(false) {
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
  string cSum = getCheckSum();

  vector<double> y(yLocal_, yLocal_ + sizeY());
  vector<double> yp(ypLocal_, ypLocal_ + sizeY());
  vector<double> z(zLocal_, zLocal_ + sizeZ());
  vector<double> g(gLocal_, gLocal_ + sizeG());

  os << cSum;
  os << y;
  os << yp;
  os << z;
  os << g;

  mapVariables[ variablesFileName() ] = values.str();
}

void
ModelCPP::loadVariables(const string& variables) {
  stringstream values(variables);
  boost::archive::binary_iarchive is(values);

  string cSum = getCheckSum();
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

  // loading values
  std::copy(yValues.begin(), yValues.end(), yLocal_);
  std::copy(ypValues.begin(), ypValues.end(), ypLocal_);
  std::copy(zValues.begin(), zValues.end(), zLocal_);
  std::copy(gValues.begin(), gValues.end(), gLocal_);
  // notify we used dumped values
  isStartingFromDump_ = true;
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

}  // namespace DYN
