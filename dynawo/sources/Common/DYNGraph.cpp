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
Graph::pathExist(int nodeId1, int nodeId2, const unordered_map<pair<int, int>, string> & edges) {
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
Graph::shortestPath(int nodeIdStart, int nodeIdEnd, const unordered_map<pair<int, int>, string> & edges) {
  checkVertex(nodeId1);
  checkVertex(nodeId2);

  if (nodeId1 == nodeId2)
    return vector<string>();

  unordered_map<int, unordered_set<int>> neighbors = buildNeighboringMap(edges);

  static const int NOT_SET = std::numeric_limits<int>::min();
  unordered_map<int, int> predecessors;
  for (int nodeId : vertices_)
    predecessors[nodeId] = NOT_SET;

  unordered_set<int> nodesCurr;
  unordered_set<int> nodesNextRank;

  nodesNextRank.insert(nodeIdStart);
  predecessors[nodeIdStart] = nodeIdStart;

  // Dijsktra algorithm specialized for the case where all weights are 1 : progress rank by rank, tag once
  while (!nodesNextRank.empty()) {
    nodesCurr.swap(nodesNextRank);
    while (!nodesCurr.empty()) {
      int nodeId = *nodesCurr.begin();
      nodesCurr.erase(nodeId);
      for (int neighborId : neighbors[nodeId]) {
        if (predecessors[neighborId] != NOT_SET)
          continue;
        predecessors[neighborId] = nodeId;
        if (neighborId == nodeIdEnd)
          return buildStringPath(nodeIdEnd, predecessors, edges);
      }
    }
  }
  return vector<string>();
}

vector<string>
Graph::buildStringPath(int nodeIdEnd, const unordered_map<int, int> & predecessors, const unordered_map<pair<int, int>, string> & edges) {
  vector<string> toReturn;
  int nodeId = nodeIdEnd;
  while (predecessors[nodeId] != nodeId) {
    toReturn.push_front((edges.find(pair<nodeId, predecessors[nodeId]) == edges.end()) ? edges[pair<int, int>(predecessors[nodeId], nodeId)]
                                                                                       : edges[pair<int, int>(nodeId, predecessors[nodeId])]);
    nodeId = predecessors[nodeId];
  }
  return toReturn;
}

int
Graph::calculateComponents(const unordered_map<pair<int, int>, string> & edges, map<int, int> & result) {
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
Graph::buildNeighboringMap(const unordered_map<pair<int, int>, string> & edges) {
  unordered_map<int, unordered_set<int>> neighbors;
  for (auto it : edges) {
    int nodeId1 = it.first.first, nodeId2 = it.first.second;
    checkVertex(nodeId1);
    checkVertex(nodeId2);
    neighbors[nodeId1].insert(nodeId2);
    neighbors[nodeId2].insert(nodeId1);
  }
  return neighbors;
}

}  // namespace DYN
