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

#include "DYNGraph.h"

using std::string;
using std::vector;
using std::pair;
using std::map;
using std::unordered_map;
using std::set;
using std::unordered_set;

namespace DYN {

bool
Graph::pathExist(int nodeId1, int nodeId2, const unordered_map<string, pair<int, int>> & edges) {
  checkVertex(nodeId1);
  checkVertex(nodeId2);

  if (nodeId1 == nodeId2)
    return true;

  unordered_map<int, unordered_set<int>> neighbors = buildNeighboringMap(edges);

  unordered_set <int> toTreat, treated;
  toTreat.insert(nodeId1);

  while (!toTreat.empty()) {
    int nodeId = *toTreat.begin();
    toTreat.erase(nodeId);
    treated.insert(nodeId);

    for (int neighborId : neighbors[nodeId]) {
      if (treated.find(neighborId) != treated.end())
        continue;
      if (neighborId == nodeId2)
        return true;
      toTreat.insert(neighborId);
    }
  }
  return false;
}

vector<string>
Graph::shortestPath(int nodeIdStart, int nodeIdEnd, const unordered_map<string, pair<int, int>> & edges) {
  // ToDo
  return vector<string>();
}

int
Graph::calculateComponents(const unordered_map<string, pair<int, int>> & edges, map<int, int> & result) {
  unordered_map<int, unordered_set<int>> neighbors = buildNeighboringMap(edges);

  set<int> toTreatGlobal;
  for (int nodeId : vertices_)
    toTreatGlobal.insert(nodeId);

  int compId = 0;
  while (!toTreatGlobal.empty()) {
    unordered_set<int> toTreatLocal;
    int seedId = *toTreatGlobal.begin();
    toTreatLocal.insert(seedId);
    toTreatGlobal.erase(seedId);
    while (!toTreatLocal.empty()) {
      int nodeId = *toTreatLocal.begin();
      toTreatLocal.erase(nodeId);
      for (int neighborId : neighbors[nodeId]) {
        auto it = toTreatGlobal.find(neighborId);
        if (it == toTreatGlobal.end())
          continue;
        toTreatLocal.insert(*it);
        toTreatGlobal.erase(it);
      }
      result[nodeId] = compId;
    }
    ++compId;
  }

  return compId;
}

unordered_map<int, unordered_set<int>>
Graph::buildNeighboringMap(const unordered_map<string, pair<int, int>> & edges) {
  unordered_map<int, unordered_set<int>> neighbors;
  for (auto it : edges) {
    int nodeId1 = it.second.first, nodeId2 = it.second.second;
    checkVertex(nodeId1);
    checkVertex(nodeId2);
    neighbors[nodeId1].insert(nodeId2);
    neighbors[nodeId2].insert(nodeId1);
  }
  return neighbors;
}

}  // namespace DYN
