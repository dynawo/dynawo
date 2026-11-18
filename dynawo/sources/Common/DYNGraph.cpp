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
#include "DYNMacrosMessage.h"
#include <set>

using std::string;
using std::vector;
using std::map;
using std::pair;
using std::set;
using std::unordered_set;
using std::unordered_map;

namespace DYN {

static const int INVALID = -1;
static const int NOT_SET = -2;

inline int
dualId(int nodeId1, int nodeId2) {
  if (nodeId1 < nodeId2)
    return (nodeId1 << 16) + nodeId2;
  else
    return (nodeId2 << 16) + nodeId1;
}

void
Graph::addVertex(int nodeId) {
  if ((nodeId < 0) || (nodeId > 65535))
    throw DYNError(DYN::Error::GENERAL, InvalidVertexId, nodeId);
  vertices_.insert(nodeId);
  nodeIdMax_ = std::max(nodeIdMax_, nodeId);
}

void
Graph::addEdge(int nodeId1, int nodeId2, const string & name) {
  checkNodes(nodeId1, nodeId2);
  if (edgesNames_.find(name) != edgesNames_.end())
    throw DYNError(DYN::Error::GENERAL, AlreadyDefinedEdge, name);

  edgesNames_.insert(name);
  edgesByNodes_.insert({dualId(nodeId1, nodeId2), name});
  neighbors_[nodeId1].push_back(nodeId2);
  neighbors_[nodeId2].push_back(nodeId1);
}

bool
Graph::pathExist(int nodeId1, int nodeId2, const unordered_set<string> & closedEdges) {
  checkNodes(nodeId1, nodeId2);

  if (nodeId1 == nodeId2)
    return true;

  bool filteredEdges = !closedEdges.empty();
  vector<bool> tagged(nodeIdMax_+1, false);
  vector<int> toTreat;
  toTreat.reserve(nodeIdMax_/2);
  toTreat.push_back(nodeId1);
  tagged[nodeId1] = true;

  while (!toTreat.empty()) {
    int nodeId = toTreat.back();
    toTreat.pop_back();
    for (int neighborId : neighbors_.at(nodeId)) {
      if (tagged[neighborId])
        continue;
      if (filteredEdges && (closedEdges.find(edgesByNodes_.at(dualId(nodeId, neighborId))) == closedEdges.end()))
        continue;
      if (neighborId == nodeId2)
        return true;
      toTreat.push_back(neighborId);
      tagged[neighborId] = true;
    }
  }

  return false;
}

vector<string>
Graph::shortestPath(int nodeIdStart, int nodeIdEnd, const unordered_set<string> & closedEdges) {
  checkNodes(nodeIdStart, nodeIdEnd);

  if (nodeIdStart == nodeIdEnd)
    return vector<string>();

  bool filteredEdges = !closedEdges.empty();
  vector<int> predecessors(nodeIdMax_+1, NOT_SET);
  predecessors[nodeIdStart] = nodeIdStart;

  vector<int> nodesCurr;
  vector<int> nodesNextRank;
  nodesNextRank.push_back(nodeIdStart);

  // Dijsktra algorithm specialized for the case where all weights are 1 : progress rank by rank, tag once
  while (!nodesNextRank.empty()) {
    nodesCurr.swap(nodesNextRank);
    while (!nodesCurr.empty()) {
      int nodeId = nodesCurr.back();
      nodesCurr.pop_back();
      for (int neighborId : neighbors_.at(nodeId)) {
        if (predecessors[neighborId] != NOT_SET)
          continue;
        if (filteredEdges && (closedEdges.find(edgesByNodes_.at(dualId(nodeId, neighborId))) == closedEdges.end()))
          continue;
        predecessors[neighborId] = nodeId;
        if (neighborId == nodeIdEnd)
          return buildStringPath(nodeIdEnd, predecessors);
        nodesNextRank.push_back(neighborId);
      }
    }
  }

  return vector<string>();
}

vector<string>
Graph::buildStringPath(int nodeIdEnd, const vector<int> & predecessors) const {
  vector<string> reversePath;
  int nodeId = nodeIdEnd;
  int prevId = predecessors.at(nodeId);
  while (prevId != nodeId) {
    reversePath.push_back(edgesByNodes_.at(dualId(nodeId, prevId)));
    nodeId = prevId;
    prevId = predecessors.at(nodeId);
  }

  int nbSteps = reversePath.size();
  vector<string> toReturn(nbSteps);
  for (int i = 0; i< nbSteps; ++i)
    toReturn[i] = reversePath[nbSteps-i-1];

  return toReturn;
}

vector<int>
Graph::calculateComponents(const unordered_set<string> & closedEdges) {
  checkNeighbors();

  vector<int> mapping(nodeIdMax_+1, NOT_SET);
  for (int nodeId : missingNodes_)
    mapping[nodeId] = INVALID;

  int compId = 0;
  int nodeIdGlobal = 0;

  while (nodeIdGlobal <= nodeIdMax_) {
    if (mapping[nodeIdGlobal] == NOT_SET) {
      mapping[nodeIdGlobal] = compId;
      vector<int> toTreat(1, nodeIdGlobal);
      while (!toTreat.empty()) {
        int nodeId = toTreat.back();
        toTreat.pop_back();
        for (int neighborId : neighbors_.at(nodeId)) {
          if (mapping[neighborId] != NOT_SET)
            continue;
          if (closedEdges.find(edgesByNodes_.at(dualId(nodeId, neighborId))) == closedEdges.end())
            continue;
          toTreat.push_back(neighborId);
          mapping[neighborId] = compId;
        }
      }
      ++compId;
    }
    ++nodeIdGlobal;
  }

  mapping.push_back(compId);
  return mapping;
}

void
Graph::checkVertex(int nodeId) const {
  if (vertices_.find(nodeId) == vertices_.end())
    throw DYNError(DYN::Error::GENERAL, UnknownVertex, nodeId);
}

void
Graph::checkNeighbors() {
  if (!neighbors_.empty())
    return;

  neighbors_.resize(nodeIdMax_+1);

  for (int i=0; i < nodeIdMax_; ++i)
    if (vertices_.find(i) == vertices_.end())
      missingNodes_.insert(i);
}

void
Graph::checkNodes(int nodeId1, int nodeId2) {
  checkVertex(nodeId1);
  checkVertex(nodeId2);
  checkNeighbors();
}

}  // namespace DYN
