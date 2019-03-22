//
// Copyright (c) 2016-2019, RTE (http://www.rte-france.com)
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Libiidm, a library to model IIDM networks and allows
// importing and exporting them to files.
//


#include <iostream>
#include <string>

#include <IIDM/builders.h>
#include <IIDM/Network.h>

#include <IIDM/Extension.h>
#include <IIDM/cpp11.h>

class SampleExtension : public IIDM::Extension {
public:
  BOOST_TYPE_INDEX_REGISTER_CLASS

  explicit SampleExtension(int value): m_value(value) {}

  int value() const { return m_value; }
  SampleExtension& value(int v) { m_value = v; return *this; }

private:
  int m_value;

public:
  IIDM_UNIQUE_PTR<SampleExtension> clone() const { return IIDM_UNIQUE_PTR<SampleExtension>(do_clone()); }

protected:
  virtual SampleExtension* do_clone() const IIDM_OVERRIDE {return new SampleExtension(*this);}
};

using std::cout;
using std::endl;

using namespace IIDM;
using namespace IIDM::builders;



int main() {
//creating the network

  cout << "creating network with external component extensions..." << endl;
  Network network = NetworkBuilder().sourceFormat("handcrafted").caseDate("today").forecastDistance(0).build("network");

  std::vector<id_type> ids;
  ids.push_back("EXT 1");
  ids.push_back("EXT 2");
  ids.push_back("EXT 3");
  ids.push_back("EXT 4");
  ids.push_back("EXT 5");
  ids.push_back("EXT 1");//volontairement pas 6
  ids.push_back("EXT 7");

  network.add_externalComponent("EXT 8");

  // inspired from xml..IIDMDocumentHandler.cpp

  for (std::vector<id_type>::size_type i = 0; i < ids.size(); ++i) {
    id_type const& id = ids[i];
    Identifiable * identifiable = network.searchById(id);
    if (!identifiable) {
      identifiable = & network.add_externalComponent(id);
    }
    identifiable->setExtension(SampleExtension(i+1));
  }

  for (Network::identifiable_iterator it = network.identifiable_begin(); it != network.identifiable_end(); ++it) {
    cout << "component: " << it->id();
    if ( it->has_extension<SampleExtension>() ) {
      cout << "\textension:" << it->getExtension<SampleExtension>().value();
    }
    cout << endl;
  }

  cout << "done." << endl;
  return 0;
}
