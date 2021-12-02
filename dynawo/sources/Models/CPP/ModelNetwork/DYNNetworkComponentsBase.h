//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain simulation tool for power systems.
//

#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTSBASE_H_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTSBASE_H_

#include "DYNEnumUtils.h"
#include "DYNNetworkComponent.h"
#include "DYNSparseMatrix.h"

#include <boost/shared_ptr.hpp>
#include <tuple>
#include <type_traits>
#include <unordered_map>
#include <vector>

namespace DYN {

template<class... Models>
class NetworkComponentsBase {
 public:
  // TODO(lecourtoisflo) remove this mechanism when c++17 is available and use std::get<T> instead to Index
  template<class T, class Tuple>
  struct Index;

  template<class T, class... Types>
  struct Index<T, std::tuple<T, Types...> > {
    static constexpr std::size_t value = 0;
  };

  template<class T, class U, class... Types>
  struct Index<T, std::tuple<U, Types...> > {
    static constexpr std::size_t value = 1 + Index<T, std::tuple<Types...> >::value;
  };
  template<class T>
  using IndexTuple = Index<T, std::tuple<Models...> >;
  //
  using StateChangeZ = std::pair<bool, bool>;  // first for topo change, second for state change

 public:
  template<class T>
  void addModel(const boost::shared_ptr<T>& model) {
    static_assert(IndexTuple<T>::value < size, "NetworkComponentsBase::addModel: incorrect size");
    std::get<IndexTuple<T>::value>(components_).push_back(model);
  }

  void evalF(propertyF_t type) {
    evalFImpl(type);
  }

  void evalG(double t) {
    evalGImpl(t);
  }

  StateChangeZ evalZ(double t) {
    StateChangeZ change(false, false);  // no change by default
    evalZImpl(t, change);
    return change;
  }

  StateChangeZ evalState(double t) {
    StateChangeZ change(false, false);  // no change by default
    evalStateImpl(t, change);
    return change;
  }

  void addBusNeighbors() {
    addBusNeighborsImpl();
  }

  void evalCalculatedVars() {
    evalCalculatedVarsImpl();
  }

  void evalJt(SparseMatrix& jt, double cj, int rowOffset) {
    evalJtImpl(jt, cj, rowOffset);
  }

  void evalDerivatives(double cj) {
    evalDerivativesImpl(cj);
  }

  void evalJtPrim(SparseMatrix& jt, int rowOffset) {
    evalJtPrimImpl(jt, rowOffset);
  }

  void evalDerivativesPrim() {
    evalDerivativesPrimImpl();
  }

  void evalNodeInjection() {
    evalNodeInjectionImpl();
  }

  void initSizes(unsigned int& sizeY, unsigned int& sizeF, unsigned int& sizeZ, unsigned int& sizeG, unsigned int& sizeMode, unsigned int& sizeCalculatedVar,
                 std::vector<unsigned int>& componentIndexByCalculatedVar, unsigned int& index) {
    initSizesImpl(sizeY, sizeF, sizeZ, sizeG, sizeMode, sizeCalculatedVar, componentIndexByCalculatedVar, index);
  }

  void setReferenceY(double* y, double* yp, double* f, int offsetY, int& offsetF) {
    setReferenceYImpl(y, yp, f, offsetY, offsetF);
  }
  void setReferenceZ(double* z, bool* zConnected, int& offsetZ) {
    setReferenceZImpl(z, zConnected, offsetZ);
  }
  void setReferenceG(state_g* g, int& offsetG) {
    setReferenceGImpl(g, offsetG);
  }
  void setReferenceCalculatedVar(double* calculatedVars, int& offsetCalculatedVar) {
    setReferenceCalculatedVarImpl(calculatedVars, offsetCalculatedVar);
  }

  boost::shared_ptr<NetworkComponent> getComponentByIndex(unsigned int index) const {
    unsigned int currentIndex = 0;
    return getComponentByIndexImpl(index, currentIndex);
  }

  void clear() {
    clearImpl();
  }

 public:
  static constexpr std::size_t size = std::tuple_size<std::tuple<Models...> >::value;

 private:
  template<class T>
  using ModelVector = std::vector<boost::shared_ptr<T> >;
  using Tuple = typename std::tuple<ModelVector<Models>...>;

 private:
  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalFImpl(propertyF_t type);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalFImpl(propertyF_t type);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalGImpl(double t);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalGImpl(double t);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalZImpl(double t, StateChangeZ& change);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalZImpl(double t, StateChangeZ& change);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalStateImpl(double t, StateChangeZ& change);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalStateImpl(double t, StateChangeZ& change);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type addBusNeighborsImpl();
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type addBusNeighborsImpl();

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalCalculatedVarsImpl();
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalCalculatedVarsImpl();

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalJtImpl(SparseMatrix& jt, double cj, int rowOffset);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalJtImpl(SparseMatrix& jt, double cj, int rowOffset);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalDerivativesImpl(double cj);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalDerivativesImpl(double cj);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalJtPrimImpl(SparseMatrix& jt, int rowOffset);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalJtPrimImpl(SparseMatrix& jt, int rowOffset);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalDerivativesPrimImpl();
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalDerivativesPrimImpl();

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type evalNodeInjectionImpl();
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type evalNodeInjectionImpl();

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type initSizesImpl(unsigned int& sizeY, unsigned int& sizeF, unsigned int& sizeZ, unsigned int& sizeG,
                                                                        unsigned int& sizeMode, unsigned int& sizeCalculatedVar,
                                                                        std::vector<unsigned int>& componentIndexByCalculatedVar, unsigned int& index);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type initSizesImpl(unsigned int& sizeY, unsigned int& sizeF, unsigned int& sizeZ, unsigned int& sizeG,
                                                                       unsigned int& sizeMode, unsigned int& sizeCalculatedVar,
                                                                       std::vector<unsigned int>& componentIndexByCalculatedVar, unsigned int& index);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), boost::shared_ptr<NetworkComponent> >::type getComponentByIndexImpl(unsigned int index,
                                                                                                                  unsigned int& currentIndex) const;
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), boost::shared_ptr<NetworkComponent> >::type getComponentByIndexImpl(unsigned int index,
                                                                                                                 unsigned int& currentIndex) const;


  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type setReferenceYImpl(double* y, double* yp, double* f, int& offsetY, int& offsetF);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type setReferenceYImpl(double* y, double* yp, double* f, int& offsetY, int& offsetF);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type setReferenceZImpl(double* z, bool* zConnected, int& offsetZ);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type setReferenceZImpl(double* z, bool* zConnected, int& offsetZ);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type setReferenceGImpl(state_g* g, int& offsetG);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type setReferenceGImpl(state_g* g, int& offsetG);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type setReferenceCalculatedVarImpl(double* calculatedVars, int& offsetCalculatedVar);
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type setReferenceCalculatedVarImpl(double* calculatedVars, int& offsetCalculatedVar);

  template<std::size_t I = 0>
  inline typename std::enable_if<(I == size), void>::type clearImpl();
  template<std::size_t I = 0>
  inline typename std::enable_if<(I < size), void>::type clearImpl();

 private:
  Tuple components_;
};
}  // namespace DYN

#include "DYNNetworkComponentsBase.hpp"

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTSBASE_H_
