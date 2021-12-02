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

#ifndef MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTSBASE_HPP_
#define MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTSBASE_HPP_

#include "DYNNetworkComponent.h"

namespace DYN {

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalFImpl(propertyF_t) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalFImpl(propertyF_t type) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->evalF(type);
  }
  evalFImpl<I + 1>(type);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalGImpl(double) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalGImpl(double t) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->evalG(t);
  }
  evalGImpl<I + 1>(t);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalZImpl(double, StateChangeZ&) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalZImpl(double t, StateChangeZ& change) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    auto evalZState = model->evalZ(t);
    switch (evalZState) {
    case NetworkComponent::TOPO_CHANGE:
      change.first = true;
      break;
    case NetworkComponent::STATE_CHANGE:
      change.second = true;
      break;
    case NetworkComponent::NO_CHANGE:
      break;
    }
  }
  evalZImpl<I + 1>(t, change);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalStateImpl(double, StateChangeZ&) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalStateImpl(double t, StateChangeZ& change) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    auto evalZState = model->evalState(t);
    switch (evalZState) {
    case NetworkComponent::TOPO_CHANGE:
      change.first = true;
      break;
    case NetworkComponent::STATE_CHANGE:
      change.second = true;
      break;
    case NetworkComponent::NO_CHANGE:
      break;
    }
  }
  evalStateImpl<I + 1>(t, change);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::addBusNeighborsImpl() {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::addBusNeighborsImpl() {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->addBusNeighbors();
  }
  addBusNeighborsImpl<I + 1>();
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalCalculatedVarsImpl() {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalCalculatedVarsImpl() {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->evalCalculatedVars();
  }
  evalCalculatedVarsImpl<I + 1>();
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalJtImpl(SparseMatrix&, double, int) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalJtImpl(SparseMatrix& jt, double cj, int rowOffset) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->evalJt(jt, cj, rowOffset);
  }
  evalJtImpl<I + 1>(jt, cj, rowOffset);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalDerivativesImpl(double) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalDerivativesImpl(double cj) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->evalDerivatives(cj);
  }
  evalDerivativesImpl<I + 1>(cj);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalJtPrimImpl(SparseMatrix&, int) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalJtPrimImpl(SparseMatrix& jt, int rowOffset) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->evalJtPrim(jt, rowOffset);
  }
  evalJtPrimImpl<I + 1>(jt, rowOffset);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalDerivativesPrimImpl() {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalDerivativesPrimImpl() {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->evalDerivativesPrim();
  }
  evalDerivativesPrimImpl<I + 1>();
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalNodeInjectionImpl() {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::evalNodeInjectionImpl() {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->evalNodeInjection();
  }
  evalNodeInjectionImpl<I + 1>();
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::initSizesImpl(unsigned int&, unsigned int&, unsigned int&, unsigned int&, unsigned int&, unsigned int&,
                                                std::vector<unsigned int>&, unsigned int&) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::initSizesImpl(unsigned int& sizeY, unsigned int& sizeF, unsigned int& sizeZ, unsigned int& sizeG, unsigned int& sizeMode,
                                                unsigned int& sizeCalculatedVar, std::vector<unsigned int>& componentIndexByCalculatedVar,
                                                unsigned int& index) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    model->initSize();
    sizeY += model->sizeY();
    sizeF += model->sizeF();
    sizeZ += model->sizeZ();
    sizeG += model->sizeG();
    sizeMode += model->sizeMode();
    model->setOffsetCalculatedVar(sizeCalculatedVar);
    sizeCalculatedVar += model->sizeCalculatedVar();
    componentIndexByCalculatedVar.resize(sizeCalculatedVar, index);
    ++index;
  }
  initSizesImpl<I + 1>(sizeY, sizeF, sizeZ, sizeG, sizeMode, sizeCalculatedVar, componentIndexByCalculatedVar, index);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), boost::shared_ptr<NetworkComponent> >::type
NetworkComponentsBase<Models...>::getComponentByIndexImpl(unsigned int, unsigned int&) const {
  return nullptr;
}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), boost::shared_ptr<NetworkComponent> >::type
NetworkComponentsBase<Models...>::getComponentByIndexImpl(unsigned int index, unsigned int& currentIndex) const {
  const auto& models = std::get<I>(components_);
  for (const auto& model : models) {
    if (currentIndex == index) {
      return boost::dynamic_pointer_cast<NetworkComponent>(model);
    }
    ++currentIndex;
  }

  return getComponentByIndexImpl<I + 1>(index, currentIndex);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::setReferenceYImpl(double*, double*, double*, int&, int&) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::setReferenceYImpl(double* y, double* yp, double* f, int& offsetY, int& offsetF) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    if (model->sizeY() > 0) {
      model->setReferenceY(y, yp, f, offsetY, offsetF);
      offsetY += model->sizeY();
      offsetF += model->sizeF();
    }
  }
  setReferenceYImpl<I + 1>(y, yp, f, offsetY, offsetF);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::setReferenceZImpl(double*, bool*, int&) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::setReferenceZImpl(double* z, bool* zConnected, int& offsetZ) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    if (model->sizeZ() > 0) {
      model->setReferenceZ(z, zConnected, offsetZ);
      offsetZ += model->sizeZ();
    }
  }
  setReferenceZImpl<I + 1>(z, zConnected, offsetZ);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::setReferenceGImpl(state_g*, int&) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::setReferenceGImpl(state_g* g, int& offsetG) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    if (model->sizeG() > 0) {
      model->setReferenceG(g, offsetG);
      offsetG += model->sizeG();
    }
  }
  setReferenceGImpl<I + 1>(g, offsetG);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::setReferenceCalculatedVarImpl(double*, int&) {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::setReferenceCalculatedVarImpl(double* calculatedVars, int& offsetCalculatedVar) {
  auto& models = std::get<I>(components_);
  for (auto& model : models) {
    if (model->sizeCalculatedVar() > 0) {
      model->setReferenceCalculatedVar(calculatedVars, offsetCalculatedVar);
      offsetCalculatedVar += model->sizeCalculatedVar();
    }
  }
  setReferenceCalculatedVarImpl<I + 1>(calculatedVars, offsetCalculatedVar);
}

template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I == NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::clearImpl() {}
template<class... Models>
template<std::size_t I>
inline typename std::enable_if<(I < NetworkComponentsBase<Models...>::size), void>::type
NetworkComponentsBase<Models...>::clearImpl() {
  std::get<I>(components_).clear();
  clearImpl<I + 1>();
}

}  // namespace DYN

#endif  // MODELS_CPP_MODELNETWORK_DYNNETWORKCOMPONENTSBASE_HPP_
