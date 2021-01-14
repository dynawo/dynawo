//
// Copyright (c) 2021, RTE (http://www.rte-france.com)
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
 * @file  DYNIoDico.cpp
 *
 * @brief IoDico class implementation
 *
 */
#include <stdlib.h>
#include <sstream>
#include <fstream>
#include <boost/algorithm/string/trim.hpp>

#include "DYNIoDico.h"
#include "DYNMacrosMessage.h"
using std::string;
using std::ifstream;
using boost::shared_ptr;
using std::stringstream;
using std::vector;


namespace DYN {

static bool readLine(string& line, string& key, string& phrase);

IoDico::IoDico(const string& name) :
name_(name) {
}

void IoDico::readFile(const string& file) {
  // Open file
  ifstream in(file.c_str());

  // Try to read it
  if (in.bad()) {
    throw MessageError("Error when opening file : " + file);
  }

  string line;
  bool ok = true;
  string key;
  string phrase;
  if (in.is_open()) {
    while (getline(in, line) && ok) {
      ok = readLine(line, key, phrase);
      if (ok) {
        if (!key.empty()) {
          if (map_.find(key) != map_.end()) {
            throw MessageError(" Reading of the dictionary " + file + " the key '" + key + "' is not unique");
          }
          map_[key] = phrase;
        }
      } else {
        throw MessageError("Error happened when reading the dictionary " + file);
      }
    }
    in.close();
  }
}

string IoDico::msg(const string& msgId) {
  string phrase = "";

  if (map_.find(msgId) != map_.end()) {
    phrase = map_[msgId];
  } else {
    throw MessageError("there is no key '" + msgId + "' in the dictionary");
  }
  return phrase;
}

std::map<string, string>::const_iterator IoDico::begin() const {
  return map_.begin();
}

std::map<string, string>::const_iterator IoDico::end() const {
  return map_.end();
}

/**
 * @brief reads a line in the dictionarry and tries to find the key and the
 * message description (separator used is @b = )
 *
 *
 * @param line  line to read
 * @param key   return key is succeeded to read a key  "" otherwise
 * @param value return value is succeded to read a description, "" otherwise
 *
 * @return @b true is succeeded to read, @b false otherwise
 */
bool
readLine(string& line, string& key, string& value) {
  key = "";
  value = "";
  // 1) erase any comment
  size_t found = line.find("//");
  string line1 = line.substr(0, found);

  boost::algorithm::trim(line1);
  if (line1.empty())  // line empty : it was a comment line
    return true;  // it's not an error

  // 2) cut the line in two parts : key and value with separator =
  found = line1.find("=");
  if (found != string::npos) {
    key = line1.substr(0, found);
    value = line1.substr(found + 1);
  } else {
    return false;
  }

  // erase all blanks at the beginning and at the end of the key
  boost::algorithm::trim(key);

  // same for value
  boost::algorithm::trim(value);

  return true;
}

}  // namespace DYN
