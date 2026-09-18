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

inline int
Graph::dualId(int nodeId1, int nodeId2) {
  if (nodeId1 < nodeId2)
    return (nodeId1 << 16) + nodeId2;
  else
    return (nodeId2 << 16) + nodeId1;
}

void
Graph::addEdge(int nodeId1, int nodeId2, const std::string & name) {
  checkVertex(nodeId1);
  checkVertex(nodeId2);
  if (edges_.find(name) != edges_.end())
    throw DYNError(DYN::Error::GENERAL, AlreadyDefinedEdge, name);

  edges_.insert({name, {nodeId1, nodeId2}});
  edgesNames_.insert({dualId(nodeId1, nodeId2), name});
}

unordered_set<string>
Graph::getAllEdges() {
  unordered_set<string> toReturn;
  for (auto it : edges_)
    toReturn.insert(it.first);
  return toReturn;
}

bool
Graph::pathExist(int nodeId1, int nodeId2, const unordered_set<string> & closedEdges) {
  checkVertex(nodeId1);
  checkVertex(nodeId2);

  if (nodeId1 == nodeId2)
    return true;

  unordered_map<int, unordered_set<int>> neighbors = buildNeighboringMap(closedEdges);

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
Graph::shortestPath(int nodeIdStart, int nodeIdEnd, const unordered_set<string> & closedEdges) {
  checkVertex(nodeIdStart);
  checkVertex(nodeIdEnd);

  if (nodeIdStart == nodeIdEnd)
    return vector<string>();

  unordered_map<int, unordered_set<int>> neighbors = buildNeighboringMap(closedEdges);

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
          return buildStringPath(nodeIdEnd, predecessors);
        nodesNextRank.insert(neighborId);
      }
    }
  }
  return vector<string>();
}

vector<string>
Graph::buildStringPath(int nodeIdEnd, const unordered_map<int, int> & predecessors) {
  vector<string> reversePath;
  int nodeId = nodeIdEnd;
  while (predecessors.at(nodeId) != nodeId) {
    reversePath.push_back(edgesNames_[dualId(nodeId, predecessors.at(nodeId))]);
    nodeId = predecessors.at(nodeId);
  }

  int nbSteps = reversePath.size();
  vector<string> toReturn(nbSteps);
  for (int i = 0; i< nbSteps; ++i)
    toReturn[i] = reversePath[nbSteps-i-1];
  return toReturn;
}

int
Graph::calculateComponents(const unordered_set<string> & closedEdges, map<int, int> & result) {
  unordered_map<int, unordered_set<int>> neighbors = buildNeighboringMap(closedEdges);

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
Graph::buildNeighboringMap(const unordered_set<string> & closedEdges) {
  unordered_map<int, unordered_set<int>> neighbors;
  for (const string & edgeName : closedEdges) {
    if (edges_.find(edgeName) == edges_.end())
      throw DYNError(DYN::Error::GENERAL, UnknownEdge, edgeName);
    int nodeId1 = edges_[edgeName].first;
    int nodeId2 = edges_[edgeName].second;
    neighbors[nodeId1].insert(nodeId2);
    neighbors[nodeId2].insert(nodeId1);
  }
  return neighbors;
}

}  // namespace DYN
